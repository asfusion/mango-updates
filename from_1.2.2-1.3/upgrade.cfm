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
		<cfset local.queryString = "UPDATE #local.tablePrefix#permission 
				SET id = 'publish_pages' 
				WHERE id = 'plublish_pages'" />
		<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
		<!--- the update should cascade to the role permissions, but we are not sure, 
		so let's do it anyway --->
		<cfset local.queryString = "UPDATE #local.tablePrefix#role_permission 
				SET permission_id = 'publish_pages' 
				WHERE permission_id = 'plublish_pages'" />
		<cfset local.queryInterface.makeQuery(local.queryString,0,false) />
		--------- done <br />
		
		
		<!--- :::::::::::::::::::::: --->
		- Updating configuration file ...
		
		<cfset variables.blogManager.saveSetting(local.blog.id & "/authorization","methods", "native") />
		<cfset variables.blogManager.saveSetting(local.blog.id & "/authorization/settings","component", "") />
		
		--------- done <br />
		
		
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
		
		<!--- :::::::::::::::::::::: --->
		- Updating plugins: </p><ul>
		
		<li>
		<cfset local.currentZipDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "plugins" & local.fileSeparator 
				& "user" & local.fileSeparator & "commentModeration" />
		<cfset local.currentzip = GetDirectoryFromPath(GetCurrentTemplatePath()) & "commentModeration.zip" />
		
		<cfif directoryexists(local.pluginsDir & "user/commentModeration/")>
			Updating Comment Moderation...
			<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
			<cfset unzipFile(local.currentzip, local.pluginsDir & "user#local.fileSeparator#commentModeration" & local.fileSeparator) />
			done
		<cfelse>
			Comment Moderation not installed in this system <br />
		</cfif>
		</li>
		
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
		<cfset local.currentZipDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "plugins" & local.fileSeparator & "user" 
				& local.fileSeparator & "googlesearch" />
		<cfset local.currentzip = GetDirectoryFromPath(GetCurrentTemplatePath()) & "googlesearch.zip" />
		<li>
		<cfif directoryexists(local.pluginsDir & "user/googlesearch/")>
			Updating Google Custom Search... 
			<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
			<cfset unzipFile(local.currentzip, local.pluginsDir & "user#local.fileSeparator#googlesearch" & local.fileSeparator) />
			done
		<cfelse>
			Google Custom Search not installed in this system <br />
		</cfif>
		
		<cfset local.currentZipDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "plugins" & local.fileSeparator & "user" 
				& local.fileSeparator & "flickrWidget" />
		<cfset local.currentzip = GetDirectoryFromPath(GetCurrentTemplatePath()) & "flickrWidget.zip" />
		<li>
		<cfif directoryexists(local.pluginsDir & "user/flickrWidget/")>
			Updating Flickr Widget... 
			<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
			<cfset unzipFile(local.currentzip, local.pluginsDir & "user#local.fileSeparator#flickrWidget" & local.fileSeparator) />
			done
		<cfelse>
			Flickr Widget not installed in this system <br />
		</cfif>
		</li>
		
		
		<cfset local.currentZipDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "plugins" & local.fileSeparator & "user" 
				& local.fileSeparator & "paragraphFormatter" />
		<cfset local.currentzip = GetDirectoryFromPath(GetCurrentTemplatePath()) & "paragraphFormatter.zip" />
		
		<li>
			Adding Paragraph Formatter... 
			<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
			<cfset unzipFile(local.currentzip, local.pluginsDir & "user#local.fileSeparator#paragraphFormatter" & local.fileSeparator) />
			done
		</li>
		
		<!--- install paragraphFormatter --->
		<cfset local.adminUtil = variables.blogManager.getAdministrator() />
		<cfset local.adminUtil.activatePlugin("paragraphFormatter","com.asfusion.mango.plugins.paragraphFormatter",
				variables.blogManager.getCurrentUser()) />
		
		<li>
		<cfset local.currentZipDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "plugins" & local.fileSeparator 
				& "user" & local.fileSeparator & "colorCoding" />
		<cfset local.currentzip = GetDirectoryFromPath(GetCurrentTemplatePath()) & "colorCoding.zip" />
		
		<cfif directoryexists(local.pluginsDir & "user/colorCoding/")>
			Updating Color Coding...
			<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
			<cfset unzipFile(local.currentzip, local.pluginsDir & "user#local.fileSeparator#colorCoding" & local.fileSeparator) />
			done
		<cfelse>
			Color Coding not installed in this system <br />
		</cfif>
		</li>
		
		<cfset local.pluginPrefs.init(local.blog.getSetting('pluginsPrefsPath')) />
		<!--- update preferences file for color coding --->	
		<cfset local.pluginPrefs.removeNode(local.blog.getId() & "/com/blueinstant/plugins/colorcode") />
		</ul>
		
		<!--- :::::::::::::::::::::::::::::::::::::::::: --->
		
		<p>
		<!--- remove deleted files --->
		- Deleting deprecated files... 
		<cftry>
			<cfif fileexists("#local.baseDirectory#admin/assets/scripts/libraries.js")>
				<cffile action="delete" file="#local.baseDirectory#admin/assets/scripts/libraries.js" />
			</cfif>
			<cfcatch type="any">
				<span style="color:Red">Could not delete admin/assets/scripts/libraries.js, please delete manually</span><br/>
			</cfcatch>
		</cftry>
		<cftry>
			<cfif fileexists("#local.baseDirectory#admin/assets/scripts/behaviors.js")>
				<cffile action="delete" file="#local.baseDirectory#admin/assets/scripts/behaviors.js" />
			</cfif>
			<cfcatch type="any">
				<span style="color:Red">Could not delete admin/assets/scripts/behaviors.js, please delete manually</span><br/>
			</cfcatch>
		</cftry>
		<cftry>
			<cfif directoryexists("#local.baseDirectory#admin/assets/wforms")>
				<cfdirectory action="delete" directory="#local.baseDirectory#admin/assets/wforms" recurse="true" />
			</cfif>
			<cfcatch type="any">
				<span style="color:Red">Could not delete admin/assets/wforms, please delete manually</span><br/>
			</cfcatch>
		</cftry>
		<cfset local.imglist = "cache,categories,dashboard,general,links,logout,manage,options,plugins,presentation,themes,upload,users,write" />
		<cfloop list="#local.imglist#" index="local.imgfile">
			<cfloop list="on,off" index="local.imgstatus">
				<cftry>
					<cfif fileexists("#local.baseDirectory#admin/styles/tiger_skin_images/menu_#local.imgfile#_#local.imgstatus#.png")>
						<cffile action="delete" file="#local.baseDirectory#admin/styles/tiger_skin_images/menu_#local.imgfile#_#local.imgstatus#.png" />
					</cfif>
					<cfcatch type="any">
						<cfoutput><span style="color:Red">Could not delete admin/styles/tiger_skin_images/menu_#local.imgfile#_#local.imgstatus#.png, please delete manually</span><br/></cfoutput>
					</cfcatch>
				</cftry>
			</cfloop>
		</cfloop>
		<cfset local.imglist = "bg_menu_on.png,icon_dashboard.png,toggle.gif,wp-config.png" />
		<cfloop list="#local.imglist#" index="local.imgfile">
			<cftry>
				<cfif fileexists("#local.baseDirectory#admin/styles/tiger_skin_images/#local.imgfile#")>
					<cffile action="delete" file="#local.baseDirectory#admin/styles/tiger_skin_images/#local.imgfile#" />
				</cfif>
				<cfcatch type="any">
					<cfoutput><span style="color:Red">Could not delete admin/styles/tiger_skin_images/#local.imgfile#, please delete manually</span><br/></cfoutput>
				</cfcatch>
			</cftry>
		</cfloop>
		--------- done
		</p>
	</cfoutput>