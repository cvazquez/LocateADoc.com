<cfset this.programmer = listGetAt(cgi.server_name, 1, ".")>
<cfif server.thisServer EQ "dev">
	<cfset this.name = "LAD3#this.programmer#">
</cfif>
<cfset this.clientmanagement = true>
<cfset this.clientStorage="myColdfusionLAD">
<cfset this.mappings["/tests"] = GetDirectoryFromPath( GetBaseTemplatePath() ) & "tests" >