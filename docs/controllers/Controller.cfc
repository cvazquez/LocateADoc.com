<!---
	This is the parent controller file that all your controllers should extend.
	You can add functions to this file to make them globally available in all your controllers.
	Do not delete this file.
--->
<cfcomponent extends="Wheels">
	<!--- Global variables --->
	<cfset Globals = {}>
	<cfif server.thisServer EQ "dev">
		<cfset Globals.domain = "dev3.locateadoc.com">
		<cfset Globals.serverImagePath = "/export/home/dev3.locateadoc.com/docs">
	<cfelse>
		<cfset Globals.domain = "www.locateadoc.com">
		<cfset Globals.serverImagePath = "/export/home/locateadoc.com/docs">
	</cfif>

	<cfset Globals.doctorPhotoBaseURL = "http://#Globals.domain#/images/profile/doctors/thumb/">

	<cfparam name="Client.ReferralFull" default="">
	<cfparam name="Client.EntryPage" default="">
	<cfparam name="Client.keywords" default="">

	<cfset ProceduresAndSpecialties = Application.qProceduresAndSpecialties>

	<cfif Find("print-view",Request.currentURL)>
		<cfset canonicalURL = REReplace(trim(REReplace(REReplace(Request.currentURL,"&?print-view",""),"\?&","?")),"\?$","")>
	</cfif>
	<cfif Find("?",Request.currentURL)>
		<cfset doNotIndex = true>
	</cfif>




</cfcomponent>