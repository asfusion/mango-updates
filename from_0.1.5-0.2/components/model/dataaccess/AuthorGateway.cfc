<cfcomponent name="author" hint="Gateway for author">

 <!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="init" output="false" returntype="any" hint="instantiates an object of this class" access="public">
	<cfargument name="datasource" required="true" type="struct">
	<cfargument name="cacheMinutes" required="false" default="360" type="numeric" hint="Number of minutes to cache">
		
		<cfset variables.datasource = arguments.datasource />
		<cfset variables.dsn = arguments.datasource.name />
		<cfset variables.cacheMinutes = arguments.cacheMinutes />
		<cfset variables.prefix = arguments.datasource.tablePrefix />
		
		<cfreturn this />
</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getByID" output="false" hint="Gets a query with only one record corresponding tor ID" access="public" returntype="query">
	<cfargument name="id" required="true" type="string" hint="Primary key"/>

	<cfset var q_author = "" />
	
	<cfquery name="q_author" datasource="#variables.dsn#">
		SELECT *
		FROM	#variables.prefix#author
		WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35"/>
	</cfquery>

	<cfreturn q_author />
</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getAll" output="false" hint="Gets all the records" access="public" returntype="query">

	<cfset var q_author = "" />
	
	<cfquery name="q_author" datasource="#variables.dsn#">
		SELECT*
		FROM	#variables.prefix#author
		ORDER BY name		
	</cfquery>

	<cfreturn q_author />
</cffunction>

	
	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getByUsername" output="false" access="public" returntype="query">
		<cfargument name="username" required="true" type="string" hint="Name"/>

	<cfset var q_author = "" />
	
	<cfquery name="q_author" datasource="#variables.dsn#">
		SELECT *
		FROM	#variables.prefix#author
		WHERE username = <cfqueryparam value="#arguments.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50"/>
	</cfquery>

	<cfreturn q_author />
</cffunction>


	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getByAlias" output="false" access="public" returntype="query">
		<cfargument name="alias" required="true" type="string" hint="Alias"/>

	<cfset var q_author = "" />
	
	<cfquery name="q_author" datasource="#variables.dsn#">
		SELECT *
		FROM	#variables.prefix#author
		WHERE alias = <cfqueryparam value="#arguments.alias#" cfsqltype="CF_SQL_VARCHAR" maxlength="100"/>
	</cfquery>

	<cfreturn q_author />
</cffunction>
	
	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getByemail" output="false" access="public" returntype="query">
		<cfargument name="email" required="true" type="string" hint="Email"/>

	<cfset var q_author = "" />
	
	<cfquery name="q_author" datasource="#variables.dsn#">
		SELECT *
		FROM	#variables.prefix#author
		WHERE email = <cfqueryparam value="#arguments.email#" cfsqltype="CF_SQL_VARCHAR" maxlength="255"/>
	ORDER BY name
	</cfquery>

	<cfreturn q_author />
</cffunction>

	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getIdByEmail" output="false" access="public" returntype="string">
		<cfargument name="email" required="true" type="string" hint="Email"/>

	<cfset var q_author = getByemail(arguments.email) />

	<cfif q_author.recordcount>
		<cfreturn q_author.id />
	<cfelse>
		<cfreturn "" />
	</cfif>
	
</cffunction>


</cfcomponent>