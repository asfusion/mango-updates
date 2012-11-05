<cfcomponent name="RoleManager">

	<cfset variables.accessObject = "">

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainApp" required="true" type="any">
		<cfargument name="accessObject" required="true" type="any">
		<cfargument name="pluginQueue" required="true" type="PluginQueue">
			
			<cfset variables.factory = arguments.accessObject />
			<cfset variables.accessObject = arguments.accessObject.getRolesGateway()>
			<cfset variables.daoObject = arguments.accessObject.getRoleManager()>
			<cfset variables.pluginQueue = arguments.pluginQueue />
			
			<cfset variables.mainApp = arguments.mainApp />
			<cfset variables.objectFactory = variables.mainApp.getObjectFactory()>

			<cfreturn this />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getRoles" access="public" output="false" returntype="array">
		
		<cfset var rolesQuery = variables.accessObject.getAll() />
		<cfset var roles = packageObjects(rolesQuery) />		
		
		<cfreturn roles />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getRoleById" access="public" output="false" returntype="any">
		<cfargument name="id" required="true" type="string">
		<cfset var rolesQuery = variables.accessObject.getById(arguments.id) />
		<cfset var roles = packageObjects(rolesQuery) />		
		
		<cfif arraylen(roles)>
			<cfreturn roles[1] />
		<cfelse>
			<cfthrow errorcode="RoleNotFound" message="Role was not found" type="RoleNotFound">
		</cfif>
		
		<cfreturn roles />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getPermissions" access="public" output="false" returntype="array">
		
		<cfset var rolesQuery = variables.accessObject.getAllPermissions() />
		<cfset var roles = packagePermissions(rolesQuery) />		
		
		<cfreturn roles />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getRoleByPermissions" access="public" returntype="any" hint="throws RoleNotFound">
		<cfargument name="permissions" type="string" />
		
		<cfset var roles = getRoles() />
		<cfset var j = 0 />
		<cfset var role = '' />
		<cfset var found = false />
		
		<cfscript>
		for (j = 1; j LTE arraylen(roles); j = j +1) {	
			found = NOT len(listDiff(permissions, roles[j].permissions));
			
			if (found){
				role = roles[j];
				break;
			}
		}
  		</cfscript>
		<cfif not found>
			<cfthrow errorcode="RoleNotFound" message="Role was not found" type="RoleNotFound">
		</cfif>
		<cfreturn role />
		
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="packageObjects" access="private" output="false" returntype="array">
		<cfargument name="objectsQuery" required="true" type="query">
		
		<cfset var roles = arraynew(1) />
		<cfset var thisObject = "" />
		<cfset var factory =  variables.objectFactory />

		<cfoutput query="arguments.objectsQuery" group="id">
			<cfset thisObject = factory.createRole() />
			<cfset thisObject.id = id />
			<cfset thisObject.name = name />
			<cfset thisObject.description = description />
			<cfset thisObject.preferences = createObject("component","utilities.Preferences").init(preferences) />
			<cfoutput>
				<cfset thisObject.permissions = listappend(thisObject.permissions,permission)>
			</cfoutput>
			<cfset arrayappend(roles,thisObject) />
		</cfoutput>

		<cfreturn roles />
	</cffunction>
	
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="packagePermissions" access="private" output="false" returntype="array">
		<cfargument name="objectsQuery" required="true" type="query">
		
		<cfset var permissions = arraynew(1) />
		<cfset var thisObject = "" />
		<cfset var factory =  variables.objectFactory />

		<cfoutput query="arguments.objectsQuery">
			<cfset thisObject = factory.createPermission() />
			<cfset thisObject.id = id />
			<cfset thisObject.name = name />
			<cfset thisObject.description = description />
			<cfset thisObject.isCustom = is_custom />
			<cfset arrayappend(permissions,thisObject) />
		</cfoutput>

		<cfreturn permissions />
	</cffunction>
	

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
<cffunction name="addRole" access="package" output="false" returntype="struct">
		<cfargument name="role" required="true" type="any">
		<cfargument name="rawData" required="true" type="struct">
			
		<cfscript>
				var thisObject = arguments.role;
				var valid = "";
				var event = "";
				var newResult = "";
				var message = createObject("component","Message");
				var status = "";
				var returnObj = structnew();
				var msgText = "";
				var eventObj = structnew();
				var data = structnew();
				var util = createObject("component","Utilities");
				var pluginQueue = variables.mainApp.getPluginQueue();
				var i = 0;
				var isDuplicate = true;
				var newId = '';
				
				message.setType("role");
				
				if(NOT len(thisObject.getId())){
					thisObject.id = util.makeCleanString(thisObject.getName());
					newId = thisObject.id;			
				}
				isDuplicate = variables.accessObject.getById(newId).recordcount GT 0;
				
				//remove duplicates
				while(isDuplicate) {
					i = i + 1;
					newId = thisObject.id & "-" & i;
					isDuplicate = variables.accessObject.getById(newId).recordcount GT 0;
				}
				thisObject.id = newId;
				
				//call plugins
				eventObj.role = thisObject;
				eventObj.rawdata = arguments.rawData;
				eventObj.newItem = thisObject;
				
				event = pluginQueue.createEvent("beforeRoleAdd",eventObj,"Update");
				event = pluginQueue.broadcastEvent(event);
			
				thisObject = event.getData().role;
				if(event.getContinueProcess()){
				
					valid = thisObject.isValidForSave();
					if(valid.status){					
						newResult = variables.daoObject.create(thisObject);			
						
						if(newResult.status){
							status = "success";
							event = pluginQueue.createEvent("afterRoleAdd",thisObject,"Update");
							event = pluginQueue.broadcastEvent(event);
							thisObject = event.getData();
						}
						else{
							status = "error";
						}
						message.setStatus(status);
						message.setText(newResult.message);
					}
					else {
						for (i = 1; i LTE arraylen(valid.errors);i=i+1){
							msgText = msgText & "<br />" & valid.errors[i];
						}
						message.setStatus("error");
						message.setText(msgText);
					}
				}
			</cfscript>
		<cfset returnObj.data = rawData />	
		<cfset returnObj.newRole = thisObject />
		<cfset returnObj.message = message />

		<cfreturn returnObj />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
<cffunction name="editRole" access="package" output="false" returntype="struct">
		<cfargument name="role" required="true" type="any">
		<cfargument name="rawData" required="true" type="struct">
		<cfscript>
				var thisObject = arguments.role;
				var valid = "";
				var event = "";
				var newResult = "";
				var message = createObject("component","Message");
				var status = "";
				var returnObj = structnew();
				var msgText = "";
				var eventObj = structnew();
				var data = structnew();
				var util = createObject("component","Utilities");
				var i = 0;
				
				message.setType("role");
				
				thisObject.oldId = thisObject.id;
				thisObject.id = util.makeCleanString(thisObject.getName());
				
				//call plugins
				eventObj.rawdata = arguments.rawData;
				eventObj.newItem = thisObject;
				eventObj.oldItem = getRoleById(thisObject.oldId);
				
				event = variables.pluginQueue.createEvent("beforeRoleUpdate",eventObj,"Update");
				event = variables.pluginQueue.broadcastEvent(event);
			
				thisObject = event.getnewItem();
				if(event.getContinueProcess()){
				
					valid = thisObject.isValidForSave();	
					if(valid.status){
						newResult = variables.daoObject.update(thisObject);					
						
						if(newResult.status){
							status = "success";
							event = variables.pluginQueue.createEvent("afterRoleUpdate",eventObj,"Update");
							event = variables.pluginQueue.broadcastEvent(event);
							thisObject = event.getnewItem();
						}
						else{
							status = "error";
						}
						message.setStatus(status);
						message.setText(newResult.message);
					}
					else {
						for (i = 1; i LTE arraylen(valid.errors);i=i+1){
							msgText = msgText & "<br />" & valid.errors[i];
						}
						message.setStatus("error");
						message.setText(msgText);
					}
				}
			</cfscript>
		<cfset returnObj.data = rawData />	
		<cfset returnObj.newRole = thisObject />
		<cfset returnObj.message = message />

		<cfreturn returnObj />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="deleteRole" access="package" output="false" returntype="struct">
		<cfargument name="comment" required="true" type="any">
		<cfargument name="rawData" required="true" type="struct">
		<cfargument name="user" required="false" type="any">
			
			<cfscript>
				var thisObject = arguments.comment;
				var event = "";
				var newResult = "";
				var message = createObject("component","Message");
				var status = "";
				var returnObj = structnew();
				var msgText = "";
				var eventObj = structnew();
				var data = structnew();
				
				message.setType("comment");
				
				//call plugins
				eventObj.comment = thisObject;
				eventObj.rawdata = arguments.rawData;
				eventObj.oldItem = thisObject;
				eventObj.changeByUser = arguments.user;
				
				event = variables.pluginQueue.createEvent("beforeCommentDelete",eventObj,"Delete");
				event = variables.pluginQueue.broadcastEvent(event);
			
				thisObject = event.getoldItem();
				if(event.getContinueProcess()){
			
						newResult = variables.daoObject.delete(thisObject.getId());					
						
						
						if(newResult.status){
							status = "success";
							event = variables.pluginQueue.createEvent("afterCommentDelete",eventObj,"Delete");
							event = variables.pluginQueue.broadcastEvent(event);
							thisObject = event.getoldItem();
						}
						else{
							status = "error";
						}
						message.setStatus(status);
						message.setText(newResult.message);				
				}
			</cfscript>
		<cfset returnObj.data = rawData />	
		<cfset returnObj.oldRole = thisObject />
		<cfset returnObj.message = message />

		<cfreturn returnObj />
	</cffunction>

	<cffunction name="listDiff" access="private">
		<cfargument name="list1">
		<cfargument name="list2">


		<cfscript>
		/**
		* Compares two lists and returns the elements that do not appear in both lists.
		Returns a list that contains the elementsrest between list1 and list2
		*
		* @param list1      First list to compare (Required)
		* @param list2      Second list to compare (Required)
		* @param delimiters      Delimiter for all lists. Defualt is comma. (Optional)
		* @return Returns a string.
		* @author Ivan Rodriguez (wantez015 @ hotmail.com)
		* @version 1, June 26, 2002
		*/
			var delimiters    = ",";
			var listReturn = "";
			var position = 1;
			
			// default list delimiter to a comma unless otherwise specified    
			if (arrayLen(arguments) gte 3){
				delimiters = arguments[3];
			}
			        
			//checking list1
			for(position = 1; position LTE ListLen(list1,delimiters); position = position + 1) {
				value = ListGetAt(list1, position , delimiters );
				if (ListFindNoCase(list2, value , delimiters ) EQ 0)
					listReturn = ListAppend(listReturn, value , delimiters );
			}
			        
			//checking list2
			for(position = 1; position LTE ListLen(list2,delimiters); position = position + 1)    {
				value = ListGetAt(list2, position , delimiters );
				if (ListFindNoCase(list1, value , delimiters ) EQ 0)
					listReturn = ListAppend(listReturn, value , delimiters );
			}
			return listReturn;
		</cfscript>
	</cffunction>
</cfcomponent>