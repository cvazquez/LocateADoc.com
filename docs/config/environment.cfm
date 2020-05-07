<!---
	The environment setting can be set to "design", "development", "testing", "maintenance" or "production".
	For example, set it to "design" or "development" when you are building your application and to "production" when it's running live.
--->

<cfif Server.ThisServer eq "Dev" and Left(LCase(CGI.SERVER_NAME),5) neq "alpha">
	<cfset set(environment="development")>
<cfelse>
	<cfset set(environment="production")>
</cfif>