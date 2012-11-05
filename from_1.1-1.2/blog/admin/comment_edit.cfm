<cfsilent>
	<cfparam name="error" default="">
	<cfparam name="message" default="">
	<cfparam name="id" default="" />
	<cfparam name="found" default="false" />
	
	<cfif structkeyexists(form,"submit")>
		<cfset result = request.formHandler.handleEditComment(form) />
		<cfif result.message.getStatus() EQ "success">
			<cfset message = result.message.getText() />
		<cfelse>
			<cfset error = result.message.getText() />
		</cfif>
	</cfif>

	<!--- get post by id --->
	<cfif NOT len(error)>
	<cftry>
		<cfset comment = request.administrator.getComment(id) />
		<cfset content = comment.getContent() />
		<cfset email = comment.getCreatorEmail() />
		<cfset name = comment.getCreatorName() />
		<cfset website = comment.getCreatorUrl() />
		<cfset approved = comment.getApproved() />
		<cfset createdOn = dateformat(comment.getCreatedOn(),'short') & " " & timeformat(comment.getCreatedOn(),'medium') />
		<cftry>
			<cfset post = request.administrator.getPost(comment.getEntryId()) />
			<cfcatch type="any">
				<cfset post = request.administrator.getPage(comment.getEntryId()) />
			</cfcatch>
		</cftry>
		<cfset found = true />
	<cfcatch type="any">
		<cfset error = cfcatch.message />
	</cfcatch>
	</cftry>
	
	</cfif>
</cfsilent>
<cf_layout page="Comments">

<div id="wrapper">
	
	<div id="content">
	<cfif found>
	<cfoutput><h2 class="pageTitle">Comment for entry 
			<a href="#request.blogManager.getBlog().geturl()##post.getUrl()#">#post.getTitle()#</a></h2></cfoutput>
	</cfif>
		<div id="innercontent">
		<cfif len(error)>
			<p class="error"><cfoutput>#error#</cfoutput></p>
		</cfif>
		<cfif len(message)>
			<p class="message"><cfoutput>#message#</cfoutput></p>
		</cfif>
		<cfoutput>
	<cfif found>
		<form method="post" action="comment_edit.cfm">
			<span class="oneField">
				<label for="wf_Name" class="preField">Name</label>
				<input type="text" id="wf_Name" name="creatorName" value="#name#" size="30" class="required"><span class="reqMark">*</span><br></span>
			<span class="oneField">
				<label for="wf_Email" class="preField">Email</label>
				<input type="text" id="wf_Email" name="creatorEmail" value="#email#" size="30" class="validate-email required"><span class="reqMark">*</span><br></span>
				<span class="oneField">
					<label for="wf_Website" class="preField">Website</label><input type="text" id="wf_Website" name="creatorUrl" value="#website#" size="30" class=""><br></span>
				<span class="oneField">
					<label for="wf_Comment" class="preField">Comment</label><textarea cols="60" rows="20" id="wf_Comment" name="content" class="required">#content#</textarea><span class="reqMark">*</span><br></span>
				
      <span class="oneChoice">
        <input type="checkbox" value="yes" id="approved" name="approved" <cfif approved>checked="checked"</cfif>/>
        <label for="approved" id="approved-L" class="postField">Approved?</label>
      </span>
      <br/>	
				
				<input type="hidden" name="commentId" value="#id#">
				<input type="hidden" name="id" value="#id#">
				
				<div class="actions">
					<a href="comments.cfm?action=delete&amp;id=#id#&amp;entry_id=#post.getId()#" class="deleteButton">Delete</a>
<a href="comments.cfm?entry_id=#post.getId()#">Back to comments</a>
<input type="submit" class="primaryAction" id="submit" name="submit" value="Submit">
</div>

</form>
</cfif>

		</cfoutput>
		
		</div>
	</div>
</div>

</cf_layout>