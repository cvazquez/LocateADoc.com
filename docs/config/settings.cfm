<!--- General settings --->
<cfset set(dataSourceName="myLocateadocLB3")>
<cfset set(urlRewriting="On")>
<cfset set(assetQueryString=true)>

<!--- Server specific settings --->
<cfif LCase(Server.ThisServer) eq "dev">
	<cfif Left(LCase(CGI.SERVER_NAME),5) neq "alpha">
		<!--- Settings for DEV server except alphas --->
		<cfset set(sendEmailOnError = "false")>
	<cfelse>
		<!--- Settings for ALPHAS --->
		<!--- <cfset set(errorEmailAddress = "lad3_errors@locateadoc.com")> --->
		<cfset set(sendEmailOnError = "false")>
	</cfif>
<cfelse>
	<!--- Settings for LIVE server --->
	<cfset set(reloadPassword = "redesign")>
	<!--- <cfset set(errorEmailAddress = "lad3_errors@locateadoc.com")> --->
	<cfset set(sendEmailOnError = "false")>
	<cfset set(excludeFromErrorEmail = "Application")>
</cfif>