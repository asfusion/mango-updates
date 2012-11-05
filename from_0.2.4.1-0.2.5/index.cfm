<cfif NOT structkeyexists(request,"indexTemplate")>
	<cfset request.indexTemplate = "index.cfm" />
</cfif>
<cfset blog = request.blogManager.getBlog() />
<cfset pluginQueue = request.blogManager.getPluginQueue() />
<cfset pluginQueue.broadcastEvent(pluginQueue.createEvent("beforeIndexTemplate",request)) />
<cfcontent reset="true" /><cfinclude template="#blog.getbasePath()#skins/#blog.getSkin()#/#request.indexTemplate#">