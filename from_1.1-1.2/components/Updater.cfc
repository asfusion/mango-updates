<cfcomponent>
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="applicationManager" required="true" type="any">
		<cfargument name="configFile" required="false" type="string" default="" hint="Path to config file"/>
		<cfargument name="baseDirectory" type="string" required="true" />
			
			<cfset variables.blogManager = arguments.applicationManager />
			<cfset variables.configFile = arguments.configFile />
			<cfset variables.baseDirectory = arguments.baseDirectory />
			
		<cfreturn this />
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="downloadSkin" access="public" output="false" returntype="struct">
		<cfargument name="skin" type="String" required="true" />
			<cfset var ftp = "" />
			<cfset var connection = "" />
			<cfset var skinInfo = "" />
			<cfset var exists = "">
			<cfset var skinsDir = variables.blogManager.getBlog().getSetting('skinsDirectory') />
			<cfset var result = structnew()/>
			
			<cfset result.message = createObject("component","Message") />
					
			<cfset result.message.setstatus("success") />
			<cfset result.message.setText("Skin downloaded and available to use") />
			
			<cftry>
				<!--- check if this skin is compatible --->
				<cfinvoke webservice="http://www.mangoblog.org/services/Update.cfc?wsdl" method="getSkinInfo" timeout="5" returnvariable="skinInfo"><cfinvokeargument name="skin" value="#arguments.skin#"></cfinvoke>
				<cfif versionCompare(skinInfo.requiresVersion, variables.blogManager.getVersion()) LT 1>
					<!--- try to get ftp data from web service --->
					<cfinvoke webservice="http://www.mangoblog.org/services/Update.cfc?wsdl" method="getSkinFTP" timeout="5" returnvariable="ftp">
					
					<cftry>
						<!--- open connection and check if it exists --->
						<cfftp connection="connection" server="#ftp.server#"  username="#ftp.username#" 
					password="#ftp.password#" stoponerror="Yes" action="open" passive="true">
						<cfftp action="existsdir" directory="#ftp.directory##arguments.skin#" connection="connection" result="exists">
						<cfif exists.returnValue>
							<!--- download it and  save skin in skin directory --->
							<cfset ftpcopy(ftp.server, ftp.username, ftp.password, "#ftp.directory##arguments.skin#", skinsDir) />
						<cfelse>
							<cfset result.message.setstatus("error") />
							<cfset result.message.setText("Selected skin cannot be found.") />
						</cfif>
						<cfcatch type="any">
							<!--- try simple download->unzip route --->
							<cftry>
								<cfset httpDownload(skinInfo.downloadUrl, skinsDir & arguments.skin & "/")>
							
								<cfcatch type="any"><!--- didn't work out either --->
									<cfset result.message.setstatus("ftp_error") />
									<cfset result.message.setText(skinInfo.downloadUrl) />
								</cfcatch>
							</cftry>
						</cfcatch>
					</cftry>
				<cfelse>
					<cfset result.message.setstatus("error") />
					<cfset result.message.setText("Selected skin requires a newer version of Mango Blog than the one it is installed.") />
				</cfif>
			 
				<cfcatch type="any">
					<cfset result.message.setstatus("error") />
					<cfset result.message.setText(cfcatch.Message) />
				</cfcatch>
			</cftry>
		<cfreturn result />
	</cffunction>	
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="checkForUpdates" access="public" output="false" returntype="string">
		<cfset var latestVersion = 0 />
		<cfset var message = "">
		
		<cftry>
			<cfinvoke webservice="http://www.mangoblog.org/services/Update.cfc?wsdl" 
						method="getCurrentVersionNumber" timeout="5" returnvariable="latestVersion">

			<cfif versionCompare(latestVersion, variables.blogManager.getVersion()) EQ 1>
				<cftry>
				<cfinvoke webservice="http://www.mangoblog.org/services/Update.cfc?wsdl" method="getUpdateInstructions" timeout="10" returnvariable="message">
					<cfinvokeargument name="version" value="#variables.blogManager.getVersion()#">
				</cfinvoke>
					
					<cfcatch type="any">
						<!--- since I changed the methods on the webservice, it is possible 
						that this server has the definitions cached. So, for the moment, try another url --->
						<cfinvoke webservice="http://www.mangoblog.org/services/Update2.cfc?wsdl" method="getUpdateInstructions" timeout="10" returnvariable="message">
							<cfinvokeargument name="version" value="#variables.blogManager.getVersion()#">
						</cfinvoke>
					</cfcatch>
				</cftry>
			</cfif>
			
			<cfcatch type="any"></cfcatch>
		</cftry>
		
		<cfreturn message />
		
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="executeUpdate" access="public" output="true">
		<cfset var updatePlan = arraynew(1) />
		<cfset var i = 0 />
		<cfset var stepResult = structnew() />
		<cfset var serverVersion = structnew() />
		
		<cfset stepResult.message = createObject("component","Message") />
					
		<cfset stepResult.message.setstatus("success") />
		<cfset stepResult.message.setText('Update done') />
		
		<cftry>
			<cfif structkeyexists(server, "coldfusion")>
				<cfset serverVersion.productname = server.coldfusion.productname />
				<cfset serverVersion.productversion = server.coldfusion.productversion />
			</cfif>
			
			<cftry>
				<!--- call Mango services to get the upgrade plan --->
				<cfinvoke webservice="http://www.mangoblog.org/services/Update.cfc?wsdl" method="getUpdatePlan" 
							timeout="10" returnvariable="updatePlan">
					<cfinvokeargument name="version" value="#variables.blogManager.getVersion()#">
					<cfinvokeargument name="serverInfo" value="#serverVersion#">
				</cfinvoke>
				
				<cfcatch type="any">
					<!--- since I changed the methods on the webservice, it is possible 
						that this server has the definitions cached. So, for the moment, try another url --->
						<cfinvoke webservice="http://www.mangoblog.org/services/Update2.cfc?wsdl" method="getUpdatePlan" timeout="10" returnvariable="updatePlan">
							<cfinvokeargument name="version" value="#variables.blogManager.getVersion()#">
							<cfinvokeargument name="serverInfo" value="#serverVersion#">
						</cfinvoke>
				</cfcatch>
			</cftry>
			
			<cfloop from="1" to="#arraylen(updatePlan)#" index="i">
			<p>	<strong>Updating to version #updatePlan[i].updatesToVersion#</strong><br /><br /></p>
				<cfset stepResult = downloadUpdate(updatePlan[i].updateFileUrl, 
										updatePlan[i].runnerFile,
										updatePlan[i].fileIsZip) />
				
				<cfif stepResult.message.getStatus() NEQ "success">
					<cfreturn stepResult />
				</cfif>
			</cfloop>
			
			<cfset variables.blogManager.removeCurrentUser() />
			<cfset variables.blogManager.reloadConfig() />
			
			<cfcatch type="any">
				<cfset stepResult.message.setstatus("error") />
				<cfset stepResult.message.setText("Upgrade could not be performed: " & cfcatch.Message) />
			</cfcatch>
		</cftry>
	
		<cfreturn stepResult />
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<!--- very important function. It will download and replace files and do everything needed to
	update mango's version --->
	<cffunction name="downloadUpdate" access="public" output="true" returntype="struct">
		<cfargument name="remoteUpdateFile" type="string" required="true" />
		<cfargument name="runnerFile" type="string" required="true" />
		<cfargument name="isZipped" type="boolean" required="false" default="false" />
		
		<cfset var tempDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "updater_temp/" />
		<cfset var result = structnew()/>
		<cfset var local = structnew() />
		
		<cfset local.baseDirectory = variables.baseDirectory />
		<cfset local.configFile = variables.configFile />
		<cfset local.componentsPath = GetDirectoryFromPath(GetCurrentTemplatePath()) />

		<cfset result.message = createObject("component","Message") />
					
		<cfset result.message.setstatus("success") />
		<cfset result.message.setText('<br /><strong>Updated done!</strong><br />
		You will now be logged out. <a href="index.cfm">Click here to continue</a>.') />
		
		<cftry>
			<p>Downloading files... 
			
			<!--- the simplest way is to download one file and then simply include it and run it... --->
			<cfset httpDownload(arguments.remoteUpdateFile, tempDir, arguments.isZipped) />
			done <br />
			Starting the update</p>
			<cfinclude template="updater_temp/#runnerFile#" />
			
			
			<!--- remove update files --->
			<p>Deleting temporary files...
			<cfdirectory action="delete" directory="#tempDir#" recurse="true">
			done
			</p>
			<cfcatch type="any">
				<cfset result.message.setstatus("error") />
				<cfset result.message.setText("Upgrade could not be performed: " & cfcatch.Message) />
			</cfcatch>
		</cftry>
		
		<cfreturn result />
	</cffunction>
	
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="ftpcopy" access="private" output="false">
		<cfargument name="server" required="true" type="any">
		<cfargument name="username" required="true" type="string">
		<cfargument name="password" required="true" type="string">
		<cfargument name="dir" required="true" type="any">
		<cfargument name="localdir" required="true" type="string">
		
		<cfset var dirs = "" />
		
		<!--- create local dir if needed --->
		<cfif NOT directoryExists(arguments.localdir & arguments.dir)>
			<cfdirectory action="create" directory="#arguments.localdir##arguments.dir#">
		</cfif>
		
		<cfftp server="#arguments.server#"  username="#arguments.username#"  passive="true"
				password="#arguments.password#" action="listdir" name="dirs" directory="#arguments.dir#">
				
		<cfoutput query="dirs">
			<cfif isDirectory>
				<!--- copy folder --->
				<cfset ftpcopy(arguments.server, arguments.username, arguments.password,
						Path, arguments.localdir)>
			<cfelse>
				<!--- copy file --->
				<cfftp server="#arguments.server#"  username="#arguments.username#" 
				password="#arguments.password#"  passive="true"
				action="getFile" localfile="#arguments.localdir##path#"
				remotefile="#path#"
 				failifexists="No">
			</cfif>
			
		</cfoutput>
		
	</cffunction>

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="httpDownload" access="private" output="false">
		<cfargument name="zipAddress" required="true" type="any">
		<cfargument name="localdir" required="true" type="string">
		<cfargument name="isZip" required="false" type="boolean" default="true">
		
		<cfset var tempdir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "temp/">
		<cfset var zip = "" />
		<cfset var filename = listlast(zipaddress,"/") />
		
		<cfif NOT directoryexists(tempdir)>
			<cfdirectory action="create" directory="#tempdir#">
		</cfif>
		
		<cfhttp url="#arguments.zipAddress#" method="get" path="#tempdir#">
		
		<cfif NOT directoryexists(localdir)>
			<cfdirectory action="create" directory="#localdir#">
		</cfif>
		
		<cfif arguments.isZip>
			<cfset unzipFile(tempdir & filename, localdir) />
		<cfelse><!--- not a zip file, simply copy it to the destination directory --->
			<cffile action="copy" source="#tempdir##filename#" destination="#localdir#">
		</cfif>
		
		<!--- delete the zip file --->
		<cftry>
			<!--- if we did everything but couldn't delete the zip, no big deal --->
			<cffile action="delete" file="#tempdir##filename#" />
			<cfdirectory action="delete" directory="#tempdir#" recurse="true">
			<cfcatch type="any"></cfcatch>
		</cftry>
		<cfreturn />
	</cffunction>
	

<cfscript>
/**
 * Unzips a file to the specified directory.
 * 
 * @param zipFilePath 	 Path to the zip file (Required)
 * @param outputPath 	 Path where the unzipped file(s) should go (Required)
 * @return void 
 * @author Samuel Neff (sam@serndesign.com) 
 * @version 1, September 1, 2003 
 */
function unzipFile(zipFilePath, outputPath) {
	var zipFile = ""; // ZipFile
	var entries = ""; // Enumeration of ZipEntry
	var entry = ""; // ZipEntry
	var fil = ""; //File
	var inStream = "";
	var filOutStream = "";
	var bufOutStream = "";
	var nm = "";
	var pth = "";
	var lenPth = "";
	var buffer = "";
	var l = 0;
     
	zipFile = createObject("java", "java.util.zip.ZipFile");
	zipFile.init(zipFilePath);
	
	entries = zipFile.entries();
	
	while(entries.hasMoreElements()) {
		entry = entries.nextElement();
		if(NOT entry.isDirectory()) {
			nm = entry.getName(); 
			
			lenPth = len(nm) - len(getFileFromPath(nm));
			
			if (lenPth) {
			pth = outputPath & left(nm, lenPth);
		} else {
			pth = outputPath;
		}
		if (NOT directoryExists(pth)) {
			fil = createObject("java", "java.io.File");
			fil.init(pth);
			fil.mkdirs();
		}
		filOutStream = createObject(
			"java", 
			"java.io.FileOutputStream");
		
		filOutStream.init(outputPath & nm);
		
		bufOutStream = createObject(
			"java", 
			"java.io.BufferedOutputStream");
		
		bufOutStream.init(filOutStream);
		
		inStream = zipFile.getInputStream(entry);
		buffer = repeatString(" ",1024).getBytes(); 
		
		l = inStream.read(buffer);
		while(l GTE 0) {
			bufOutStream.write(buffer, 0, l);
			l = inStream.read(buffer);
		}
		inStream.close();
		bufOutStream.close();
		}
	}
	zipFile.close();
}
</cfscript>




<cffunction name="versionCompare" returntype="numeric" access="public">
	<cfargument name="version1">
	<cfargument name="version2">

	<cfset var len1 = listlen(arguments.version1,".") />
	<cfset var len2 = listlen(arguments.version2,".") />
	<cfset var i = 0/>
	<cfset var piece1 = ""/>
	<cfset var piece2 = ""/>
	
	<cfif len1 GT len2>
		<cfset arguments.version2 = arguments.version2 & repeatstring(".0",len1-len2) />
	</cfif>
	
	<cfif len1 LT len2>
		<cfset arguments.version1 = arguments.version1 & repeatstring(".0",len2-len1) />
	</cfif>
	
	<cfloop from="1" to="#listlen(arguments.version1,".")#" index="i">
		<cfset piece1 = listgetat(arguments.version1,i,".")/>
		<cfset piece2 = listgetat(arguments.version2,i,".")/>
		
		<cfif piece1 NEQ piece2>
			<!--- we need to compare --->
			<cfif piece1 GT piece2>
				<cfreturn 1/>
			<cfelse>
				<cfreturn -1/>
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- they were equal --->
	<cfreturn 0/>
	
</cffunction>


	
</cfcomponent>