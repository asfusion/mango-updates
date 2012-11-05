<cfsetting enablecfoutputonly="true">
<cfparam name="attributes.selfUrl" default="false">

<cfif thisTag.executionmode is 'start'>
	<cfif attributes.selfUrl>
		<cfset address = cgi.script_name />
		<cfif len(cgi.path_info)>
			<cfset address = address & cgi.path_info />
		</cfif>
		<cfif len(cgi.query_string)>
			<cfset address = address & "?" & cgi.query_string />
		</cfif>
<cfoutput>#address#</cfoutput></cfif>
</cfif>
<cfsetting enablecfoutputonly="false">