<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--

	terrafirma1.0 by nodethirtythree design
	http://www.nodethirtythree.com

-->
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
<mango:Author>
<title><mango:AuthorProperty name /> | <mango:Blog title /></title>
	<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=<mango:Blog charset />" />
	<meta name="generator" content="Mango <mango:Blog version />" />
	<meta name="description" content="<mango:Blog description />" />
	<meta name="robots" content="index, follow" />

	<link rel="alternate" type="application/atom+xml" title="Atom" href="<mango:Blog atomurl />" />
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<mango:Blog rssurl />" />	
	<link rel="EditURI" type="application/rsd+xml" title="RSD" href="<mango:Blog apiurl />" />
	
	<link rel="stylesheet" type="text/css" href="<mango:Blog skinurl />assets/styles/main.css" />
<mango:Event name="beforeHtmlHeadEnd" />
</head>
<body>
<mango:Event name="beforeHtmlBodyStart" />
<div id="outer">

	<div id="upbg"></div>

	<div id="inner">

		<div id="header">
			<h1><a href="<mango:Blog basePath />"><mango:Blog title /></a></h1>
			<h2><mango:Blog tagline /></h2>
		</div>
	
		<div id="splash"></div>
	
		<div id="menu">
			<ul>
				<li class="first"><a href="<mango:Blog basePath />">Blog</a></li>
				<mango:Pages><mango:Page>
					<li>
						<a href="<mango:PageProperty link>" title="<mango:PageProperty title />"><mango:PageProperty title /></a></li></mango:Page></mango:Pages>		
			</ul>
		</div>
	

		<div id="primarycontent">
		
			<!-- primary content start -->
			<div class="post">
				<div class="header">
					<h3>About <mango:AuthorProperty name /></h3>
				</div>
				<div class="content">
					<mango:AuthorProperty description />
					<p></p>
				</div>			
				<div class="footer">
				</div>
			</div>
			<!-- primary content end -->
	
		</div>
		
		<div id="secondarycontent">
		<mango:Event name="afterSideBarStart" number="1" />
			<!-- secondary content start -->
			<h3>Categories</h3>
			<div class="content">
				<mango:Categories>
				<ul class="linklist">
					<mango:Category ifCurrentIsFirst>
						<li class="first"><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty title />"><mango:CategoryProperty title /></a></li>
					</mango:Category>
					<mango:Category ifCurrentIsNotFirst>
						<li><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty title />"><mango:CategoryProperty title /></a></li>
					</mango:Category>
				</mango:Categories>
				</ul>
			</div>
			
			
			<h3>Monthly Archives</h3>
			<div class="content">
				<ul class="linklist"><mango:Archives type="month"><mango:Archive>
					<li><a href="<mango:ArchiveProperty link />"><mango:ArchiveProperty title dateformat="mmmm yyyy" /> (<mango:ArchiveProperty postcount />)</a></li>
				</mango:Archive></mango:Archives>
				</ul>
			</div>
			
			<!--- Links --->
		<mangox:LinkCategories>
			<mangox:LinkCategory>
				<h3><mangox:LinkCategoryProperty name /></h3>
			</mangox:LinkCategory>
			<div class="content">
				<ul class="linklist">
					<mangox:Links>
						<mangox:Link ifCurrentIsFirst>
						<li class="first"><a href="<mangox:LinkProperty address />" title="<mangox:LinkProperty title />"><mangox:LinkProperty title /></a></li>
						</mangox:Link>
						<mangox:Link ifCurrentIsNotFirst>
						<li><a href="<mangox:LinkProperty address />" title="<mangox:LinkProperty title />"><mangox:LinkProperty title /></a></li>
						</mangox:Link>
					</mangox:Links>
				</ul>
			</div>
		</mangox:LinkCategories>

			<!-- secondary content end -->
			<mango:Event name="beforeSideBarEnd" number="1" />
		</div>
	
		<div id="footer"><mango:Event name="afterFooterStart" />
			<a href="http://www.mangoblog.org" title="Mango Blog - A ColdFusion blog engine">Powered by Mango Blog</a>. Design by <a href="http://www.nodethirtythree.com/">NodeThirtyThree</a> ported by <a href="http://www.asfusion.com">AsFusion</a>
			<mango:Event name="beforeFooterEnd" />
		</div>

	</div>

</div>
<mango:Event name="beforeHtmlBodyEnd" />

</mango:Author>
</body>
</html>
