<cfcomponent output="false">

	<cfproperty name="label" type="string" />
	<cfproperty name="entryType" type="string" default="post" />
	<cfproperty name="showInMenu" type="string" default="secondary" />
	<cfproperty name="template" type="string" />
	<cfproperty name="link" type="string" />
	<cfproperty name="order" type="numeric" default="1" />
	<cfproperty name="standardFields" type="struct" />
	<cfproperty name="customFields" type="array" />
	
	<cfscript>
		this.id = "";
		this.active = false;
		this.label = "";
		this.entryType = "post";
		this.showInMenu = "secondary";
		this.template = "";
		this.standardFields = structnew();
		this.customFields = arraynew(1);
		this.address = "";
		this.order = 1;
		this.goTo = "list";	
	</cfscript>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="init" access="public" output="false" returntype="any">		
		<cfargument name="entryType" type="string" default="post" />
		
		<cfscript>
			this.entryType = arguments.entryType;
			if (this.entryType EQ 'post')
				this.label = 'Posts';
			else
				this.label = 'Pages';
			this.standardFields = structnew();
			this.standardFields['title'] = structnew();
			this.standardFields['title'].show = true;
			this.standardFields['title'].value = '';
			this.standardFields['content'] = structnew();
			this.standardFields['content'].show = true;
			this.standardFields['content'].value = '';
			this.standardFields['excerpt'] = structnew();
			this.standardFields['excerpt'].show = true;
			this.standardFields['excerpt'].value = '';
			this.standardFields['comments_allowed'] = structnew();
			this.standardFields['comments_allowed'].show = true;
			this.standardFields['comments_allowed'].value = this.entryType EQ 'post';
			this.standardFields['status'] = structnew();
			this.standardFields['status'].show = true;
			this.standardFields['status'].value = 'published';
			this.standardFields['template'] = structnew();
			this.standardFields['template'].show = true;
			this.standardFields['template'].value = '';
			this.standardFields['parent'] = structnew();
			this.standardFields['parent'].show = true;
			this.standardFields['parent'].value = '';
			this.standardFields['sortOrder'] = structnew();
			this.standardFields['sortOrder'].show = true;
			this.standardFields['sortOrder'].value = '1';
			this.standardFields['customFields'] = structnew();
			this.standardFields['customFields'].show = true;
			this.standardFields['categories'] = structnew();
			this.standardFields['categories'].show = true;
			this.standardFields['categories'].value = '';
			this.standardFields['posted_on'] = structnew();
			this.standardFields['posted_on'].show = true;
			this.standardFields['posted_on'].value = '';
		</cfscript>
		
		<cfreturn this />
	</cffunction>


<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="serializeToXML" access="public" output="false" returntype="xml">

		<cfreturn />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="initFromXML" access="public" output="false" returntype="void">
		<cfargument name="xml" type="String" required="true" />
		
		<cfset var xmlData = "" />
		<cfset var i = 0 />
		<cfset var j = 0 />
		
		<cftry>
			<cfset xmlData = xmlparse(xml).customPanel />
			<cfset this.id = xmlData.xmlAttributes.id />
			<cfset this.active = xmlData.xmlAttributes.active />
			<cfset this.entryType = xmlData.xmlAttributes.type />
			<cfset this.showInMenu = xmlData.xmlAttributes.showInMenu />
			<cfset this.order = xmlData.xmlAttributes.order />
			<cfset this.address = xmlData.xmlAttributes.address />
			<cfset this.styleName = xmlData.xmlAttributes.styleName />
			<cfset this.goTo = xmlData.xmlAttributes.goTo />
			<cfset this.label = xmlData.label.xmltext />
			<cfset this.template = xmlData.editTemplate.xmltext />
			<!--- <cfset this.standardFields = structnew() /> --->
			<cfloop from="1" to="#arraylen(xmlData.standardFields.xmlchildren)#" index="i">
				<cfset this.standardFields[xmlData.standardFields.xmlchildren[i].xmlAttributes.id] = structnew() />
				<cfset this.standardFields[xmlData.standardFields.xmlchildren[i].xmlAttributes.id].show = xmlData.standardFields.xmlchildren[i].xmlAttributes.show />
				<cfset this.standardFields[xmlData.standardFields.xmlchildren[i].xmlAttributes.id].value = xmlData.standardFields.xmlchildren[i].xmltext />
			</cfloop>
			
			<cfloop from="1" to="#arraylen(xmlData.customFields.xmlchildren)#" index="i">
				<cfset this.customFields[i] = structnew() />
				<cfset this.customFields[i]["id"] = xmlData.customFields.xmlchildren[i].xmlAttributes.id />
				<cfset this.customFields[i]["value"] = xmlData.customFields.xmlchildren[i].defaultValue.xmltext />
				<cfset this.customFields[i]["name"] = xmlData.customFields.xmlchildren[i].label.xmltext />
				<cfset this.customFields[i]["inputType"] = xmlData.customFields.xmlchildren[i].xmlAttributes.type />
				<cfset this.customFields[i]["options"] = arraynew(1) />
				<cfif structkeyexists(xmlData.customFields.xmlchildren[i],"options")>
					<cfloop from="1" to="#arraylen(xmlData.customFields.xmlchildren[i].options.xmlChildren)#" index="j">
						<cfset this.customFields[i].options[j] = structnew() />
						<cfset this.customFields[i].options[j]["label"] = xmlData.customFields.xmlchildren[i].options.xmlChildren[j].label.xmlText />
						<cfset this.customFields[i].options[j]["value"] = xmlData.customFields.xmlchildren[i].options.xmlChildren[j].value.xmlText />
					</cfloop>
				</cfif>
			</cfloop>
			
			<cfif NOT len(this.address)>
				<cfset this.address = this.entryType />
				<cfif this.goTo EQ "list">
					<cfset this.address = this.address & "s">
				</cfif>
				<cfset this.address = "#this.address#.cfm?panel=#this.id#&amp;owner=#this.id#" />
			</cfif>
			<cfcatch type="any"></cfcatch>
		</cftry>

		<cfreturn />
	</cffunction>

<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getShowFields" access="public" output="false" returntype="string">
		<cfset var list = "" />
		<cfset var key = "" />
		<cfloop collection="#this.standardFields#" item="key">
			<cfif this.standardFields[key].show>
				<cfset list = listappend(list,key) />
			</cfif>
		</cfloop>
		<cfreturn list />
	</cffunction>
</cfcomponent>