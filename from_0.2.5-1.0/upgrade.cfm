<cfparam name="id" default="default">
<cfparam name="done" default="0">

<cfif NOT done>
<cfset path = GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset config = createObject("component","components.utilities.Preferences").init("#path#config.cfm")>
<cfset pluginPrefs = createObject("component","components.utilities.Preferences").init("#path#pluginprefs.cfm")>

<cfset currentSystemPlugins = pluginPrefs.get(id,"systemPlugins","") />
<cfset currentSystemPlugins = listappend(currentSystemPlugins, "Statistics") />
<cfset pluginPrefs.put(id,"systemPlugins", currentSystemPlugins) />

<cfset config.put(id & "/blogsettings/admin/customPanels","directory", "#path#admin/custompanels/") />
<cfset config.put(id & "/blogsettings/admin/customPanels","path", "custompanels/") />

<!--- try deleting admin files I removed --->
<cfloop list="page_edit.cfm,page_new.cfm,post_edit.cfm,post_new.cfm,author_edit.cfm,author_new.cfm,authorForm.cfm,category_edit.cfm,category_new.cfm,categoryForm.cfm,fileUpload.swf,download.cfm,upload.cfm,loader.swf,fileexplorer.ini.cfm,uploadSkinFile.cfm,downloadSkinFile.cfm" index="item">
<cftry>
	<cffile action="delete" file="#path#admin/#item#">
<cfcatch type="any">
</cfcatch>
</cftry>
</cfloop>


<!--- try deleting admin folders I removed --->
<cfloop list="assets/editors/tinymce,icons,com/blueinstant,fileexplorer,services" index="item">
<cftry>
	<cfdirectory action="delete" directory="#path#admin/#item#" recurse="true">
<cfcatch type="any">
</cfcatch>
</cftry>
</cfloop>

<!--- check the datasource --->
<cfset datasource = config.get("/generalSettings/dataSource","name") />
<cfset dbtype = config.get("/generalSettings/dataSource","type") />
<cfset prefix = config.get("/generalSettings/dataSource","tablePrefix") />
<cfset username = config.get("/generalSettings/dataSource","username") />
<cfset password = config.get("/generalSettings/dataSource","password") />

<cftransaction action="begin">	
	<cftry>
		<!--- set baseline is complete EQ true, if there is an error we will set it to false--->
		<cfset isComplete = true />
	
		<cfif dbtype EQ "mssql">
			<cfquery name="modifyAuthorsTable" datasource="#datasource#" username="#username#" password="#password#">
				ALTER TABLE #prefix#author
				ADD active bit NULL DEFAULT 1;
				
				ALTER TABLE #prefix#author
				DROP COLUMN permissions;
				
				ALTER TABLE #prefix#permission
				ADD name varchar(50) NULL, 
				is_custom bit NULL DEFAULT 1;
							
				ALTER TABLE #prefix#author_blog
				ADD role varchar(20) NULL;
			</cfquery>	
			<cfquery name="modifyAuthorsTable" datasource="#datasource#" username="#username#" password="#password#">
				UPDATE #prefix#author
				SET active = 1;
				
				CREATE TABLE #prefix#role ( 
					id  	varchar(20) NOT NULL,
					name	varchar(50) NULL,
					description varchar(255) default NULL,
					preferences ntext default NULL,
					CONSTRAINT PK_#prefix#role PRIMARY KEY(id)
				);
				
				  
				CREATE TABLE #prefix#role_permission ( 
				    role_id      	varchar(20) NOT NULL,
				    permission_id	varchar(20) NOT NULL,
				    CONSTRAINT PK_#prefix#role_permission PRIMARY KEY(permission_id,role_id)
				)
				
				ALTER TABLE #prefix#role_permission
				    ADD CONSTRAINT FK_#prefix#role_permission_role
					FOREIGN KEY(role_id)
					REFERENCES #prefix#role(id)
					ON DELETE CASCADE  ON UPDATE CASCADE
				
				ALTER TABLE #prefix#role_permission
				    ADD CONSTRAINT FK_#prefix#role_permission_permission
					FOREIGN KEY(permission_id)
					REFERENCES #prefix#permission(id)
					ON DELETE CASCADE  ON UPDATE CASCADE
		
				
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('manage_all_pages', 'Manage pages', 'Add, edit and remove any page', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('manage_all_posts', 'Manage all posts', 'Edit and remove other author''s posts', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('manage_categories', 'Manage categories', 'Add, edit and delete categories', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('manage_files', 'Manage files', 'Upload, rename and delete files', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('manage_links', 'Manage links', 'Add, edit and remove links', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('manage_pages', 'Manage own pages', 'Add, edit, and remove pages created by the user', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('manage_plugins', 'Manage plugins', 'Install and remove plugins', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('manage_plugin_prefs', 'Manage plugin custom settings', 'Change settings specified by plugins', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('manage_posts', 'Manage own posts', 'Create and edit own posts', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('manage_settings', 'Manage blog settings', 'Change blog main settings', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('manage_themes', 'Manage themes', 'Download and remove themes', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('manage_users', 'Manage users', 'Add and edit users and permissions', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('plublish_pages', 'Publish pages', 'If not enabled, user can only create drafts or "to review" pages', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('publish_posts', 'Publish posts', 'If not enabled, user can only create drafts or "to review" posts', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('set_plugins', 'Manage installed plugins', 'Activate and de-activate plugins', 0);
				INSERT INTO #prefix#permission(id, name, description, is_custom)
				  VALUES('set_themes', 'Switch themes', 'Change the blog theme', 0);
				
				
				INSERT INTO #prefix#role (id, name, description, preferences)
				  VALUES('administrator', 'Administrator', 'Somebody who has access to all the administration features.', '');
				INSERT INTO #prefix#role (id, name, description, preferences)
				  VALUES('author', 'Author', 'Somebody who can publish and manage their own posts and pages.', '');
				INSERT INTO #prefix#role (id, name, description, preferences)
				  VALUES('editor', 'Editor', 'Somebody who can publish posts, manage posts as well as manage other people''s posts.', '');
				
				
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'manage_all_pages');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('author', 'manage_all_pages');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('editor', 'manage_all_pages');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'manage_all_posts');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('editor', 'manage_all_posts');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'manage_categories');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('author', 'manage_categories');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('editor', 'manage_categories');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'manage_files');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('author', 'manage_files');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('editor', 'manage_files');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'manage_links');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('editor', 'manage_links');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'manage_pages');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('author', 'manage_pages');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('editor', 'manage_pages');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'manage_plugins');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'manage_plugin_prefs');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('editor', 'manage_plugin_prefs');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'manage_posts');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('author', 'manage_posts');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('editor', 'manage_posts');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'manage_settings');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'manage_themes');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'manage_users');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'plublish_pages');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('author', 'plublish_pages');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('editor', 'plublish_pages');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'publish_posts');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('author', 'publish_posts');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('editor', 'publish_posts');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'set_plugins');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('administrator', 'set_themes');
				INSERT INTO #prefix#role_permission(role_id, permission_id)
				  VALUES('editor', 'set_themes');
				
				
				UPDATE #prefix#author_blog
				SET role = 'administrator';
			</cfquery>
			
		<cfelseif dbtype EQ "mysql">
			<cfquery name="modifyAuthorsTable" datasource="#datasource#" username="#username#" password="#password#">
				ALTER TABLE `#prefix#author` 
				DROP COLUMN `permissions`,
				ADD COLUMN `active` TINYINT(1) DEFAULT 1 AFTER `alias`;
			</cfquery>
			<cfquery name="modifyAuthorsTable" datasource="#datasource#" username="#username#" password="#password#">
				UPDATE #prefix#author
				SET active = 1;
			</cfquery>
			<cfquery name="modifyPermissionsTable" datasource="#datasource#" username="#username#" password="#password#">
				ALTER TABLE `#prefix#permission` 
				ADD COLUMN `name` varchar(50) AFTER `id`,
				ADD COLUMN `is_custom` TINYINT(1) DEFAULT 1 AFTER `description`;
			</cfquery>
			<cfquery name="addRoleTable" datasource="#datasource#" username="#username#" password="#password#">
				CREATE TABLE `#prefix#role` (
					`id` varchar(20) NOT NULL,
					`name` varchar(50) default NULL,
					`description` varchar(255) default NULL,
					`preferences` text default NULL,
				  PRIMARY KEY  (`id`)
				) CHARACTER SET utf8 COLLATE utf8_general_ci;
			</cfquery>
			<cftry>
			<cfquery name="addRolePermissionTable" datasource="#datasource#" username="#username#" password="#password#">
			CREATE TABLE  `#prefix#role_permission` (
			  `role_id` varchar(20) NOT NULL,
			  `permission_id` varchar(20) NOT NULL,
			  PRIMARY KEY (`permission_id`, `role_id`),
			  CONSTRAINT `FK_#prefix#role_permission_role` FOREIGN KEY `FK_#prefix#role_permission_role` (`role_id`)
			    REFERENCES `#prefix#role` (`id`)
			    ON DELETE CASCADE
			    ON UPDATE CASCADE,
			  CONSTRAINT `FK_#prefix#role_permission_permission` FOREIGN KEY `FK_#prefix#role_permission_permission` (`permission_id`)
			    REFERENCES `#prefix#permission` (`id`)
			    ON DELETE CASCADE
			    ON UPDATE CASCADE
			) CHARACTER SET utf8 COLLATE utf8_general_ci;
			</cfquery>
			<cfcatch type="any">
				<cfquery name="addRolePermissionTable" datasource="#datasource#" username="#username#" password="#password#">
			CREATE TABLE  `#prefix#role_permission` (
			  `role_id` varchar(20) NOT NULL,
			  `permission_id` varchar(20) NOT NULL,
			  PRIMARY KEY (`permission_id`, `role_id`)
			) CHARACTER SET utf8 COLLATE utf8_general_ci;
			</cfquery>
			</cfcatch>
			
			</cftry>
			<cfquery name="modifyAuthorBlogTable" datasource="#datasource#" username="#username#" password="#password#">
			ALTER TABLE `#prefix#author_blog` ADD COLUMN `role` varchar(20) AFTER `blog_id`;
			</cfquery>
			<cfquery name="addPermission" datasource="#datasource#" username="#username#" password="#password#">
			INSERT INTO #prefix#permission(id, name, description, is_custom)
			VALUES('manage_all_pages', 'Manage pages', 'Add, edit and remove any page', 0),
			('manage_all_posts', 'Manage all posts', 'Edit and remove other author''s posts', 0),
			('manage_categories', 'Manage categories', 'Add, edit and delete categories', 0),
			('manage_files', 'Manage files', 'Upload, rename and delete files', 0),
			('manage_links', 'Manage links', 'Add, edit and remove links', 0),
			('manage_pages', 'Manage own pages', 'Add, edit, and remove pages created by the user', 0),
			('manage_plugins', 'Manage plugins', 'Install and remove plugins', 0),
			('manage_plugin_prefs', 'Manage plugin custom settings', 'Change settings specified by plugins', 0),
			('manage_posts', 'Manage own posts', 'Create and edit own posts', 0),
			('manage_settings', 'Manage blog settings', 'Change blog main settings', 0),
			('manage_themes', 'Manage themes', 'Download and remove themes', 0),
			('manage_users', 'Manage users', 'Add and edit users and permissions', 0),
			('plublish_pages', 'Publish pages', 'If not enabled, user can only create drafts or "to review" pages', 0),
			('publish_posts', 'Publish posts', 'If not enabled, user can only create drafts or "to review" posts', 0),
			('set_plugins', 'Manage installed plugins', 'Activate and de-activate plugins', 0),
			('set_themes', 'Switch themes', 'Change the blog theme', 0)
		</cfquery>
		
		<cfquery name="setup" datasource="#datasource#" username="#username#" password="#password#">
		INSERT INTO `#prefix#role` (id, name, description, preferences)
		  VALUES('administrator', 'Administrator', 'Somebody who has access to all the administration features.', ''),
		  ('author', 'Author', 'Somebody who can publish and manage their own posts and pages.', ''),
		  ('editor', 'Editor', 'Somebody who can publish posts, manage posts as well as manage other people''s posts.', '')
		</cfquery>
		
		<cfquery name="setup" datasource="#datasource#" username="#username#" password="#password#">
		INSERT INTO #prefix#role_permission(role_id, permission_id)
		  VALUES('administrator', 'manage_all_pages'),
				('author', 'manage_all_pages'),
				('editor', 'manage_all_pages'),
				('administrator', 'manage_all_posts'),
				('editor', 'manage_all_posts'),
				('administrator', 'manage_categories'),
				('author', 'manage_categories'),
				('editor', 'manage_categories'),
				('administrator', 'manage_files'),
				('author', 'manage_files'),
				('editor', 'manage_files'),
				('administrator', 'manage_links'),
				('editor', 'manage_links'),
				('administrator', 'manage_pages'),
				('author', 'manage_pages'),
				('editor', 'manage_pages'),
				('administrator', 'manage_plugins'),
				('administrator', 'manage_plugin_prefs'),
				('editor', 'manage_plugin_prefs'),
				('administrator', 'manage_posts'),
				('author', 'manage_posts'),
				('editor', 'manage_posts'),
				('administrator', 'manage_settings'),
				('administrator', 'manage_themes'),
				('administrator', 'manage_users'),
				('administrator', 'plublish_pages'),
				('author', 'plublish_pages'),
				('editor', 'plublish_pages'),
				('administrator', 'publish_posts'),
				('author', 'publish_posts'),
				('editor', 'publish_posts'),
				('administrator', 'set_plugins'),
				('administrator', 'set_themes'),
				('editor', 'set_themes');
			</cfquery>
			
			<cfquery name="setup" datasource="#datasource#" username="#username#" password="#password#">
				UPDATE #prefix#author_blog
				SET role = 'administrator';
			</cfquery>
		</cfif>
	
		<cfcatch type="any">
			<cftransaction action="rollback">
			<cfset isComplete = false />
			<p>Upgrade Error, please see the details below.  All changes to the database have been rolled back.</p>
			<cfdump var="#cfcatch#">
		</cfcatch>
	</cftry>
	<cfif isComplete>
		<cftransaction action="commit">			
		<p>Upgrade done, now you can copy the new files and restart CF or <a href="?done=1">click here</a>.</p>
	</cfif>
</cftransaction>

<cfelse>
	<cfset request.blogManager.reloadConfig() />
	<p>Done</p>
</cfif>