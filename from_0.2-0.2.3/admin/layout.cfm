<cfif thisTag.executionMode is "start">
<cfparam name="attributes.page" default="summary"/>
<cfparam name="attributes.includenav" default="true">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:spry="http://ns.adobe.com/spry">
<head>
	<title><cfoutput>#attributes.page#</cfoutput></title>
	<!--- <script src="assets/scripts.js" type="text/javascript"></script> --->
	<link href="assets/wforms/campground.css" rel="stylesheet" type="text/css" />
	<link href="assets/wforms/antique/wforms-jsonly.css" rel="alternate stylesheet" type="text/css" title="stylesheet activated by javascript" />
	<script type="text/javascript" src="assets/scripts/libraries.js" ></script>
	<script type="text/javascript" src="assets/scripts/behaviors.js" ></script>
	<script type="text/javascript" src="assets/wforms/wforms.js" ></script>
	<link href="assets/styles/tiger.css" rel="stylesheet" type="text/css" />
	<!--[if lte IE 6]>
<link href='assets/styles/tiger_ie.css' rel="stylesheet"  type='text/css' media='screen'>
<![endif]-->
	<!-- TinyMCE -->
<script language="javascript" type="text/javascript" src="assets/editors/tinymce/jscripts/tiny_mce/tiny_mce.js"></script>
<script language="javascript" type="text/javascript">
	tinyMCE.init({
		mode : "exact",
		elements : "contentField,wf_Excerpt1,authorDescription",
		theme : "advanced",
		plugins : "simplebrowser,table,save,preview,zoom,flash,contextmenu,paste,fullscreen,noneditable",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_path_location : "bottom",
		
		theme_advanced_buttons1 : "cut,copy,paste,pastetext,pasteword,separator,tablecontrols,preview,zoom,separator, fullscreen,code,help",
	theme_advanced_buttons2 : "bold,italic,formatselect,styleselect,bullist,numlist,del,separator,outdent,indent,separator,undo,redo,separator,link,unlink,anchor,image,cleanup,removeformat,separator,sub,sup,charmap",
	theme_advanced_buttons3 : "",
		
		<cfif len(request.currentSkin.adminEditorCss)>
<cfoutput>content_css : "#request.blogManager.getBlog().getbasePath()#skins/#request.blogManager.getBlog().getSkin()#/#request.currentSkin.adminEditorCss#",</cfoutput></cfif>
	    plugin_insertdate_dateFormat : "%Y-%m-%d",
	    plugin_insertdate_timeFormat : "%H:%M:%S",
		extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
		theme_advanced_resize_horizontal : false,
		theme_advanced_resizing : true,
		<cfoutput>document_base_url : "#request.blogManager.getBlog().getbasePath()#",</cfoutput>
		relative_urls : false,
<cfoutput>      plugin_simplebrowser_browselinkurl : '#request.blogManager.getBlog().getbasePath()#admin/assets/editors/tinymce/jscripts/tiny_mce/plugins/simplebrowser/browser.html?Connector=connectors/cfm/connector.cfm',
      plugin_simplebrowser_browseimageurl : '#request.blogManager.getBlog().getbasePath()#admin/assets/editors/tinymce/jscripts/tiny_mce/plugins/simplebrowser/browser.html?Type=Image&Connector=connectors/cfm/connector.cfm',
      plugin_simplebrowser_browseflashurl : '#request.blogManager.getBlog().getbasePath()#admin/assets/editors/tinymce/jscripts/tiny_mce/plugins/simplebrowser/browser.html?Type=Flash&Connector=connectors/cfm/connector.cfm'</cfoutput>
		
	});
</script>
<!-- /TinyMCE -->
	<script type="text/javascript" src="assets/scripts/spry/xpath.js"></script>
	<script type="text/javascript" src="assets/scripts/spry/SpryData.js"></script>
</head>		
<body>
<div id="container">	
<div id="header">
	<h1><cfoutput>#request.blogManager.getBlog().getTitle()# &gt; #attributes.page#</h1>
		<div id="viewsitelink"><a href="#request.blogManager.getBlog().getUrl()#">Go to site</a></div></cfoutput>
	<div id="logout"><a href="index.cfm?logout=1">Logout</a></div>				
</div>
	<cf_navigation page="#attributes.page#" includenav="#attributes.includenav#">
	
</cfif>	
	
<cfif thisTag.executionMode is "end">

<div id="footer"><a href="http://www.mangoblog.org" id="mangolink"><span>Powered by Mango Blog></span></a> <span class="footer_version">&nbsp;&nbsp;<cfoutput>#request.blogManager.getVersion()#</cfoutput></span></div>
</div><!--- container --->
</body>
</html>
</cfif>

