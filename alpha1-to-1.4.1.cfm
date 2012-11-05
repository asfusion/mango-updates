<cfparam name="id" default="default">

<cfset path = GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset config = createObject("component","components.utilities.Preferences").init("#path#config.cfm")>

<!--- change plugin settings --->
<cfset config.put(id & "/plugins","directory", config.get(id,"pluginsDirectory")) />
<cfset config.put(id & "/plugins","path", "plugins.") />
<cfset config.put(id & "/plugins","preferencesFile", "#path#pluginprefs.cfm") />

<cfset pluginPrefs = createObject("component","components.utilities.Preferences").init("#path#pluginprefs.cfm")>
<cfset pluginPrefs.put(id,"systemPlugins", "CacheUpdater,SearchIndexer,SubscriptionHandler") />
<cfset pluginPrefs.put(id,"userPlugins", "captcha,formRememberer,cocomment,colorcoding,linkify") />

<!--- delete old preferences file --->
<cftry>
<cffile action="delete" file="#path#components/plugins/preferences.cfm">
<cfcatch type="any"></cfcatch>
</cftry>

<p>Upgrade done, now you can copy the new files and restart CF.</p>