<cfparam name="id" default="default">
<cfparam name="done" default="0">
<cfif NOT done>
<cfset path = GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset config = createObject("component","components.utilities.Preferences").init("#path#config.cfm")>

<!--- add url setting --->
<cfset config.put(id & "/blogsettings","useFriendlyUrls", "1") />

<!--- try deleting admin file I removed --->
<cftry>
	<cffile action="delete" file="#path#admin/downloadableSkins.cfm">
<cfcatch type="any">
</cfcatch>
</cftry>

<p>Upgrade done, now you can copy the new files and restart CF or <a href="?done=1">click here</a>.</p>

<cfelse>
	<cfset request.blogManager.reloadConfig() />
</cfif>