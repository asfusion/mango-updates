<cfcomponent name="FormHandler">

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="administrator" required="true" type="any">
		<cfargument name="user" required="true" type="any">
		
			<cfset variables.administrator = arguments.administrator>
			<cfset variables.user = arguments.user>
		
		<cfreturn this />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleAddPost" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var data = structnew() />
			<cfset var result = "" />
			<cfset var categories = arraynew(1) />
			
			<cfif structkeyexists(arguments.formFields,"category")>
				<cfset categories = listtoarray(arguments.formFields.category) />
			</cfif>
			
			<cfset data.title = arguments.formFields.title>
			<cfset data.content = arguments.formFields.content>
			<cfif structkeyexists(arguments.formFields,"excerpt")>
				<cfset data.excerpt = arguments.formFields.excerpt>
			</cfif>
			
			<cfif structkeyexists(arguments.formFields,"allowComments")>
				<cfset data.allowComments = true />
			<cfelse>
				<cfset data.allowComments = false />
			</cfif>
			
			<cfif arguments.formFields.publish EQ "published">
				<cfset data.publish = true />
			<cfelse>
				<cfset data.publish = false />
			</cfif>
			
			<!--- add custom fields, make a structure --->
			<cfset data.customFields = structnew() />
			<cfif structkeyexists(arguments.formFields,"totalCustomFields")>
			<cfloop from="1" to="#totalCustomFields#" index="i">
				<cfif structkeyexists(arguments.formFields, "customField_#i#") AND
					structkeyexists(arguments.formFields, "customFieldKey_#i#")>
					<cfset key = arguments.formFields["customFieldKey_#i#"] />
					<cfset data.customFields[key] = structnew() />
					<cfset data.customFields[key].key = key />
					<cfset data.customFields[key].name = arguments.formFields["customFieldName_#i#"] />
					<cfset data.customFields[key].value = arguments.formFields["customField_#i#"] />
				</cfif>
			</cfloop>
			</cfif>
			
			<cfset data.authorId = variables.user.getId() />
			<cfset data.postedOn = arguments.formFields.postedOn />
			
			<cfset result = variables.administrator.newPost(argumentCollection=data) />
			<cfif result.message.getStatus() EQ "success">
				<!--- add categories --->
				<cfset variables.administrator.setPostCategories(result.newPost.getId(), categories) />
			</cfif>
		
		<cfreturn result/>
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleEditPost" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var data = structnew() />
			<cfset var result = "" />
			<cfset var categories = arraynew(1) />
			<cfset var i = 0 />
			<cfset var key = "" />
			
			<cfif structkeyexists(arguments.formFields,"category")>
				<cfset categories = listtoarray(arguments.formFields.category) />
			</cfif>
			
			<cfset data.title = arguments.formFields.title>
			<cfset data.content = arguments.formFields.content>
			<cfif structkeyexists(arguments.formFields,"excerpt")>
				<cfset data.excerpt = arguments.formFields.excerpt>
			</cfif>
			<cfset data.postId = arguments.formFields.id>
			
			<cfif structkeyexists(arguments.formFields,"allowComments")>
				<cfset data.allowComments = true />
			<cfelse>
				<cfset data.allowComments = false />
			</cfif>
			
			<cfif arguments.formFields.publish EQ "published">
				<cfset data.publish = true />
			<cfelse>
				<cfset data.publish = false />
			</cfif>
			
			<cfset data.postedOn = arguments.formFields.postedOn />
			
			<!--- add custom fields, make a structure --->
			<cfset data.customFields = structnew() />
			<cfif structkeyexists(arguments.formFields,"totalCustomFields")>
			<cfloop from="1" to="#totalCustomFields#" index="i">
				<cfif structkeyexists(arguments.formFields, "customField_#i#") AND
					structkeyexists(arguments.formFields, "customFieldKey_#i#")>
					<cfset key = arguments.formFields["customFieldKey_#i#"] />
					<cfset data.customFields[key] = structnew() />
					<cfset data.customFields[key].key = key />
					<cfset data.customFields[key].name = arguments.formFields["customFieldName_#i#"] />
					<cfset data.customFields[key].value = arguments.formFields["customField_#i#"] />
				</cfif>
			</cfloop>
			</cfif>
			
			<cfset result = variables.administrator.editPost(argumentCollection=data) />
			<cfif result.message.getStatus() EQ "success">
				<!--- add categories --->
				<cfset variables.administrator.setPostCategories(result.post.getId(), categories) />
			</cfif>
		
		<cfreturn result/>
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleDeletePost" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var result = "" />
			<cfset result = variables.administrator.deletePost(arguments.formFields.id) />
		
		<cfreturn result/>
	</cffunction>	

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleAddPage" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var data = structnew() />
			<cfset var result = "" />
			
			<cfset data.title = arguments.formFields.title>
			<cfset data.content = arguments.formFields.content>
			<cfif structkeyexists(arguments.formFields,"excerpt")>
				<cfset data.excerpt = arguments.formFields.excerpt>
			</cfif>
			<cfset data.parentPage = arguments.formFields.parentPage>
			<cfset data.template = arguments.formFields.template>
			<cfset data.sortOrder = val(arguments.formFields.sortOrder) />
			
			<cfif structkeyexists(arguments.formFields,"allowComments")>
				<cfset data.allowComments = true />
			<cfelse>
				<cfset data.allowComments = false />
			</cfif>
			
			<cfif arguments.formFields.publish EQ "published">
				<cfset data.publish = true />
			<cfelse>
				<cfset data.publish = false />
			</cfif>
			
			<!--- add custom fields, make a structure --->
			<cfset data.customFields = structnew() />
			<cfif structkeyexists(arguments.formFields,"totalCustomFields")>
			<cfloop from="1" to="#totalCustomFields#" index="i">
				<cfif structkeyexists(arguments.formFields, "customField_#i#") AND
					structkeyexists(arguments.formFields, "customFieldKey_#i#")>
					<cfset key = arguments.formFields["customFieldKey_#i#"] />
					<cfset data.customFields[key] = structnew() />
					<cfset data.customFields[key].key = key />
					<cfset data.customFields[key].name = arguments.formFields["customFieldName_#i#"] />
					<cfset data.customFields[key].value = arguments.formFields["customField_#i#"] />
				</cfif>
			</cfloop>
			</cfif>
			
			<cfset data.authorId = variables.user.getId() />
			
			<cfset result = variables.administrator.newPage(argumentCollection=data) />
		<cfreturn result/>
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleEditPage" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var data = structnew() />
			<cfset var result = "" />

			<cfset data.title = arguments.formFields.title>
			<cfset data.content = arguments.formFields.content>
			<cfif structkeyexists(arguments.formFields,"excerpt")>
				<cfset data.excerpt = arguments.formFields.excerpt>
			</cfif>
			<cfset data.parentPage = arguments.formFields.parentPage>
			<cfset data.template = arguments.formFields.template>
			<cfset data.sortOrder = val(arguments.formFields.sortOrder) />
			<cfset data.pageId = arguments.formFields.id>
			
			<cfif structkeyexists(arguments.formFields,"allowComments")>
				<cfset data.allowComments = true />
			<cfelse>
				<cfset data.allowComments = false />
			</cfif>
			
			<cfif arguments.formFields.publish EQ "published">
				<cfset data.publish = true />
			<cfelse>
				<cfset data.publish = false />
			</cfif>
			
			<!--- add custom fields, make a structure --->
			<cfset data.customFields = structnew() />
			<cfif structkeyexists(arguments.formFields,"totalCustomFields")>
			<cfloop from="1" to="#totalCustomFields#" index="i">
				<cfif structkeyexists(arguments.formFields, "customField_#i#") AND
					structkeyexists(arguments.formFields, "customFieldKey_#i#")>
					<cfset key = arguments.formFields["customFieldKey_#i#"] />
					<cfset data.customFields[key] = structnew() />
					<cfset data.customFields[key].key = key />
					<cfset data.customFields[key].name = arguments.formFields["customFieldName_#i#"] />
					<cfset data.customFields[key].value = arguments.formFields["customField_#i#"] />
				</cfif>
			</cfloop>
			</cfif>
			
			<cfset result = variables.administrator.editPage(argumentCollection=data) />
		
		<cfreturn result/>
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleDeletePage" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var result = "" />
			<cfset result = variables.administrator.deletePage(arguments.formFields.id) />
		
		<cfreturn result/>
	</cffunction>	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleEditBlog" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var data = structnew() />
			<cfset var result = "" />
			<cfset var service = "" />
			
			<cfset data.title = trim(arguments.formFields.title) />
			<cfset data.description = trim(arguments.formFields.description) />
			<cfset data.tagline = trim(arguments.formFields.tagline) />
			<cfset data.url = trim(arguments.formFields.address) />
			<cfset data.user = variables.user />
					
			<cfset result = variables.administrator.editBlog(argumentCollection=data) />
			
		<cfreturn result/>
	</cffunction>	

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleEditSkin" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var data = structnew() />
			<cfset var result = "" />
			<cfset var service = "" />
			
			<cfset data.action = trim(arguments.formFields.action) />
			<cfset data.skin = trim(arguments.formFields.skin) />
			<cfset data.user = variables.user />
					
			<cfset result = variables.administrator.editSkin(argumentCollection=data) />
			
		<cfreturn result/>
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleAddAuthor" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var data = structnew() />
			<cfset var result = "" />
			
			<cfset data.name = arguments.formFields.name>
			<cfset data.username = arguments.formFields.username>
			<cfset data.password = arguments.formFields.password>
			<cfset data.email = arguments.formFields.email>
			<cfset data.description = arguments.formFields.description>
			<cfset data.shortdescription = arguments.formFields.shortdescription>
			
			<cfset result = variables.administrator.newAuthor(argumentCollection=data) />
		
		<cfreturn result/>
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleEditAuthor" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var data = structnew() />
			<cfset var result = "" />
			
			<cfset data.id = arguments.formFields.id>
			<cfset data.name = arguments.formFields.name>
			<cfset data.username = arguments.formFields.username>
			<cfset data.password = arguments.formFields.password>
			<cfset data.email = arguments.formFields.email>
			<cfset data.description = arguments.formFields.description>
			<cfset data.shortdescription = arguments.formFields.shortdescription>
			
			<cfset result = variables.administrator.editAuthor(argumentCollection=data) />
		
		<cfreturn result/>
	</cffunction>
	
<!--- Categories --->
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleAddCategory" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var data = structnew() />
			<cfset var result = "" />
			
			<cfset data.title = arguments.formFields.title>
			<cfset data.description = arguments.formFields.description />
			
			<cfset result = variables.administrator.newCategory(argumentCollection=data) />
		
		<cfreturn result/>
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleEditCategory" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var data = structnew() />
			<cfset var result = "" />
			
			<cfset data.id = arguments.formFields.id>
			<cfset data.title = arguments.formFields.title>
			<cfset data.description = arguments.formFields.description>
			
			<cfset result = variables.administrator.editCategory(argumentCollection=data) />
		
		<cfreturn result/>
	</cffunction>			

<!--- Comments --->
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleAddComment" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var data = structnew() />
			<cfset var result = "" />

			<cfset data.content = arguments.formFields.content />
			<cfset data.creatorName = variables.user.getName() />
			<cfset data.creatorEmail = variables.user.getEmail() />
			<cfset data.creatorUrl = arguments.formFields.creatorUrl />
			<cfset data.entryId = arguments.formFields.entry_id />
			<cfset data.user = variables.user>
			<cfset data.approved = true />

			<cfset result = variables.administrator.newComment(argumentCollection=data) />
		<cfreturn result/>
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleEditComment" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var data = structnew() />
			<cfset var result = "" />
			
			<cfset data.commentId = arguments.formFields.commentId />
			<cfset data.content = arguments.formFields.content />
			<cfset data.creatorName = arguments.formFields.creatorName />
			<cfset data.creatorEmail = arguments.formFields.creatorEmail />
			<cfset data.creatorUrl = arguments.formFields.creatorUrl />
			<cfset data.user = variables.user>
			
			<cfif structkeyexists(arguments.formFields,"approved")>
				<cfset data.approved = true />
			<cfelse>
				<cfset data.approved = false />
			</cfif>

			<cfset result = variables.administrator.editComment(argumentCollection=data) />
		
		<cfreturn result/>
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleDeleteComment" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var result = "" />
			<cfset result = variables.administrator.deleteComment(arguments.formFields.id, variables.user) />
		
		<cfreturn result/>
	</cffunction>	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleActivatePlugin" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var result = structnew() />
			
			<cfif arguments.formFields.action EQ "activate">
				<cfset result = variables.administrator.activatePlugin(formfields.name, formfields.id, variables.user) />
			<cfelseif arguments.formFields.action EQ "deactivate">
				<cfset result = variables.administrator.deactivatePlugin(formfields.name, formfields.id, variables.user) />
			</cfif>
		
		<cfreturn result/>
	</cffunction>	

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="downloadSkin" access="package" output="false" returntype="Any">
		<cfargument name="formFields" type="struct" required="false" />
			
			<cfset var result = structnew() />
			
			<cfset result = variables.administrator.downloadSkin(formfields.skin) />
		
		<cfreturn result/>
	</cffunction>

</cfcomponent>