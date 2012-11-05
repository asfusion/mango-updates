<cfcomponent extends="PluginQueue">


<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="broadcastEvent" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		
			<cfset var allPlugins = "" />
			<cfset var thisPlugin = "" />
			<cfset var i = "" />
			<cfset var eventName = arguments.event.name />
			<cfset var cfthread = "" />
			<cfset var pluginId = "">
			<cfset var logger = ""/>
			
			<cfif structkeyexists(variables.queues,eventName)>
				<cfset allPlugins = variables.queues[eventName].getElements() />
				
				<cfloop from="1" to="#arraylen(allPlugins)#" index="i">
					<cfset thisPlugin = allPlugins[i].plugin />
					<cfif allPlugins[i].eventType EQ "synch">
						<cftry>
							<cfset arguments.event = thisPlugin.processEvent(arguments.event) />
							<cfcatch type="any">
								<cfset logger = createObject("component","utilities.Logger") />
								<cfset logger.logObject("error",cfcatch,  "Error while calling plugin") />
								<!--- if plugin fails, silently continue --->
							</cfcatch>
						</cftry>
						
						<cfif NOT arguments.event.continueProcess>
							<cfbreak>
						</cfif>
					<cfelseif allPlugins[i].eventType EQ "asynch">
						<cfset pluginId = thisPlugin.getId() />
						
						<cfthread action="run" name="thread#i#" pluginId="#pluginId#" event="#arguments.event#">
							<cfset var thisPlugin = variables.plugins[attributes.pluginId]>
							<cfset var logger = ""/>
							
							<cftry>
								<cfset thisPlugin.handleEvent(attributes.event) />
								<cfcatch type="any">
									<cfset logger = createObject("component","utilities.Logger") />
									<cfset logger.logObject("error",cfcatch, "Error while calling plugin #pluginId#") />
								</cfcatch>
							</cftry>
						</cfthread>
					</cfif>
				</cfloop>
				
			</cfif>
		
		<cfreturn arguments.event />
	</cffunction>
	
</cfcomponent>