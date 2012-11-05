<cfcomponent name="BlogManager">
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainApp" required="true" type="any">

			<cfset variables.mainApp = arguments.mainApp />
			
		<cfreturn this />
	</cffunction>


<cffunction name="getBlogs" output="false" hint="Gets all the records" access="public" returntype="array">

	<cfset var blog =  "" />
	<cfset var blogsQuery = variables.mainApp.getDataAccessFactory().getblogGateway().getAll() />
	<cfset var blogs = arraynew(1) />

		<cfoutput query="blogsQuery">
			<cfscript>
				blog = CreateObject("component", "ObjectFactory").createBlog();
				blog.setId(id);
				blog.setTitle(title);
				blog.setUrl(urlString);
				blog.setDescription(description);
				blog.setTagline(tagline);
				blog.setSkin(skin);
				blog.setBasePath(basepath);
				blog.setCharset(charset);
				arrayappend(blogs,blog);
			</cfscript>
		</cfoutput>

	<cfreturn blogs />
</cffunction>

<cffunction name="getBlogsByAuthor" output="false" hint="Gets the blogs for which a given user has access to" access="public" returntype="array">
	<cfargument name="author_id" required="true" type="string" hint="Author key"/>
	
	<cfset var blog =  "" />
	<cfset var blogsQuery = variables.mainApp.getDataAccessFactory().getblogGateway().getByAuthor(arguments.author_id) />
	<cfset var blogs = arraynew(1) />
		
		<cfoutput query="blogsQuery">
			<cfscript>
				blog = CreateObject("component", "ObjectFactory").createBlog();
				blog.setId(id);
				blog.setTitle(title);
				blog.setUrl(urlString);
				blog.setDescription(description);
				blog.setTagline(tagline);
				blog.setSkin(skin);
				blog.setBasePath(basepath);
				blog.setCharset(charset);
				arrayappend(blogs,blog);
			</cfscript>
		</cfoutput>

	<cfreturn blogs />
</cffunction>


<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getBlog" access="public" output="false" returntype="any">
		<cfargument name="id" required="false" default="default" type="string" hint="Primary key"/>
		<cfargument name="config"  required="false" default="#structnew()#" type="struct" hint="Various configuration settings"/>
		
		<cfset var blog = CreateObject("component", "ObjectFactory").createBlog() />
		<cfset var settings = variables.mainApp.getDataAccessFactory().getblogGateway().getByID(arguments.id) />
		
		<cfoutput query="settings" maxrows="1">
			<cfscript>
				blog.setId(id);
				blog.setTitle(title);
				blog.setUrl(urlString);
				blog.setDescription(description);
				blog.setTagline(tagline);
				blog.setSkin(skin);
				blog.setBasePath(basepath);
				blog.setCharset(charset);
				blog.setSettings(arguments.config);				
				// @TODO add basepath to urls
			</cfscript>
		</cfoutput>
		
		
		<cfreturn blog />
	</cffunction>

<!--- @TODO add events to this function --->
	<cffunction name="addBlog" access="public" output="false" returntype="any">
		<cfargument name="blog" required="true" type="any" />
		<cfargument name="config" required="false" default="#structnew()#" type="struct" hint="Various configuration settings"/>
		
		<cfset var daoObject = variables.mainApp.getDataAccessFactory().getblogmanager() />
		<cfset var result = daoObject.create(arguments.blog) />
	
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="editBlog" access="public" output="false" returntype="any">
		<cfargument name="blog" required="true" type="any" />
		<cfargument name="rawData" required="true" type="struct">
		<cfargument name="config" required="false" default="#structnew()#" type="struct" hint="Various configuration settings"/>
		<cfargument name="user" required="false" type="any">
		
		<cfscript>
				var thisObject = arguments.blog;
				var valid = "";
				var event = "";
				var newResult = "";
				var message = createObject("component","Message");
				var status = "";
				var returnObj = structnew();
				var msgText = "";
				var eventObj = structnew();
				var data = structnew();
				var daoObject = variables.mainApp.getDataAccessFactory().getblogmanager();
				var pluginQueue = variables.mainApp.getPluginQueue();
				var i = 0;
				
				message.setType("blog");
				
				eventObj.blog = thisObject;
				eventObj.rawdata = arguments.rawData;
				eventObj.newItem = arguments.blog;
				eventObj.oldItem = getBlog(arguments.blog.getId());
				eventObj.changeByUser = arguments.user;

				event = pluginQueue.createEvent("beforeBlogUpdate",eventObj,"Update");
				event = pluginQueue.broadcastEvent(event);
			
				thisObject = event.getnewItem();

				if(event.getContinueProcess()){
				
					valid = thisObject.isValidForSave();	
					if(valid.status){					
						newResult = daoObject.update(thisObject);					
						
						
						if(newResult.status){
							status = "success";
							event = pluginQueue.createEvent("afterBlogUpdate",eventObj,"Update");
							event = pluginQueue.broadcastEvent(event);
							thisObject = event.getnewItem();
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
		<cfset returnObj.blog = thisObject />
		<cfset returnObj.message = message />

		<cfreturn returnObj />

	</cffunction>

</cfcomponent>