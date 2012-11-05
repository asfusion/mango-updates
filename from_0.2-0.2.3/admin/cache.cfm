<cfhtmlhead text='<script type="text/javascript" src="assets/scripts/swfobject/swfobject.js"></script>'>
<cf_layout page="Cache">
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
                font: 76% Arial, sans-serif;
            }
        </style>
<div id="wrapper">	
	<div id="content">
		<h2 class="pageTitle">Cache Manager</h2>
		
		<p>The cache helps make your website faster by remembering the content of your posts and pages. If you would like to remove some entries from memory, click on "Remove this entry" or "Clear All" to remove all posts and pages</p>
		
		 <div id="flashcontent">
            <strong>In order to use the Cache Manager, you need JavaScript and Flash Player 9+ support!</strong>
        </div>

        <script type="text/javascript">
        // <![CDATA[
            var so = new SWFObject('assets/swfs/CacheManager.swf', 'cacheManager', '100%', '100%', '9', '#FFFFFF');
            so.useExpressInstall('assets/scripts/swfobject/expressinstall.swf');
           <cfoutput> so.addVariable("username", "#session.author.getUsername()#");
            so.addVariable("password", "#session.author.getPassword()#");</cfoutput>
            so.addParam('menu', 'false');
            so.write('flashcontent');
        // ]]>
        </script>
		
		</div>
	</div>
</div>
</cf_layout>