<cfsetting enablecfoutputonly="true">
<cfparam name="attributes.type" default="false">
<cfparam name="attributes.title" default="false">
<cfparam name="attributes.postcount" default="false">
<cfparam name="attributes.link" default="false">
<cfparam name="attributes.dateformat" default="dd mmm, yyyy">
<cfparam name="attributes.ifIsType" default="">
<cfparam name="attributes.ifPostCountGT" type="string" default="">
<cfparam name="attributes.ifPostCountLT" type="string" default="">
<cfparam name="attributes.ifHasNextPage" default="false">
<cfparam name="attributes.ifHasPreviousPage" default="false">
<cfparam name="attributes.pageSize" default="0">
<cfparam name="attributes.pageDifference" default="0"><!--- used for paging --->
<cfparam name="attributes.includeBasePath" default="true">

<cfif thisTag.executionmode is 'start'>

<!--- this tag has to be inside an archive tag --->
	<cfset data = GetBaseTagData("cf_archive")/> 
	<cfset currentArchive = data.currentArchive>
	<cfset currentPageNumber = data.currentPageNumber>

	<cfset pageNumb = currentPageNumber + attributes.pageDifference>
	<cfset prop = "" />
	
	<cfif len(attributes.ifIsType)>
		<cfset type = currentArchive.getType()>
		<cfset subtype = ""/>
		
		<cfif type EQ "date">
			<cfif currentArchive.getDay() NEQ 0>
				<cfset subtype = "day">
			<cfelseif currentArchive.getMonth() NEQ 0>
				<cfset subtype = "month">
			<cfelseif currentArchive.getYear() NEQ 0>
				<cfset subtype = "year">
			</cfif>		
		</cfif>
		
		<cfif attributes.ifIsType NEQ type AND subtype NEQ attributes.ifIsType>
			<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
		</cfif>
	</cfif>
	
	<cfif attributes.ifHasNextPage>
		<cfset pageSize = currentArchive.getPageSize() />
		<cfif (pageSize * currentPageNumber) + pageSize GTE currentArchive.getPostCount()>
			<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
		</cfif>
	</cfif>
	
	<cfif attributes.ifHasPreviousPage>
		<cfif request.currentPageNumber LT 1>
			<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
		</cfif>
	</cfif>

	<cfif len(attributes.ifPostCountGT)>
		<cfif NOT currentArchive.getPostCount() GT attributes.ifPostCountGT>
			<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
		</cfif>
	</cfif>
	
	<cfif len(attributes.ifPostCountLT)>
		<cfif NOT currentArchive.getPostCount() LT attributes.ifPostCountLT>
			<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
		</cfif>
	</cfif>

<cfif attributes.title>
	<cfif currentArchive.getType() EQ "date">
		<cfset prop = currentArchive.getFormattedTitle(attributes.dateformat) />
	<cfelse>
		<cfset prop = currentArchive.getTitle() />
	</cfif>
	
</cfif>

<cfif attributes.type>
	<cfset prop = currentArchive.getType() />
</cfif>

<cfif attributes.postcount>
	<cfset prop = currentArchive.getPostCount() />
</cfif>

<cfif attributes.link AND (pageNumb LTE 0 OR attributes.pageDifference EQ 0)>
		<cfset prop = currentArchive.getUrl() />
		<cfif attributes.includeBasePath>
			<cfset prop = request.blogManager.getBlog().getBasePath() & prop/>
		</cfif>
<cfelseif attributes.link AND pageNumb NEQ 0>
	<cfset prop = currentArchive.getUrl() />
	<cfif val(request.blogManager.getBlog().getSetting("useFriendlyUrls"))>
		<!--- see if there is a slash at the end of the url, if not, add it --->
		<cfif len(prop) EQ 0 OR right(prop,1) NEQ "/">
			<cfset prop = prop & "/">
		</cfif>
		<cfset prop = prop &  "page/#pageNumb#"/>
	<cfelse>
		<cfif NOT findnocase("?",prop)>
			<cfset prop = prop & "?" />
		</cfif>
		<cfset prop = prop & "&amp;page=#pageNumb#">
	</cfif>
	
	<cfif attributes.includeBasePath>
		<cfset prop = request.blogManager.getBlog().getBasePath() & prop/>
	</cfif>
</cfif>

<cfoutput>#prop#</cfoutput>

</cfif>

<cfsetting enablecfoutputonly="false">