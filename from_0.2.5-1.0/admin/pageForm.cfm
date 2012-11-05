<cfparam name="customFormFields" default="#arraynew(1)#">
<cfparam name="showFields" default="title,content,excerpt,comments_allowed,status,template,parent,customFields,sortOrder">
<cfoutput><form method="post" action="#cgi.SCRIPT_NAME#" name="pageForm" id="pageForm">
	<input type="hidden" name="id" value="#id#">
	<div id="sideoptions">
	<cfif listfind(showFields,'parent') OR listfind(showFields,'template') OR listfind(showFields,"sortOrder")>
	 <fieldset id="pageSettings" class="sidebox">
      <legend>Settings</legend>
		<cfif listfind(showFields,'parent')>
         <label for="parentPage" id="parentPage-L" class="preField">Parent Page</label>
			<select name="parentPage" id="parentPage"><option value="">None</option>
				<cfloop from="1" to="#arraylen(pages)#" index="i">
					<option value="#pages[i].getId()#" <cfif parent EQ pages[i].getId()>selected="selected"</cfif>>#pages[i].getTitle()#</option>
			</cfloop>
			</select>
			<cfelse>
			<input type="hidden" name="parentPage" value="#parent#" />
		</cfif>
      <cfif arraylen(templates) AND listfind(showFields,'template')>
      <br/>
	 <label for="template" id="template-L" class="preField">Skin template</label>
      <select id="template" name="template" class="">
		<option value="" <cfif template EQ "">selected="selected"</cfif>>default</option>
     	<cfloop from="1" to="#arraylen(templates)#" index="i">
			<option value="#templates[i].file#" <cfif templates[i].file EQ template>selected="selected"</cfif>>#templates[i].name#</option>
		</cfloop>
      </select>
	<cfelse>
		<input type="hidden" name="template" value="#template#" />
	</cfif>
	<cfif listfind(showFields,'sortOrder')>
      <br/>
	 <label for="sortOrder" id="sortOrder-L" class="preField">Sort order</label>
      <input type="text" id="sortOrder" name="sortOrder" value="#sortOrder#" size="2" class="none"/>
	<cfelse>
		<input type="hidden" name="sortOrder" value="#sortOrder#" />
	</cfif>
    </fieldset>
	<cfelse>
		<input type="hidden" name="parentPage" value="#parent#" />
		<input type="hidden" name="template" value="#template#" />
		<input type="hidden" name="sortOrder" value="#sortOrder#" />
	</cfif>
	<cfif listfind(showFields,'comments_allowed')>
	<fieldset id="commentsOptions" class="sidebox"><legend>Comments</legend>
		<div class="field-hint-inactive" id="allowComments-H">
        	<div>Whether or not reader comments are permitted in this page</div>
		</div>
      <span class="label preField">Allow comments</span>
        <input type="checkbox" value="yes" id="allowComments" name="allowComments" <cfif allowComments>checked="checked"</cfif>/>
	</fieldset>
	<cfelse>
		<input type="hidden" name="allowComments" value="#allowComments#" />
	</cfif>
	<cfif listfind(showFields,'status')>
	<fieldset id="wf_Publishstatus"  class="sidebox">
      <legend>Publish status</legend>
      <span class="required">
			<span class="oneChoice">
				<input type="radio" value="published" id="published" name="publish" <cfif publish EQ "published">checked="checked"</cfif>/>
				<label for="published" id="published-L" class="postField">Published</label>
			</span>
			<!--- <span class="oneChoice">
				<input type="radio" value="to-review" id="review" name="publish" <cfif publish EQ "to-review">checked="checked"</cfif>/>
				<label for="review" id="review-L" class="postField">To be reviewed</label>
			</span> --->
			<span class="oneChoice">
				<input type="radio" value="draft" id="draft" name="publish" <cfif publish EQ "draft">checked="checked"</cfif>/>
				<label for="draft" id="draft-L" class="postField">Draft</label>
			</span>
	     </span>
      <br/>
    </fieldset>
	<cfelse>
		<input type="hidden" name="publish" value="#publish#" />
	</cfif>
	</div>
	
	<div class="widget">
	<cfif listfind(showFields,'title') OR listfind(showFields,'content') OR listfind(showFields,'excerpt')>
    <fieldset id="wf_Post" class="">
      <legend>Page</legend>
	<cfif listfind(showFields,'title')>
      <label for="title" id="title-L" class="preField">Title <span class="reqMark">*</span></label>
      <input type="text" id="title" name="title" value="#htmleditformat(title)#" size="50" class="none required"/>
      <br/>
	<cfelse>
		<input type="hidden" name="title" value="#htmleditformat(title)#" />
	</cfif>
	<cfif listfind(showFields,'content')>
      <label for="contentField" id="content-L" class="preField">Content <span class="reqMark">*</span></label>
      <textarea cols="50" rows="20" id="contentField" name="content" class="htmlEditor required"  style="width: 100%">#htmleditformat(content)#</textarea>
      <br/>
	<cfelse>
		<input type="hidden" name="content" value="#htmleditformat(content)#" />
	</cfif>
	<cfif listfind(showFields,'excerpt')>
      <div class="field-hint-inactive" id="excerpt-H">
        <div>Short summary describing post</div>
      </div>
      <label for="excerpt" id="excerpt-L" class="preField">Excerpt</label>
      <textarea cols="50" rows="5" id="excerpt" name="excerpt" class="htmlEditor"  style="width: 100%">#htmleditformat(excerpt)#</textarea>   
	<cfelse>
		<input type="hidden" name="excerpt" value="#htmleditformat(excerpt)#" />
	</cfif>
	 </fieldset>
	<cfelse>
		<input type="hidden" name="title" value="#htmleditformat(title)#" />
		<input type="hidden" name="content" value="#htmleditformat(content)#" />
		<input type="hidden" name="excerpt" value="#htmleditformat(excerpt)#" />
	</cfif>
	
	<cfif listfind(showFields,'customFields')>
	<fieldset id="customFieldsFieldset" class="">
      <legend>Custom Fields</legend>		
		<cfloop from="1" to="#arraylen(customFields)#" index="i">
		<p>
			<label for="customField_#i#" id="customField_#i#-L" class="preField">#customFields[i].name#</label>
      		<textarea id="customField_#i#" name="customField_#i#" rows="2" cols="50">#htmleditformat(customFields[i].value)#</textarea> (key: #customFields[i].key#)
			<input type="hidden" name="customFieldKey_#i#" value="#htmleditformat(customFields[i].key)#" />
			<input type="hidden" name="customFieldName_#i#" value="#htmleditformat(customFields[i].name)#" />
      	</p>
		</cfloop>
		<br/>
		<h3>New custom field</h3>
		<div>
		<label class="preField">Label</label>
		<input type="text" name="customFieldName_#i#" size="25"/>
		&nbsp;<label>Key</label>
		<input type="text" name="customFieldKey_#i#" size="20"/>
		<br/>
		<label for="customField_#i#" id="customField_#i#-L" class="preField">Value</label>
		<textarea id="customField_#i#" name="customField_#i#" rows="2" cols="50"></textarea>
		</div>
	 </fieldset>
	 <cfelse>
		<cfloop from="1" to="#arraylen(customFields)#" index="i">
			<input type="hidden" name="customField_#i#" value="#htmleditformat(customFields[i].value)#" />
			<input type="hidden" name="customFieldKey_#i#" value="#htmleditformat(customFields[i].key)#" />
			<input type="hidden" name="customFieldName_#i#" value="#htmleditformat(customFields[i].name)#" />
		</cfloop>
	 </cfif>
	<cf_customFormFields entry="#page#" customFormFields="#customFormFields#" startingIndex="#i+1#">
	<cfoutput>#tostring(event.getOutputData())#</cfoutput>
	<input type="hidden" name="totalCustomFields" value="#totalCustomFields#" />
    <div class="actions">
      <input type="submit" class="primaryAction button" id="tfa_submit" name="submit" value="submit"/>
    </div>
  </div>

</form></cfoutput>