/**
 * $Id: editor_plugin_src.js 520 2008-01-07 16:30:32Z spocke $
 *
 * @author Moxiecode
 * @copyright Copyright © 2004-2008, Moxiecode Systems AB, All rights reserved.
 */

(function() {
	tinymce.create('tinymce.plugins.ASFFileExplorerPlugin', {
		init : function(ed, url) {
		},

		getInfo : function() {
			return {
				longname : 'ASF File Explorer',
				author : 'AsFusion',
				authorurl : 'http://www.asfusion.com',
				infourl : 'http://www.asfusion.com',
				version : 1
			};
		},
	});
	
	// Register plugin
	tinymce.PluginManager.add('asffileexplorer', tinymce.plugins.ASFFileExplorerPlugin);
})();

function ASFFileExplorerPlugin_browse(field_name, current_url, type, win) {

	var url = tinyMCE.activeEditor.getParam('plugin_asffileexplorer_browseurl') + "?type=" + type;

	tinyMCE.activeEditor.windowManager.open({
        file : url,
        title : 'File Browser',
        width : 600, 
        height : 450,
        resizable : "yes",
        inline : "yes",  // This parameter only has an effect if you use the inlinepopups plugin!
        close_previous : "no"
    }, {
        window : win,
        input : field_name
    });
    return false;
};