<cfcomponent>
	
	<cffunction name="copyFiles" returntype="void" output="true">
		<cfargument name="folderFrom" />
		<cfargument name="folderTo" />
		<cfargument name="name" />
		
		<cfset var local = structnew() />
		<cfset local.thisDir = getDirectoryFromPath(GetCurrentTemplatePath()) />
		
		<!--- make a zip of the subdirs, and then unzip them in their final location,
			this is easier than try to recurse over the directories --->
		<cfset local.currentZipDir = local.thisDir & "blog" />
		<cfset local.currentzip = local.thisDir & arguments.name & ".zip" />
					
		<cfset zipFileNew(local.currentzip, arguments.folderFrom, arguments.folderFrom) />
		<cfset unzipFile(local.currentzip, arguments.folderTo) />
		
	</cffunction>
	
	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cfscript>
/**
 * Create a zip file of a directory or just a file.
 * 
 * @param zipPath 	 File name of the zip to create. (Required)
 * @param toZip 	 Folder or full path to file to add to zip. (Required)
 * @param relativeFrom 	 Some or all of the toZip path, from which the entries in the zip file will be relative (Optional)
 * @return Returns nothing. 
 * @author Nathan Dintenfass (nathan@changemedia.com) 
 * @version 1.1, January 19, 2004 
 */
function zipFileNew(zipPath,toZip){
	//make a fileOutputStream object to put the ZipOutputStream into
	var output = createObject("java","java.io.FileOutputStream").init(zipPath);
	//make a ZipOutputStream object to create the zip file
	var zipOutput = createObject("java","java.util.zip.ZipOutputStream").init(output);
	//make a byte array to use when creating the zip
	//yes, this is a bit of hack, but it works
	var byteArray = repeatString(" ",1024).getBytes();
	//we'll need to create an inputStream below for writing out to the zip file
	var input = "";
	//we'll be making zipEntries below, so make a variable to hold them
	var zipEntry = "";
	var zipEntryPath = "";
	//we'll use this while reading each file
	var len = 0;
	//a var for looping below
	var ii = 1;
	//a an array of the files we'll put into the zip
	var fileArray = arrayNew(1);
	//an array of directories we need to traverse to find files below whatever is passed in
	var directoriesToTraverse = arrayNew(1);
	//a var to use when looping the directories to hold the contents of each one
	var directoryContents = "";
	//make a fileObject we can use to traverse directories with
	var fileObject = createObject("java","java.io.File").init(toZip);
	//which part of the file path should be excluded in the zip?
	var relativeFrom = "";
	
	//if there is a 3rd argument, that is the relativeFrom value
	if(structCount(arguments) GT 2){
		relativeFrom = arguments[3];
	}
	
	//
	// first, we'll deal with traversing the directory tree below the path passed in, so we get all files under the directory
	// in reality, this should be a separate function that goes out and traverses a directory, but cflib.org does not allow for UDF's that rely on other UDF's!!
	//
	
	//if this is a directory, let's set it in the directories we need to traverse
	if(fileObject.isDirectory())
		arrayAppend(directoriesToTraverse,fileObject);
	//if it's not a directory, add it the array of files to zip
	else
		arrayAppend(fileArray,fileObject);	
	//now, loop through directories iteratively until there are none left
	while(arrayLen(directoriesToTraverse)){
		//grab the contents of the first directory we need to traverse
		directoryContents = directoriesToTraverse[1].listFiles();
		//loop through the contents of this directory
		for(ii = 1; ii LTE arrayLen(directoryContents); ii = ii + 1){			
			//if it's a directory, add it to those we need to traverse
			if(directoryContents[ii].isDirectory())
				arrayAppend(directoriesToTraverse,directoryContents[ii]);	
			//if it's not a directory, add it to the array of files we want to add
			else
				arrayAppend(fileArray,directoryContents[ii]);	
		}
		//now kill the first member of the directoriesToTraverse to clear out the one we just did
		arrayDeleteAt(directoriesToTraverse,1);
	} 
	
	//
	// And now, on to the zip file
	//
	
	//let's use the maximum compression
	zipOutput.setLevel(9);
	//loop over the array of files we are going to zip, adding each to the zipOutput
	for(ii = 1; ii LTE arrayLen(fileArray); ii = ii + 1){
		//make a fileInputStream object to read the file into
		input = createObject("java","java.io.FileInputStream").init(fileArray[ii].getPath());
		//make an entry for this file
		zipEntryPath = fileArray[ii].getPath();
		//if we are making the zip relative from a certain directory, exclude that from the zipEntryPath
		if(len(relativeFrom)){
			zipEntryPath = replace(zipEntryPath,relativeFrom,"");
		} 
		zipEntry = createObject("java","java.util.zip.ZipEntry").init(zipEntryPath);
		//put the entry into the zipOutput stream
		zipOutput.putNextEntry(zipEntry);
		// Transfer bytes from the file to the ZIP file
		len = input.read(byteArray);
		while (len GT 0) {
			zipOutput.write(byteArray, 0, len);
			len = input.read(byteArray);
		}
		//close out this entry
		zipOutput.closeEntry();
		input.close();
	}
	//close the zipOutput
	zipOutput.close();
	//return nothing
	return "";
}

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
	
</cfcomponent>