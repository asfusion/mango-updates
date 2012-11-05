<cfset local.blog = variables.blogManager.getBlog() />
<cfset local.settings = local.blog.getSetting("admin") />
<cfset local.id = local.blog.getId() />

<cfset local.fileSeparator = createObject("java","java.io.File").separator />

<cfset local.configFile = "#local.baseDirectory#config.cfm" />
<cfset local.assetsDir = "#local.baseDirectory#assets#local.fileSeparator#content#local.fileSeparator#" />
<cfset local.skinsDir = "#local.baseDirectory#skins#local.fileSeparator#" />
<cfset local.thisDir = getDirectoryFromPath(GetCurrentTemplatePath()) />
<cfset local.pluginsDir = local.blog.getSetting("pluginsDir") />

<!--- check that we got it right --->
<cfif fileexists(local.configFile)>
	<cfoutput>
		<cfset local.utils = createObject("component","helpers.Utils") />
		<p>
		Updating settings...
		
		<cfset local.config = createObject("component","helpers.PreferencesFile").init(local.configFile)>
		
		<!--- remove the old assets directory, it is now a struct --->
		<cfset local.config.remove(local.id & "/blogsettings", "assetsDirectory") />
		
		<!--- add assetsdir to settings  --->
		<cfset local.config.put(local.id & "/blogsettings/assets", "directory", local.assetsDir) />
		<cfset local.config.put(local.id & "/blogsettings/assets", "path", "assets/content/") />
		
		<!--- ensure that the skins directory is correctly set --->
		<cfset local.config.put(local.id & "/blogsettings", "skinsDirectory", local.skinsDir) />
		
		done<br />
		<!--- :::::::::::::::::::::: --->
		Copying base files... 
		<!--- make a zip of the subdirs, and then unzip them in their final location,
		this is easier than try to recurse over the directories --->
		<cfset local.currentZipDir = local.thisDir & "blog" />
		<cfset local.currentzip = local.thisDir & "blog.zip" />
		
		<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
		<cfset unzipFile(local.currentzip, local.baseDirectory) />
		
		done <br />
		
		<!--- :::::::::::::::::::::: --->
		Copying components.. 
		<cfset local.currentZipDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "components" />
		<cfset local.currentzip = GetDirectoryFromPath(GetCurrentTemplatePath()) & "components.zip" />
		
		<!--- get the components setting by checking where we currently are --->
		<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
		<cfset unzipFile(local.currentzip, local.componentsPath) />
		
		done<br />
		
		<!--- :::::::::::::::::::::: --->
		Updating system plugins... 
		
		<cfset local.currentZipDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "plugins" & local.fileSeparator & "system" />
		<cfset local.currentzip = GetDirectoryFromPath(GetCurrentTemplatePath()) & "systemPlugins.zip" />
		
		<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
		<cfset unzipFile(local.currentzip, local.pluginsDir & "system" & local.fileSeparator) />
		
		done <br />
		
		<!--- :::::::::::::::::::::: --->
		Updating plugins: </p><ul>
		
		<cfset local.currentZipDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "plugins" & local.fileSeparator & "user" 
				& local.fileSeparator & "akismet" />
		<cfset local.currentzip = GetDirectoryFromPath(GetCurrentTemplatePath()) & "akismet.zip" />
		<li>
		<cfif directoryexists(local.pluginsDir & "user/akismet/")>
			Updating Akismet... 
			<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
			<cfset unzipFile(local.currentzip, local.pluginsDir & "user#local.fileSeparator#akismet" & local.fileSeparator) />
			done
		<cfelse>
			Plugin Akismet not installed in this system <br />
		</cfif>
		
		</li>
		<li>
		<cfset local.currentZipDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "plugins" & local.fileSeparator 
				& "user" & local.fileSeparator & "homeChooser" />
		<cfset local.currentzip = GetDirectoryFromPath(GetCurrentTemplatePath()) & "homeChooser.zip" />
		
		<cfif directoryexists(local.pluginsDir & "user/homeChooser/")>
			Updating Home Chooser...
			<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
			<cfset unzipFile(local.currentzip, local.pluginsDir & "user#local.fileSeparator#homeChooser" & local.fileSeparator) />
			done
		<cfelse>
			Plugin Home Chooser not installed in this system <br />
		</cfif>
		</li>
		<li>
		<cfset local.currentZipDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "plugins" 
				& local.fileSeparator & "user" & local.fileSeparator & "googleAnalytics" />
		<cfset local.currentzip = GetDirectoryFromPath(GetCurrentTemplatePath()) & "googleAnalytics.zip" />
		
		<cfif directoryexists(local.pluginsDir & "user/googleAnalytics/")>
			Updating Google Analytics...
			<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
			<cfset unzipFile(local.currentzip, local.pluginsDir & "user#local.fileSeparator#googleAnalytics" & 
					local.fileSeparator) />
			done
		<cfelse>
			Plugin Google Analytics not installed in this system <br />
		</cfif>
		</li>
		</ul>
		<p>
		<!--- :::::::::::::::::::::: --->
		<!--- remove cache updater from plugins --->
		<cfset local.preferences = createObject("component","helpers.PreferencesFile").init(local.blog.getSetting("pluginsPrefsPath"))>
		<cfset local.currentSystemPlugins = local.preferences.get(local.id,"systemPlugins","") />
		<cfif listfindnocase(local.currentSystemPlugins, "CacheUpdater")>
			<cfset local.currentSystemPlugins = listdeleteat(local.currentSystemPlugins, 
					listfindnocase(local.currentSystemPlugins, "CacheUpdater")) />
			<cfset local.preferences.put(local.id,"systemPlugins",local.currentSystemPlugins) />
		</cfif>
		
		<!--- remove application.cfc file --->
		Deleting deprecated files... 
		<cftry>
			<cfif fileexists("#local.baseDirectory#admin/Application.cfc")>
				<cffile action="delete" file="#local.baseDirectory#admin/Application.cfc">
			</cfif>
			done 
		<cfcatch type="any">
			<span style="color:Red">Could not delete admin/Application.cfc, please delete manually</span><br/>
		</cfcatch>
		</cftry>
		</p>
	</cfoutput>
<cfelse>
	<!--- unfortunately, we cannot continue, throw exception --->
	<cfthrow type="CONFIG_FILE_NOT_FOUND" message="Automatic update could not be executed, updater could not find config file">
</cfif>
