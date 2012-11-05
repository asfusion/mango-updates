<cfsetting enablecfoutputonly="true">
<cfparam name="attributes.size" default="80">
<cfparam name="attributes.rating" default="R">
<cfparam name="attributes.defaultimg" default="">
<cfparam name="attributes.border" default="">
<cfparam name="attributes.imgtag" default="true">
<cfparam name="attributes.class" default="">

<cfif thisTag.executionmode is 'start'>
	<cfset ancestorlist = getbasetaglist() />

	<cfif listfindnocase(ancestorlist,"cf_comments")>
		<cfset gravatar_data = GetBaseTagData("cf_comments")/>
		<cfset gravatar_currentComment = gravatar_data.currentComment />
		<cfset gravatar_class = "" />
		<cfset blog = request.blogManager.getBlog() />
		<cfset gravatar_url = 
		"http://www.gravatar.com/avatar.php?gravatar_id=#LCase(hash(LCase(gravatar_currentComment.getCreatorEmail())))#&amp;rating=#attributes.rating#&amp;size=#attributes.size#"/>

		<cfif len(attributes.defaultimg)>
			<cfif not findnocase("http://",attributes.defaultimg)>
				<cfset attributes.defaultimg = blog.getUrl() & "skins/#blog.getSkin()#/" & attributes.defaultimg />
			</cfif>
			<cfset gravatar_url = gravatar_url & "&amp;default=" & URLEncodedFormat(attributes.defaultimg) />
		</cfif>
			
		<cfif len(attributes.border)>
			<cfset gravatar_url = gravatar_url & "&amp;border=" & attributes.border />
		</cfif>
		
		<cfif len(attributes.class)>
			<cfset gravatar_class = 'class="#attributes.class#"'/>
		</cfif>
	
		<cfif attributes.imgtag>
			<cfoutput><img alt="#gravatar_currentComment.getCreatorName()#" src="#gravatar_url#" title="#gravatar_currentComment.getCreatorName()#" width="#attributes.size#"  height="#attributes.size#" #gravatar_class# /></cfoutput>		
		<cfelse>
			<cfoutput>#gravatar_url#</cfoutput>
		</cfif>
	</cfif>
</cfif>
<cfsetting enablecfoutputonly="false">