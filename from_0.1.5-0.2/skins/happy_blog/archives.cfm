<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>Archives | <mango:Blog title /></title>
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
		<div class="desni_clanak">
			<h3>About</h3>
			<p><mango:Blog description descriptionParagraphFormat /></p>
		</div>
				
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
	<mango:Archive pageSize="2">
	<div id="srednja_kolona">
	<div class="srednji_clanak">
		<div class="clanak">
		<mango:ArchiveProperty ifIsType="category"><h2>Category: <mango:ArchiveProperty title /></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="month"><h2>Viewing by month: <mango:ArchiveProperty title dateformat="mmmm yyyy" /></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="day"><h2>Viewing by day: <mango:ArchiveProperty title dateformat="dd mmmm yyyy" /></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="year"><h2>Viewing by year: <mango:ArchiveProperty title dateformat="yyyy" /></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="search"><h2>Search results for: <mango:ArchiveProperty title /></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="author"><h2>Viewing by author: <mango:ArchiveProperty title /></h2></mango:ArchiveProperty>
		<mango:ArchiveProperty ifIsType="unknown"><h2>No archives</h2></mango:ArchiveProperty>
		</div>
	</div>
	
	<mango:Posts count="5">
			<mango:Post>
				<div class="srednji_clanak">
					<div class="clanak">
				 		<h3><a href="<mango:PostProperty link />"><mango:PostProperty title /></a></h3>
				 		<mango:PostProperty ifhasExcerpt excerpt>
							<div class="read_more">
				 			<p><a href="<mango:PostProperty link />">Read more</a> &gt; Posted on: <mango:PostProperty date dateformat="medium" /></p>
				 			</div>
						</mango:PostProperty>
						<mango:PostProperty ifnothasExcerpt body>
							<div class="read_more"><p>Posted on: <mango:PostProperty date dateformat="medium" /></p></div>
						</mango:PostProperty>
				 		
				 	</div>
				</div>	
			</mango:Post>
		</mango:Posts>
		
		<p>
		<mango:ArchiveProperty ifHasPreviousPage><a class="next" href="<mango:ArchiveProperty link pageDifference="-1" />">Next Entries &gt;</a></mango:ArchiveProperty>
		<mango:ArchiveProperty ifHasNextPage><a class="previous" href="<mango:ArchiveProperty link pageDifference="1" />">&lt; Previous Entries</a></mango:ArchiveProperty> 
		</p>
		
	</mango:Archive>
	</div>
</div>
<mango:Event name="beforeHtmlBodyEnd" />
</body>
</html>