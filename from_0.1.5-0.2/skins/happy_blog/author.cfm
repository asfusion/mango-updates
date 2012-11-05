<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<mango:Author>
<head>
	<title><mango:AuthorProperty name /> | <mango:Blog title /></title>
	<meta http-equiv="Content-Type" content="text/html;charset=<mango:Blog charset />" />
	<link rel="stylesheet" type="text/css" href="images/style.css" />
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
<div id="sadrzaj">
	<div id="lijeva_kolona">
		<div id="title">
			<p><mango:Blog title /></p>
		</div>	
		<p><mango:Blog tagline /></p>
		
		<a href="<mango:Blog basePath />">Blog</a>
		<mango:Pages><mango:Page>
		<a href="<mango:PageProperty link>" title="<mango:PageProperty title />"><mango:PageProperty title /></a></mango:Page></mango:Pages>
		
	</div>
	
	<div id="desna_kolona">
	<mango:Event name="afterSideBarStart" number="1" />
				
		<div class="informacije">
			<p>Categories</p>
			<p><mangox:CategoryCloud /></p>
		</div>
		
		<div class="informacije">
			<p>Monthly Archives</p>
			<mango:Archives type="month"><mango:Archive>
        	<p><a href="<mango:ArchiveProperty link />"><mango:ArchiveProperty title dateformat="mmmm yyyy" /></a></p>
			</mango:Archive></mango:Archives>
		</div>
		
		<div class="informacije">
			<!--- Links --->
		<mangox:LinkCategories>
			<mangox:LinkCategory ifCurrentIsEven>
			<p><mangox:LinkCategoryProperty name /></p>
			</mangox:LinkCategory>
			<mangox:LinkCategory ifCurrentIsOdd>
			<p><mangox:LinkCategoryProperty name /></p>
			</mangox:LinkCategory>
			
			<mangox:Links>
				<mangox:Link>
					<p><a href="<mangox:LinkProperty address />" title="<mangox:LinkProperty title />"><mangox:LinkProperty title /></a></p>
				</mangox:Link>
			</mangox:Links>
		</mangox:LinkCategories>
		</div>
		
		
		<div class="informacije">
			<p>Feeds</p>
			<p><a href="<mango:Blog rssurl />" class="last">RSS Feeds</a></p>
		</div>
		
		<div class="informacije">
			<p>Design: Luka Cvrk <a href="http://www.solucija.com">Solucija.com</a>
			<br />Powered by: <a href="http://www.mangoblog.org" title="Mango Blog - A ColdFusion blog engine">Mango Blog</a><br />Ported by: <a href="http://www.asfusion.com">AsFusion</a>
			
			</p>
		</div>
		<mango:Event name="beforeSideBarEnd" number="1" />
	</div>
		
	<div id="srednja_kolona">
		<div class="srednji_clanak">
			<div class="clanak">
				 <h3>About <mango:AuthorProperty name /></h3>
				<mango:AuthorProperty description>				
			</div>
		</div>
		

		</div></div>
	</div>
</div>

<mango:Event name="beforeHtmlBodyEnd" />
</mango:Author>
</body>
</html>