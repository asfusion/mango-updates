<cfset variables.blogManager = request.blogManager />
<cfset local = structnew() />
<cfset path = GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset local.configFile = "#path#config.cfm" />
<cfset local.manual = true />
<cfinclude template="upgrade.cfm" >

<p>Now you can move the files (copy only the files, not full directories):
<ul><li>
Files in folder blog need to go to your blog root
</li>
<li>Files in components need to go to your blog root/components folder</li>
<li>Files in plugins need to go your components/plugins folder.</li>
<li>Delete the "helpers" folder</li>
</ul></p>
<p>If you are running this plugin, it is highly recommended that you upgrade by entering the address into the 
plugin install/upgrade URL:</p>

<ul>
<li>CFFormProtect: http://mangoblog-extensions.googlecode.com/files/cfformprotect_1.1.zip</li>
</ul>
