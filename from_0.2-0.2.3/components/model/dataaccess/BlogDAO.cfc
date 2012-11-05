<cfcomponent>

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
	<cffunction name="create" output="false" access="public" returntype="any">
		<cfargument name="bean" required="true" type="any">
		<cfset var qCreate="">

		<cfquery name="qCreate" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			insert into #variables.prefix#blog(id, title, description, tagline, skin, url, charset, basePath)
			values (
				<cfqueryparam value="#arguments.bean.getid()#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#arguments.bean.gettitle()#" cfsqltype="CF_SQL_VARCHAR" maxlength="150" />,
				<cfqueryparam value="#arguments.bean.getdescription()#" cfsqltype="cf_sql_longvarchar" />,
				<cfqueryparam value="#arguments.bean.gettagline()#" cfsqltype="CF_SQL_VARCHAR" maxlength="150" />,
				<cfqueryparam value="#arguments.bean.getskin()#" cfsqltype="CF_SQL_VARCHAR" maxlength="100" />,
				<cfqueryparam value="#arguments.bean.geturl()#" cfsqltype="CF_SQL_VARCHAR" maxlength="255" />,
				<cfqueryparam value="#arguments.bean.getcharset()#" cfsqltype="CF_SQL_VARCHAR" maxlength="50" />,
				<cfqueryparam value="#arguments.bean.getbasePath()#" cfsqltype="CF_SQL_VARCHAR" maxlength="255" />
			)
		</cfquery>

	<cfreturn bean> 
	</cffunction>



	<cffunction name="update" output="false" access="public" returntype="struct">
		<cfargument name="bean" required="true" type="any">

		<cfscript>
			var qUpdate = "";
			var returnObj = structnew();
			returnObj["status"] = false;
			returnObj["message"] = "";
		</cfscript>

	<cftry>
		<cfquery name="qUpdate" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			update #variables.prefix#blog
			set title = <cfqueryparam value="#arguments.bean.gettitle()#" cfsqltype="CF_SQL_VARCHAR" />,
				description = <cfqueryparam value="#arguments.bean.getdescription()#" cfsqltype="cf_sql_longvarchar" />,
				tagline = <cfqueryparam value="#arguments.bean.gettagline()#" cfsqltype="CF_SQL_VARCHAR" />,
				skin = <cfqueryparam value="#arguments.bean.getskin()#" cfsqltype="CF_SQL_VARCHAR" />,
				url = <cfqueryparam value="#arguments.bean.geturl()#" cfsqltype="CF_SQL_VARCHAR" />,
				charset = <cfqueryparam value="#arguments.bean.getcharset()#" cfsqltype="CF_SQL_VARCHAR" />,
				basePath = <cfqueryparam value="#arguments.bean.getbasePath()#" cfsqltype="CF_SQL_VARCHAR" />
			where id = <cfqueryparam value="#arguments.bean.getid()#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		
		<cfset returnObj["status"] = true/>

		<cfcatch type="Any">
			<cfset returnObj["status"] = false/>
			<cfset returnObj["message"] = CFCATCH.message & ": " & CFCATCH.detail />
		</cfcatch>
	</cftry>

	<cfif returnObj["status"]>
		<cfset returnObj["message"] = "Update successful"/>
		<cfset returnObj["data"] = arguments.bean />
	</cfif>

	<cfreturn returnObj/>
		
	</cffunction>



	<cffunction name="delete" output="false" access="public" returntype="void">
		<cfargument name="bean" required="true" type="any">
		<cfset var qDelete="">

		<cfquery name="qDelete" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			delete
			from #variables.prefix#blog
			where id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.bean.getid()#" />
		</cfquery>
	</cffunction>


</cfcomponent>