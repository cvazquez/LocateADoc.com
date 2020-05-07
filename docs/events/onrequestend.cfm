<!--- Place code here that should be executed on the "onRequestEnd" event. --->
<cfparam name="Request.overrideDebug" default="">
<cfparam default="" name="Client.skipmobile">
<cfparam default="" name="Client.desktop">
<cfparam default="" name="Client.forcemobile">
<cfparam default="" name="Client.mobile_entry_page">

<!--- <cfparam name="Request.isMobileBrowser" default="FALSE" type="boolean"> --->
<cfif Request.overrideDebug eq "">
     <cfset set(showDebugInformation = Client.Debug)>
     <cfsetting showdebugoutput="#Client.Debug#">
<cfelse>
     <cfset set(showDebugInformation = Request.overrideDebug)>
     <cfsetting showdebugoutput="#Request.overrideDebug#">
</cfif>

<!--- Mobile index redirect --->
<cfset controllerExceptions = "resources,profile,common,doctormarketing,askadoctor,home,pictures,doctors,financing">
<cfset directoryException = (CGI.PATH_INFO contains "/api" or CGI.PATH_INFO contains "/mobile")>
<cfset scriptException = ListFind("/redirect.cfm,/go.cfm", CGI.SCRIPT_NAME)>
<cfif not Client.skipmobile and not ListFind(controllerExceptions, ListFirst(CGI.PATH_INFO, "/")) and not (IsDefined("Request.wheels.params.controller") and ListFindNoCase(controllerExceptions, Request.wheels.params.controller)) and not directoryException and not scriptException and not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
	<cfif not structKeyExists(Client, "mobile_entry_page") or Client.mobile_entry_page eq "" or CGI.HTTP_REFERER does not contain "locateadoc.com/mobile">
		<cfset Client.mobile_entry_page = ReReplace(ReReplace(Request.currentURL,"[&?]forcemobile=[01]","","ALL"),"[&?]desktop=[01]","","ALL")>
	</cfif>
	<cflocation url="/mobile/index?t=#Client.mobile_entry_page#" addtoken="no">
</cfif>