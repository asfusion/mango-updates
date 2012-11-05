<cfsetting enablecfoutputonly="true">
<cfparam name="attributes.title" default="false">
<cfparam name="attributes.url" default="false">
<cfparam name="attributes.description" default="false">
<cfparam name="attributes.tagline" default="false">
<cfparam name="attributes.version" default="false">
<cfparam name="attributes.skinurl" default="false">
<cfparam name="attributes.charset" default="false">
<cfparam name="attributes.basePath" default="false">
<cfparam name="attributes.searchUrl" default="false">
<cfparam name="attributes.atomUrl" default="false">
<cfparam name="attributes.rssUrl" default="false">
<cfparam name="attributes.apiUrl" default="false">
<cfparam name="attributes.host" default="false">
<cfparam name="attributes.id" default="false">
<cfparam name="attributes.languageAbbr" default="false">
<cfparam name="attributes.date" default="false">
<cfparam name="attributes.format" default="plain">
<cfparam name="attributes.dateformat" default="mm/dd/yyyy">
<cfparam name="attributes.fullUrl" default="false">
<cfparam name="attributes.descriptionParagraphFormat" default="false">

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
	<cfset blog = request.blogManager.getBlog()>
	<cfset prop = "" />
	
	<cfif attributes.title>
		<cfset prop = blog.getTitle() />
	</cfif>
	
	<cfif attributes.url>
		<cfset prop = blog.getUrl() />	
	</cfif>
	
	<cfif attributes.skinurl>
		<cfset prop = "#blog.getBasePath()#skins/#blog.getSkin()#/" >	
	</cfif>
	
	<cfif attributes.description>
		<cfset prop = blog.getDescription() />
		<cfif attributes.descriptionParagraphFormat>
			<cfset prop = ParagraphFormat2(prop) />
		</cfif>
	</cfif>
	
	<cfif attributes.tagline>
		<cfset prop = blog.getTagline() />	
	</cfif>
	
	<cfif attributes.version>
		<cfset prop = request.blogManager.getVersion() />	
	</cfif>
	
	<cfif attributes.charset>
		<cfset prop = blog.getCharset() />
	</cfif>
	
	<cfif attributes.basePath>
		<cfset prop = blog.getBasePath() />
	</cfif>
	
	<cfif attributes.searchUrl>
		<cfset prop = blog.getBasePath() & blog.getSetting("searchUrl") />	
	</cfif>
	
	<cfif attributes.atomUrl>

		<cfif findnocase("http", blog.getSetting("atomUrl")) EQ 1>
			<cfset prop = blog.getSetting("atomUrl") />
		<cfelse>
			<cfset prop = blog.getUrl() & blog.getSetting("atomUrl") />
		</cfif>
	
	</cfif>
	
	<cfif attributes.rssUrl>

		<cfif findnocase("http", blog.getSetting("rssUrl")) EQ 1>
			<cfset prop = blog.getSetting("rssUrl") />
		<cfelse>
			<cfset prop = blog.getUrl() & blog.getSetting("rssUrl") />
		</cfif>
	
	</cfif>
	
	<cfif attributes.apiUrl>
		<cfset prop = blog.getUrl() & blog.getSetting("apiUrl") />	
	</cfif>
	
	<cfif attributes.languageAbbr>
		<cfset prop = blog.getSetting("language") />	
	</cfif>
	
	<cfif attributes.host>
		<cfset prop = blog.getHost() />	
	</cfif>
	
	<cfif attributes.date>
		<cfset prop = dateformat(now(),attributes.dateformat) />	
	</cfif>
	
	<cfif attributes.id>
		<cfset prop = blog.getId() />	
	</cfif>
	
	<cfif attributes.format EQ "xml">
		<cfoutput>#xmlformat(prop)#</cfoutput>
	<cfelse>
		<cfoutput>#prop#</cfoutput>
	</cfif>
	
	
</cfif>
<cfsetting enablecfoutputonly="false">