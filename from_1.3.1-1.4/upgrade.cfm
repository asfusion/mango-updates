<cfset local.blog = variables.blogManager.getBlog() />

<cfset local.fileSeparator = createObject("java","java.io.File").separator />

<cfset local.thisDir = getDirectoryFromPath(GetCurrentTemplatePath()) />
<cfset local.pluginsDir = local.blog.getSetting("pluginsDir") />

<cfset local.pluginPrefs = createObject("component","helpers.PreferencesFile").init(
								local.blog.getSetting('pluginsPrefsPath')) />

<cfset local.queryInterface = variables.blogManager.getQueryInterface() />
<cfset local.tablePrefix = local.queryInterface.getTablePrefix() />


	<cfoutput>
		<cfset local.utils = createObject("component","helpers.Utils") />
		<p>
		<!--- :::::::::::::::::::::: --->
		- Updating database...
		<!--- Check if access_admin permission already exists --->
		<cfset local.queryString = "SELECT id FROM #local.tablePrefix#permission WHERE id = 'access_admin'" />
		<cfset local.queryResult = local.queryInterface.makeQuery(local.queryString,0,true) />
		<cfif not local.queryResult.recordCount>
			<!--- Create access_admin permission --->
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#permission (
					id, name, description, is_custom
				) VALUES (
					'access_admin',
					'Access site admin',
					'If not enabled, user will have no access to the admin pages',
					0
				)" />
			<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			<!--- Add access_admin permission to all existing roles --->
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#role_permission (
					role_id, permission_id
				)
					SELECT id, 'access_admin'
					FROM #local.tablePrefix#role" />
			<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			
		</cfif>
		
		<!--- Check if manage_pods permission already exists --->
		<cfset local.queryString = "SELECT id FROM #local.tablePrefix#permission WHERE id = 'manage_pods'" />
		<cfset local.queryResult = local.queryInterface.makeQuery(local.queryString,0,true) />
		<cfif not local.queryResult.RecordCount>
			<!--- Create access_admin permission --->
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#permission (
					id, name, description, is_custom
				) VALUES (
					'manage_pods',
					'Manage sidebar pods',
					'Add, remove and re-order pods added to the blog''s sidebars',
					0
				)" />
			<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			<!--- Add access_admin permission to all existing roles --->
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#role_permission (
					role_id, permission_id
				)
					SELECT id, 'manage_pods'
					FROM #local.tablePrefix#role" />
			<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
		</cfif>
		
		<!--- Check if manage_pods permission already exists --->
		<cfset local.queryString = "SELECT id FROM #local.tablePrefix#permission WHERE id = 'manage_system'" />
		<cfset local.queryResult = local.queryInterface.makeQuery(local.queryString,0,true) />
		<cfif not local.queryResult.RecordCount>
			<!--- Create access_admin permission --->
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#permission (
					id, name, description, is_custom
				) VALUES (
					'manage_system',
					'Manage system',
					'Update blog and change system settings',
					0
				)" />
			<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			<!--- Add access_admin permission to all existing roles --->
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#role_permission (
					role_id, permission_id
				)
					SELECT id, 'manage_system'
					FROM #local.tablePrefix#role" />
			<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
		</cfif>
		
		<cfset local.dbupgrade = createObject("component","helpers.DatabaseUpgrade") />
		<cfset local.dbUpgradeResult = local.dbupgrade.addTables(local.queryInterface) />
	
		<cfif local.dbUpgradeResult>
		
			<!--- move the list of plugins from the file to the newly created columns --->
			<cfset local.systemPluginList = local.pluginPrefs.get(local.blog.getId(), 'systemPlugins') />
			<!--- append the new plugin: RevisionManager --->
			<cfset local.systemPluginList = listappend(local.systemPluginList, "RevisionManager") />
			<cfset local.pluginList = local.pluginPrefs.get(local.blog.getId(), 'userPlugins') />
			<cfset local.queryString = "UPDATE #local.tablePrefix#blog 
						SET systemplugins = '#local.systemPluginList#',
							plugins = '#local.pluginList#'" />
			<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
			
			<!--- move preferences --->
			<br />
			- Moving preferences to database....
			<cfset local.upgradeHelper = createObject("component","helpers.PreferencesUpgrade") />
			
			<cfset local.upgradeHelper.movePreferences(local.pluginPrefs, local.queryInterface, local.blog.getId()) />
			
			--------- done <br />
			</p>
			
			<p>
			Updating settings...<br />
			<cfset local.isCF8 = server.coldfusion.productname is "ColdFusion Server" and 
					listFirst(server.coldfusion.productversion) gte 8 />
			<cfif local.isCF8>
				<cfset local.threaded = '1' />
			<cfelse>
				<cfset local.threaded = '0' />
			</cfif>
			<cfset local.config = createObject("component","helpers.PreferencesFile").init(local.configFile) />
			<cfset local.config.put('generalSettings/system','enableThreads', local.threaded) />
			--------- done <br />
			</p>
			
			<cfif NOT structkeyexists(local,"manual")>
				<p>
				<!--- move files if we are not in manual mode --->
				<cftry>
					<!--- :::::::::::::::::::::: --->
					- Copying components.. 
					<cfset local.currentZipDir = local.thisDir & "components" />
					<cfset local.currentzip = local.thisDir & "components.zip" />
					
					<!--- get the components setting by checking where we currently are --->
					<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
					<cfset unzipFile(local.currentzip, local.componentsPath) />
					--------- done<br />
					
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
							& "user" & local.fileSeparator & "formRememberer" />
					<cfset local.currentzip = GetDirectoryFromPath(GetCurrentTemplatePath()) & "formRememberer.zip" />
					
					<cfif directoryexists(local.pluginsDir & "user/formRememberer/")>
						Updating formRememberer...
						<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
						<cfset unzipFile(local.currentzip, local.pluginsDir & "user#local.fileSeparator#formRememberer" & local.fileSeparator) />
						<!--- done --->
					<cfelse>
						<!--- not installed in this system <br /> --->
					</cfif>
					</p>
				
			<p>There are new files for the CFFormProtect plugin. If you are running this plugin, it is highly recommended that you upgrade by entering the address into the 
			plugin install/upgrade URL:</p>
			
			<ul>
			<li>http://mangoblog-extensions.googlecode.com/files/cfformprotect_1.1.zip</li>
			</ul>
						
				<cfcatch type="any">
					<br />Could not copy new files. Please check that ColdFusion has read/write access to the entire blog folder and 
					all sub-folders and try again. 
					<br />
					If you still have problems, you can move the files manually. Download the zip file from: 
					<a href="http://mangoblog.googlecode.com/files/MangoBlog_update_from_1.3.1-1.4-take2.zip">http://mangoblog.googlecode.com/files/MangoBlog_update_from_1.3.1-1.4-take2.zip</a>
					and then copy only the files, not full directories:
					<ul><li>
					Files in folder blog need to go to your blog root
					</li>
					<li>Files in components need to go to your blog root/components folder</li>
					<li>Files in plugins need to go your components/plugins folder.</li>
					<li>Delete the "helpers" folder and other files not in the above folders</li>
					</ul>
					<p>After doing so and reloading your blog, and you are running the CFFormProtect plugin,
						 it is highly recommended that you upgrade it by entering the address into the 
						plugin install/upgrade URL:</p>
			
			<ul>
			<li>http://mangoblog-extensions.googlecode.com/files/cfformprotect_1.1.zip</li>
			</ul>
				</cfcatch>
				</cftry>
				
	</cfif>
		</cfif>
	</cfoutput>