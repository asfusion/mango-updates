<cfparam name="id" default="default">

<cfset path = GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset config = createObject("component","components.utilities.Preferences").init("#path#config.cfm")>

<!--- add skin directory setting --->
<cfset config.put(id & "/blogsettings","skinsDirectory", "") />

<cfset pluginPrefs = createObject("component","components.utilities.Preferences").init("#path#pluginprefs.cfm")>
<cfset pluginPrefs.put(id,"systemPlugins", "CacheUpdater,SearchIndexer,SubscriptionHandler,Links") />

<!--- add tables for links --->
<!--- check the datasource --->
<cfset datasource = config.get("/generalSettings/dataSource","name") />
<cfset dbtype = config.get("/generalSettings/dataSource","type") />
<cfset prefix = config.get("/generalSettings/dataSource","tablePrefix") />

<cfif dbtype EQ "mssql">
	<cfquery name="addLinks" datasource="#datasource#">
		CREATE TABLE  #prefix#link (
		  id varchar(35) NOT NULL,
		  title nvarchar(100) default NULL,
		  description nvarchar(1000) default NULL,
		  address varchar(255) default NULL,
		  category_id varchar(35) default NULL,
		  showOrder int default '0'
		) 
		
		ALTER TABLE #prefix#link WITH NOCHECK ADD 
			CONSTRAINT PK_#prefix#link PRIMARY KEY  CLUSTERED 
			( id
			) 
		
		CREATE TABLE  #prefix#link_category (
		  id varchar(35) NOT NULL,
		  name nvarchar(50) default NULL,
		  description nvarchar(1000) default NULL,
		  parent_category_id varchar(35) default NULL
		)
		
		ALTER TABLE #prefix#link_category WITH NOCHECK ADD 
			CONSTRAINT PK_#prefix#link_category PRIMARY KEY  CLUSTERED 
			( id
			) 
	</cfquery>
<cfelseif dbtype EQ "mysql">
	<cfquery name="addLinks" datasource="#datasource#">
	CREATE TABLE  `#prefix#link` (
	  `id` varchar(35) NOT NULL,
	  `title` varchar(100) default NULL,
	  `description` varchar(1000) default NULL,
	  `address` varchar(255) default NULL,
	  `category_id` varchar(35) default NULL,
	  `showOrder` int(11) default '0',
	  PRIMARY KEY  (`id`)
	) 
	</cfquery>
	
	<cfquery name="addLinks" datasource="#datasource#">
	CREATE TABLE  `#prefix#link_category` (
	  `id` varchar(35) NOT NULL,
	  `name` varchar(50) default NULL,
	  `description` varchar(1000) default NULL,
	  `parent_category_id` varchar(35) default NULL,
	   PRIMARY KEY  (`id`)
	)
	</cfquery>
</cfif>

<cfset categoryId = createUUID() />

<cfquery name="addLinks"  datasource="#datasource#">
	INSERT INTO #variables.prefix#link_category ( id, name)
	VALUES ('#categoryId#', 'Favorite Links')
</cfquery>		
	
	<cfquery name="addLinks"  datasource="#datasource#">
		INSERT INTO #variables.prefix#link ( id, title, address, description, category_id)
		VALUES ('#createUUID()#', 'AsFusion', 'http://www.asfusion.com', 'A blog about ColdFusion and Flex', '#categoryId#')
  	</cfquery>
			


<p>Upgrade done, now you can copy the new files and restart CF.</p>