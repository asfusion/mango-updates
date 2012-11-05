<cfcomponent name="PageManager">

	<cfset variables.accessObject = "">
	<cfset variables.mainApp = "" />
	<cfset variables.daoObject = "" />
	<cfset variables.pageNames = structnew() /><!--- ids as keys, names as values --->
	<cfset variables.pageIds = structnew() /><!--- names as keys, ids as values --->
	<cfset variables.childrenCache = createObject("component","utilities.Cache") />
	<cfset variables.itemsCache = createObject("component","utilities.Cache") />

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainApp" required="true" type="any">
			
			<cfset variables.factory = arguments.mainApp.getDataAccessFactory() />
			<cfset variables.accessObject = variables.factory.getPagesGateway() />		
			<cfset variables.mainApp = arguments.mainApp />
			<cfset variables.daoObject = variables.factory.getPageManager() />
			<cfset variables.pluginQueue = variables.mainApp.getPluginQueue() />
			<cfset variables.blogid = arguments.mainApp.getBlog().getId() />
			
		<cfreturn this />
	</cffunction>

	<cffunction name="getPages" access="public" output="false" returntype="array">	
		<cfargument name="from" required="false" default="1" type="numeric" hint=""/>
		<cfargument name="count" required="false" default="0" type="numeric" hint=""/>
		<cfargument name="adminMode" required="false" default="false" type="boolean" hint="Whether to include drafts and future posts"/>
		
		<cfset var pagesQuery = variables.accessObject.getAll(variables.blogid,arguments.adminMode) />
		<cfset var pages = packageObjects(pagesQuery,arguments.from,arguments.count) />		
		
		<cfreturn pages />
	</cffunction>

		
	<!---	<cfset var postsIds = variables.accessObject.getAllIds(variables.blogid,arguments.adminMode) />
		<cfset var posts = "" />
		<cfset var ids = "" />
		<cfset var postsQuery = "" />
		<cfif arguments.count EQ 0 AND postsIds.recordcount GT 0>
			<cfset arguments.count = postsIds.recordcount />
		<cfelseif arguments.count EQ 0>
			<cfset arguments.count = 1 />
		</cfif>
		
		<cfoutput query="postsIds" startrow="#arguments.from#" maxrows="#arguments.count#">
			<cfset ids = listappend(ids,id) />
		</cfoutput>
		<cfset postsQuery = variables.accessObject.getByIds(ids,querynew("key"),arguments.adminMode) />
		<cfset posts = packageObjects(postsQuery,arguments.from,arguments.count,NOT arguments.adminMode) />
		
		<cfreturn posts />
	</cffunction>	 --->
	
	
	<cffunction name="getPagesByParent" access="public" output="false" returntype="array">
		<cfargument name="parent_page_id" required="true" type="string" hint="Parent page"/>
		<cfargument name="from" required="false" default="1" type="numeric" hint=""/>
		<cfargument name="count" required="false" default="0" type="numeric" hint=""/>
		<cfargument name="adminMode" required="false" default="false" type="boolean" hint="Whether to include drafts and future posts"/>
		
			<cfset var pagesQuery = "" />
			<cfset var pages = "" />
			<cfset var cacheresult = variables.childrenCache.checkAndRetrieve(arguments.parent_page_id)>		
			<cfif cacheresult.contains>
				<cfset pagesQuery = cacheresult.value />
			<cfelse>
				<cfset pagesQuery = variables.accessObject.getByParent(arguments.parent_page_id,variables.blogid,arguments.adminMode) />
				<cfset variables.childrenCache.store(arguments.parent_page_id,pagesQuery) />
			</cfif>		
			
			<cfset pages = packageObjects(pagesQuery,arguments.from,arguments.count) />		
		
		<cfreturn pages />
	</cffunction>
	
<!--- 	getByName --->	
	<cffunction name="getPageByName" access="public" output="false" returntype="any">
		<cfargument name="name" required="true" type="string" hint="Name"/>
		
		<!---<cfset var pagesQuery = variables.accessObject.getByName(arguments.name,variables.blogid) />
		<cfset var pages = packageObjects(pagesQuery) /> --->		
		<cfset var id = getPageIdFromCache(arguments.name) />
		
		<!--- let getById handle request --->
		<cfif id NEQ "">	
			<cftry>
					<cfreturn getPageById(id) />
				
				<cfcatch type="PageNotFound">
					<cfthrow errorcode="PageNotFound" message="Page #arguments.name# was not found" type="PageNotFound">
				</cfcatch>
			</cftry>
		<cfelse>
			<!--- page not found --->
			<cfthrow errorcode="PageNotFound" message="Page #arguments.name# was not found" type="PageNotFound">
		</cfif>
		<!---<cfif NOT pagesQuery.recordcount>
			<cfthrow errorcode="PageNotFound" message="Page #arguments.name# was not found" type="PageNotFound">
		</cfif>
		<cfreturn pages[1] /> --->
	</cffunction>
	
<!--- 	getById --->	
	<cffunction name="getPageById" access="public" output="false" returntype="any">
		<cfargument name="id" required="true" type="string" hint="Id"/>
		<cfargument name="adminMode" required="false" default="false" type="boolean" hint="Whether to include drafts and future posts"/>
		<!--- admin mode does not use cache --->
		<cfset var pagesQuery = "" />
		<cfset var pages = "" />
		<cfset var cacheresult = variables.itemsCache.checkAndRetrieve(arguments.id)>
				
		<cfif NOT arguments.adminMode AND cacheresult.contains>
			<cfreturn createObject("component","PageWrapper").init(variables.pluginQueue,cacheresult.value) />
		<cfelse>
			<!--- not in cache, we must get it from db --->
			<cfset pagesQuery = variables.accessObject.getById(arguments.id,arguments.adminMode) />
			<cfset pages = packageObjects(pagesQuery,1,1,NOT arguments.adminMode) />
			<cfif NOT pagesQuery.recordcount>
				<cfthrow errorcode="PageNotFound" message="Page was not found" type="PageNotFound">
			</cfif>
			<cfreturn pages[1] />
		</cfif>
		
	</cffunction>
	

 <!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<!--- 	getByAuthor --->	
	<cffunction name="getPagesByAuthor" access="public" output="false" returntype="array">
		<cfargument name="author_id" required="true" type="numeric" default="0" hint="Author"/>
		<cfargument name="from" required="false" default="1" type="numeric" hint=""/>
		<cfargument name="count" required="false" default="0" type="numeric" hint=""/>
		
		<cfset var pagesQuery = variables.accessObject.getByAuthor(arguments.author_id,variables.blogid) />
		<cfset var pages = packageObjects(pagesQuery,arguments.from,arguments.count) />		
		
		<cfreturn pages />
	</cffunction>
	
	
 <!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<!--- 	search --->	
	<cffunction name="getPagesByKeyword" access="public" output="false" returntype="array">
		<cfargument name="keyword" required="true" type="string" default="" hint="Keyword"/>
		<cfargument name="from" required="false" default="1" type="numeric" hint=""/>
		<cfargument name="count" required="false" default="0" type="numeric" hint=""/>
		
		<cfset var pagesQuery = variables.accessObject.search(arguments.keyword) />
		<cfset var pages = packageObjects(pagesQuery,arguments.from,arguments.count) />			
		
		<cfreturn pages />
	</cffunction>			
	
 <!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="packageObjects" access="private" output="false" returntype="array">
		<cfargument name="pagesQuery" required="true" type="query">
		<cfargument name="from" required="false" default="1" type="numeric" hint=""/>
		<cfargument name="count" required="false" default="0" type="numeric" hint=""/>
		<cfargument name="useWrapper" required="false" default="true" type="boolean" hint="Whether to use post wrapper"/>
		
		<cfset var pages = arraynew(1) />
		<cfset var thisPage = "" />
		<cfset var urlString = "" />
		<cfset var parent = 0 />
		<cfset var i = 0/>
		<cfset var thisid = "" />
		<cfset var hierarchyNames = "" />
		<cfset var wrappedPage = "" />
		<cfset var cacheCheck = "" />
		<cfset var createNewPage = true />
		
		<cfif arguments.count EQ 0>
			<cfset arguments.count = pagesQuery.recordcount />
		</cfif>
		
		<cfif pagesQuery.recordcount>
			<cfoutput query="arguments.pagesQuery" group="id">
				<cfset i = i + 1 />
				<cfset hierarchyNames = ""/>
				<cfset createNewPage = true />
				<cfif i GTE arguments.from AND i LT (arguments.count + arguments.from)>
					<!--- check the cache --->
					<cfif arguments.useWrapper>
						<cfset cacheCheck = variables.itemsCache.checkAndRetrieve(id) />
						<cfif cacheCheck.contains>
							<cfset thisPage = cacheCheck.value />
							<cfset createNewPage = false />
						</cfif>
					</cfif>
					
					<cfif createNewPage>
						<cfset thisPage = CreateObject("component", "ObjectFactory").createPage() />		
										
						<cfif NOT len(parent_page_id)>
							<cfset parent = 0 />
						<cfelse>
							<cfset parent = parent_page_id />
						</cfif>
					
						<cfscript>
							thisPage.parentPageId = parent_page_id;
							thisPage.template = template;
							thisPage.Hierarchy = hierarchy;
							thisPage.Id = id;
							thisPage.Name = name;
							thisPage.Title = title;
							thisPage.content = content;
							thisPage.excerpt = excerpt;
							thisPage.authorId = author_id;
							thisPage.Author = author;
							thisPage.commentsAllowed = comments_allowed;
							thisPage.status = status;
							thisPage.LastModified = last_modified;
							thisPage.CommentCount = comment_count;
							thisPage.SortOrder = sort_order;
						</cfscript>
					
						<cfoutput group="field_id">
							<cfif len(field_id)>
								<cfset thisPage.setCustomField(field_id,field_name,field_value) />
							</cfif>
						</cfoutput>
						
						<!--- replace hierarchy ids for names --->
						<cfloop list="#hierarchy#" index="thisid" delimiters="/">
							<cfset hierarchyNames = listappend(hierarchyNames,getPageNameFromCache(thisid),"/") />						
						</cfloop>
						
						<cfif len(hierarchyNames)>
							<cfset hierarchyNames = hierarchyNames & "/"/>
						</cfif>
						<!--- set URL with setting from blog --->
						<cfset urlString = replacenocase(replacenocase(replacenocase(variables.mainApp.getBlog().getSetting("pageUrl"),"{pageid}",id),
									"{pageName}",name),
									"{pageHierarchyNames}",hierarchyNames) />
						
						<cfset thisPage.setUrl(urlString) />
					</cfif>
					
					
					<cfif arguments.useWrapper>
						<cfset wrappedPage = createObject("component","PageWrapper").init(variables.pluginQueue,thisPage) />
						<cfif createNewPage>
							<!--- store in cache (only if we are not in admin mode and we have not retrieved it from the cache already) --->
							<cfset variables.itemsCache.store(id,thisPage) />
						</cfif>
					<cfelse>
						<cfset wrappedPage = thisPage />
					</cfif>
					<cfset arrayappend(pages,wrappedPage)>
				</cfif>
				
			</cfoutput>
		</cfif>
		<cfreturn pages />
	</cffunction>
	
<!---::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getPageNameFromCache" access="private" output="false" returntype="string">
		<cfargument name="id" required="true" type="string" hint="Id"/>
		
		<cfset var pagesQuery = "" />		
		<cfif structkeyexists(variables.pageNames,arguments.id)>
			<cfreturn variables.pageNames[arguments.id] />
		<cfelse>
			<cfset pagesQuery = variables.accessObject.getById(arguments.id) />		
		
			<cfif pagesQuery.recordcount>
				<cfset variables.pageNames[arguments.id] = pagesQuery.name />
				<cfset variables.pageIds[pagesQuery.name] = arguments.id />
				<cfreturn pagesQuery.name />
			
			<cfelse>
				<cfreturn "" />
			</cfif>
		</cfif>
	</cffunction>

<!---::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getPageIdFromCache" access="private" output="false" returntype="string">
		<cfargument name="name" required="true" type="string" hint="Name"/>
		
		<cfset var pagesQuery = "" />		
		<cfif structkeyexists(variables.pageIds,arguments.name)>
			<cfreturn variables.pageIds[arguments.name] />
		<cfelse>
			<cfset pagesQuery = variables.accessObject.getByName(arguments.name,variables.blogid) />		
		
			<cfif pagesQuery.recordcount>
				<cfset variables.pageNames[pagesQuery.id] = arguments.name />
				<cfset variables.pageIds[arguments.name] = pagesQuery.id />
				<cfreturn pagesQuery.id />
			
			<cfelse>
				<cfreturn "" />
			</cfif>
		</cfif>
	</cffunction>
	
<!---:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
<!--- Edit functions --->
	<cffunction name="addPage" access="package" output="false" returntype="struct">
		<cfargument name="page" required="true" type="any">
		<cfargument name="rawData" required="true" type="struct">
		<cfargument name="user" required="false" type="any">
			
			<cfscript>
				var thisObject = arguments.page;
				var authorManager = variables.mainApp.getAuthorsManager();
				var valid = "";
				var event = "";
				var newResult = "";
				var message = createObject("component","Message");
				var status = "";
				var returnObj = structnew();
				var msgText = "";
				var eventObj = structnew();
				var data = structnew();
				var util = createObject("component","Utilities");
				
				message.setType("page");

				if(NOT len(thisObject.getName())){
					thisObject.setName(util.makeCleanString(thisObject.getTitle()));				
				}
				
				if (NOT structkeyexists(arguments,"user")){
					arguments.user = authorManager.getAuthorById(arguments.page.getAuthorId(),true);
				}
				
				//call plugins
				eventObj.page = thisObject;
				eventObj.rawdata = arguments.rawData;
				eventObj.newItem = arguments.page;
				eventObj.changeByUser = arguments.user;
					event = variables.pluginQueue.createEvent("beforePageAdd",eventObj,"Update");
					event = variables.pluginQueue.broadcastEvent(event);
			
				thisObject = event.getNewItem();
				if(event.getContinueProcess()){
				
					valid = thisObject.isValidForSave();	
					if(valid.status){					
						newResult = variables.daoObject.store(thisObject);					
						
						
						if(newResult.status){
							status = "success";
							event = variables.pluginQueue.createEvent("afterPageAdd",eventObj,"Update");
							event = variables.pluginQueue.broadcastEvent(event);
							thisObject = event.getNewItem();
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
		<cfset returnObj.newPage = thisObject />
		<cfset returnObj.message = message />

		<cfreturn returnObj />
	</cffunction>

	<cffunction name="editPage" access="package" output="false" returntype="struct">
		<cfargument name="page" required="true" type="any">
		<cfargument name="rawData" required="true" type="struct">
		<cfargument name="user" required="false" type="any">
			
			<cfscript>
				var thisObject = arguments.page;
				var authorManager = variables.mainApp.getAuthorsManager();
				var valid = "";
				var event = "";
				var newResult = "";
				var message = createObject("component","Message");
				var status = "";
				var returnObj = structnew();
				var msgText = "";
				var eventObj = structnew();
				var data = structnew();
				
				message.setType("page");

				thisObject.setLastModified(now());				
				
				if (NOT structkeyexists(arguments,"user")){
					arguments.user = authorManager.getAuthorById(arguments.page.getAuthorId(),true);
				}
				
				//call plugins
				eventObj.page = thisObject;
				eventObj.rawdata = arguments.rawData;
				eventObj.newItem = arguments.page;
				eventObj.oldItem = getPageById(arguments.page.getId(),true);
				eventObj.changeByUser = arguments.user;

				event = variables.pluginQueue.createEvent("beforePageUpdate",eventObj,"Update");
				event = variables.pluginQueue.broadcastEvent(event);
			
				thisObject = event.getnewItem();
				if(event.getContinueProcess()){
				
					valid = thisObject.isValidForSave();	
					if(valid.status){					
						newResult = variables.daoObject.store(thisObject);					
						
						
						if(newResult.status){
							status = "success";
							event = variables.pluginQueue.createEvent("afterPageUpdate",eventObj,"Update");
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
		<cfset returnObj.newPage = thisObject />
		<cfset returnObj.message = message />

		<cfreturn returnObj />
	</cffunction>

	<cffunction name="deletePage" access="package" output="false" returntype="struct">
		<cfargument name="page" required="true" type="any">
		<cfargument name="rawData" required="true" type="struct">
		<cfargument name="user" required="false" type="any">
			
			<cfscript>
				var thisObject = arguments.page;
				var authorManager = variables.mainApp.getAuthorsManager();
				var valid = "";
				var event = "";
				var newResult = "";
				var message = createObject("component","Message");
				var status = "";
				var returnObj = structnew();
				var msgText = "";
				var eventObj = structnew();
				var data = structnew();
				
				message.setType("page");
			
				if (NOT structkeyexists(arguments,"user")){
					arguments.user = authorManager.getAuthorById(arguments.page.getAuthorId(),true);
				}
				
				//call plugins
				eventObj.page = thisObject;
				eventObj.rawdata = arguments.rawData;
				eventObj.oldItem = thisObject;
				eventObj.changeByUser = arguments.user;
				
				event = variables.pluginQueue.createEvent("beforePageDelete",eventObj,"Delete");
				event = variables.pluginQueue.broadcastEvent(event);
			
				thisObject = event.getoldItem();
				if(event.getContinueProcess()){
			
						newResult = variables.daoObject.delete(thisObject.getId());					
						
						
						if(newResult.status){
							status = "success";
							event = variables.pluginQueue.createEvent("afterPageDelete",eventObj,"Delete");
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
		<cfset returnObj.newPage = thisObject />
		<cfset returnObj.message = message />

		<cfreturn returnObj />
	</cffunction>
		
		<cffunction name="updateEvent" access="public" output="false" returntype="void">
		<cfargument name="event" type="String" required="true" />
			<cfset var obj = "" />
		
			<cfswitch expression="#listgetat(arguments.event,1,'|')#">
					<cfcase value="pageAdded">
						<cfset obj = getPageById(listgetat(arguments.event,2,"|")) />
						<cfset variables.childrenCache.clear(obj.getParentPageId()) />
					</cfcase>
					<cfcase value="pageUpdated">
						<cfset obj = getPageById(listgetat(arguments.event,2,"|")) />
						<cfset variables.childrenCache.clear(obj.getId()) />
						<cfset variables.itemsCache.clear(obj.getId()) />
						<cfset variables.childrenCache.clear(obj.getParentPageId()) />
					</cfcase>
					<cfcase value="pageDeleted">
						<cfset variables.childrenCache.clear(listgetat(arguments.event,2,"|")) />
						<cfset variables.itemsCache.clear(listgetat(arguments.event,2,"|")) />
					</cfcase>
				</cfswitch>
	</cffunction>
	
<!--- Cache management --->
<!---::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getCache" access="public" output="false" returntype="any">
		<cfreturn variables.itemsCache />
	</cffunction>

	<cffunction name="getChildrenCache" access="public" output="false" returntype="any">
		<cfreturn variables.childrenCache />
	</cffunction>		
</cfcomponent>