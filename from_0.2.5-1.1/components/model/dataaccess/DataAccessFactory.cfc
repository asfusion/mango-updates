<cfcomponent name="DataAccessFactory" hint="Hub for all components to get the object instances">

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="init" output="false" returntype="any" hint="instantiates an object of this class" access="public">
	<cfargument name="datasource" required="true" type="struct">
	<cfargument name="cacheGateways" required="false" default="false" type="boolean">
	
			<cfset variables.datasource = arguments.datasource />
			<cfset variables.cacheGateways = false />
			<cfset variables.dbtype = arguments.datasource.type />
			
			<!--- cache gateways if necessary --->
			<cfif arguments.cacheGateways>
				<cfset variables.gateways = structnew()/>
				<cfset variables.gateways["pages"] = getPagesGateway() />
				<cfset variables.gateways["subscription"] = getsubscriptionGateway() />
				<cfset variables.gateways["category"] = getCategoriesGateway() />
				<cfset variables.gateways["posts"] = getPostsGateway() /> 
				<cfset variables.gateways["author"] = getAuthorsGateway() /> 
				<cfset variables.gateways["roles"] = getRolesGateway() /> 
				<cfset variables.cacheGateways = true />
			</cfif>

	<cfreturn this />
</cffunction>


<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getauthorManager" output="false" access="public" hint="Gets the manager of author"> 
	<cfset var obj = "" />
	<cfset obj = createObject("component","AuthorDAO") />
	<cfset obj.init(variables.datasource) />
	<cfreturn obj />
</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getAuthorsGateway" output="false" access="public" hint="Gets the manager of author"> 
	<cfset var obj = "" />
	
	<cfif NOT variables.cacheGateways>
		<cfset obj = createObject("component","AuthorGateway").init(variables.datasource)  />
	<cfelse>
		<cfset obj = variables.gateways["author"]>
	</cfif>
	<cfreturn obj />	

</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getcategoryManager" output="false" access="public" hint="Gets the manager of category"> 
	<cfset var obj = "" />
		<cfset obj = createObject("component","CategoryDAO") />
	<cfset obj.init(variables.datasource) />
	<cfreturn obj />
</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getCategoriesGateway" output="false" access="public" hint="Gets the manager of category"> 
	<cfset var obj = "" />
	
	<cfif NOT variables.cacheGateways>
		<cfset obj = createObject("component","CategoryGateway").init(variables.datasource)  />
	<cfelse>
		<cfset obj = variables.gateways["category"]>
	</cfif>
	<cfreturn obj />	

</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getCommentsManager" output="false" access="public" hint="Gets the manager of comment"> 
	<cfset var obj = "" />
		<cfset obj = createObject("component","CommentDAO") />
	
	<cfset obj.init(variables.datasource) />
	<cfreturn obj />
</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getCommentsGateway" output="false" access="public" hint="Gets the manager of comment"> 
	<cfset var obj = "" />
	
	<cfif NOT variables.cacheGateways>
		<cfset obj = createObject("component","CommentGateway").init(variables.datasource)  />
	<cfelse>
		<cfset obj = variables.gateways["comment"]>
	</cfif>
	<cfreturn obj />	

</cffunction>


<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getPostManager" output="false" access="public" hint="Gets the manager of post"> 
	<cfset var obj = "" />
		<cfset obj = createObject("component","PostDAO") />

	<cfset obj.init(variables.datasource) />
	<cfreturn obj />
</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getPostsGateway" output="false" access="public" hint="Gets the manager of post"> 
	<cfset var obj = "" />
	
	<cfif NOT variables.cacheGateways>
		<cfset obj = createObject("component","PostsGateway").init(variables.datasource)  />
	<cfelse>
		<cfset obj = variables.gateways["posts"]>
	</cfif>
	<cfreturn obj />	

</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getPageManager" output="false" access="public" hint="Gets the manager of pages"> 
	<cfset var obj = createObject("component","PageDAO") />
	<cfset obj.init(variables.datasource) />
	<cfreturn obj />
</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getPagesGateway" output="false" access="public" hint="Gets the manager of post"> 
	<cfset var obj = "" />
	
	<cfif NOT variables.cacheGateways>
		<cfset obj = createObject("component","PageGateway").init(variables.datasource)  />
	<cfelse>
		<cfset obj = variables.gateways["pages"]>
	</cfif>
	<cfreturn obj />	

</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getRoleManager" output="false" access="public" hint="Gets the manager of roles"> 
	<cfset var obj = createObject("component","RoleDAO") />
	<cfset obj.init(variables.datasource) />
	<cfreturn obj />
</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getRolesGateway" output="false" access="public" hint="Gets the manager of post"> 
	<cfset var obj = "" />
	
	<cfif NOT variables.cacheGateways>
		<cfset obj = createObject("component","RoleGateway").init(variables.datasource)  />
	<cfelse>
		<cfset obj = variables.gateways["roles"]>
	</cfif>
	<cfreturn obj />	

</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getblogManager" output="false" access="public" hint="Gets the manager of blog"> 
	<cfset var obj = "" />
	
		<cfset obj = createObject("component","BlogDAO") />
	
	<cfset obj.init(variables.datasource) />
	<cfreturn obj />
</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="getblogGateway" output="false" access="public" hint="Gets the manager of blog"> 
	<cfset var obj = "" />
	
	<cfif NOT variables.cacheGateways>
		<cfset obj = createObject("component","BlogGateway").init(variables.datasource)  />
	<cfelse>
		<cfset obj = variables.gateways["blog"]>
	</cfif>
	<cfreturn obj />	

</cffunction>

</cfcomponent>