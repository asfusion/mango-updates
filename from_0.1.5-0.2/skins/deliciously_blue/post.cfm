<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<mango:Post>
<head>
  <title><mango:PostProperty title /> - <mango:Blog title /></title>
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
				<h2><mango:PostProperty title /></h2>
				<mango:PostProperty body />
			</div>	
			<div>Posted by <mango:PostProperty author /> on <mango:PostProperty date /> at <mango:PostProperty time /> |  Categories: <mango:Categories><mango:Category><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty description />"> <mango:CategoryProperty title /></a> - </mango:Category></mango:Categories>              </div>

			<a name="comments"></a>
				<h3><mango:PostProperty ifCommentCountGT="0" commentCount> <mango:PostProperty>Comments</h3>
					<mango:Comments><mango:Comment>
					<div class="commentblock<mango:CommentProperty ifIsAuthor> highlighted</mango:CommentProperty>">
					<a <mango:CommentProperty ifhasurl>href="<mango:CommentProperty url />"</mango:CommentProperty> class="thumb">
				<mangox:Gravatar size="40" defaultimg="assets/images/nogravatar.png" class="left" /></a>
				
				<p><mango:CommentProperty ifhasurl><a href="<mango:CommentProperty url />"></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a></mango:CommentProperty> wrote on <a href="#comment-<mango:CommentProperty id />"><mango:CommentProperty date dateformat="mm/dd/yy" /> <mango:CommentProperty time /></a></p>
	            <mango:CommentProperty content />   
				</mango:Comment>
			</div>
			</mango:Comments>
		
							
				<mango:PostProperty ifCommentsAllowed>
				<a id="commentForm"></a>
				<h4>Write your comment</h4>
				<mango:Message ifMessageExists type="comment" status="error">
					<p class="error">There was a problem: <mango:Message text /></p>
				</mango:Message>
				<mango:Message ifMessageExists type="comment" status="success">
					<p class="message"><mango:Message text /></p>
				</mango:Message>
				<form method="post" action="#commentForm" name="comments_form">
					<input type="hidden" name="action" value="addComment" />
					<input type="hidden" name="comment_post_id" value="<mango:PostProperty id />" />
					<input type="hidden" name="comment_parent" value="" />
					<p><label for="comment-author">Name</label><br />
                       <input id="comment-author" name="comment_name" size="30" value="<mango:RequestVar name="comment_name" />"  />
                    </p>
                    <p>
					<label for="comment-email">Email Address (it will not be displayed)</label><br />
					<input id="comment-email" name="comment_email" size="30" value="<mango:RequestVar name="comment_email" />" /></p>
					<p>
						<label for="comment-url">Website</label><br />
						<input id="comment-url" name="comment_website" size="30" value="<mango:RequestVar name="comment_website" />" />
					</p>
					<p>
						<label for="subscribe">
							<input type="checkbox" id="subscribe" name="comment_subscribe" value="1" />Subscribe to this comment thread</label>
					</p>
					<p>
						<label for="comment-text">Comments:</label><br />
						<textarea id="comment-text" name="comment_content" rows="10" cols="30"><mango:RequestVar name="comment_content" /></textarea>
					</p>
					<mango:Event name="beforeCommentFormEnd" />
					<p><input type="submit" accesskey="s" name="submit_comment" id="comment-post" value="Post" />	</p>
				</form>
			</mango:PostProperty> 
			</mango:Post>	
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
</body>
</html>