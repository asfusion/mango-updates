<cfcomponent hint="Represents an event that is broadcasted in the admin forms" extends="Event">

<cfset this.formName = "" />
<cfset this.item = "" />
<cfset this.status = "new" /><!--- new or update --->
<cfset this.formScope = structnew() />

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="init" hint="Constructor" access="public" output="false" returntype="any">
		<cfargument name="name" type="any" required="true" />
		<cfargument name="data" type="any" required="true" hint="Data needed for the plugins to process the event" />
		<cfargument name="message" type="struct" required="false" default="#structnew()#"  />
		
			<cfset setName(arguments.name) />
			<cfset setData(arguments.data) />
			<cfset setMessage(arguments.message) />
			
		<cfreturn this />
	</cffunction>	

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setData" access="public" output="false" returntype="void">
		<cfargument name="data" type="any" required="true" />
		
		<cfset super.setData(arguments.data)/>
		<cfif isstruct(arguments.data)>
			<cfif structkeyexists(arguments.data,"formName")>
				<cfset this.formName = arguments.data.formName />
			</cfif>
			<cfif structkeyexists(arguments.data,"item")>
				<cfset this.item = arguments.data.item />
			</cfif>
			<cfif structkeyexists(arguments.data,"formScope")>
				<cfset this.formScope = arguments.data.formScope />
			</cfif>
			<cfif structkeyexists(arguments.data,"status")>
				<cfset this.status = arguments.data.status />
			</cfif>
		</cfif>
		<cfset this.data = arguments.data />
	</cffunction>
</cfcomponent>