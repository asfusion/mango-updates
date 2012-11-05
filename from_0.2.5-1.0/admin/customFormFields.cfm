<!--- we need an entry and an array of custom form fields --->
<cfparam name="attributes.customFormFields" default="#arraynew(1)#">
<cfparam name="attributes.entry">
<cfparam name="attributes.startingIndex" default="2">
<cfif thisTag.executionmode EQ "start">
<cfoutput>
	<cfset currentFieldNumber = attributes.startingIndex />
<cfloop from="1" to="#arraylen(attributes.customFormFields)#" index="i">
	
	<cfset currentValue = attributes.customFormFields[i].value />
	
	<input type="hidden" name="customFieldKey_#currentFieldNumber#" value="#htmleditformat(attributes.customFormFields[i].id)#" />
	<input type="hidden" name="customFieldName_#currentFieldNumber#" value="#htmleditformat(attributes.customFormFields[i].name)#" />
	<cfif attributes.customFormFields[i].inputType EQ "hidden">
		<input type="hidden" name="customField_#currentFieldNumber#" value="#htmleditformat(currentValue)#" />
	<cfelseif attributes.customFormFields[i].inputType EQ "textinput">
	<p>
		<label for="customField_#currentFieldNumber#" id="customField_#currentFieldNumber#-L" class="preField">#attributes.customFormFields[i].name#</label>
		<input type="text" name="customField_#currentFieldNumber#" value="#htmleditformat(currentValue)#" size="40" />
	</p>
	<cfelseif attributes.customFormFields[i].inputType EQ "textarea">
	<p>
		<label for="customField_#currentFieldNumber#" id="customField_#currentFieldNumber#-L" class="preField">#attributes.customFormFields[i].name#</label>
		<textarea name="customField_#currentFieldNumber#" rows="10" cols="50">#htmleditformat(currentValue)#</textarea>
	</p>
	<cfelseif attributes.customFormFields[i].inputType EQ "htmlTextarea">
	<p>
		<label for="customField_#currentFieldNumber#" id="customField_#currentFieldNumber#-L" class="preField">#attributes.customFormFields[i].name#</label>
		<textarea name="customField_#currentFieldNumber#" class="htmlEditor" rows="10" cols="50" style="width: 100%">#htmleditformat(currentValue)#</textarea>
	</p>
	<cfelseif attributes.customFormFields[i].inputType EQ "radioButton">
	<p>
		<label for="customField_#currentFieldNumber#" id="customField_#currentFieldNumber#-L" class="preField">#attributes.customFormFields[i].name#</label>
		<cfloop from="1" to="#arraylen(attributes.customFormFields[i].options)#" index="j">
			<input type="radio" value="#attributes.customFormFields[i].options[j].value#" id="customField_#currentFieldNumber#" 
					name="customField_#currentFieldNumber#" <cfif attributes.customFormFields[i].options[j].value EQ currentValue>checked="checked"</cfif>/> #attributes.customFormFields[i].options[j].label#&nbsp;&nbsp;&nbsp;
		</cfloop>
	</p>
	<cfelseif attributes.customFormFields[i].inputType EQ "dropdown">
	<p>
		<label for="customField_#currentFieldNumber#" id="customField_#currentFieldNumber#-L" class="preField">#attributes.customFormFields[i].name#</label>
		<select name="customField_#currentFieldNumber#">		
		<cfloop from="1" to="#arraylen(attributes.customFormFields[i].options)#" index="j">
			<option value="#attributes.customFormFields[i].options[j].value#" <cfif attributes.customFormFields[i].options[j].value EQ currentValue>selected="selected"</cfif>>#attributes.customFormFields[i].options[j].label#</option>
		</cfloop>
		</select>
	</p>
	<cfelseif attributes.customFormFields[i].inputType EQ "checkbox">
	<p>
		<label id="customField_#currentFieldNumber#-L" class="preField">#attributes.customFormFields[i].name#</label>
		<cfloop from="1" to="#arraylen(attributes.customFormFields[i].options)#" index="j">
			<input type="checkbox" value="#attributes.customFormFields[i].options[j].value#" id="customField_#currentFieldNumber#" 
					name="customField_#currentFieldNumber#" <cfif listfind(currentValue,attributes.customFormFields[i].options[j].value)>checked="checked"</cfif> /> #attributes.customFormFields[i].options[j].label#&nbsp;&nbsp;&nbsp;
		</cfloop>
	</p>
	</cfif>
	<cfset currentFieldNumber = currentFieldNumber + 1 />
</cfloop>
</cfoutput>
</cfif>