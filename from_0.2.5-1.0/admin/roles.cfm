<cfsilent>
	<cfimport prefix="mangoAdmin" taglib="tags">
	<cfparam name="error" default="">
	<cfparam name="message" default="">
	<cfparam name="mode" default="new">
	<cfparam name="id" default="">
	<cfparam name="name" default="">
	<cfparam name="description" default="">
	<cfparam name="permissionsList" default="">
	<cfparam name="formtitle" default="New Role">
	<cfparam name="showMenuList" default="all">
	
	<cfif id NEQ "">
		<cfset mode = "update" />
	</cfif>
	
	<cfif structkeyexists(form,"submit")>
		<cfif mode EQ "update">
			<cfset result = request.formHandler.handleEditRole(form) />
			<cfif result.message.getStatus() EQ "success">
				<cfset id = result.newRole.id />
			</cfif>
		<cfelse>
			<cfset result = request.formHandler.handleAddRole(form) />
			<cfif result.message.getStatus() EQ "success">
				<cfset name = "" />
				<cfset permissionsList = "" />
				<cfset id = "" />
			</cfif>
		</cfif>
		<cfif result.message.getStatus() EQ "success">
			<cfset message = result.message.getText() />
		<cfelse>
			<cfset error = result.message.getText() />
		</cfif>
	</cfif>
	
	<cfset manager = request.blogManager.getRolesManager() />
	
	<cfif NOT len(error)>
		<cfif mode EQ "update">
		<cftry>
			<cfset role = manager.getRoleById(id) />
			<cfset name = role.name />
			<cfset description = role.description />
			<cfset permissionsList = role.permissions />
			<cfset showMenuList = role.preferences.get("admin","menuItems","all") />
			<cfset formtitle = 'Editing role: "#name#"'>
			
			<cfcatch type="any">
				<cfset error = cfcatch.message />
			</cfcatch>
		</cftry>
	</cfif>
	</cfif>
	
	
	<!--- get roles --->
	<cfset roles = manager.getRoles() />
	<!--- get permissions --->
	<cfset permissions = manager.getPermissions() />	
	<cfset currentAuthor = request.blogManager.getCurrentUser() />
	<cfset preferences = currentAuthor.currentRole.preferences.get("admin","menuItems","") />
	
</cfsilent>
<cf_layout page="Users" title="Roles">
<cfif listfind(currentAuthor.currentRole.permissions, "manage_users")>
<div id="wrapper">
	<div id="submenucontainer">
		<ul id="submenu">
			<li><a href="author.cfm?profile=1">My Profile</a></li>
			<cfif NOT len(preferences) OR listfind(preferences,"users_new")>
			<li><a href="author.cfm">New User</a></li>
			</cfif>
			<cfif NOT len(preferences) OR listfind(preferences,"users_edit")>
			<li><a href="authors.cfm">Edit User</a></li>
			</cfif>
			<cfif NOT len(preferences) OR listfind(preferences,"roles")>
			<li><a href="roles.cfm" class="current">Roles</a></li>
			</cfif>			
			<mangoAdmin:MenuEvent name="authorsNav" />
		</ul>
	</div>
	
	<div id="content">
		<h2 class="pageTitle">Roles</h2>	

		<div id="innercontent">
		<cfif len(error)>
			<p class="error"><cfoutput>#error#</cfoutput></p>
		</cfif>
		<cfif len(message)>
			<p class="message"><cfoutput>#message#</cfoutput></p>
		</cfif>
		
		<cfoutput>
			<div>
		<cfif mode EQ "update"><p class="buttonBar"><a href="roles.cfm" class="editButton">Create New Role</a></p></cfif>
		<table cellspacing="0">
			<tr><th class="buttonColumn">Edit</th><th>Name</th><th>Description</th></tr>
			<cfloop from="1" to="#arraylen(roles)#" index="i">
				<tr>
					<td <cfif NOT i mod 2>class="alternate"</cfif>><a href="roles.cfm?id=#roles[i].getId()#" class="editButton">Edit</a></td>
					<td <cfif NOT i mod 2>class="alternate"</cfif>>#roles[i].getName()#</td>
					<td <cfif NOT i mod 2>class="alternate"</cfif>>#roles[i].getDescription()#</td>
				</tr>
			</cfloop>
		</table>
		</div>
		<div>
			<form action="roles.cfm" method="POST">
				<input type="hidden" name="id" value="#id#">
				<fieldset id="roleFieldset">
		      	<legend>#formtitle#</legend>
				<span class="oneField"><label for="name" class="preField">Name</label>
				<input type="text" id="name" name="name" value="#htmleditformat(name)#" size="" class="required"><span class="reqMark">*</span><br></span>
				<span class="oneField">
				<label for="description" class="preField">Description</label>
				<textarea id="description" name="description" rows="2" cols="30">#htmleditformat(description)#</textarea><br></span>
				
				<div class="column1">
				<h3>Permissions</h3>
				<div class="hint">What can a user with this role do?</div><br />
				<cfloop from="1" to="#arraylen(permissions)#" index="i">
				<span class="oneChoice"><input type="checkbox" value="#permissions[i].id#" id="permissions_#permissions[i].id#" 
						name="permissions" <cfif listfind(permissionsList,permissions[i].id)>checked="checked"</cfif>>
					<label for="permissions_#permissions[i].id#" id="permissions_#permissions[i].id#-L" class="postField">#permissions[i].name#</label><br /> (#permissions[i].description#)<br />
					</span><br />
				</cfloop>
				
					<div class="actions"><input type="submit" class="primaryAction" name="submit" id="submit" value="Submit"></div>	
				</div>
				<div class="column2">
					<h3>Preferences</h3>
					<h4>Menu items to show in admin:</h4>
					<div class="hint">Removing a menu item only hides it from the menu but  it does not revoke permissions</div>
				<!--- @TODO: make this a nice loop instead --->
					<span class="oneChoice"><input type="checkbox" value="posts" id="menuItems_posts" 
						name="menuItems" <cfif listfind(showMenuList,"posts") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_posts" id="menuItems_posts-L" class="postField">Posts</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="posts_new" id="menuItems_posts_new" 
						name="menuItems" <cfif listfind(showMenuList,"posts_new") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_posts_new" id="menuItems_posts_new-L" class="postField">Posts Submenu: New Post</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="pages" id="menuItems_pages" 
						name="menuItems" <cfif listfind(showMenuList,"pages") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_pages" id="menuItems_pages-L" class="postField">Pages</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="pages_new" id="menuItems_posts_new" 
						name="menuItems" <cfif listfind(showMenuList,"pages_new") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_pages_new" id="menuItems_pages_new-L" class="postField">Pages Submenu: New Page</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="links" id="menuItems_links" 
						name="menuItems" <cfif listfind(showMenuList,"links") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_links" id="menuItems_links-L" class="postField">Links</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="categories" id="menuItems_categories" 
						name="menuItems" <cfif listfind(showMenuList,"categories") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_categories" id="menuItems_categories-L" class="postField">Categories</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="categories_new" id="menuItems_categories_new" 
						name="menuItems" <cfif listfind(showMenuList,"categories_new") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_pages_new" id="menuItems_categories_new-L" class="postField">Categories Submenu: New Category</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="files" id="menuItems_files" 
						name="menuItems" <cfif listfind(showMenuList,"files") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_files" id="menuItems_files-L" class="postField">Files</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="themes" id="menuItems_themes" 
						name="menuItems" <cfif listfind(showMenuList,"themes") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_themes" id="menuItems_themes-L" class="postField">Themes</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="plugins" id="menuItems_plugins" 
						name="menuItems" <cfif listfind(showMenuList,"plugins") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_plugins" id="menuItems_plugins-L" class="postField">Add-ons</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="users" id="menuItems_users" 
						name="menuItems" <cfif listfind(showMenuList,"users") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_users" id="menuItems_users-L" class="postField">Users</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="users_new" id="menuItems_users_new" 
						name="menuItems" <cfif listfind(showMenuList,"users_new") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_users_new" id="menuItems_users_new-L" class="postField">Users Submenu: New User</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="users_edit" id="menuItems_users_edit" 
						name="menuItems" <cfif listfind(showMenuList,"users_edit") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_users_edit" id="menuItems_users_edit-L" class="postField">Users Submenu: Edit User</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="roles" id="menuItems_roles" 
						name="menuItems" <cfif listfind(showMenuList,"roles") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_roles" id="menuItems_roles-L" class="postField">Users Submenu: Roles</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="cache" id="menuItems_cache" 
						name="menuItems" <cfif listfind(showMenuList,"cache") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_cache" id="menuItems_cache-L" class="postField">Cache</label><br />
					</span><br />
					<span class="oneChoice"><input type="checkbox" value="settings" id="menuItems_settings" 
						name="menuItems" <cfif listfind(showMenuList,"settings") OR showMenuList EQ "all">checked="checked"</cfif>>
					<label for="menuItems_settings" id="menuItems_settings-L" class="postField">Settings</label><br />
					</span><br />
				</div>				
				</fieldset>
			</form>
		</div>
		</cfoutput>
		</div>
	</div>
		<cfelse><!--- not authorized --->
<div id="content"><div id="innercontent">
<p class="message">Your role does not allow you to manage user roles</p>
</div></div>
</cfif>
</div>
</cf_layout>