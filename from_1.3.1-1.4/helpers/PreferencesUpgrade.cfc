<cfcomponent>

	<cffunction name="movePreferences">
		<cfargument name="preferencesFile" />
		<cfargument name="queryInterface" />
		<cfargument name="blogid" />
		
		<cfset var node = ''/>
		<cfset var path = ''/>
		<cfset var key = ''/>
		<cfset var query = '' />
		<cfset var cleanPath = '' />
		<cfset var prefix = arguments.queryInterface.getTablePrefix() />
		<cfset var all = arguments.preferencesFile.exportSubtreeAsStruct() />
		
		<!--- look for leaf nodes --->
		<cfset var leaves = getLeaves(all, '') />
		
		<cfloop collection="#leaves#" item="path">
			<cfset node = arguments.preferencesFile.exportSubtreeAsStruct(path) />
			<cfloop collection="#node#" item="key">
				
				<cfif NOT isstruct(node[key])>
					<cfset cleanPath = path />
					<!--- remove the first slash --->
					<cfif find("/",path) EQ 1>
						<cfset cleanPath = RemoveChars(cleanPath,1,1) />
					</cfif>
					<cfset query = "insert into #prefix#setting(path, name, value, blog_id)
					values (
						'#cleanPath#',
						'#key#',
						'#replacenocase(node[key],"'","''",'all')#',
						'#arguments.blogid#')"/>
					
					<cftry>
						<cfset arguments.queryInterface.makeQuery(query,0,false) />
						<cfcatch type="any"><!--- it means we already have this setting here ---></cfcatch>
					</cftry>
				</cfif>
			</cfloop>
		</cfloop>
		
		<!--- remove plugins, which should not be stored here --->
		<cfset query = "DELETE FROM #prefix#setting
						WHERE path = '#arguments.blogid#' AND 
						(name = 'userPlugins' OR name = 'systemPlugins')"/>
					
					<cfset arguments.queryInterface.makeQuery(query,0,false) />
		
	</cffunction>
	
	
	<cffunction name="getLeaves">
		<cfargument name='tree'>
		<cfargument name='currentpath'>
		
		<cfset var leaves = structnew() />
		<cfset var key = ''/>
		<cfoutput>
		<!--- look for leaf nodes --->
			<cfloop collection="#tree#" item='key'>
				<cfif IsStruct(tree[key])>
					<cfset structappend(leaves,getLeaves(tree[key], currentPath & "/" & key))/>
				<cfelse>
					<cfset leaves[currentpath] = '' />
				</cfif>
			</cfloop>
		</cfoutput>	
		<cfreturn leaves />
	</cffunction>
</cfcomponent>