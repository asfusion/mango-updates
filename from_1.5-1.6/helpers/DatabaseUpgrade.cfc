<cfcomponent>

	<cffunction name="updateSettings" returntype="boolean" output="true">
		<cfargument name="queryInterface" />
		<cfargument name="settings" />
		<cfargument name="blogId" />
		
		<cfset var local = structnew() />
		<cfset variables.tablePrefix = arguments.queryInterface.getTablePrefix() />
		<cfset variables.queryInterface = arguments.queryInterface />
		<cfset variables.blogId = arguments.blogId />
		
		<cfset local.result = true />
		
		<cftry>
			<cfset addSetting('system/assets','directory', 
				arguments.settings.get('#arguments.blogId#/blogsettings/assets','directory','{baseDirectory}assets/content/')) />
			<cfset addSetting('system/assets','path', 
				arguments.settings.get('#arguments.blogId#/blogsettings/assets','path','assets/content/')) />
			
			
			<cfset addSetting('system/mail','server', 
				arguments.settings.get('generalSettings/mailServer','server','')) />
			<cfset addSetting('system/mail','username', 
				arguments.settings.get('generalSettings/mailServer','username','')) />	
			<cfset addSetting('system/mail','password', 
				arguments.settings.get('generalSettings/mailServer','password','')) />
			<cfset addSetting('system/mail','defaultFromAddress', 
				arguments.settings.get('generalSettings/mailServer','defaultFromAddress','')) />
				
				
			<cfset addSetting('system/urls','searchUrl', 
				arguments.settings.get('#arguments.blogId#/blogsettings','searchUrl','archives.cfm/search/')) />
			<cfset addSetting('system/urls','postUrl', 
				arguments.settings.get('#arguments.blogId#/blogsettings','postUrl','post.cfm/{postName}')) />
			<cfset addSetting('system/urls','authorUrl', 
				arguments.settings.get('#arguments.blogId#/blogsettings','authorUrl','author.cfm/{authorAlias}')) />
			<cfset addSetting('system/urls','archivesUrl', 
				arguments.settings.get('#arguments.blogId#/blogsettings','archivesUrl','archives.cfm/')) />
			<cfset addSetting('system/urls','categoryUrl', 
				arguments.settings.get('#arguments.blogId#/blogsettings','categoryUrl','archives.cfm/category/{categoryName}')) />
			<cfset addSetting('system/urls','pageUrl', 
				arguments.settings.get('#arguments.blogId#/blogsettings','pageUrl','page.cfm/{pageHierarchyNames}{pageName}')) />
			<cfset addSetting('system/urls','rssUrl', 
				arguments.settings.get('#arguments.blogId#/blogsettings','rssUrl','feeds/rss.cfm')) />
			<cfset addSetting('system/urls','atomUrl', 
				arguments.settings.get('#arguments.blogId#/blogsettings','atomUrl','feeds/atom.cfm')) />
			<cfset addSetting('system/urls','apiUrl', 
				arguments.settings.get('#arguments.blogId#/blogsettings','apiUrl','api')) />
			<cfset addSetting('system/urls','useFriendlyUrls', 
				arguments.settings.get('#arguments.blogId#/blogsettings','useFriendlyUrls','1')) />
			<cfset addSetting('system/urls','admin', '') />
			
			<cfset local.customSettings = arguments.settings.exportSubtreeAsStruct('#arguments.blogId#/logging') />
			<cfloop collection="#local.customSettings#" item="local.searchKey">
				<cfif isStruct(local.customSettings[local.searchKey])>
					<!--- we are only going to go one level deep here --->
					<cfloop collection="#local.customSettings[local.searchKey]#" item="local.searchSubKey">
						<cfif NOT isStruct(local.customSettings[local.searchKey][local.searchSubKey])>
							<cfset addSetting('system/engine/logging/#local.searchKey#', 
								 local.searchSubKey, local.customSettings[local.searchKey][local.searchSubKey]) />
						</cfif>
					</cfloop>
				<cfelse>
					<cfset addSetting('system/engine/logging', local.searchKey, local.customSettings[local.searchKey]) />
				</cfif>
			</cfloop>
			
			<cfset addSetting('system/engine','enableThreads', 
				arguments.settings.get('generalSettings/system','enableThreads','0')) />
				
			<cfset addSetting('system/skins','directory', 
				arguments.settings.get('#arguments.blogId#/blogsettings','skinsDirectory','{baseDirectory}skins/')) />	
			<cfset addSetting('system/skins','path', '') />	
			<cfset addSetting('system/skins','url', '') />		
			
			<cfset addSetting('system/authorization','methods', 
				arguments.settings.get('#arguments.blogId#/authorization','methods','native')) />
			
			<!--- check for custom authentication --->
			<cfif len(arguments.settings.get('#arguments.blogId#/authorization/settings','component','')) GT 0>
				<cfset local.auth = arguments.settings.exportSubtreeAsStruct('#arguments.blogId#/authorization/settings') />
				
				<cfloop collection="#local.auth#" item="local.authSetting">
					<cfset addSetting('system/authorization/settings',local.authSetting, '#replacenocase(local.auth[local.authSetting],"'","''",'all')#') />
				</cfloop>
			</cfif>
			
			<cfset addSetting('system/plugins','directory', 
				arguments.settings.get('#arguments.blogId#/plugins','directory','{componentsDirectory}plugins/')) />
			<cfset addSetting('system/plugins','path', 
				arguments.settings.get('#arguments.blogId#/plugins','path','plugins.')) />
			
			<cfset addSetting('system/search','component', 
				arguments.settings.get('#arguments.blogId#/searchSettings','component','search.DatabaseSimple')) />
			
			<cfset local.searchSettings = arguments.settings.exportSubtreeAsStruct('#arguments.blogId#/searchSettings/settings') />
			<cfloop collection="#local.searchSettings#" item="local.searchKey">
				<cfif isStruct(local.searchSettings[local.searchKey])>
					<!--- we are only going to go one level deep here --->
					<cfloop collection="#local.searchSettings[local.searchKey]#" item="local.searchSubKey">
						<cfif NOT isStruct(local.searchSettings[local.searchKey][local.searchSubKey])>
							<cfset addSetting('system/search/settings/#local.searchKey#', 
								 local.searchSubKey, local.searchSettings[local.searchKey][local.searchSubKey]) />
						</cfif>
					</cfloop>
				<cfelse>
					<cfset addSetting('system/search/settings', local.searchKey, local.searchSettings[local.searchKey]) />
				</cfif>
			</cfloop>
			
		
			<br />Database upgraded successfully<br />
			<cfcatch type="any">
				<cfset local.result = false />
				<br />Couldn't add settings to database: <cfoutput>#cfcatch.Detail#</cfoutput>
			</cfcatch>
		</cftry>
		
		<cfreturn local.result />
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::: --->
	<cffunction name="addSetting">
		<cfargument name="path">
		<cfargument name="name">
		<cfargument name="value">
		
		<cfset var local = structnew() />
		
		<!--- paths may contain a \ at the end, which makes the query fail, so we'll escape them --->
		<cfif right(arguments.value,1) EQ "\">
			<cfset arguments.value = arguments.value & "\" />
		</cfif>
		
		<cfset local.queryString = "SELECT * FROM #variables.tablePrefix#setting 
		WHERE path = '#arguments.path#' AND name = '#arguments.name#' AND blog_id = '#variables.blogId#'" />
		<cfset local.queryResult = variables.queryInterface.makeQuery(local.queryString,0,true) />
		
		<cfif NOT local.queryResult.recordcount>
			<!--- setting does not already exist --->
			<cfset local.queryStringInsert = "INSERT INTO #variables.tablePrefix#setting(path, name, value, blog_id)
  				VALUES('#arguments.path#', '#arguments.name#', '#arguments.value#', '#variables.blogId#')" />
			<cfset variables.queryInterface.makeQuery(local.queryStringInsert, 0, false) />
		</cfif>
		
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::: --->
	<cffunction name="updateCustomFields" returntype="void" output="true">
		<cfargument name="queryInterface" />
		
		<cfset var local = structnew() />
		<cfset local.tablePrefix = arguments.queryInterface.getTablePrefix() />
		
		<cfset local.queryString = "UPDATE #local.tablePrefix#entry_custom_field
			SET id = 'entryType'
			WHERE id = 'adminCustomPanel'
			" />
		<cfset arguments.queryInterface.makeQuery(local.queryString,0,false) />
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::: --->
	<cffunction name="addPermission" returntype="void" output="true">
		<cfargument name="queryInterface" />
		
		<cfset var local = structnew() />
		<cfset local.tablePrefix = arguments.queryInterface.getTablePrefix() />
		
		<cfset local.queryString = "SELECT * FROM #local.tablePrefix#permission
			WHERE id = 'set_profile'
			" />
		<cfset local.result = arguments.queryInterface.makeQuery(local.queryString,0, true) />
		
		<cfif local.result.recordcount EQ 0>
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#permission (id, name, description, is_custom)
				VALUES ('set_profile', 'Update own profile', 'Update own username, password, description and picture', 0)" />
			<cfset arguments.queryInterface.makeQuery(local.queryString, 0, false) />
		</cfif>
		
		<cfset local.queryString = "SELECT * FROM #local.tablePrefix#permission
			WHERE id = 'manage_comments'
			" />
		<cfset local.result = arguments.queryInterface.makeQuery(local.queryString,0, true) />
		
		<cfif local.result.recordcount EQ 0>
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#permission (id, name, description, is_custom)
				VALUES ('manage_comments', 'Manage comments', 'Edit and delete comments', 0)" />
			<cfset arguments.queryInterface.makeQuery(local.queryString, 0, false) />
		</cfif>
		
		<cftry>
			
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#role_permission (role_id, permission_id)
				VALUES ('administrator', 'set_profile')" />
			<cfset arguments.queryInterface.makeQuery(local.queryString, 0, false) />
			
			<cfcatch type="any"></cfcatch>
		</cftry>
		
		<cftry>
			
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#role_permission (role_id, permission_id)
				VALUES ('author', 'set_profile')" />
			<cfset arguments.queryInterface.makeQuery(local.queryString, 0, false) />
			
			<cfcatch type="any"></cfcatch>
		</cftry>
		
		<cftry>
			
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#role_permission (role_id, permission_id)
				VALUES ('editor', 'set_profile')" />
			<cfset arguments.queryInterface.makeQuery(local.queryString, 0, false) />
			
			<cfcatch type="any"></cfcatch>
		</cftry>
		
		
		<cftry>
			
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#role_permission (role_id, permission_id)
				VALUES ('administrator', 'manage_comments')" />
			<cfset arguments.queryInterface.makeQuery(local.queryString, 0, false) />
			
			<cfcatch type="any"></cfcatch>
		</cftry>
		
		<cftry>
			
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#role_permission (role_id, permission_id)
				VALUES ('author', 'manage_comments')" />
			<cfset arguments.queryInterface.makeQuery(local.queryString, 0, false) />
			
			<cfcatch type="any"></cfcatch>
		</cftry>
		
		<cftry>
			
			<cfset local.queryString = "INSERT INTO #local.tablePrefix#role_permission (role_id, permission_id)
				VALUES ('editor', 'manage_comments')" />
			<cfset arguments.queryInterface.makeQuery(local.queryString, 0, false) />
			
			<cfcatch type="any"></cfcatch>
		</cftry>
		
	</cffunction>
	
</cfcomponent>