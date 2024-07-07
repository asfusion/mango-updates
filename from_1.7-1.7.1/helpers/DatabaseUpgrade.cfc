<cfcomponent>

	<!--- ::::::::::::::::::::::::::::::::::: --->
	<cffunction name="addSettings">
		<cfargument name="queryInterface" />
		<cfargument name="blogId" />
		
		<cfset var local = structnew() />
		<cfset variables.tablePrefix = arguments.queryInterface.getTablePrefix() />
		<cfset variables.queryInterface = arguments.queryInterface />
		<cfset variables.blogId = arguments.blogId />
		<cfset var dbtype = arguments.queryInterface.getDBType() />

		<cfif dbtype EQ "mssql">
			<cfset local.queryString = "ALTER TABLE #variables.tablePrefix#setting ADD [type] VARCHAR(10)  NULL  DEFAULT 'string'" />
		<cfelseif dbtype EQ "mysql">
			<cfset local.queryString = "ALTER TABLE `#variables.tablePrefix#setting` ADD `type` VARCHAR(10)  NULL  DEFAULT 'string'" />
		</cfif>

		<cfset local.queryResult = variables.queryInterface.makeQuery(local.queryString,0,true) />
		
		<cfif NOT local.queryResult.recordcount>
			<!--- setting does not already exist --->
			<cfset local.queryStringInsert = "INSERT INTO #variables.tablePrefix#setting(path, name, value, blog_id)
  				VALUES('system/admin/htmleditor', 'editor', 'ckeditor', '#variables.blogId#')" />
			<cfset variables.queryInterface.makeQuery(local.queryStringInsert, 0, false) />
		</cfif>



<cfset local.queryString = "CREATE TABLE `#variables.tablePrefix#login_key` (
		`id` varchar(35) NOT NULL DEFAULT '',
		`user_id` varchar(35) DEFAULT NULL,
		`user_type` varchar(10) DEFAULT NULL,
		`last_visit_on` datetime DEFAULT NULL,
		PRIMARY KEY (`id`)
		)">
		<cfset local.queryResult = variables.queryInterface.makeQuery(local.queryString,0,true) />

<cfset local.queryString = "CREATE TABLE `#variables.tablePrefix#login_password_reset` (
		`id` varchar(40) NOT NULL DEFAULT '',
		`user_id` varchar(40) DEFAULT NULL,
		`valid` tinyint DEFAULT NULL,an
		`created_on` datetime DEFAULT NULL,
		PRIMARY KEY (`id`)
		)">

		<cfset local.queryResult = variables.queryInterface.makeQuery(local.queryString,0,true) />

		
	</cffunction>




</cfcomponent>