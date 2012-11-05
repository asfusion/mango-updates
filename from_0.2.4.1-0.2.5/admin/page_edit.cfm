<cfsilent>
	<cfparam name="id" default="0" />		
	<cfparam name="title" default="" />
	<cfparam name="content" default="" />
	<cfparam name="excerpt" default="" />
	<cfparam name="error" default="" />
	<cfparam name="message" default="" />
	<cfparam name="sortOrder" default="1" />
	<cfparam name="template" default="page.cfm" />
	<cfparam name="allowComments" default="false" />
	<cfparam name="publish" default="published" />
	<cfparam name="parent" default="" />
	<cfparam name="customFields" default="#arraynew(1)#">
	
	<cfset templates = request.administrator.getPageTemplates() />
	
	<!--- get pages --->
	<cfset pages = request.administrator.getPages() />
	
	<cfif structkeyexists(form,"submit")>
		<cfset result = request.formHandler.handleEditPage(form) />
		<cfif result.message.getStatus() EQ "success">
			<cfset message = result.message.getText() />
		<cfelse>
			<cfset error = result.message.getText() />
		</cfif>
	</cfif>
	
	<!--- get post by id --->
	<cfif NOT len(error)>
	<cftry>
		<cfset page = request.administrator.getPage(id) />
		<!--- send event to give opportunity to plugins to pre-populate a default page --->
		<cfset args = structnew() />
		<cfset args.item = page />
		<cfset args.formName = "pageForm" />
		<cfset args.request = request />
		<cfset args.formScope = form />
		<cfset args.status = "update" />
		<cfset pluginQueue = request.blogManager.getpluginQueue() />
		<cfset event = pluginQueue.createEvent("beforeAdminPageFormDisplay",args,"AdminForm") />
		<cfset event = pluginQueue.broadcastEvent(event) />
		
		<cfset page = event.item />

		<!--- also create the event that will be used to show extra data at the end of the form --->
		<cfset event = pluginQueue.createEvent("beforeAdminPageFormEnd",args,"AdminForm") />
		<cfset event = pluginQueue.broadcastEvent(event) />
		
		<cfset title = page.getTitle() />
		<cfset content = page.getContent() />
		<cfset excerpt = page.getExcerpt() />
		<cfset allowComments = page.getCommentsAllowed() />
		<cfset publish = page.getStatus() />
		<cfset parent = page.getParentPageId() />
		<cfset template = page.getTemplate() />
		<cfset sortOrder = page.getSortOrder() />
		<cfset customFields = page.getCustomFieldsAsArray() />

	<cfcatch type="any">
		<cfset error = cfcatch.message />
	</cfcatch>
	</cftry> 
	</cfif>
	
</cfsilent>

<cf_layout page="Pages">
<div id="wrapper">
	<div id="submenucontainer">
		<ul id="submenu">
			<li><a href="page_new.cfm">New</a></li>	
			<li><a href="pages.cfm" class="current">Edit</a></li>
		</ul>
	</div>
	
	<div id="content">
		<h2 class="pageTitle">Editing page: "<cfoutput>#title#</cfoutput>"</h2>
		
		<div id="innercontent">
		<cfif len(error)>
			<p class="error"><cfoutput>#error#</cfoutput></p>
		</cfif>
		<cfif len(message)>
			<p class="message"><cfoutput>#message#</cfoutput></p>
		</cfif>
		
		<cfinclude template="pageForm.cfm">
		
		</div>
	</div>
</div>


</cf_layout>