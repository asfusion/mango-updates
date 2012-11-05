<cfsilent>
	<cfparam name="error" default="">
	<cfparam name="message" default="">

	<cfif structkeyexists(url,"action")>
		<cfset result = request.formHandler.handleActivatePlugin(url) />
		<cfif result.message.getStatus() EQ "success">
			<cfset message = result.message.getText() />
			
		<cfelse>
			<cfset error = result.message.getText() />
		</cfif>
	</cfif>
	
	<cfset plugins = request.administrator.getPlugins() />
	<cfset inactivePlugins = arraynew(1) />
	<cfset activePlugins = arraynew(1) />
	
	<cfloop from="1" to="#arraylen(plugins)#" index="i">
		<cfif plugins[i].active>
			<cfset arrayappend(activePlugins,plugins[i]) />
		<cfelse>
			<cfset arrayappend(inactivePlugins,plugins[i]) />
		</cfif>
	</cfloop>
	<cfset currentAuthor = request.blogManager.getCurrentUser() />
</cfsilent>
<cf_layout page="Add-ons" title="Add-ons">
	<div id="wrapper">
	<cfif listfind(currentAuthor.currentRole.permissions, "manage_plugins")
				OR listfind(currentAuthor.currentRole.permissions, "set_plugins")>
		<div id="content">
		<h2 class="pageTitle">Installed Add-ons</h2>
		
			<div id="innercontent">
			<cfif len(error)>
				<p class="error"><cfoutput>#error#</cfoutput></p>
			</cfif>
			<cfif len(message)>
				<p class="message"><cfoutput>#message#</cfoutput></p>
			</cfif>

<cfoutput>
<cfif arraylen(activeplugins)>
<h2 class="sectionTitle">Active</h2>

<table>
<cfloop from="1" to="#arraylen(activePlugins)#" index="i">
	<tr><th>#activePlugins[i].name#</th>
	<th><a href="addons.cfm?action=deactivate&amp;id=#activePlugins[i].id#&amp;name=#listgetat(activePlugins[i].class,1,'.')#">De-activate</a></th></tr>
	<tr><td colspan="3"><p>#activePlugins[i].description#</p></td></tr>
	
</cfloop>  
</table>
</cfif>

<cfif arraylen(inactiveplugins)>
<h2 class="sectionTitle">Not Active</h2>

<table>
<cfloop from="1" to="#arraylen(inactivePlugins)#" index="i">
	<tr><th>#inactivePlugins[i].name#</th>
	<th><a href="addons.cfm?action=activate&amp;id=#inactivePlugins[i].id#&amp;name=#listgetat(inactivePlugins[i].class,1,'.')#">Activate</a></th></tr>
	<tr><td colspan="3"><p>#inactivePlugins[i].description#</p></td></tr>
	
</cfloop>
</table>
</cfif>

</cfoutput>

</div>
</div>
<cfelse><!--- not authorized --->
<div id="content"><div id="innercontent">
<p class="message">Your role does not allow managing add-ons</p>
</div></div>
</cfif>
</div>
</cf_layout>