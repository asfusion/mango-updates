<cfcomponent name="Aministrator">

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="applicationManager" required="true" type="any">

			<cfset variables.blogManager = arguments.applicationManager>
		
		<cfreturn this />
	</cffunction>


	<cffunction name="getUsersBlogs" access="public" output="false" returntype="array">
		<cfargument name="username" type="String" required="true" />

			<cfset var blogsManager = variables.blogManager.getBlogsManager() />
			<cfset var blogs =  ""/>
			<cfset var authorsManager = variables.blogManager.getauthorsManager() />
			<cfset var author =  authorsManager.getAuthorByUsername(arguments.username,true) />
			
			<cfset blogs =  blogsManager.getBlogsByAuthor(author.getId()) />
			
		<cfreturn blogs />
	</cffunction>
	
	<cffunction name="getBlog" access="public" output="false" returntype="any">

			<!--- @TODO get only blogs for user --->
			<cfreturn variables.blogManager.getBlog() />
			
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getAuthors" access="public" output="false" returntype="array">

			<cfset var authorsManager = variables.blogManager.getauthorsManager() />
			<cfset var authors =  authorsManager.getAuthors() />
			
		<cfreturn authors />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getAuthor" access="public" output="false" returntype="any">
		<cfargument name="id" type="String" required="true" />
		
			<cfset var authorsManager = variables.blogManager.getauthorsManager() />
			<cfset var author =  authorsManager.getAuthorById(arguments.id,true) />
			
		<cfreturn author />
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getAuthorByUsername" access="public" output="false" returntype="any">
		<cfargument name="username" type="String" required="true" />
		
			<cfset var authorsManager = variables.blogManager.getauthorsManager() />
			<cfset var author =  authorsManager.getAuthorByUsername(arguments.username,true) />
			
		<cfreturn author />
	</cffunction>	

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getPages" access="public" output="false" returntype="array">
		<cfargument name="from" type="numeric" default="1" required="false" />
		<cfargument name="count" type="numeric" default="0" required="false" />
				
			<cfset var pagesManager = variables.blogManager.getPagesManager() />
			<cfset var pages = pagesManager.getPages(arguments.from,arguments.count,true) />			
		
		<cfreturn pages />
	</cffunction>	

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getRecentPosts" access="public" output="false" returntype="array">
		<cfargument name="maxCount" type="numeric" default="0" required="false" />
				
			<cfset var postsManager = variables.blogManager.getPostsManager() />
			<cfset var posts = postsManager.getPosts(1,arguments.maxCount,true) />			
		
		<cfreturn posts />
	</cffunction>	

	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getPost" access="public" output="false" returntype="any">
		<cfargument name="postId" type="String" required="true" />
					
			<cfset var postsManager = variables.blogManager.getPostsManager() />
			<cfset var post = postsManager.getPostById(arguments.postId,true) />
	
		<cfreturn post />
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getPage" access="public" output="false" returntype="any">
		<cfargument name="pageId" type="String" required="true" />
					
			<cfset var pagesManager = variables.blogManager.getPagesManager() />
			<cfset var page = pagesManager.getPageById(arguments.pageId,true) />
	
		<cfreturn page />
	</cffunction>		
	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="newPost" access="public" output="false" returntype="struct">		
		<cfargument name="title" type="string" required="true" />
		<cfargument name="content" type="string" required="true" />
		<cfargument name="excerpt" type="string" required="false" default="" />
		<cfargument name="publish" type="boolean" required="false" default="true" hint="If false, post will be saved as draft" />		
	<!---	<cfargument name="blogid" type="String" required="false" default="1" hint="" /> --->
		<cfargument name="authorId" type="String" required="false" default="1" hint="" />
		<cfargument name="allowComments" type="boolean" required="false" default="true" hint="" />
		<cfargument name="postedOn" type="string" required="false" default="#now()#" hint="" />
		<cfargument name="user" required="false" type="any">
		
		<!---@TODO add category array as argument --->
		
			<cfset var postsManager = variables.blogManager.getPostsManager() />
			<cfset var authors = variables.blogManager.getAuthorsManager() />
			<cfset var post = variables.blogManager.getObjectFactory().createPost() />
			<cfset var result = "" />

				<!---make a new post --->
				<cfset post.setAuthorId(arguments.authorId) />
				<cfset post.setContent(arguments.content) />
				<cfset post.setTitle(arguments.title) />
				<cfset post.setBlogId(variables.blogManager.getBlog().getId()) />
				<cfset post.setCommentsAllowed(arguments.allowComments) />
				<cfset post.setPostedOn(arguments.postedOn) />
				<cfset post.setExcerpt(arguments.excerpt) />
				
				<cfif arguments.publish>
					<cfset post.setStatus("published") />
				<cfelse>
					<cfset post.setStatus("draft") />
				</cfif>
				
				<!--- @TODO decide what to do with raw data argument --->
				<cfset result = postsManager.addPost(post,structnew()) />

		
		<cfreturn result />
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="editPost" access="public" output="false" returntype="any">		
		<cfargument name="postId" type="String" required="true" />
		<cfargument name="title" type="string" required="true" />
		<cfargument name="content" type="string" required="true" />
		<cfargument name="excerpt" type="string" required="false"  />
		<cfargument name="publish" type="boolean" required="false" default="true" hint="If false, post will be saved as draft" />		
		<cfargument name="allowComments" type="boolean" required="false" hint="" />
		<cfargument name="postedOn" type="string" required="false" hint="When this post is to be published" />
		<cfargument name="user" required="false" type="any">
		
		<!---@TODO add category array as argument --->
		
			<cfset var postsManager = variables.blogManager.getPostsManager() />
			<cfset var post = postsManager.getPostById(arguments.postId,true) />
			<!---<cfset var authorId = 0 /> --->
			<cfset var result = "" />
							
				<!--- populate post --->
				<cfset post.setContent(arguments.content) />
				<cfset post.setTitle(arguments.title) />
				
				<cfif structkeyexists(arguments,"excerpt")>
					<cfset post.setExcerpt(arguments.excerpt) />
				</cfif>
				
				<cfif structkeyexists(arguments,"allowComments")>
					<cfset post.setCommentsAllowed(arguments.allowComments) />
				</cfif>
				
				<cfif structkeyexists(arguments,"postedOn")>
					<cfset post.setPostedOn(arguments.postedOn) />
				</cfif>
				
				<cfif arguments.publish>
					<cfset post.setStatus("published") />
				<cfelse>
					<cfset post.setStatus("draft") />
				</cfif>
				
				<!--- @TODO decide what to do with raw data argument --->
				<cfset result = postsManager.editPost(post,structnew()) />
		
		<cfreturn result />
	</cffunction>		

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="deletePost" access="public" output="false" returntype="any">		
		<cfargument name="postId" type="String" required="true" />
		<cfargument name="user" required="false" type="any">
		
			<cfset var postsManager = variables.blogManager.getPostsManager() />
			<cfset var post = postsManager.getPostById(arguments.postId,true) />
			<cfset var result = "" />			
										
				<!--- populate post --->
				<cfset post.setId(arguments.postId) />

				<!--- @TODO decide what to do with raw data argument --->
				<cfset result = postsManager.deletePost(post,structnew()) />
		
		<cfreturn result />
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="newPage" access="public" output="false" returntype="struct">		
<!---		<cfargument name="blogid" type="String" required="true" /> --->
		<cfargument name="title" type="string" required="true" />
		<cfargument name="content" type="string" required="true" />
		<cfargument name="excerpt" type="string" required="false" default="" />
		<cfargument name="publish" type="boolean" required="false" default="true" hint="If false, post will be saved as draft" />		
		<cfargument name="parentPage" type="string" required="false" default="" />
		<cfargument name="template" type="string" required="false" default="" />
		<cfargument name="sortOrder" type="numeric" required="false" default="1" />
		<cfargument name="authorId" type="String" required="false" default="1" hint="" />
		<cfargument name="allowComments" type="boolean" required="false" default="true" hint="" />
		<cfargument name="user" required="false" type="any">
		
			<cfset var pagesManager = variables.blogManager.getPagesManager() />
			<cfset var page = variables.blogManager.getObjectFactory().createPage() />
			<cfset var result = "" />

				<!---make a new page --->
				<cfset page.setAuthorId(arguments.authorId) />
				<cfset page.setContent(arguments.content) />
				<cfset page.setTitle(arguments.title) />
				<cfset page.setTemplate(arguments.template) />
				<cfset page.setParentPageId(arguments.parentPage) />
				<cfset page.setSortOrder(arguments.sortOrder) />
				<cfset page.setCommentsAllowed(arguments.allowComments) />
				<cfset page.setBlogId(variables.blogManager.getBlog().getId()) />
				<cfset page.setExcerpt(arguments.excerpt) />
				
				<cfif arguments.publish>
					<cfset page.setStatus("published") />
				<cfelse>
					<cfset page.setStatus("draft") />
				</cfif>
				
				<!--- @TODO decide what to do with raw data argument --->
				<cfset result = pagesManager.addPage(page,structnew(),getAuthor(arguments.authorId)) />
		
		<cfreturn result />
	</cffunction>	
	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="editPage" access="public" output="false" returntype="any">		
		<cfargument name="pageId" type="String" required="true" />
		<cfargument name="title" type="string" required="true" />
		<cfargument name="content" type="string" required="true" />
		<cfargument name="excerpt" type="string" required="false" default="" />
		<cfargument name="publish" type="boolean" required="false" default="true" hint="If false, post will be saved as draft" />		
		<cfargument name="parentPage" type="string" required="false" default="" />
		<cfargument name="template" type="string" required="false" default="" />
		<cfargument name="sortOrder" type="numeric" required="false" default="1" />
		<cfargument name="allowComments" type="boolean" required="false" default="true" hint="" />
		<cfargument name="user" required="false" type="any">
		
			<cfset var pagesManager = variables.blogManager.getPagesManager() />
			<cfset var page = pagesManager.getPageById(arguments.pageId,true) />
			<cfset var result = "" />
							
				<!--- populate post --->
				<cfset page.setContent(arguments.content) />
				<cfset page.setTitle(arguments.title) />
				<cfset page.setCommentsAllowed(arguments.allowComments) />
				<cfset page.setSortOrder(arguments.sortOrder) />
				<cfset page.setParentPageId(arguments.parentPage) />
				<cfset page.setExcerpt(arguments.excerpt) />
				<cfset page.setTemplate(arguments.template) />
				
				<cfif arguments.publish>
					<cfset page.setStatus("published") />
				<cfelse>
					<cfset page.setStatus("draft") />
				</cfif>
				
				<!--- @TODO decide what to do with raw data argument --->
				<cfset result = pagesManager.editPage(page,structnew()) />
		
		<cfreturn result />
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="deletePage" access="public" output="false" returntype="any">		
		<cfargument name="pageId" type="String" required="true" />
		<cfargument name="user" required="false" type="any">
		
			<cfset var manager = variables.blogManager.getPagesManager() />
			<cfset var page = manager.getPageById(arguments.pageId,true) />
			<cfset var result = "" />			
										
				<!--- populate post --->
				<cfset page.setId(arguments.pageId) />

				<!--- @TODO decide what to do with raw data argument --->
				<cfset result = manager.deletePage(page,structnew()) />
		
		<cfreturn result />
	</cffunction>	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="newAuthor" access="public" output="false" returntype="struct">		
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		<cfargument name="name" type="string" required="true"  />
		<cfargument name="email" type="string" required="true" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="shortdescription" type="string" required="false" default="" />
		<cfargument name="user" required="false" type="any">
		
			<cfset var authorsManager = variables.blogManager.getauthorsManager() />
			<cfset var author = variables.blogManager.getObjectFactory().createAuthor() />
			<cfset var result = "" />
			<!--- give access to all blogs --->
			<cfset var blogs = variables.blogManager.getBlogsManager().getBlogs() />
			
				<cfset author.setUsername(arguments.username)/>
				<cfset author.setPassword(arguments.password) />
				<cfset author.setName(arguments.name) />
				<cfset author.setEmail(arguments.email) />
				<cfset author.setDescription(arguments.description) />
				<cfset author.setShortDescription(arguments.shortdescription) />
				<cfset author.setBlogs(blogs) />

				<cfset result = authorsManager.addAuthor(author,structnew()) />
		
		<cfreturn result />
	</cffunction>
	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="editAuthor" access="public" output="false" returntype="struct">		
		<cfargument name="id" type="string" required="true" />
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		<cfargument name="name" type="string" required="true"  />
		<cfargument name="email" type="string" required="true" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="shortdescription" type="string" required="false" default="" />
		<cfargument name="user" required="false" type="any">
		
			<cfset var authorsManager = variables.blogManager.getauthorsManager() />
			<cfset var author = getAuthor(arguments.id) />
			<cfset var result = "" />
			<!--- give access to all blogs --->
			<cfset var blogs = variables.blogManager.getBlogsManager().getBlogs() />

				<cfset author.setUsername(arguments.username)/>
				<cfset author.setPassword(arguments.password) />
				<cfset author.setName(arguments.name) />
				<cfset author.setEmail(arguments.email) />
				<cfset author.setDescription(arguments.description) />
				<cfset author.setShortDescription(arguments.shortdescription) />
				<cfset author.setBlogs(blogs) />

				<cfset result = authorsManager.editAuthor(author,structnew()) />
		
		<cfreturn result />
	</cffunction>		
		

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="editBlog" access="public" output="false" returntype="any">		
		<cfargument name="title" type="string" required="true" />
		<cfargument name="tagline" type="string" required="true" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="url" type="string" required="false" default="true" hint="" />		
		<cfargument name="skin" type="string" required="false" default="" hint="" />
		<cfargument name="user" required="false" type="any">

			<cfset var blog = variables.blogManager.getBlog().clone() />
			<cfset var result = "" />
				
				<cfif right(arguments.url,1) NEQ "/">
					<cfset arguments.url = arguments.url & "/">
				</cfif>
								
				<cfset blog.setTagline(arguments.tagline) />
				<cfset blog.setTitle(arguments.title) />
				<cfset blog.setdescription(arguments.description) />
				<cfset blog.setUrl(arguments.url) />
				
				<cfif len(arguments.skin)>
					<cfset blog.setSkin(arguments.skin) />
				</cfif>
				
				<cfset blog.setBasePath(GetPathFromURL(arguments.url)) />
				
				<!--- @TODO decide what to do with raw data argument --->
				<cfset result =  variables.blogManager.getBlogsManager().editBlog(blog,structnew(),structnew(),arguments.user) />
			
				<!--- reload app to see changes in live site --->
				<cfset variables.blogManager.reloadConfig() />
		<cfreturn result />
	</cffunction>		

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="editSkin" access="public" output="false" returntype="any">		
		<cfargument name="skin" type="string" required="true" />
		<cfargument name="action" type="string" required="true" />
		<cfargument name="user" required="false" type="any">
		
		<cfset var blog =  ""/>
		<cfset var result = "" />
		<cfset var dir = getSkinDirectory() />
		
		<cfif action EQ "set">
			<cfset blog = variables.blogManager.getBlog().clone() />
			<cfset blog.setSkin(arguments.skin) />
			<cfset result =  variables.blogManager.getBlogsManager().editBlog(blog,structnew(),structnew(),arguments.user) />
			<cfset variables.blogManager.reloadConfig() />
		<cfelseif action EQ "delete">
			<!--- delete directory --->
			<cfset result = structnew()/>
			<cfset result.message = createObject("component","Message") />
			
			<cfset result.message.setstatus("success") />
			<cfset result.message.setText("Skin deleted") />
			
			<cftry>
				<cfdirectory directory="#dir##skin#" action="delete">
				<cfcatch type="any">
					<cfset result.message.setStatus("error") />
					<cfset result.message.setText(cfcatch.Message) />
				</cfcatch>
			</cftry>
			
			
		</cfif>
				
		<cfreturn result />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="editCategory" access="public" output="false" returntype="any">
		<cfargument name="id" type="String" required="true" />
		<cfargument name="title" type="string" required="true" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="user" required="false" type="any">

			<cfset var category = getCategory(arguments.id) />
			<cfset var result = "" />
				
				<cfset category.setTitle(arguments.title) />
				<cfset category.setdescription(arguments.description) />

				<!--- @TODO decide what to do with raw data argument --->
				<cfset result =  variables.blogManager.getCategoriesManager().editCategory(category,structnew()) />
		
		<cfreturn result />
	</cffunction>


<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="newCategory" access="public" output="false" returntype="any">
		<cfargument name="title" type="string" required="true" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="user" required="false" type="any">

			<cfset var category = variables.blogManager.getObjectFactory().createCategory() />
			<cfset var result = "" />
				
				<cfset category.setTitle(arguments.title) />
				<cfset category.setdescription(arguments.description) />
				<cfset category.setBlogId(variables.blogManager.getBlog().getId()) />

				<!--- @TODO decide what to do with raw data argument --->
				<cfset result =  variables.blogManager.getCategoriesManager().addCategory(category,structnew()) />
		
		<cfreturn result />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<!---	<cffunction name="getUserInfo" access="remote" output="false" returntype="any">
		<cfargument name="username" type="String" required="true" />

			<cfset var author = variables.blogManager.getObjectFactory().createAuthor() />
			<cfset var authors = variables.blogManager.getAuthorsManager() />

				<cfset author = authors.getAuthorByUsername(arguments.username) />

		<cfreturn author />
	</cffunction> --->
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getCategory" access="public" output="false" returntype="any">
		<cfargument name="categoryId" type="String" required="true" />
					
			<cfset var categoriesManager = variables.blogManager.getCategoriesManager() />
			<cfset var categories = categoriesManager.getCategoryById(arguments.categoryId,true) />	
			
		<cfreturn categories />
	</cffunction>		
		
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getCategories" access="public" output="false" returntype="any">
		<cfargument name="blogid" type="String" required="false" default="default" hint="Ignored" />

			<cfset var categoriesManager = variables.blogManager.getCategoriesManager() />
			<cfset var categories = categoriesManager.getCategories("name",true) />	
			
		<cfreturn categories />
	</cffunction>		

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="setPostCategories" access="public" output="false" returntype="any">
		<cfargument name="postId" type="String" required="true" />
		<cfargument name="categories" type="array" required="true" />
		
			<cfset var postsManager = variables.blogManager.getPostsManager() />
			<cfset var categoriesManager = variables.blogManager.getCategoriesManager() />
			<cfset var result = "" />
			<cfset var categoryIds = arraynew(1) />
			<cfset var i = 0 />
			<cfset var category = "" />
			<!--- ensure we are passed category ids --->
			<cfloop from="1" to="#arraylen(arguments.categories)#" index="i">
				<cftry>
					<cfset category = categoriesManager.getCategoryById(arguments.categories[i], true) />
					<cfset arrayappend(categoryIds,category.id) />
				<cfcatch type="any">
					<cftry>
						<cfset category = categoriesManager.getCategoryByName(arguments.categories[i], true) />
						<cfset arrayappend(categoryIds,category.id) />
					<cfcatch type="any"></cfcatch>
					</cftry>
				</cfcatch>
				</cftry>
				
			</cfloop>
			
			<cfset result = postsManager.setPostCategories(arguments.postId, categoryIds) />

		<cfreturn result />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getPostComments" access="public" output="false" returntype="array">
		<cfargument name="entry_id" type="string" required="true" />
				
			<cfset var commentsManager = variables.blogManager.getCommentsmanager() />
			<cfset var comments = commentsManager.getCommentsByPost(arguments.entry_id,true) />			
		
		<cfreturn comments />
	</cffunction>

	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getComment" access="public" output="false" returntype="any">
		<cfargument name="commentId" type="String" required="true" />
					
			<cfset var commentsManager = variables.blogManager.getCommentsManager() />
			<cfset var comment = commentsManager.getCommentById(arguments.commentId,true) />
	
		<cfreturn comment />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="newComment" access="public" output="false" returntype="struct">
		<cfargument name="entryId" type="String" required="true" />
		<cfargument name="content" type="string" required="true" />
		<cfargument name="creatorName" type="string" required="true" />
		<cfargument name="creatorEmail" type="string" required="true" />
		<cfargument name="creatorUrl" type="string" required="false" default="" />		
		<cfargument name="approved" type="string" required="false" default="" />		
		<cfargument name="isImport" required="false" type="boolean" default="false">
		<cfargument name="user" required="false" type="any">
		
			<cfset var commentsManager = variables.blogManager.getCommentsManager() />
			<cfset var comment = variables.blogManager.getObjectFactory().createComment() />
			<cfset var result = "" />
			<cfset var rawdata = structnew() />
			
			<cfset rawdata.isImport = arguments.isImport />

				<!---make a new page --->
				<cfset comment.setEntryId(arguments.entryId) />
				<cfset comment.setContent(arguments.content) />
				<cfset comment.setcreatorName(arguments.creatorName) />
				<cfset comment.setcreatorEmail(arguments.creatorEmail) />
				<cfset comment.setcreatorUrl(arguments.creatorUrl) />
				<cfset comment.setapproved(arguments.approved) />
				
				<!--- @TODO decide what to do with raw data argument --->
				<cfif structkeyexists(arguments,"user")>
					<cfset result = commentsManager.addComment(comment,rawdata,arguments.user) />
				<cfelse>
					<cfset result = commentsManager.addComment(comment, rawdata) />
				</cfif>
		
		<cfreturn result />
	</cffunction>	
	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="editComment" access="public" output="false" returntype="any">		
		<cfargument name="commentId" type="String" required="true" />
		<cfargument name="content" type="string" required="true" />
		<cfargument name="creatorName" type="string" required="true" />
		<cfargument name="creatorEmail" type="string" required="true" />
		<cfargument name="creatorUrl" type="string" required="false" default="" />		
		<cfargument name="approved" type="string" required="false" default="" />
		<cfargument name="user" required="false" type="any">
		
			<cfset var commentsManager = variables.blogManager.getCommentsManager() />
			<cfset var comment = commentsManager.getCommentById(arguments.commentId,true) />
			<cfset var result = "" />
							
				<!--- populate post --->
				<cfset comment.setContent(arguments.content) />
				<cfset comment.setCreatorEmail(arguments.creatorEmail) />
				<cfset comment.setCreatorUrl(arguments.creatorUrl) />
				<cfset comment.setCreatorName(arguments.creatorName) />
				<cfset comment.setApproved(arguments.approved) />
				
				<!--- @TODO decide what to do with raw data argument --->
				<cfset result = commentsManager.editComment(comment,structnew(),arguments.user) />
		
		<cfreturn result />
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="deleteComment" access="public" output="false" returntype="any">		
		<cfargument name="commentId" type="String" required="true" />
		<cfargument name="user" required="false" type="any">
		
			<cfset var manager = variables.blogManager.getCommentsManager() />
			<cfset var comment = ""/>
			<cfset var result = structnew() />
			
			<cftry>
				<cfset comment = manager.getCommentById(arguments.commentId,true) />
				<!--- @TODO decide what to do with raw data argument --->
				<cfset result = manager.deleteComment(comment,structnew(), arguments.user) />
				
				<cfcatch type="any">
					<cfset result.message = createObject("component","Message") />
					<cfset result.message.setStatus("error") />
					<cfset result.message.setText(cfcatch.Message) />
				</cfcatch>
			</cftry>
		
		<cfreturn result />
	</cffunction>	
	

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getSkins" access="public" output="false" returntype="array">

			<cfset var skins = arraynew(1) />
			<cfset var skin = "" />
			<cfset var dirs = "" />
			<cfset var skindata = "" />
			<cfset var skinxmlfile = "" />
			<cfset var dir = getSkinDirectory() />
			
			<cfdirectory name="dirs" directory="#dir#" action="list">
				
				<cfoutput query="dirs">
					<cfset skinxmlfile = directory & "/" & name & "/skin.xml"/>
					<cfif fileexists(skinxmlfile)>
						<cffile action="read" file="#skinxmlfile#" variable="skindata">
						<cfset skindata = xmlparse(skindata).skin />
						<cfset skin = structnew() />
						<cfset skin.name = skindata.xmlAttributes.name />
						<cfset skin.id = skindata.xmlAttributes.id />
						<cfset skin.lastModified = skindata.xmlAttributes.lastModified />
						<cfset skin.version = skindata.xmlAttributes.version />
						<cfset skin.description = skindata.description.xmltext />
						<cfset skin.thumbnail = skindata.thumbnail.xmltext />
						<cfset skin.author = skindata.author.xmltext />
						<cfset skin.authorUrl = skindata.authorUrl.xmltext />
						<cfset skin.designAuthor = skindata.designAuthor.xmltext />
						<cfset skin.designAuthorUrl = skindata.designAuthorUrl.xmltext />
						<cfif structkeyexists(skindata,"requiresVersion")>
						<cfset skin.requiresVersion = skindata.requiresVersion.xmltext />
						<cfelse><cfset skin.requiresVersion = ""></cfif>
						<cfif structkeyexists(skindata,"license")>
						<cfset skin.license = skindata.license.xmltext />
						<cfelse><cfset skin.license = ""></cfif>
						<cfset arrayappend(skins,skin) />
					</cfif>
				</cfoutput>
		<cfreturn skins />
	</cffunction>


<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getPlugins" access="public" output="false" returntype="array">

			<cfset var dir = variables.blogManager.getBlog().getSetting('pluginsDir') & "/user/"/>
			<cfset var allPlugins = createObject("component","PluginLoader").findPlugins(dir) />
			<cfset var activePlugins = arraytolist(variables.blogManager.getPluginQueue().getPluginNames())/>
			<cfset var i = 0/>
			<cfloop from="1" to="#arraylen(allPlugins)#" index="i">
				<cfif listfind(activePlugins,allPlugins[i].id)>
					<cfset allPlugins[i].active = true />
				<cfelse>
					<cfset allPlugins[i].active = false />
				</cfif>
			</cfloop>
			
		<cfreturn allPlugins />
	</cffunction>	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getSkin" access="public" output="false" returntype="any">
		<cfargument name="id" type="String" required="true" />
			<cfset var skin = "" />
			<cfset var skindata = "" />
			<cfset var skinxmlfile = "" />
			<cfset var dir = getSkinDirectory() />
			<cfset var i = 0 />
			<cfset var pagetemplate = "">
			
			<cfset skinxmlfile = dir & "/" & arguments.id & "/skin.xml"/>
				<cffile action="read" file="#skinxmlfile#" variable="skindata">
				<cfset skindata = xmlparse(skindata).skin />
				<cfset skin = structnew() />
				<cfset skin.name = skindata.xmlAttributes.name />
				<cfset skin.id = skindata.xmlAttributes.id />
				<cfset skin.lastModified = skindata.xmlAttributes.lastModified />
				<cfset skin.version = skindata.xmlAttributes.version />
				<cfset skin.description = skindata.description.xmltext />
				<cfset skin.thumbnail = skindata.thumbnail.xmltext />
				<cfset skin.adminEditorCss = skindata.adminEditorCss.xmltext />
				<cfset skin.license = skindata.license.xmltext />
				<cfset skin.pageTemplates = arraynew(1) />
				
				<cfloop from="1" to="#arraylen(skindata.pageTemplates.xmlchildren)#" index="i">
					<cfset pagetemplate = structnew() />
					<cfset pagetemplate.file = skindata.pageTemplates.xmlchildren[i].xmlattributes.file />
					<cfset pagetemplate.name = skindata.pageTemplates.xmlchildren[i].xmlattributes.name />
					<cfif fileexists("#dir#/#arguments.id#/#pagetemplate.file#")>
						<cfset skin.pageTemplates[i] = pagetemplate />
					</cfif>
				</cfloop>

		<cfreturn skin />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="activatePlugin" access="public" output="false" returntype="any">
		<cfargument name="plugin" type="String" required="true" />
		<cfargument name="pluginId" type="String" required="true" />
		<cfargument name="user" required="false" type="any">
			<cfset var blog = variables.blogManager.getBlog()/>
			<cfset var dir = blog.getSetting('pluginsPrefsPath')/>
			<cfset var result = structnew()/>
			<cfset var id = blog.getId()/>
			<cfset var pluginPrefs = createObject("component","utilities.Preferences").init(dir)>
			<cfset var currentlist = pluginPrefs.get(id,"userPlugins","")/>
			<cfset var pluginObj = ""/>
			<cfset var pluginQueue = "" />
			
			<cfset result.message = createObject("component","Message") />
			
			<cfif NOT listfind(currentList,plugin)>
				<cfset currentList = listappend(currentlist,plugin)>
				<cfset pluginPrefs.put(id,"userPlugins", currentList) />
				<cfset variables.blogManager.reloadConfig()/>
				
				<cfset pluginQueue = variables.blogManager.getPluginQueue()>
				
				<!--- see if it was activated correctly --->
				<cfif pluginQueue.pluginExists(arguments.pluginId)>
					<cfset pluginObj = pluginQueue.getPlugin(arguments.pluginId)/>
					
					<cftry>
						<cfset pluginObj.setup()/>
						
						<cfset result.message.setstatus("success") />
						<cfset result.message.settext("Plugin activated")/>
						
						<cfcatch type="any">
							<cfset result.message.setstatus("success") />
							<cfset result.message.settext("Plugin was activated, but it could not be setup: " & cfcatch.Message)/>
						</cfcatch>
					</cftry>
				<cfelse>
					<cfset result.message.setstatus("error") />
					<cfset result.message.settext("Plugin could not be activated")/>
					<!--- revert list --->
					<cfset currentList = listdeleteat(currentlist,listfind(currentlist,plugin))>
					<cfset pluginPrefs.put(id,"userPlugins", currentList) />
					<cfset variables.blogManager.reloadConfig()/>
				</cfif>
						
				<cfset notifyAPI(arguments.user.getUsername(),arguments.user.getPassword())>
				
			<cfelse>
				<cfset result.message.setstatus("error") />
				<cfset result.message.settext("Plugin was already active")/>
			</cfif>
		
		<cfreturn result />
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="deactivatePlugin" access="public" output="false" returntype="any">
		<cfargument name="plugin" type="String" required="true" />
		<cfargument name="pluginId" type="String" required="true" />
		<cfargument name="user" required="false" type="any">
			<cfset var blog = variables.blogManager.getBlog()/>
			<cfset var dir = blog.getSetting('pluginsPrefsPath')/>
			<cfset var result = structnew()/>
			<cfset var id = blog.getId()/>
			<cfset var pluginPrefs = createObject("component","utilities.Preferences").init(dir)>
			<cfset var currentlist = pluginPrefs.get(id,"userPlugins","")/>
			<cfset var pluginObj = ""/>
			
			<cfset result.message = createObject("component","Message") />
			
			<cfif listfind(currentList,plugin)>
				<cfset currentList = listdeleteat(currentlist,listfind(currentlist,plugin))>
				<cfset pluginPrefs.put(id,"userPlugins", currentList) />
				<cfset result.message.setstatus("success") />
				<cfset result.message.settext("Plugin de-activated")/>
				<cfset pluginObj = variables.blogManager.getPluginQueue().getPlugin(arguments.pluginId)/>
				<cfset pluginObj.unsetup()/>
				
				<cfset notifyAPI(arguments.user.getUsername(),arguments.user.getPassword())>
				<cfset variables.blogManager.reloadConfig()/>
			<cfelse>
				<cfset result.message.setstatus("error") />
				<cfset result.message.settext("Plugin was not active")/>
			</cfif>
			
			
		<cfreturn result />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="pluginUpdated" access="public" output="false" returntype="any">
		<cfargument name="plugin" type="String" required="true" />
		<cfargument name="pluginId" type="String" required="true" />
		<cfargument name="user" required="false" type="any">
			
			<cfset notifyAPI(arguments.user.getUsername(),arguments.user.getPassword())>
		
		<cfreturn />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getPageTemplates" access="public" output="false" returntype="array">

			<cfset var templates = "" />
			<cfset var id = variables.blogManager.getBlog().getSkin() />
			<cfset templates = getSkin(id).pageTemplates />
		
			
		<cfreturn templates />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="downloadSkin" access="public" output="false" returntype="struct">
		<cfargument name="skin" type="String" required="true" />
			<cfset var ftp = "" />
			<cfset var connection = "" />
			<cfset var skinInfo = "" />
			<cfset var exists = "">
			<cfset var skinsDir = getSkinDirectory() />
			<cfset var result = structnew()/>
			
			<cfset result.message = createObject("component","Message") />
					
			<cfset result.message.setstatus("success") />
			<cfset result.message.setText("Skin downloaded and available to use") />
			
			<cftry>
				<!--- check if this skin is compatible --->
				<cfinvoke webservice="http://www.mangoblog.org/services/Update.cfc?wsdl" method="getSkinInfo" timeout="5" returnvariable="skinInfo"><cfinvokeargument name="skin" value="#arguments.skin#"></cfinvoke>
				<cfif versionCompare(skinInfo.requiresVersion, variables.blogManager.getVersion()) LT 1>
					<!--- try to get ftp data from web service --->
					<cfinvoke webservice="http://www.mangoblog.org/services/Update.cfc?wsdl" method="getSkinFTP" timeout="5" returnvariable="ftp">
					
					<cftry>
					<!--- open connection and check if it exists --->
					<cfftp connection="connection" server="#ftp.server#"  username="#ftp.username#" 
				password="#ftp.password#" stoponerror="Yes" action="open" passive="true">
					<cfftp action="existsdir" directory="#ftp.directory##arguments.skin#" connection="connection" result="exists">
					<cfif exists.returnValue>
						<!--- download it and  save skin in skin directory --->
						<cfset ftpcopy(ftp.server, ftp.username, ftp.password, "#ftp.directory##arguments.skin#", skinsDir) />
					<cfelse>
						<cfset result.message.setstatus("error") />
						<cfset result.message.setText("Selected skin cannot be found.") />
					</cfif>
						<cfcatch type="any">
							<cfset result.message.setstatus("ftp_error") />
							<cfset result.message.setText(skinInfo.downloadUrl) />
						</cfcatch>
					</cftry>
				<cfelse>
					<cfset result.message.setstatus("error") />
					<cfset result.message.setText("Selected skin requires a newer version of Mango Blog than the one it is installed.") />
				</cfif>
			 
				<cfcatch type="any">
					<cfset result.message.setstatus("error") />
					<cfset result.message.setText(cfcatch.Message) />
				</cfcatch>
			</cftry>
		<cfreturn result />
	</cffunction>				
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="checkCredentials" access="public" output="false" returntype="boolean">
		<cfargument name="username" type="String" required="true" />
		<cfargument name="password" type="String" required="true" />
		<cfargument name="soft" type="boolean" required="false" default="false" />
		
			<cfset var authors = variables.blogManager.getAuthorsManager() />
			<cfif NOT arguments.soft>
				<cfreturn authors.checkCredentials(arguments.username,arguments.password) />
			<cfelse>
				<cfreturn authors.checkSoftCredentials(arguments.username,arguments.password) />
			</cfif>
	</cffunction>		

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="notifyAPI" access="public" output="true" returntype="void">
		<cfargument name="username" type="String" required="true" />
		<cfargument name="password" type="String" required="true" />
		<cfargument name="event" type="String" required="false" default="configChanged" />
		
			<cftry>
			<cfinvoke webservice="#variables.blogManager.getBlog().getUrl()#api/APIService.cfc?wsdl" method="dataUpdated" timeout="1">
				<cfinvokeargument name="username" value="#arguments.username#">
				<cfinvokeargument name="password" value="#arguments.password#">
				<cfinvokeargument name="event" value="#arguments.event#">
			</cfinvoke>
			<cfcatch type="any"><cfoutput>Could not call webservice</cfoutput></cfcatch>
			</cftry>
	</cffunction>	
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getSkinDirectory" access="public" output="true" returntype="string">
		<cfset var dir = variables.blogManager.getBlog().getSetting('skinsDirectory') />
		<cfif NOT len(dir)>
			<!--- use default --->
			<cfset dir = replacenocase(GetDirectoryFromPath(GetCurrentTemplatePath()),"components","skins") />
		</cfif>
		<cfreturn dir />
	</cffunction>	


<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="ftpcopy" access="private" output="false">
		<cfargument name="server" required="true" type="any">
		<cfargument name="username" required="true" type="string">
		<cfargument name="password" required="true" type="string">
		<cfargument name="dir" required="true" type="any">
		<cfargument name="localdir" required="true" type="string">
		
		<cfset var dirs = "" />
		
		<!--- create local dir if needed --->
		<cfif NOT directoryExists(arguments.localdir & arguments.dir)>
			<cfdirectory action="create" directory="#arguments.localdir##arguments.dir#">
		</cfif>
		
		<cfftp server="#arguments.server#"  username="#arguments.username#"  passive="true"
				password="#arguments.password#" action="listdir" name="dirs" directory="#arguments.dir#">
				
		<cfoutput query="dirs">
			<cfif isDirectory>
				<!--- copy folder --->
				<cfset ftpcopy(arguments.server, arguments.username, arguments.password,
						Path, arguments.localdir)>
			<cfelse>
				<!--- copy file --->
				<cfftp server="#arguments.server#"  username="#arguments.username#" 
				password="#arguments.password#"  passive="true"
				action="getFile" localfile="#arguments.localdir##path#"
				remotefile="#path#"
 				failifexists="No">
			</cfif>
			
		</cfoutput>
		
	</cffunction>
	

	<cfscript>
/**
 * Returns the path from a specified URL.
 * 
 * @param this_url 	 URL to parse. 
 * @return Returns a string. 
 * @author Shawn Seley (shawnse@aol.com) 
 * @version 1, February 21, 2002 
 */
function GetPathFromURL(this_url) {
	var first_char        = "";
	var re_found_struct   = "";
	var path              = "";
	var i                 = 0;
	var cnt               = 0;
	
	this_url = trim(this_url);
	
	first_char = Left(this_url, 1);
	if (Find(first_char, "./")) {
		// relative URL (ex: "../dir1/filename.html" or "/dir1/filename.html")
		re_found_struct = REFind("[^##\?]+", this_url, 1, "True");
	} else if(Find("://", this_url)){
		// absolute URL    (ex: "ftp://user:pass@ftp.host.com")
		re_found_struct = REFind("/[^##\?]*", this_url, Find("://", this_url)+3, "True");
	} else {
		// abbreviated URL (ex: "user:pass@ftp.host.com")
		re_found_struct = REFind("/[^##\?]*", this_url, 1, "True");
	}
	
	if (re_found_struct.pos[1] GT 0)  {
		// get path with filename (if exists)
		path = Mid(this_url, re_found_struct.pos[1], re_found_struct.len[1]);
		
		// chop off the filename
 		if(find("/", path)) {
			i = len(path) - find("/" ,reverse(path)) +1;
			cnt = len(path) -i;
			if (cnt LT 1) cnt =1;
			if (REFind("[^##\?]+\.[^##\?]+", Right(path, cnt))){
				// if the part after the last slash is a file name then chop it off
				path = Left(path, i);
			}
		}
		return path;
	} else {
		return "";
	}
}

/**
 * Returns the host from a specified URL.
 * RE fix for MX, thanks to Tom Lane
 * 
 * @param this_url 	 URL to parse. (Required)
 * @return Returns a string. 
 * @author Shawn Seley (shawnse@aol.com) 
 * @version 2, August 23, 2002 
 */
function GetHostFromURL(this_url) {
	var first_char       = "";
	var re_found_struct  = "";
	var num_expressions  = 0;
	var num_dots         = 0;
	var this_host        = "";
	
	this_url = trim(this_url);
	
	first_char = Left(this_url, 1);
	if (Find(first_char, "./")) {
		return "";   // relative URL = no host   (ex: "../dir1/filename.html" or "/dir1/filename.html")
	} else if(Find("://", this_url)){
		// absolute URL    (ex: "pass@ftp.host.com">ftp://user:pass@ftp.host.com")
		re_found_struct = REFind("[^@]*@([^/:\?##]+)|([^/:\?##]+)", this_url, Find("://", this_url)+3, "True");
	} else {
		// abbreviated URL (ex: "user:pass@ftp.host.com")
		re_found_struct = REFind("[^@]*@([^/:\?##]+)|([^/:\?##]+)", this_url, 1, "True");
	}
	
	if (re_found_struct.pos[1] GT 0) {
		num_expressions = ArrayLen(re_found_struct.pos);
                if(re_found_struct.pos[num_expressions] is 0) num_expressions = num_expressions - 1;
		this_host = Mid(this_url, re_found_struct.pos[num_expressions], re_found_struct.len[num_expressions]);
		num_dots = (Len(this_host) - Len(Replace(this_host, ".", "", "ALL")));;
		if ((not FindOneOf("/@:", this_url)) and (num_dots LT 2)){
			// since this URL doesn't contain any "/" or "@" or ":" characters and since the "host" has fewer than two dots (".")
			// then it is probably actually a file name
			return ""; 
		}
		return this_host;
	} else {
		return "";
	}
}
</cfscript>

<cffunction name="versionCompare" returntype="numeric" access="public">
	<cfargument name="version1">
	<cfargument name="version2">

	<cfset var len1 = listlen(arguments.version1,".") />
	<cfset var len2 = listlen(arguments.version2,".") />
	<cfset var i = 0/>
	<cfset var piece1 = ""/>
	<cfset var piece2 = ""/>
	
	<cfif len1 GT len2>
		<cfset arguments.version2 = arguments.version2 & repeatstring(".0",len1-len2) />
	</cfif>
	
	<cfif len1 LT len2>
		<cfset arguments.version1 = arguments.version1 & repeatstring(".0",len2-len1) />
	</cfif>
	
	<cfloop from="1" to="#listlen(arguments.version1,".")#" index="i">
		<cfset piece1 = listgetat(arguments.version1,i,".")/>
		<cfset piece2 = listgetat(arguments.version2,i,".")/>
		
		<cfif piece1 NEQ piece2>
			<!--- we need to compare --->
			<cfif piece1 GT piece2>
				<cfreturn 1/>
			<cfelse>
				<cfreturn -1/>
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- they were equal --->
	<cfreturn 0/>
	
</cffunction>

</cfcomponent>
