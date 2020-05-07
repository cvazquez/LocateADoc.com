<cfparam name="client.debug" default=false>
<cfparam name="Application.sharedModulesSuffix" default="">

<cfset errormessage = "Unhandled 404 Error at #CGI.PATH_INFO#">
<cfset showError = Server.ThisServer eq "dev" or Client.debug>
<cfset errorURL = "http#CGI.HTTPS eq "on" ? "s" : ""#://#CGI.HTTP_HOST##CGI.SCRIPT_NAME neq "/rewrite.cfm" ? CGI.SCRIPT_NAME : ""##CGI.PATH_INFO##CGI.QUERY_STRING neq "" ? "?#CGI.QUERY_STRING#" : ""#">

<cftry>
	<cfinclude template="/LocateADocModules#Application.sharedModulesSuffix#/_exception.cfm">
	<cfinclude template="/LocateADocModules#Application.sharedModulesSuffix#/_identifySpider.cfm">
	<cfcatch></cfcatch>
</cftry>

<cfif not isDefined("Client.IsSpider")>
	<cfmodule template="/LocateADocModules#Application.SharedModulesSuffix#/SpiderFilter.cfm" ReturnVariable="Client.IsSpider">
</cfif>

<cftry>
	<cfif showError>
		<cfset redirectIntro = "Normally, this page would render">
	<cfelse>
		<cfset redirectIntro = "User was presented with">
	</cfif>
	<cfsavecontent variable="message">
		<cfoutput>
			<h2>#errormessage#</h2>
			<p style="font-face: verdana;color:red"><em><b>#redirectIntro# the 404 page.</b></em></p>
		</cfoutput>
	</cfsavecontent>
	<cfif showError>
		<cfsavecontent variable="pageBody">
			<cfoutput>
				<style>
					##wrapper { overflow:visible; }
				</style>
				<div id="main" style="overflow:visible;">
					<ul class="breadcrumbs">
						<li>#errormessage#</li>
					</ul>
					<div class="container inner-container">
						<div class="inner-holder">
							<div class="content-frame">
								<div class="financing" style="overflow:visible;">
									<cfset errorDump(showOutput=true, sendEmail=false, message="#message#", expand="no")>
								</div>
							</div>
						</div>
					</div>
				</div>
			</cfoutput>
		</cfsavecontent>
	<cfelse>
		<!--- Send error email --->
		<cfset emailAddress = "lad3_errors@locateadoc.com">
		<cfset errorDump(
							showOutput=false,
							sendEmail=true,
							fromEmail=emailAddress,
							toEmail=emailAddress,
							subject="#errormessage#",
							message="#message#",
							QueriesScope=true
							)>
		<!--- What to do next --->
		<cfsavecontent variable="pageBody">
			<cfinclude template="/views/common/404.cfm">
		</cfsavecontent>
	</cfif>

	<cfoutput>
		<cfset isError = true>
		<cfset doNotIndex = true>
		<cfif not isDefined("Request.oUser.email")>
			<cfset Request.oUser.email = "">
		</cfif>
		<cfif not isDefined("params.controller")>
			<cfset params.controller = "">
		</cfif>
		<cfif not isDefined("ProceduresAndSpecialties")>
			<cfinclude template="/LocateADocModules#Application.SharedModulesSuffix#/_applicationProceduresAndSpecialties.cfm">
		</cfif>
		<cfinclude template="/views/_header.cfm">
		#pageBody#
		<cfinclude template="/views/_footer.cfm">
	</cfoutput>

	<!--- Record error in DB --->
	<cfquery datasource="myLocateadocEdits">
		INSERT DELAYED INTO servererrors
		SET	errorMessage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#errormessage#">,
			errorCode = 404,
			url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#errorURL#">,
			server = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Server.ThisServer#">,
			scriptName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.SCRIPT_NAME#">,
			ipAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			userAgent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_USER_AGENT#">,
			isSpider = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(Client.isSpider)#">,
			spiderName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#identifySpider(CGI.HTTP_USER_AGENT)#">,
			referrer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_REFERER#">,
			cfId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(Client.CFID)#">,
			cfToken = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(Client.CFToken)#">,
			userAction = "User was presented with the 404 page.",
			createdAt = now()
	</cfquery>

	<cfcatch>
		<!--- Record new error in DB --->
		<cfset errorCode = 503>
		<cfif cfcatch.message contains "The request has exceeded the allowable time limit">
			<cfset errorCode = 408>
		</cfif>
		<cfquery datasource="myLocateadocEdits">
			INSERT DELAYED INTO servererrors
			SET	errorMessage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfcatch.message#">,
				errorCode = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(errorCode)#">,
				url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#errorURL#">,
				server = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Server.ThisServer#">,
				scriptName = "/events/onmissingtemplate.cfm",
				ipAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				userAgent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_USER_AGENT#">,
				isSpider = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(Client.isSpider)#">,
				spiderName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#identifySpider(CGI.HTTP_USER_AGENT)#">,
				referrer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_REFERER#">,
				cfId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(Client.CFID)#">,
				cfToken = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(Client.CFToken)#">,
				userAction = "User was presented with the 'raw' exception page.",
				createdAt = now()
		</cfquery>

		<cfif showError>
			<cfcontent reset="yes">
			<cfoutput><h1>Exception in onmissingtemplate.cfm</h1></cfoutput>
			<cfdump var="#cfcatch#">
		<cfelse>
			<!--- Send error email --->
			<cfset emailAddress = "lad3_errors@locateadoc.com">
			<cfset errorDump(
								showOutput=false,
								sendEmail=true,
								fromEmail=emailAddress,
								toEmail=emailAddress,
								subject="Uncaught Exception: #cfcatch.message#",
								message="This error was generated in /events/onmissingtemplate.cfm",
								QueriesScope=true
								)>
			<cfinclude template="/views/common/_raw_exception.cfm">
		</cfif>
	</cfcatch>
</cftry>
<cfabort>