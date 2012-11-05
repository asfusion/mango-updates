<cfset local.blog = variables.blogManager.getBlog() />

<cfset local.fileSeparator = createObject("java","java.io.File").separator />
<cfset local.pluginsDir = local.blog.getSetting("pluginsDir") />
<cfset local.thisDir = getDirectoryFromPath(GetCurrentTemplatePath()) />
<cfset local.utils = createObject("component","helpers.Utils") />
<cfset local.configPreferences = createObject("component","helpers.PreferencesFile").init(local.configFile) />

	<cfoutput>
		<p>Removing custom panel preferences...</p>
		<!--- do not do this, leave for next update 
		<cfset local.configPreferences.removeNode(local.blog.getId() & "/blogsettings/admin/customPanels") />--->
				<p>
				<cftry>
					<cfif NOT structkeyexists(local,"manual")>
					<!--- :::::::::::::::::::::: --->
					- Copying base files... 
					<!--- make a zip of the subdirs, and then unzip them in their final location,
					this is easier than try to recurse over the directories --->
					<cfset local.utils.copyFiles(local.thisDir & "blog", local.baseDirectory, "blog") />
					
					--------- done <br />
					
					<!--- :::::::::::::::::::::: --->
					- Copying components... 
					
					<cfset local.utils.copyFiles(local.thisDir & "components", local.componentsPath, "components") />	
					
					--------- done<br />
					<!--- :::::::::::::::::::::: --->
					- Copying system plugins... 
					
					<cfset local.utils.copyFiles(local.thisDir & "plugins#local.fileSeparator#system", local.pluginsDir & "system#local.fileSeparator#", "systemplugins") />	
					
					--------- done<br />
					
					<!--- :::::::::::::::::::::: --->
					- Copying user plugins... 
					
					<cfif directoryexists(local.pluginsDir & "user/flickrWidget/")>
						<br />FlickrWidget...
						<cfset local.utils.copyFiles(local.thisDir & "plugins#local.fileSeparator#user#local.fileSeparator#flickrWidget", local.pluginsDir & "user#local.fileSeparator#flickrWidget", "flickrWidget") />	
						--------- done<br />
					<cfelse>
						<br />FlickrWidget not installed in this system
					</cfif>
					<cfif directoryexists(local.pluginsDir & "user/googleAnalytics/")>
						<br />googleAnalytics...
						<cfset local.utils.copyFiles(local.thisDir & "plugins#local.fileSeparator#user#local.fileSeparator#googleAnalytics", local.pluginsDir & "user#local.fileSeparator#googleAnalytics", "googleAnalytics") />	
						--------- done<br />
					<cfelse>
						<br />googleAnalytics not installed in this system
					</cfif>
					<cfif directoryexists(local.pluginsDir & "user/homeChooser/")>
						<br />homeChooser...
						<cfset local.utils.copyFiles(local.thisDir & "plugins#local.fileSeparator#user#local.fileSeparator#homeChooser", local.pluginsDir & "user#local.fileSeparator#homeChooser", "homeChooser") />	
						--------- done<br />
					<cfelse>
						<br />homeChooser not installed in this system
					</cfif>
					</p>
					<p>
			- Deleting files...
			<br /></cfif>
			<cftry>
				<cfif directoryexists("#local.baseDirectory#admin/com/asfusion/fileexplorer/services")>
					<cfdirectory action="delete" directory="#local.baseDirectory#admin/com/asfusion/fileexplorer/services" recurse="true" />
				</cfif>
				<cfif directoryexists("#local.baseDirectory#admin/assets/swfs/fileicons")>
					<cfdirectory action="delete" directory="#local.baseDirectory#admin/assets/swfs/fileicons" recurse="true" />
				</cfif>
				<cfif directoryexists("#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/assets")>
					<cfdirectory action="delete" directory="#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/assets" recurse="true" />
				</cfif>
				<cfif directoryexists("#local.baseDirectory#admin/custompanels")>
					<cfdirectory action="delete" directory="#local.baseDirectory#admin/custompanels" recurse="true" />
				</cfif>
				<cfif fileexists("#local.baseDirectory#admin/tags/CustomMenu.cfm")>
					<cffile action="delete" file="#local.baseDirectory#admin/tags/CustomMenu.cfm" />
				</cfif>
				<cfif fileexists("#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/AC_OETags.js")>
					<cffile action="delete" file="#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/AC_OETags.js" />
				</cfif>
				<cfif fileexists("#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/fileexplorer.html")>
					<cffile action="delete" file="#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/fileexplorer.html" />
				</cfif>
				<cfif fileexists("#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/FileExplorerLite.swf")>
					<cffile action="delete" file="#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/FileExplorerLite.swf" />
				</cfif>
				<cfif fileexists("#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/FileManager.cfc")>
					<cffile action="delete" file="#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/FileManager.cfc" />
				</cfif>
				<cfif fileexists("#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/FileWebService.cfc")>
					<cffile action="delete" file="#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/FileWebService.cfc" />
				</cfif>
				<cfif fileexists("#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/MainFileExplorer.cfc")>
					<cffile action="delete" file="#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/MainFileExplorer.cfc" />
				</cfif>
				<cfif fileexists("#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/playerProductInstall.swf")>
					<cffile action="delete" file="#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/playerProductInstall.swf" />
				</cfif>
				<cfif fileexists("#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/upload.cfm")>
					<cffile action="delete" file="#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/upload.cfm" />
				</cfif>
				<cfif fileexists("#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/fileexplorer.ini.cfm")>
					<cffile action="delete" file="#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/fileexplorer.ini.cfm" />
				</cfif>
				<br />
				Done
				<cfcatch type="any">
					<span style="color:Red">Could not delete files or folders:<br />
					#local.baseDirectory#admin/com/asfusion/fileexplorer/services<br />
					#local.baseDirectory#admin/assets/swfs/fileicons<br />
					#local.baseDirectory#admin/assets/editors/tiny_mce/plugins/asffileexplorer/assets<br />
					#local.baseDirectory#admin/custompanels<br />
					#local.baseDirectory#admin/tags/CustomMenu.cfm
					 <br />
					 Please delete manually</span><br/>
					 
				</cfcatch>
			</cftry>
			
				<!---@TODO remove custom panels setting in config.cfm change adminCustomPanel for entryType custom field --->
				<cfcatch type="any">
					<br />Could not copy new files. Please check that ColdFusion has read/write access to the entire blog folder and 
					all sub-folders and try again. 
					<br />
					If you still have problems, you can move the files manually. Download the zip file from: 
					<a href="http://mangoblog.googlecode.com/files/MangoBlog_update_from_1.4.3-1.5.zip">http://mangoblog.googlecode.com/files/MangoBlog_update_from_1.4.3-1.5.zip</a>
					and then copy only the files, not full directories:
					<ul><li>
					Files in folder blog need to go to your blog root
					</li>
					<li>Files in components need to go to your blog root/components folder</li>
					<li>Delete the "helpers" folder and other files not in the above folders</li>
					</ul>
				</cfcatch>
				</cftry>
	</cfoutput>	