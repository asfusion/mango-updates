<cfparam name="step" default="1">
<cfparam name="datasourceExists" default="" />
<cfparam name="message" default="">
<cfparam name="error" default="">
<cfparam name="dbType" default="">
<cfparam name="prefix" default="">
<cfparam name="prefix_new" default="">
<cfparam name="dbtype_new" default="">
<cfparam name="datasource_new" default="">
<cfparam name="password_new" default="">
<cfparam name="username_new" default="">
<cfparam name="database_new" default="">
<cfparam name="server_new" default="">
<cfparam name="datasource" default="">
<cfparam name="blog_address" default="http://#cgi.HTTP_HOST##replacenocase(cgi.script_name,'admin/setup/setup.cfm','')#">
<cfparam name="blog_address_blogcfc" default="http://#cgi.HTTP_HOST##replacenocase(cgi.script_name,'admin/setup/setup.cfm','')#">
<cfparam name="blog_address_wordpress" default="http://#cgi.HTTP_HOST##replacenocase(cgi.script_name,'admin/setup/setup.cfm','')#">
<cfparam name="blog_title" default="My Mango Blog">
<cfparam name="email" default="">
<cfparam name="email_wordpress" default="">
<cfparam name="blogcfcini" default="">
<cfparam name="mangoConfig" default="">

<cfset pluginspath = expandPath("../../components/plugins/") />

<cfflush interval="5">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Mango Blog Setup</title>
<link href="../assets/wforms/antique/wforms.css" rel="stylesheet" type="text/css" />
<link href="../assets/wforms/antique/wforms-jsonly.css" rel="alternate stylesheet" type="text/css" title="stylesheet activated by javascript" />
<script type="text/javascript" src="../assets/wforms/wforms.js" ></script>

<style>
	#logo {
		background:url("../assets/images/logo.png") no-repeat;
		height:46px;
		width:174px;
	}
	
	#logo span {
		margin:0;
		display:none;
	}
	body {
		font-family: 'Trebuchet MS', 'Lucida Grande', Verdana, Arial, Sans-Serif;
	}
	h2 {
		font-family: Arial, Sans-Serif;
	}
	h2 {
		border-bottom: 1px solid #800000;
	}
	
	p, div.message {
		padding: 1em;
	}
	.message {
		background-color:#FFFFCC;
		border: 1px solid #ffd540;
	}
	
.field-hint , .field-hint-inactive{
	width: 65%;
	min-height: 2em;
	float: right;
	clear: right;
	font-size: 85%;
	padding: 0 0 0 20px ;
}

.field-hint {
	color: #000;	
	background-image: url(../assets/wforms/tfa-bracket.gif);
	background-repeat: no-repeat;
	background-position: left center;	
}
/* Field-Hint without focus */
.field-hint-inactive {
	color: #666;

}

</style>

</head>
<body>


<h1 id="logo"><span>Mango</span></h1>

<h2>Setup Wizard</h2>

<cfif isdefined("form.submit")>
<cfswitch expression="#step#">
<cfcase value="1">
	<cfset setupObj = CreateObject("component", "Setup")/>
	<cfif form.datasourceExists>
		<!--- use an already created datasource --->
		<cfset setupObj.init(form.datasource, form.dbType, form.prefix)/>
		<cfset result = setupObj.setupDatabase()/>
	<cfelse>
		<!--- create it --->
		<cfset dsn = structnew() />
		<cfset dsn.cfadminpassword = form.cfadminpassword_new/>
		<cfset dsn.datasourcename =  form.datasource_new/>
		<cfset dsn.dbName = form.database_new />
		<cfset dsn.host = form.server_new />
		<cfset dsn.dbType = form.dbtype_new  />
		<cfset dsn.username = form.username_new />
		<cfset dsn.password = form.password_new />
		<cfset result = setupObj.addCFDatasource(argumentcollection=dsn)/>
			<cfif result.status>
				<cfset setupObj.init(form.datasource_new, form.dbtype_new, form.prefix_new)/>
				<cfset result = setupObj.setupDatabase()/>
				<cfset datasource = datasource_new />
				<cfset dbType = dbtype_new />
				<cfset prefix = prefix_new />
			</cfif>
	</cfif>
	<cfif result.status>
		<cfset step = 2 />
		
	<cfelse>
		<cfset error = result.message />
	</cfif>
</cfcase>

<cfcase value="2">
	<cfset setupObj = CreateObject("component", "Setup").init(form.datasource, form.dbType, form.prefix)/>
		<cfset path = expandPath("../../") />
		
		
					
	<!--- new blog --->
	<cfif form.isblognew>
		<cfset result = setupObj.saveConfig(path,pluginspath,"",email)/>
		
		<cfif result.status>
			<cfset result = setupObj.addBlog(form.blog_title, form.blog_address)/>
				<cfif result.status>
					<cfset result = setupObj.addAuthor(form.name, form.username, form.password,form.email)/>
					<cfset result = setupObj.addData() />
					
				
					<cfif NOT result.status>
						<cfset error = result.message />
					</cfif>
					<cfset step = 3 />
					<cfset setupObj.setupPlugins() />
				<cfelse>
					<cfset error = result.message />
				</cfif>
			
		<cfelse>
			<cfset error = result.message />
		</cfif>
	
	<cfelseif NOT form.isblognew>
	<!--- import --->
		<cfswitch expression="#form.blogengine#">
	
		<!--- wordpress --->
	
		<cfcase value="blogCFC">
			<!--- blogCFC --->
			<cftry>
				<div class="message">
					<cfset importObj = CreateObject("component", "Importer_BlogCFC_5x").init(path,form.blogcfcini,form.datasource, form.dbType, form.prefix,pluginspath)/>
					<cfset result = importObj.import(form.blog_address_blogcfc) />
					
				</div>
				<cfif NOT result.status>
					<cfset error = result.message />
				<cfelse>
					<cfset setupObj.setupPlugins() />
					<cfset step = 3/>
				</cfif>
				<cfcatch type="any">
					</div>
					<cfset error = cfcatch.message & ": " & cfcatch.detail />
				</cfcatch>
			</cftry>
		</cfcase>

		<cfcase value="wordpress">
			<!--- Upload exported file --->
			<cftry>
				<cffile action="upload" destination="#expandPath('.')#" filefield="wf_Exporteddatafile" nameconflict="overwrite">
				<cfif cffile.fileWasSaved>
					
					<cftry>
						<div class="message">
							<cfset importObj = CreateObject("component", "Importer_Wordpress").init(path,"/Applications/JRun4/servers/cfusion/cfusion-ear/cfusion-war/mango/admin/setup/wordpress.2007-11-11.xml",
									form.datasource, form.dbType, form.prefix,pluginspath)/>
							<cfset result = importObj.import(form.blog_address_wordpress, form.email_wordpress) />
							
						</div>
						<cfif NOT result.status>
							<cfset error = result.message />
						<cfelse>
							<cfset setupObj.setupPlugins() />
							<cfset step = 3/>
						</cfif>
						<cfcatch type="any">
							</div>
							<cfset error = cfcatch.message & ": " & cfcatch.detail />
						</cfcatch>
					</cftry>
					
				<cfelse>
					<cfset error = "File could not be saved">	
				</cfif>
				<cfcatch type="any">
					<cfset error = cfcatch.message & ": " & cfcatch.detail />
				</cfcatch>
			</cftry>
			
		</cfcase>
		<!--- <cfcase value="mango">
			<!--- Mango --->
			<cftry>
				<div class="message">
					<cfset importObj = CreateObject("component", "Importer_Mango").init(path,form.mangoConfig,form.datasource, form.dbType, form.prefix,pluginspath)/>
					<cfset result = importObj.import(form.blog_address_blogcfc) />
					
				</div>
				<cfif NOT result.status>
					<cfset error = result.message />
				<cfelse>
					<cfset setupObj.setupPlugins() />
					<cfset step = 3/>
				</cfif>
				<cfcatch type="any">
					</div>
					<cfset error = cfcatch.message & ": " & cfcatch.detail />
				</cfcatch>
			</cftry>
		</cfcase> --->
		</cfswitch>
	<cfelse>
			<cfset error = result.message />
	</cfif>
</cfcase>

</cfswitch>
</cfif>

<cfswitch expression="#step#">
<cfcase value="1">

<p class="message">You are about to install Mango Blog. <br />You will need to have a database (MS SQL or MySQL) already created (it can be an empty database).</p>

<cfif len(error)>
	<p class="error"><cfoutput>#error#</cfoutput></p>
</cfif>	

<cfoutput><form method="post" action="setup.cfm" name="wf_Wizardpages" id="wf_Wizardpages">
  <div class="widget">
    <div class="wfPage" id="wfPgIndex-1">
      <h3>Step 1</h3>
      <div class="instructions"></div>
      <span class="label preField">Do you already have a datasource set up for you?</span>
      <span class="required">
		
        <span class="oneChoice">
          <input type="radio" value="yes" class="switch-a" id="wf_Yes" name="datasourceExists" <cfif datasourceExists EQ "yes">checked="checked"</cfif> />
          <label for="wf_Yes" id="wf_Yes-L" class="postField">Yes</label>
        </span>
        <span class="oneChoice">
          <input type="radio" value="no" class="switch-b" id="wf_No" name="datasourceExists" <cfif datasourceExists EQ "no">checked="checked"</cfif>/>
          <label for="wf_No" id="wf_No-L" class="postField">No</label>
        </span>
      </span>
      <br/>
    </div>
    <fieldset id="wf_Datasourceinforma" class="on offstate-a">
      <legend>Datasource information</legend>
      <div class="instructions">Fill this if you already have a datasource set up in the ColdFusion administrator (or your hosting provider creates them for you)</div>
      <div class="field-hint-inactive" id="wf_Datasourcename-H">
        <div>The name of the datasource as entered in the ColdFusion administrator</div>
      </div>
      <label for="wf_Datasourcename" id="wf_Datasourcename-L" class="preField">Datasource name
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Datasourcename" name="datasource" value="#datasource#" size="" class="validate-alphanum required"/>
      <br/>
      <span class="label preField">Database type <span class="reqMark">*</span></span>
      <span class="required">
       <span class="oneChoice">
          <input type="radio" value="mssql" id="wf_MSSQL" name="dbtype" <cfif dbType EQ "mssql">checked="checked"</cfif>/>
          <label for="wf_MSSQL" id="wf_MSSQL-L" class="postField">MS SQL</label>
        </span>
        <span class="oneChoice">
          <input type="radio" value="mysql" id="wf_MySQL" name="dbtype" <cfif dbType EQ "mysql">checked="checked"</cfif>/>
          <label for="wf_MySQL" id="wf_MySQL-L" class="postField">MySQL</label>
        </span>
      </span>
      <br/>
      <div class="field-hint-inactive" id="wf_Tableprefix1-H">
        <div>Fill this if your database is not empty or you have another Mango installation in the same database</div>
      </div>
      <label for="wf_Tableprefix1" id="wf_Tableprefix1-L" class="preField">Table prefix</label>
      <input type="text" id="wf_Tableprefix1" name="prefix" value="#prefix#" size="" class="validate-alphanum"/>
      <br/>
    </fieldset>
    
	 <fieldset id="wf_Newdatasource" class="offstate-b">
      <legend>New datasource</legend>
      <label for="cfadminpassword_new" id="wf_ColdFusionAdminis-L" class="preField">ColdFusion Administrator password</label>
      <input type="password" id="cfadminpassword_new" name="cfadminpassword_new" value="" class="none"/>
      <br/>

      <label for="wf_Datasourcename1" id="wf_Datasourcename1-L" class="preField">Datasource name
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Datasourcename1" name="datasource_new" value="#datasource_new#" size="" class="validate-alphanum required"/>
      <br/>
      <span class="label preField">Database type <span class="reqMark">*</span></span>
      <span class="required">
        <span class="oneChoice">
          <input type="radio" value="mssql" id="wf_MSSQL11" name="dbtype_new"/>
          <label for="wf_MSSQL11" id="wf_MSSQL11-L" class="postField">MS SQL</label>
        </span>
        <span class="oneChoice">
          <input type="radio" value="mysql" id="wf_MySQL11" name="dbtype_new"/>
          <label for="wf_MySQL11" id="wf_MySQL11-L" class="postField">MySQL (3.x)</label>
        </span>
      </span>
      <br/>
      <div class="field-hint-inactive" id="wf_Server1-H">
        <div>Your database host address (i.e.: localhost, an ip address or url)</div>
      </div>
      <label for="wf_Server1" id="wf_Server1-L" class="preField">Server
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Server1" name="server_new" value="localhost" value="#server_new#" class="required"/>
      <br/>
      <div class="field-hint-inactive" id="wf_Databasename-H">
        <div>The name of your database</div>
      </div>
      <label for="wf_Databasename" id="wf_Databasename-L" class="preField">Database name
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Databasename" name="database_new" value="#database_new#" size="" class="validate-alphanum required"/>
      <br/>
      <div class="field-hint-inactive" id="wf_Username1-H">
        <div>Username to access your database</div>
      </div>
      <label for="wf_Username1" id="wf_Username1-L" class="preField">Username
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Username1" name="username_new" value="#username_new#" size="" class="required"/>
      <br/>
      <div class="field-hint-inactive" id="wf_Password-H">
        <div>Your database password</div>
      </div>
      <label for="wf_Password" id="wf_Password-L" class="preField">Password</label>
      <input type="password" id="wf_Password" name="password_new" value="#password_new#" class=""/>
      <br/>
      <div class="offstate-b">
        <div class="field-hint-inactive" id="wf_Tableprefix11-H">
          <div>Use this if your database is not empty or you have another Mango installation in the same database</div>
        </div>
        <label for="wf_Tableprefix11" id="wf_Tableprefix11-L" class="preField">Table prefix</label>
        <input type="text" id="wf_Tableprefix11" name="prefix_new" value="#prefix_new#" size="" class="validate-alphanum"/>
        <br/>
      </div>
    </fieldset>
		
      <div class="actions">
      <input type="submit" class="primaryAction" id="submit" name="submit" value="Next"/>
    </div>
  </div>
</form></cfoutput>

</cfcase>
<cfcase value="2">
<cfif len(error)>
	<p class="error"><cfoutput>#error#</cfoutput></p>
</cfif>	<cfoutput> 
<!---<form method="post" action="setup.cfm" name="wf_StepWizardStep21" id="wf_StepWizardStep21">
  <div class="widget">
   
	<h3>
  <span>Step 2</span>
</h3>
    <fieldset id="wf_Authorinformation" class="on">
      <legend>Author information</legend>
      <label for="wf_Name2" id="wf_Name2-L" class="preField">Name
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Name2" name="name" value="" size="" class="none required"/>
      <br/>
      <label for="wf_Username2" id="wf_Username2-L" class="preField">Username
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Username2" name="username" value="admin" size="" class="validate-alphanum required"/>
      <br/>
      <label for="wf_Password1" id="wf_Password1-L" class="preField">Password
						 <span class="reqMark">*</span></label>
      <input type="password" id="wf_Password1" name="password" value="" class="none required"/>
      <br/>
      <div class="field-hint-inactive" id="wf_Email-H">
        <div>Email address where password will be sent if forgotten. This address also identifies the author when writing comments in posts.</div>
      </div>
      <label for="wf_Email" id="wf_Email-L" class="preField">Email
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Email" name="email" value="" size="" class="validate-email required"/>
      <br/>
    </fieldset>
    <fieldset id="wf_Bloginformation" class="on">
      <legend>Blog information</legend>
      <label for="wf_Title1" id="wf_Title1-L" class="preField">Title
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Title1" name="blog_title" value="#blog_title#" size="50" class="none required"/>
      <br/>
      <label for="wf_Address2" id="wf_Address2-L" class="preField">Address
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Address2" name="blog_address" value="#blog_address#" size="50" class="required"/>
      <br/>
    </fieldset>


    <div class="actions">
      <input type="submit" class="primaryAction" id="submit" name="submit" value="Submit"/>
    </div>
  </div>
<input type="hidden" name="step" value="2">
 <input type="hidden"name="prefix" value="#prefix#" />
 <input type="hidden"name="datasource" value="#datasource#" />
 <input type="hidden"name="dbtype" value="#dbtype#" />
</form> --->

<h3>
  <span>Step 2</span>
</h3>

<form method="post" action="setup.cfm" name="wf_StepWizardStep21" id="wf_StepWizardStep21" enctype="multipart/form-data">

  <div class="widget">
    <span class="label preField">Is this blog new?</span>
    <span class="required">
      <span class="oneChoice">
        <input type="radio" value="yes" class="switch-a" checked="checked" id="wf_Yes" name="isblognew"/>
        <label for="wf_Yes" id="wf_Yes-L" class="postField">Yes</label>
      </span>
      <span class="oneChoice">
        <input type="radio" value="no" class="switch-b" id="wf_NoIwanttoimportda" name="isblognew"/>
        <label for="wf_NoIwanttoimportda" id="wf_NoIwanttoimportda-L" class="postField">No, I want to import data from another blog</label>
      </span>
    </span>
    <br/>
    <fieldset id="wf_Authorinformation" class="on offstate-a">
		<legend>Author information</legend>
      <label for="wf_Name2" id="wf_Name2-L" class="preField">Name
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Name2" name="name" value="" size="" class="none required"/>
      <br/>
      <label for="wf_Username2" id="wf_Username2-L" class="preField">Username
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Username2" name="username" value="admin" size="" class="validate-alphanum required"/>
      <br/>
      <label for="wf_Password1" id="wf_Password1-L" class="preField">Password
						 <span class="reqMark">*</span></label>
      <input type="password" id="wf_Password1" name="password" value="" class="none required"/>
      <br/>
      <div class="field-hint-inactive" id="wf_Email-H">
        <div>Email address where password will be sent if forgotten. This address also identifies the author when writing comments in posts.</div>
      </div>
      <label for="wf_Email" id="wf_Email-L" class="preField">Email
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Email" name="email" value="#email#" size="" class="validate-email required"/>
      <br/>
    </fieldset>
       <fieldset id="wf_Bloginformation" class="on offstate-a">
      <legend>Blog information</legend>
      <label for="wf_Title1" id="wf_Title1-L" class="preField">Title
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Title1" name="blog_title" value="#blog_title#" size="50" class="none required"/>
      <br/>
      <label for="wf_Address2" id="wf_Address2-L" class="preField">Address
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Address2" name="blog_address" value="#blog_address#" size="50" class="required"/>
<!---      <legend>Author information</legend>
      <label for="wf_Name2" id="wf_Name2-L" class="preField">Name
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Name2" name="wf_Name2" value="" size="" class="none required"/>
      <br/>
      <label for="wf_Username2" id="wf_Username2-L" class="preField">Username
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Username2" name="wf_Username2" value="admin" size="" class="validate-alphanum required"/>
      <br/>
      <label for="wf_Password1" id="wf_Password1-L" class="preField">Password
						 <span class="reqMark">*</span></label>
      <input type="password" id="wf_Password1" name="wf_Password1" value="" class="none required"/>
      <br/>
      <div class="field-hint-inactive" id="wf_Email-H">
        <div>Email address where password will be sent if forgotten. This address also identifies the author when writing comments in posts.</div>
      </div>
      <label for="wf_Email" id="wf_Email-L" class="preField">Email
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Email" name="wf_Email" value="" size="" class="validate-email required"/>
      <br/>
    </fieldset>
    <fieldset id="wf_Bloginformation" class="on offstate-a">
      <legend>Blog information</legend>
      <label for="wf_Title1" id="wf_Title1-L" class="preField">Title
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Title1" name="wf_Title1" value="My Blog" size="50" class="none required"/>
      <br/>
      <label for="wf_Address2" id="wf_Address2-L" class="preField">Address
						 <span class="reqMark">*</span></label>
      <input type="text" id="wf_Address2" name="wf_Address2" value="http://" size="50" class="required"/> --->
      <br/>
    </fieldset>
    <fieldset id="wf_Blogimport1" class="offstate-b">
      <legend>Blog import</legend>
      <span class="label preField">Blog engine</span>
      <span class="required">
        <span class="oneChoice">
          <input type="radio" value="wordpress" class="switch-c" id="wf_Wordpress1" name="blogengine"/>
          <label for="wf_Wordpress1" id="wf_Wordpress1-L" class="postField">Wordpress</label>
        </span>
        <span class="oneChoice">
          <input type="radio" value="BlogCFC" class="switch-d" id="wf_BlogCFC1" name="blogengine"/>
          <label for="wf_BlogCFC1" id="wf_BlogCFC1-L" class="postField">BlogCFC 5.x</label>
        </span>
        <!--- <span class="oneChoice">
          <input type="radio" value="wf_BlogCFM1" class="switch-e" id="wf_BlogCFM1" name="blogengine"/>
          <label for="wf_BlogCFM1" id="wf_BlogCFM1-L" class="postField">BlogCFM</label>
        </span>
        <span class="oneChoice">
          <input type="radio" value="wf_Blogger" class="switch-f" id="wf_Blogger" name="blogengine"/>
          <label for="wf_Blogger" id="wf_Blogger-L" class="postField">Blogger</label>
        </span>
        <span class="oneChoice">
          <input type="radio" value="wf_MovableType" class="switch-g" id="wf_MovableType" name="blogengine"/>
          <label for="wf_MovableType" id="wf_MovableType-L" class="postField">Movable Type</label>
        </span> --->
      </span>
      <br/>
      <div id="wf_Wordpressexport1" class="offstate-c">
        <div class="instructions">To export Wordpress content, go to your Wordpress admin, click Manage &gt; Import. Save the file in your computer.</div>
        <div class="field-hint-inactive" id="wf_Exporteddatafile-H">
          <div>File that you saved with Wordpress content</div>
        </div>
        <label for="wf_Exporteddatafile" id="wf_Exporteddatafile-L" class="preField">Exported data file
						 <span class="reqMark">*</span></label>
        <input type="file" id="wf_Exporteddatafile" name="wf_Exporteddatafile" value="" size="" class="required"/>
        <br/>
		
		<div class="field-hint-inactive" id="wf_Blogaddress-H">
          <div>Leave blank to use URL from Wordpress file</div>
        </div>
        <label for="wf_Blogaddress" id="wf_Blogaddress-L" class="preField">Blog address</label>
        <input type="text" id="wf_Blogaddress" name="blog_address_wordpress" value="#blog_address_wordpress#" size="40" class=""/>
        <br/>
		
		<div class="field-hint-inactive" id="email_wordpress-H">
          <div>Main address to use when sending email</div>
        </div>
		<span class="required">
        <label for="email_wordpress" id="email_wordpress-L" class="preField">Email address<span class="reqMark">*</span></label>
        <input type="text" id="email_wordpress" name="email_wordpress" value="#email_wordpress#" size="40" class=""/>
		</span>
        <br/>
		
		<p class="message">Important: All authors will be set a temporary password: "password". Their email address will be set to the main blog email address. If you have more than one author, you will need to update the author settings in your administrator once the blog is setup</p>
		
      </div>
	
	
      <div class="offstate-d">
        <div class="field-hint-inactive" id="wf_Configurationfile-H">
          <div>Full path of the location of your blog.ini.cfm file (ie: c:\inetpub\wwwroot\myblog\blog.ini.cfm) </div>
        </div>
        <label for="wf_Configurationfile" id="wf_Configurationfile-L" class="preField">Configuration file
						 <span class="reqMark">*</span></label>
        <input type="text" id="wf_Configurationfile" name="blogcfcini" value="#blogcfcini#" size="40" class="required"/>
        <br/>		
      </div>
	 
	<div class="offstate-d">
        <div class="field-hint-inactive" id="wf_Blogaddress-H">
          <div>Leave blank to use URL from configuration file</div>
        </div>
        <label for="wf_Blogaddress" id="wf_Blogaddress-L" class="preField">Blog address</label>
        <input type="text" id="wf_Blogaddress" name="blog_address_blogcfc" value="#blog_address_blogcfc#" size="40" class=""/>
        <br/>
      </div>
	
	<div class="offstate-h">
        <div class="field-hint-inactive" id="wf_Configurationfile-H">
          <div>Full path of the location of your config.cfm file (ie: c:\inetpub\wwwroot\myblog\config.cfm) </div>
        </div>
        <label for="wf_Configurationfile" id="wf_Configurationfile-L" class="preField">Configuration file
						 <span class="reqMark">*</span></label>
        <input type="text" id="wf_Configurationfile" name="mangoConfig" value="#mangoConfig#" size="40" class="required"/>
        <br/>
				
      </div>
	
    </fieldset>
    <div class="actions">
      <input type="submit" class="primaryAction" id="tfa_submit" name="submit" value="Submit"/>
    </div>
  </div>
<input type="hidden" name="step" value="2">
 <input type="hidden"name="prefix" value="#prefix#" />
 <input type="hidden"name="datasource" value="#datasource#" />
 <input type="hidden"name="dbtype" value="#dbtype#" />
</form>


</cfoutput>
	
</cfcase>

<cfcase value="3">
	<h3> Step 3</h3>
	
	<p>Done!</p>
<cfoutput>
	<p>You can now start posting from your administration at: <a href="#blog_address#admin/index.cfm?first=1">#blog_address#admin/</a></p>
	<p>Then you can view your blog at: <a href="#blog_address#">#blog_address#</a></p>
</cfoutput>
	
</cfcase>


</cfswitch>
</body>
</html>
