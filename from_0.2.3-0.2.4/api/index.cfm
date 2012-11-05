<cfsetting showdebugoutput="false">
<cfimport prefix="mango" taglib="../tags/mango">
<cftry>

<cfset content = getHttpRequestData().content />
<cfif NOT len(content)>
<cfcontent type="text/xml" reset="yes"><?xml version="1.0"?>
<rsd version="1.0" xmlns="http://archipelago.phrasewise.com/rsd">
  <service>
    <engineName>Mango</engineName>
    <engineLink>http://www.mangoblog.org/</engineLink>
    <homePageLink><mango:Blog url /></homePageLink>
    <apis>
      <api name="Movable Type" blogID="<mango:Blog id />" preferred="true" apiLink="<mango:Blog url />api/index.cfm" />
      <api name="MetaWeblog" blogID="<mango:Blog id />" preferred="true" apiLink="<mango:Blog url />api/index.cfm" />
      <api name="Blogger" blogID="<mango:Blog id />" preferred="false" apiLink="<mango:Blog url />api/index.cfm" />
    </apis>
  </service>
</rsd>
<cfelse>
<cfset data = CreateObject("component", "XmlrpcParser").parseRequest(content) />
<!--- <cfheader name="Content-Length" value="#len(tostring(data))#"> --->
<cfcontent type="text/xml" reset="yes"><?xml version="1.0"?>
<cfoutput>#tostring(data)#</cfoutput>
</cfif>
<cfcatch type="any">	
</cfcatch>
</cftry>