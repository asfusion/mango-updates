<cfcomponent>

<!--- use application to get to main Mango component --->
<cfset variables.blogManager = application.blogFacade.getMango() />
<cfset variables.administrator = variables.blogManager.getAdministrator() />

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="login" access="remote" output="false" returntype="boolean">		
		<cfargument name="username" type="String" required="true" />
		<cfargument name="password" type="String" required="true" />
		
		<cfset var isAuthor = variables.administrator.checkCredentials(arguments.username,arguments.password) />
		<cfset var author = "" />
			
		<cfif isAuthor>
			<cfset author = variables.administrator.getAuthorByUsername(arguments.username) />
			<!--- save this authentication --->
			<cfset variables.blogManager.setCurrentUser(author) />
		</cfif>
			
		<cfreturn isAuthor />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getPage" access="remote" output="false" hint="Throws 'PageNotFound'">
		<cfargument name="name" type="String" required="true" />
		
		<!--- get and return the page --->
		<cfreturn variables.blogManager.getPagesManager().getPageByName(arguments.name, variables.blogManager.isCurrentUserLoggedIn(), false) />
				
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getPosts" access="remote" output="false" returntype="array">
		<cfargument name="from" required="false" default="1" type="numeric" hint=""/>
		<cfargument name="count" required="false" default="0" type="numeric" hint=""/>
		
		<!--- get the posts --->
		<cfreturn variables.blogManager.getPostsManager().getPosts(arguments.from, arguments.count, variables.blogManager.isCurrentUserLoggedIn(), false) />
				
	</cffunction>
	
</cfcomponent>