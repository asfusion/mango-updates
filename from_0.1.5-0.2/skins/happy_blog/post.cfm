<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<mango:Post>
<head>
	<title><mango:PostProperty title /> | <mango:Blog title /></title>
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
			<mango:Author>
			<h3>About <mango:AuthorProperty name /></h3>
			<p><mango:AuthorProperty shortdescription descriptionParagraphFormat /><br /><a href="<mango:AuthorProperty link />">More ...</a></p>
			</mango:Author>
			
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
		
	<div id="srednja_kolona">
		<div class="srednji_clanak">
			<div class="clanak">
				 <h3><mango:PostProperty title /></h3>
				<mango:PostProperty body>
				<div class="read_more"><p>Posted on: <mango:PostProperty date dateformat="medium" /></p></div>
				 <p><mango:PostProperty ifcommentsallowed><a href="#comments">
				 <mango:PostProperty commentCount /> comments</a> - Categories: </mango:PostProperty>
				<mango:Categories><mango:Category>
					<a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty description />"> <mango:CategoryProperty title /></a><mango:Category ifCurrentIsNotLast> | </mango:Category></mango:Category></mango:Categories>
				</p>
			</div>
		</div>
		
		
		
		<a name="comments"></a>
		<mango:PostProperty ifcommentsallowed>
			<div class="srednji_clanak">
			<div class="clanak"><h3>Comments</h3></div></div>
			
			<mango:Comments>
				<mango:Comment>
				<div class="srednji_clanak">
			<div class="<mango:CommentProperty ifNotIsAuthor>clanak</mango:CommentProperty><mango:CommentProperty ifIsAuthor>highlighted</mango:CommentProperty>">
				<a name="comment-<mango:CommentProperty id />"></a>
				<div class="commentblock">
					<a <mango:CommentProperty ifhasurl>href="<mango:CommentProperty url />"</mango:CommentProperty> class="thumb">
				<mangox:Gravatar size="40" defaultimg="assets/images/nogravatar.png" class="floatLeft" /></a>
				
				<p><mango:CommentProperty ifhasurl><a href="<mango:CommentProperty url />"></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a></mango:CommentProperty> wrote on <a href="#comment-<mango:CommentProperty id />"><mango:CommentProperty date dateformat="mm/dd/yy" /> <mango:CommentProperty time /></a></p>
	            <mango:CommentProperty content />  
	            
	            </div></div>
	             </div>
				</mango:Comment>
			
			</mango:Comments>
			
			<div class="srednji_clanak">
			<div class="clanak">
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
					<textarea id="comment-text" name="comment_content" rows="10" cols="40"><mango:RequestVar name="comment_content" /></textarea>
				</p>
				<p>					
					<input type="checkbox" id="subscribe" name="comment_subscribe" value="1" /> <label for="subscribe">Subscribe to this comment thread</label>
				</p>
				
				<mango:Event name="beforeCommentFormEnd" />
				<p><input type="submit" accesskey="s" name="submit_comment" id="comment-post" value="Post comment" class="button" />	</p>
			
           </form>
			</div>
			</div>
		</mango:PostProperty>
		
		
		<mango:PostProperty ifNotcommentsallowed  ifCommentCountGT="0">
		<div class="srednji_clanak">
			<div class="clanak"><h3>Comments</h3></div></div>
			
			<mango:Comments>
				<mango:Comment>
				<div class="srednji_clanak">
			<div class="<mango:CommentProperty ifNotIsAuthor>clanak</mango:CommentProperty><mango:CommentProperty ifIsAuthor>highlighted</mango:CommentProperty>">
				<a name="comment-<mango:CommentProperty id />"></a>
				<div class="commentblock">
					<a <mango:CommentProperty ifhasurl>href="<mango:CommentProperty url />"</mango:CommentProperty> class="thumb">
				<mangox:Gravatar size="40" defaultimg="assets/images/nogravatar.png" class="floatLeft" /></a>
				
				<p><mango:CommentProperty ifhasurl><a href="<mango:CommentProperty url />"></mango:CommentProperty><mango:CommentProperty name /><mango:CommentProperty ifhasurl></a></mango:CommentProperty> wrote on <a href="#comment-<mango:CommentProperty id />"><mango:CommentProperty date dateformat="mm/dd/yy" /> <mango:CommentProperty time /></a></p>
	            <mango:CommentProperty content />  
	            
	            </div></div>
	             </div>
				</mango:Comment>
			
			</mango:Comments>
		</mango:PostProperty>
		
		</div></div>
	</div>
</div>
</mango:Post>
<mango:Event name="beforeHtmlBodyEnd" />
</body>
</html>