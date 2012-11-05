<cfset local.blog = variables.blogManager.getBlog() />

<cfset local.fileSeparator = createObject("java","java.io.File").separator />

<cfset local.thisDir = getDirectoryFromPath(GetCurrentTemplatePath()) />
<cfset local.pluginsDir = local.blog.getSetting("pluginsDir") />


	<cfoutput>
		<cfset local.utils = createObject("component","helpers.Utils") />
		<p>
		
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
		<cfset local.currentZipDir = local.thisDir & "components" />
		<cfset local.currentzip = local.thisDir & "components.zip" />
		
		<!--- get the components setting by checking where we currently are --->
		<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
		<cfset unzipFile(local.currentzip, local.componentsPath) />
		
		done<br />
		
		<!--- :::::::::::::::::::::: --->
		Updating system plugins... 
		
		<cfset local.currentZipDir = local.thisDir & "plugins" & local.fileSeparator & "system" />
		<cfset local.currentzip = local.thisDir & "systemPlugins.zip" />
		
		<cfset local.utils.zipFileNew(local.currentzip, local.currentZipDir, local.currentZipDir) />
		<cfset unzipFile(local.currentzip, local.pluginsDir & "system" & local.fileSeparator) />
		
		done <br />
		
		<!--- :::::::::::::::::::::: --->
		Updating plugins: </p><ul>
		
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
		</ul>
	</cfoutput>