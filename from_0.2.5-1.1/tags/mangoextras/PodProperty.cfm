<cfsetting enablecfoutputonly="true">
<cfparam name="attributes.id" default="false">
<cfparam name="attributes.title" default="false">
<cfparam name="attributes.content" default="false">
<cfparam name="attributes.ifNotHasTitle" default="false">
<cfparam name="attributes.ifHasTitle" default="false">

<cfif thisTag.executionmode is 'start'>
	
<cfset data = GetBaseTagData("cf_pod")/>
<cfset currentPod = data.currentPod />
<cfset prop = "" />

<cfif attributes.ifHasTitle AND NOT len(currentPod.title)>
	<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
</cfif>

<cfif attributes.ifNotHasTitle AND len(currentPod.title)>
	<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
</cfif>

<cfif attributes.title>
	<cfset prop = currentPod.title />
</cfif>

<cfif attributes.content>
	<cfset prop = currentPod.content />
</cfif>

<cfoutput>#prop#</cfoutput>

</cfif>

<cfsetting enablecfoutputonly="false">