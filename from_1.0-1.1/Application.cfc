<cfcomponent displayname="Application">
<!--- 
	Author   : Laura Arguello
	Date   : 01/29/06
--->
	<cfscript>
		this.name = "mango_#right(hash(GetDirectoryFromPath(GetCurrentTemplatePath())),50)#_v1_1";
		this.setclientcookies="yes";
		this.sessionmanagement="yes";
		this.sessiontimeout= CreateTimeSpan(0,0,30,0);
		
		variables.componentsPath = "components.";
	</cfscript>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="OnApplicationStart" output="false">
		<cfset var facade = ""/>
		<cftry>
			<cfset createObject("component", variables.componentsPath & "utilities.Preferences")>
			<cfcatch type="any">
				<!--- if we catch a problem, it means there was a problem finding the path --->
				<cfset variables.componentsPath = 
						replace(replacenocase(replacenocase(cgi.script_name,ListLast(cgi.script_name,"/"),''),'admin/',''),"/",".",'all') 
							& "components." />
				<cfset variables.componentsPath = right(variables.componentsPath,len(variables.componentsPath)-1) />
		</cfcatch>
		</cftry>
		
		<cfset facade = createobject("component",variables.componentsPath & "MangoFacade") />
		<cftry>
			<cfset facade.setMango(createobject("component",variables.componentsPath & "Mango").init(GetDirectoryFromPath(GetCurrentTemplatePath()) & "config.cfm")) />
			<cfset application.blogFacade = facade />
		<cfcatch type="MissingConfigFile">
			<cflocation URL="admin/setup/setup.cfm" addtoken="false">
		</cfcatch>
		</cftry>
	</cffunction>
	

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="onRequestStart" returnType="boolean" output="false">
		<cfargument type="String" name="targetPage" required="true" />
			
			<cfparam name="form" default="#structnew()#">
			
			<cfif structkeyexists(cgi,"CONTENT_TYPE") AND cgi["CONTENT_TYPE"] EQ "application/x-amf">
				<cfset StructDelete(this,"onError") />
			</cfif>
			
			<cfset request.blogManager = application.blogFacade.getMango()/>
			<cfset structappend(request,request.blogManager.handleRequest(targetPage,url,form),true)/>

			<cfsetting showdebugoutput="false">
		<cfreturn true>
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="onSessionEnd">
	   <cfargument name = "SessionScope" required="true" />
	   <cfargument name = "AppScope" required="true" />	 
	</cffunction>	

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="onApplicationEnd" returnType="void">
   <cfargument name="ApplicationScope" required="true" />
</cffunction>	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="onError" returnType="void">
		<cfargument name="Exception" required="true" />
		<cfargument name="EventName" type="String" required="true"/>

		<cfset request.message = createObject("component",variables.componentsPath & "Message") />
		<cfset request.message.setTitle("Error: " & arguments.EventName) />
		<cfset request.message.setText(exception.message) />
		<cfset request.message.setStatus("error") />
		<cfset request.message.setData(exception.detail) />
		
		<cftry>
			<cfsetting enablecfoutputonly="false">
			<cfinclude template="generic.cfm">
		<cfcatch type="any">
			<cfsetting enablecfoutputonly="false">
			<cfinclude template="error.cfm">
		</cfcatch>
		</cftry>
	</cffunction>
	
	
</cfcomponent>
