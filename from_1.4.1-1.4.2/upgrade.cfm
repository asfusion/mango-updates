<cfset local.blog = variables.blogManager.getBlog() />

<cfset local.fileSeparator = createObject("java","java.io.File").separator />

<cfset local.thisDir = getDirectoryFromPath(GetCurrentTemplatePath()) />
<cfset local.pluginsDir = local.blog.getSetting("pluginsDir") />

<cfset local.queryInterface = variables.blogManager.getQueryInterface() />
<cfset local.tablePrefix = local.queryInterface.getTablePrefix() />


	<cfoutput>
		<cfset local.utils = createObject("component","helpers.Utils") />
		<p>
		<!--- :::::::::::::::::::::: --->
		- Updating database...
		<cfset local.dbupgrade = createObject("component","helpers.DatabaseUpgrade") />
		<cfset local.dbUpgradeResult = local.dbupgrade.addTables(local.queryInterface) />
		</p>	
		<cfif local.dbUpgradeResult>
			
			<cfset variables.blogManager.saveSetting(local.blog.id & "/logging","level", "warning") />
			
			<p>
			- Deleting logs...
			<br />
			<cftry>
				<cfif directoryexists("#local.componentsPath#utilities/logs")>
					<cfdirectory action="delete" directory="#local.componentsPath#utilities/logs" recurse="true" />
				</cfif>
				<br />
				Done
				<cfcatch type="any">
					<span style="color:Red">Could not delete logs (#local.componentsPath#utilities/logs), please delete manually</span><br/>
				</cfcatch>
			</cftry>
			</p>
			<cfif NOT structkeyexists(local,"manual")>
				<p>
				<!--- move files if we are not in manual mode --->
				<cftry>
					
					<!--- :::::::::::::::::::::: --->
					- Copying base files... 
					<!--- make a zip of the subdirs, and then unzip them in their final location,
					this is easier than try to recurse over the directories --->
					<cfset local.currentZipDir = local.thisDir & "blog" />
					<cfset local.currentzip = local.thisDir & "blog.zip" />
					
					<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
					<cfset unzipFile(local.currentzip, local.baseDirectory) />
					
					--------- done <br />
				
					<!--- :::::::::::::::::::::: --->
					- Updating system plugins... 
					
					<cfset local.currentZipDir = local.thisDir & "plugins" & local.fileSeparator & "system" />
					<cfset local.currentzip = local.thisDir & "systemPlugins.zip" />
					
					<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
					<cfset unzipFile(local.currentzip, local.pluginsDir & "system" & local.fileSeparator) />
					
					--------- done <br />
					
					
					<!--- copy plugins --->
					<cfset local.currentZipDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "plugins" & local.fileSeparator 
							& "user" & local.fileSeparator & "captcha" />
					<cfset local.currentzip = GetDirectoryFromPath(GetCurrentTemplatePath()) & "captcha.zip" />
					
					<cfif directoryexists(local.pluginsDir & "user/captcha/")>
						Updating captcha plugin...
						<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
						<cfset unzipFile(local.currentzip, local.pluginsDir & "user#local.fileSeparator#captcha" & local.fileSeparator) />
						<!--- done --->
					</cfif>
					
						<!--- :::::::::::::::::::::: --->
						- Copying components.. 
						<cfset local.currentZipDir = local.thisDir & "components" />
						<cfset local.currentzip = local.thisDir & "components.zip" />
						
						<!--- get the components setting by checking where we currently are --->
						<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
						<cfset unzipFile(local.currentzip, local.componentsPath) />
						--------- done<br />
					</p>
				
				<cfcatch type="any">
					<br />Could not copy new files. Please check that ColdFusion has read/write access to the entire blog folder and 
					all sub-folders and try again. 
					<br />
					If you still have problems, you can move the files manually. Download the zip file from: 
					<a href="http://mangoblog.googlecode.com/files/MangoBlog_update_from_1.4.1-1.4.2.zip">http://mangoblog.googlecode.com/files/MangoBlog_update_from_1.4.1-1.4.2.zip</a>
					and then copy only the files, not full directories:
					<ul><li>
					Files in folder blog need to go to your blog root
					</li>
					<li>Files in components need to go to your blog root/components folder</li>
					<li>Files in plugins need to go your components/plugins folder.</li>
					<li>Delete the "helpers" folder and other files not in the above folders</li>
					</ul>
				</cfcatch>
				</cftry>
				
	</cfif>
		</cfif>
	</cfoutput>