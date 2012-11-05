<cfcomponent displayname="Application">
<!--- 
	Author   : Laura Arguello
	Date   : 04/07/06
--->
	<cfscript>
		this.name = "mangoAdmin_#right(hash(GetDirectoryFromPath(GetCurrentTemplatePath())),50)#";
		this.setclientcookies="yes";
		this.sessionmanagement="Yes";
		this.sessiontimeout= CreateTimeSpan(0,0,30,0);	
		variables.path = replacenocase(GetMetaData(this).name,"admin.Application","components.");
		variables.adminPath = replacenocase(GetMetaData(this).name,"Application","");
		
		//for the file explorer
		variables.fileExplorerConfig = GetDirectoryFromPath(GetCurrentTemplatePath()) & "fileexplorer.ini.cfm";

	</cfscript>

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="OnApplicationStart" output="false">
		<cfset application.blogManager = createobject("component",variables.path & "Mango").init(expandPath("../config.cfm"),"default",true) />
		
		<cfset application.administrator = application.blogManager.getAdministrator() />
		<cfset application.currentSkin = application.administrator.getSkin(application.blogManager.getBlog().getSkin()) />
		
		<cfset application.fileManager = structnew()/>
		<cfset application.fileManager.typesWithIcons = GetProfileString(variables.fileExplorerConfig, "default", "typesWithIcons") />
		<cfset application.fileManager.servicespath = variables.adminPath &  "services" />
		<cfset application.fileManager.treeRootLabel = GetProfileString(variables.fileExplorerConfig, "default", "treeRootLabel") />
		<cfset application.fileManager.allowedExtensions = GetProfileString(variables.fileExplorerConfig, "default", "allowedExtensions") />
		<cfset application.fileManager.allowedExtensionsDescription = GetProfileString(variables.fileExplorerConfig, "default", "allowedExtensionsDescription") />
		
		
		<cfset application.skinManager = structnew()/>
		<cfset application.skinManager.typesWithIcons = GetProfileString(variables.fileExplorerConfig, "skins", "typesWithIcons") />
		<cfset application.skinManager.servicespath = variables.adminPath &  "services" />
		<cfset application.skinManager.treeRootLabel = GetProfileString(variables.fileExplorerConfig, "skins", "treeRootLabel") />
		<cfset application.skinManager.allowedExtensions = GetProfileString(variables.fileExplorerConfig, "skins", "allowedExtensions") />
		<cfset application.skinManager.allowedExtensionsDescription = GetProfileString(variables.fileExplorerConfig, "skins", "allowedExtensionsDescription") />
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="onSessionStart">	
		
		<cfset session.blogManager = application.blogManager />
		<cfset session.administrator = session.blogManager.getAdministrator() />
		<cfset session.author = createObject("component",variables.path & "ObjectFactory").createAuthor() />
	
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="onRequestStart" returnType="boolean" output="true">
		<cfargument type="String" name="targetPage" required="true" />
			<cfset var authors = ""/>
			<cfset var isAuthor = ""/>
			<cfset var rootDir = ""/>
			<cfparam name="form" default="#structnew()#">
			
			<cfif structkeyexists(url,"logout")>
				<cfset onSessionStart() />
			</cfif>
			
			<cfif structkeyexists(form,"login")>
				<cfset authors = application.blogManager.getAuthorsManager() />
				<cfset isAuthor = authors.checkCredentials(form.username,form.password) />
				<cfif isAuthor>
					<cfset session.author = authors.getAuthorByUsername(form.username) />
					<cfset session.author.setPassword(form.password) />
					<cfset session.formHandler = createObject("component","FormHandler").init(session.administrator,session.author) />		
					
					<cfset rootDir = expandPath("../assets/content/") />
					<cfset session.fileManager = createObject("component","com.blueinstant.FileManager"
							).init(rootDir,GetProfileString(variables.fileExplorerConfig, "default", "allowedExtensions")) />
					
					<!--- for skin --->
					<cfset rootDir = session.administrator.getBlog().getSetting('skinsDirectory') />
					<cfif NOT len(rootDir)>
						<!--- use default --->
						<cfset rootDir = replacenocase(GetDirectoryFromPath(GetCurrentTemplatePath()),"admin","skins") />
					</cfif>
					
					<cfset session.skinFileManager = createObject("component","com.blueinstant.FileManager"
							).init(rootDir,GetProfileString(variables.fileExplorerConfig, "skins", "allowedExtensions")) />
							
				<cfelse>
					<cfset request.errormsg = "Invalid login, please try again." />
					<cfset request.username = form.username />
				</cfif>
			</cfif>
			
			<cfif NOT structkeyexists(session,"author") OR session.author.getId() EQ "">
				<cfsetting showdebugoutput="false">
				<cfinclude template="login.cfm">
				<cfreturn false>
			</cfif>
			
			<cfset request.blogManager = session.blogManager />
			<cfset request.administrator = session.administrator />
			<cfset request.currentSkin = application.currentSkin />
			<cfset request.formHandler = session.formHandler />
			<cfset request.fileManagerProps = application.fileManager />
			<cfset request.skinManagerProps = application.skinManager />
			
			<cfset request.blogManager = application.blogManager />
			<cfset structappend(request,request.blogManager.handleRequest(targetPage,url,form),true)/>
			
			<!--- just for tinymc --->
			<cfset request.serverRoot = replacenocase(GetDirectoryFromPath(GetCurrentTemplatePath()),request.blogManager.getBlog().getBasePath() & "admin","")/>
			
			<cfsetting showdebugoutput="false">
		<cfreturn true>
	</cffunction>

	
</cfcomponent>
