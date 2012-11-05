<cfcomponent name="EntryDAO" hint="Manages entries">
      
 <!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="init" output="false" returntype="any" hint="instantiates an object of this class" access="public">
	<cfargument name="datasource" required="true" type="struct">
		
		<cfset variables.datasource = arguments.datasource />
		<cfset variables.dsn = arguments.datasource.name />
		<cfset variables.prefix = arguments.datasource.tablePrefix />
		<cfset variables.username = arguments.datasource.username />
		<cfset variables.password = arguments.datasource.password />
		<cfreturn this />
		
</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="read" output="false" access="public" returntype="any">
		<cfargument name="entry" required="true" type="any" hint="Entry object to populate"/>
		
		<cfset var qRead="">

		<cfquery name="qRead" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			select 	id, name, title, content, excerpt, author_id, 	comments_allowed, status, last_modified
			from #variables.prefix#entry
			where id = <cfqueryparam value="#arguments.entry.getId()#" cfsqltype="CF_SQL_VARCHAR" maxlength="35"/>
		</cfquery>

		<cfscript>
			arguments.entry.setName(qRead.name);
			arguments.entry.setTitle(qRead.title);
			arguments.entry.setContent(qRead.content);
			arguments.entry.setExcerpt(qRead.excerpt);
			arguments.entry.setAuthorId(qRead.author_id);
			arguments.entry.setCommentsAllowed(qRead.comments_allowed);
			arguments.entry.setStatus(qRead.status);
			arguments.entry.setLastModified(qRead.last_modified);
			return arguments.entry;
		</cfscript>
	</cffunction> 


<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="store" output="false" hint="Inserts a new record" access="public" returntype="any">
	<cfargument name="entry" required="true" type="any" hint="Entry object"/>

		<cfset var id = arguments.entry.getId() />
		<!--- @TODO validate unique name --->
		<cfif len(id)>
			<!--- update --->
			<cfreturn update(arguments.entry) />
		<cfelse>
			<cfreturn create(arguments.entry) />
		</cfif>	

</cffunction>

	
	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<!--- Overwrite this method! --->
<cffunction name="create" output="false" hint="Inserts a new record" access="public" returntype="struct">
	<cfargument name="entry" required="true" type="any" hint="entry object"/>
	<cfscript>
		var qinsertentry = "";
		var id = arguments.entry.getId();
		var returnObj = structnew();
		returnObj["status"] = false;
		returnObj["message"] = "";
		if (NOT len(id)){
			id = createUUID();
		}
	</cfscript>

<!---	<cftry> --->
		<cfquery name="qinsertentry"  datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		INSERT INTO #variables.prefix#entry
		(id, name,title,content,excerpt,author_id,comments_allowed,status,last_modified,blog_id)
		VALUES (
		<cfqueryparam value="#id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35"/>,
		<cfqueryparam value="#arguments.entry.getName()#" cfsqltype="CF_SQL_VARCHAR" maxlength="200"/>,
		<cfqueryparam value="#arguments.entry.getTitle()#" cfsqltype="CF_SQL_VARCHAR" maxlength="200"/>,
		<cfqueryparam value="#arguments.entry.getContent()#" cfsqltype="CF_SQL_LONGVARCHAR"/>,
		<cfqueryparam value="#arguments.entry.getExcerpt()#" cfsqltype="CF_SQL_LONGVARCHAR" />,
		<cfqueryparam value="#arguments.entry.getAuthorId()#" cfsqltype="CF_SQL_VARCHAR" maxlength="35"/>,
		<cfqueryparam value="#arguments.entry.getCommentsAllowed()#" cfsqltype="cf_sql_tinyint"/>,
		<cfqueryparam value="#arguments.entry.getStatus()#" cfsqltype="CF_SQL_VARCHAR" maxlength="50"/>,
		<cfqueryparam value="#arguments.entry.getLastModified()#" cfsqltype="cf_sql_timestamp"/>,
		<cfqueryparam value="#arguments.entry.getBlogId()#" cfsqltype="CF_SQL_VARCHAR"/>	
		)
		 </cfquery>

		<cfset returnObj["status"] = true/>

<!---		<cfcatch type="Any">
			<cfset returnObj["status"] = false/>
			<cfset returnObj["message"] = CFCATCH.message & ": " & CFCATCH.detail/>
		</cfcatch>
	</cftry> --->

	<cfif returnObj["status"]>
		<cfset arguments.entry.setId(id)/>
		<cfset returnObj["message"] = "Insert successful"/>
		<cfset returnObj["data"] = arguments.entry />
	</cfif>

	<cfreturn returnObj/>
</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="update" output="false" hint="Updates a record" access="public" returntype="struct">
	<cfargument name="entry" required="true" type="any" hint="entry object"/>

    <cfscript>
		var qupdateentry = "";
		var returnObj = structnew();
		returnObj["status"] = false;
		returnObj["message"] = "";
	</cfscript>

	<cftry>
		<cfquery name="qupdateentry"  datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		UPDATE #variables.prefix#entry
		SET
		name = <cfqueryparam value="#arguments.entry.getName()#" cfsqltype="CF_SQL_VARCHAR" maxlength="200"/>,
		title = <cfqueryparam value="#arguments.entry.getTitle()#" cfsqltype="CF_SQL_VARCHAR" maxlength="200"/>,
		content = <cfqueryparam value="#arguments.entry.getContent()#" cfsqltype="CF_SQL_LONGVARCHAR"/>,
		excerpt = <cfqueryparam value="#arguments.entry.getExcerpt()#" cfsqltype="CF_SQL_LONGVARCHAR" />,
		author_id = <cfqueryparam value="#arguments.entry.getAuthorId()#" cfsqltype="CF_SQL_VARCHAR" maxlength="35"/>,
		comments_allowed = <cfqueryparam value="#arguments.entry.getCommentsAllowed()#" cfsqltype="cf_sql_tinyint"/>,
		status = <cfqueryparam value="#arguments.entry.getStatus()#" cfsqltype="CF_SQL_VARCHAR" maxlength="50"/>,	
		last_modified = <cfqueryparam value="#arguments.entry.getLastModified()#" cfsqltype="cf_sql_timestamp"/>
		
		WHERE id = <cfqueryparam value="#arguments.entry.getId()#" cfsqltype="CF_SQL_VARCHAR" maxlength="35"/>
		</cfquery>

		<cfset returnObj["status"] = true/>

		<cfcatch type="Any">
			<cfset returnObj["status"] = false/>
			<cfset returnObj["message"] = CFCATCH.message & ": " & CFCATCH.detail />
		</cfcatch>
	</cftry>

	<cfif returnObj["status"]>
		<cfset returnObj["message"] = "Insert successful"/>
		<cfset returnObj["data"] = arguments.entry />
	</cfif>

	<cfreturn returnObj/>
</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="delete" output="false" hint="Deletes a record" access="public" returntype="struct">
<cfargument name="id" required="true" type="string" hint="Primary key"/>
    
    <cfscript>
		var qdeleteentry = "";
		var returnObj = structnew();
		returnObj["status"] = false;
		returnObj["message"] = "";
	</cfscript>

	<cftry>
		<cfquery name="qdeleteentry"  datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
            DELETE FROM #variables.prefix#entry
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35"/>
		</cfquery>
    
		<cfset returnObj["status"] = true/>
		
    	<cfcatch type="Any">
    		<cfset returnObj["status"] = false/>
     	   <cfset returnObj["message"] = CFCATCH.message & ": " & CFCATCH.detail />
		</cfcatch>
	</cftry>
    						
	<cfif returnObj["status"]>
    	<cfset returnObj["message"] = "Delete successful"/>
		<cfset returnObj["data"] = arguments.id />
    </cfif>
    
	<cfreturn returnObj/>
</cffunction>


</cfcomponent>