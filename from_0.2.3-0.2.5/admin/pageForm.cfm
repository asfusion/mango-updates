<cfoutput><form method="post" action="#cgi.SCRIPT_NAME#" name="pageForm" id="pageForm">
	<input type="hidden" name="id" value="#id#">
	<div id="sideoptions">
	 <fieldset id="pageSettings" class="sidebox">
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
    </fieldset>
	
	<fieldset id="commentsOptions" class="sidebox"><legend>Comments</legend>
		<div class="field-hint-inactive" id="wf_Allowcomments2-H">
        	<div>Whether or not reader comments are permitted in this page</div>
		</div>
      <span class="label preField">Allow comments</span>
        <input type="checkbox" value="yes" id="allowComments" name="allowComments" <cfif allowComments>checked="checked"</cfif>/>
	</fieldset>
	
	<fieldset id="wf_Publishstatus"  class="sidebox">
      <legend>Publish status</legend>
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
	
	</div>
	
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
    </fieldset>
	
	<fieldset id="customFieldsFieldset" class="">
      <legend>Custom Fields</legend>
		<input type="hidden" name="totalCustomFields" value="#arraylen(customFields) + 1#" />
		
		<cfloop from="1" to="#arraylen(customFields)#" index="i">
			<label for="customField_#i#" id="customField_#i#-L" class="preField">#customFields[i].name#</label>
      		<input type="text" id="customField_#i#" name="customField_#i#" value="#htmleditformat(customFields[i].value)#" size="50" /> (key: #customFields[i].key#)
		<input type="hidden" name="customFieldKey_#i#" value="#htmleditformat(customFields[i].key)#" />
		<input type="hidden" name="customFieldName_#i#" value="#htmleditformat(customFields[i].name)#" />
      	<br/>
		</cfloop>
		<br/>
		<cfset i = arraylen(customFields) + 1 />
		<h3>New custom field</h3>
		<div>
		<label class="preField">Label</label>
		<input type="text" name="customFieldName_#i#" size="25"/>
		&nbsp;<label>Key</label>
		<input type="text" name="customFieldKey_#i#" size="20"/>
		<br/>
		<label for="customField_#i#" id="customField_#i#-L" class="preField">Value</label>
		<input type="text" id="customField_#i#" name="customField_#i#" size="50" />
		</div>

	 </fieldset>
	<cfoutput>#tostring(event.getOutputData())#</cfoutput>
    <div class="actions">
      <input type="submit" class="primaryAction button" id="tfa_submit" name="submit" value="submit"/>
    </div>
  </div>

</form></cfoutput>