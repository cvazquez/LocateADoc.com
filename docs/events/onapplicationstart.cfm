<!--- Place code here that should be executed on the "onApplicationStart" event. --->
<cfset Application.SharedModulesSuffix = "">
<cfif Server.ThisServer eq "dev" and ListGetAt(CGI.SERVER_NAME, 1, ".") neq "dev3">
	<cfset Application.SharedModulesSuffix = "_#ListGetAt(cgi.SERVER_NAME, 1, ".")#">
</cfif>

<cfset Application.leadTypes = {}>
<cfset Application.leadTypes.phone = {id=1, name="Phone Lead"}>
<cfset Application.leadTypes.mini = {id=2, name="Mini Lead"}>
<cfset Application.leadTypes.coupon = {id=3, name="Coupon Lead"}>

<cfset Application.stCachedContent = {}>

<cfinclude template="/LocateADocModules#Application.SharedModulesSuffix#/_applicationProceduresAndSpecialties.cfm">

<CFSET stSearchEngines=StructNew()>
<CFSET stSearchEngines["yahoo"]="p">
<CFSET stSearchEngines["search.yahoo.com"]="va">
<CFSET stSearchEngines["altavista.com"]="q">
<CFSET stSearchEngines["google"]="q">
<CFSET stSearchEngines["google.com"]="as_q">
<CFSET stSearchEngines["eureka.com"]="q">
<CFSET stSearchEngines["lycos.com"]="query">
<CFSET stSearchEngines["hotbot.com"]="MT">
<CFSET stSearchEngines["msn.com"]="q">
<CFSET stSearchEngines["infoseek.com"]="qt">
<CFSET stSearchEngines["excite.com"]="search">
<CFSET stSearchEngines["netscape.com"]="search">
<CFSET stSearchEngines["search.netscape.com"]="query">
<CFSET stSearchEngines["mamma.com"]="query">
<CFSET stSearchEngines["alltheweb.com"]="query">
<CFSET stSearchEngines["northernlight.com"]="qr">
<CFSET stSearchEngines["aol.com"]="query">
<CFSET stSearchEngines["mywebsearch"]="searchfor">
<CFSET stSearchEngines["websearch.cs.com"]="query">
<CFSET stSearchEngines["myway.com"]="searchfor">
<CFSET stSearchEngines["search.iwon.com"]="searchfor">
<CFSET stSearchEngines["ask.com"]="q">
<CFSET stSearchEngines["mysearch.com"]="searchfor">
<CFSET stSearchEngines["live.com"]="q">
<CFSET stSearchEngines["comcast.net"]="q">

<CFSET Application.stSearchEngines=stSearchEngines>