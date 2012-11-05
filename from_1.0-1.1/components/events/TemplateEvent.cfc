<cfcomponent name="TemplateEvent" hint="Represents an event that is broadcasted from a template" extends="Event" alias="org.mangoblog.event.TemplateEvent">
	<cfproperty name="name" type="string" default="" />
	<cfproperty name="data" type="any" />
	<cfproperty name="outputdata" type="any" />
	<cfproperty name="continueProcess" type="boolean" default="true" />
	<cfproperty name="message" type="struct" />
	<cfproperty name="requestdata" type="any" />
	<cfproperty name="contextdata" type="any" />
	
	<cfset this.requestdata = "" />
	<cfset this.contextdata = "" />

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setData" access="public" output="false" returntype="void">
		<cfargument name="data" type="any" required="true" />
			<cfif isstruct(arguments.data)>
				<cfif structkeyexists(arguments.data,"context")>
					<cfset setContextData(arguments.data.context) />
				</cfif>
				<cfif structkeyexists(arguments.data,"request")>
					<cfset setRequestData(arguments.data.request) />
				</cfif>
			</cfif>
		<cfset this.data = arguments.data />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getRequestData" access="public" output="false" returntype="any">
		<cfreturn this.requestdata />
	</cffunction>
		
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setRequestData" access="public" output="false" returntype="void">
		<cfargument name="data" type="any" required="true" />
		<cfset this.requestdata = arguments.data />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setContextData" access="public" output="false" returntype="void">
		<cfargument name="data" type="any" required="true" />
		<cfset this.contextdata = arguments.data />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getContextData" access="public" output="false" returntype="any">
		<cfreturn this.contextdata />
	</cffunction>


</cfcomponent>