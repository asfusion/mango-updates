<cfset assetsSettings = blog.getSetting('assets') />
		
<cfif find("/", assetsSettings.path) EQ 1>
	<!--- absolute path, prepend only domain --->
	<cfset fileUrl = assetsSettings.path />
<cfelse>
	<cfset fileUrl = blog.getUrl() & assetsSettings.path />
</cfif>
<!-- TinyMCE -->
<script language="javascript" type="text/javascript" src="assets/editors/tinymce_3/jscripts/tiny_mce/tiny_mce.js"></script>
<script language="javascript" type="text/javascript">
	tinyMCE.init({
		mode : "specific_textareas",
		editor_selector : "htmlEditor",
		theme : "advanced",
		plugins : "table,save,contextmenu,paste,noneditable,asffileexplorer",
		entity_encoding : "raw",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_path_location : "bottom",
		
		theme_advanced_buttons1 : "bold,italic,formatselect,styleselect,bullist,numlist,del,separator,outdent,indent,separator,undo,redo,separator,link,unlink,anchor,image,cleanup,removeformat,charmap,code,help",
		theme_advanced_buttons2 : "",
		theme_advanced_buttons3 : "",
		
		<cfif len(currentSkin.adminEditorCss)>
<cfoutput>content_css : "#blog.getbasePath()#skins/#blog.getSkin()#/#currentSkin.adminEditorCss#",</cfoutput></cfif>
		extended_valid_elements : "span[class|style],code[class]",
		theme_advanced_resize_horizontal : false,
		theme_advanced_resizing : true,
		<cfoutput>document_base_url : "#blog.getbasePath()#",</cfoutput>
		relative_urls : false,
		remove_linebreaks : false,
<cfoutput>
	 plugin_asffileexplorer_browseurl : '#blog.getbasePath()#admin/assets/editors/tinymce_3/jscripts/tiny_mce/plugins/asffileexplorer/fileexplorer.html',
	 plugin_asffileexplorer_assetsUrl:'#fileUrl#',  
	 file_browser_callback : 'ASFFileExplorerPlugin_browse'
	 </cfoutput>
	});
</script>
<!-- /TinyMCE -->