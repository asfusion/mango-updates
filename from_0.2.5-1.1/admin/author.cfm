<cfsilent>
	<cfparam name="id" default="" />		
	<cfparam name="name" default="" />		
	<cfparam name="username" default="" />
	<cfparam name="password" default="" />
	<cfparam name="email" default="" />
	<cfparam name="active" default="1" />
	<cfparam name="error" default="" />
	<cfparam name="message" default="" />
	<cfparam name="description" default="" />
	<cfparam name="shortdescription" default="" />
	<cfparam name="role" default="" />
	<cfparam name="mode" default="new" />
	<cfparam name="profile" default="0" />

	<cfset pagetitle = "New user" />
	<cfset pluginQueue = request.blogManager.getpluginQueue() />
	<cfset currentAuthor = request.blogManager.getCurrentUser() />
	<cfset preferences = currentAuthor.currentRole.preferences.get("admin","menuItems","") />
	
	<cfif profile OR NOT listfind(currentAuthor.currentRole.permissions, "manage_users")>
		<cfset id = currentAuthor.id />
		<cfset mode = "profile" />
	<cfelseif id NEQ "">
		<cfset mode = "update" />
	</cfif>
		
	<cfif structkeyexists(form,"submit")>
		<cfif mode EQ "update">
			<cfset result = request.formHandler.handleEditAuthor(form) />
		 <cfelseif mode EQ "profile">
			<cfset result = request.formHandler.handleEditProfile(form) />
		<cfelse>
			<cfset result = request.formHandler.handleAddAuthor(form) />
		</cfif>
		<cfif result.message.getStatus() EQ "success">
			<cfset message = result.message.getText() />
		<cfelse>
			<cfset error = result.message.getText() />
		</cfif>
	</cfif>
	
	<!--- get post by id --->
	<cfif NOT len(error)>
	<cftry>
		<cfif mode EQ "update" OR mode EQ "profile">
			<cfset author = request.administrator.getAuthor(id) />
			<cfset name = author.getName() />
			<cfset username = author.getusername() />
			<cfset password = author.getpassword() />
			<cfset email = author.getemail() />
			<cfset active = author.active />
			<cfset description = author.getdescription() />
			<cfset shortdescription = author.getshortdescription() />
			<cfset role = author.currentRole.id />
			<cfset pagetitle = 'Editing user: "#name# (#username#)"'>
			<cfif mode EQ "profile">
				<cfset pagetitle = 'Your User Profile'>
			</cfif>
		</cfif>		
	<cfcatch type="any">
		<cfset error = cfcatch.message />
	</cfcatch>
	</cftry> 
	</cfif>
	
	<!--- get roles --->
	<cfset roles = request.blogManager.getRolesManager().getRoles() />
	
</cfsilent>
<cf_layout page="Users" title="User">

<div id="wrapper">
	<div id="submenucontainer">
		<ul id="submenu">
			<cfoutput><li><a href="author.cfm?profile=1"<cfif mode EQ "profile"> class="current"</cfif>>My Profile</a></li></cfoutput>
			<cfif listfind(currentAuthor.currentRole.permissions, "manage_users")>			
			<cfif NOT len(preferences) OR listfind(preferences,"users_new")>
			<li><a href="author.cfm"<cfif mode EQ "new"> class="current"</cfif>>New User</a></li>
			</cfif>
			<cfif NOT len(preferences) OR listfind(preferences,"users_edit")>
			<li><a href="authors.cfm"<cfif mode EQ "update"> class="current"</cfif>>Edit User</a></li>
			</cfif>
			<cfif NOT len(preferences) OR listfind(preferences,"roles")>
			<li><a href="roles.cfm">Roles</a></li>
			</cfif>
			<mangoAdmin:MenuEvent name="authorsNav" />
			</cfif>
		</ul>
	</div>
	
	<div id="content">
		<h2 class="pageTitle"><cfoutput>#pageTitle#</cfoutput></h2>
		
		<div id="innercontent">
		<cfif len(error)>
			<p class="error"><cfoutput>#error#</cfoutput></p>
		</cfif>
		<cfif len(message)>
			<p class="message"><cfoutput>#message#</cfoutput></p>
		</cfif>
		
		<cfoutput><form method="post" action="#cgi.SCRIPT_NAME#" name="authorForm" id="authorForm">
  <div class="widget">
<input type="hidden" name="id" value="#id#">
	<input type="hidden" name="profile" value="#profile#">
    <fieldset id="authorFieldset" class="">
      <legend>User</legend>
      <div class="field-hint-inactive" id="wf_Name-H">
        <div>User&##x27;s name as it will appear in posts</div>
      </div>
      <label for="name" id="name-L" class="preField">Name <span class="reqMark">*</span></label>
      <input type="text" id="name" name="name" value="#name#" size="" class="none required"/>
      <br/>
      <div class="field-hint-inactive" id="username-H">
        <div>A unique username for authentication purposes</div>
      </div>
      <label for="username" id="username-L" class="preField">Username <span class="reqMark">*</span></label>
      <input type="text" id="username" name="username" value="#username#" size="" class="validate-alphanum required"/>
      <br/>
      <label for="password" id="password-L" class="preField">Password <span class="reqMark">*</span></label>
      <input type="password" id="password" name="password" value="#password#" class="none required"/>
      <br/>
      <div class="field-hint-inactive" id="email-H">
        <div>An email address that identifies the user. It is also used to email notifications, forgotten password, etc.</div>
      </div>
      <label for="email" id="email-L" class="preField">E-mail <span class="reqMark">*</span></label>
      <input type="text" id="email" name="email" value="#email#" size="" class="validate-email required"/>
      <br/>
	<cfif mode NEQ "profile">
	<span class="oneField">
    <label for="role" class="preField">Role</label>
    <select id="role" name="role" class="required">
		<cfloop from="1" to="#arraylen(roles)#" index="i">
			<option value="#roles[i].id#" <cfif role EQ roles[i].id>selected="selected"</cfif>>#roles[i].name#</option></cfloop>
    </select>
    <span class="reqMark">*</span>
    <br/>
  </span>
<span class="oneChoice"><input type="checkbox" value="1" id="active" 
						name="active" <cfif active>checked="checked"</cfif>>
					<label for="active" id="active-L" class="postField">Active</label>
					</span><br />
	<cfelse>
		<input type="hidden" name="role" value="#role#">
		<input type="hidden" name="active" value="#active#">
	</cfif>

	 <label for="shortdescription" id="shortdescription-L" class="preField">Short Description</label>
      <textarea cols="30" rows="4" id="shortdescription" name="shortdescription" class="none">#shortdescription#</textarea>
      <br/>
      <div class="field-hint-inactive" id="authorDescription-H">
        <div>Text to show in author&##x27;s page</div>
      </div>
      <label for="authorDescription" id="authorDescription-L" class="preField">Description</label>
      <textarea cols="30" rows="10" id="authorDescription" name="description" class="htmlEditor"  style="width: 100%">#description#</textarea>
	<br/>     
    </fieldset>
    <div class="actions">
      <input type="submit" class="primaryAction" id="submit" name="submit" value="Save"/>
    </div>
  </div>

</form>
</cfoutput>
		
		</div>
	</div>
</div>

</cf_layout>