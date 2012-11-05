<cfimport prefix="mangoAdmin" taglib="tags">
<cfset assetsSettings = blog.getSetting('assets') />
		
<cfif find("/", assetsSettings.path) EQ 1>
	<!--- absolute path, prepend only domain --->
	<cfset fileUrl = assetsSettings.path />
<cfelse>
	<cfset fileUrl = blog.getUrl() & assetsSettings.path />
</cfif>
<!-- TinyMCE -->
<script type="text/javascript" src="assets/editors/tinymce_3/jscripts/tiny_mce/tiny_mce.js"></script>
<script type="text/javascript">
	<mangoAdmin:Event name="beforeTinyMCEinit" />
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
		extended_valid_elements : "span[class|style],code[class]",
		theme_advanced_resize_horizontal : false,
		theme_advanced_resizing : true,
		relative_urls : false,
		remove_linebreaks : false,
		document_base_url : "<cfoutput>#blog.getbasePath()#</cfoutput>",
		<cfif len(currentSkin.adminEditorCss)><cfoutput>
		content_css : "#blog.getbasePath()#skins/#blog.getSkin()#/#currentSkin.adminEditorCss#",
		</cfoutput></cfif>
		<mangoAdmin:Event name="tinyMCEinit" />
		<cfoutput>
		plugin_asffileexplorer_browseurl : '#blog.getbasePath()#admin/assets/editors/tinymce_3/jscripts/tiny_mce/plugins/asffileexplorer/fileexplorer.html',
		plugin_asffileexplorer_assetsUrl:'#fileUrl#',  
		file_browser_callback : 'ASFFileExplorerPlugin_browse'
		</cfoutput>,
		onchange_callback: function(editor) {
			tinyMCE.triggerSave();
			$("#" + editor.id).valid();
		}
	});
	<mangoAdmin:Event name="afterTinyMCEinit" />
</script>
<!-- /TinyMCE -->