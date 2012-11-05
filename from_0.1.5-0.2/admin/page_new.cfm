<cfsilent>
	<cfparam name="id" default="" />		
	<cfparam name="title" default="" />
	<cfparam name="content" default="" />
	<cfparam name="excerpt" default="" />
	<cfparam name="error" default="" />
	<cfparam name="message" default="" />
	<cfparam name="allowComments" default="false" />
	<cfparam name="publish" default="published" />
	<cfparam name="template" default="" />
	<cfparam name="sortOrder" default="1" />

	
	<cfset templates = request.administrator.getPageTemplates() />
	
	<cfif structkeyexists(form,"submit")>
		<cfset result = request.formHandler.handleAddPage(form) />
		<cfif result.message.getStatus() EQ "success">
			<cfset message = result.message.getText() />
			<cfset id = "" />
			<cfset title = "" />
			<cfset content = "" />
			<cfset excerpt = "" />
			<cfset allowComments = false />
			<cfset publish = "published" />
			<cfset template = "" />
			<cfset sortOrder = 1 />
		<cfelse>
			<cfset error = result.message.getText() />
		</cfif>
	</cfif>
	
			
	<!--- get pages --->
	<cfset pages = request.administrator.getPages() />
	
</cfsilent>
<cf_layout page="Pages">	
<div id="wrapper">
	<div id="submenucontainer">
		<ul id="submenu">
			<li><a href="page_new.cfm"  class="current">New</a></li>	
			<li><a href="pages.cfm">Edit</a></li>
		</ul>
	</div>
	
	<div id="content">
		<h2 class="pageTitle">New page</h2>
		
		<div id="innercontent">
		<cfif len(error)>
			<p class="error"><cfoutput>#error#</cfoutput></p>
		</cfif>
		<cfif len(message)>
			<p class="message"><cfoutput>#message#</cfoutput></p>
		</cfif>

<cfoutput><form method="post" action="#cgi.SCRIPT_NAME#" name="wf_Newpost" id="wf_Newpost">
  <div class="widget">
    <fieldset id="wf_Post" class="">
      <legend>Page</legend>
      <label for="wf_Title" id="wf_Title-L" class="preField">Title
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Title" name="title" value="#title#" size="50" class="none required"/>
      <br/>
      <label for="contentField" id="content-L" class="preField">Content
						 <span class="reqMark">*</span></label>
      <textarea cols="50" rows="20" id="contentField" name="content" class="none required"  style="width: 100%">#htmleditformat(content)#</textarea>
      <br/>
      <div class="field-hint-inactive" id="wf_Excerpt1-H">
        <div>Short summary describing post</div>
      </div>
      <label for="wf_Excerpt1" id="wf_Excerpt1-L" class="preField">Excerpt</label>
      <textarea cols="50" rows="5" id="wf_Excerpt1" name="excerpt" class="none"  style="width: 100%">#htmleditformat(excerpt)#</textarea>
      <br/>
      <div class="field-hint-inactive" id="wf_Allowcomments2-H">
        <div>Whether or not reader comments are permitted for this post</div>
      </div>
      <span class="label preField">Allow comments?</span>
      <span class="oneChoice">
        <input type="checkbox" value="yes" id="allowComments" name="allowComments" <cfif allowComments>checked="checked"</cfif>/>
        <label for="allowComments" id="allowComments-L" class="postField"></label>
      </span>
      <br/>
    </fieldset>
     <fieldset id="wf_Categories2">
      <legend>Settings</legend>
         <label for="parentPage" id="parentPage-L" class="preField">Parent Page</label>
			<select name="parentPage" id="parentPage"><option value="">None</option>
				<cfloop from="1" to="#arraylen(pages)#" index="i">
					<option value="#pages[i].getId()#">#pages[i].getTitle()#</option>
			</cfloop>
			</select>
	<cfif arraylen(templates)>
      <br/>
	 <label for="template" id="template-L" class="preField">Skin template</label>
      <select id="template" name="template" class="">
		<option value="" <cfif template EQ "">selected="selected"</cfif>>default</option>
     	<cfloop from="1" to="#arraylen(templates)#" index="i">
			<option value="#templates[i].file#" <cfif templates[i].file EQ template>selected="selected"</cfif>>#templates[i].name#</option>
		</cfloop>
      </select>
	<cfelse>
		<input type="hidden" name="template" value="" />
	</cfif>
      <br/>
	 <label for="sortOrder" id="sortOrder-L" class="preField">Sort order</label>
      <input type="text" id="sortOrder" name="sortOrder" value="#sortOrder#" size="2" class="none"/>
      <br/>
    </fieldset>
    <fieldset id="wf_Publishstatus" class="">
      <legend>Publish status</legend>
      <span class="label preField">Status</span>
      <span class="required">
        <span class="oneChoice">
          <input type="radio" value="published" id="wf_Published" name="publish" <cfif publish EQ "published">checked="checked"</cfif>/>
          <label for="wf_Published" id="wf_Published-L" class="postField">Published</label>
        </span>
        <span class="oneChoice">
          <input type="radio" value="draft" id="wf_Draft" name="publish" <cfif publish EQ "draft">checked="checked"</cfif>/>
          <label for="wf_Draft" id="wf_Draft-L" class="postField">Draft</label>
        </span>
      </span>
      <br/>
    </fieldset>
    <div class="actions">
      <input type="submit" class="primaryAction" id="tfa_submit" name="submit" value="submit"/>
    </div>
  </div>

</form></cfoutput>
</div>
	</div>
</div>

</cf_layout>