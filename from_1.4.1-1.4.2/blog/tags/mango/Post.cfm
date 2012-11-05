<cfsetting enablecfoutputonly="true">
<cfif thisTag.executionmode is "start">

<cfparam name="attributes.ifCurrentIsOdd" type="boolean" default="false">
<cfparam name="attributes.ifCurrentIsEven" type="boolean" default="false">
<cfparam name="attributes.ifCurrentIsFirst" type="boolean" default="false">
<cfparam name="attributes.ifCurrentIsLast" type="boolean" default="false">
<cfparam name="attributes.ifCurrentIsNotFirst" type="boolean" default="false">
<cfparam name="attributes.ifCurrentIsNotLast" type="boolean" default="false">

	<cfset ancestorlist = getbasetaglist() />

	<cfif listfindnocase(ancestorlist,"cf_posts")>
		<cfset data = GetBaseTagData("cf_posts")/> 
		<cfset currentPost = data.currentPost />
		<cfset currentItemCount = data.counter />
		<cfset total = data.to />
	<cfelse>
		<!--- this boolean parameter will allow previewing a draft post --->
		<cfset isAuthor = false />
		<cfif structkeyexists(request.externalData,"preview")>
			<cfset isAuthor = request.blogManager.isCurrentUserLoggedIn() />
		</cfif>
		<cfif structkeyexists(request.externalData,"preview") and isValid("UUID",request.externalData.postName)>
			<cfset currentPost = request.blogManager.getPostsManager().getPostById(request.externalData.postName,isAuthor,true) />
		<cfelse>
			<cfset currentPost = request.blogManager.getPostsManager().getPostByName(request.externalData.postName,isAuthor,true) />
		</cfif>
		<cfset currentItemCount = 1 />
		<cfset total = 1 />
	</cfif>
	
	<cfif attributes.ifCurrentIsOdd AND NOT currentItemCount mod 2>
			<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif attributes.ifCurrentIsEven AND currentItemCount mod 2>
			<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif attributes.ifCurrentIsFirst AND currentItemCount NEQ 1>
			<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif attributes.ifCurrentIsLast AND currentItemCount NEQ total>
			<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif attributes.ifCurrentIsNotFirst AND currentItemCount EQ 1>
			<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
	<cfif attributes.ifCurrentIsNotLast AND currentItemCount EQ total>
			<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
	</cfif>
	
</cfif>

<cfsetting enablecfoutputonly="false">