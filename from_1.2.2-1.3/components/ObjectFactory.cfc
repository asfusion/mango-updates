<cfcomponent name="ObjectFactory">
	
	<cfscript>
		variables.commentObjectPath = "model.Comment";
		variables.postObjectPath = "model.Post";
		variables.categoryObjectPath = "model.Category";
		variables.authorObjectPath = "model.Author";
		variables.pageObjectPath = "model.Page";
		variables.entryObjectPath = "model.Entry";
		variables.blogObjectPath = "model.Blog";
		variables.archiveObjectPath = "model.Archive";
		variables.roleObjectPath = "model.Role";
		variables.messageObjectPath = "Message";
		variables.permissionObjectPath = "model.Permission";
		variables.credentialObjectPath = "model.Credential";
	</cfscript>
	
	<cffunction name="createBlog" access="public" output="false" returntype="Any">
		<cfreturn CreateObject("component", variables.blogObjectPath )/>
	</cffunction>
	
	<cffunction name="createComment" access="public" output="false" returntype="Any">
		<cfreturn CreateObject("component", variables.commentObjectPath )/>
	</cffunction>
	
	<cffunction name="createPage" access="public" output="false" returntype="Any">
		<cfreturn CreateObject("component", variables.pageObjectPath )/>
	</cffunction>

	<cffunction name="createPost" access="public" output="false" returntype="Any">
		<cfreturn CreateObject("component", variables.postObjectPath )/>
	</cffunction>
	
	<cffunction name="createEntry" access="public" output="false" returntype="Any">
		<cfreturn CreateObject("component", variables.entryObjectPath )/>
	</cffunction>

	<cffunction name="createAuthor" access="public" output="false" returntype="Any">
		<cfreturn CreateObject("component", variables.authorObjectPath )/>
	</cffunction>

	<cffunction name="createCategory" access="public" output="false" returntype="Any">
		<cfreturn CreateObject("component", variables.categoryObjectPath )/>
	</cffunction>
	
	<cffunction name="createArchive" access="public" output="false" returntype="Any">
		<cfreturn CreateObject("component", variables.archiveObjectPath )/>
	</cffunction>
	
	<cffunction name="createMessage" access="public" output="false" returntype="Any">
		<cfreturn CreateObject("component", variables.messageObjectPath )/>
	</cffunction>
	
	<cffunction name="createRole" access="public" output="false" returntype="Any">
		<cfreturn CreateObject("component", variables.roleObjectPath )/>
	</cffunction>
	
	<cffunction name="createPermission" access="public" output="false" returntype="Any">
		<cfreturn CreateObject("component", variables.permissionObjectPath )/>
	</cffunction>
	
	<cffunction name="createCredential" access="public" output="false" returntype="Any">
		<cfreturn CreateObject("component", variables.credentialObjectPath )/>
	</cffunction>	
	
</cfcomponent>