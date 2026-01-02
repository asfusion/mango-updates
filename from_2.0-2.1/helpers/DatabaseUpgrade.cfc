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
			<cfset local.queryString = "ALTER TABLE #variables.tablePrefix#author ADD`preferences TEXT  NULL" />
		<cfelseif dbtype EQ "mysql">
			<cfset local.queryString =
				"ALTER TABLE `#variables.tablePrefix#author` ADD `preferences` TEXT  NULL"/>
		</cfif>
		<cfset local.queryResult = variables.queryInterface.makeQuery(local.queryString,0,false) />

	</cffunction>
</cfcomponent>