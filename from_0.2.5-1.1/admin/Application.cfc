<cfcomponent>
<!--- 
	Author   : Laura Arguello
--->
	<cfscript>
		this.name = "mangoAdmin_#right(hash(GetDirectoryFromPath(GetCurrentTemplatePath())),50)#_v1_1";
		this.setclientcookies="yes";
		this.sessionmanagement="Yes";
		this.sessiontimeout= CreateTimeSpan(0,0,30,0);
		
	</cfscript>

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="OnApplicationStart" output="false">
		<cfset var facade = "" />
		<cfset var blogManager = "" />
		
		<!--- this piece is only necessary for set ups that have a mapping in some of the folders in the path --->
		<cfset application.path = replacenocase(GetMetaData(this).name,"admin.Application","components.") />
		<!--- variables.adminPath = replacenocase(GetMetaData(this).name,"Application",""); --->
		
		<!--- check whether components path works --->
		<cftry>
			<cfset createObject("component", application.path & "utilities.Preferences")>
			<cfcatch type="any">
				<!--- if we catch a problem, it means there was a problem finding the path --->
				<cfset application.path = 
						replace(replacenocase(replacenocase(cgi.script_name,ListLast(cgi.script_name,"/"),''),'admin/',''),"/",".",'all') 
							& "components." />
				<cfset application.path = right(application.path,len(application.path)-1) />
				<!--- <cfset variables.adminPath = replacenocase(variables.path,"components.","admin.") /> --->
		</cfcatch>
		</cftry>
		
		<cfset facade = createobject("component",application.path & "MangoFacade") />
		<cfset blogManager = createobject("component",application.path & "Mango").init(expandPath("../config.cfm"),"default",true) />
		<cfset facade.setMango(blogManager) />
		
		<cfset application.administrator = blogManager.getAdministrator() />
		<cfset application.currentSkin = application.administrator.getSkin(blogManager.getBlog().getSkin()) />
		
		<!--- set the plugin file manager root --->
		<cfset application.asfFileExplorerPluginRoot = expandPath("../assets/content/") />
		<!--- set the root of the file explorer --->
		<cfset createObject("component","com.asfusion.fileexplorer.services.MainFileExplorer").getInstance().init(application.asfFileExplorerPluginRoot) />
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="onSessionStart">
	
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="onRequestStart" returnType="boolean" output="true">
		<cfargument type="String" name="targetPage" required="true" />
			<cfset var authors = ""/>
			<cfset var isAuthor = ""/>
			<cfset var rootDir = ""/>
			<cfset var facade = createobject("component",application.path & "MangoFacade") />
			<cfset var blogManager = facade.getMango() />
			<cfset var author = "" />
			
			<cfparam name="form" default="#structnew()#">
			<cfsetting showdebugoutput="false">
			
			<cfif structkeyexists(url,"logout")>
				<cfset blogManager.removeCurrentUser() />
			</cfif>
			
			<cfif structkeyexists(form,"login")>
				<cfset authors = blogManager.getAuthorsManager() />
				<cfset isAuthor = authors.checkCredentials(form.username,form.password) />
				<cfif isAuthor>
					<cfset author = authors.getAuthorByUsername(form.username, true) />
					<cfset author.setPassword(form.password) />
					<cfset blogManager.setCurrentUser(author) />
					<cfset session.formHandler = createObject("component","FormHandler").init(application.administrator, author) />
				<cfelse>
					<cfset request.errormsg = "Invalid login, please try again." />
					<cfset request.username = form.username />
				</cfif>
			</cfif>
			
			<cfif NOT blogManager.isCurrentUserLoggedIn()>
				<cfinclude template="login.cfm">
				<cfreturn false>
			</cfif>
			
			<cfset request.blogManager = blogManager />
			<cfset request.administrator = application.administrator />
			<cfset request.currentSkin = application.currentSkin />
			<cfset request.formHandler = session.formHandler />

			<cfset structappend(request,request.blogManager.handleRequest(targetPage,url,form),true)/>

		<cfreturn true>
	</cffunction>
	
</cfcomponent>
