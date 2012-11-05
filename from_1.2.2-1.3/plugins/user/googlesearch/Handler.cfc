<cfcomponent>

	<cfset variables.package = "com/asfusion/mango/plugins/googlesearch"/>

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
			
			<cfset var blogid = arguments.mainManager.getBlog().getId() />
			<cfset var path = blogid & "/" & variables.package />
			<cfset variables.preferencesManager = arguments.preferences />
			<cfset variables.manager = arguments.mainManager />
			
			<cfset variables.title = variables.preferencesManager.get(path,"podTitle","Search") />
			<cfset variables.settingsFile = variables.preferencesManager.get(path,"settingsFile","") />
			<cfset variables.searchBoxCode = "" />
			<cfset variables.searchResultsCode = "" />
			<cfset loadCode() />
		<cfreturn this />
	</cffunction>
	
	
	<cffunction name="getName" access="public" output="false" returntype="string">
		<cfreturn variables.name />
	</cffunction>

	<cffunction name="setName" access="public" output="false" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
	</cffunction>

	<cffunction name="getId" access="public" output="false" returntype="any">
		<cfreturn variables.id />
	</cffunction>

	<cffunction name="setId" access="public" output="false" returntype="void">
		<cfargument name="id" type="any" required="true" />
		<cfset variables.id = arguments.id />
	</cffunction>

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<cfreturn "Google Search activated. <br />You can now <a href='generic_settings.cfm?event=googlesearch-showSettings&amp;owner=googlesearch&amp;selected=googlesearch'>Configure it</a>" />
	</cffunction>

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<cfreturn />
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="remove" hint="This is run when a plugin is removed" access="public" output="false" returntype="any">
		<cfset var blogid = variables.manager.getBlog().getId() />
		<cfset var path = blogid & "/" & variables.package />
		
		<cffile action="delete" file="#GetDirectoryFromPath(GetCurrentTemplatePath())#code/#variables.settingsFile#">
		<cfset variables.preferencesManager.removeNode(path) />
				
		<cfreturn "Google Search settings removed" />
	</cffunction>

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		
			<cfset var data =  "" />
			<cfset var eventName = arguments.event.name />
			
		<cfreturn />
	</cffunction>

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		
		<cfset var data = arguments.event.data />
		<cfset var eventName = arguments.event.name />
		<cfset var content = "" />
		<cfset var outData = "" />
		<cfset var blogid = "" />
		<cfset var path = "" />
		<cfset var pod = "" />
		<cfset var link = "" />
		<cfset var page = "" />
		
		<cfif eventName EQ "getPods">
				
				<!--- make sure we can add this to the pods list --->
				<cfif event.allowedPodIds EQ "*" OR listfindnocase(event.allowedPodIds, "googlesearch")>
					
					<cfset pod = structnew() />
					<cfset pod.title = variables.title />
					<cfset pod.content = variables.searchBoxCode />
					<cfset pod.id = "googlesearch" />
					<cfset arguments.event.addPod(pod)>
				</cfif>
			
			<cfelseif eventName EQ "googlesearch-search">
				<cfset data.message.setData(variables.searchResultsCode)/>
				<cfset data.message.setTitle("Search Results for #data.externaldata.q#")/>
			
			<cfelseif eventName EQ "googlesearch-showform">
				<cfset outData = arguments.event.outputData />
				<cfset outData = outData & variables.searchBoxCode />
				<cfset arguments.event.outputData = outData />
			
			<!--- admin nav event --->
			<cfelseif eventName EQ "settingsNav">
				<cfset link = structnew() />
				<cfset link.owner = "googlesearch">
				<cfset link.page = "settings" />
				<cfset link.title = "Google Search" />
				<cfset link.eventName = "googlesearch-showSettings" />
				
				<cfset arguments.event.addLink(link)>
			
			<!--- admin event --->
			<cfelseif eventName EQ "googlesearch-showSettings">			
				<cfif structkeyexists(data.externaldata,"apply")>
					<cfset blogid = variables.manager.getBlog().getId() />
					<cfset path = blogid & "/" & variables.package />
		
					<cfset variables.title = data.externaldata.podTitle />
					<cfset variables.preferencesManager.put(path,"podTitle",variables.title) />
					
					<cfif NOT len(variables.settingsFile)>
						<cfset variables.settingsFile = "code_" & createUUID() & ".txt" />
						<cfset variables.preferencesManager.put(path,"settingsFile", variables.settingsFile) />
					</cfif>
					
					<cffile action="write" file="#GetDirectoryFromPath(GetCurrentTemplatePath())#code/#variables.settingsFile#" 
								output="#data.externaldata.searchBoxCode#------#data.externaldata.searchResultsCode#">
					
					<cfset loadCode() />
					
					<cfset data.message.setstatus("success") />
					<cfset data.message.setType("settings") />
					<cfset data.message.settext("Settings updated")/>
				</cfif>
				
				<cfsavecontent variable="page">
					<cfinclude template="admin/settingsForm.cfm">
				</cfsavecontent>
					
					<!--- change message --->
					<cfset data.message.setTitle("Google Search settings") />
					<cfset data.message.setData(page) />
					
			<cfelseif eventName EQ "getPodsList"><!--- no content, just title and id --->
				<cfset pod = structnew() />
				<cfset pod.title = "Google Custom Search" />
				<cfset pod.id = "googlesearch" />
				<cfset arguments.event.addPod(pod)>
			</cfif>
		<cfreturn arguments.event />
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="loadCode" access="private">
		
		<cfset var content = "" />
		<cfset var separatorPosition = 0 />
		<cfset var formClosePosition = 0 />
		
		<cfif len(variables.settingsFile) AND 
				fileexists(GetDirectoryFromPath(GetCurrentTemplatePath()) & "code/" & variables.settingsFile)>
			<cfsavecontent variable="content"><cfinclude template="code/#variables.settingsFile#">
			</cfsavecontent>
			
			<cfset separatorPosition = findnocase("------",content) />
			<cfif separatorPosition GT 0>
				<cfset variables.searchBoxCode = left(content, separatorPosition - 1) />
				<!--- add a hidden input, if needed --->
				<cfif NOT findnocase('<input type="hidden" name="event" value="googlesearch-search" />',variables.searchBoxCode)>
					<cfset formClosePosition = findnocase("</form>", variables.searchBoxCode) />
					<cfset variables.searchBoxCode = insert('<input type="hidden" name="event" value="googlesearch-search" />
					<input type="hidden" name="action" value="event" />',
						variables.searchBoxCode, formClosePosition - 1) />
				</cfif>
				
				<cfset variables.searchResultsCode = right(content, len(content) - 5 - separatorPosition)>
			</cfif>
		</cfif>
		
	</cffunction>
	
</cfcomponent>