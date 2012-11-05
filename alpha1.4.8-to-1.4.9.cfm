<cfparam name="id" default="default">
<cfset path = GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset config = createObject("component","components.utilities.Preferences").init("#path#config.cfm")>

<cfset datasource = config.get("/generalSettings/dataSource","name") />
<cfset dbtype = config.get("/generalSettings/dataSource","type") />
<cfset prefix = config.get("/generalSettings/dataSource","tablePrefix") />

<!--- get all passwords and hash them --->

<cfquery name="authors" datasource="#datasource#">
	SELECT * FROM #prefix#author
</cfquery>

<cfoutput query="authors">
	<cfquery name="addLinks"  datasource="#datasource#">
		UPDATE #variables.prefix#author
		SET password = '#hash(id & password,"SHA")#'
		WHERE id = '#id#'
	</cfquery>
</cfoutput>
	

<p>Upgrade done, now you can copy the new files and restart CF.</p>