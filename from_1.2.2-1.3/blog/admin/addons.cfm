<cfsilent>
	<cfparam name="error" default="">
	<cfparam name="message" default="">

	<cfif structkeyexists(form,"pluginUrl") and isvalid("url",form.pluginUrl)>
		<cfset result = request.formHandler.handleDownloadPlugin(form) />
		<cfif result.message.getStatus() EQ "success">
			<cfset message = result.message.getText() />
		<cfelse>
			<cfset error = result.message.getText() />
		</cfif>
	<cfelseif structkeyexists(url,"action")>
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

<h2 class="sectionTitle">Install or Update Add-on</h2>
<form action="addons.cfm" method="post">
	<p style="margin-left:1em;">
		<label for="pluginUrl">URL of add-on to download</label>
		<span class="hint">Enter the full URL of the add-on - this should be a .zip file.<br />
		If the add-on is already installed, it will be updated with the new version.</span>
		<span class="field">
			<input type="text" name="pluginUrl" id="pluginUrl" size="60" class="required url" />
			<input type="submit" value="Download add-on" />
		</span>
	</p>
</form>

<cfif arraylen(activeplugins)>
<h2 class="sectionTitle">Active</h2>

<table>
<cfloop from="1" to="#arraylen(activePlugins)#" index="i">
	<tr class="plugin_head">
		<th>#activePlugins[i].name# <i>#activePlugins[i].version#</i></th>
		<th class="act_link"><a href="addons.cfm?action=deactivate&amp;id=#activePlugins[i].id#&amp;name=#listgetat(activePlugins[i].class,1,'.')#">De-activate</a></th>
	</tr>
	<tr>
		<td colspan="2"><p>#activePlugins[i].description#</p></td>
	</tr>
	
</cfloop>  
</table>
</cfif>

<cfif arraylen(inactiveplugins)>
<h2 class="sectionTitle">Not Active</h2>

<table>
<cfloop from="1" to="#arraylen(inactivePlugins)#" index="i">
	<tr class="plugin_head">
		<th>#inactivePlugins[i].name# <i>#inactivePlugins[i].version#</i></th>
		<th class="act_link"><a href="addons.cfm?action=activate&amp;id=#inactivePlugins[i].id#&amp;name=#listgetat(inactivePlugins[i].class,1,'.')#">Activate</a></th>
	</tr>
	<tr>
		<td colspan="2"><p>#inactivePlugins[i].description#</p></td>
	</tr>
	
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

<script type="text/javascript">
$('tr.plugin_head').each(function() {
	var _this = $(this);
	var _desc = _this.next().hide();
	_this.children(':first-child').click(function(){
		_desc.toggle();
	}).css('cursor','pointer');
});
</script>
</cf_layout>