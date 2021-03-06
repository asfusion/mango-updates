<cfcomponent>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getInstance" output="false" description="Returns an object of this class" 
					access="public" returntype="any">
						
		<cfset var newinstance = "" />
		<cfif NOT structkeyexists(application,"_mainFileExplorer")> 
			<cfset newinstance = createObject("component", "MainFileExplorer").init() />
			<cfset application._mainFileExplorer = newinstance />
		 </cfif> 
		
		<cfreturn application._mainFileExplorer />
	</cffunction>	

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="init" output="false" returntype="any">
		<!--- making a dependency on Mango here, but at least I can remove the 
		reference in application.cfc --->
		<cfset var blogManager = application.blogFacade.getMango() />
		<cfset var blog = blogManager.getBlog() />
		<cfset var assetsInfo = blog.getSetting('assets') />
	
		<cfset variables.settings.rootDirectory = assetsInfo.directory />
		<cfif findnocase("/",assetsInfo.path) NEQ 1 OR findnocase("http",assetsInfo.path) NEQ 1>
		 	<cfset variables.settings.rootUrl = blog.getBasePath() & assetsInfo.path />
		 <cfelse>
		 	<cfset variables.settings.rootUrl = assetsInfo.path />
	 	</cfif>
	 	<cfif NOT structkeyexists(assetsInfo, "extensions")>
			<cfset assetsInfo.extensions = "*" />
		</cfif>
	 	<cfset variables.settings.allowedExtensions = assetsInfo.extensions />
	 	<cfif NOT structkeyexists(assetsInfo, "fileManager")>
			<cfset assetsInfo.fileManager = "FileManager" />
		</cfif>
	 	<cfset variables.settings.fileManager = assetsInfo.fileManager />
		<cfreturn this>
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getFileManager" access="public" output="false" returntype="any">
		<cfif NOT structkeyexists(variables,"filemanager")>
			<cfset variables.fileManager = createObject("component",variables.settings.fileManager).init(variables.settings)/>
		</cfif>
		<cfreturn variables.fileManager />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="setFileManager" access="public" output="false" returntype="any">
		<cfargument name="filemanager">

		<cfset variables.fileManager = arguments.filemanager>

	</cffunction>
		
	
</cfcomponent>