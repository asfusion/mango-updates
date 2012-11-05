<cfparam name="id" default="default">
<cfset path = GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset config = createObject("component","components.utilities.Preferences").init("#path#config.cfm")>

<cfset datasource = config.get("/generalSettings/dataSource","name") />
<cfset dbtype = config.get("/generalSettings/dataSource","type") />
<cfset prefix = config.get("/generalSettings/dataSource","tablePrefix") />

<!--- add column and table for permissions --->
<cfif dbtype EQ "mssql">
	<cfquery name="permissions" datasource="#datasource#">
		ALTER TABLE #prefix#author
		ADD permissions TEXT
		
		CREATE TABLE #prefix#permission (
			id varchar (20) NOT NULL ,
 		 	description varchar (255) NULL,
		    CONSTRAINT PK_#prefix#permission PRIMARY KEY(id)
		)
	</cfquery>
<cfelseif dbtype EQ "mysql">
	<cfquery name="authors" datasource="#datasource#">
		ALTER TABLE `#prefix#author` 
		ADD COLUMN `permissions` text
		AFTER `alias`;
	</cfquery>
	<cfquery name="permissions" datasource="#datasource#">
		CREATE TABLE `#prefix#permission` (
	  		`id` varchar(20) NOT NULL,
	  		`description` varchar(255),
	  		PRIMARY KEY(`id`)
		)
	</cfquery>
</cfif>

<p>Upgrade done, now you can copy the new files and restart CF.</p>