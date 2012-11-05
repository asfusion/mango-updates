<cfsilent>
	<cfparam name="id" default="0" />		
	<cfparam name="title" default="" />
	<cfparam name="content" default="" />
	<cfparam name="excerpt" default="" />
	<cfparam name="postedOn" default="#dateformat(now(),'mm/dd/yy')# #timeformat(now(),'medium')#" />
	<cfparam name="error" default="" />
	<cfparam name="message" default="" />
	<cfparam name="allowComments" default="true" />
	<cfparam name="publish" default="published" />
	<cfparam name="categoriesList" default="">
	<cfparam name="customFields" default="#arraynew(1)#">
	
	<cfif structkeyexists(form,"submit")>
		<cfset result = request.formHandler.handleEditPost(form) />
		<cfif result.message.getStatus() EQ "success">
			<cfset message = result.message.getText() />
		<cfelse>
			<cfset error = result.message.getText() />
		</cfif>
	</cfif>
	
	<!--- get post by id --->
	<cfif NOT len(error)>
	<cftry>
		<cfset post = request.administrator.getPost(id) />

		<!--- send event to give opportunity to plugins to pre-populate the post --->
		<cfset args = structnew() />
		<cfset args.item = post />
		<cfset args.formName = "postForm" />
		<cfset args.request = request />
		<cfset args.formScope = form />
		<cfset args.status = "update" />
		<cfset pluginQueue = request.blogManager.getpluginQueue() />
		<cfset event = pluginQueue.createEvent("beforeAdminPostFormDisplay",args,"AdminForm") />
		<cfset event = pluginQueue.broadcastEvent(event) />
		
		<cfset post = event.item />
		
		<!--- also create the event that will be used to show extra data at the end of the form --->
		<cfset event = pluginQueue.createEvent("beforeAdminPostFormEnd",args,"AdminForm") />
		<cfset event = pluginQueue.broadcastEvent(event) />
		
		<cfset title = post.getTitle() />
		<cfset content = post.getContent() />
		<cfset excerpt = post.getExcerpt() />
		<cfset allowComments = post.getCommentsAllowed() />
		<cfset publish = post.getStatus() />
		<cfset postedOn = dateformat(post.getPostedOn(),'short') & " " & timeformat(post.getPostedOn(),'medium') />
		<cfset categories = post.getCategories() />
		<cfset categoriesList = "" />
		<cfset customFields = post.getCustomFieldsAsArray() />
				
		<cfloop from="1" to="#arraylen(categories)#" index="i">
			<cfset categoriesList = listappend(categoriesList,categories[i].getId()) />
		</cfloop>
		
	<cfcatch type="any">
		<cfset error = cfcatch.message />
	</cfcatch>
	</cftry>
	
	</cfif>
	<!--- get categories --->
	<cfset categories = request.administrator.getCategories() />

	
</cfsilent>
<cf_layout page="Posts">
	
<div id="wrapper">
	<div id="submenucontainer">
		<ul id="submenu">
			<li><a href="post_new.cfm">New</a></li>	
			<li><a href="posts.cfm" class="current">Edit</a></li>
		</ul>
	</div>
	
	<div id="content">
		<h2 class="pageTitle">Editing post: "<cfoutput>#title#</cfoutput>"</h2>
		
		<div id="innercontent">
		<cfif len(error)>
			<p class="error"><cfoutput>#error#</cfoutput></p>
		</cfif>
		<cfif len(message)>
			<p class="message"><cfoutput>#message#</cfoutput></p>
		</cfif>
		
		<cfinclude template="postForm.cfm">
		
		</div>
	</div>
</div>

</cf_layout>