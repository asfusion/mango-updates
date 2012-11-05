<cfparam name="id" default="default">
<cfparam name="done" default="0">

<cfif NOT done>
<cfset path = GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset config = createObject("component","components.utilities.PreferencesFile").init("#path#config.cfm")>
<cfset pluginPrefs = createObject("component","components.utilities.PreferencesFile").init("#path#pluginprefs.cfm")>

<cfset currentSystemPlugins = pluginPrefs.get(id,"systemPlugins","") />
<cfif NOT listfindnocase(currentSystemPlugins, "PodManager")>
	<cfset currentSystemPlugins = listappend(currentSystemPlugins, "PodManager") />
	<cfset pluginPrefs.put(id,"systemPlugins", currentSystemPlugins) />
</cfif>

<cfset request.blogManager.reloadConfig() />
	<p>Done</p>
	
</cfif>