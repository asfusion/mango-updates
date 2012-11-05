<cfsetting enablecfoutputonly="true">
<cfparam name="attributes.name" default="posts">
<cfparam name="attributes.menu" default="primary">
<cfparam name="attributes.liClass" default="">
<cfparam name="attributes.owner" default="">
<cfparam name="selected" default="">

<cfif thisTag.executionmode EQ "start">
<!--- all these events are type template --->
	<cfif structkeyexists(request.externalData,"selected")>
		<cfset selected = request.externalData.selected />
	</cfif>
		
	<cfif structkeyexists(request.externalData,"owner")>
		<cfset attributes.owner = request.externalData.owner />
	</cfif>
	
	<!--- get custom menu items --->
	<cfset panels = request.administrator.getCustomPanels() />
	<cfset links = panels[attributes.name] />

	<cfoutput><cfloop from="1" to="#arraylen(links)#" index="i">
		<cfif links[i].showInMenu EQ attributes.menu AND links[i].active>
			<li class="#links[i].styleName#<cfif listfind(attributes.owner,links[i].id)> current</cfif>"><a href="#links[i].address#">#links[i].label#</a></li>
		</cfif>
	</cfloop></cfoutput>
</cfif>
<cfsetting enablecfoutputonly="false">