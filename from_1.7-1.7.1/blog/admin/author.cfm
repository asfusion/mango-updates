<cfsilent>
	<cfimport prefix="mangoAdmin" taglib="tags">
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
	<cfparam name="picture" default="" />	

	<cfset pagetitle = "New user" />
	<cfset pluginQueue = request.blogManager.getpluginQueue() />
	<cfset currentAuthor = request.blogManager.getCurrentUser() />
	<cfset currentBlogId = request.blogManager.getBlog().getId() />
	<cfset currentRole = currentAuthor.getCurrentRole(currentBlogId)/>
	<cfset preferences = currentRole.preferences.get("admin","menuItems","") />
	
	<cfif profile OR NOT listfind(currentRole.permissions, "manage_users")>
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
			<cfset password = '' />
			<cfset email = author.getemail() />
			<cfset active = author.active />
			<cfset description = author.getdescription() />
			<cfset shortdescription = author.getshortdescription() />
			<cfset picture = author.getpicture() />			
			<cfset role = author.getCurrentRole(currentBlogId).id />
			<cfset pagetitle = 'Editing user: "#xmlformat(name)# (#xmlformat(username)#)"'>
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
	<cfoutput>

	<!-- INNER NAV IF NEEDED -->
	<nav class="navbar navbar-expand-lg navbar-transparent navbar-dark navbar-theme-primary mb-4">
	<div class="">
	<div class="navbar-collapse collapse w-100" id="navbar-default-primary">
	<ul class="navbar-nav navbar-nav-hover align-items-start">
	<cfoutput><li class="nav-item"><a href="author.cfm?profile=1" class="nav-link <cfif mode EQ "profile"> active</cfif>">My Profile</a></li></cfoutput>

	<cfif listfind(currentRole.permissions, "manage_users")>
	<cfif NOT len(preferences) OR listfind(preferences,"users_new")>
			<li class="nav-item"><a class="nav-link<cfif mode EQ "new"> active</cfif>" href="author.cfm">New User</a></li>
	</cfif>
	<cfif NOT len(preferences) OR listfind(preferences,"users_edit")>
			<li class="nav-item"><a class="nav-link <cfif mode EQ "update"> active</cfif>" href="authors.cfm">Edit User</a></li>
	</cfif>
	<cfif NOT len(preferences) OR listfind(preferences,"roles")>
			<li class="nav-item"><a class="nav-link" href="roles.cfm">Roles</a></li>
	</cfif>
		<mangoAdmin:MenuEvent name="authorsNav" />
	</cfif>
	</ul>
	</div>
		<div class="d-flex align-items-start">
			<button class="navbar-toggler ms-2" type="button" data-toggle="collapse"
					data-target="##navbar-default-primary" aria-controls="navbar-default-primary"
					aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
		</div>
	</div>
	</nav>
	<!-- END INNER NAV IF NEEDED -->

	<h4 class="h4"><cfoutput>#pageTitle#</cfoutput></h4>

	<cfif len(message)><div class="alert alert-success" role="alert">#message#</div></cfif>
	<cfif len(error)><div class="alert alert-danger" role="alert">#error#</div></cfif>

	<form method="post" action="#cgi.SCRIPT_NAME#" id="authorForm">

	<div class="row">
		<div class="col-12 col-lg-4 col-xl-4">
			<div class="card card-body border-0 shadow mb-4">

		<div class="mb-3">
			<label for="name">Name</label>
				<input type="text" id="name" name="name" value="#htmleditformat(name)#" size="30" class="form-control required"/>
			<div class="form-text hint">User's name as it will appear in posts</div>
		</div>

		<div class="mb-3">
			<label for="email">E-mail</label>
			<span class="field"><input type="text" id="email" name="email" value="#htmleditformat(email)#" class="form-control email required"/></span>
			<span class="form-text hint">An email address that identifies the user. It is also used to email notifications, forgotten password, etc.</span>
		</div>

		<div class="mb-3">
			<label for="username">Username</label>
			<input type="text" id="username" name="username" value="#htmleditformat(username)#" size="30" class="form-control required validate-alphanum"/>
			<div class="form-text hint">A unique username for authentication purposes</div>
		</div>

		<div class="mb-3">
			<label for="password">Password</label>
			<input type="password" id="password" name="password" class="form-control"/></span>
		</div>

		<cfif mode NEQ "profile">
		<div class="mb-3">
			<label for="role">Role</label>
			<select class="form-select mb-0 required" id="role" name="role">
		<cfloop from="1" to="#arraylen(roles)#" index="i">
				<option value="#roles[i].id#" <cfif role EQ roles[i].id>selected="selected"</cfif>>#xmlformat(roles[i].name)#</option></cfloop>

			</select>
		</div>
		<div class="mb-3">
			<div class="form-check form-switch">
					<input class="form-check-input" type="checkbox" value="1" id="active" name="active" <cfif active>checked="checked"</cfif>/>
				<label class="form-check-label" for="active">Active</label>
	</div>
	</div>
		</cfif>

		</div><!-- end card -->
		</div>
		<div class="col-12 col-lg-8 col-xl-8">
			<div class="card card-body border-0 shadow mb-4">
			<div class="mb-3">
				<label for="shortdescription">Short Description</label>
				<textarea rows="4" id="shortdescription" name="shortdescription" class="form-control" >#htmleditformat(shortdescription)#</textarea>
			</div>

			<div class="mb-3">
				<label for="authorDescription">Description</label>
				<span class="field"><textarea rows="10" id="authorDescription" name="description" class="htmlEditor form-control"  style="width: 100%">#htmleditformat(description)#</textarea></span>
				<span class="form-text hint">Text to show in author's page</span>

			</div>

			<div class="mb-3">
				<label for="picture">Picture</label>
				<span class="hint">Author's photo or profile image</span>

				<div class="input-group">
					<input type="text" class="form-control assetSelector" id="picture" name="picture" value="#htmleditformat(picture)#" placeholder="choose file">
					<!---<span class="input-group-text classselector-button">
						<i class="bi bi-file-fill icon icon-xs text-gray-600"></i>
					</span>--->
				</div>

			</div>

			<div class="mt-3 align-content-end"><button class="btn btn-gray-800 mt-2 animate-up-2" type="submit">Save</button></div>
			</div>
		</div>

			<input type="hidden" name="id" value="#id#"/>
			<input type="hidden" name="profile" value="#profile#"/>
		<cfif mode EQ "profile">
			<input type="hidden" name="role" value="#role#"/>
			<input type="hidden" name="active" value="#active#"/>
		</cfif>

		<input type="hidden" name="submit" value="Save">
	</div>
	</div>
		</form>
		</cfoutput>
		
</cf_layout>