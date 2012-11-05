<cfsilent>
	<cfparam name="id" default="0" />
	<cfparam name="name" default="" />		
	<cfparam name="username" default="" />
	<cfparam name="password" default="" />
	<cfparam name="email" default="" />
	<cfparam name="error" default="" />
	<cfparam name="message" default="" />
	<cfparam name="description" default="" />
	<cfparam name="shortdescription" default="" />
	
	<cfif structkeyexists(form,"submit")>
		<cfset result = request.formHandler.handleAddAuthor(form) />
		<cfif result.message.getStatus() EQ "success">
			<cfset message = result.message.getText() />
		<cfelse>
			<cfset error = result.message.getText() />
		</cfif>
	</cfif>
	
</cfsilent>
<cf_layout page="Authors">
<div id="wrapper">
	<div id="submenucontainer">
		<ul id="submenu">
			<li><a href="author_new.cfm"  class="current">New</a></li>	
			<li><a href="authors.cfm">Edit</a></li>
		</ul>
	</div>
	
	<div id="content">
		<h2 class="pageTitle">New author</h2>	
		
		<div id="innercontent">
		<cfif len(error)>
			<p class="error"><cfoutput>#error#</cfoutput></p>
		</cfif>
		<cfif len(message)>
			<p class="message"><cfoutput>#message#</cfoutput></p>
		</cfif>
		
		<cfinclude template="authorForm.cfm">
		
		</div>
	</div>
</div>

</cf_layout>