<cfcomponent displayname="CategoryArchive" extends="Archive">

<cfset this.type = "category">

	<cffunction name="init" access="public" returntype="" output="false">
		<cfargument name="type" type="string" required="false" default="" />
		<cfargument name="title" type="string" required="false" default="" />
		<cfargument name="postCount" type="string" required="false" default="" />
		<cfargument name="category" type="string" required="false" default="" />

		<cfscript>
			// run setters
			setCategory(arguments.category);
			super.init(argumentcollection=arguments);
		</cfscript>

		<cfreturn this />
 	</cffunction>


	<cffunction name="setCategory" access="public" returntype="void" output="false">
		<cfargument name="category" type="Category" required="true" />
		<cfset this.category = arguments.category />
	</cffunction>
	
	<cffunction name="getCategory" access="public" returntype="Category" output="false">
		<cfreturn this.category />
	</cffunction>

</cfcomponent>