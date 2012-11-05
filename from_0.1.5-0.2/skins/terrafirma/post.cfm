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
<mango:Post>
<title><mango:PostProperty title /> | <mango:Blog title /></title>
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

		<div id="date"><mango:PostProperty date dateformat="mmm dd, yyyy" /></div>
		</div>
	

		<div id="primarycontent">
		
			<!-- primary content start -->
			<div class="post">
				<div class="header">
					<h3><mango:PostProperty title /></h3>
					<div class="date"><mango:PostProperty date dateformat="mmm dd, yyyy" /></div>
				</div>
				<div class="content">
					<mango:PostProperty body />
					<p></p>
				</div>			
				<div class="footer">
					<ul>
						<mango:PostProperty ifcommentsallowed>
						<li class="comments"><a href="<mango:PostProperty link />#comments">Comments (<mango:PostProperty commentCount />)</a></li></mango:PostProperty>
					</ul>
				</div>
			</div>
			
		<a name="comments"></a>
		<mango:PostProperty ifcommentsallowed>
			<!-- Comments -->
			<h3>Comments</h3>
			
			<mango:Comments>
				<mango:Comment><a name="comment-<mango:CommentProperty id />"></a>
	
				<div class="commentblock<mango:CommentProperty ifIsAuthor> highlighted</mango:CommentProperty>">
					<a <mango:CommentProperty ifhasurl>href="<mango:CommentProperty url />"</mango:CommentProperty> class="thumb">
				<mangox:Gravatar size="40" defaultimg="assets/images/nogravatar.png" class="floatleft" /></a>
				
				<p><mango:CommentProperty ifhasurl><a href="<mango:CommentProperty url />"></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a></mango:CommentProperty> wrote on <a href="#comment-<mango:CommentProperty id />"><mango:CommentProperty date dateformat="mm/dd/yy" /> <mango:CommentProperty time /></a></p>
	            <mango:CommentProperty content />   
				</mango:Comment>
			</div>
 			<div class="clear"></div>
			</mango:Comments>
			
			
			<a name="commentForm"></a>
			<form method="post" action="#commentForm" name="comments_form">
				<input type="hidden" name="action" value="addComment" />
				<input type="hidden" name="comment_post_id" value="<mango:PostProperty id />" />
				<input type="hidden" name="comment_parent" value="" />
				<h3>Write your comment</h3>
                <mango:Message ifMessageExists type="comment" status="error">
					<p class="error dark">There was a problem: <mango:Message text /></p>
				</mango:Message>
				<mango:Message ifMessageExists type="comment" status="success">
					<p class="message dark"><mango:Message text /></p>
				</mango:Message>
				 <p>
					<label for="comment-author">Name</label><br />
                    <input id="comment-author" name="comment_name" size="30" value="<mango:RequestVar name="comment_name" />"  />
				</p>
				<p>
					<label for="comment-email">Email Address </label><br />
					<input id="comment-email" name="comment_email" size="30" value="<mango:RequestVar name="comment_email" />" /> (it will not be displayed)
				</p>
				<p>
					<label for="comment-url">Website</label><br />
					<input id="comment-url" name="comment_website" size="30" value="<mango:RequestVar name="comment_website" />" />
				</p>
				<p>
					<label for="comment-text">Your Comments</label><br />
					<textarea id="comment-text" name="comment_content" rows="10" cols="50"><mango:RequestVar name="comment_content" /></textarea>
				</p>
				<p>					
					<input type="checkbox" id="subscribe" name="comment_subscribe" value="1" /> <label for="subscribe">Subscribe to this comment thread</label>
				</p>
				
				<mango:Event name="beforeCommentFormEnd" />
				<p><input type="submit" accesskey="s" name="submit_comment" id="comment-post" value="Post comment" class="button" />	</p>
			
           </form>
			
		</mango:PostProperty>
		<mango:PostProperty ifNotcommentsallowed  ifCommentCountGT="0">
		<!--- even though comments are not allowed, there might be old comments --->
		<!-- Comments -->
			<h3>Comments</h3>
			
			<mango:Comments>
				<mango:Comment><a name="comment-<mango:CommentProperty id />"></a>
	
				<div class="commentblock<mango:CommentProperty ifIsAuthor> highlighted</mango:CommentProperty>">
					<a <mango:CommentProperty ifhasurl>href="<mango:CommentProperty url />"</mango:CommentProperty> class="thumb">
				<mangox:Gravatar size="40" defaultimg="assets/images/nogravatar.png" class="floatleft" /></a>
				
				<p><mango:CommentProperty ifhasurl><a href="<mango:CommentProperty url />"></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a></mango:CommentProperty> wrote on <a href="#comment-<mango:CommentProperty id />"><mango:CommentProperty date dateformat="mm/dd/yy" /> <mango:CommentProperty time /></a></p>
	            <mango:CommentProperty content />   
				</mango:Comment>
			</div>
 			<div class="clear"></div>
			</mango:Comments>
		
		</mango:PostProperty>
			<!-- primary content end -->
	
		</div>

		<div id="secondarycontent">
		<mango:Event name="afterSideBarStart" number="1" />
			<!-- secondary content start -->
			<mango:Author>
			<h3>About <mango:AuthorProperty name /></h3>		
			<div class="content">
				<p><mango:AuthorProperty shortdescription descriptionParagraphFormat />
				<a href="<mango:AuthorProperty link />">More ...</a></p>
			</div>
			</mango:Author>
</mango:Post>
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
</body>
</html>
