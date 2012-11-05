<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<mango:Post>
<head profile="http://gmpg.org/xfn/11">
	<meta http-equiv="Content-Type" content="text/html; charset=<mango:Blog charset />" />
	<meta name="generator" content="Mango <mango:Blog version />" />
	<meta name="description" content="<mango:Blog description />" />
	<title><mango:PostProperty title /> &raquo; <mango:Blog title /></title>

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
			
		<div class="post" id="post-<mango:PostProperty id />">
			<h2 class="posttitle"><a href="<mango:PostProperty link />" rel="bookmark" title="Permanent link to <mango:PostProperty title />"><mango:PostProperty title /></a></h2>
			
			<p class="postmeta"><mango:PostProperty date dateformat="mmmm dd, yyyy" />
					 &#183; Filed under 
					 <mango:Categories><mango:Category><a href="<mango:CategoryProperty link />" title="View all posts in <mango:CategoryProperty title />"> <mango:CategoryProperty title /></a><mango:Category ifCurrentIsNotLast> | </mango:Category></mango:Category></mango:Categories>
			</p>
		
			<div class="postentry">
				<mango:PostProperty body />
			</div>
				
			&nbsp;
			<!-- del.icio.us -->
			<span class="delicious">
				<a href="http://del.icio.us/post" onclick="window.open('http://del.icio.us/post?v=4&amp;noui&amp;jump=close&amp;url='+encodeURIComponent(location.href)+'&amp;title='+encodeURIComponent(document.title), 'delicious','toolbar=no,width=700,height=400'); return false;"> <strong>del.icio.us this!</strong></a>
			</span>
		</div>

<mango:PostProperty ifcommentsallowed>
<h2 id="comments">
	<mango:PostProperty ifCommentCountLT="1">No</mango:PostProperty><mango:PostProperty ifCommentCountGT="0" commentCount /> Response<mango:PostProperty ifCommentCountGT="1">s</mango:PostProperty> so far <a href="#postcomment" title="Jump to the comments form">&raquo;</a></h2>

<ol id="commentlist" class="commentlist">

	<!-- A different style if comment author is blog owner -->
<mango:Comments>
	<mango:Comment>
	<li class="<mango:CommentProperty ifIsAuthor>adminreply</mango:CommentProperty> item" id="comment-<mango:CommentProperty id />">
		<!-- Comment Counter -->
		<div class="commentcounter"><mango:CommentProperty currentCount /></div>
		<div class="commentgravatar"><mangox:Gravatar size="40" defaultimg="assets/images/gravatar.jpg" class="gravatar" /></div>
		<!-- Gravatar -->
		<h3 class="commenttitle"><mango:CommentProperty ifhasurl><a href="<mango:CommentProperty url />" rel='external nofollow'></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a> said,</h3>
		
		<p class="commentmeta">
			<a href="#comment-<mango:CommentProperty id />"><mango:CommentProperty date dateformat="mmm d, yyyy" /> @ <mango:CommentProperty time /></a>
		</p>
		
		<p><mango:CommentProperty content /></p>
		
	</li>
</mango:Comment>
</mango:Comments>
</ol>

<h2 id="postcomment">Say your words</h2>
<a name="commentForm"></a>
	<form action="#commentForm" method="post"  name="comments_form">
		<input type="hidden" name="action" value="addComment" />
		<input type="hidden" name="comment_post_id" value="<mango:PostProperty id />" />
		<input type="hidden" name="comment_parent" value="" />
		<mango:Message ifMessageExists type="comment" status="error">
			<p class="error">There was a problem: <br /><mango:Message text /></p>
		</mango:Message>
		<mango:Message ifMessageExists type="comment" status="success">
			<p class="message"><mango:Message text /></p>
		</mango:Message>
		<p>
		<input type="text" name="comment_name" id="author" value="<mango:RequestVar name="comment_name" />" tabindex="1" />
		<label for="author">&nbsp;Name (required)</label>
		</p>
		<p>
		<input type="text" name="comment_email" id="email" value="<mango:RequestVar name="comment_email" />" tabindex="2" />
		<label for="email">&nbsp;E-mail (required, hidden to public)</label>
		</p>
		<p>
		<input type="text" name="comment_website" id="url" value="<mango:RequestVar name="comment_website" />" tabindex="3" />
		<label for="url">&nbsp;<abbr title="Uniform Resource Identifier">URI</abbr> (your blog or website)</label>
		</p>
		<p>
		<textarea name="comment_content" id="comment" cols="" rows="" tabindex="4"><mango:RequestVar name="comment_content" /></textarea>
		</p>
		<p>					
			<input type="checkbox" id="subscribe" name="comment_subscribe" value="1" /> <label for="subscribe">Subscribe to this comment thread</label>
		</p>
				
		<mango:Event name="beforeCommentFormEnd" />
		<p>
			<input name="submit" type="submit" id="submit" class="button" tabindex="5" value="Submit Comment" />
		</p>
		</form>
</mango:PostProperty>
<mango:PostProperty ifNotcommentsallowed  ifCommentCountGT="0">
<h2 id="comments">
	<mango:PostProperty ifCommentCountGT="0" commentCount /> Response<mango:PostProperty ifCommentCountGT="1">s</mango:PostProperty></h2>
	
	<ol id="commentlist" class="commentlist">

	<!-- A different style if comment author is blog owner -->
<mango:Comments>
	<mango:Comment>
	<li class="<mango:CommentProperty ifIsAuthor>adminreply</mango:CommentProperty> item" id="comment-<mango:CommentProperty id />">
		<!-- Comment Counter -->
		<div class="commentcounter"><mango:CommentProperty currentCount /></div>
		<div class="commentgravatar"><mangox:Gravatar size="40" defaultimg="assets/images/gravatar.jpg" class="gravatar" /></div>
		<!-- Gravatar -->
		<h3 class="commenttitle"><mango:CommentProperty ifhasurl><a href="<mango:CommentProperty url />" rel='external nofollow'></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a> said,</h3>
		
		<p class="commentmeta">
			<a href="#comment-<mango:CommentProperty id />"><mango:CommentProperty date dateformat="mmm d, yyyy" /> @ <mango:CommentProperty time /></a>
		</p>
		
		<p><mango:CommentProperty content /></p>
		
	</li>
</mango:Comment>
</mango:Comments>
</ol>
</mango:PostProperty>
		
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
</mango:Post>
</body>
</html>