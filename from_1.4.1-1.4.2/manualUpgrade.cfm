<cfset variables.blogManager = request.blogManager />
<cfset local = structnew() />
<cfset path = GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset local.configFile = "#path#config.cfm" />
<cfset local.componentsPath = "#path#components/" />
<cfset local.manual = true />
<cfinclude template="upgrade.cfm" >

<p>If there were no errors above, then you can move the files (copy only the files, not full directories):
<ul><li>
Files in folder blog need to go to your blog root
</li>
<li>Files in components need to go to your blog root/components folder</li>
<li>Files in plugins need to go your components/plugins folder. If you don't have the plugin "captcha" installed, then you don't need to copy the folder "plugins/user/captcha"</li>
<li>Delete the "helpers" folder</li>
</ul></p>

</ul>
