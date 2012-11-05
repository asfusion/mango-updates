<cfparam name="id" default="default">
<cfparam name="done" default="0">
<cfif NOT done>
<cfset path = GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset config = createObject("component","components.utilities.Preferences").init("#path#config.cfm")>

<!--- add url setting --->
<cfif NOT len(config.get("/generalSettings/dataSource","username",""))>
	<cfset config.put("/generalSettings/dataSource","username","") />
</cfif>
<cfif NOT len(config.get("/generalSettings/dataSource","password",""))>
	<cfset config.put("/generalSettings/dataSource","password","") />
</cfif>
<p>Upgrade done, now you can copy the new files and restart CF or <a href="?done=1">click here</a>.</p>

<cfelse>
	<cfset request.blogManager.reloadConfig() />
</cfif>