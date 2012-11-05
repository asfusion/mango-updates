<cfimport prefix="mangoAdmin" taglib="tags">
<cffunction name="versionCompare" returntype="numeric">
	<cfargument name="version1">
	<cfargument name="version2">

	<cfset var len1 = listlen(arguments.version1,".") />
	<cfset var len2 = listlen(arguments.version2,".") />
	<cfset var i = 0/>
	<cfset var piece1 = ""/>
	<cfset var piece2 = ""/>
	
	<cfif len1 GT len2>
		<cfset arguments.version2 = arguments.version2 & repeatstring(".0",len1-len2) />
	</cfif>
	
	<cfif len1 LT len2>
		<cfset arguments.version1 = arguments.version1 & repeatstring(".0",len2-len1) />
	</cfif>
	
	<cfloop from="1" to="#listlen(arguments.version1,".")#" index="i">
		<cfset piece1 = listgetat(arguments.version1,i,".")/>
		<cfset piece2 = listgetat(arguments.version2,i,".")/>
		
		<cfif piece1 NEQ piece2>
			<!--- we need to compare --->
			<cfif piece1 GT piece2>
				<cfreturn 1/>
			<cfelse>
				<cfreturn -1/>
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- they were equal --->
	<cfreturn 0/>
	
</cffunction>

<!--- check current version --->
<cftry>
	<cfset lastversion = "0"/>
	<cfset message = "">
	<cfinvoke webservice="http://www.mangoblog.org/services/Update.cfc?wsdl" method="getCurrentVersionNumber" timeout="5" returnvariable="lastversion">
	
	<cfif versionCompare(lastversion,request.blogManager.getVersion()) EQ 1>
		<cfinvoke webservice="http://www.mangoblog.org/services/Update.cfc?wsdl" method="getCurrentBuildUrl" timeout="5" returnvariable="zipurl">
		
		<cfset message ='<p class="message">There is a new version of Mango Blog (#lastversion#). It is recommended that you <a href="#zipurl#">download</a> it and upgrade your current install</p>'/>
		
	</cfif>
	<cfif structkeyexists(url, "first")>
		<cfset message ='<p class="message">Welcome to your blog! <br/>You can now edit the <a href="categories.cfm">categories</a>, or <a href="post.cfm">write a new post</a>
		<br />Also, don''t forget to edit your blog''s <a href="settings.cfm">settings</a>.</p>'/>
	</cfif>
	
	
	<cfcatch type="any"></cfcatch>
</cftry>
<cf_layout page="Overview" title="Overview">
	<div id="wrapper">
		<div id="content">
		<h2 class="pageTitle">Overview</h2>
		
			<div id="innercontent">
			<cfoutput>#message#</cfoutput>
			
			<mangoAdmin:PodEvent name="dashboardPod" />
			</div>
		</div>
	</div>
</cf_layout>