<cfsetting enablecfoutputonly="true">
<cfparam name="attributes.pageSize" default="0">
<cfparam name="request.currentPageNumber" default="0">

<cfif thisTag.executionmode is 'start'>

<cfset currentPageNumber = request.currentPageNumber />

<cfset ancestorlist = getbasetaglist() />	
	<cfif listfindnocase(ancestorlist,"cf_archives")>
		<cfset data = GetBaseTagData("cf_archives")/> 
		<cfset currentArchive = data.currentArchive>
	<cfelseif structkeyexists(request,"archive")>
		<cfset currentArchive = request.archive />
	<cfelse>
		<cfset currentArchive = request.blogManager.getArchivesManager().getArchive("recent",structnew()) />
	</cfif>

	<cfif attributes.pageSize>
		<cfset currentArchive.setPageSize(attributes.pageSize) />
	</cfif>
	
	

</cfif>

<cfsetting enablecfoutputonly="false">