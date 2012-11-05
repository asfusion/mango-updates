<cfsilent>
	<cfimport prefix="mangoAdmin" taglib="tags">
	<cfparam name="id" default="" />		
	<cfparam name="title" default="" />		
	<cfparam name="description" default="" />
	<cfparam name="error" default="" />
	<cfparam name="message" default="" />	
	<cfparam name="mode" default="new" />
		
	<cfset pagetitle = "New category" />
	<cfset currentAuthor = request.blogManager.getCurrentUser() />
	<cfset preferences = currentAuthor.currentRole.preferences.get("admin","menuItems","") />
	
	<cfif id NEQ "">
		<cfset mode = "update" />
	</cfif>
	
	<cfif structkeyexists(form,"submit")>
		<cfif mode EQ "update">
			<cfset result = request.formHandler.handleEditCategory(form) />
		<cfelse>
			<cfset result = request.formHandler.handleAddCategory(form) />
		</cfif>		
		<cfif result.message.getStatus() EQ "success">
			<cfset message = result.message.getText() />
		<cfelse>
			<cfset error = result.message.getText() />
		</cfif>
	</cfif>
	
	<!--- get post by id --->
	<cfif NOT len(error)>
		<cfif mode EQ "update">
		<cftry>
			<cfset category = request.administrator.getCategory(id) />
			<cfset title = category.getTitle() />
			<cfset description = category.getdescription() />
			<cfset pagetitle = 'Editing category: "#title#"'>
			
			<cfcatch type="any">
				<cfset error = cfcatch.message />
			</cfcatch>
		</cftry>
	</cfif>
	</cfif>
	
</cfsilent>
<cf_layout page="Categories" title="Categories">
<div id="wrapper">
<cfif listfind(currentAuthor.currentRole.permissions, "manage_categories")>
	<div id="submenucontainer">
		<ul id="submenu">
			<cfif NOT len(preferences) OR listfind(preferences,"categories_new")>
			<li><a href="category.cfm"<cfif mode EQ "new"> class="current"</cfif>>New Category</a></li>
			</cfif>	
			<li><a href="categories.cfm"<cfif mode EQ "update"> class="current"</cfif>>Edit Category</a></li>
			<mangoAdmin:MenuEvent name="categoriesNav" />
		</ul>
	</div>
	
	<div id="content">
		<h2 class="pageTitle"><cfoutput>#pagetitle#</cfoutput></h2>
		
		<div id="innercontent">
		<cfif len(error)>
			<p class="error"><cfoutput>#error#</cfoutput></p>
		</cfif>
		<cfif len(message)>
			<p class="message"><cfoutput>#message#</cfoutput></p>
		</cfif>
		
		<cfoutput><form method="post" action="#cgi.SCRIPT_NAME#" name="categoryForm" id="categoryForm">
 
<div class="widget">
<input type="hidden" name="id" value="#id#">
    <fieldset id="categoryFieldset" class="">
      <legend>Category</legend>
      <label for="title" id="title-L" class="preField">Title <span class="reqMark">*</span></label>
      <input type="text" id="title" name="title" value="#title#" size="" class="required"/>
      <br/>
      <div class="field-hint-inactive" id="wf_Description-H">
        <div>What this category is about. Whether or not this is shown in the blog depends on the skin used</div>
      </div>
      <label for="description" id="description-L" class="preField">Description</label>
      <textarea cols="30" rows="2" id="description" name="description" class="">#description#</textarea>
      <br/>
    </fieldset>
    <div class="actions">
      <input type="submit" class="primaryAction" id="submit" name="submit" value="Save"/>
    </div>
  </div>
</form></cfoutput>
		</div>
	</div>
<cfelse><!--- not authorized --->
<div id="content"><div id="innercontent">
<p class="message">Your role does not allow you to edit categories</p>
</div></div>
</cfif>
</div>

</cf_layout>