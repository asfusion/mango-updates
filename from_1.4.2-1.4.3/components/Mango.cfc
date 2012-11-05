<cfcomponent name="Mango">

	<cfset variables.blog = "" />
	<cfset variables.version = "1.4.3" />
	<cfset variables.pluginQueue = "" />
	<cfset variables.config = "" />
	<cfset variables.blogId = "default" />
	<cfset variables.preferences = structnew() />
	<cfset variables.settings = structnew() />
	<cfset variables.isAdmin = true />
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="configFile" required="false" type="string" default="" hint="Path to config file"/>
		<cfargument name="id" required="false" default="default" type="string" hint="Blog"/>
		<cfargument name="baseDirectory" required="false" type="string" hint="Path to main blog directory" />			
		
			<cfset var settings = "" />
			<cfset var preferences = createObject("component", "utilities.PreferencesFile")/>
			<cfset var pluginDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "plugins/" />
			<cfset var pluginPath = "plugins." />
			
			<cfset variables.config = arguments.configFile/>
			<cfset variables.blogId = arguments.id />
			<cfset variables.settings["baseDirectory"] = arguments.baseDirectory />
			

			<!--- check for the config file --->
			<cfif fileexists(variables.config)>
				<cfset preferences.init(variables.config)/>
			<cfelse>
				<cfthrow type="MissingConfigFile" errorcode="MissingConfigFile" detail="Configuration file could not be read">
			</cfif>
			
			<cfset settings = preferences.exportSubtreeAsStruct("") />
		
			<cfif settings.generalSettings.system.enableThreads EQ "1">
				<cfset variables.pluginQueue = createObject("component","PluginQueueThreaded")/>
			<cfelse>
				<cfset variables.pluginQueue = createObject("component","PluginQueue")/>
			</cfif>

	 	<cfscript>
		 	if (len(settings[variables.blogId].plugins.directory)){
				pluginDir = replaceDirectoryPlaceHolders(settings[variables.blogId].plugins.directory);
				pluginPath = settings[variables.blogId].plugins.path;
			}
			//replace the {baseDirectory} variable
		 	settings[variables.blogId].blogSettings.admin.customPanels.directory = 
		 		replaceDirectoryPlaceHolders(settings[variables.blogId].blogSettings.admin.customPanels.directory);
		 		
		 	settings[variables.blogId].blogSettings.assets.directory = 
		 		replaceDirectoryPlaceHolders(settings[variables.blogId].blogSettings.assets.directory);
		 		
		 	settings[variables.blogId].blogSettings.skinsDirectory = 
		 		replaceDirectoryPlaceHolders(settings[variables.blogId].blogSettings.skinsDirectory);
		 											
		 	variables.objectFactory = createobject("component","ObjectFactory");
		 	variables.settings["mailServer"] = settings.generalSettings.mailServer;
		 	variables.settings["datasource"] = settings.generalSettings.dataSource;
		 	variables.settings["authorization"] = settings[variables.blogId].authorization;
		 	variables.dataAccessFactory = createobject("component","model.dataaccess.DataAccessFactory").init(variables.settings["dataSource"]);		
	 		variables.blogManager = createobject("component","BlogManager").init(this);
			variables.blog = variables.blogManager.getBlog(variables.blogId,settings[variables.blogId].blogSettings);		
			variables.blog.setSetting("pluginsDir", pluginDir);
			variables.blog.setSetting("pluginsPath", pluginPath);
			variables.blog.setSetting("pluginsPrefsPath", "");
			
			variables.postsManager = createobject("component","PostManager").init(this);
			variables.categoriesManager = createobject("component","CategoryManager").init(this);
			variables.rolesManager = createobject("component","RoleManager").init(this,variables.dataAccessFactory,variables.pluginQueue);
			variables.archivesManager = createobject("component","ArchivesManager").init(this,variables.dataAccessFactory);
			variables.authorsManager = createobject("component","AuthorManager").init(this);
			variables.pagesManager = createobject("component","PageManager").init(this);
			variables.commentsManager = createobject("component","CommentManager").init(this,variables.dataAccessFactory,variables.pluginQueue);
			
			variables.logsManager = createobject("component","LogManager").init(this, variables.dataAccessFactory);
			variables.logger = createobject("component","utilities.Logger");
			variables.logger.setLevel(settings[variables.blogId].logging.level);
			//add default handler
			variables.logger.addHandler(variables.logsManager);
			
			//add custom handler, if any
			if (structkeyexists(settings[variables.blogId].logging,"component")) {
				try {
					variables.logger.addHandler(createobject("component",
							settings[variables.blogId].logging.component).init(
								settings[variables.blogId].logging.settings,
								variables.blogId));
				}
				catch (var e) {}
			}
			
			variables.pluginQueue.init(variables.logger);
			
			try {
				variables.searcher = createobject("component",
							settings[variables.blogId].searchSettings.component).init(
								settings[variables.blogId].searchSettings.settings,
								settings[variables.blogId].blogSettings.language,
								variables.blogId);
			}
			catch (var e) {}
			
			
			variables.preferences["plugins"] = createObject("component","SettingManager").init(this, variables.dataAccessFactory);
			
			loadPlugins(pluginDir,pluginPath, variables.isAdmin);
		</cfscript>
		
		
		<cfreturn this />
	</cffunction>

	<!--- this method gets called every time a page is rendered.
	It is used to put variables into scope
	 --->
	<cffunction name="parseVariables" access="private" output="true" returntype="struct">		
		<cfargument name="urlvars" type="struct" required="false" />
		<cfargument name="formvars" type="struct" required="false" />
		
		<cfscript>
			var basePath = variables.blog.getBasePath();
			var returnData = structnew();
			var seoUrl = "";
			var externalData = structnew();
			externalData.raw = arraynew(1);
			if (isDefined("CGI.path_info")) {
				seoUrl = CGI.path_info;
			} 
			/* else {
				seoUrl = CGI.request_uri;
	        } */
 			externalData.raw = listtoarray(seoUrl,"/");
 			
 			
 			/* default request.postContext variable */
 			returnData.postContext = "recent";
 			
 			/* default request.message variable */
 			returnData.message = createObject("component","Message");
 			
 			/* Add url variables */
 			structappend(externalData,arguments.urlVars,true);
 			
 			/* Add form variables */
 			structappend(externalData,arguments.formvars,true);
 			
 			returnData.externalData = externalData;
		</cfscript>
		
		<cfreturn returnData />
	</cffunction>

	<!--- this function handles special requests such as comment posting or form post that requires plugin intervention --->
	<cffunction name="handleRequest" access="public" output="true" returntype="struct">		
		<cfargument name="targetPage" type="String" required="true" />
		<cfargument name="urlvars" type="struct" required="false" />
		<cfargument name="formvars" type="struct" required="false" />
				
		<cfset var results = parseVariables(arguments.urlvars,arguments.formvars)>		
		<cfset var temp = "" />

			<!--- look for action key  --->
			<cfif structkeyexists(results.externaldata,"action") AND results.externaldata.action EQ "addComment">
					<cfset temp = variables.commentsManager.addCommentFromRawData(results.externaldata) />
					<cfset structappend(results.externaldata,temp.data)/>
					<cfset results.message = temp.message />
					<cfset results.newcomment = temp.newcomment />
			</cfif>	
				
			<cfif structkeyexists(results.externaldata,"event")>
				<cfset variables.pluginQueue.broadcastEvent(variables.pluginQueue.createEvent(results.externaldata.event,results))/>
			</cfif>
						
		<cfreturn results />
	</cffunction>


	<cffunction name="getBlog" access="public" output="false" returntype="any">		
		<cfreturn variables.blog />
	</cffunction>
	
	<cffunction name="getBlogsManager" access="public" output="false" returntype="any">		
		<cfreturn variables.blogManager />
	</cffunction>
		
	<cffunction name="getPostsManager" access="public" output="false" returntype="any">		
		<cfreturn variables.postsManager />
	</cffunction>

	<cffunction name="getPagesManager" access="public" output="false" returntype="any">		
		<cfreturn variables.pagesManager />
	</cffunction>

	<cffunction name="getCategoriesManager" access="public" output="false" returntype="any">		
		<cfreturn variables.categoriesManager />
	</cffunction>

	<cffunction name="getCommentsManager" access="public" output="false" returntype="any">		
		<cfreturn variables.commentsManager />
	</cffunction>

	<cffunction name="getArchivesManager" access="public" output="false" returntype="any">		
		<cfreturn variables.archivesManager />
	</cffunction>

	<cffunction name="getAuthorsManager" access="public" output="false" returntype="any">		
		<cfreturn variables.authorsManager />
	</cffunction>
	
	<cffunction name="getRolesManager" access="public" output="false" returntype="any">		
		<cfreturn variables.rolesManager />
	</cffunction>
	
	<cffunction name="getLogsManager" access="public" output="false" returntype="any">		
		<cfreturn variables.logsManager />
	</cffunction>
	
	<cffunction name="getSettingsManager" access="public" output="false" returntype="any">		
		<cfreturn variables.preferences["plugins"] />
	</cffunction>

	<cffunction name="getSearcher" access="public" output="false" returntype="any">		
		<cfreturn variables.searcher />
	</cffunction>

	<cffunction name="getDataAccessFactory" access="package" output="false" returntype="any">		
		<cfreturn variables.dataAccessFactory />
	</cffunction>

	<cffunction name="getObjectFactory" access="public" output="false" returntype="any">		
		<cfreturn variables.objectFactory />
	</cffunction>

	<cffunction name="getPlugin" access="public" output="false" returntype="any">
		<cfargument name="name" type="any" hint="Name of plugin" required="false" />
			
			<cfreturn variables.pluginQueue.getPlugin(arguments.name) />
	</cffunction>

	<cffunction name="getPluginQueue" access="public" output="false" returntype="any">
		<cfreturn variables.pluginQueue />
	
	</cffunction>
	
	<cffunction name="getAdministrator" access="public" output="false" returntype="any">
		<cfreturn createObject("component", "AdminUtil").init(this) />	
	</cffunction>
	
	<cffunction name="getAuthorizer" access="public" output="false" returntype="any">
		<cfreturn createObject("component", "Authorizer").init(this, variables.settings['authorization']) />	
	</cffunction>

	<cffunction name="getUpdater" access="public" output="false" returntype="any">
		<cfreturn createObject("component", "Updater").init(this, variables.config, variables.settings["baseDirectory"]) />	
	</cffunction>

	<cffunction name="getMailer" access="public" output="false" returntype="any">
		<cfreturn createObject("component", "utilities.Mailer").init(argumentCollection=variables.settings["mailServer"]) />	
	</cffunction>
	
	<cffunction name="getLogger" access="public" output="false" returntype="any">
		<cfreturn variables.logger />	
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getQueryInterface" access="public" output="false" returntype="any">
		<cfreturn createObject("component", "utilities.QueryInterface").init(variables.settings["datasource"]) />	
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="reloadConfig" access="public" output="false" returntype="void">
		<cfset var facade = createobject("component", "MangoFacade") />
		<!--- this creates a new mango instance and sets it as the default instance --->
		<cfset facade.setMango(createobject("component", "Mango").init(
				variables.config, variables.blogId, variables.settings["baseDirectory"])) />
		<!--- just so that current request also gets the new config, init this instance too --->
		<cfset init(variables.config, variables.blogId, variables.settings["baseDirectory"]) />
	</cffunction>
		
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="saveSetting" access="public" output="false" returntype="any">		
		<cfargument name="pathName" type="String" required="false" hint="Path to preference node" />
		<cfargument name="key" type="String" required="true" hint="Key with which the specified value is to be associated." />
		<cfargument name="value" type="String" required="true" hint="Value to be associated with the specified key" />
		<cfargument name="reload" type="String" required="false" default="false" hint="Whether to reload Mango or not" />
		
		<cfset var preferences = createObject("component", "utilities.PreferencesFile")/>
		<cfset preferences.init(variables.config) />
		<cfset preferences.put(arguments.pathName, arguments.key, arguments.value) />
		
		<cfif arguments.reload>
			<cfset reloadConfig() />
		</cfif>
	</cffunction>

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="loadPlugins" access="private" output="false" returntype="void">
		<cfargument name="pluginsDir" type="String" required="true" />
		<cfargument name="pluginsPath" type="String" required="false" default="plugins." />
		<cfargument name="isAdmin" required="false" default="false" type="boolean" hint="Whether this Mango instantiation is administration or the blog"/>	
		
		<cfset CreateObject("component", "PluginLoader").loadPlugins(variables.blog.systemPlugins,variables.pluginQueue,
					arguments.pluginsDir & "system/",arguments.pluginsPath & "system." , this, variables.preferences["plugins"]) />
		<cfset CreateObject("component", "PluginLoader").loadPlugins(variables.blog.plugins,variables.pluginQueue,
					arguments.pluginsDir & "user/", arguments.pluginsPath & "user.", this, variables.preferences["plugins"]) />
	
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="loadPlugin" access="public" output="false" returntype="string" hint="returns the name of the plugin if successfully loaded">
		<cfargument name="plugin" type="string" required="true" />
		<cfargument name="type" type="string" required="false" default="user" />

		<cfreturn createObject("component", "PluginLoader").loadPlugins(plugin,variables.pluginQueue,
					variables.blog.getSetting("pluginsDir") & arguments.type & "/",
					variables.blog.getSetting("pluginsPath") & arguments.type & "." , 
					this, variables.preferences["plugins"]) />
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getVersion" access="public" output="false" returntype="string">		
		<cfreturn variables.version />
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="isCurrentUserLoggedIn" output="false" description="Returns whether or not user is logged in" 
				access="public" returntype="boolean">
			
		<cfreturn structkeyexists(session,"user") />
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getCurrentUser" output="false" description="Returns the currently logged in user" 
						access="public" returntype="any">

			<cfif NOT structkeyexists(session,"user")>
				<cfthrow message="User is not logged in" type="NotLoggedIn" detail="NotLoggedIn">
			</cfif>
			
			<cfreturn session.user />
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="setCurrentUser" output="false" description="Sets the currently logged in user" 
						access="public" returntype="void">
		<cfargument name="user" required="true" >
		<cfset session.user = arguments.user />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="removeCurrentUser" output="false" description="Logs user out" 
						access="public" returntype="void">

		<cfset structdelete(session,"user") />

	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="replaceDirectoryPlaceHolders" access="private">
		<cfargument name="data" type="string" />
		
		<cfset arguments.data = replacenocase(arguments.data,"{baseDirectory}",variables.settings["baseDirectory"]) />
		<cfreturn replacenocase(arguments.data,"{componentsDirectory}",getDirectoryFromPath(GetCurrentTemplatePath())) />
	</cffunction>
</cfcomponent>