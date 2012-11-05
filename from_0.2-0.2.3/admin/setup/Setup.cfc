<cfcomponent name="Setup">
	
	<cfset variables.defaults = structnew() />
	<cfset variables.defaults["id"] = "default"/>
	<cfset variables.defaults["charset"] = "ISO-8859-1"/>
	<cfset variables.defaults["tagline"] = "A Mango for you"/>
	<cfset variables.defaults["description"] = "A mango blog (edit your blog description in the administration)"/>
	<cfset variables.defaults["skin"] = "nautica05"/>
	<cfset variables.defaults["categoryName"] = "default"/>
	<cfset variables.defaults["categoryTitle"] = "Default"/>
	<cfset variables.defaults["systemPlugins"] = "CacheUpdater,SearchIndexer,SubscriptionHandler,Links"/>
	<cfset variables.defaults["userPlugins"] = "captcha,formRememberer,colorcoding,linkify"/>
			
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="init" access="package" output="false" returntype="Setup">
		<cfargument name="datasourcename" type="String" required="true" />
		<cfargument name="dbType" type="String" required="true" />
		<cfargument name="prefix" type="String" required="false" default="" />
		<cfargument name="username" type="String" required="false" />
		<cfargument name="password" type="String" required="false" />

			<cfset variables.dsn = arguments.datasourcename  />
			<cfset variables.dbType = arguments.dbType  />
			<cfset variables.prefix = arguments.prefix  />
			<cfset variables.componentPath = replacenocase(GetMetaData(this).name,"admin.setup.Setup","components.") />
		<cfreturn this />
	
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="checkSystem" access="package" output="false" returntype="any">
		<!--- check cffile --->
		<!--- check directory permissions --->
		<!--- check Verity availability --->
	
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="setupDatabase" access="package" output="false" returntype="struct">
			<cfset var setup = "" />
			<cfset var result = structnew() />
			<cfset var prefix = variables.prefix />
			<cfset var dsn = variables.dsn />
			<cfset var dbType = variables.dbType />
			<cfset result.status = true />
			<cfset result.message =  "" />
			
			<cftry>

				<cfinclude template="#dbType#.sql">
			
			<cfcatch type="any">
				<cfset result.status = false />
				<cfset result.message = cfcatch.Message &   " " & cfcatch.Detail />
			</cfcatch>
			</cftry>

		<cfreturn result/>
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="addCFDatasource" access="package" output="false" returntype="struct">
		<cfargument name="cfadminpassword" type="String" required="true" />
		<cfargument name="datasourcename" type="String" required="true" />
		<cfargument name="dbName" type="String" required="true" />
		<cfargument name="host" type="String" required="true" />
		<cfargument name="dbType" type="String" required="true" />
		<cfargument name="username" type="String" required="false" />
		<cfargument name="password" type="String" required="false" />
		
			<cfset var ds = "" />
			<cfset var result = structnew() />
			<cfset var dsn = structnew() />
			<cfset var dsexists = true />
			<cfset result.status = false />
			<cfset result.message =  "" />
			
		<cftry>
				<cfscript>
					 // Login to CF Administrator
					createObject("component","cfide.adminapi.administrator").login(arguments.cfadminpassword);
					 // Instantiate the data source object
					dsObj = createObject("component","cfide.adminapi.datasource");
				</cfscript>
				
		
		
				<cftry>
					<!--- make sure it does not exist --->
					<cfset dsObj.getDatasources(arguments.datasourcename) />
					<!--- if it doesn't throw error, it already exists' --->
					<cfcatch type="any">
						<!--- everything fine --->
						<cfset dsexists = false />
					</cfcatch>
				</cftry>
				<cfif dsexists>
					<cfthrow type="duplicateDatasource" message="Datasource already exists">
				</cfif>
				
				<cfscript>
					dsn = structNew();
					dsn.name= arguments.datasourcename;
					dsn.host = arguments.host;					
					dsn.database = arguments.dbName;
					dsn.username = arguments.username;
					dsn.password = arguments.password;
					
					if (arguments.dbType IS "mssql"){
						//Create it
	   					dsObj.setMSSQL(argumentCollection=dsn);
					}
					else if (arguments.dbType IS "mysql"){
						//Create it
	   					dsObj.setMySQL(argumentCollection=dsn);
					}
					
					//verify it:
					result.status= dsObj.verifyDsn(arguments.datasourcename);
					if (NOT result.status){// roll back changes
						dsObj.deleteDatasource(arguments.datasourcename);
						result.message = "Datasource could not be verified, please check the settings";
					}
				</cfscript>

		<cfcatch type="cfadminapiSecurityError">
			<cfset result.message = "Could not login to CF Administrator" />
		</cfcatch>
		<cfcatch type="duplicateDatasource">
			<cfset result.message = cfcatch.Message />
		</cfcatch>
		<cfcatch type="any">
			<cfset result.message =  cfcatch.Message &   " " & cfcatch.Detail />
		</cfcatch>
		</cftry>
			

		<cfreturn result/>
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="addAuthor" access="package" output="false" returntype="struct">
		<cfargument name="name" type="String" required="false" />
		<cfargument name="username" type="String" required="false" />
		<cfargument name="password" type="String" required="false" />
		<cfargument name="email" type="String" required="false" />

			<cfset var qinsertauthor = "" />
			<cfset var result = structnew() />
			<cfset var admin = ""/>
			<cfset var id = createUUID() />
			<cfset result.status = true />
			<cfset result.message =  "" />
		<cftry>
			<cfif structkeyexists(variables,"blog")>
				<cfset admin = variables.blog.getAdministrator()>
				<cfset admin.newAuthor(arguments.username,arguments.password,arguments.name,arguments.email) />
			<cfelse>
				<cfquery name="qinsertauthor"  datasource="#variables.dsn#">
				INSERT INTO #variables.prefix#author
				(id, username,password,name,email)
				VALUES (
				<cfqueryparam value="#id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35"/>,
				<cfqueryparam value="#arguments.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50"/>,
				<cfqueryparam value="#hash(id & arguments.password,'SHA')#" cfsqltype="CF_SQL_VARCHAR" maxlength="50"/>,
				<cfqueryparam value="#arguments.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="100"/>,
				<cfqueryparam value="#arguments.email#" cfsqltype="CF_SQL_VARCHAR" maxlength="255"/>)

		  </cfquery>
			
			</cfif>
			
			
			<cfcatch type="any">
				<cfset result.status = false />
				<cfset result.message = cfcatch.Message &   " " & cfcatch.Detail />
			</cfcatch>
		</cftry>

		<cfreturn result/>
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="addBlog" access="package" output="false" returntype="struct">
		<cfargument name="title" type="String" required="false" />
		<cfargument name="address" type="String" required="false" />
		
			<cfset var qinsertblog = "" />
			<cfset var result = structnew() />
			<cfset result.status = true />
			<cfset result.message =  "" />
			<!--- add back slash if there isn't' --->
			
			<cfif right(arguments.address,1) NEQ "/">
				<cfset arguments.address = arguments.address & "/">
			</cfif>
			<cftry>
	
			<cfquery name="qinsertblog"  datasource="#variables.dsn#">
				INSERT INTO #variables.prefix#blog
				(id, title,tagline,skin,url,charset,basePath, description)
				VALUES (
				'#variables.defaults["id"]#',
				<cfqueryparam value="#arguments.title#" cfsqltype="CF_SQL_VARCHAR" maxlength="150"/>,
				'#variables.defaults["tagline"]#',
				'#variables.defaults["skin"]#',
				<cfqueryparam value="#arguments.address#" cfsqltype="CF_SQL_VARCHAR" maxlength="255"/>,
				'#variables.defaults["charset"]#',
				<cfqueryparam value="#GetPathFromURL(arguments.address)#" cfsqltype="CF_SQL_VARCHAR" maxlength="255"/>,
				'#variables.defaults["description"]#')
		  </cfquery>
		  	
		  	 <cfset variables.componentPath = replacenocase(GetMetaData(this).name,"admin.setup.Setup","components.") /> 
			<cfset variables.blog = createobject("component",variables.componentPath & "Mango").init(variables.config,variables.defaults["id"])>
		<cfcatch type="any">
				<cfset result.status = false />
				<cfset result.message = cfcatch.Message &   " " & cfcatch.Detail />
			</cfcatch>
		</cftry>

		<cfreturn result/>
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="addData" access="package" output="false" returntype="struct">
		
			<cfset var addDataQuery = "" />
			<cfset var result = structnew() />
			<cfset var admin = ""/>
			<cfset var categoryId = createUUID() />
			
			<cfset result.status = true />
			<cfset result.message =  "" />
			
		<!---	<cftry> --->
			<cfif structkeyexists(variables,"blog")>
				<cfset admin = variables.blog.getAdministrator()>
				<cfset admin.newCategory(variables.defaults["categoryTitle"]) />
			<cfelse>
				<cfquery name="addDataQuery"  datasource="#variables.dsn#">
					INSERT INTO #variables.prefix#category
					(id,name,title,created_on,blog_id)
					VALUES ('#createUUID()#','#variables.defaults["categoryName"]#', '#variables.defaults["categoryTitle"]#',
					<cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP"/>,'#variables.defaults["id"]#')
		  		</cfquery>
		  	</cfif>
	<!---	  		
		  		<cfquery name="addDataQuery"  datasource="#variables.dsn#">
					INSERT INTO #variables.prefix#category
					(name,title,blog_id)
					VALUES ('#variables.defaults["categoryName"]#', '#variables.defaults["categoryTitle"]#','#variables.defaults["id"]#')
		  		</cfquery>
		  		
		  		<cfquery name="addDataQuery"  datasource="#variables.dsn#">
					INSERT INTO #variables.prefix#category
					(name,title,blog_id)
					VALUES ('#variables.defaults["categoryName"]#', '#variables.defaults["categoryTitle"]#','#variables.defaults["id"]#')
		  		</cfquery>
			 --->
<!---		<cfcatch type="any">
				<cfset result.status = false />
				<cfset result.message = cfcatch.Message &   " " & cfcatch.Detail />
			</cfcatch>
			</cftry> --->

		<cfquery name="addDataQuery"  datasource="#variables.dsn#">
					INSERT INTO #variables.prefix#link_category ( id, name, blog_id)
					VALUES ('#categoryId#', 'Favorite Links', '#variables.defaults["id"]#')
		  		</cfquery>

			<cfquery name="addDataQuery"  datasource="#variables.dsn#">
					INSERT INTO #variables.prefix#link ( id, title, address, description, category_id)
					VALUES ('#createUUID()#', 'AsFusion', 'http://www.asfusion.com', 'A blog about ColdFusion and Flex', '#categoryId#')
		  		</cfquery>
	
			
		<cfreturn result/>
	</cffunction>	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="setupPlugins" access="package" output="false" returntype="any">
		<cfset var queue = ""/>
		<cfset var plugin = "" />
		<cfset var i = 0 />
		<cfset var list = "">
		
		<cfif structkeyexists(variables,"blog")>
			<cfset queue = variables.blog.getPluginQueue() />
			<cfset list = queue.getPluginNames() />
				
			<cfloop from="1" to="#arraylen(list)#" index="i">
				<cfset plugin = queue.getPlugin(list[i])>
				<cfset plugin.setup() />
			</cfloop>
		</cfif>

		<cfreturn/>
	</cffunction>		
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--->
	<cffunction name="saveConfig" access="package" output="false" returntype="struct">
		<cfargument name="path" type="String" required="true" />
		<cfargument name="pluginsDir" type="String" required="true" />
		<cfargument name="assetsDir" type="String" required="false" default="" />
		<cfargument name="email" type="String" required="false" default="" />
		<cfargument name="id" type="String" required="false" default="#variables.defaults['id']#"/>
		<cfargument name="pluginsPath" type="String" required="false" default="plugins." />
		<cfargument name="applyUserPlugins" type="boolean" required="false" default="true" />
		
			<cfset var setup = "" />
			<cfset var result = structnew() />

			<cfset var config = createObject("component",variables.componentPath & "utilities.Preferences").init("#arguments.path#config.cfm")>
			<cfset var pluginPrefs = createObject("component",variables.componentPath & "utilities.Preferences").init("#arguments.path#pluginprefs.cfm")>
			<cfset variables.config = "#arguments.path#config.cfm" />
			<cfset result.status = true />
			<cfset result.message =  "" />
			
			<!--- datasource --->
			<cfset config.put("generalSettings/dataSource", "name", variables.dsn)/>
			<cfset config.put("generalSettings/dataSource", "type", variables.dbType)/>
			<cfset config.put("generalSettings/dataSource", "tablePrefix", variables.prefix )/>
			
			<!--- mailserver --->
			<cfset config.put("generalSettings/mailServer", "server", "")/>
			<cfset config.put("generalSettings/mailServer", "username", "") />
			<cfset config.put("generalSettings/mailServer", "password",  "")/>
			<cfset config.put("generalSettings/mailServer", "defaultFromAddress",  arguments.email)/>
			
			<!--- blog settings for this id --->
			<cfset config.put(arguments.id & "/blogsettings","language", "en") />
			<cfset config.put(arguments.id & "/blogsettings","searchUrl", "archives.cfm/search/") />
			<cfset config.put(arguments.id & "/blogsettings","postUrl", "post.cfm/{postName}") />
			<cfset config.put(arguments.id & "/blogsettings","authorUrl", "author.cfm/{authorAlias}") />
			<cfset config.put(arguments.id & "/blogsettings","archivesUrl", "archives.cfm/") />
			<cfset config.put(arguments.id & "/blogsettings","categoryUrl", "archives.cfm/category/{categoryName}") />
			<cfset config.put(arguments.id & "/blogsettings","pageUrl", "page.cfm/{pageHierarchyNames}{pageName}") />
			<cfset config.put(arguments.id & "/blogsettings","rssUrl", "feeds/rss.cfm") />
			<cfset config.put(arguments.id & "/blogsettings","atomUrl", "feeds/atom.cfm") />
			<cfset config.put(arguments.id & "/blogsettings","apiUrl", "api") />
			<cfset config.put(arguments.id & "/blogsettings","assetsDirectory", arguments.assetsDir) />
			<cfset config.put(arguments.id & "/blogsettings","skinsDirectory", "") />
			<cfset config.put(arguments.id & "/blogsettings","useFriendlyUrls", "1") />
			<cfset config.put(arguments.id & "/plugins","directory", arguments.pluginsDir) />
			<cfset config.put(arguments.id & "/plugins","path", arguments.pluginsPath) />
			<cfset config.put(arguments.id & "/plugins","preferencesFile", "#arguments.path#pluginprefs.cfm") />
			<cfset config.put(arguments.id & "/searchSettings","component", "search.Verity") />
			<cfset config.put(arguments.id & "/searchSettings/settings","collectionsPath", "") />
			
			<!--- default plugins --->
			<cfset pluginPrefs.put(arguments.id,"systemPlugins", variables.defaults["systemPlugins"]) />
			<cfif arguments.applyUserPlugins>
				<cfset pluginPrefs.put(arguments.id,"userPlugins", variables.defaults["userPlugins"]) />
			<cfelse>
				<cfset pluginPrefs.put(arguments.id,"userPlugins", "") />
			</cfif>		
		<cfreturn result/>
	</cffunction>
	
<cfinclude template="lib.cfm">


</cfcomponent>