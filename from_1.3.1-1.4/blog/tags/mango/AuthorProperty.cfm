<cfsetting enablecfoutputonly="true">
<cfparam name="attributes.id" default="false">
<cfparam name="attributes.shortdescription" default="false">
<cfparam name="attributes.description" default="false">
<cfparam name="attributes.name" default="false">
<cfparam name="attributes.link" default="false">
<cfparam name="attributes.archivesLink" default="false">
<cfparam name="attributes.email" default="false">
<cfparam name="attributes.picture" default="false">
<cfparam name="attributes.role" default="false">
<cfparam name="attributes.ifHasPicture" default="false">
<cfparam name="attributes.descriptionParagraphFormat" default="false">
<cfparam name="attributes.includeBasePath" default="true">
<cfparam name="attributes.format" default="plain">

<cfif thisTag.executionmode is 'start'>
<cfscript>
/**
 * An &quot;enhanced&quot; version of ParagraphFormat.
 * Added replacement of tab with nonbreaking space char, idea by Mark R Andrachek.
 * Rewrite and multiOS support by Nathan Dintenfas.
 * 
 * @param string 	 The string to format. (Required)
 * @return Returns a string. 
 * @author Ben Forta (ben@forta.com) 
 * @version 3, June 26, 2002 
 */
function ParagraphFormat2(str) {
	//first make Windows style into Unix style
	str = replace(str,chr(13)&chr(10),chr(10),"ALL");
	//now make Macintosh style into Unix style
	str = replace(str,chr(13),chr(10),"ALL");
	//now fix tabs
	str = replace(str,chr(9),"&nbsp;&nbsp;&nbsp;","ALL");
	//now return the text formatted in HTML
	return replace(str,chr(10),"<br />","ALL");
}

</cfscript>

<cfset ancestorlist = getbasetaglist() />

	<cfif listfindnocase(ancestorlist,"cf_author")>
		<cfset data = GetBaseTagData("cf_author")/>
	<cfelseif listfindnocase(ancestorlist,"cf_authenticatedauthor")>
		<cfset data = GetBaseTagData("cf_authenticatedauthor")/>
	</cfif>

<cfset currentAuthor = data.currentAuthor />
<cfset prop = "" />

<cfif attributes.ifHasPicture>
		<cfif NOT len(currentAuthor.getPicture())>
			<cfsetting enablecfoutputonly="false"><cfexit method="exittag">
		</cfif>
	</cfif>

<cfif attributes.shortdescription>
	<cfset prop = currentAuthor.getShortDescription() />
	<cfif attributes.descriptionParagraphFormat>
		<cfset prop = ParagraphFormat2(prop) />
	</cfif>
</cfif>

<cfif attributes.description>
	<cfset prop = currentAuthor.getDescription() />
	<cfif attributes.descriptionParagraphFormat>
		<cfset prop = ParagraphFormat2(prop) />
	</cfif>
</cfif>

<cfif attributes.name>
	<cfset prop = currentAuthor.getName() />
</cfif>

<cfif attributes.id>
	<cfset prop = currentAuthor.getId() />
</cfif>

<cfif attributes.archivesLink>
	<cfset prop = currentAuthor.getArchivesUrl() />
	<cfif attributes.includeBasePath>
		<cfset prop = request.blogManager.getBlog().getBasePath() & prop/>
	</cfif>
</cfif>

<cfif attributes.link>
	<cfset prop = currentAuthor.getUrl() />
	<cfif attributes.includeBasePath>
		<cfset prop = request.blogManager.getBlog().getBasePath() & prop/>
	</cfif>
</cfif>

<cfif attributes.email>
	<cfset prop = currentAuthor.getEmail() />
</cfif>

<cfif attributes.role>
	<cfset prop = currentAuthor.getCurrentRole().getName() />
</cfif>

<cfif attributes.picture>
	<cfset prop = currentAuthor.getPicture() />
</cfif>
<cfif attributes.format EQ "xml">
	<cfset prop = xmlformat(prop) />
<cfelseif attributes.format EQ "escapedHtml">
	<cfset prop = htmleditformat(prop)>
</cfif>
<cfoutput>#prop#</cfoutput>
</cfif>

<cfsetting enablecfoutputonly="false">