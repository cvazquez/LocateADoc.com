<cfset indicators = "">
<cfif (get("environment") neq "production" and  get("environment") neq "maintenance") <!--- or LCase(Server.ThisServer) eq "dev" ---> or Client.Debug>
	<cfset indicators = ListAppend(indicators,UCase(get("environment"))&" MODE")>
	<cfif doNotIndex>
		<cfset indicators = ListAppend(indicators,"<span style=""color:red"">NOINDEX is set</span>")>
	</cfif>
</cfif>
<cfif Client.Debug<!---  or Server.ThisServer eq "dev" --->>
	<cfset indicators = ListAppend(indicators,"DEBUG #Client.Debug ? "ON" : "OFF"#")>
	<cfif isDefined("Server.thisServer")>
		<cfset indicators = ListAppend(indicators,"SERVER: #UCase(Server.thisServer)#")>
	</cfif>
	<cfif isDefined("Application.applicationname")>
		<cfset indicators = ListAppend(indicators,"APPLICATION: #Application.applicationname#")>
	</cfif>
	<cfif structKeyExists(Request, "additionalIndicatorList") and Request.additionalIndicatorList neq "">
		<cfset indicators = ListAppend(indicators,Request.additionalIndicatorList)>
	</cfif>
	<cfif canonicalURL NEQ "">
		<cfset indicators = ListAppend(indicators, "Canonical: " &canonicalURL)>
	</cfif>
</cfif>
<cfoutput>
	<cfif indicators neq "">
		<div id="debug-mode" style="position:absolute;left:0px;top:0px; background-color:white; padding:5px; border: 1px solid ##ccc; border-top:0; border-left:0; z-index:9999999;">
			<cfloop list="#indicators#" index="i">#i#<br /></cfloop>
		</div>
	</cfif>
</cfoutput>