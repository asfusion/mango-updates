<cfcomponent name="util" description="Various utilities">

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="config" output="false" hint="Takes a configuration file and extracts the data" access="public" returntype="struct">
	<cfargument name="configfile" required="true" type="string" hint="The complete path to the configuration file">	
	<cfargument name="group" required="false" default="default" type="string" hint="Group to read">
	<cfargument name="includeCommon" required="false" default="true" type="boolean" hint="Whether to include settings that apply to all groups">
		
	<cfset var config = ""/>
	<cfset var configvar = "" />
	<cfset var i = 1 />
	<cfset var j = 1 />
	<cfset var data = structnew() />
	
	<!--- read the configuration file --->
	<cffile action="read" file="#arguments.configfile#" variable="configvar">
	
	<!--- remove cfsilent just in case --->
	<cfset configvar = replacenocase(replacenocase(configvar,"<cfsilent>",""),"</cfsilent>","") />
	
	<cfscript>
		config = XmlParse(configvar).config;		
		
		for (i = 1; i LTE arraylen(config.xmlchildren); i = i + 1){
			if (arguments.includeCommon){
				if (config.xmlchildren[i].xmlName EQ "parameter"){
					structappend(data,parseConfigNode(config.xmlchildren[i]));
				}
			}
			if (config.xmlchildren[i].xmlName EQ "group" AND config.xmlchildren[i].xmlattributes["id"] EQ arguments.group){
				 for (j = 1; j LTE ArrayLen(config.xmlchildren[i].xmlChildren); j = j + 1){
				 	structappend(data,parseConfigNode(config.xmlchildren[i].xmlchildren[j]));
				 }				
			}
		}
	
		return data;
	</cfscript>

</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="configGetGroupId" output="false" hint="Takes a configuration file and extracts the data" access="public" returntype="string">
	<cfargument name="configfile" required="true" type="string" hint="The complete path to the configuration file">	
	<cfargument name="index" required="false" default="1" type="string" hint="Group number to get">
		
	<cfset var config = ""/>
	<cfset var configvar = "" />
	<cfset var i = 1 />
	<cfset var j = 0 />
	
	<!--- read the configuration file --->
	<cffile action="read" file="#arguments.configfile#" variable="configvar">
	
	<!--- remove cfsilent just in case --->
	<cfset configvar = replacenocase(replacenocase(configvar,"<cfsilent>",""),"</cfsilent>","") />
	
	<cfscript>
		config = XmlParse(configvar).config;		
		
		for (i = 1; i LTE arraylen(config.xmlchildren); i = i + 1){
			if (config.xmlchildren[i].xmlName EQ "group"){
				j = j + 1;
				if (j EQ arguments.index){
					return config.xmlchildren[i].xmlattributes["id"];
				}
			}			
		}	
		return "";
	</cfscript>
	
</cffunction>


<cffunction name="parseConfigNode" output="false"  access="private" returntype="struct">
	<cfargument name="configNode" required="true" type="xml">
	
		<cfscript>
			var data = structnew();
			var i = 0;
			var j = 0;
			var k = 0;
			var node = arguments.configNode;
			var itemName = "";
			var itemValue = "";
			var args = "";
			var structItem = "";
			
			itemName = node["name"].XmlText;
			itemValue = node["value"].XmlText;
		
				switch (node.XmlAttributes["type"]){
						case "text":
							data[itemName] = itemValue;
							break;
						case "component":
							data[itemName] = createobject("component",trim(itemValue)) ;
							//are there any actions to perform?
							 if (structkeyexists(node[i],"actions")){
								//check whether we must call any method in this component
								for (j = 1; j LTE arraylen(node[i].actions.xmlChildren); j = j + 1){
									if (node[i].actions.xmlChildren[j].XmlName EQ "callmethod"){
									
										//are there any parameters?
										args = structnew();
										for (k = 1; k LTE arraylen(node[i].actions.xmlChildren[j].XmlChildren); k = k + 1){
												if (node[i].actions.xmlChildren[j].XmlChildren[k].XmlName EQ "argument"){//this is an argument
													argName = node[i].actions.xmlChildren[j].XmlChildren[k].XmlAttributes.name;
													//check the type of parameter, whether is literal or a variable
													switch (node[i].actions.xmlChildren[j].XmlChildren[k].XmlAttributes["type"]){
														case "literal": args[argName] = node[i].actions.xmlChildren[j].XmlChildren[k].XmlText;
																				break;
														case "variable": args[argName] = evaluate(node[i].actions.xmlChildren[j].XmlChildren[k].XmlText);		
																				break;											
													}
													 
												}
										}
										invokeComponent(arguments.scope[itemName],trim(node[i].actions.xmlChildren[j].XmlAttributes["name"]),args);
									}
								}		
							} 
							break;
						case "boolean":
							data[itemName] = javacast("boolean",itemValue);
							break;
						case "variable": data[itemName] = evaluate(itemValue);
																			break;
						case "structure":
							data[itemName] = structnew();
							//loop over keys
							 	for (k = 1; k LTE arraylen(node.value.xmlChildren); k = k + 1){
							 		structItem = node.value.xmlChildren[k];
							 		
									if (structItem.XmlName EQ "element"){
										if (NOT arraylen(structItem.value.xmlChildren)){
											data[itemName][structItem.key.XmlText] = structItem.value.XmlText;
										}
										/* has inner children of the type: 
											<parameter type="type">
												<name>name</name>
												<value>value</value>
											</parameter>
										*/
										else {
											for (i = 1; i LTE arraylen(structItem.value.xmlChildren); i = i + 1){
												data[itemName][structItem.key.XmlText] = parseConfigNode(structItem.value.xmlChildren[i]);
											}
											
										}
									}
								} 
							break;		
						case "array":
							data[itemName] = arraynew(1);
							//loop over keys
							 	for (k = 1; k LTE arraylen(node.value.xmlChildren); k = k + 1){
							 		structItem = node.value.xmlChildren[k];
							 		
									if (structItem.XmlName EQ "element"){
										if (NOT arraylen(structItem.xmlChildren)){
											data[itemName][k] = structItem.XmlText;
										}
										/* has inner children of the type: 
											<parameter type="type">
												<name>name</name>
												<value>value</value>
											</parameter>
										*/
										else {
											for (i = 1; i LTE arraylen(structItem.xmlChildren); i = i + 1){
												data[itemName][k] = parseConfigNode(structItem.xmlChildren[i]);
											}
											
										}
									}
								} 
							break;																							
						default: data[itemName] = itemValue;
							break;
					}				
		
		return data;
		</cfscript>

</cffunction>

 <!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="invokeComponent" output="false" hint="Private method to invoke a component dynamically" access="private" returntype="void">
	<cfargument name="component" type="any" required="true" hint="Reference to component object">
	<cfargument name="method" type="string" required="true" hint="">
	<cfargument name="parameters" type="struct" required="false" default="#structnew()#" hint="">
		
	<cfinvoke component="#arguments.component#" method="#arguments.method#"  argumentcollection="#arguments.parameters#">
	
</cffunction>

 <!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="makeCleanString" output="false" hint="Creates a nice string to use in URLs" access="public" returntype="string">
	<cfargument name="stringToClean" type="string" required="true">
	<cfargument name="maxLength" type="numeric" required="false" default="150">
	<cfargument name="maxWords" type="numeric" required="false" default="70">	
		
		<cfset var cleanedString = lcase(arguments.stringToClean) />

			<cfset cleanedString = replace(cleanedString,chr(241),"n","all")>
			<cfset cleanedString = replace(cleanedString,chr(225),"a","all")>
			<cfset cleanedString = replace(cleanedString,chr(44),"e","all")>
			<cfset cleanedString = replace(cleanedString,chr(237),"i","all")>
			<cfset cleanedString = replace(cleanedString,chr(243),"o","all")>
			<cfset cleanedString = replace(cleanedString,chr(250),"u","all")>
			<cfset cleanedString = replace(cleanedString,chr(252),"u","all")>
			<cfset cleanedString = replace(cleanedString, "-", " ", "ALL")/>
			<cfset cleanedString = trim(cleanedString)/>
			<cfset cleanedString =rereplace(cleanedString, "[^a-z0-9 ]", "", "ALL")/>
			<cfset cleanedString = rereplace(cleanedString,"[ ]","-", "ALL")/>
			<cfset cleanedString = rereplace(cleanedString,"---","-", "ALL") />
			<cfset cleanedString = rereplace(cleanedString,"--","-", "ALL") />
		
			<!--- get number of words --->
			<cfscript>
				while (listlen(cleanedString,"-") GT 2 AND (len(cleanedString) GT arguments.maxWords OR len(cleanedString) GT arguments.maxLength)){
					cleanedString = listdeleteat(cleanedString,listlen(aliasgenerated,"-"),"-");
				}
			</cfscript>
			
			<cfreturn cleanedString />
			
</cffunction>



</cfcomponent>