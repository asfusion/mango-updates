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
		<cfset title = page.getTitle() />
		<cfset content = page.getContent() />
		<cfset excerpt = page.getExcerpt() />
		<cfset allowComments = page.getCommentsAllowed() />
		<cfset publish = page.getStatus() />
		<cfset parent = page.getParentPageId() />
		<cfset template = page.getTemplate() />
		<cfset sortOrder = page.getSortOrder() />

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
		
		<cfoutput><form method="post" action="#cgi.SCRIPT_NAME#" name="wf_Newpost" id="wf_Newpost">
	<input type="hidden" name="id" value="#id#">
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
					<option value="#pages[i].getId()#" <cfif parent EQ pages[i].getId()>selected="selected"</cfif>>#pages[i].getTitle()#</option>
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
<!---      <label for="postedOn" id="postedOn-L" class="preField">Publishing date</label>
      <input type="text" id="postedOn" name="postedOn" value="#postedOn#" size="20" class="validate-date"/>
      <br/> --->
    </fieldset>
    <div class="actions">
      <input type="submit" class="primaryAction button" id="tfa_submit" name="submit" value="submit"/>
    </div>
  </div>

</form></cfoutput>
		
		</div>
	</div>
</div>


</cf_layout>