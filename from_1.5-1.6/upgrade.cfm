<cfset local.blog = variables.blogManager.getBlog() />

<cfset local.fileSeparator = createObject("java","java.io.File").separator />
<cfset local.pluginsDir = local.blog.getSetting("pluginsDir") />
<cfset local.thisDir = getDirectoryFromPath(GetCurrentTemplatePath()) />
<cfset local.utils = createObject("component","helpers.Utils") />
<cfset local.configPreferences = createObject("component","helpers.PreferencesFile").init(local.configFile) />
<cfset local.queryInterface = variables.blogManager.getQueryInterface() />

	<cfoutput>
		<cfset local.dbupgrade = createObject("component","helpers.DatabaseUpgrade") />
		
		<p>Moving config.cfm settings to database...</p>
		<cfset local.dbUpgradeResult = local.dbupgrade.updateSettings(local.queryInterface, local.configPreferences, local.blog.getId()) />
		
		<cfif local.dbUpgradeResult>
			<cfset local.dbupgrade.updateCustomFields(local.queryInterface)/>
			<p>Adding new permissions...</p>
			<cfset local.dbupgrade.addPermission(local.queryInterface)/>
		
			<!--- make a backup and delete all nodes no longer used --->
			<cfif NOT fileExists('#local.configFile#.bak.cfm')>
				<p>Making backup of config file...</p>
				<cffile action="copy" source="#local.configFile#" destination="#local.configFile#.bak.cfm" /> 
			</cfif>
			
			<p>Remove settings from config file...</p>
			<cfset local.configPreferences.removeNode(local.blog.getId()) />
			<cfset local.configPreferences.removeNode("generalSettings/system") />
			<cfset local.configPreferences.removeNode("generalSettings/mailServer") />
			
			<cfset variables.blogManager.getBlogsManager().activatePlugin(local.blog.getId(), 'AssetManager', '', 'system')/>
			<cfset variables.blogManager.getBlogsManager().activatePlugin(local.blog.getId(), 'PluginHelper', '', 'system')/>
		<cfelse>
			<cfthrow message="Error" />
		</cfif>
				<p>
				<cftry>
					<cfif NOT structkeyexists(local,"manual") AND local.dbUpgradeResult>
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
					<!--- just replace reloadconfig because it would give an error--->
					<cfset variables.blogManager.reloadConfig = reloadConfig />
					</p>
					<p>
			<br /></cfif>
			
				<cfcatch type="any">
					<!--- put the old config back --->
					<cfif fileExists('#local.configFile#.bak.cfm')>
						<cffile action="copy" destination="#local.configFile#" source="#local.configFile#.bak.cfm" /> 
					</cfif>
					
					<br />Could not copy new files. Please check that ColdFusion has read/write access to the entire blog folder and 
					all sub-folders and try again. 
					<br />
					If you still have problems, you can move the files manually. Download the zip file from: 
					<a href="http://mangoblog.googlecode.com/files/MangoBlog_update_from_1.5-1.6.zip">http://mangoblog.googlecode.com/files/MangoBlog_update_from_1.5-1.6.zip</a>
					and then copy only the files, not full directories:
					<ul><li>
					Files in folder blog need to go to your blog root
					</li>
					<li>Files in components need to go to your blog root/components folder</li>
					<li>Delete the "helpers" folder and other files not in the above folders</li>
					</ul>
					<cfthrow message="Error" />
				</cfcatch>
				</cftry>
	</cfoutput>
	
	
<cffunction name="reloadConfig"></cffunction>	