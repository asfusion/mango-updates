<cfcomponent name="PluginLoader">


	<cffunction name="loadPlugins" access="package" output="false" returntype="Any">
		<cfargument name="list" type="any" required="true" />	
		<cfargument name="pluginQueue" type="PluginQueue" required="true" />
		<cfargument name="path" type="string" required="false" default="#GetDirectoryFromPath(GetCurrentTemplatePath())#" />
		<cfargument name="componentBasePath" type="string" required="false" default="" />
		<cfargument name="mainManager" type="any" required="true" />		
		<cfargument name="preferences" type="any" required="true" />	
		<cfargument name="adminMode" type="boolean" required="false" default="false" />
		
			<cfset var i = 0 />
			<cfset var xml = "">
			<cfset var logger = "" />
			
			<cfloop index="i" list="#arguments.list#">
				<cftry>
					<cffile action="read" file="#arguments.path##i#/plugin.xml" variable="xml">
				
					<cfset loadPlugin(parseXml(xmlparse(xml),arguments.adminMode),arguments.pluginQueue,arguments.componentBasePath,arguments.mainManager,arguments.preferences) />
				
				<cfcatch type="any">
					<!--- log the error --->
					<cfset logger = createObject("component","utilities.Logger") />
					<cfset logger.setLevel("warning") />
					<cfset logger.logObject("warning",cfcatch,"Blog #mainManager.getBlog().getId()#: Error while instantiating plugin #i#")>
				</cfcatch>
				</cftry>
			</cfloop>
			
		<cfreturn />
	</cffunction>
	
	<cffunction name="findPlugins" access="public" output="false" returntype="array">
		<cfargument name="path" type="string" required="true" />
			
			<cfset var list = "">
			<cfset var plugins = arraynew(1) />
			<cfset var xml = "">
			
			<cftry>
				<cfdirectory name="list" directory="#arguments.path#" action="list" filter="plugin.xml" recurse="true">
				
				<cfoutput query="list">
					<cffile action="read" file="#directory#/plugin.xml" variable="xml">
					
					<cfset arrayappend(plugins,parseXml(xmlparse(xml))) />
				</cfoutput>
				
				<cfcatch type="any"><!--- ignore error ---></cfcatch>
			</cftry>
		<cfreturn plugins />
	</cffunction>
	
	<cffunction name="parseXml" access="public" output="false" returntype="struct">
		<cfargument name="pluginxml" type="xml" required="true" />
		<cfargument name="adminMode" type="boolean" required="false" default="false" />

			<cfset var i = 0/>
			<cfset var data = pluginxml.plugin />
			<cfset var plugin = structnew() />
			<cfset var event = ""/>
			
			<cfset plugin.name = data.xmlattributes["name"] />
			<cfset plugin.id = data.xmlattributes["id"] />
			<cfset plugin.class = data.xmlattributes["class"] />
			<cfset plugin.author = data.xmlAttributes["provider-name"] />
			<cfset plugin.version = data.xmlAttributes["version"] />
			<cfset plugin.description = data.description.xmltext />
			<cfset plugin.events = arraynew(1)/>
			
			<cfloop index="i" from="1" to="#arraylen(data.listens.xmlChildren)#">
				<cfset event = structnew() />
				<cfset event.name = data.listens.xmlChildren[i].xmlattributes["name"] />
				<cfset event.type = data.listens.xmlChildren[i].xmlattributes["type"] />
				<cfset event.priority = data.listens.xmlChildren[i].xmlattributes["priority"] />
				
				<cfset arrayappend(plugin.events,event) />
			</cfloop>
			
			<cfif arguments.adminMode>
				<cfif structkeyexists(data,'listensAdmin')>
					<cfloop index="i" from="1" to="#arraylen(data.listensAdmin.xmlChildren)#">
						<cfset event = structnew() />
						<cfset event.name = data.listensAdmin.xmlChildren[i].xmlattributes["name"] />
						<cfset event.type = data.listensAdmin.xmlChildren[i].xmlattributes["type"] />
						<cfset event.priority = data.listensAdmin.xmlChildren[i].xmlattributes["priority"] />
						
						<cfset arrayappend(plugin.events,event) />
					</cfloop>
				</cfif>
			</cfif>
			
		<cfreturn plugin />
	</cffunction>	
	
	<cffunction name="loadPlugin" access="package" output="false" returntype="void">
		<cfargument name="pluginData" type="struct" required="true" />
		<cfargument name="pluginQueue" type="PluginQueue" required="true" />
		<cfargument name="componentBasePath" type="string" required="false" default="" />
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />		
		
			<cfset var i = 0 />
			<cfset var plugin = createObject("component", 
					arguments.componentBasePath & arguments.pluginData.class).init(arguments.mainManager,arguments.preferences) />
			<cfset var event = "" />
			
			<cfset plugin.setId(arguments.pluginData.id) />
			<cfset plugin.setName(arguments.pluginData.name) />
			
			<!--- add events --->
			<cfloop index="i" from="1" to="#arraylen(arguments.pluginData.events)#">
				<cfset event = arguments.pluginData.events[i] />
				<cfset arguments.pluginQueue.addListener(plugin,arguments.pluginData.events[i].name,arguments.pluginData.events[i].type,arguments.pluginData.events[i].priority)/>	
			</cfloop>
			
	</cffunction>
	
</cfcomponent>