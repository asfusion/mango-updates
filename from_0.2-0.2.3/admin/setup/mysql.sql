<cfquery name="setup" datasource="#dsn#">
CREATE TABLE #prefix#author (
  `id` varchar(35) NOT NULL default '',
  `username` varchar(50) NOT NULL default '',
  `password` varchar(50) NOT NULL default '',
  `name` varchar(100) NOT NULL default '',
  `email` varchar(255) NOT NULL default '',
  `description` text default NULL,
  `shortdescription` text default NULL,
  `picture` varchar(100) NOT NULL default '',
  `alias` varchar(100) NOT NULL default '',
  `permissions` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `IX_#prefix#author` (`username`),
  KEY `IX_#prefix#author_1` (`alias`)
)
</cfquery>

<cfquery name="setup" datasource="#dsn#">
CREATE TABLE `#prefix#permission` (
	  		`id` varchar(20) NOT NULL,
	  		`description` varchar(255),
	  		PRIMARY KEY(`id`)
		)
</cfquery>

<cfquery name="setup" datasource="#dsn#">
CREATE TABLE `#prefix#blog` (
 `id` varchar(50) NOT NULL default '',
  `title` varchar(150) default NULL,
  `description` text default NULL,
  `tagline` varchar(150) default NULL,
  `skin` varchar(100) default NULL,
  `url` varchar(255) default NULL,
  `charset` varchar(50) default NULL,
  `basepath` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) 
</cfquery>

<cfquery name="setup" datasource="#dsn#">
CREATE TABLE  `#prefix#author_blog` (
  `author_id` varchar(35) NOT NULL default '',
  `blog_id` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`author_id`,`blog_id`),
  KEY `FK_#prefix#author_blog_blog` (`blog_id`),
  CONSTRAINT `FK_#prefix#author_blog_author` FOREIGN KEY (`author_id`) REFERENCES `#prefix#author` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_#prefix#author_blog_blog` FOREIGN KEY (`blog_id`) REFERENCES `#prefix#blog` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) 
</cfquery>


<cfquery name="setup" datasource="#dsn#">
CREATE TABLE `#prefix#category` (
  `id` varchar(35) NOT NULL default '',
  `name` varchar(150) default NULL,
  `title` varchar(150) default NULL,
  `description` varchar(150) default NULL,
  `created_on` datetime default NULL,
  `parent_category_id` varchar(35) default NULL,
  `blog_id` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  KEY `IX_#prefix#category` (`blog_id`),
  CONSTRAINT `FK_#prefix#category_blog` FOREIGN KEY (`blog_id`) REFERENCES `#prefix#blog` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)
</cfquery>

<cfquery name="setup" datasource="#dsn#">
CREATE TABLE `#prefix#entry` (
 `id` varchar(35) NOT NULL default '',
  `name` varchar(200) NOT NULL default '',
  `title` varchar(200) NOT NULL default '',
  `content` text default NULL,
  `excerpt` text default NULL,
  `author_id` varchar(35) default NULL,
  `comments_allowed` tinyint(1) NOT NULL default '1',
  `trackbacks_allowed` tinyint(1) default NULL,
  `status` varchar(50) default NULL,
  `last_modified` datetime default NULL,
  `blog_id` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  KEY `IX_#prefix#entry` (`name`),
  KEY `FK_#prefix#entry_author` (`author_id`),
  KEY `FK_#prefix#entry_blog` (`blog_id`),
  CONSTRAINT `FK_#prefix#entry_author` FOREIGN KEY (`author_id`) REFERENCES `#prefix#author` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_#prefix#entry_blog` FOREIGN KEY (`blog_id`) REFERENCES `#prefix#blog` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) 
</cfquery>

<cfquery name="setup" datasource="#dsn#">
CREATE TABLE `#prefix#entry_custom_field` (
  `id` varchar(255) NOT NULL default '',
  `entry_id` varchar(35) NOT NULL default '',
  `name` varchar(255) default NULL,
  `field_value` text default NULL,
  PRIMARY KEY  (`id`,`entry_id`),
  KEY `FK_#prefix#entry_custom_field_entry` (`entry_id`),
  CONSTRAINT `FK_#prefix#entry_custom_field_entry` FOREIGN KEY (`entry_id`) REFERENCES `#prefix#entry` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)
</cfquery>

<cfquery name="setup" datasource="#dsn#">
CREATE TABLE  `#prefix#entry_subscription` (
  `entry_id` varchar(35) NOT NULL default '',
  `email` varchar(100) NOT NULL default '',
  `name` varchar(50) default NULL,
  `type` varchar(20) NOT NULL default '',
  `mode` varchar(20) NOT NULL default 'instant',
  PRIMARY KEY  (`entry_id`,`email`,`type`),
  CONSTRAINT `FK_#prefix#subscription_entry` FOREIGN KEY (`entry_id`) REFERENCES `#prefix#entry` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)
</cfquery>

<cfquery name="setup" datasource="#dsn#">
CREATE TABLE  `#prefix#media` (
  `id` varchar(35) NOT NULL default '',
  `entry_id` varchar(35) default NULL,
  `url` varchar(255) default NULL,
  `fileSize` int(10) unsigned default NULL,
  `type` varchar(50) default NULL,
  `medium` varchar(50) default NULL,
  `isDefault` tinyint(3) unsigned default NULL,
  `duration` int(10) unsigned default NULL,
  `height` int(10) unsigned default NULL,
  `width` int(10) unsigned default NULL,
  `lang` varchar(50) default NULL,
  `rating` varchar(50) default NULL,
  `rating_scheme` varchar(10) default NULL,
  `title` varchar(100) default NULL,
  `description` text default NULL,
  `thumbnail` varchar(255) default NULL,
  `media_group` varchar(35) default NULL,
  `copyright` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  KEY `IX_#prefix#media` (`entry_id`),
  CONSTRAINT `FK_#prefix#media_entry` FOREIGN KEY (`entry_id`) REFERENCES `#prefix#entry` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) 
</cfquery>

<cfquery name="setup" datasource="#dsn#">
CREATE TABLE `#prefix#page` (
  `id` varchar(35) NOT NULL default '0',
  `template` varchar(100) default NULL,
  `parent_page_id` varchar(35) default NULL,
  `hierarchy` text default NULL,
  `sort_order` int(10) unsigned NOT NULL default '1',
  PRIMARY KEY  (`id`),
  CONSTRAINT `FK_#prefix#page_entry` FOREIGN KEY (`id`) REFERENCES `#prefix#entry` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) 
</cfquery>

<cfquery name="setup" datasource="#dsn#">
CREATE TABLE `#prefix#post` (
  `id` varchar(35) NOT NULL default '0',
  `posted_on` datetime default NULL,
  PRIMARY KEY  (`id`),
  CONSTRAINT `FK_#prefix#post_entry` FOREIGN KEY (`id`) REFERENCES `#prefix#entry` (`id`) ON DELETE CASCADE ON UPDATE CASCADE 
)
</cfquery>

<cfquery name="setup" datasource="#dsn#">
CREATE TABLE `#prefix#comment` (
  `id` varchar(35) NOT NULL default '',
  `entry_id` varchar(35) default NULL,
  `content` text default NULL,
  `creator_name` varchar(50) default NULL,
  `creator_email` varchar(100) default NULL,
  `creator_url` varchar(255) default NULL,
  `created_on` datetime default NULL,
  `approved` tinyint(1) default NULL,
  `author_id` varchar(35) default NULL,
  `parent_comment_id` varchar(35) default NULL,
  `rating` float default NULL,
  PRIMARY KEY  (`id`),
  KEY `IX_#prefix#comment` (`entry_id`),
  KEY `FK_#prefix#comment_author` (`author_id`),
  KEY `FK_#prefix#comment_comment` (`parent_comment_id`),
  CONSTRAINT `FK_#prefix#comment_author` FOREIGN KEY (`author_id`) REFERENCES `#prefix#author` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_#prefix#comment_comment` FOREIGN KEY (`parent_comment_id`) REFERENCES `#prefix#comment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_#prefix#comment_entry` FOREIGN KEY (`entry_id`) REFERENCES `#prefix#entry` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)

</cfquery>

<cfquery name="setup" datasource="#dsn#">
CREATE TABLE `#prefix#post_category` (
  `post_id` char(35) NOT NULL default '0',
  `category_id` char(35) NOT NULL default '0',
  PRIMARY KEY  (`post_id`,`category_id`),
  KEY `FK_#prefix#post_category_category` (`category_id`),
  CONSTRAINT `FK_#prefix#post_category_post` FOREIGN KEY (`post_id`) REFERENCES `#prefix#post` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)
</cfquery>

<cfquery name="setup" datasource="#dsn#">
CREATE TABLE  `#prefix#trackback` (
  `id` varchar(35) NOT NULL default '',
  `entry_id` varchar(35) default NULL,
  `content` text default NULL,
  `title` varchar(200) default NULL,
  `creator_url` varchar(255) default NULL,
  `creator_url_title` varchar(50) default NULL,
  `created_on` datetime default NULL,
  `approved` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `FK_#prefix#trackback_entry` (`entry_id`),
  CONSTRAINT `FK_#prefix#trackback_entry` FOREIGN KEY (`entry_id`) REFERENCES `#prefix#entry` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)
</cfquery>

<cfquery name="setup" datasource="#dsn#">
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

<cfquery name="setup" datasource="#dsn#">
CREATE TABLE  `#prefix#link_category` (
  `id` varchar(35) NOT NULL,
  `name` varchar(50) default NULL,
  `description` varchar(1000) default NULL,
  `parent_category_id` varchar(35) default NULL,
  `blog_id` varchar(50) default NULL,
   PRIMARY KEY  (`id`)
)
</cfquery>