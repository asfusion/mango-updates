<cfsilent>
	<cfimport prefix="mangoAdmin" taglib="tags">
	<cfparam name="error" default="">
	<cfparam name="message" default="">
	<cfparam name="entry_id" default="" />
	
	<cfif structkeyexists(url,"action") AND url.action EQ "delete">
		<cfset result = request.formHandler.handleDeleteComment(url) />
		<cfif result.message.getStatus() EQ "success">
			<cfset message = result.message.getText() />
		<cfelse>
			<cfset error = result.message.getText() />
		</cfif>
	</cfif>
	
	<cfif structkeyexists(form,"submit")>
		<cfset result = request.formHandler.handleAddComment(form) />
		<cfif result.message.getStatus() EQ "success">
			<cfset message = result.message.getText() />
		<cfelse>
			<cfset error = result.message.getText() />
		</cfif>
	</cfif>

	<cfset comments = request.administrator.getPostComments(entry_id) />
	<cftry>
		<cfset post = request.administrator.getPost(entry_id) />
		<cfcatch type="any">
			<cftry>
				<cfset post = request.administrator.getPage(entry_id) />
				
				<cfcatch type="any">
					<cfset error = cfcatch.message/>
				</cfcatch>
			</cftry>
		</cfcatch>
	</cftry>
	
	<cfscript>
/**
 * Returns a XHTML compliant string wrapped with properly formatted paragraph tags.
 * 
 * @param string 	 String you want XHTML formatted. 
 * @param attributeString 	 Optional attributes to assign to all opening paragraph tags (i.e. style=""font-family: tahoma""). 
 * @return Returns a string. 
 * @author Jeff Howden (&#106;&#101;&#102;&#102;&#64;&#109;&#101;&#109;&#98;&#101;&#114;&#115;&#46;&#101;&#118;&#111;&#108;&#116;&#46;&#111;&#114;&#103;) 
 * @version 1.1, January 10, 2002 
 */
function XHTMLParagraphFormat(string)
{
  var attributeString = '';
  var returnValue = '';
  if(ArrayLen(arguments) GTE 2) attributeString = ' ' & arguments[2];
  if(Len(Trim(string)))
    returnValue = '<p' & attributeString & '>' & Replace(string, Chr(13) & Chr(10), '</p>' & Chr(13) & Chr(10) & '<p' & attributeString & '>', 'ALL') & '</p>';
  return returnValue;
}
</cfscript>
</cfsilent>
<cf_layout page="Comments">

<div id="wrapper">
	
	<div id="content">
		<cfoutput><h2 class="pageTitle">Comments for post "#post.getTitle()#"</h2></cfoutput>	
		
		<div id="innercontent">
		<cfif len(error)>
			<p class="error"><cfoutput>#error#</cfoutput></p>
		</cfif>
		<cfif len(message)>
			<p class="message"><cfoutput>#message#</cfoutput></p>
		</cfif>
		<cfoutput>
		
		<cfif NOT arraylen(comments)><p>No comments</p></cfif>
		<cfloop from="1" to="#arraylen(comments)#" index="i">
			<div<cfif NOT comments[i].getApproved() AND comments[i].getRating() EQ -1> class="spam"<cfelseif NOT i mod 2> class="alternate"</cfif>><a name="#comments[i].getId()#"></a>
			<p><strong>Name:</strong> #comments[i].getCreatorName()# | <strong>E-mail:</strong> <a href='#comments[i].getCreatorEmail()#'>#comments[i].getCreatorEmail()#</a> | <strong>Website:</strong> <a href="#comments[i].getCreatorUrl()#">#comments[i].getCreatorUrl()#</a></p>
	
		#XHTMLParagraphFormat(comments[i].getContent())#

        <p>Posted #dateformat(comments[i].getCreatedOn(),"medium")# #timeformat(comments[i].getCreatedOn(),"short")# | <a href="comment_edit.cfm?id=#comments[i].getId()#">Edit</a> | <a href="#cgi.script_name#?action=delete&amp;id=#comments[i].getId()#&amp;entry_id=#entry_id#" class="deleteButton">Delete</a></p>
</div>
		</cfloop>
	
	<h2>Add a comment</h2>
	<form method="post" action="comments.cfm">
		<span class="oneField">
			<label for="wf_Comment" class="preField">Comment</label><textarea cols="60" rows="20" id="wf_Comment" name="content" class="required"></textarea><span class="reqMark">*</span><br></span>
		<span class="oneField">
					<label for="wf_Website" class="preField">Website</label><input type="text" id="wf_Website" name="creatorUrl" value="" size="30" class=""><br></span>
							
		<input type="hidden" name="entry_id" value="#entry_id#">
				
		<div class="actions">
			<input type="submit" class="primaryAction" id="submit" name="submit" value="Submit">
		</div>
	</form>
		</cfoutput>
		
		</div>
	</div>
</div>

</cf_layout>