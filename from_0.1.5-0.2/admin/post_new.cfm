<cfsilent>
	<cfparam name="id" default="0" />		
	<cfparam name="title" default="" />
	<cfparam name="content" default="" />
	<cfparam name="excerpt" default="" />
	<cfparam name="postedOn" default="#dateformat(now(),'mm/dd/yy')# #timeformat(now(),'medium')#" />
	<cfparam name="error" default="" />
	<cfparam name="message" default="" />
	<cfparam name="allowComments" default="true" />
	<cfparam name="publish" default="published" />
	
	<!--- get categories --->
	<cfset categories = request.administrator.getCategories() />
	
	<cfif structkeyexists(form,"submit")>
		<cfset result = request.formHandler.handleAddPost(form) />
		<cfif result.message.getStatus() EQ "success">
			<cfset message = result.message.getText() />
			<cfset id = "" />
			<cfset title = "" />
			<cfset content = "" />
			<cfset excerpt = "" />
			<cfset allowComments = true />
			<cfset publish = "published" />
			<cfset postedOn =  "#dateformat(now(),'mm/dd/yy')# #timeformat(now(),'medium')#">
		<cfelse>
			<cfset error = result.message.getText() />
		</cfif>
	</cfif>
	
</cfsilent>
<cf_layout page="Posts">
<div id="wrapper">
	<div id="submenucontainer">
		<ul id="submenu">
			<li><a href="post_new.cfm" class="current">New</a></li>	
			<li><a href="posts.cfm" >Edit</a></li>
		</ul>
	</div>
	
	<div id="content">
		<h2 class="pageTitle">New post</h2>
		
		<div id="innercontent">
		<cfif len(error)>
			<p class="error"><cfoutput>#error#</cfoutput></p>
		</cfif>
		<cfif len(message)>
			<p class="message"><cfoutput>#message#</cfoutput></p>
		</cfif>
		
		<cfoutput><form method="post" action="post_new.cfm" name="wf_Newpost" id="wf_Newpost">
  <div class="widget">
    <fieldset id="wf_Post" class="">
      <legend>Post</legend>
      <label for="wf_Title" id="wf_Title-L" class="preField">Title
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Title" name="title" value="#title#" size="50" class="none required"/>
      <br/>
      <label for="contentField" id="content-L" class="preField">Content
						 <span class="reqMark">*</span></label>
      <textarea cols="50" rows="20" id="contentField" name="content" class="none required"  style="width: 100%">#htmleditformat(content)#</textarea>
      <br/>
      <div class="field-hint-inactive" id="wf_Excerpt1-H">
        <div>Short summary describing post</div>
      </div><br />
      <label for="wf_Excerpt1" id="wf_Excerpt1-L" class="preField">Excerpt</label>
      <textarea cols="50" rows="5" id="wf_Excerpt1" name="excerpt" class="none" style="width: 100%">#htmleditformat(excerpt)#</textarea>
      <br/>
      <div class="field-hint-inactive" id="wf_Allowcomments2-H">
        <div>Whether or not reader comments are permitted for this post</div>
      </div>
      <span class="label preField">Allow comments?</span>
      <span class="oneChoice">
        <input type="checkbox" value="yes" id="allowComments" name="allowComments" <cfif allowComments>checked="checked"</cfif>/>
        <label for="allowComments" id="allowComments-L" class="postField"></label>
      </span>
      <br/>
    </fieldset>
    <fieldset id="wf_Categories2" class="">
      <legend>Categories</legend>
      <div class="instructions">File under these categories:</div>
	 <span class="oneField">
      <span class="required">
		
		<cfloop from="1" to="#arraylen(categories)#" index="i">
			<span class="oneChoice">
          <input type="checkbox" value="#categories[i].getId()#" id="category_#i#" name="category"/>
          <label for="category_#i#" id="categorylabel_#i#" class="postField">#categories[i].getTitle()#</label><br />
			</span>
		</cfloop>
		
		</span>
      </span>
      <br/>
    </fieldset>
    <fieldset id="wf_Publishstatus" class="">
      <legend>Publish status</legend>
      <span class="required">
        <span class="oneChoice">
          <input type="radio" value="published" id="wf_Published" name="publish" <cfif publish EQ "published">checked="checked"</cfif>/>
          <label for="wf_Published" id="wf_Published-L" class="postField">Published</label>
        </span>
        <span class="oneChoice">
          <input type="radio" value="draft" id="wf_Draft" name="publish" <cfif publish EQ "draft">checked="checked"</cfif>/>
          <label for="wf_Draft" id="wf_Draft-L" class="postField">Draft</label>
        </span>
      </span>
      <br/>
      <label for="postedOn" id="postedOn-L" class="preField">Publishing date</label>
      <input type="text" id="postedOn" name="postedOn" value="#postedOn#" size="20" class="validate-date"/>
      <br/>
    </fieldset>
    <div class="actions">
      <input type="submit" class="primaryAction" id="tfa_submit" name="submit" value="submit"/>
    </div>
  </div>

</form></cfoutput>

		
		</div>
	</div>
</div>

</cf_layout>