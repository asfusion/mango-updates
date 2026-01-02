<cfset local.blog = variables.blogManager.getBlog() />

<cfset local.fileSeparator = createObject("java","java.io.File").separator />
<cfset local.pluginsDir = local.blog.getSetting("pluginsDir") />
<cfset local.thisDir = getDirectoryFromPath(GetCurrentTemplatePath()) />
<cfset local.utils = createObject("component","helpers.Utils") />
<cfset local.queryInterface = variables.blogManager.getQueryInterface() />

	<cfoutput>
		<cftry>
		<cfset local.dbupgrade = createObject("component","helpers.DatabaseUpgrade") />
			<p>
				- Updating database...
			<cfset local.dbUpgradeResult = local.dbupgrade.addSettings(local.queryInterface, local.blog.getId()) />

				--------- done <br />

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
					
					<cfset local.utils.copyFiles(local.thisDir & "components#local.fileSeparator#plugins#local.fileSeparator#system", local.pluginsDir & "system#local.fileSeparator#", "systemplugins") />	
					--------- done<br />
					
					</p>
					<p>
			<br /></cfif>
			
				<cfcatch type="any">
					<br />Could not copy new files. Please check that ColdFusion has read/write access to the entire blog folder and 
					all sub-folders and try again. 
					<br />
					If you still have problems, you can move the files manually. Download the zip file from: 
					<a href="https://www.mangoblog.org/downloads/Mango_update_from_2.0-2.1.zip">https://www.mangoblog.org/downloads/Mango_update_from_2.0-2.1.zip</a>
					and then copy only the files, not full directories:
					<ul><li>
					Files in folder blog need to go to your blog root
					</li>
					<li>Files in components need to go to your blog root/components folder</li>
					<li>Delete the "helpers" folder and other files not in the above folders</li>
					</ul>
					<cfthrow message="#cfcatch.message#" />
				</cfcatch>
				</cftry>
	</cfoutput>
	
	
<cffunction name="reloadConfig"></cffunction>	