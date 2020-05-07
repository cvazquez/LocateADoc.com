<cfcomponent extends="Controller" output="false">

	<cfset isMobile = false>
	<cfset mobileSuffix = "">

	<cffunction name="init">
		<cfset filters("initialize1")>
		<cfset usesLayout("checkPrint")>
	</cffunction>

	<cffunction name="checkPrint">
		<cfif structKeyExists(params, "print-view")>
			<cfreturn "/print">
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>

	<cffunction name="index">
		<cfset title = "Medical Loans | Medical Financing & Surgery Loans">
		<cfset metaDescriptionContent = "CareCredit patient financing for medical, dental and health care procedures to cover healthcare expenses.">
		<cfset breadcrumbs = []>

		<cfparam default="" name="params.submitted">
		<cfparam default="" name="params.firstname">
		<cfparam default="" name="params.lastname">
		<cfparam default="" name="params.email">
		<cfparam default="" name="params.zip">
		<cfset errorList = ''>

		<cfif params.submitted EQ 1>
			<cfif trim(params.firstname) EQ ''>
				<cfset errorList = listAppend(errorList, "First Name")>
			</cfif>
			<cfif trim(params.lastname) EQ ''>
				<cfset errorList = listAppend(errorList, "Last Name")>
			</cfif>
			<cfif trim(params.zip) EQ ''>
				<cfset errorList = listAppend(errorList, "Zip")>
			</cfif>
			<cfif not isEmail(trim(params.email))>
				<cfset errorList = listAppend(errorList, "Email")>
			</cfif>

			<cfif listLen(errorList) EQ 0>
				<!--- Check if the patient selected any doctors. If not, then send them a list --->

				<cfset leadsExist = (model("ProfileLead").countByEmail(params.email) GT 0)>

				<cfset params.source_id = 1>
				<cfset params.vendor_id = 1>

				<cfset newLead = model("FinancingPatientLead").new(
					associationId = 4,
					source = val(params.source_id),
					vendor = val(params.vendor_id),
					status = 1,
					firstName = trim(params.firstname),
					lastName = trim(params.lastname),
					email = trim(params.email),
					postalCode = trim(params.zip)
				)>
				<cfif leadsExist>
					<cfset newLead.emailedDoctorsAt = now()>
				</cfif>

				<cfset newLead.save()>
				<cflocation url="https://www.carecredit.com/sw/patient/application2.html?id=UjhdZARECV1cB1NjVUoGNg%3D%3D" addtoken="no">
			</cfif>
		</cfif>


		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<!--- Render mobile page --->
			<cfset Request.mobileLayout = true>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="indexToHTML">
		<cfargument name="params" required="true">
		<cfset initialize1()>
		<cfset index()>
		<cfreturn variables>
	</cffunction>

<!--- Private Methods --->

	<cffunction name="initialize1" access="private">
		<!--- Gathering data for view --->
		<cfset breadcrumbs = []>
		<cfset arrayAppend(breadcrumbs,linkTo(href="/",text="Home"))>
		<cfset arrayAppend(breadcrumbs,"<span>Patient Financing</span>")>
		<cfif params.action eq "PrintView">
			<cfset params.action = "index">
		</cfif>
	</cffunction>

	<cffunction name="sponsoredlink" returntype="struct" access="private">
		<cfparam name="params.specialty" default="">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">

		<cfset sponsoredLink = getSponsoredLink(specialty="#val(params.specialty)#",
												paramsAction		= "#params.action#",
												paramsController	= "#params.controller#")>
		<cfreturn sponsoredLink>
	</cffunction>

</cfcomponent>