<cfsetting enablecfoutputonly="true">
<cfparam name="attributes.id" default="false">
<cfparam name="attributes.title" default="false">
<cfparam name="attributes.body" default="false">
<cfparam name="attributes.date" default="false">
<cfparam name="attributes.dateformat" default="mm/dd/yyyy">
<cfparam name="attributes.datemodified" default="false">
<cfparam name="attributes.timemodified" default="false">
<cfparam name="attributes.time" default="false">
<cfparam name="attributes.timeformat" default="short">
<cfparam name="attributes.author" default="false">
<cfparam name="attributes.excerpt" default="false">
<cfparam name="attributes.commentcount" default="false">
<cfparam name="attributes.trackbackcount" default="false">
<cfparam name="attributes.link" default="false">
<cfparam name="attributes.customfield" default="">
<cfparam name="attributes.currentCount" default="false">

<!--- IF attributes --->
<cfparam name="attributes.ifcommentsallowed" default="false">
<cfparam name="attributes.ifnotcommentsallowed" default="false">
<cfparam name="attributes.ifhasExcerpt" default="false">
<cfparam name="attributes.ifnothasExcerpt" default="false">
<cfparam name="attributes.ifCommentCountGT" type="string" default="">
<cfparam name="attributes.ifCommentCountLT" type="string" default="">
<cfparam name="attributes.ifHasCustomField" type="string" default="">
<cfparam name="attributes.ifNotHasCustomField" type="string" default="">
<cfparam name="attributes.ifCurrentCountLT" type="string" default="">
<cfparam name="attributes.ifCurrentCountGT" type="string" default="">

<cfparam name="attributes.format" default="plain">
<cfparam name="attributes.includeBasePath" default="true">

<cfif thisTag.executionmode is 'start'>
	<cfset data = GetBaseTagData("cf_post",1)/>
	<cfset currentPost = data.currentPost />
	<cfset currentItemCount = data.currentItemCount />
	<cfset prop = "" />

	
	<cfif attributes.ifhasExcerpt AND NOT len(currentPost.getExcerpt())>
		<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif attributes.ifnothasExcerpt AND len(currentPost.getExcerpt())>
		<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>			
	
	<cfif attributes.ifcommentsallowed AND NOT currentPost.getCommentsAllowed()>
		<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif attributes.ifnotcommentsallowed AND currentPost.getCommentsAllowed()>
		<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif len(attributes.ifCommentCountGT) AND currentPost.getCommentCount() LTE attributes.ifCommentCountGT>
		<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif len(attributes.ifCommentCountLT) AND currentPost.getCommentCount() GTE attributes.ifCommentCountLT>
		<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif len(attributes.ifHasCustomField) AND NOT currentPost.customFieldExists(attributes.ifHasCustomField)>
		<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif len(attributes.ifNotHasCustomField) AND currentPost.customFieldExists(attributes.ifNotHasCustomField)>
		<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif len(attributes.ifCurrentCountLT) AND currentItemCount GTE attributes.ifCommentCountLT>
		<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif len(attributes.ifCurrentCountGT) AND currentItemCount LTE attributes.ifCommentCountGT>
		<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif attributes.title>		
		<cfset prop = currentPost.getTitle() />
	</cfif>
	
	<cfif attributes.body>				
		<cfset prop = currentPost.getContent() />
	</cfif>
	
	<cfif attributes.date>
		<cfif attributes.dateformat NEQ "utc">
			<cfset prop = dateformat(currentPost.getPostedOn(),attributes.dateformat) />
		<cfelse>
			<cfset prop = GetHttpTimeString(toString(currentPost.getPostedOn())) />
		</cfif>
	</cfif>
			
	<cfif attributes.time>
		<cfset prop = timeformat(currentPost.getPostedOn(),attributes.timeformat) />	
	</cfif>
		
	<cfif attributes.datemodified>
		<cfset prop = dateformat(currentPost.getLastModified(),attributes.dateformat) />	
	</cfif>
	
	<cfif attributes.timemodified>
		<cfset prop = dateformat(currentPost.getLastModified(),attributes.timeformat) />	
	</cfif>

	<cfif attributes.author>
		<cfset prop = currentPost.getAuthor() />
	</cfif>
	
	<cfif attributes.commentcount>
		<cfset prop = currentPost.getCommentCount() />
	</cfif>
	
	<cfif attributes.trackbackcount>
		<cfset prop = 0 />
	</cfif>
	
	<cfif attributes.id>
		<cfset prop = currentPost.getId() />
	</cfif>
	
	<cfif attributes.excerpt>
		<cfset prop = currentPost.getExcerpt() />
	</cfif>
	
	<cfif attributes.link>
		<cfset prop = currentPost.getUrl() />
		<cfif attributes.includeBasePath>
			<cfset prop = request.blogManager.getBlog().getBasePath() & prop/>
		</cfif>
	</cfif>
	
	<cfif len(attributes.customfield)>
		<cfif currentPost.customFieldExists(attributes.customfield)>
		<cfset prop = currentPost.getCustomField(attributes.customfield).value />
		</cfif>
	</cfif>

	<cfif attributes.currentCount>
		<cfset prop = currentItemCount />
	</cfif>
	
	<cfif attributes.format EQ "xml">
		<cfoutput>#xmlformat(prop)#</cfoutput>
	<cfelse>
		<cfoutput>#prop#</cfoutput>
	</cfif>

</cfif>

<cfsetting enablecfoutputonly="false">