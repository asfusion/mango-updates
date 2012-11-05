<cfif thisTag.executionMode is "start">
<cfimport prefix="mangoAdmin" taglib="tags">
<cfparam name="attributes.page" default=""/>
<cfparam name="attributes.title" default=""/>
<cfset blog = request.blogManager.getBlog() />
<cfset currentSkin = request.administrator.getSkin(blog.getSkin()) />
<cfcontent reset="true">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:spry="http://ns.adobe.com/spry">
<head><cfoutput>
	<meta http-equiv="Content-Type" content="text/html;charset=#blog.getCharset()#" />
	<title>#attributes.title#</cfoutput></title>
	<link href="assets/wforms/campground.css" rel="stylesheet" type="text/css" />
	<link href="assets/wforms/antique/wforms-jsonly.css" rel="alternate stylesheet" type="text/css" title="stylesheet activated by javascript" />
	<script type="text/javascript" src="assets/scripts/libraries.js" ></script>
	<script type="text/javascript" src="assets/scripts/behaviors.js" ></script>
	<script type="text/javascript" src="assets/wforms/wforms.js" ></script>
	<link href="assets/styles/tiger.css" rel="stylesheet" type="text/css" />
	<!--[if lte IE 6]>
<link href='assets/styles/tiger_ie.css' rel="stylesheet"  type='text/css' media='screen'>
<![endif]-->
	<link href="assets/styles/custom.css" rel="stylesheet" type="text/css" />
	
	<cfinclude template="editorSettings.cfm">
	
	<script type="text/javascript" src="assets/scripts/spry/xpath.js"></script>
	<script type="text/javascript" src="assets/scripts/spry/SpryData.js"></script>
	<mangoAdmin:Event name="beforeAdminHeaderEnd">
</head>		
<body>
<div id="container">
<div id="header">
	<h1><cfoutput>#blog.getTitle()# &gt; #attributes.title#</h1>
		<div id="viewsitelink"><a href="#blog.getUrl()#">Go to site</a></div></cfoutput>
	<div id="logout"><a href="index.cfm?logout=1">Logout</a></div>				
</div>
	<cf_navigation page="#attributes.page#">	
</cfif>	
	
<cfif thisTag.executionMode is "end">
<div id="footer"><a href="http://www.mangoblog.org" id="mangolink"><span>Powered by Mango Blog></span></a> <span class="footer_version">&nbsp;&nbsp;<cfoutput>#request.blogManager.getVersion()#</cfoutput></span></div>
</div><!--- container --->
</body>
</html>
</cfif>