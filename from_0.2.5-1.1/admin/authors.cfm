<cfsilent>
	<cfimport prefix="mangoAdmin" taglib="tags">
	<cfparam name="error" default="">
	<cfparam name="message" default="">
	
	<!--- get authors --->
	<cfset authors = request.administrator.getAuthors() />
	<cfset currentAuthor = request.blogManager.getCurrentUser() />
	<cfset preferences = currentAuthor.currentRole.preferences.get("admin","menuItems","") />
	
</cfsilent>
<cf_layout page="Users" title="Users">
<div id="wrapper">
<cfif listfind(currentAuthor.currentRole.permissions, "manage_users")>
	<div id="submenucontainer">
		<ul id="submenu">
			<cfoutput><li><a href="author.cfm?profile=1">My Profile</a></li></cfoutput>
			<cfif NOT len(preferences) OR listfind(preferences,"users_new")>
			<li><a href="author.cfm">New User</a></li>
			</cfif>
			<cfif NOT len(preferences) OR listfind(preferences,"users_edit")>
			<li><a href="authors.cfm" class="current">Edit User</a></li>
			</cfif>
			<cfif NOT len(preferences) OR listfind(preferences,"roles")>
			<li><a href="roles.cfm">Roles</a></li>
			</cfif>
			<mangoAdmin:MenuEvent name="authorsNav" />
		</ul>
	</div>
	
	<div id="content">
		<h2 class="pageTitle">All Users</h2>	

		<div id="innercontent">
		<cfif len(error)>
			<p class="error"><cfoutput>#error#</cfoutput></p>
		</cfif>
		<cfif len(message)>
			<p class="message"><cfoutput>#message#</cfoutput></p>
		</cfif>

		<cfoutput>
		<p class="buttonBar"><a href="author.cfm" class="editButton">Create New User</a></p>
		<table cellspacing="0">
			<tr><th class="buttonColumn">Edit</th><th>Name</th><th>Email</th><th>Role</th><th>Active</th></tr>
			<cfloop from="1" to="#arraylen(authors)#" index="i">
				<tr>
					<td <cfif NOT i mod 2>class="alternate"</cfif>><a href="author.cfm?id=#authors[i].getId()#" class="editButton">Edit</a></td>
					<td <cfif NOT i mod 2>class="alternate"</cfif>>#authors[i].getName()#</td>
					<td <cfif NOT i mod 2>class="alternate"</cfif>>#authors[i].getEmail()#</td>
					<td <cfif NOT i mod 2>class="alternate"</cfif>>#authors[i].currentRole.name#</td>
					<td <cfif NOT i mod 2>class="alternate"</cfif>><cfif NOT authors[i].active>Not </cfif>Active</td>
				</tr>
			</cfloop>
		</table>
		</cfoutput>
		
		</div>
	</div>
	<cfelse><!--- not authorized --->
<div id="content"><div id="innercontent">
<p class="message">Your role does not allow you to manage users</p>
</div></div>
</cfif>
</div>
</cf_layout>