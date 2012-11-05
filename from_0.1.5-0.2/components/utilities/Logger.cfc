<cfcomponent name="Logger">

<cfset variables.logLevels = "error"/>
<!---<cfset setLevel("debug")/> --->

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="logMessage" output="false" hint="Logs the specified message" access="public" returntype="void">
		<cfargument name="level" required="false" default="error" type="string" />
		<cfargument name="message" required="true" type="string" />
		
		<!--- only log it if we are at that logging level --->
		<cfif listfind(variables.logLevels,arguments.level)>
			<cffile action="APPEND" file="#GetDirectoryFromPath(GetCurrentTemplatePath())#logs/#arguments.level#.log.html" output="#arguments.message#" addnewline="Yes" fixnewline="No">
		</cfif>
</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="logObject" output="false" hint="Logs the specified object/struct" access="public" returntype="void">
		<cfargument name="level" required="false" default="error" type="string" />
		<cfargument name="obj" required="true" type="any" />
		<cfargument name="description" required="false" default="" type="string" />
		
			<cfset var message = ""/>
			<cfsavecontent variable="message">
				<cfdump var="#arguments.obj#">
			</cfsavecontent>
			
		<cfset logMessage(arguments.level,arguments.description & "<br /><hr />" & message)/>
		
</cffunction>


<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="setLevel" output="false" hint="Sets the log level" access="public" returntype="void">
		<cfargument name="level" required="false" default="error" hint="Either error, warning, info and debug" type="string" />
		
		<cfswitch expression="#arguments.level#">
			<cfcase value="warning">
				<cfset variables.logLevels = "error,warning" />
			</cfcase>			
			<cfcase value="info">
				<cfset variables.logLevels = "error,warning,info" />
			</cfcase>
			<cfcase value="debug">
				<cfset variables.logLevels = "error,warning,info,debug" />
			</cfcase>
			<cfdefaultcase>
				<cfset variables.logLevels = "error" />
			</cfdefaultcase>			
		</cfswitch>
		

</cffunction>

</cfcomponent>
