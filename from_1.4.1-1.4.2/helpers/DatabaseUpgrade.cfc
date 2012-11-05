<cfcomponent>

	<cffunction name="addTables" returntype="boolean" output="true">
		<cfargument name="queryInterface" />
		
		<cfset var local = structnew() />
		<cfset local.tablePrefix = arguments.queryInterface.getTablePrefix() />
		<cfset local.queryInterface = arguments.queryInterface />
		
		<!--- add the log table --->
		<cfset local.dbtype = local.queryInterface.getDBType() />
		<cfset local.result = true />
		
			<!--- check if table log already exists --->
			<cftry>
				<cfset local.checkQuery = "SELECT level FROM #local.tablePrefix#log" />
				<cfset local.queryInterface.makeQuery(local.checkQuery,0,false) />
				<cfset local.logExists = true />
				
				<cfcatch type="any">
					<cfset local.logExists = false />
				</cfcatch>
			</cftry>
			
		
		<cftry>
		<cfif local.dbtype EQ "mssql">
		<!--- MSSQL ------------------------- --->	
			<cfif NOT local.logExists>
				<cfset local.queryString = "CREATE TABLE #local.tablePrefix#log (
				  level varchar(20) default NULL,
				  category varchar(30) default NULL,
				  message ntext default NULL,
				  logged_on datetime default NULL,
				  blog_id varchar(50) default NULL,
				  owner nvarchar(255) default NULL
				)" />
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			
		<cfelseif local.dbtype EQ "mssql_2005">
			<!--- MSSQL 2005 ------------------------- --->
			<cfif NOT local.logExists>
				<cfset local.queryString = "CREATE TABLE #local.tablePrefix#log (
				  level varchar(20) default NULL,
				  category varchar(30) default NULL,
				  message nvarchar(max) default NULL,
				  logged_on datetime default NULL,
				  blog_id varchar(50) default NULL,
				  owner nvarchar(255) default NULL
				)" />
				
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			
		<cfelseif local.dbtype EQ "mysql">
		<!--- MYSQL ------------------------- --->	
			<cfif NOT local.logExists>
				<cfset local.queryString = "CREATE TABLE `#local.tablePrefix#log` (
				  `level` varchar(20) default NULL,
				  `category` varchar(30) default NULL,
				  `message` longtext,
				  `logged_on` datetime default NULL,
				  `blog_id` varchar(50) default NULL,
				  `owner` varchar(255) default NULL
			) CHARACTER SET utf8 COLLATE utf8_general_ci;" />
				
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			
		</cfif>
			<br />Database upgraded successfully<br />
			<cfcatch type="any">
				<cfset local.result = false />
				<br />Couldn't upgrade database: <cfoutput>#cfcatch.Detail#</cfoutput>
			</cfcatch>
		</cftry>
		
		<cfreturn local.result />
	</cffunction>
	
</cfcomponent>