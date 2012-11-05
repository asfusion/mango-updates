<cfparam name="id" default="default">

<cfset path = GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset config = createObject("component","components.utilities.Preferences").init("#path#config.cfm")>

<cfset datasource = config.get("/generalSettings/dataSource","name") />
<cfset dbtype = config.get("/generalSettings/dataSource","type") />
<cfset prefix = config.get("/generalSettings/dataSource","tablePrefix") />

<cfif dbtype EQ "mssql">
	<cfquery name="addLinks" datasource="#datasource#">
		ALTER TABLE #prefix#link_category
		ADD blog_id varchar(50)
	</cfquery>
<cfelseif dbtype EQ "mysql">
	<cfquery name="addLinks" datasource="#datasource#">
		ALTER TABLE `#prefix#link_category`
		ADD COLUMN `blog_id` varchar(50)
		AFTER `parent_category_id`
	</cfquery>
</cfif>

<cfquery name="addLinks"  datasource="#datasource#">
	UPDATE #variables.prefix#link_category
	SET blog_id = 'default'
</cfquery>	

<p>Upgrade done, now you can copy the new files and restart CF.</p>