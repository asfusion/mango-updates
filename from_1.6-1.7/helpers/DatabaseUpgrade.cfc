<cfcomponent>

	<!--- ::::::::::::::::::::::::::::::::::: --->
	<cffunction name="addSettings">
		<cfargument name="queryInterface" />
		<cfargument name="blogId" />
		
		<cfset var local = structnew() />
		<cfset variables.tablePrefix = arguments.queryInterface.getTablePrefix() />
		<cfset variables.queryInterface = arguments.queryInterface />
		<cfset variables.blogId = arguments.blogId />
		
		<cfset local.queryString = "SELECT * FROM #variables.tablePrefix#setting 
		WHERE path = 'system/admin/htmleditor' AND name = 'editor' AND blog_id = '#variables.blogId#'" />
		<cfset local.queryResult = variables.queryInterface.makeQuery(local.queryString,0,true) />
		
		<cfif NOT local.queryResult.recordcount>
			<!--- setting does not already exist --->
			<cfset local.queryStringInsert = "INSERT INTO #variables.tablePrefix#setting(path, name, value, blog_id)
  				VALUES('system/admin/htmleditor', 'editor', 'ckeditor', '#variables.blogId#')" />
			<cfset variables.queryInterface.makeQuery(local.queryStringInsert, 0, false) />
		</cfif>
		
	</cffunction>
	
</cfcomponent>