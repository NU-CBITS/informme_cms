<cfset path_to_pdf = "C:\inetpub\wwwroot\pdf\">
<cfinclude template="keys.cfm">
<cfif isdefined("form.mailJSON")>
  <cfset mail_data = deserializejson(form.mailJSON)>
  <cfif not isdefined("mail_data.bcc")>
    <cfset mail_data.bcc = "">
  </cfif>
  <cfif not isdefined("mail_data.mime")>
    <cfset mail_data.mime = "html">
  </cfif>
  <cfif not isdefined("mail_data.cc")>
    <cfset mail_data.cc = "">
  </cfif>
  <cfif mail_data.subject contains "InformMe">
    <cfset path_suffix = "informme">
  </cfif>
  <cfif not isdefined("path_suffix")>
    <cfset path_suffix = "general">
  </cfif>
  <cfset path_to_pdf = path_to_pdf & path_suffix>
  <cfif isdefined("mail_data.saveAsPDFAndLink") and mail_data.saveAsPDFAndLink is "true">
    <cfif isdefined("mail_data.additional_contents")>
      <cfset mail_contents = mail_data.additional_contents>
      <cfelse>
      <cfset mail_contents = mail_data.contents>
    </cfif>
    <cfdocument format="pdf" filename="#path_to_pdf#\#hash(mail_data.to)#.pdf" overwrite="yes" > <cfoutput>#mail_data.contents#</cfoutput> </cfdocument>
    <cfset mail_contents = mail_contents & "<br/><a href='http://mohrlab.northwestern.edu/pdf/" & path_suffix & "/" & hash(mail_data.to)  & ".pdf'>Download Your Summary<br/>" >
    <cfhttp method="post" username="#username#" password="#password#" url="https://api.mailgun.net/v2/cbits.northwestern.edu/messages">
      <cfhttpparam name="from" type="FormField" value="#mail_data.from#">
      <cfhttpparam name="to" type="FormField" value="#mail_data.to#">
      <cfhttpparam name="subject" type="FormField" value="#mail_data.subject#">
      <cfhttpparam name="text" type="FormField" value="#mail_contents#">
      <cfhttpparam name="html" type="FormField" value="#mail_contents#">
      <cfif mail_data.cc is not "">
        <cfhttpparam name="cc" type="FormField" value="#mail_data.bcc#">
      </cfif>
      <cfif mail_data.bcc is not "">
        <cfhttpparam name="bcc" type="FormField" value="#mail_data.bcc#">
      </cfif>
    </cfhttp>
    <cfoutput> #cfhttp.fileContent# </cfoutput>
    <cfelse>
    <cfset mail_contents = mail_data.contents>
    <cfhttp method="post" username="api" password="key-[REPLACE ME]" url="https://api.mailgun.net/v2/cbits.northwestern.edu/messages">
      <cfhttpparam name="from" type="FormField" value="#mail_data.from#">
      <cfhttpparam name="to" type="FormField" value="#mail_data.to#">
      <cfhttpparam name="subject" type="FormField" value="#mail_data.subject#">
      <cfhttpparam name="text" type="FormField" value="#mail_contents#">
      <cfhttpparam name="html" type="FormField" value="#mail_contents#">
      <cfif mail_data.cc is not "">
        <cfhttpparam name="cc" type="FormField" value="#mail_data.bcc#">
      </cfif>
      <cfif mail_data.bcc is not "">
        <cfhttpparam name="bcc" type="FormField" value="#mail_data.bcc#">
      </cfif>
    </cfhttp>
    <cfoutput> #cfhttp.fileContent# </cfoutput>
  </cfif>
  <cfelse>
</cfif>
