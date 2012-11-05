<cfoutput>
<form method="post" action="#cgi.script_name#">
	<span class="oneField">
    <label for="homePage" class="preField">Page to show as home:</label>
	<select name="homePage" id="homePage"><option value="">-- Default --</option>
		<cfloop from="1" to="#arraylen(pages)#" index="i">
			<option value="#pages[i].getName()#" <cfif variables.indexPage EQ pages[i].getName()>selected="selected"</cfif>>#pages[i].getTitle()#</option>
		</cfloop>
	</select>    
	</span>
	<br/>
	<span class="oneChoice">
		<div class="field-hint-inactive" id="allowComments-H">
        	<div>If checked, this page will not be listed in the top-level menu.</div>
		</div>
		<input type="checkbox" value="1" id="removeFromMenu" 
						name="removeFromMenu" <cfif variables.removeFromMenu>checked="checked"</cfif>>
		<label for="removeFromMenu" id="removeFromMenu-L" class="postField">Remove this page from menu</label>
	</span>
	<br /><br />
	<span class="oneField">
    <label for="blogPage" class="preField">Page to show as blog:</label>
	<select name="blogPage" id="blogPage"><option value="">-- Default --</option>
		<cfloop from="1" to="#arraylen(pages)#" index="i">
			<option value="#pages[i].getName()#" <cfif variables.blogPage EQ pages[i].getName()>selected="selected"</cfif>>#pages[i].getTitle()#</option>
		</cfloop>
	</select>
    <br/>
  </span>

  <div class="actions">
    <input type="submit" class="primaryAction" value="Submit"/>
	<input type="hidden" value="event" name="action" />
	<input type="hidden" value="homeChooser-showSettings" name="event" />
	<input type="hidden" value="true" name="apply" />
	<input type="hidden" value="homeChooser" name="selected" />
  </div>

</form>



</cfoutput>