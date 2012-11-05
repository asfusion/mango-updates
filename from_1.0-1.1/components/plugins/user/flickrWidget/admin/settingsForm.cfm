<cfoutput>

<form method="post" action="#cgi.script_name#">
	<span class="oneField">
    <label for="podTitle" class="preField">Pod Title:</label>
    <input type="text" id="podTitle" name="podTitle" value="#variables.title#" size="20"/>
    <br/>
  </span>
  <span class="oneField">
    <div class="field-hint-inactive" id="tags-H">
      <div>Photos matching these tags (separated by commas). Either tags or user are required</div>
    </div>
    <label for="tags" class="preField">Tags:</label>
    <input type="text" id="tags" name="tags" value="#variables.tags#" size="20"/>
    <br/>
  </span>
 <span class="oneField">
    <div class="field-hint-inactive" id="username-H">
      <div>Photos belonging to this username. Either tags or user are required</div>
    </div>
    <label for="username" class="preField">Username:</label>
    <input type="text" id="username" name="username" value="#variables.username#" size="20"/>
    <br/>
  </span>
  <div class="actions">
    <input type="submit" class="primaryAction" value="Submit"/>
	<input type="hidden" value="event" name="action" />
	<input type="hidden" value="showFlickrWidgetSettings" name="event" />
	<input type="hidden" value="true" name="apply" />
	<input type="hidden" value="flickrWidget" name="selected" />
  </div>

</form>



</cfoutput>