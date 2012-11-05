<cfset local.blog = variables.blogManager.getBlog() />

<cfset local.fileSeparator = createObject("java","java.io.File").separator />

<cfset local.thisDir = getDirectoryFromPath(GetCurrentTemplatePath()) />
<cfset local.utils = createObject("component","helpers.Utils") />
	<cfoutput>
				<p>
				<cftry>
					
					<!--- :::::::::::::::::::::: --->
					- Copying base files... 
					<!--- make a zip of the subdirs, and then unzip them in their final location,
					this is easier than try to recurse over the directories --->
					<cfset local.utils.copyFiles(local.thisDir & "blog", local.baseDirectory, "blog") />
					
					--------- done <br />
					
					<!--- :::::::::::::::::::::: --->
					- Copying components.. 
					
					<cfset local.utils.copyFiles(local.thisDir & "components", local.componentsPath, "components") />	
					
					--------- done<br />
					</p>
				
				<cfcatch type="any">
					<br />Could not copy new files. Please check that ColdFusion has read/write access to the entire blog folder and 
					all sub-folders and try again. 
					<br />
					If you still have problems, you can move the files manually. Download the zip file from: 
					<a href="http://mangoblog.googlecode.com/files/MangoBlog_update_from_1.4.2-1.4.3.zip">http://mangoblog.googlecode.com/files/MangoBlog_update_from_1.4.2-1.4.3.zip</a>
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