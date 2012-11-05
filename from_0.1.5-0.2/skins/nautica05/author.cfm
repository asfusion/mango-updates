<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<mango:Author>
<head>
  <title><mango:AuthorProperty name /> | <mango:Blog title /></title>
	<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=<mango:Blog charset />" />
	<meta name="generator" content="Mango <mango:Blog version />" />
	<meta name="description" content="<mango:Blog description />" />
	<meta name="keywords" content="" />
	<meta name="robots" content="index, follow" />

	<link rel="alternate" type="application/atom+xml" title="Atom" href="<mango:Blog atomurl />" />
	<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="<mango:Blog rssurl />" />	
	<link rel="EditURI" type="application/rsd+xml" title="RSD" href="<mango:Blog apiurl />" />

 	<link rel="stylesheet" type="text/css" href="<mango:Blog skinurl />assets/styles/layout.css" media="screen, projection, tv " />
	<link rel="stylesheet" type="text/css" href="<mango:Blog skinurl />assets/styles/html.css" media="screen, projection, tv " />
	<mango:Event name="beforeHtmlHeadEnd" />
</head>

<body>
<mango:Event name="beforeHtmlBodyStart" />
<!-- #content: holds all except site footer - causes footer to stick to bottom -->
<div id="content">

  <!-- #header: holds the logo and top links -->
  <div id="header" class="width">
	<h1><a href="<mango:Blog basePath />"><mango:Blog title /></a> <span class="tagline"><mango:Blog tagline /></span></h1>
    <ul>
      <li><a href="<mango:Blog rssurl />" class="last">RSS Feeds</a></li>
    </ul>

  </div>
  <!-- #header end -->


  <!-- #headerImg: holds the main header image or flash -->
  <div id="headerImg" class="width"></div>

  <!-- #menu: the main large box site menu -->
  <div id="menu" class="width">
    <ul>
        <li><a href="<mango:Blog basePath />"><span class="title">Blog</span></a></li>
		<mango:Pages><mango:Page>
			<li><a href="<mango:PageProperty link>" title="<mango:PageProperty title />"><span class="title"><mango:PageProperty title /></span></a></li></mango:Page></mango:Pages>
    </ul>

  </div>
  <!-- #menu end -->

  <!-- #page: holds the page content -->
  <div id="page">

    <!-- #columns: holds the columns of the page -->
    <div id="columns" class="widthPad">


    <!-- Right column -->
    <div class="floatLeft width73">

     <h1>About <mango:AuthorProperty name /></h1>
	    <div class="post">
			<mango:AuthorProperty description />
		</div>

    </div>
    <!-- Right column end -->
	
	 <!-- Right link column -->
    <div class="floatRight width25 lightBlueBg horzPad">
	<mango:Event name="afterSideBarStart" number="1" />
      <h3>Categories</h3>

      <ul class="submenu1">
		<mango:Categories>
			<mango:Category>
	        <li><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty title />"><mango:CategoryProperty title /></a></li>
			</mango:Category>
		</mango:Categories>
      </ul>
		
	 <h3>Monthly <span class="dark">Archives</span></h3>
			
     <ul class="submenu1"><mango:Archives type="month"><mango:Archive>
        <li><a href="<mango:ArchiveProperty link />"><mango:ArchiveProperty title dateformat="mmmm yyyy" /> (<mango:ArchiveProperty postcount />)</a></li>
		</mango:Archive>
		</mango:Archives>
	  </ul>

	<h3>Search <span class="dark">Archives</span></h3>
		<form name="searchForm" id="searchForm" method="get" action="<mango:Blog searchUrl />">
			<input type="text" name="term" value="Search For..." />
			<input class="button" type="submit" name="Submit" value="GO" />
		</form>
		
		<!--- Links --->
		<mangox:LinkCategories>
			<mangox:LinkCategory ifCurrentIsEven>
			<h3><span class="dark"><mangox:LinkCategoryProperty name /></span></h3>
			</mangox:LinkCategory>
			<mangox:LinkCategory ifCurrentIsOdd>
			<h3><mangox:LinkCategoryProperty name /></h3>
			</mangox:LinkCategory>
			<ul class="submenu1">
			<mangox:Links>
				<mangox:Link>
					<li><a href="<mangox:LinkProperty address />" title="<mangox:LinkProperty title />"><mangox:LinkProperty title /></a></li>
				</mangox:Link>
			</mangox:Links>
			</ul>
		</mangox:LinkCategories>
	  
		<mango:Event name="beforeSideBarEnd" number="1" />
	</div>
	
    </div>
    <!-- #columns end -->

  </div>
  <!-- #page end -->

</div>
<!-- #content end -->

<!-- #footer: holds the site footer (logo and links) -->
<div id="footer">

  <!-- #bg: applies the site width and footer background -->
	<div id="bg" class="width">
		<mango:Event name="afterFooterStart" />
		<ul>
			<li><a href="http://www.mangoblog.org" title="Mango Blog - A ColdFusion blog engine">Powered by Mango Blog</a></li>
			<li>Design by <a href="http://www.studio7designs.com">studio7designs.com</a> ported by <a href="http://www.asfusion.com">AsFusion</a></li>
		</ul>
		<mango:Event name="beforeFooterEnd" />
  	</div>
  <!-- #bg end -->

</div>
<!-- #footer end -->
<mango:Event name="beforeHtmlBodyEnd" />
</body>
</mango:Author>	
</html>