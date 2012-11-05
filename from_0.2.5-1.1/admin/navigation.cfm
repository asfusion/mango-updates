<cfparam name="attributes.page" default="">
<cfimport prefix="mangoAdmin" taglib="tags">
<cfset page = attributes.page>
<cfset currentAuthor = request.blogManager.getCurrentUser() />
<cfset permissions = currentAuthor.currentRole.permissions />
<cfset preferences = currentAuthor.currentRole.preferences.get("admin","menuItems","all") />

<cffunction name="showMenuItem" returntype="boolean">
	<cfargument name="permissionsAllowed">
	<cfargument name="preferenceAllowed">
	<cfset var i = 0 />
	<cfset var show = NOT len(arguments.permissionsAllowed) />
	
	<cfloop list="#arguments.permissionsAllowed#" index="i">
		<cfif listfind(permissions,i)>
			<cfset show = true />
			<cfbreak>
		</cfif>
	</cfloop>
	
	<cfreturn show AND (NOT len(arguments.preferenceAllowed) OR listfind(preferences,arguments.preferenceAllowed) OR preferences EQ "all") />
</cffunction>

<div id="menucontainer">
<ul title="Main navigation menu" id="adminmenu">
<cfif attributes.page NEQ "overview"><li id="overviewMenuItem"><a href="index.cfm">Overview</a></li>
<cfelse><li id="overviewMenuItem" class="current"><a href="index.cfm" class="current">Overview</a></li></cfif>
<cfif showMenuItem("manage_all_posts,manage_posts","posts")>
<cfif attributes.page NEQ "posts"><li id="postsMenuItem"><a href="posts.cfm">Posts</a></li>
<cfelse><li id="postsMenuItem" class="current"><a href="posts.cfm" class="current">Posts</a></li></cfif>
</cfif>
<cfif showMenuItem("manage_all_posts,manage_posts","")>
<mangoAdmin:CustomMenu name="posts">
</cfif>
<cfif showMenuItem("manage_all_pages,manage_pages","pages")>
<cfif attributes.page NEQ "pages"><li id="pagesMenuItem"><a href="pages.cfm">Pages</a></li>
<cfelse><li id="pagesMenuItem" class="current"><a href="pages.cfm" class="current">Pages</a></li></cfif>
</cfif>
<cfif showMenuItem("manage_all_pages,manage_pages","")>
<mangoAdmin:CustomMenu name="pages">
</cfif>

<cfif showMenuItem("manage_links","links")>
<cfif attributes.page NEQ "links"><li id="linksMenuItem"><a href="generic.cfm?event=links-showLinksSettings&amp;selected=links-showLinksSettings&amp;owner=Links">Links</a></li>
<cfelse><li id="linksMenuItem" class="current"><a href="generic.cfm?event=links-showLinksSettings&amp;selected=links-showLinksSettings&amp;owner=Links" class="current">Links</a></li></cfif>
</cfif>

<cfif showMenuItem("manage_categories","categories")>
<cfif attributes.page NEQ "Categories"><li id="categoriesMenuItem"><a href="categories.cfm">Categories</a></li>
<cfelse><li id="categoriesMenuItem" class="current"><a href="categories.cfm" class="current">Categories</a></li></cfif>
</cfif>

<cfif showMenuItem("manage_files","files")>
<cfif attributes.page NEQ "File Explorer"><li id="filesMenuItem"><a href="files.cfm">Files</a></li>
<cfelse><li id="filesMenuItem" class="current"><a href="files.cfm" class="current">Files</a></li></cfif>
</cfif>

<cfif showMenuItem("manage_themes,set_themes","themes")>
<cfif attributes.page NEQ "Themes"><li id="themesMenuItem"><a href="skins.cfm">Themes</a></li>
<cfelse><li id="themesMenuItem" class="current"><a href="skins.cfm" class="current">Themes</a></li></cfif>
</cfif>

<cfif showMenuItem("manage_plugins,set_plugins","plugins")>
<cfif attributes.page NEQ "Add-ons"><li id="pluginsMenuItem"><a href="addons.cfm">Add-ons</a></li>
<cfelse><li id="pluginsMenuItem" class="current"><a href="addons.cfm" class="current">Add-ons</a></li></cfif>
</cfif>

<cfif showMenuItem("manage_users","users")>
	<cfset usersTitle = "Users">
<cfelse>
	<cfset usersTitle = "My Profile">
</cfif>
<cfoutput><cfif attributes.page NEQ "Users"><li id="authorsMenuItem"><a href="author.cfm?profile=1">#usersTitle#</a></li>
<cfelse><li id="authorsMenuItem" class="current"><a href="author.cfm?profile=1" class="current">#usersTitle#</a></li></cfif></cfoutput>

<cfif showMenuItem("","cache")>
<cfif attributes.page NEQ "Cache"><li id="cacheMenuItem"><a href="cache.cfm">Cache</a></li>
<cfelse><li id="cacheMenuItem" class="current"><a href="cache.cfm" class="current">Cache</a></li></cfif>
</cfif>
<cfif showMenuItem("manage_settings,manage_plugin_prefs","settings")>
<cfif attributes.page NEQ "settings"><li id="settingsMenuItem"><a href="settings.cfm">Settings</a></li>
<cfelse><li id="settingsMenuItem" class="current"><a href="settings.cfm" class="current">Settings</a></li></cfif>
</cfif>
<mangoAdmin:MenuEvent name="mainNav" liClass="menuItem" />

<li id="logoutMenuItem" class="last"><a href="index.cfm?logout=1">Logout</a></li>
</ul>
</div>