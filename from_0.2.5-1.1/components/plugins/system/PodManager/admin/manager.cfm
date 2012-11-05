<cfoutput>
<form method="post" action="#cgi.script_name#">
	<fieldset>
		<legend>#locationTitle#</legend>
	<div class="field-hint-inactive" id="pods-H">
        <div>All theme pods and pods added by plugins available: <br />
		#availableLabel#
		</div>
      </div>
	<label for="pods" id="pods-L" class="preField">Pod order (use ids):</label>
      <textarea cols="30" rows="12" id="pods" name="pods" class="none">#newList#</textarea>
      <br/>
  <div class="actions">
	<input type="hidden" name="locationId" value="#locationId#" />
    <input type="submit" class="primaryAction" value="Save changes"/>
	<input type="hidden" name="owner" value="PodManager" />
	<input type="hidden" value="podManager-showSettings" name="event" />
	<input type="hidden" value="true" name="apply" />
	<input type="hidden" value="PodManager" name="selected" />
  </div>
</fieldset>
</form>
</cfoutput>