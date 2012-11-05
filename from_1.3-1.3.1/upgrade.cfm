<cfset local.blog = variables.blogManager.getBlog() />

<cfset local.fileSeparator = createObject("java","java.io.File").separator />

<cfset local.thisDir = getDirectoryFromPath(GetCurrentTemplatePath()) />
<cfset local.pluginsDir = local.blog.getSetting("pluginsDir") />

<cfset local.pluginPrefs = createObject("component","helpers.PreferencesFile").init(
								local.blog.getSetting('pluginsPrefsPath')) />

	<cfoutput>
		<cfset local.utils = createObject("component","helpers.Utils") />
		<p>
		<!--- :::::::::::::::::::::: --->
		- Copying components.. 
		<cfset local.currentZipDir = local.thisDir & "components" />
		<cfset local.currentzip = local.thisDir & "components.zip" />
		
		<!--- get the components setting by checking where we currently are --->
		<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
		<cfset unzipFile(local.currentzip, local.componentsPath) />
		
		--------- done<br />
		
		<!--- do this only in case people had problems with previous updater --->
		<cfset local.currentZipDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "plugins" & local.fileSeparator 
				& "user" & local.fileSeparator & "colorCoding" />
		<cfset local.currentzip = GetDirectoryFromPath(GetCurrentTemplatePath()) & "colorCoding.zip" />
		
		<cfif directoryexists(local.pluginsDir & "user/colorCoding/")>
			<!--- Updating Color Coding... --->
			<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
			<cfset unzipFile(local.currentzip, local.pluginsDir & "user#local.fileSeparator#colorCoding" & local.fileSeparator) />
			<!--- done --->
		<cfelse>
			<!--- Color Coding not installed in this system <br /> --->
		</cfif>
		
		<cfset local.pluginPrefs.init(local.blog.getSetting('pluginsPrefsPath')) />
		<!--- update preferences file for color coding --->	
		<cfset local.pluginPrefs.removeNode(local.blog.getId() & "/com/blueinstant/plugins/colorcode") />
		
		<p>
		<!--- remove deleted files, in case people had problems with previous install --->
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