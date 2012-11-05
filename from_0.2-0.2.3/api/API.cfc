<cfcomponent hint="Various functions that return structure-type objects">

<cfset variables.apiHelper = createObject("component","APIService") />

	<cffunction name="getUsersBlogs" access="remote" output="false" returntype="array">
		<cfargument name="username" type="String" required="true" />
		<cfargument name="password" type="String" required="true" />
			
			<cfset var blogs = variables.apiHelper.getUsersBlogs(argumentCollection=arguments) />
			<cfset var result = arraynew(1) />
			<cfset var i = 0 />
			
			<cfloop index="i" from="1" to="#arraylen(blogs)#">
				<cfset result[i] = blogs[i].getInstanceData()/>
			</cfloop>
			
		<cfreturn result />
	</cffunction>

	<cffunction name="getRecentPosts" access="remote" output="false" returntype="array">
		<cfargument name="username" type="String" required="true" />
		<cfargument name="password" type="String" required="true" />
		<cfargument name="maxCount" type="numeric" default="0" required="false" />
		<cfargument name="blogid" type="String" required="false" default="1" hint="Ignored" />
					
			<cfset var posts = variables.apiHelper.getRecentPosts(argumentCollection=arguments) />
			<cfset var result = arraynew(1) />
			<cfset var i = 0 />
			
			<cfloop index="i" from="1" to="#arraylen(posts)#">
				<cfset result[i] = posts[i].getInstanceData()/>
			</cfloop>
			
		<cfreturn result />
	</cffunction>	
	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getPost" access="remote" output="false" returntype="struct">
		<cfargument name="username" type="String" required="true" />
		<cfargument name="password" type="String" required="true" />
		<cfargument name="postId" type="String" required="true" />
					
			<cfset var post = variables.apiHelper.getPost(argumentCollection=arguments).getInstanceData() />

		<cfreturn post />
	</cffunction>	
	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="newPost" access="remote" output="false" returntype="string">		
		<cfargument name="username" type="String" required="true" />
		<cfargument name="password" type="String" required="true" />
		<cfargument name="title" type="string" required="true" />
		<cfargument name="content" type="string" required="true" />
		<cfargument name="publish" type="boolean" required="false" default="true" hint="If false, post will be saved as draft" />		
		<cfargument name="blogid" type="String" required="false" default="1" hint="Ignored" />
		
		<cfset var result = variables.apiHelper.newPost(argumentCollection=arguments) />
			<cfif result.message.getStatus() EQ "success">
			<cfreturn result.newPost.getId() />
		<cfelse>
			<cfreturn "">
		</cfif>

	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="editPost" access="remote" output="false" returntype="boolean">		
		<cfargument name="username" type="String" required="true" />
		<cfargument name="password" type="String" required="true" />
		<cfargument name="postId" type="String" required="true" />
		<cfargument name="title" type="string" required="true" />
		<cfargument name="content" type="string" required="true" />
		<cfargument name="publish" type="boolean" required="false" default="true" hint="If false, post will be saved as draft" />		
		
		<cfset var result = variables.apiHelper.editPost(argumentCollection=arguments) />
		<cfreturn (result.message.getStatus() EQ "success") />

	</cffunction>		

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="deletePost" access="remote" output="false" returntype="boolean">		
		<cfargument name="username" type="String" required="true" />
		<cfargument name="password" type="String" required="true" />
		<cfargument name="postId" type="String" required="true" />
		
			<cfset var result = variables.apiHelper.deletePost(argumentCollection=arguments) />
			<cfreturn (result.message.getStatus() EQ "success") />

	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getUserInfo" access="remote" output="false" returntype="struct">
		<cfargument name="username" type="String" required="true" />
		<cfargument name="password" type="String" required="true" />
			
			<cfreturn variables.apiHelper.getUserInfo(argumentCollection=arguments).getInstanceData() />

	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getCategories" access="remote" output="false" returntype="any">
		<cfargument name="username" type="String" required="true" />
		<cfargument name="password" type="String" required="true" />
		<cfargument name="blogid" type="String" required="false" default="1" hint="Ignored" />

			<cfset var categories = variables.apiHelper.getCategories(argumentCollection=arguments) />
			<cfset var result = arraynew(1) />
			<cfset var i = 0 />

			<cfloop index="i" from="1" to="#arraylen(categories)#">
				<cfset result[i] = categories[i].getInstanceData()/>
			</cfloop>

		<cfreturn result />
	</cffunction>


<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="setPostCategories" access="remote" output="false" returntype="boolean">
		<cfargument name="username" type="String" required="true" />
		<cfargument name="password" type="String" required="true" />
		<cfargument name="postId" type="String" required="true" />
		<cfargument name="categories" type="array" required="true" />
	
		<cfset var result = variables.apiHelper.setPostCategories(argumentCollection=arguments) />
		<cfreturn (result.message.getStatus() EQ "success") />
		
	</cffunction>

	
</cfcomponent>