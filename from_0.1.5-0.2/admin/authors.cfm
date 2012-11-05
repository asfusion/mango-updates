<cfsilent>
	<cfparam name="error" default="">
	<cfparam name="message" default="">
	
	<!--- get authors --->
	<cfset authors = request.administrator.getAuthors() />
	
</cfsilent>
<cf_layout page="Authors">

<div id="wrapper">
	<div id="submenucontainer">
		<ul id="submenu">
			<li><a href="author_new.cfm">New</a></li>	
			<li><a href="authors.cfm" class="current">Edit</a></li>
		</ul>
	</div>
	
	<div id="content">
		<h2 class="pageTitle">All authors</h2>	
		
		<div id="innercontent">
		<cfif len(error)>
			<p class="error"><cfoutput>#error#</cfoutput></p>
		</cfif>
		<cfif len(message)>
			<p class="message"><cfoutput>#message#</cfoutput></p>
		</cfif>
		
		<cfoutput>
		<table cellspacing="0">
			<tr><th>Edit</th><th>Name</th><th>Email</th></tr>
			<cfloop from="1" to="#arraylen(authors)#" index="i">
				<tr>
					<td <cfif NOT i mod 2>class="alternate"</cfif>><a href="author_edit.cfm?id=#authors[i].getId()#" class="editButton">Edit</a></td>
					<td <cfif NOT i mod 2>class="alternate"</cfif>>#authors[i].getName()#</td>
					<td <cfif NOT i mod 2>class="alternate"</cfif>>#authors[i].getEmail()#</td>
				</tr>
			</cfloop>
		</table>
		</cfoutput>
		
		</div>
	</div>
</div>	
	




</cf_layout>