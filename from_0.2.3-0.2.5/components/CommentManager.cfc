<cfcomponent name="CommentManager">

	<cfset variables.accessObject = "">

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainApp" required="true" type="any">
		<cfargument name="accessObject" required="true" type="any">
		<cfargument name="pluginQueue" required="true" type="PluginQueue">
			
			<cfset variables.factory = arguments.accessObject />
			<cfset variables.accessObject = arguments.accessObject.getCommentsGateway()>
			<cfset variables.daoObject = arguments.accessObject.getCommentsManager()>
			<cfset variables.pluginQueue = arguments.pluginQueue />
			
			<cfset variables.mainApp = arguments.mainApp />
			
			<cfreturn this />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getComments" access="public" output="false" returntype="array">
		<cfargument name="adminMode" required="false" default="false" type="boolean" hint="Whether to include non-approved comments"/>
		
		<cfset var postsQuery = variables.accessObject.getAll(arguments.adminMode) />
		<cfset var posts = packageObjects(postsQuery,NOT arguments.adminMode) />		
		
		<cfreturn posts />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<!--- 	getByPost --->	
	<cffunction name="getCommentsByPost" access="public" output="false" returntype="array">
			<cfargument name="entry_id" required="true" type="string" hint="Entry ID"/>
			<cfargument name="adminMode" required="false" default="false" type="boolean" hint="Whether to include non-approved comments"/>
		
		<cfset var commentsQuery = variables.accessObject.getByPost(arguments.entry_id,arguments.adminMode) />
		<cfreturn packageObjects(commentsQuery,NOT arguments.adminMode) />		

	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getCommentById" access="public" output="false" returntype="any">
		<cfargument name="id" required="true" type="string" hint="Id"/>
		<cfargument name="adminMode" required="false" default="false" type="boolean" hint="Whether to include non-approved comments"/>
		
		<cfset var commentsQuery = variables.accessObject.getByID(arguments.id, arguments.adminMode) />
		<cfset var comments = packageObjects(commentsQuery,NOT arguments.adminMode) />
		<cfif NOT commentsQuery.recordcount>
			<cfthrow errorcode="CommentNotFound" message="Comment was not found" type="CommentNotFound">
		</cfif>
		<cfreturn comments[1] />		
		
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="packageObjects" access="private" output="false" returntype="array">
		<cfargument name="objectsQuery" required="true" type="query">
		<cfargument name="useWrapper" required="false" default="true" type="boolean" hint="Whether to use wrapper"/>
		
		<cfset var comments = arraynew(1) />
		<cfset var thisObject = "" />
		<cfset var wrapper = "" />
		<cfset var factory =  createObject("component","ObjectFactory") />

		<cfoutput query="arguments.objectsQuery">
			<cfset thisObject = factory.createComment() />
			<cfset thisObject.init(id, entry_id, content, creator_name, creator_email, creator_url, created_on, approved, author_id, parent_comment_id) />
			
			<cfif arguments.useWrapper>
				<cfset wrapper =  createObject("component","CommentWrapper").init(variables.pluginQueue, thisObject) />
				<cfset arrayappend(comments,wrapper) />
			<cfelse>
				<cfset arrayappend(comments,thisObject) />
			</cfif>

		</cfoutput>
		
		<cfreturn comments />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="createEmptyComment" access="public" output="false" returntype="any">
		<cfargument name="adminMode" required="false" default="false" type="boolean" hint="Whether to include non-approved comments"/>
		
		<cfset var commentsQuery = querynew("id,entry_id,content,creator_name,creator_email,creator_url,created_on,approved,author_id,parent_comment_id") />
		<cfset var package = "" />
		<cfset queryaddrow(commentsQuery,1) />
		<cfset querysetcell(commentsQuery,"created_on",now()) />
		<cfset package = packageObjects(commentsQuery,NOT arguments.adminMode) />
		<cfreturn package[1] />		

	</cffunction>	
	

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<!--- adding a new comment --->
	<cffunction name="addCommentFromRawData" access="public" output="false" returntype="struct">
		<cfargument name="commentData" required="true" type="struct">
			
			<cfscript>
				var thisObject = "";
				var authorGateway = variables.factory.getAuthorsGateway();
				var authorId = "";
				var valid = "";
				var event = "";
				var newComment = "";
				var newCommentResult = "";
				var message = createObject("component","Message");
				var status = "";
				var returnObj = structnew();
				var msgText = "";
				var eventObj = structnew();
				var data = structnew();
				
				//get author by email address
				if (len(commentData.comment_email)){
					authorId = authorGateway.getIdByEmail(commentData.comment_email);
				}
				
				message.setType("comment");

				thisObject = createObject("component","model.Comment");
				thisObject.setEntryId(trim(arguments.commentData.comment_post_id));
				thisObject.setContent(trim(arguments.commentData.comment_content));
				thisObject.setCreatorName(trim(arguments.commentData.comment_name));
				thisObject.setCreatorEmail(trim(arguments.commentData.comment_email));
				if (len(arguments.commentData.comment_website) AND NOT findnocase("http://",arguments.commentData.comment_website))
					thisObject.setCreatorUrl("http://" & arguments.commentData.comment_website);
				else
					thisObject.setCreatorUrl(arguments.commentData.comment_website);
				
				if (NOT structkeyexists(arguments.commentData,"comment_created_on")){
					thisObject.setCreatedOn(now());
				}
				else{
					thisObject.setCreatedOn(arguments.commentData.comment_created_on);
				}
				
				thisObject.setApproved(true);
				
				thisObject.setAuthorId(authorId);
				if(structkeyexists(arguments.commentData,"comment_parent")){
					thisObject.setParentCommentId(arguments.commentData.comment_parent);
				}
							
				//call plugins
				
				
				eventObj.comment = thisObject;
				eventObj.rawdata = arguments.commentData;
				eventObj.newItem = thisObject;
				//eventObj.changeByUser = arguments.user;
				
				valid = thisObject.isValidForSave();	
				
				if(valid.status){
					event = variables.pluginQueue.createEvent("beforeCommentAdd",eventObj,"Update");
					event.setMessage(message);
					event = variables.pluginQueue.broadcastEvent(event);
			
					thisObject = event.getData().comment;
					valid = thisObject.isValidForSave();
					
					if(event.getContinueProcess() AND valid.status){
					
						newCommentResult = variables.daoObject.create(thisObject);					
							
						if(newCommentResult.status){
							status = "success";
							event = variables.pluginQueue.createEvent("afterCommentAdd",eventObj,"Update");
							event = variables.pluginQueue.broadcastEvent(event);
							thisObject = event.getNewItem();
							//clean up variables
							data.comment_content = "";
							data.comment_email = "";
							data.comment_website = "";
							data.comment_name = "";
							// @TODO: finish this list
								
							if (thisObject.getApproved())
								message.setText('Comment posted');
							else if (thisObject.getRating() EQ -1){
								message.setText('Comment submitted but it will be reviewed for possible spam.');
							}
							else {
								message.setText('Comment submitted. You need to wait for moderator approval before comment is made public');
							}
								
						}
						else{
							status = "error";
							message.setText(newCommentResult.message);
						}
						message.setStatus(status);						
					}					
				}
				
				if (NOT valid.status) {
					for (i = 1; i LTE arraylen(valid.errors);i=i+1){
						msgText = msgText & "<br />" & valid.errors[i];
					}
					message.setStatus("error");
					message.setText(msgText);
				}
			</cfscript>
		<cfset returnObj.data = data />	
		<cfset returnObj.newComment = thisObject />
		<cfset returnObj.message = message />

		<cfreturn returnObj />
	</cffunction>
	
<cffunction name="addComment" access="package" output="false" returntype="struct">
		<cfargument name="comment" required="true" type="any">
		<cfargument name="rawData" required="true" type="struct">
		<cfargument name="user" required="false" type="any" default="#structnew()#">
			
			<cfscript>
				var thisObject = arguments.comment;
				var authorGateway = variables.factory.getAuthorsGateway();
				var valid = "";
				var event = "";
				var newResult = "";
				var authorId = "";
				var message = createObject("component","Message");
				var status = "";
				var returnObj = structnew();
				var msgText = "";
				var eventObj = structnew();
				var data = structnew();
				
				message.setType("comment");
				
				//call plugins
				thisObject.setCreatedOn(now());
				eventObj.comment = thisObject;
				eventObj.rawdata = arguments.rawData;
				eventObj.newItem = thisObject;
				eventObj.changeByUser = arguments.user;
				if (len(thisObject.getCreatorEmail())){
					authorId = authorGateway.getIdByEmail(thisObject.getCreatorEmail());
				}
				thisObject.setAuthorId(authorId);
						
				valid = thisObject.isValidForSave();
				
				if(valid.status){
					event = variables.pluginQueue.createEvent("beforeCommentAdd",eventObj,"Update");
					event = variables.pluginQueue.broadcastEvent(event);
			
					thisObject = event.getNewItem();
					valid = thisObject.isValidForSave();
					
					if(event.getContinueProcess() AND valid.status){//plugins must have continue and still valid
								
						newResult = variables.daoObject.create(thisObject);
							
						if(newResult.status){
							status = "success";
							event = variables.pluginQueue.createEvent("afterCommentAdd",eventObj,"Update");
							event = variables.pluginQueue.broadcastEvent(event);
							thisObject = event.getNewItem();
							// @TODO: finish this list
						
							if (thisObject.getApproved())
								message.setText('Comment submitted');
							else if (thisObject.getRating() EQ -1){
								message.setText('Comment submitted but it will be moderated for possible spam.');
							}
							else {
								message.setText('Comment submitted. You need to wait for moderator approval before comment is made public');
							}
						}
						else{
							status = "error";
							message.setText(newResult.message);
						}						
						message.setStatus(status);
					}				
				}
				
				//not valid
				if (NOT valid.status) {
					for (i = 1; i LTE arraylen(valid.errors);i=i+1){
						msgText = msgText & "<br />" & valid.errors[i];
					}
					message.setStatus("error");
					message.setText(msgText);
				}
			</cfscript>
		<cfset returnObj.data = rawData />	
		<cfset returnObj.newComment = thisObject />
		<cfset returnObj.message = message />

		<cfreturn returnObj />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
<cffunction name="editComment" access="package" output="false" returntype="struct">
		<cfargument name="comment" required="true" type="any">
		<cfargument name="rawData" required="true" type="struct">
		<cfargument name="user" required="false" type="any">
			
			<cfscript>
				var thisObject = arguments.comment;
				var valid = "";
				var event = "";
				var newResult = "";
				var authorGateway = variables.factory.getAuthorsGateway();
				var message = createObject("component","Message");
				var status = "";
				var returnObj = structnew();
				var msgText = "";
				var eventObj = structnew();
				var data = structnew();
				var authorId = "";
				
				message.setType("comment");
				
				//call plugins
				eventObj.rawdata = arguments.rawData;
				eventObj.newItem = arguments.comment;
				eventObj.oldItem = getCommentById(arguments.comment.getId(),true);
				eventObj.changeByUser = arguments.user;
				
				if (len(thisObject.getCreatorEmail())){
					authorId = authorGateway.getIdByEmail(thisObject.getCreatorEmail());
				}
				thisObject.setAuthorId(authorId);
				
				event = variables.pluginQueue.createEvent("beforeCommentUpdate",eventObj,"Update");
				event = variables.pluginQueue.broadcastEvent(event);
			
				thisObject = event.getnewItem();
				if(event.getContinueProcess()){
				
					valid = thisObject.isValidForSave();	
					if(valid.status){					
						newResult = variables.daoObject.update(thisObject);					
						
						if(newResult.status){
							status = "success";
							event = variables.pluginQueue.createEvent("afterCommentUpdate",eventObj,"Update");
							event = variables.pluginQueue.broadcastEvent(event);
							thisObject = event.getnewItem();
							// @TODO: finish this list
						}
						else{
							status = "error";
						}
						message.setStatus(status);
						message.setText(newResult.message);
					}
					else {
						for (i = 1; i LTE arraylen(valid.errors);i=i+1){
							msgText = msgText & "<br />" & valid.errors[i];
						}
						message.setStatus("error");
						message.setText(msgText);
					}
				}
			</cfscript>
		<cfset returnObj.data = rawData />	
		<cfset returnObj.newComment = thisObject />
		<cfset returnObj.message = message />

		<cfreturn returnObj />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="deleteComment" access="package" output="false" returntype="struct">
		<cfargument name="comment" required="true" type="any">
		<cfargument name="rawData" required="true" type="struct">
		<cfargument name="user" required="false" type="any">
			
			<cfscript>
				var thisObject = arguments.comment;
				var event = "";
				var newResult = "";
				var message = createObject("component","Message");
				var status = "";
				var returnObj = structnew();
				var msgText = "";
				var eventObj = structnew();
				var data = structnew();
				
				message.setType("comment");
				
				//call plugins
				eventObj.comment = thisObject;
				eventObj.rawdata = arguments.rawData;
				eventObj.oldItem = thisObject;
				eventObj.changeByUser = arguments.user;
				
				event = variables.pluginQueue.createEvent("beforeCommentDelete",eventObj,"Delete");
				event = variables.pluginQueue.broadcastEvent(event);
			
				thisObject = event.getoldItem();
				if(event.getContinueProcess()){
			
						newResult = variables.daoObject.delete(thisObject.getId());					
						
						
						if(newResult.status){
							status = "success";
							event = variables.pluginQueue.createEvent("afterCommentDelete",eventObj,"Delete");
							event = variables.pluginQueue.broadcastEvent(event);
							thisObject = event.getoldItem();
						}
						else{
							status = "error";
						}
						message.setStatus(status);
						message.setText(newResult.message);				
				}
			</cfscript>
		<cfset returnObj.data = rawData />	
		<cfset returnObj.newComment = thisObject />
		<cfset returnObj.message = message />

		<cfreturn returnObj />
	</cffunction>
	
 <!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
 <cffunction name="search" output="false" hint="Search for comments matching the criteria" access="public" returntype="array">
	<cfargument name="entry_id" required="false" type="string" hint="Entry"/>
	<cfargument name="created_since" required="false" hint="Date"/>
	<cfargument name="approved" required="false" type="boolean"  hint="Approved?"/>
	<cfargument name="adminMode" required="false" default="false" type="boolean" hint="Whether to include non-approved comments"/>

	<cfset var commentsQuery = variables.accessObject.search(argumentCollection=arguments) />
	<cfset var comments = packageObjects(commentsQuery,NOT arguments.adminMode) />		
		
	<cfreturn comments />

   </cffunction>

</cfcomponent>