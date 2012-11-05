<cfset basePath = request.blogManager.getBlog().getBasePath() & "admin/"/>
<cfcontent reset="true" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- 
 * File Explorer plugin cannot be used outside MangoBlog. Please visit asfusion.com 
 * to get a commercial version
 *
 * @author AsFusion
 * @copyright Copyright ©2008, AsFusion, All rights reserved.
 * -->
<head>
	<title>File Explorer</title>
	<cfoutput><script type="text/javascript" src="#basepath#assets/scripts/swfobject/swfobject.js"></script>
	<script type="text/javascript">
		swfobject.registerObject("fileExplorerLite", "9.0.115", "#basepath#assets/scripts/swfobject/expressInstall.swf");
	</script></cfoutput>
	<script language="javascript" src="../../tiny_mce_popup.js"></script>
	<script language="javascript" >
	var FileBrowserDialogue = {
    init : function () {
        // Here goes your code for setting your custom things onLoad.
    },
    selectFile : function (file) {
  		var baseURLAssets = tinyMCE.activeEditor.getParam('plugin_asffileexplorer_assetsUrl');
  		if (file.indexOf('/') == 0){
				file = file.substring(1);//drop the first character
			}
        var URL = baseURLAssets + file;
        var win = tinyMCEPopup.getWindowArg("window");

        // insert information now
        win.document.getElementById(tinyMCEPopup.getWindowArg("input")).value = URL;

        // for image browsers: update image dimensions
        if (win.ImageDialog){
        	if (win.ImageDialog.getImageData) win.ImageDialog.getImageData();
        	if (win.ImageDialog.showPreviewImage) win.ImageDialog.showPreviewImage(URL);
		}
        // close popup window
        tinyMCEPopup.close();
    }
}

tinyMCEPopup.onInit.add(FileBrowserDialogue.init, FileBrowserDialogue);
	</script>

<style type="text/css">
            /* hide from ie on mac \*/
            html {
                height: 100%;
                overflow: hidden;
            }			
            /* end hide */
            body {
                height: 100%;
                margin: 0;
                padding: 0;
                background-color: #FFFFFF;
            }
        </style>
</head>
<body>
		<cfoutput>
			<object id="fileExplorerLite" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%">
			<param name="movie" value="#basePath#assets/swfs/AssetSelector.swf" />
			<param name="bgcolor" value="##FFFFFF" />
			<param name="flashvars" value="path=#basePath#com/asfusion/" />
        	<!--[if !IE]>-->
			<object type="application/x-shockwave-flash" data="#basePath#assets/swfs/AssetSelector.swf" width="100%" height="100%">
				<param name="bgcolor" value="##FFFFFF" />
				<param name="flashvars" value="path=#basePath#com/asfusion/" />
			<!--<![endif]-->
			<div>
				<p><strong>In order to use the File Explorer, you need Flash Player 9+ support!</strong></p>
				<p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a></p>
			</div>
			<!--[if !IE]>-->
			</object>
			<!--<![endif]-->
		</object>
		</cfoutput>
</body> 
</html> 
