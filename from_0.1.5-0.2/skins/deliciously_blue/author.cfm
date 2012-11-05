<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<mango:Author>
<head>
  <title><mango:AuthorProperty name /> - <mango:Blog title /></title>
	<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=<mango:Blog charset />" />
	<meta name="generator" content="Mango <mango:Blog version />" />
	<meta name="description" content="<mango:Blog description />" />
	<meta name="keywords" content="" />
	<meta name="robots" content="index, follow" />

	<link rel="stylesheet" href="<mango:blog skinurl />assets/styles/main.css" type="text/css" title="Style" media="screen" />
	<link rel="alternate" type="application/atom+xml" title="Atom" href="<mango:Blog atomurl />" />
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<mango:Blog rssurl />" />	
	<link rel="EditURI" type="application/rsd+xml" title="RSD" href="<mango:Blog apiurl />" />
	<link rel="stylesheet" type="text/css" href="<mango:Blog skinurl />assets/styles/main.css" media="screen, projection, tv " />
	<mango:Event name="beforeHtmlHeadEnd" />
</head>

<body>
<mango:Event name="beforeHtmlBodyStart" />
<div id="container">
	<div id="header">
		<form name="searchForm" id="searchForm" method="get" action="<mango:Blog searchUrl>">
			<input type="text" name="term" value="Search For..." />
			<input class="button" type="submit" name="Submit" value="GO" />
		</form>
		<h1><a href="<mango:Blog basePath />"><mango:Blog title /></a></h1>
		<p><mango:Blog tagline /></p>
	</div>

	<div id="tabs10">
		<ul>
			<mango:Pages from="1"><mango:Page>
	        <li><a href="<mango:PageProperty link>" title="<mango:PageProperty title />"><span><mango:PageProperty title /></span></a></li>
			</mango:Page></mango:Pages>	
		 </ul>
	</div>

	<div id="container2">
		<div id="content">
			<div>
				<h2>About <mango:AuthorProperty name /></h2>
				<mango:AuthorProperty description />
			</div>	
			
		</div>
<div id="sidebar"><mango:Event name="afterSideBarStart" number="1" />
		<h2>Categories</h2>
		<ul>
		<mango:Categories><mango:Category>
	    	<li><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty title />"><mango:CategoryProperty title /></a></li>
		</mango:Category>
		</mango:Categories>
		</ul>
		
		<p></p>
		<mango:Pages ifCountGT="0" count="1">
			<h2>Pages</h2>
		</mango:Pages>
		<ul>
		<mango:Pages from="1"><mango:Page>
	        <li><a href="<mango:PageProperty link />" title="<mango:PageProperty title />"><span><mango:PageProperty title /></span></a></li>
		</mango:Page></mango:Pages>	
		</ul>
		 <p></p>
		
		<h2>Recent posts</h2>
		 
        <mango:Posts count="5">	
			<p><mango:Post><a href="<mango:PostProperty link>"><mango:PostProperty title></a></mango:Post></p> 
        </mango:Posts>
		
		<h2>Monthly Archives</h2>
        <p><mango:Archives type="month"><mango:Archive>	
			<a href="<mango:ArchiveProperty link />"><mango:ArchiveProperty title dateformat="mmmm yyyy" /></a> (<mango:ArchiveProperty postcount>)<br />
	    	</mango:Archive></mango:Archives>
        </p>
			
		<h2>Syndication</h2>
			<p>
			<a href="<mango:Blog atomurl />">Feeds</a></p>
			
		<!--- Links --->
		<mangox:LinkCategories>
			<mangox:LinkCategory>
			<h2><mangox:LinkCategoryProperty name /></h2>
			</mangox:LinkCategory>
			<ul>
			<mangox:Links>
				<mangox:Link>
					<li><a href="<mangox:LinkProperty address />" title="<mangox:LinkProperty title />"><mangox:LinkProperty title /></a></li>
				</mangox:Link>
			</mangox:Links>
			</ul>
			<p></p>
		</mangox:LinkCategories>
			
	<mango:Event name="beforeSideBarEnd" number="1" />
	   	</div>
		<div id="footer"><mango:Event name="afterFooterStart" />
			<p>Design by <a href="http://www.jdavidmacor.com/">super j man</a> ported to <a href="http://www.mangoblog.org" title="Mango Blog - A ColdFusion blog engine">Mango Blog</a> by <a href="http://www.asfusion.com">AsFusion</a></p><mango:Event name="beforeFooterEnd" />
		</div>
	</div>

</div>
<mango:Event name="beforeHtmlBodyEnd" />
</mango:Author>
</body>
</html>