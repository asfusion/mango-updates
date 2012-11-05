<cfcomponent hint="Represents an event that is broadcasted to add pod items" extends="TemplateEvent">

<cfset this.pods = arraynew(1) />

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
				<cfif structkeyexists(arguments.data,"pods")>
					<cfset setPods(arguments.data.pods) />
				</cfif>
			</cfif>
		<cfset this.data = arguments.data />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getPods" access="public" output="false" returntype="any">
		<cfreturn this.pods />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="setPods" access="public" output="false" returntype="void">
		<cfargument name="data" type="any" required="true" />
		<cfset this.pods = arguments.data />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="addPod" access="public" output="false" returntype="void">
		<cfargument name="data" type="any" required="true" />
		<cfset arrayappend(this.pods, arguments.data) />
	</cffunction>
</cfcomponent>