<cfparam name="attributes.page" default="summary">
<cfparam name="attributes.includenav" default="true">
<cfimport prefix="mangoAdmin" taglib="tags">
<cfset page = attributes.page>

<div id="menucontainer">
<ul title="Main navigation menu" id="adminmenu">
	<cfif attributes.page NEQ "overview"><li id="overviewMenuItem"><a href="index.cfm">Overview</a></li>
<cfelse>
<li id="overviewMenuItem" class="current"><a href="index.cfm" class="current">Overview</a></li></cfif>

<cfif attributes.page NEQ "posts"><li id="postsMenuItem"><a href="post_new.cfm">Posts</a></li>
<cfelse><li id="postsMenuItem" class="current"><a href="post_new.cfm" class="current">Posts</a></li></cfif>

<cfif attributes.page NEQ "pages"><li id="pagesMenuItem"><a href="pages.cfm">Static Pages</a></li>
<cfelse><li id="pagesMenuItem" class="current"><a href="pages.cfm" class="current">Static Pages</a></li></cfif>

<cfif attributes.page NEQ "links"><li id="linksMenuItem"><a href="generic.cfm?event=links-showLinksSettings&amp;selected=links-showLinksSettings&amp;owner=Links">Links</a></li>
<cfelse><li id="linksMenuItem" class="current"><a href="generic.cfm?event=links-showLinksSettings&amp;selected=links-showLinksSettings&amp;owner=Links" class="current">Links</a></li></cfif>

<cfif attributes.page NEQ "Categories"><li id="categoriesMenuItem"><a href="categories.cfm">Categories</a></li>
<cfelse>
<li id="categoriesMenuItem" class="current"><a href="categories.cfm" class="current">Categories</a></li></cfif>

<cfif attributes.page NEQ "authors"><li id="authorsMenuItem"><a href="authors.cfm">Authors</a></li>
<cfelse>
<li id="authorsMenuItem" class="current"><a href="authors.cfm" class="current">Authors</a></li></cfif>

<cfif attributes.page NEQ "File Explorer"><li id="filesMenuItem"><a href="files.cfm">Files</a></li>
<cfelse>
<li id="filesMenuItem" class="current"><a href="files.cfm" class="current">Files</a></li></cfif>

<cfif attributes.page NEQ "settings"><li id="settingsMenuItem"><a href="settings.cfm">Settings</a></li>
<cfelse>
<li id="settingsMenuItem" class="current"><a href="settings.cfm" class="current">Settings</a></li></cfif>

<cfif attributes.page NEQ "Add-ons"><li id="pluginsMenuItem"><a href="addons.cfm">Add-ons</a></li>
<cfelse>
<li id="pluginsMenuItem" class="current"><a href="addons.cfm" class="current">Add-ons</a></li></cfif>

<cfif attributes.page NEQ "Cache"><li id="cacheMenuItem"><a href="cache.cfm">Cache</a></li>
<cfelse>
<li id="cacheMenuItem" class="current"><a href="cache.cfm" class="current">Cache</a></li></cfif>

<mangoAdmin:MenuEvent name="mainNav" liClass="menuItem" />

<li id="logoutMenuItem" class="last"><a href="index.cfm?logout=1">Logout</a></li>
</ul>
</div>