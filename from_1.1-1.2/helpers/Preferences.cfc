<!--- 
Implementation of the Java Preferences API. 
Although it doesn't implement the same functions as the java.util.prefs.Preferences, it is able to parse
and modify files generated by the Java API.

It can be used to store any type of configuration settings or user
preferences whenever programatic access and manipulation is desired.

Sample usage:
<cfset preferencesFile = GetDirectoryFromPath(GetCurrentTemplatePath()) &  "myPreferences.cfm" />
<cfset preferences = createObject("component","components.utilities.Preferences").init(preferencesFile) />
Path: /userSettings/tom 
Key: name
Value: Tom
<cfset preferences.put("/userSettings/tom","name", "Tom") />

Path: /userSettings/tom 
Key: themeColor
Value: red
<cfset preferences.put("/userSettings/tom","themeColor", "red") />

--------------------------------------------------
Copyright 2007 Laura Arguello

Licensed under the Apache License, Version 2.0 (the "License"); you may not use the files in this package except in compliance with the License. You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and limitations under the License.
--->

<cfcomponent>

	<cfset variables.xmlData = xmlnew(false) />
	<cfset variables.currentNode = "/preferences/root" />
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="init" access="public" output="false" hint="Contructor">
		<cfargument name="initialData" type="String" required="false" default=""  />
		<cfargument name="node" type="String" required="false" default="/preferences/root" hint="Starting node. Not required" />
			
			<cfset variables.currentNode = arguments.node />
			<cfif len(arguments.initialData)>
				<!--- remove cfsilent just in case --->
				<cfset arguments.initialData = trim(replacenocase(replacenocase(arguments.initialData,"<cfsilent>",""),"</cfsilent>","")) />
				<cfset importPreferences(XmlParse(arguments.initialData)) />
			<cfelse>
				<cfset createNew() />
			</cfif>
			
		<cfreturn this />
	</cffunction>

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="get" access="public" output="false" returntype="any" hint="Returns the value associated with the specified key in this preference node. Returns the specified default if there is no value associated with the key.">
		<cfargument name="pathName" type="String" required="false" hint="Path to preference node" />
		<cfargument name="key" type="String" required="true" hint="key whose associated value is to be returned" />
		<cfargument name="default" type="String" required="false" default="" hint="the value to be returned in the event that this preference node has no value associated with key" />
		
			<cfset var preference = arguments.default />
			<cfset var searchPath = variables.currentNode />
			<cfset var node = "" />
			
			<cfloop list="#arguments.pathName#" index="node" delimiters="/">
				<cfset searchPath = searchPath &  '/node[@name="#node#"]' />
			</cfloop>
			<cfset searchPath = searchPath &  '/map/entry[@key="#key#"]' />
			
			<!--- find node in tree --->
			<cfset node = XmlSearch(variables.xmlData, searchPath) />
			<cfif arraylen(node)>
				<cfset preference = node[1].xmlattributes.value />
			</cfif>
			
		<cfreturn preference />
	</cffunction>

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="remove" access="public" output="false" returntype="void" hint="Removes the value associated with the specified key in this preference node, if any.">
		<cfargument name="pathName" type="String" required="false" hint="Path to preference node" />
		<cfargument name="key" type="String" required="true" hint="key whose mapping is to be removed from the preference node." />
		
		<cfset var mapEntries = "" />
		<cfset var node = "" />
		<cfset var i = 0 />
		
		<cfif nodeexists(arguments.pathName)>
			<cfset node = getNode(arguments.pathName) />
			<cfif structkeyexists(node, "map")>
				<cfloop from="1" to="#arraylen(node.map.xmlChildren)#" index="i">
					<cfif node.map.xmlChildren[i].xmlName EQ "entry" AND 
							node.map.xmlChildren[i].xmlAttributes["key"] EQ arguments.key>
						<cfset arraydeleteat(node.map.xmlChildren, i) />
						<cfbreak />
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		<cfset flush() />
		
		<cfreturn />
	</cffunction>

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="nodeExists" access="public" output="false" returntype="boolean">
		<cfargument name="pathName" type="String" required="false" />
		
		<cfset var searchPath = variables.currentNode />
		<cfset var node = "" />

		<cfloop list="#arguments.pathName#" index="node" delimiters="/">
			<cfset searchPath = searchPath &  '/node[@name="#node#"]' />
		</cfloop>
		
		<!--- find node in tree --->
		<cfset node = XmlSearch(variables.xmlData, searchPath) />
		
		<cfreturn arraylen(node) />
	</cffunction>
	

	<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getNode" access="private" output="false" returntype="xml">
		<cfargument name="pathName" type="String" required="false" hint="Path to preference node" />
		
		<cfset var searchPath = variables.currentNode />
		<cfset var node = "" />

		<cfloop list="#arguments.pathName#" index="node" delimiters="/">
			<cfset searchPath = searchPath &  '/node[@name="#node#"]' />
		</cfloop>
		
		<!--- find node in tree --->
		<cfset node = XmlSearch(variables.xmlData, searchPath) />
		<!--- if not found, this will throw an error --->
		<cfreturn node[1] />
		
	</cffunction>	

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="put" access="public" output="false" returntype="void" hint="Associates the specified value with the specified key in the given preference node">
		<cfargument name="pathName" type="String" required="false" hint="Path to preference node" />
		<cfargument name="key" type="String" required="true" hint="Key with which the specified value is to be associated." />
		<cfargument name="value" type="String" required="false" hint="Value to be associated with the specified key" />
		
			<cfset var newNode = "" />
			<cfset var node = "" />
			<cfset var entry = "" />
			<cfset var i = 0 />
			<cfset var found = false />
			
			<cfif NOT nodeexists(arguments.pathName)>
				<cfset createNode(arguments.pathName) />
			</cfif>
			<cfset node = getNode(arguments.pathName) />
			
			<!--- find key --->
			<cfloop from="1" to="#arraylen(node.map.xmlChildren)#" index="i">
				<cfif node.map.xmlChildren[i].xmlAttributes["key"] EQ arguments.key>
					<cfset found = true />
					<!--- change value --->
					<cfset node.map.xmlChildren[i].xmlAttributes["value"] = arguments.value />
					<cfbreak> 
				</cfif>
			</cfloop>
			
			<cfif NOT found>
				<cfset newNode = XmlElemNew(variables.xmlData,"entry") />
				<cfset newNode.XmlAttributes["key"] = arguments.key />
				<cfset newNode.XmlAttributes["value"] = arguments.value />
				<cfset arrayappend(node.map.xmlChildren,newNode) />
			</cfif>
			
		<cfset flush() />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="removeNode" access="public" output="false" returntype="void" hint="Removes the given preference node and all of its descendants">
		<cfargument name="pathName" type="String" required="true" hint="Path to node to remove" />
		
		<cfset var parentPath = listDeleteAt(arguments.pathName, listlen(arguments.pathName, "/"), "/") />
		<cfset var parent = "" />
		<cfset var i = 0 />
		<cfset var nodeName = listlast(arguments.pathName, "/") />

		<cfif nodeexists(arguments.pathName)>
			<cfset parent = getNode(parentPath) />
			
			<cfloop from="1" to="#arraylen(parent.node)#" index="i">
				<cfif parent.node[i].xmlAttributes.name EQ nodeName>
					<!--- remove it --->
					<cfset arraydeleteat(parent.xmlchildren, xmlChildPos(parent, "node", i)) />
					<cfbreak />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="exportSubtree" access="public" output="false" returntype="xml">
		<cfreturn duplicate(variables.xmlData) />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="exportSubtreeAsStruct" access="public" output="false" returntype="struct" hint="Returns a structure containing the keys and values of the preferences from given node">
		<cfargument name="pathName" type="String" required="false" default="/" hint="Path to node from which to export" />
		
		<!--- go to node --->
		<cfset var node = getNode(arguments.pathName) />
		<cfset var map = structnew() />
		<cfset var i = 0 />
		
		<cfloop from="1" to="#arraylen(node.map.xmlChildren)#" index="i">
			<cfset map[node.map.xmlChildren[i].xmlAttributes["key"]] = node.map.xmlChildren[i].xmlAttributes["value"] />
		</cfloop>
		
		<cfloop from="1" to="#arraylen(node.xmlChildren)#" index="i">
			<!--- ignore the map node --->
			<cfif node.xmlChildren[i].xmlname EQ "node">
				<cfset map[node.xmlChildren[i].xmlAttributes["name"]] = exportSubtreeAsStruct(arguments.pathName & "/" & node.xmlChildren[i].xmlAttributes["name"]) />
			</cfif>
		</cfloop>
		
		<cfreturn map />
	</cffunction>


<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="createNode" access="private" output="false" returntype="void">
		<cfargument name="pathName" type="String" required="true" />
		
		<cfset var nodePath = "" />
		<cfset var searchPath = variables.currentNode />
		<cfset var node = "" />
		<cfset var parentPath = "" />
		<cfset var parent = "" />
		<cfset var newNode = "" />
		<cfset var newMap = "" />
	
		<cfloop list="#arguments.pathName#" index="node" delimiters="/">
			<cfset nodePath = nodePath &  "/" & node />
			<cfset parentPath = searchPath />
			<cfset searchPath = searchPath &  '/node[@name="#node#"]' />
			<cfif NOT nodeexists(nodePath)>
				<cfset newNode = XmlElemNew(variables.xmlData, "node") />
				<cfset newMap = XmlElemNew(variables.xmlData, "map") />
				
				<cfset parent = XmlSearch(variables.xmlData, parentPath) />
				<cfset newNode.XmlAttributes["name"] = node />				
				<cfset arrayappend(newNode.xmlChildren,newMap) />
				<cfset arrayappend(parent[1].xmlChildren,newNode) />
			</cfif>
		</cfloop>

		
	</cffunction>


<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="importPreferences" access="public" output="false" returntype="void">
		<cfargument name="data" type="xml" required="true" />
			
			<cfset variables.xmlData = arguments.data />
			
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="createNew" access="private" output="false" returntype="void">
	
<cfxml casesensitive="false" variable="variables.xmlData"><?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE preferences SYSTEM 'http://java.sun.com/dtd/preferences.dtd'>				
<preferences EXTERNAL_XML_VERSION="1.0">
	<root type="system">
		<map />				    
	</root>
</preferences>			
</cfxml>
			
			<cfset flush() />
			
	</cffunction>
	
<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="flush" access="public" output="false" returntype="void" hint="Saves any changes in the contents of the preferences to the persistent store">
		<!--- doesn't do anything... --->		
	</cffunction>		
	
</cfcomponent>