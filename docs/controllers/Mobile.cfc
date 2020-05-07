<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
	    <cfset provides("html,json")>
	    <cfset filters(through="initializeController")>
	    <cfset usesLayout("/layout_mobile")>
	</cffunction>

	<cffunction name="initializeController">
		<cfparam name="URL.t" default="">
		<cfparam default="" name="Client.mobile_entry_page">

		<cfif URL.t neq "">
			<!--- Catch mobile links trying to use our mobile site as a redirect to their site - http://www.locateadoc.com/mobile/index?t=http://www.wzsoso.com/black-sabbath-tour-dates/ --->
			<cfif NOT ReFindNoCase("^https?://www.locateadoc.com", URL.t)>
				<cfset Client.mobile_entry_page = "http://www.locateadoc.com">
			<cfelse>
				<cfset Client.mobile_entry_page = URL.t>
			</cfif>

		<cfelseif Client.mobile_entry_page EQ "">
			<cfset Client.mobile_entry_page = "http://www.locateadoc.com">
		</cfif>

		<!--- <cfif not structKeyExists(Client, "mobile_entry_page") or Client.mobile_entry_page eq "">
			<cfif URL.t neq "">
				<cfset Client.mobile_entry_page = URL.t>
			<cfelse>
				<cfset Client.mobile_entry_page = "http://www.locateadoc.com">
			</cfif>
		</cfif> --->
	</cffunction>

	<cffunction name="index">
		<cfset analyticsPageTrack = "/funnel_G3/step1.html">
	</cffunction>

	<cffunction name="page1">
		<cfset analyticsPageTrack = "/funnel_G3/step2.html">
		<cfquery datasource="myLocateadocLB3" name="ProceduresAndSpecialties">
			(
				SELECT procedures.id, procedures.name, 'procedure' as type
				FROM procedures
				WHERE procedures.isPrimary = 1 AND procedures.deletedAt IS NULL
			)
			UNION ALL
			(
				SELECT specialties.id, specialties.name, 'specialty' as type
				FROM specialties
				WHERE specialties.categoryId = 1 AND specialties.deletedAt IS NULL
			)
			ORDER BY name ASC
		</cfquery>
	</cffunction>

	<cffunction name="page2">
		<cfinvoke component="/controllers/Common" method="contactadoctor" isModule="true" paramstruct="#params#" returnvariable="results">

		<cfif isStruct(results) and structKeyExists(results, "featuredListings") and results.featuredListings.recordCount>
			<cfset analyticsPageTrack = "/funnel_G3/step3.html">
			<cfset listings = results.featuredListings>
			<cfset FolioMiniLeadSiteWideId = results.SWID>
		<cfelseif not isStruct(results) or not structKeyExists(results, "featuredListings")>
			<cfset missing = results>
			<cfset renderPage(template="missing")>
		<cfelse>
			<cflocation url="/mobile/noresults" addtoken="no" statuscode="301">
		</cfif>
	</cffunction>

	<cffunction name="page3">
		<cfset analyticsPageTrack = "/funnel_G3/step4.html">
		<cfinvoke component="/controllers/Common" method="contactadoctor" isModule="true" processing="true" paramstruct="#params#" returnvariable="results">
	</cffunction>

	<cffunction name="noresults">
	</cffunction>

</cfcomponent>