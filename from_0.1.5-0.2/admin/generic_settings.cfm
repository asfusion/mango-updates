<cfsilent>
	<cfimport prefix="mangoAdmin" taglib="tags">
	
</cfsilent>
<cf_layout page="Settings">
<div id="wrapper">

	<div id="submenucontainer">
		<ul id="submenu">
			<li><a href="settings.cfm">General</a></li>
			<li><a href="skins.cfm">Skins</a></li> 
			<mangoAdmin:MenuEvent name="settingsNav" />
		</ul>
	</div>
	
	<div id="content">
		<h2 class="pageTitle"><mangoAdmin:Message title /></h2>
		
		<div id="innercontent">
		<cfoutput>
			<mangoAdmin:Message ifMessageExists type="settings" status="error">
				<p class="error"><mangoAdmin:Message text /></p>
			</mangoAdmin:Message>
			<mangoAdmin:Message ifMessageExists type="settings" status="success">
				<p class="message"><mangoAdmin:Message text /></p>
			</mangoAdmin:Message>

			<mangoAdmin:Message data />
		</cfoutput>
		</div>
	</div>
</div>
</cf_layout>