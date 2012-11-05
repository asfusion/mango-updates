<cfcomponent>

	<cffunction name="addTables" returntype="boolean" output="true">
		<cfargument name="queryInterface" />
		
		<cfset var local = structnew() />
		<cfset local.tablePrefix = arguments.queryInterface.getTablePrefix() />
		<cfset local.queryInterface = arguments.queryInterface />
		
		<!--- add the plugins columns, very important! --->
		<cfset local.dbtype = local.queryInterface.getDBType() />
		<cfset local.result = true />
		
		<!--- check if systemplugins and plugins columns already exist --->
			<cftry>
				<cfset local.checkQuery = "SELECT plugins FROM #local.tablePrefix#blog" />
				<cfset local.queryInterface.makeQuery(local.checkQuery,0,false) />
				<cfset local.pluginsExists = true />
				
				<cfcatch type="any">
					<cfset local.pluginsExists = false />
				</cfcatch>
			</cftry>
			
			<cftry>
				<cfset local.checkQuery = "SELECT systemplugins FROM #local.tablePrefix#blog" />
				<cfset local.queryInterface.makeQuery(local.checkQuery,0,false) />
				<cfset local.systempluginsExists = true />
				
				<cfcatch type="any">
					<cfset local.systempluginsExists = false />
				</cfcatch>
			</cftry>
			
			<!--- check if table settings already exists --->
			<cftry>
				<cfset local.checkQuery = "SELECT path FROM #local.tablePrefix#setting" />
				<cfset local.queryInterface.makeQuery(local.checkQuery,0,false) />
				<cfset local.settingExists = true />
				
				<cfcatch type="any">
					<cfset local.settingExists = false />
				</cfcatch>
			</cftry>
			
			<!--- check if table entry_revision already exists --->
			<cftry>
				<cfset local.checkQuery = "SELECT id FROM #local.tablePrefix#entry_revision" />
				<cfset local.queryInterface.makeQuery(local.checkQuery,0,false) />
				<cfset local.revisionExists = true />
				
				<cfcatch type="any">
					<cfset local.revisionExists = false />
				</cfcatch>
			</cftry>
		
		<cftry>
		<cfif local.dbtype EQ "mssql">
		<!--- MSSQL ------------------------- --->	
			<cfif NOT local.pluginsExists>
				<cfset local.queryString = "ALTER TABLE #local.tablePrefix#blog 
					ADD plugins text;" />
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			<cfif NOT local.systempluginsExists>
				<cfset local.queryString = "ALTER TABLE #local.tablePrefix#blog 
					ADD systemplugins text;" />
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			
			<cfif NOT local.settingExists>
				<cfset local.queryString = "CREATE TABLE #local.tablePrefix#setting (
				  path nvarchar(255) NOT NULL default '',
				  name nvarchar(100) NOT NULL default '',
				  [value] ntext,
				  blog_id varchar(50) default ''
				)
				
				CREATE  INDEX IX_#local.tablePrefix#setting_path ON #local.tablePrefix#setting(path)
				CREATE  INDEX IX_#local.tablePrefix#setting_blog ON #local.tablePrefix#setting(blog_id)" />
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			
			<cfif NOT local.revisionExists>
				<!--- add versioning table --->
				<cfset local.queryString = "CREATE TABLE #local.tablePrefix#entry_revision (
					  id varchar(35) NOT NULL,
					  entry_id varchar(35) default NULL,
					  name nvarchar (200) NULL ,
					  title nvarchar (200) NULL ,
					  content text,
					  excerpt text,
					  author_id varchar(35) default NULL,
					  last_modified smalldatetime default NULL,
					  entry_type varchar(10) default NULL,
					  CONSTRAINT PK_#local.tablePrefix#entry_revision PRIMARY KEY(id)
					)
					
					CREATE  INDEX IX_#local.tablePrefix#entry_revision ON #local.tablePrefix#entry_revision(entry_id)" />
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			
		<cfelseif local.dbtype EQ "mssql_2005">
			<!--- MSSQL 2005 ------------------------- --->
			<cfif NOT local.pluginsExists>
				<cfset local.queryString = "ALTER TABLE #local.tablePrefix#blog 
					ADD plugins nvarchar(max);" />
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			<cfif NOT local.systempluginsExists>
				<cfset local.queryString = "ALTER TABLE #local.tablePrefix#blog 
					ADD systemplugins nvarchar(max);" />
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			
			<cfif NOT local.settingExists>
				<cfset local.queryString = "CREATE TABLE #local.tablePrefix#setting (
				 	 path nvarchar(255) NOT NULL default '',
				 	 name nvarchar(100) NOT NULL default '',
				 	 [value] nvarchar(max),
					  blog_id varchar(50) default ''
					)
				
					CREATE  INDEX IX_#local.tablePrefix#setting_path ON #local.tablePrefix#setting(path)
					CREATE  INDEX IX_#local.tablePrefix#setting_blog ON #local.tablePrefix#setting(blog_id)" />
				
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			
			<cfif NOT local.revisionExists>
				<cfset local.queryString = "CREATE TABLE #local.tablePrefix#entry_revision (
					  id varchar(35) NOT NULL,
					  entry_id varchar(35) default NULL,
					  name nvarchar (200) NULL ,
					  title nvarchar (200) NULL ,
					  content nvarchar(max),
					  excerpt nvarchar(max),
					  author_id varchar(35) default NULL,
					  last_modified smalldatetime default NULL,
					  entry_type varchar(10) default NULL,
					  CONSTRAINT PK_#local.tablePrefix#entry_revision PRIMARY KEY(id)
					)
					
					CREATE  INDEX IX_#local.tablePrefix#entry_revision ON #local.tablePrefix#entry_revision(entry_id)" />
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			
		<cfelseif local.dbtype EQ "mysql">
		<!--- MYSQL ------------------------- --->	
			<cfif NOT local.pluginsExists>
				<cfset local.queryString = "ALTER TABLE #local.tablePrefix#blog 
					ADD COLUMN `plugins` text" />
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			<cfif NOT local.systempluginsExists>
				<cfset local.queryString = "ALTER TABLE #local.tablePrefix#blog 
					ADD COLUMN `systemplugins` text" />
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			
			<cfif NOT local.settingExists>
				<cfset local.queryString = "CREATE TABLE `#local.tablePrefix#setting` (
				  `path` varchar(255) NOT NULL default '',
				  `name` varchar(100) NOT NULL default '',
				  `value` longtext,
				  `blog_id` varchar(50) default '',
				  KEY `IX_#local.tablePrefix#setting_path` (`path`),
				  KEY `IX_#local.tablePrefix#setting_blog` (`blog_id`)
				) CHARACTER SET utf8 COLLATE utf8_general_ci;" />
				
				<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			</cfif>
			
			<cfif NOT local.revisionExists>
				<!--- for the revisionmanager plugin --->
				<cfset local.queryString = "CREATE TABLE `#local.tablePrefix#entry_revision` (
				  `id` varchar(35) NOT NULL,
				  `entry_id` varchar(35) default NULL,
				  `name` varchar(200) default NULL,
				  `title` varchar(200) default NULL,
				  `content` longtext,
				  `excerpt` longtext,
				  `author_id` varchar(35) default NULL,
				  `last_modified` datetime default NULL,
				  `entry_type` varchar(10) default NULL,
				  PRIMARY KEY  (`id`),
				  KEY `IX_#local.tablePrefix#entry_revision` (`entry_id`)
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