<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=<mango:Blog charset />" />
	<meta name="generator" content="Mango <mango:Blog version />" />
	<meta name="description" content="<mango:Blog description />" />
	<meta name="robots" content="index, follow" />
	<title>Archives | <mango:Blog title /></title>
	
	<link rel="alternate" type="application/atom+xml" title="Atom" href="<mango:Blog atomurl />" />
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<mango:Blog rssurl />" />	
	<link rel="EditURI" type="application/rsd+xml" title="RSD" href="<mango:Blog apiurl />" />

	<link rel="stylesheet" href="<mango:blog skinurl />assets/styles/main.css" type="text/css" title="Style" media="screen" />
	<!--[if IE 6]><link rel="stylesheet" href="<mango:blog skinurl />assets/styles/fix.css" type="text/css" /><![endif]-->
	<mango:Event name="beforeHtmlHeadEnd" />
</head>

<body>
	<mango:Event name="beforeHtmlBodyStart" />
	<div id="sidebar">
	<h1><mango:Blog title /></h1>
	<h2><mango:Blog tagline /></h2>

	<div id="menu">
		<mango:Event name="afterSideBarStart" number="1" />
		<a href="<mango:Blog basePath />">Blog</a>
		<mango:Pages><mango:Page>
		<a href="<mango:PageProperty link />" title="<mango:PageProperty title />"><mango:PageProperty title /></a></mango:Page></mango:Pages>

		<h3>Categories</h3>
		
		<mango:Categories>
			<mango:Category>
			<mango:CategoryProperty ifiscurrentcategory>
	       <a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty title />" class="active"><mango:CategoryProperty title /></a>
	       </mango:CategoryProperty>
	       <mango:CategoryProperty ifisnotcurrentcategory>
	       	<a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty title />"><mango:CategoryProperty title /></a>
	       </mango:CategoryProperty>
	       </mango:Category>
		</mango:Categories>
		
	</div>


		<h3>Syndication</h3>
		<p><a href="<mango:Blog rssurl />">RSS Feeds</a><br />
		<a href="<mango:Blog atomurl />">Atom Feeds</a></p>
	<mango:Event name="beforeSideBarEnd" number="1" />
	</div>

	<div id="content">
	<mango:Archive pageSize="5">
	
		<mango:ArchiveProperty ifIsType="category"><h2>Category: <mango:ArchiveProperty title /></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="month"><h2>Viewing by month: <mango:ArchiveProperty title dateformat="mmmm yyyy" /></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="day"><h2>Viewing by day: <mango:ArchiveProperty title dateformat="dd mmmm yyyy" /></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="year"><h2>Viewing by year: <mango:ArchiveProperty title dateformat="yyyy" /></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="search"><h2>Search results for: <mango:ArchiveProperty title /></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="author"><h2>Viewing by author: <mango:ArchiveProperty title /></h2></mango:ArchiveProperty>					
		<mango:ArchiveProperty ifIsType="unknown"><h2>No archives</h2></mango:ArchiveProperty>
		
		<mango:Posts count="5">
			<mango:Post>
			<div>
				<h3><a href="<mango:PostProperty link />"><mango:PostProperty title /></a></h3>
				<mango:PostProperty ifhasExcerpt excerpt>
				<br />
				<a href="<mango:PostProperty link />">Read complete post</a>
				</mango:PostProperty>
				<mango:PostProperty ifnothasExcerpt body />
							
				</div>	
					
				<div class="footNote"><p>Posted by <mango:PostProperty author /> on <mango:PostProperty date dateformat="long" /> at <mango:PostProperty time /> - Categories: <mango:Categories><mango:Category><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty description />"> <mango:CategoryProperty title /></a><mango:Category ifCurrentIsNotLast> | </mango:Category></mango:Category></mango:Categories></p></div>
			</mango:Post>
		</mango:Posts>
		<mango:ArchiveProperty ifHasPreviousPage><a class="next" href="<mango:ArchiveProperty link pageDifference="-1" />">Next Entries &gt;</a></mango:ArchiveProperty>
		<mango:ArchiveProperty ifHasNextPage><a class="previous" href="<mango:ArchiveProperty link pageDifference="1" />">&lt; Previous Entries</a></mango:ArchiveProperty> 
			
	</mango:Archive>

	<div id="footer"><mango:Event name="afterFooterStart" />
		<p>Design by <a href="http://andreasviklund.com">Andreas Viklund</a>  ported to <a href="http://www.mangoblog.org">Mango</a> by <a href="http://www.asfusion.com">AsFusion</a></p>
		<mango:Event name="beforeFooterEnd" />
	</div>
	
</div>
<mango:Event name="beforeHtmlBodyEnd" />
</body>
</html>