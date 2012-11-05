<cfsetting enablecfoutputonly="true">
<cfparam name="attributes.from" type="numeric" default="1">
<cfparam name="attributes.count" type="numeric" default="5">
<cfparam name="attributes.recent" type="boolean" default="false">
<cfparam name="attributes.sortOrder" default="ascending"><!--- or descending --->

<!--- check to see if we are inside a post tag for post-specific comments --->
<cfset ancestorlist = getbasetaglist() />

<!--- starting tag --->
<cfif thisTag.executionMode EQ "start">
	<cfif NOT attributes.recent AND listfindnocase(ancestorlist,"cf_post")>
		<cfset data = GetBaseTagData("cf_post")/>
		<cfset currentPost = data.currentPost />
		<cfset items = request.blogManager.getCommentsManager().getCommentsByPost(currentPost.getId())/>
		
	<cfelseif NOT attributes.recent AND listfindnocase(ancestorlist,"cf_page")>
		<cfset data = GetBaseTagData("cf_page")/>
		<cfset currentPage = data.currentPage />
		<cfset items = request.blogManager.getCommentsManager().getCommentsByPost(currentPage.getId())/>
	<cfelse>
		<cfset items = request.blogManager.getCommentsManager().getRecentComments(attributes.count)/>
	</cfif>
	
	<cfset to = arraylen(items)>
	
	<cfparam name="attributes.to" type="numeric" default="#arraylen(items)#">
	
	<cfset counter = attributes.from>	
	<cfif counter LTE attributes.to AND counter LTE arraylen(items)>
		<cfif attributes.sortOrder EQ "ascending">
			<cfset currentComment = items[counter]>
		<cfelse>
			<cfset currentComment = items[attributes.to - counter + 1]>
		</cfif>
	<cfelse>
		<cfsetting enablecfoutputonly="false">
		 <cfexit>
	</cfif>
 </cfif>

<!--- ending tag --->
<cfif thisTag.executionMode EQ "end">
    <cfset counter = counter + 1>
	
   <cfif counter LTE attributes.to AND counter LTE arraylen(items)>
	<cfif attributes.sortOrder EQ "ascending">
			<cfset currentComment = items[counter]>
		<cfelse>
			<cfset currentComment = items[attributes.to - counter + 1]>
		</cfif><cfsetting enablecfoutputonly="false">
      <cfexit method="loop">
   </cfif>
   
</cfif>
<cfsetting enablecfoutputonly="false">