<cfcomponent name="comment" hint="Gateway for comment">

 <!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="init" output="false" returntype="any" hint="instantiates an object of this class" access="public">
	<cfargument name="datasource" required="true" type="struct">
		
		<cfset variables.datasource = arguments.datasource />
		<cfset variables.dsn = arguments.datasource.name />
		<cfset variables.prefix = arguments.datasource.tablePrefix />
		<cfset variables.username = arguments.datasource.username />
		<cfset variables.password = arguments.datasource.password />
		<cfreturn this />
</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getByID" output="false" hint="Gets a query with only one record corresponding tor ID" access="public" returntype="query">
	<cfargument name="id" required="true" type="string" hint="Primary key"/>
	<cfargument name="adminMode" required="false" default="false" type="boolean" hint="Whether to include non-approved comments"/>

	<cfset var q_comment = "" />
	
	<cfquery name="q_comment" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		SELECT
			#variables.prefix#comment.*, #variables.prefix#entry.title as entry_title
		FROM	#variables.prefix#comment
		LEFT OUTER JOIN #variables.prefix#entry ON #variables.prefix#comment.entry_id = #variables.prefix#entry.id
		WHERE #variables.prefix#comment.id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35"/>
		<cfif NOT adminMode>
			AND #variables.prefix#comment.approved = 1
		</cfif>
	</cfquery>

	<cfreturn q_comment />
</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getAll" output="false" hint="Gets all the records" access="public" returntype="query">
	<cfargument name="adminMode" required="false" default="false" type="boolean" hint="Whether to include non-approved comments"/>
	
	<cfset var q_comment = "" />
	
	<cfquery name="q_comment" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		SELECT
			#variables.prefix#comment.*, #variables.prefix#entry.title as entry_title
		FROM	#variables.prefix#comment
		LEFT OUTER JOIN #variables.prefix#entry ON #variables.prefix#comment.entry_id = #variables.prefix#entry.id
		<cfif NOT adminMode>
			WHERE #variables.prefix#comment.approved = 1
		</cfif>
	</cfquery>

	<cfreturn q_comment />
</cffunction>

	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getByPost" output="false" access="public" returntype="query">
		<cfargument name="entry_id" required="true" type="string" hint="Entry"/>
		<cfargument name="adminMode" required="false" default="false" type="boolean" hint="Whether to include non-approved comments"/>

	<cfset var q_comment = "" />
	
	<cfquery name="q_comment" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		SELECT
			#variables.prefix#comment.*, #variables.prefix#entry.title as entry_title
		FROM	#variables.prefix#comment
		LEFT OUTER JOIN #variables.prefix#entry ON #variables.prefix#comment.entry_id = #variables.prefix#entry.id
		WHERE entry_id = <cfqueryparam value="#arguments.entry_id#" cfsqltype="cf_sql_varchar"/>
		<cfif NOT adminMode>
			AND #variables.prefix#comment.approved = 1
		</cfif>
		ORDER BY created_on
	</cfquery>

	<cfreturn q_comment />
</cffunction>


<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getCount" output="false" hint="Gets the number of comments" access="public" returntype="numeric">
	<cfargument name="blogid" type="string" required="false" default="default" />
	<cfargument name="adminMode" required="false" default="false" type="boolean" hint="Whether to include drafts and future posts"/>
	
	<cfset var q_getCount = "" />

	<cfquery name="q_getCount" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		SELECT count(comment.id) as total
		FROM	#variables.prefix#comment as comment
		LEFT OUTER JOIN #variables.prefix#entry as entry ON comment.entry_id = entry.id
		WHERE entry.blog_id =  <cfqueryparam value="#arguments.blogid#" cfsqltype="cf_sql_varchar"/>
		<cfif NOT adminMode>
			AND comment.approved = 1
		</cfif>
	</cfquery>
	
	<cfreturn q_getCount.total />
	
</cffunction>


<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getBycreated_on" output="false" access="public" returntype="query">
		<cfargument name="created_on" required="true" hint="Date"/>
		<cfargument name="adminMode" required="false" default="false" type="boolean" hint="Whether to include non-approved comments"/>

	<cfset var q_comment = "" />
	
	<cfquery name="q_comment" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		SELECT
			#variables.prefix#comment.*, #variables.prefix#entry.title as entry_title
		FROM	#variables.prefix#comment
		LEFT OUTER JOIN #variables.prefix#entry ON #variables.prefix#comment.entry_id = #variables.prefix#entry.id
		WHERE created_on = <cfqueryparam value="#arguments.created_on#" cfsqltype="CF_SQL_DATETIME"/>
		<cfif NOT adminMode>
			AND #variables.prefix#comment.approved = 1
		</cfif>
	</cfquery>

	<cfreturn q_comment />
</cffunction>

	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getByapproved" output="false" access="public" returntype="query">
		<cfargument name="approved" required="true" type="boolean" default="true" hint="Approved?"/>

	<cfset var q_comment = "" />
	
	<cfquery name="q_comment" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		SELECT
			#variables.prefix#comment.*, #variables.prefix#entry.title as entry_title
		FROM	#variables.prefix#comment
		LEFT OUTER JOIN #variables.prefix#entry ON #variables.prefix#comment.entry_id = #variables.prefix#entry.id
		WHERE approved = <cfqueryparam value="#arguments.approved#" cfsqltype="CF_SQL_BIT"/>
	</cfquery>

	<cfreturn q_comment />
</cffunction>

 
 <!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
 <cffunction name="search" output="false" hint="Search for comments matching the criteria" access="public" returntype="query">
	<cfargument name="entry_id" required="false" type="string" hint="Entry"/>
	<cfargument name="created_since" required="false" hint="Date"/>
	<cfargument name="approved" required="false" type="boolean"  hint="Approved?"/>

	<cfset var q_search = "" />
	
	<cfquery name="q_search" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		SELECT 
			#variables.prefix#comment.*, #variables.prefix#entry.title as entry_title
		FROM	#variables.prefix#comment
		LEFT OUTER JOIN #variables.prefix#entry ON #variables.prefix#comment.entry_id = #variables.prefix#entry.id
		WHERE	0=0
	<cfif IsDate(arguments.created_since)>
		AND #variables.prefix#comment.created_on >= #createODBCDateTime(created_since)#
	</cfif>
	<cfif structkeyexists(arguments,"approved")>
		AND #variables.prefix#comment.approved =  <cfqueryparam value="#arguments.approved#" cfsqltype="CF_SQL_BIT"/>
	</cfif>
	<cfif structkeyexists(arguments,"entry_id")>
		AND #variables.prefix#comment.entry_id =  <cfqueryparam value="#arguments.entry_id#" cfsqltype="cf_sql_varchar"/>
	</cfif>
	
	ORDER BY created_on
	</cfquery>

	<cfreturn q_search />

   </cffunction>

</cfcomponent>