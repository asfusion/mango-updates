<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<mango:Author>
<head profile="http://gmpg.org/xfn/11">
	<meta http-equiv="Content-Type" content="text/html; charset=<mango:Blog charset />" />
	<meta name="generator" content="Mango <mango:Blog version />" />
	<meta name="description" content="<mango:Blog description />" />
	<title><mango:AuthorProperty name /> |  &raquo; <mango:Blog title /></title>

	<meta name="robots" content="index, follow" />

	<link rel="alternate" type="application/atom+xml" title="Atom" href="<mango:Blog atomurl />" />
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<mango:Blog rssurl />" />	
	<link rel="EditURI" type="application/rsd+xml" title="RSD" href="<mango:Blog apiurl />" />
	
	<link rel="stylesheet" type="text/css" href="<mango:Blog skinurl />assets/styles/main.css" />
	
	<!-- Sweet Title -->
	<script type="text/javascript" src="<mango:Blog skinurl />assets/js/addEvent.js"></script>
	<script type="text/javascript" src="<mango:Blog skinurl />assets/js/sweetTitles.js"></script>
<mango:Event name="beforeHtmlHeadEnd" />
</head>

<body>
	<mango:Event name="beforeHtmlBodyStart" />
<div id="wrapper">

<div id="header">
	<ul class="menu">
		<li class="page_item">
			<a href="<mango:Blog basePath />" title="Blog Home">Blog</a>
		</li>
		<mango:Pages><mango:Page>
			<li class="page_item">
				<a href="<mango:PageProperty link>" title="<mango:PageProperty title />"><mango:PageProperty title /></a></li></mango:Page></mango:Pages>
	</ul>
	<h1><a href="<mango:Blog basePath />" title="<mango:Blog title />"><mango:Blog title /></a></h1>
</div><!-- End of #header -->

<div id="content">
			
		<div class="post">
			<h2 class="posttitle">About <mango:AuthorProperty name /></h2>
			
			<p class="postmeta"></p>
		
			<div class="postentry">
				<mango:AuthorProperty description>	
			</div>
		</div>
		
</div><!-- End of #content -->


<div id="sidebar">
	<mango:Event name="afterSideBarStart" number="1" />
<ul>
	<!-- Search -->
	<li id="sb-search">
		<h2>Search</h2>
		<form name="searchForm" id="searchForm" method="get" action="<mango:Blog searchUrl />">
			<p>
			<input type="text" name="term" value="" />&nbsp;
			<input class="button" type="submit" name="Submit" value="Search" />
			</p>
		</form>
	</li>

	<!-- Recent Posts -->
	<li id="sb-posts">
	<h2>Latest</h2>
		<ul>
	<mango:Posts count="5">
	<mango:Post>
			<li><a href="<mango:PostProperty link />" title="<mango:PostProperty title />"><mango:PostProperty title /></a></li>
	</mango:Post>
	</mango:Posts>	
		</ul>
	</li>


	<!-- Get Recent Comments -->

	<!-- Archives -->
	<li id="sb-archives">
		<h2>Archives</h2>
		<ul><mango:Archives type="month"><mango:Archive>
			<li><a href="<mango:ArchiveProperty link />" title="<mango:ArchiveProperty title dateformat="mmmm yyyy" />">
				<mango:ArchiveProperty title dateformat="mmmm yyyy" /></a>&nbsp;(<mango:ArchiveProperty postcount />)</li>
			</mango:Archive></mango:Archives>
		</ul>
	</li>

	<!-- Categories -->
	<li id="sb-cates">
		<h2>Categories</h2>
		<ul><mango:Categories>
			<mango:Category>
				<li><a href="<mango:CategoryProperty link />" title="View all posts filed under <mango:CategoryProperty title />"><mango:CategoryProperty title /></a>&nbsp;(<mango:CategoryProperty postcount />)</li>
			</mango:Category>
		</mango:Categories>
		</ul>
	</li>


	<!-- Feeds -->
	<li id="sb-feeds">
		<h2>Feeds</h2>
		<ul>
			<li><a href="<mango:Blog rssurl />" title="Syndicate this site using RSS 2.0"><abbr title="Really Simple Syndication">RSS</abbr></a></li>
		</ul>
	</li>

	<!-- Links -->
	<mangox:LinkCategories>
		<mangox:LinkCategory>
			<li id="linkcat-2" class="linkcat"><h2><mangox:LinkCategoryProperty name /></h2>
		</mangox:LinkCategory>
		<ul>
			<mangox:Links>
				<mangox:Link>
					<li><a href="<mangox:LinkProperty address />" title="<mangox:LinkProperty title />"><mangox:LinkProperty title /></a></li>
					</mangox:Link>
				</mangox:Links>
		</ul>
		</li>
	</mangox:LinkCategories>
</ul>
<mango:Event name="beforeSideBarEnd" number="1" />
</div><!-- End of #sidebar -->

<div id="footer">
<p><mango:Event name="afterFooterStart" />
<a href="<mango:Blog basePath />"><mango:Blog title /></a>
 is powered by <a href="http://www.mangoblog.org" title="Mango Blog - A ColdFusion blog engine">Mango Blog</a>
 with theme <a href="http://www.ilemoned.com/wordpress/wptheme-greenery" title="Greenary v2.0">Greenery</a>
 &#47; <a href="http://validator.w3.org/check/referer" title="Valid XHTML 1.0 Strict">XHTML</a>
<mango:Event name="beforeFooterEnd" />
</p>
</div><!-- End of #footer -->

</div><!-- End of #wrapper -->
<mango:Event name="beforeHtmlBodyEnd" />
</mango:Author>
</body>
</html>