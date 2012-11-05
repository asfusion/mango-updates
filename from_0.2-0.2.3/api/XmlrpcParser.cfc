<cfcomponent>

	<cffunction name="parseRequest" access="public" output="false" returntype="any">
		<cfargument name="xmlRequest" required="true" type="any">
		
			<cfset var xmlParser = createObject("component","xmlrpc") />
			<cfset var data = xmlParser.XMLRPC2CFML(arguments.xmlRequest) />
			
		<cfif data.method NEQ "Error">
			<cfreturn invokeMethod(data) />
		<cfelse>			
			<cfreturn xmlParser.CFML2XMLRPC(data,"response") />
		</cfif>
		
	</cffunction>

	<cffunction name="invokeMethod" access="public" output="false" returntype="any">
		<cfargument name="data" required="true" type="struct">
			
			<cfset var apiHandler = "" />
			<cfset var methodName = "" />
			<cfset var result = "" />
			<cfset var xmlParser = createObject("component","xmlrpc") />
			<cfset var dot = ""/>
			
			<cfif findnocase("blogger",arguments.data.method)>
				<cfset apiHandler = CreateObject("component", "Blogger") />
			<cfelseif findnocase("metaWeblog",arguments.data.method)>
				<cfset apiHandler = CreateObject("component", "MetaWeblog") />
			<cfelseif findnocase("mt",arguments.data.method)>
				<cfset apiHandler = CreateObject("component", "MovableType") />
			</cfif>
		
		<cfset dot = find(".",arguments.data.method) />
		<cfif dot NEQ 0>
			<cfset methodName = mid(arguments.data.method,dot+1,len(arguments.data.method)-dot) />
		<cfelse>
			<cfset methodName = arguments.data.method />
		</cfif>

			<!---invoke method --->
			<cfinvoke component="#apiHandler#" method="#methodName#" returnvariable="result">
				<cfinvokeargument name="data" value="#arguments.data.params#">
			</cfinvoke>
			
		<cfreturn xmlParser.CFML2XMLRPC(result,"response") />
	</cffunction>

</cfcomponent>