<cfoutput>

<form method="post" action="#cgi.script_name#">
  <span class="oneField">
    <div class="field-hint-inactive" id="wf_askimet-H">
      <div>You must get this key from Akismet</div>
    </div>
    <label for="apiKey" class="preField">Your Akismet API Key:</label>
    <input type="text" id="apiKey" name="apiKey" value="#variables.apiKey#" size="" class="required"/>
    <span class="reqMark">*</span>
    <br/>
  </span>
<span class="oneField">
	
    <div class="field-hint-inactive" id="wf_askimet-H">
      <div>How you want to handle possible spam comments</div>
    </div>
    <label class="preField">Mode:</label><br />
	<input type="radio" name="mode" value="moderate" <cfif variables.mode EQ "moderate">checked="checked"</cfif>> <strong>Moderation</strong>: if comment is marked as spam, author will receive an email but comment will not be posted until author approval.<br />
	<input type="radio" name="mode" value="reject" <cfif variables.mode EQ "reject">checked="checked"</cfif>> <strong>Reject</strong>: if comment is marked as spam, it will simply be rejected<br />
    <br/>
  </span>
  <div class="actions">
    <input type="submit" class="primaryAction" value="Submit"/>
	<input type="hidden" value="event" name="action" />
	<input type="hidden" value="showAkismetSettings" name="event" />
	<input type="hidden" value="true" name="apply" />
	<input type="hidden" value="askimet" name="selected" />
  </div>
</form>
</cfoutput>