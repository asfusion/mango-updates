<cfhtmlhead text='<script type="text/javascript" src="assets/scripts/swfobject/swfobject.js"></script>'>
<!--- 
COPYRIGHT
This version of the File Explorer cannot be used outside MangoBlog
We'll have a commercial version at AsFusion.com that removes the link and can be used 
in any project.
Thanks!
 --->
<cfset currentUser = request.blogManager.getCurrentUser() />
<cf_layout page="File Explorer" title="Files">
	 <style type="text/css">
            /* hide from ie on mac \*/
            html {
                height: 100%;
                overflow: hidden;
            }			
			#wrapper {
				height: 90%;
			}			
			#container {
				height: 90%;
			}
            /* end hide */
            body {
                height: 100%;
                margin: 0;
                padding: 0;
                background-color: #FFFFFF;
            }
        </style>
<div id="wrapper">
<cfif listfind(request.blogManager.getCurrentUser().currentRole.permissions, "manage_files")>
	<div id="content">	
		<h2 class="pageTitle">File Explorer</h2>
	<div id="flashcontent">
            <strong>In order to use the File Explorer, you need JavaScript and Flash Player 9+ support!</strong>
		</div>

        <script type="text/javascript">
        // <![CDATA[
            var so = new SWFObject('assets/swfs/FileExplorerLite.swf', 'fileExplorerLite', '100%', '100%', '9.0.115', '#FFFFFF');
            so.useExpressInstall('assets/scripts/swfobject/expressinstall.swf');
            so.addParam('menu', 'false');
            so.write('flashcontent');
        // ]]>
        </script>
		
	</div>
	<cfelse><!--- not authorized --->
<div id="content"><div id="innercontent">
<p class="message">Your role does not allow you to edit files</p>
</div></div>
</cfif>
</div>
</cf_layout>