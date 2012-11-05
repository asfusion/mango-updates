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
<title>Archives | <mango:Blog title /></title>
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
		<mango:Archive pageSize="8">
			<mango:ArchiveProperty ifIsType="category"><h2>Category: <mango:ArchiveProperty title /></h2></mango:ArchiveProperty>
			<mango:ArchiveProperty ifIsType="month"><h2>Viewing by month: <mango:ArchiveProperty title dateformat="mmmm yyyy" /></h2></mango:ArchiveProperty>
			<mango:ArchiveProperty ifIsType="day"><h2>Viewing by day: <mango:ArchiveProperty title dateformat="dd mmmm yyyy" /></h2></mango:ArchiveProperty>
			<mango:ArchiveProperty ifIsType="year"><h2>Viewing by year: <mango:ArchiveProperty title dateformat="yyyy" /></h2></mango:ArchiveProperty>
			<mango:ArchiveProperty ifIsType="search"><h2>Search results for: <mango:ArchiveProperty title /></h2></mango:ArchiveProperty>
			<mango:ArchiveProperty ifIsType="author"><h2>Viewing by author: <mango:ArchiveProperty title /></h2></mango:ArchiveProperty>
			<mango:ArchiveProperty ifIsType="unknown"><h2>No archives</h2></mango:ArchiveProperty>
			
			<!-- primary content start -->
		<mango:Posts count="8">
			<mango:Post>
			<div class="post">
				<div class="header">
					<h3><a href="<mango:PostProperty link />"><mango:PostProperty title /></a></h3>
					<div class="date"><mango:PostProperty date dateformat="mmm dd, yyyy" /></div>
				</div>
			</div>
		</mango:Post>
		</mango:Posts>
		<p>
		<mango:ArchiveProperty ifHasPreviousPage><a class="next" href="<mango:ArchiveProperty link pageDifference="-1" />">Next Entries &gt;</a></mango:ArchiveProperty>
		<mango:ArchiveProperty ifHasNextPage><a class="previous" href="<mango:ArchiveProperty link pageDifference="1" />">&lt; Previous Entries</a></mango:ArchiveProperty> 
		</p>
		
		</mango:Archive>

			<!-- primary content end -->
	
		</div>
		
		<div id="secondarycontent">
		<mango:Event name="afterSideBarStart" number="1" />
			<!-- secondary content start -->
		
			<h3>About</h3>
			<div class="content">
				<p><mango:Blog description descriptionParagraphFormat /></p>
			</div>
			
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
		
		<h3>Feeds</h3>
		 <div class="content">
				<ul class="linklist">
			 <li class="first"><a href="<mango:Blog rssurl />" class="last">RSS Feeds</a></li>
    	</ul>
			</div>
		
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
</body>
</html>