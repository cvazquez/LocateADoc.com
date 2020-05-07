<cfcomponent extends="Controller" output="false">

	<!--- Global variables --->
	<cfset breadcrumbs = []>
	<cfset arrayAppend(breadcrumbs,linkTo(href="/",text="Home"))>

	<!--- determine destination of breadcrumb link --->
	<cfparam name="client.returnlink" default="">
	<cfif (CGI.HTTP_REFERER contains CGI.HTTP_HOST) and not (CGI.HTTP_REFERER contains "/profile")>
		<cfset client.returnlink = CGI.HTTP_REFERER>
	</cfif>
	<!--- <cfif client.returnLink contains "/doctors">
		<cfset arrayAppend(breadcrumbs,linkTo(href=client.returnLink,text="Find a Doctor"))>
	<cfelseif client.returnLink contains "/pictures">
		<cfset arrayAppend(breadcrumbs,linkTo(href=client.returnLink,text="Before and After Gallery"))>
	<cfelseif client.returnLink contains "/resources">
		<cfset arrayAppend(breadcrumbs,linkTo(href=client.returnLink,text="Resources"))>
	<cfelseif client.returnLink contains "/financing">
		<cfset arrayAppend(breadcrumbs,linkTo(href=client.returnLink,text="Financing"))>
	<cfelse>
		<cfset arrayAppend(breadcrumbs,linkTo(controller="doctors",text="Find a Doctor"))>
	</cfif> --->

	<!--- Set URLs and PATHs --->
	<cfset protocol = "http://">
	<cfif server.thisServer EQ "dev">
		<cfset domain = "dev3.locateadoc.com">
	<cfelse>
		<cfset domain = "www.locateadoc.com">
	</cfif>

	<cfset baseUrl			= "">
	<cfset imageBase		= "#baseURL#/images">
	<cfset galleryImageBase	= "#imageBase#/gallery">
	<cfset galleryImagePath	= "/export/home/#domain#/docs/images/gallery">
	<cfset doctorImageBase	= "#imageBase#/profile/doctors">
	<cfset doctorImagePath	= "/export/home/#domain#/docs/images/profile/doctors">
	<cfset practiceImageBase= "#imageBase#/profile/logos">

	<cfset LAD2galleryImagePath	= "/export/home/locateadoc.com/docs/pictures">
	<cfset LAD2uploadImagePath	= "/export/home/locateadoc.com/docs/images/gallery/uploaded">
	<cfset LAD3galleryImagePath	= galleryImagePath>

	<cfset miniLeadTypes = {"Phone Lead"=1, "Site Wide Mini"=2, "Coupon Lead"=3}>

	<cfset captcha_key = "VOiOeTCJsX9NBzd9X+9YEA==">

	<cfset isMobile = false>
	<cfset mobileSuffix = "">

	<cffunction name="init">
		<cfset provides("html,json")>
		<cfset filters(through="initializeController",except="setlocation,gallerycase,index,couponerror")>
		<cfset filters(through="recordHit",type="after",except="gallerycase,submitcouponlead,setlocation")>
		<cfset usesLayout("checkPrint")>
	</cffunction>

	<cffunction name="checkPrint">
		<cfif structKeyExists(params, "print-view")>
			<cfreturn "/print">
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>

<!--- URL Structure functions --->

	<cffunction name="welcomeRewrite">
		<cfargument name="params" default={}>
		<cfset variables.params = arguments.params>
		<cfset initializeController()>
		<cfset welcome()>
		<cfset Request.mobileLayout = true>
		<cfset recordHit()>

		<cfreturn variables>
	</cffunction>

	<cffunction name="reviewsRewrite">
		<cfargument name="params" default={}>
		<cfset variables.params = arguments.params>
		<cfset initializeController()>
		<cfset reviews()>
		<cfset Request.mobileLayout = true>
		<cfset recordHit()>
		<cfreturn variables>
	</cffunction>

<!--- Action --->

	<cffunction name="welcome">
		<cfparam name="params.vid" default="0">
		<cfset params.vid = val(params.vid)>

		<cfif params.vid gt 0>
			<cfset canonicalURL = trim(REReplace(Request.currentURL,"\?.*$",""))>
		</cfif>

		<cfif trim(currentLocationDetails.practicePageTitle) NEQ "">
			<cfset title = trim(currentLocationDetails.practicePageTitle)>
		<cfelse>
			<cfset title = "#DoctorOrPracticeName# - #currentLocation.cityName#, #currentLocation.stateAbbreviation# #currentLocation.postalCode#">
		</cfif>

		<cfif trim(currentLocationDetails.practiceMetaDescription) NEQ "">
			<cfset metaDescriptionContent = trim(currentLocationDetails.practiceMetaDescription)>
		<cfelse>
			<cfset metaDescriptionContent = "#DoctorOrPracticeName# is an experienced professional in the field of #mainSpecialty.name# - Doctor #doctor.lastName# has a practice in #currentLocation.cityName#, #currentLocation.stateAbbreviation#">
		</cfif>

		<cfif trim(currentLocationDetails.practiceMetaKeywords) NEQ "">
			<cfset metaKeywordsContent = currentLocationDetails.practiceMetaKeywords>
		</cfif>

		<cfset analyticsPageTrack = "/#params.siloname#/welcome">
		<!--- <cfset arrayAppend(breadcrumbs,"<span>#doctor.fullNameWithTitle# - #practice.name#</span>")> --->
		<cfset pixelfish()>
		<cfset flexVideo()>

		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif params.rewrite EQ 1 AND not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(template="welcome_mobile", layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="about">
		<cfset isMobile = false>
		<cfset mobileSuffix = "">

		<cfif trim(currentLocationDetails.doctorPageTitle) NEQ "">
			<cfset title = trim(currentLocationDetails.doctorPageTitle)>
		<cfelse>
			<cfset title = "#DoctorOrPracticeName# - Credentials and #mainSpecialty.name# Practice Information">
		</cfif>

		<cfif trim(currentLocationDetails.doctorMetaDescription) NEQ "">
			<cfset metaDescriptionContent = trim(currentLocationDetails.doctorMetaDescription)>
		<cfelse>
			<cfset metaDescriptionContent = "Welcome to #practice.name#, serving #Replace(ValueList(feederMarkets.name),",",", ","all")#">
		</cfif>

		<cfif trim(currentLocationDetails.doctorMetaKeywords) NEQ "">
			<cfset metaKeywordsContent = currentLocationDetails.doctorMetaKeywords>
		</cfif>

		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(template="about_mobile", layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="staff">
		<cfset isMobile = false>
		<cfset mobileSuffix = "">

		<cfif trim(currentLocationDetails.staffPageTitle) NEQ "">
			<cfset title = trim(currentLocationDetails.staffPageTitle)>
		<cfelse>
			<cfset title = "#DoctorOrPracticeName# - Office Staff and #mainSpecialty.name# Practice Information">
		</cfif>

		<cfif trim(currentLocationDetails.staffMetaDescription) NEQ "">
			<cfset metaDescriptionContent = trim(currentLocationDetails.staffMetaDescription)>
		<cfelse>
			<cfset metaDescriptionContent = "#practice.name#, staff biographies, practice information, #mainSpecialty.name# in #currentLocation.cityName#, #currentLocation.stateAbbreviation#">
		</cfif>

		<cfif trim(currentLocationDetails.staffMetaKeywords) NEQ "">
			<cfset metaKeywordsContent = currentLocationDetails.staffMetaKeywords>
		</cfif>

		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">

			<cfset renderPage(template="staff_mobile", layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="offers">
		<cfset isMobile = false>
		<cfset mobileSuffix = "">

		<cfif trim(currentLocationDetails.offersPageTitle) NEQ "">
			<cfset title = trim(currentLocationDetails.offersPageTitle)>
		<cfelse>
			<cfset title = "#DoctorOrPracticeName# - Special Offer for #mainSpecialty.name# Procedures">
		</cfif>

		<cfif trim(currentLocationDetails.offersMetaDescription) NEQ "">
			<cfset metaDescriptionContent = trim(currentLocationDetails.offersMetaDescription)>
		<cfelse>
			<cfset metaDescriptionContent = "Review special offers and discounts for #mainSpecialty.name# procedures offered by #DoctorOrPracticeName#, #currentLocation.cityName#, #currentLocation.stateAbbreviation#.">
		</cfif>

		<cfif trim(currentLocationDetails.offersMetaKeywords) NEQ "">
			<cfset metaKeywordsContent = currentLocationDetails.offersMetaKeywords>
		</cfif>

		<cfset submittedLead = false>
		<cfset javascriptIncludeTag(sources="profile/coupon", head=true)>
		<cfset stylesheetLinkTag(sources="profile/coupon", head=true)>
		<cfif Request.oUser.saveMyInfo eq 1>
			<cfset leadsSubmitted = model("ProfileMiniLead").findAll(where = "email = '#Request.oUser.email#' AND accountDoctorId = #params.key# AND createdAt > '#DateAdd("h",-1,now())#'")>
			<cfif leadsSubmitted.recordCount>
				<cfset submittedLead = true>
			</cfif>
		</cfif>
		<cfset couponurl = "">


		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(template="offers_mobile", layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="financing">
		<cfparam name="params.PatientFinanceType" default="#financingoptions.name#">
		<cfparam name="params.PatientFinanceId" default="#financingoptions.id#">
		<cfparam name="params.submitted" default="false">
		<cfparam name="params.firstname" default="">
		<cfparam name="params.lastname" default="">
		<cfparam name="params.email" default="">
		<cfparam name="params.zip" default="">
		<cfparam name="params.sid" default="#mainSpecialty.id#"> <!--- Listings specialty id --->
		<cfparam name="params.info_id" default="#doctorLocation.id#">
		<cfparam name="params.source_id" default="2">

		<cfset isMobile = false>
		<cfset mobileSuffix = "">

		<cfif trim(currentLocationDetails.financingPageTitle) NEQ "">
			<cfset title = trim(currentLocationDetails.financingPageTitle)>
		<cfelse>
			<cfset title = "#mainSpecialty.name# Financing - #currentLocation.cityName#, #currentLocation.stateAbbreviation# - #DoctorOrPracticeName#">
		</cfif>

		<cfif trim(currentLocationDetails.financingMetaDescription) NEQ "">
			<cfset metaDescriptionContent = trim(currentLocationDetails.financingMetaDescription)>
		<cfelse>
			<cfset metaDescriptionContent = "Get #mainSpecialty.name# Financing in the #currentLocation.cityName# Area and Nationwide for Your Surgery or Procedure with #DoctorOrPracticeName#.">
		</cfif>

		<cfif trim(currentLocationDetails.financingMetaKeywords) NEQ "">
			<cfset metaKeywordsContent = currentLocationDetails.financingMetaKeywords>
		</cfif>

		<cfset cosmetic_specialties = '42,25,40,44,9,48,19,31'>
		<cfset dentistry_specialties = '32,34,2,3,33'>
		<cfset vision_specialties = '45,10,12'>

		<cfset Missing = ''>

		<cfif params.submitted EQ "true">
			<!--- Input validation --->
			<cfif trim(params.firstname) EQ ''>
				<cfset Missing = listAppend(Missing, "First Name")>
			</cfif>

			<cfif trim(params.lastname) EQ ''>
				<cfset Missing = listAppend(Missing, "Last Name")>
			</cfif>

			<cfif trim(params.zip) EQ ''>
				<cfset Missing = listAppend(Missing, "Zip Code")>
			</cfif>

			<cfif not isEmail(trim(params.email))>
				<cfset Missing = listAppend(Missing, "Invalid email address entered")>
			</cfif>

			<cfif listLen(Missing) EQ 0>
				<cfset leadsExist = (model("ProfileLead").countByEmail(params.email) GT 0)>

				<cfif params.PatientFinanceId eq 6>
					<cfset params.vendor_id = 2>
					<!--- <cfset PatientFinancedRedirect = "http://surgeryfinancing.com/LAD/apply-now.html&source=SurgeryLoansTabOnFolioPage&specialtyid=#params.sid#&infoid=#params.info_id#"> --->
					<cfset PatientFinancedRedirect = "http://surgeryfinancing.com/LAD/apply-now.html">
				<cfelse>
					<cfset params.vendor_id = 1>
					<cfset PatientFinancedRedirect = "https://www.carecredit.com/apply/confirm.html?light=1&encm=BWQEPVw%2BB2IMMANnW29cNQU%2FXjxRMlRjVDMMNARgBDA%3D">
				</cfif>

				<cfset newLead = model("FinancingPatientLead").new(
					accountDoctorId = val(params.key),
					associationId = val(params.PatientFinanceId),
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

				<cflocation url="#PatientFinancedRedirect#" addtoken="false">
			</cfif>
		</cfif>

		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(template="financing_mobile", layout="/layout_mobile")>
		</cfif>

	</cffunction>

	<cffunction name="pictures">
		<cfparam name="params.silofilters" default="">
		<cfparam name="params.page" default="">
		<cfset var Local = {}>

		<cfset isMobile = false>
		<cfset mobileSuffix = "">

		<cfif params.silofilters neq "">
			<!--- Generate filter variables --->
			<cfset Local.i = 1>
			<cfloop list="#params.silofilters#" delimiters="/" index="Local.currentFilter">
				<cfset "params.filter#Local.i#" = Local.currentFilter>
				<cfset Local.i += 1>
			</cfloop>
			<cfset canonicalURL = "http://" & CGI.SERVER_NAME & "/" & params.siloname & (params.silodoctorid neq "" AND NOT params.siloname CONTAINS params.silodoctorid ? "-#params.silodoctorid#" : "") & "/pictures">
		</cfif>

		<cfif trim(currentLocationDetails.picturesPageTitle) NEQ "">
			<cfset title = trim(currentLocationDetails.picturesPageTitle)>
		<cfelse>
			<cfset title = "#DoctorOrPracticeName# #mainSpecialty.name# Before and After Pictures">
		</cfif>

		<cfif trim(currentLocationDetails.picturesMetaDescription) NEQ "">
			<cfset metaDescriptionContent = trim(currentLocationDetails.picturesMetaDescription)>
		<cfelse>
			<cfset metaDescriptionContent = "Before & After Photos by #FormalDoctorOrPracticeName# in #currentLocation.cityName#, #currentLocation.stateName# (#currentLocation.stateAbbreviation#).">
		</cfif>

		<cfif trim(currentLocationDetails.picturesMetaKeywords) NEQ "">
			<cfset metaKeywordsContent = currentLocationDetails.picturesMetaKeywords>
		</cfif>


		<cfset params.doctor	= params.key>
		<cfset tempVars			= createObject("component","Pictures").searchData(params)>
		<cfset structAppend(variables,tempVars,false)>

		<cfset params.controller= "pictures">
		<cfset params.action	= "searchtab">
		<cfset galleryContent	= renderPage(
									returnAs	= "string",
									layout		= "/profile/_galleryresults")>
		<cfset params.controller= "profile">
		<cfset params.action	= "pictures">

		<cfset filteredProcedures = "">
		<cfset topProcedureListWithFilters = "">
		<cfif params.procedure neq "">
			<cfset procedureInfo = model("Procedure").findAll(select="name,siloName",where="id = #val(params.procedure)#")>
			<cfif not isDefined("params.filter1")>
				<cfset galleryHeader = "#procedureInfo.name# Before and After Photos by #DoctorOrPracticeName#">
				<cfset title = "#DoctorOrPracticeName# #procedureInfo.name# Photos">
				<cfset metaDescriptionContent = "#procedureInfo.name# #metaDescriptionContent#">
				<cfset canonicalURL = "">
			<cfelseif params.silofilters neq "">
				<cfset galleryHeader = "Before and After Photos by #DoctorOrPracticeName#">
				<cfset canonicalURL = "http://" & CGI.SERVER_NAME & "/" & params.siloname & (params.silodoctorid neq "" AND NOT params.siloname CONTAINS params.silodoctorid ? "-#params.silodoctorid#" : "") & "/pictures/#procedureInfo.siloName#">
			</cfif>
		<cfelse>
			<cfset galleryHeader = "Before and After Photos by #DoctorOrPracticeName#">
			<!--- Compose procedure list for top of page --->
			<cfloop array="#search.filters.procedures#" index="procedureEntry">
				<cfset filteredProcedures = ListAppend(filteredProcedures,ListGetAt(procedureEntry,2,"|"))>
			</cfloop>
			<cfloop query="topProcedures">
				<cfif ListFind(filteredProcedures,topProcedures.procedureID) gt 0>
					<cfset topProcedureListWithFilters = ListAppend(topProcedureListWithFilters,'<a href="/#doctor.siloName#/pictures/#topProcedures.siloName#">#topProcedures.name#</a>')>
				<cfelse>
					<cfset topProcedureListWithFilters = ListAppend(topProcedureListWithFilters,topProcedures.name)>
				</cfif>
			</cfloop>
			<cfset topProcedureListWithFilters = Replace(topProcedureListWithFilters,",",", ","all")>
		</cfif>

		<cfif val(params.page) gt 1>
			<cfset metaDescriptionContent &= " - page #val(params.page)#">
		</cfif>

		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="case">
		<cfparam name="params.rewrite" default="0">
		<cfparam name="params.siloname" default="">
		<cfparam name="params.proceduresiloname" default="">
		<cfparam name="params.caseid" default="">
		<cfparam name="Client.lastProfileGallerySearch" default="">
		<cfset var Local = {}>

		<cfset isMobile = false>
		<cfset mobileSuffix = "">

		<cfif params.rewrite>
			<cfif Server.isInteger(params.caseid)>
				<cfset Local.procedure = model("galleryCaseProcedure").findAll(include="procedure, galleryCase(galleryCaseDoctors)", select="siloName", where="galleryCaseId = #params.caseid# AND gallerycaseprocedures.isPrimary = 1 AND accountDoctorId = #params.key#")>
				<cfif Local.procedure.recordCount>
					<cfif params.proceduresiloname neq Local.procedure.siloName>
						<cflocation url="/#params.siloname#/pictures/#Local.procedure.siloName#-c#params.caseid#" addtoken="no" statuscode="301">
					</cfif>
				<cfelse>
					<cfset dumpStruct = {procedure=Local.procedure,params=params}>
					<cfset fnCthulhuException(	scriptName="Profile.cfc",
												message="Couldn't find this gallery case (id: #params.caseid#) for this doctor (id: #params.key#).",
												detail="A goblin broke this page; totally not my fault.",
												dumpStruct=dumpStruct,
												redirectURL="/#params.siloname#/pictures"
												)>
				</cfif>
			<cfelse>
				<cfset dumpStruct = {params=params}>
				<cfset fnCthulhuException(	scriptName="Profile.cfc",
											message="Invalid case id (id: #params.caseid#).",
											detail="This isn't the page you're looking for.",
											dumpStruct=dumpStruct,
											redirectURL="/#params.siloname#/pictures"
											)>
			</cfif>
		</cfif>

		<cfset params.key	= val(params.key)>
		<!--- <cfset arrayAppend(breadCrumbs,"<a href='javascript:history.back()'>Results</a>")>
		<cfset arrayAppend(breadCrumbs,"Case details")> --->
		<cfset wrapperClass	= ' class="page9"'>

		<cfset galleryCase = model("GalleryCase").GetGalleryCaseAngles( galleryCaseId	= params.CaseId)>

		<cfif galleryCase.recordCount GT 0 AND galleryCase.showLAD EQ 1>
			<cfif isPastAdvertiser AND NOT isAdvertiser>
				<!--- 301 to public gallery profile --->
				<cflocation url="/pictures/#Local.procedure.siloName#-c#params.caseid#" addtoken="no" statuscode="301">
			</cfif>

			<cfset canonicalURL = "http://#cgi.server_name#/pictures/#Local.procedure.siloName#-c#params.caseid#">

			<cfset procedures = model("GalleryCase").GetGalleryCaseProcedures( galleryCaseId	= params.CaseId)>

			<cfif not isAdvertiser>
				<cflocation url="/pictures/#params.proceduresiloname#-c#params.caseid#" addtoken="no" statuscode="301">
			</cfif>

			<cfif ListFind(valueList(procedures.isExplicit), 1)>
				<cfset explicitAd = TRUE>
			</cfif>

			<cfset doctors = model("GalleryCase").GetGalleryCaseDoctorLocations( galleryCaseId	= params.CaseId)>

			<cfset doctorSpecs	= {}>

			<cfloop query="doctors">
				<cfif not structKeyExists(doctorSpecs,accountDoctorId)>
					<cfset doctorSpecs[accountDoctorId] =	model("AccountLocationSpecialty")
																.findAllByAccountDoctorLocationId(
																	value	= accountDoctorLocationId,
																	include	= "specialty",
																	page	= 1,
																	perpage	= 1)>
				</cfif>
			</cfloop>

			<cfset descriptionList = "">
			<cfif val(galleryCase.age)>
				<cfset descriptionList = ListAppend(descriptionList," #galleryCase.age# year old")>
			</cfif>
			<cfif galleryCase.galleryGenderName neq "">
				<cfset descriptionList = ListAppend(descriptionList," "&galleryCase.galleryGenderName)>
			</cfif>
			<cfif val(galleryCase.weight)>
				<cfset descriptionList = ListAppend(descriptionList," #galleryCase.weight# lb")>
			</cfif>
			<cfif val(galleryCase.gallerySkinToneId)>
				<cfset skinTone = model("gallerySkinTone").findAll(select="name",where="id=#val(galleryCase.gallerySkinToneId)#").name>
				<cfset descriptionList = ListAppend(descriptionList," "&skintone)>
			<cfelse>
				<cfset skinTone = "">
			</cfif>


			<cfif trim(currentLocationDetails.casePageTitle) NEQ "">
				<cfset title = trim(currentLocationDetails.casePageTitle)>
			<cfelse>
				<cfset title = "#procedures.name# Photos of a#descriptionList# patient by #DoctorOrPracticeName#, #currentLocation.cityName#, #currentLocation.stateAbbreviation#">
			</cfif>

			<cfif trim(currentLocationDetails.caseMetaDescription) NEQ "">
				<cfset metaDescriptionContent = trim(currentLocationDetails.caseMetaDescription)>
			<cfelse>
				<cfset metaDescriptionContent = "#procedures.name# Before and After Pictures performed by #DoctorOrPracticeName#, #currentLocation.cityName#, #currentLocation.stateAbbreviation#">
			</cfif>

			<cfif trim(currentLocationDetails.caseMetaKeywords) NEQ "">
				<cfset metaKeywordsContent = currentLocationDetails.caseMetaKeywords>
			</cfif>


			<cfset og_image = "http#CGI.SERVER_PORT_SECURE?"s":""#://#CGI.SERVER_NAME#/pictures/gallery/#procedures.siloName#-after-fullsize-#params.caseId#-#gallerycase.galleryCaseAngleId#.jpg">

			<!--- Get next/previous cases from last search criteria --->
			<cfset previousCase = 0>
			<cfset nextCase = 0>
			<cfif Client.lastProfileGallerySearch neq "">
				<cfset lastProfileGallerySearch = DeserializeJSON(Client.lastProfileGallerySearch)>
				<cfloop collection="#lastProfileGallerySearch#" item="criteria">
					<cfif ListFind("page,perpage,silourl,rewrite,controller,action,cfid,cftoken",criteria) eq 0>
						<cfset StructInsert(params,criteria,StructFind(lastProfileGallerySearch, criteria),true)>
					</cfif>
				</cfloop>
				<cfset otherCases = createObject("component","Pictures").beforeAfterData(params)>
				<cfif otherCases.results.recordcount eq 3>
					<cfset previousCase = 1>
					<cfset nextCase = 3>
				<cfelseif otherCases.results.recordcount eq 2>
					<cfif otherCases.aroundrow gt 1>
						<cfset previousCase = 1>
					<cfelse>
						<cfset nextCase = 2>
					</cfif>
				<cfelse>
					<!--- If none found, reset search structure --->
					<cfset Client.lastProfileGallerySearch = "">
				</cfif>
			</cfif>

			<cfset topGalleryProcedures = model("AccountDoctorProcedure").TopProceduresWithGalleries(doctor.id)>
		<cfelse>
			<cfif galleryCase.recordCount GT 0 AND galleryCase.showLAD EQ 0>
				<cfset errormsg	= "Invalid Gallery Case ID">
				<cfset errordesc= "We are unable to locate the gallery case for ID: #params.caseid#">
				<cfset backLink = "/#params.siloname#/pictures/#params.proceduresiloname#">



				<cfif isAdvertiser>
					<cflocation url="/#params.siloname#/pictures/" addtoken="no" statuscode="301">
				<cfelseif isPastAdvertiser>
					<cflocation url="/#params.siloname#/pictures/" addtoken="no" statuscode="301">
				</cfif>

				<cfset mainid = "errormain">
				<cfset containerclass = "">
				<cfset renderPage(template="/shared/error")>

			<cfelse>


				<!--- Try performing redirects to another procedure gallery case for the same doctor the same procedure
						http://carlos3.locateadoc.com/min-s-ahn-md/pictures/blepharoplasty-asian-eyes-c5947
						then to the procedure page in the main gallery. --->
				<cfset qGalleryCase = model("GalleryCase").GetDoctorsImagesWithSameProcedures(params.caseid)>

				<cfif qGalleryCase.recordCount GT 0>
					<!--- redirects to another procedure gallery case for the same doctor the same procedure --->
					<cfset redirectURL = "/#params.siloname#/pictures/#qGalleryCase.procedureSiloName#-c#qGalleryCase.caseId#">

					<!--- <cfoutput><p>redirectURL = #redirectURL#</p></cfoutput><cfabort> --->

					<cflocation addtoken="false" statuscode="301" url="#redirectURL#">
				<cfelse>
					<!--- redirects procedure page in the main gallery --->
					<cfset qGalleryCase = model("GalleryCase").GetImagesProcedure(params.caseid)>


					<cfset redirectURL = "/pictures/#qGalleryCase.siloName#">

					<!--- <cfoutput><p>redirectURL = #redirectURL#</p></cfoutput><cfabort> --->

					<cflocation addtoken="false" statuscode="301" url="#redirectURL#">
				</cfif>


				<cfheader statuscode="404">
				<cfset doNotIndex = true>

				<cfset errormsg	= "Invalid Gallery Case ID.">
				<cfset errordesc= "We are unable to locate the gallery case for ID: #params.caseId#">
				<cfset mainid = "errormain">
				<cfset containerclass = "">
				<cfset renderPage(template="/shared/error")>
			</cfif>
		</cfif>
		<cfset ShareText = title>

		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="reviews">
		<cfparam name="form.process_comment" default="0">
		<cfparam name="params.firstname" default="">
		<cfparam name="params.lastname" default="">
		<cfparam name="params.showname" default="1">
		<cfparam name="params.showphoto" default="0">
		<cfparam name="params.city" default="">
		<cfparam name="params.state" default="0">
		<cfparam name="params.email" default="">
		<cfparam name="params.procedures" default="">
		<cfparam name="params.reviewComment" default="">
		<cfparam name="params.rating" default="5">

		<cfset isMobile = false>
		<cfset mobileSuffix = "">


		<cfif trim(currentLocationDetails.reviewsPageTitle) NEQ "">
			<cfset title = trim(currentLocationDetails.reviewsPageTitle)>
		<cfelse>
			<cfset title = "#DoctorOrPracticeName# Reviews - LocateADoc.com">
		</cfif>

		<cfif trim(currentLocationDetails.reviewsMetaDescription) NEQ "">
			<cfset metaDescriptionContent = trim(currentLocationDetails.reviewsMetaDescription)>
		<cfelse>
			<cfset metaDescriptionContent = "Read and submit patient stories and reviews for #DoctorOrPracticeName# and get practice review information.">
		</cfif>

		<cfif trim(currentLocationDetails.reviewsMetaKeywords) NEQ "">
			<cfset metaKeywordsContent = currentLocationDetails.reviewsMetaKeywords>
		</cfif>


		<cfset successMessage = "">
		<cfset errorList = "">

		<cfif form.process_comment eq 1>
			<cfset addComment()>
		</cfif>

		<cfset rand_num = randrange(111111, 999999)>
		<cfset captcha_check = URLEncodedFormat(Encrypt(rand_num, captcha_key, "BLOWFISH")) />
		<!--- <cfset javascriptIncludeTag(source="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js",head=true)>
		<cfset styleSheetLinkTag(source="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css",head=true)> --->

		<cfset ratingSum = 0>
		<cfset weightSum = 0>
		<cfset weightedCommentCount = 0>

		<!--- Due to CF Wheels's inability to make complex joins, we load a list of
			  recommendation procedures here. This way, someone who posted a comment,
			  and had a procedure performed that we have subsequently deleted, will
			  still appear in the list of comments.                              --->
		<cfloop query="recommendations">
			<cfset recommendationProcedures = model("AccountDoctorLocationRecommendationProcedure").findAll(
											select="procedures.name",
											include="procedure",
											where="accountDoctorLocationRecommendationId = #recommendations.id#")>
			<cfif recommendationProcedures.recordcount gt 0>
				<cfset QuerySetCell(recommendations,"procedureList","<li>#ValueList(recommendationProcedures.name,'</li><li>')#</li>",currentrow)>
			</cfif>
			<!--- <cfif DateDiff("d",recommendations.createdAt,now()) lte 730> --->

			<cfif isnumeric(recommendations.rating)>
				<cfset commentWeight = Log10(10-9*Min(720,DateDiff("d",recommendations.createdAt,now()))/730)>
				<cfset ratingSum += recommendations.rating * commentWeight>
				<cfset weightSum += commentWeight>
				<cfset weightedCommentCount++>
			</cfif>
				<!--- <cfoutput>#recommendations.rating# | #commentWeight# | #ratingSum# | #weightSum# | #weightedCommentCount#<br></cfoutput> --->
			<!--- </cfif> --->
		</cfloop>
		<cfset states	= model("State")
							.findAll(
								select="states.name, states.abbreviation, states.id, countries.name as country",
								include="country",
								where="countries.showOnDirectory = 1 AND states.id NOT IN (72,73)", <!--- Temporary fix to exclude states that have California as a subset --->
								order="countries.directoryOrder asc, countries.name asc, states.name asc")>

		<cfset aggregateRating = (weightedCommentCount gt 0) ? (ratingSum / weightSum) : "">
		<!--- <cfoutput><br>#aggregateRating#</cfoutput>
		<cfabort> --->

		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
		</cfif>

	</cffunction>

	<cffunction name="askadoctor">
		<cfparam name="params.page" default="1">
		<cfset isMobile = false>
		<cfset mobileSuffix = "">


		<!--- Init pagination variables --->
		<cfset limit = 6>
		<cfset search = {}>
		<cfset search.page = Max(val(params.page),1)>
		<cfset offset = (search.page-1)*limit>


		<cfset title = "#DoctorOrPracticeName# Ask A Doctor Questions and Answers">
		<cfif search.page GT 1>
			<cfset title = title & " - Page #search.page#">
		</cfif>


		<cfif trim(currentLocationDetails.reviewsMetaDescription) NEQ "">
			<cfset metaDescriptionContent = trim(currentLocationDetails.reviewsMetaDescription)>
		<cfelse>
			<cfset metaDescriptionContent = "Read Ask A Doctor Questions and Answers for #DoctorOrPracticeName#.">
		</cfif>

		<cfif trim(currentLocationDetails.reviewsMetaKeywords) NEQ "">
			<cfset metaKeywordsContent = currentLocationDetails.reviewsMetaKeywords>
		</cfif>

		<cfset QA = model("AskADocQuestion").GetDoctorsQAs(	accountDoctorId = params.key,
															limit			= limit,
															offset			= offset)>
		<cfset qaTotal = model("AskADocQuestion").GetTotal()>
		<cfset search.pages = ceiling(qaTotal.total/limit)>

		<cfif isnumeric(doctor.googlePlusId)>
			<cfsavecontent variable="googlePlusHead">
				<cfoutput><link rel="author" href="https://plus.google.com/#doctor.googlePlusId#"/></cfoutput>
			</cfsavecontent>
			<cfhtmlhead text="#googlePlusHead#">
		</cfif>

		<cfif QA.recordCount EQ 0>
			<cfset doNotIndex = true>
		</cfif>

		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(template="askadoctor_mobile", layout="/layout_mobile")>
		</cfif>

	</cffunction>

	<cffunction name="contact">
		<cfparam name="form.process_contact" default="0">
		<cfparam name="form.process_mini" default="0">
		<cfparam name="params.miniID" default="0">

		<cfset isMobile = false>
		<cfset mobileSuffix = "">


		<cfif trim(currentLocationDetails.reviewsPageTitle) NEQ "">
			<cfset title = trim(currentLocationDetails.contactPageTitle)>
		<cfelse>
			<cfset title = "Contact #DoctorOrPracticeName# in #currentLocation.cityName#, #currentLocation.stateAbbreviation#">
		</cfif>

		<cfif trim(currentLocationDetails.contactMetaDescription) NEQ "">
			<cfset metaDescriptionContent = trim(currentLocationDetails.contactMetaDescription)>
		<cfelse>
			<cfset metaDescriptionContent = "Contact form for #DoctorOrPracticeName#, #currentLocation.cityName#, #currentLocation.stateAbbreviation# #mainSpecialty.name#.">
		</cfif>

		<cfif trim(currentLocationDetails.contactMetaKeywords) NEQ "">
			<cfset metaKeywordsContent = currentLocationDetails.contactMetaKeywords>
		</cfif>

		<cfif ListFind("1,2",form.process_mini) gt 0>
			<cfset processMiniLead()>
		</cfif>

		<cfset contactResult = processContact()>
		<cfset currentPage = contactResult.page>

		<cfif currentPage eq 1>
			<cfset states	= model("State").findAll(
								select="states.name, states.abbreviation, states.id, countries.name as country, countries.id as countryid",
								include="country",
								where="countries.showOnDirectory = 1 AND states.id NOT IN (72,73)", <!--- Temporary fix to exclude states that have California as a subset --->
								order="countries.directoryOrder asc, countries.name asc, states.name asc")>
			<cfset countries = model("Country").findAll(
								select="id,name",
								where="directoryOrder IS NOT NULL",
								order="directoryOrder asc,name asc")>
		</cfif>
		<cfif currentPage eq 2 AND val(params.miniID) gt 0>
			<cfset chosenProcedures = model("ProfileMiniLeadProcedure").findAll(
				select="procedureId",
				where="profileMiniLeadId = #val(params.miniID)#"
			)>
			<cfset params.procedures = ValueList(chosenProcedures.procedureId)>
		</cfif>

		<cfset doNotIndex = true>


		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(template="contact_mobile", layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="printcoupon">
		<cfsetting showdebugoutput="no">
		<cfset couponId = decrypt(url.coupon,"print coupon","CFMX_COMPAT", "Base64")>
		<cfset coupons = model("coupon").findByKey(key=couponId, include="accountDoctorLocationCoupon(accountDoctorLocation)", where="accountdoctorlocations.id = #val(currentLocation.id)#", group="couponId", returnAs="query")>
		<cfif not coupons.recordCount or coupons.accountDoctorId neq params.key>
			<cfset renderPage(action="couponerror", layout=false)>
			<cfexit>
		</cfif>
		<cfset fullCoupon = true>
		<cfset renderPage(layout=false)>
	</cffunction>

	<cffunction name="couponerror">
		<cfset renderPage(layout=false)>
	</cffunction>

<!--- AJAX functions --->

	<cffunction name="setlocation">
		<cfsetting showdebugoutput="no">
		<cfset Request.overrideDebug = "false">

		<cfset var Local = {}>
		<cfset Local.returnBool = true>

		<cfparam default="" name="params.key">

		<cfif NOT reFind("^[0-9]+$", params.key)>
			<!--- Probably accessing this page indirectly --->
			<cfheader statuscode="404">
			<cfset doNotIndex = true>

			<cfset errormsg	= "Invalid location ID.">
			<cfset errordesc= "We are unable to locate the doctor location for the ID: #params.key#">
			<cfset mainid = "errormain">
			<cfset containerclass = "">
			<cfset isError = true>
			<cfset renderPage(template="/shared/error")>

		<cfelse>
			<cfset client["LAD3ProfileLocation"] = "#params.key#">
			<cfset renderWith(Local.returnBool)>
		</cfif>

	</cffunction>

	<cffunction name="gallerycase">
		<cfsetting showdebugoutput=false>
		<cfset galleryCase	= model("GalleryCase")
								.findByKey(
									key		= params.key,
									include	= "galleryCaseAngles,galleryCaseProcedures,galleryGender",
									order	= "orderNumber asc")>
		<cfset procedures	= galleryCase.procedures(order="isprimary desc")>
		<cfset renderPage(layout=false)>
	</cffunction>

	<cffunction name="submitcouponlead">
		<cfset structAppend(params, params.coupon)>
		<cfset params.firstname = ListFirst(params.name, " ")>
		<cfset params.lastname = ListRest(params.name, " ")>
		<cfset params.leadTypeId = 5>
		<cfset params.couponId = decrypt(URLDecode(params.couponId),"print coupon","CFMX_COMPAT", "Base64")>
		<cfset processMiniLead()>
		<cfsetting showdebugoutput="no">
		<cfset renderWith("OK")>
	</cffunction>

<!--- Private Methods --->

	<cffunction name="initializeController" access="private">
		<cfparam name="params.key" default="">
		<cfparam name="params.l" default="0">
		<cfparam name="params.m" default="0">
		<cfparam name="params.rewrite" default="0">
		<cfparam name="params.siloname" default="">
		<cfparam name="params.silodoctorid" default="">
		<cfparam name="params.siloprocedurename" default="">
		<cfparam name="params.silofilters" default="">
		<cfparam name="params.showMap" default="0">
		<cfparam name="params.silourl" default="">
		<cfparam name="params.procedure" default="">

		<cfset var Local			= {}>
		<cfset mapCenter			= {}>
		<cfset mapCenter.longitude	= "">
		<cfset mapCenter.latitude	= "">
		<cfset mapCenter.zoom		= "">
		<cfset displayAd 			= FALSE>
		<cfset explicitAd 			= FALSE>
		<cfset adType				= "">
		<cfset hasContactForm		= FALSE>
		<cfset addressRequired		= FALSE>
		<cfset siloedFilters = "">
		<cfset siloedNames = "">

		<!--- If a location variable is defined, filter it and add it to client variables --->
		<cfif val(params.l) gt 0>
			<cfset client.LAD3ProfileLocation = val(params.l)>
			<cfset mapoption = (params.showMap neq 0 ? "&showMap=true" : "")>
			<cfset minioption = (val(params.m) neq 0 ? "&m=#val(params.m)#" : "")>
			<cfset URLoptions = Replace(mapoption & minioption,"&","?")>
			<cflocation url="#ListFirst(params.silourl, "?") & URLoptions#" addtoken="no" statuscode="301">
		</cfif>

		<cfif params.rewrite>
			<!--- Correction for malformed URLs --->
			<cfif params.siloname eq "procedure">
				<cfset Local.procedure = model("procedure").findByKey(key=params.silodoctorid, select="siloName")>
				<cfif isObject(Local.procedure)>
					<cflocation url="/#Local.procedure.siloName#" addtoken="no" statuscode="301">
				<cfelse>
					<cfset dumpStruct = {procedure=Local.procedure,params=params,Local=Local}>
					<cfset fnCthulhuException(	scriptName="Profile.cfc",
												message="Can't find procedure (id: #params.silodoctorid#).",
												detail="MAGNETS, Y U NO LIKE EACH OTHER?",
												dumpStruct=dumpStruct,
												redirectURL="/resources/surgery"
												)>
				</cfif>
			</cfif>
			<cfif params.siloname eq "specialty">
				<cfset Local.specialty = model("specialty").findByKey(key=params.silodoctorid, select="siloName")>
				<cfif isObject(Local.specialty)>
					<cflocation url="/#Local.specialty.siloName#" addtoken="no" statuscode="301">
				<cfelse>
					<cfset dumpStruct = {procedure=Local.specialty,params=params,Local=Local}>
					<cfset fnCthulhuException(	scriptName="Profile.cfc",
												message="Can't find specialty (id: #params.silodoctorid#).",
												detail="After the weekend the first five days are the hardest.",
												dumpStruct=dumpStruct,
												redirectURL="/resources/surgery"
												)>
				</cfif>
			</cfif>


			<cfif Server.isInteger(params.silodoctorid)>
				<cfset Local.docSiloName = model("AccountDoctorSiloName").findAllByAccountDoctorIdAndIsActive(values="#params.silodoctorid#,1",select="siloName")>
				<cfif Local.docSiloName.recordCount>
					<cfset params.key = params.silodoctorid>
				<cfelse>
					<cfset dumpStruct = {docSiloName=docSiloName,params=params,Local=Local}>
					<cfset fnCthulhuException(	scriptName="Profile.cfc",
												message="This doctor (id: #params.silodoctorid#) does not have an active silo name.",
												detail="Time travellers are not allowed here.",
												dumpStruct=dumpStruct,
												redirectURL="/doctors"
												)>
				</cfif>
			<cfelseif params.siloname neq "">
				<cfset Local.docSiloName = model("AccountDoctorSiloName").findAllBySiloName(value=params.siloname, select="accountDoctorId,isActive")>
				<cfif not Local.docSiloName.recordCount>
					<cfset dumpStruct = {docSiloName=Local.docSiloName,params=params,Local=Local}>
					<cfset fnCthulhuException(	scriptName="Profile.cfc",
												message="Couldn't find silo name '#params.siloname#'.",
												detail="Einstein was wrong.",
												dumpStruct=dumpStruct,
												redirectURL="/doctors"
												)>
				<cfelseif not Local.docSiloName.isActive>
					<cfset Local.docSiloName2 = model("AccountDoctorSiloName").findAllByAccountDoctorIdAndIsActive(values="#Local.docSiloName.accountDoctorId#,1", select="siloName")>
					<cfif Local.docSiloName2.recordCount>
						<cflocation url="/#Local.docSiloName2.siloName#/#params.action neq "welcome" ? params.action : ""#" addtoken="no" statuscode="301">
					<cfelse>
						<cfset dumpStruct = {docSiloName=docSiloName,docSiloName2=docSiloName2,params=params,Local=Local}>
						<cfset fnCthulhuException(	scriptName="Profile.cfc",
													message="Couldn't find active silo name for doctor (id: #Local.docSiloName.accountDoctorId#).",
													detail="Time travel is physically impossible.",
													dumpStruct=dumpStruct,
													redirectURL="/doctors"
													)>
					</cfif>
				</cfif>
				<cfset params.key = Local.docSiloName.accountDoctorId>

				<cfif params.siloprocedurename eq "search">
					<cflocation url="/#params.siloname##params.silodoctorid neq ""?"-#params.silodoctorid#":""#/pictures#params.silofilters#" addtoken="no" statuscode="301">
				</cfif>
				<cfset Local.procedureFilter = ReMatchNoCase("/procedure-[0-9]+", params.silofilters)>
				<cfif ArrayLen(Local.procedureFilter)>
					<cfset Local.procedureID = ListLast(Local.procedureFilter[1],"-")>
					<cfif Server.isInteger(Local.procedureID)>
						<cfset Local.siloProcedure = model("Procedure").findByKey(key=Local.procedureID, select="siloName")>
						<cfif isObject(Local.siloProcedure)>
							<cfset params.silofilters = ReReplace(params.silofilters, "/procedure-[0-9]+", "", "all")>
							<cflocation url="/#params.siloname##params.silodoctorid neq ""?"-#params.silodoctorid#":""#/pictures/#Local.siloProcedure.siloName##params.silofilters#" addtoken="no" statuscode="301">
						</cfif>
					</cfif>
				</cfif>
				<cfif params.siloprocedurename neq "">
					<cfset Local.siloProcedure = model("Procedure").findAllBySiloName(value=params.siloprocedurename, select="id")>
					<cfif Local.siloProcedure.recordCount>
						<cfset params.procedure = Local.siloProcedure.id>
						<cfset siloedFilters &= "/procedure-#Local.siloProcedure.id#">
						<cfset siloedNames &= "/#params.siloprocedurename#">
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		<!--- Generate JS for specialty, procedure, and body part DB --->
		<cfsavecontent variable="siloJS">
			<cfoutput>
				<script type="text/javascript">
					siloedFilters = "#siloedFilters#";
					siloedNames = "#siloedNames#";
				</script>
			</cfoutput>
		</cfsavecontent>
		<cfhtmlhead text="#fnCompress(siloJS)#">

		<!--- Redirect if doctor ID is not passed in --->
		<cfif not isDefined("params.key") or not Server.isInteger(params.key)>
			<cfset dumpStruct = {params=params}>
			<cfset fnCthulhuException(	scriptName="Profile.cfc",
										message="Invalid doctor id (id: #isDefined("params.key") ? params.key : "undefined"#).",
										detail="What did you expect?",
										dumpStruct=dumpStruct,
										redirectURL="/doctors"
										)>
		</cfif>

		<cfset doctor = model("AccountDoctor").GetProfile(accountDoctorId = params.key)>

		<!--- Redirect if doctor not found --->
		<cfif doctor.recordCount EQ 0>
			<cfset dumpStruct = {doctor=doctor,params=params}>
			<cfset fnCthulhuException(	scriptName="Profile.cfc",
										message="Can't find doctor (id: #params.key#).",
										detail="Nothing to see here. Move along.",
										dumpStruct=dumpStruct,
										redirectURL="/doctors"
										)>
		</cfif>

		<cfif doctor.photoFilename eq "">
			<cfdirectory action="list" directory="#ExpandPath('/images/profile/basic_headers')#" name="qryPhotos" filter="*.jpg">
			<cfset Local.imageNumber = RandRange(1,qryPhotos.recordCount)>
			<cfset doctorPhoto = "/images/profile/basic_headers/#qryPhotos.name[Local.imageNumber]#">
		<cfelse>
			<cfset doctorPhoto = "#doctorImageBase#/#doctor.photoFilename#">
		</cfif>
		<cfset og_image = "http#CGI.SERVER_PORT_SECURE?"s":""#://#CGI.SERVER_NAME##doctorPhoto#">

		<cfset doctorLocations	= model("AccountDoctorLocation").GetDoctorLocations( accountDoctorid = params.key)>
		<cfif doctorLocations.recordCount>
			<cfif replace(valueList(doctorLocations.longitude), ",", "", "all") neq "">
				<cfif doctorLocations.recordCount eq 1>
					<cfset mapCenter.longitude	=	doctorLocations.longitude>
					<cfset mapCenter.latitude	=	doctorLocations.latitude>
					<cfset mapCenter.zoom		=	11>
				<cfelse>
					<cfset mapCenter.longitude	=	arrayAvg(listToArray(valueList(doctorLocations.longitude)))>
					<cfset mapCenter.latitude	=	arrayAvg(listToArray(valueList(doctorLocations.latitude)))>
					<cfset Local.mapTop			=	arrayMax(listToArray(valueList(doctorLocations.latitude)))>
					<cfset Local.mapBottom		=	arrayMin(listToArray(valueList(doctorLocations.latitude)))>
					<cfset Local.mapLeft		=	arrayMin(listToArray(valueList(doctorLocations.longitude)))>
					<cfset Local.mapRight		=	arrayMax(listToArray(valueList(doctorLocations.longitude)))>
					<cfset Local.distance		=	mapDistance(Local.mapTop,Local.mapLeft,Local.mapBottom,Local.mapRight)>

					<cfif Local.distance EQ 0>
						<cfset mapCenter.longitude	=	doctorLocations.longitude>
						<cfset mapCenter.latitude	=	doctorLocations.latitude>
						<cfset mapCenter.zoom		=	11>
					<cfelse>
						<cfset mapCenter.zoom		=	mapZoom(Local.distance)>
					</cfif>
				</cfif>
			</cfif>
		<cfelse>
			<cfset dumpStruct = {doctorLocations=doctorLocations,params=params,local=local}>
			<cfset fnCthulhuException(	scriptName="Profile.cfc",
								message="Can't find doctor locations for doctor (id: #params.key#).",
								detail="Relativity is relative. And by relative, I mean wrong.",
								dumpStruct=dumpStruct,
								redirectURL="/doctors"
								)>
		</cfif>

		<cfif structKeyExists(client,"LAD3ProfileLocation") and Server.isInteger(client.LAD3ProfileLocation) and ListFind(ValueList(doctorLocations.id),client.LAD3ProfileLocation)>
			<cfset locationId = client.LAD3ProfileLocation>
		<cfelse>
			<cfset locationId = doctorLocations.id>
		</cfif>



		<cfset currentLocation	= model("AccountLocation").GetCurrentLocation(accountLocationId	= locationId)>

		<cfset currentLocationDetails = model("AccountLocationDetail")
										.GetPhoneDetails(	accountLocationId	= currentLocation.id,
															accountDoctorId 	= params.key)>
		<cfset doctorLocation		=	model("AccountDoctorLocation")
											.findAll(
												where="accountLocationId = #val(currentLocation.id)# AND accountDoctorId = #params.key#")>

		<cfif doctorLocation.recordCount EQ 0>
			<cfset doctorLocation = QueryNew("id")>
			<cfset QueryAddRow(doctorLocation)>
			<cfset QuerySetCell(doctorLocation, "id", 0)>
		</cfif>

		<cfif not model("AccountDoctor").HasCallTracking(params.key) and currentLocationDetails.recordcount>
			<cfset QuerySetCell(currentLocationDetails,"phonePlus","")>
		</cfif>
		<cfset practice =	model("AccountDoctorLocation")
								.findAll(
										select	= "accountpractices.name, accountpractices.accountId, accountdoctorlocations.accountPracticeId, accountpractices.uniqueValueProposition, accountpractices.logoFileName",
										include="accountPractice",
										where="accountDoctorId=#params.key#",
										group="accountDoctorId")>


		<!--- If practice data does not exist, redirect to doctor search --->
		<cfif val(practice.accountId) eq 0 OR practice.recordCount EQ 0>
			<cfset dumpStruct = {practice=practice,params=params,local=local}>
			<cfset fnCthulhuException(	scriptName="Profile.cfc",
										message="Can't find practice for doctor (id: #params.key#).",
										detail="No dice.",
										dumpStruct=dumpStruct,
										redirectURL="/doctors"
										)>
		</cfif>
		<cfset practiceDoctors		=	model("AccountDoctorLocation")
											.findAllByAccountPracticeId(
												select="accountdoctorlocations.accountDoctorId,accountdoctorlocations.accountLocationId,accountdoctorsilonames.siloname,CONCAT(firstName, IF(middleName<>'',CONCAT(' ',middleName),''), ' ', lastName, IF(title<>'',CONCAT(', ',title),'')) AS fullNameWithTitle",
												value=practice.accountPracticeId,
												include="accountDoctor(accountDoctorSiloNames)",
												group="accountDoctorId",
												where="accountdoctorsilonames.isActive = 1")>

		<cfset procedures	= model("AccountDoctorProcedure").GetDoctorsProcedures( accountDoctorId	= params.key)>

		<!--- Regional and Paid Basic Plus --->
		<cfset Local.advertiser = model("AccountDoctorLocation")
							.findOne(	select	= "accountproductspurchased.id",
										include	= "AccountProductsPurchasedDoctorLocations(AccountProductsPurchased)",
										where	= "accountdoctorlocations.accountDoctorId = #params.key# AND accountproductspurchased.dateEnd >= now() AND accountProductId IN (1,12)",
										returnAs= "query")>
		<cfset isAdvertiser = (Local.advertiser.recordcount GT 0 ? TRUE : FALSE)>

		<cfset Local.enhanced = model("AccountDoctorLocation")
							.findOne(	select	= "accountproductspurchased.id",
										include	= "AccountProductsPurchasedDoctorLocations(AccountProductsPurchased)",
										where	= "accountdoctorlocations.accountDoctorId = #params.key# AND accountproductspurchased.dateEnd >= now() AND accountProductId = 10",
										returnAs= "query")>
		<cfset isEnhanced = (Local.enhanced.recordcount GT 0 ? TRUE : FALSE)>

		<cfset Local.hasPastAdvertisements = model("AccountProductsPurchasedHistory").DoctorHasProductsPurchasedHistory( accountDoctorId	= params.key)>

		<cfset isPastAdvertiser = (not isAdvertiser and Local.hasPastAdvertisements) ? TRUE : FALSE>

		<cfset isBasicPlus = model("AccountDoctor").BasicPlus(params.key)>

		<cfif isBasicPlus>
			<cfset isBasicPlusOver2Leads = model("AccountDoctor").BasicPlusOver2Leads(params.key)>
			<cfset isBasicPlusOver2UnopenedLeads = model("Account").BasicPlusUnopenedLeadThreshold(accountId=practice.accountId)>
		<cfelse>
			<cfset isBasicPlusOver2Leads = false>
			<cfset isBasicPlusOver2UnopenedLeads = false>
		</cfif>

		<cfset isBasic = model("AccountDoctor").Basic(params.key)>

		<cfset topDoc = model("AccountProductsPurchased").findAll(include="accountproductspurchaseddoctorlocations(accountdoctorlocation)", where="dateEnd > now() AND accountProductID = 2 AND accountDoctorId=#params.key#", group="accountDoctorId")>

		<cfset isYext = model("AccountDoctor").Yext(params.key)>

		<cfif (isAdvertiser IS FALSE) OR (isEnhanced IS TRUE)>
			<cfif isYext IS TRUE>
				<cfset adType = "yext">
				<cfset doNotIndex = true>
			<cfelseif isPastAdvertiser IS TRUE>
				<cfset adType = "pastadvertiser">
			<cfelseif isBasicPlus IS TRUE>
				<cfset adType = "basicplus">
			<cfelse>
				<cfset adType = "basic">
			</cfif>

			<cfset displayAd = TRUE>
		</cfif>

		<cfif isAdvertiser OR (isBasicPlus and not isBasicPlusOver2Leads AND NOT isBasicPlusOver2UnopenedLeads)>
			<cfset hasContactForm = TRUE>
		</cfif>

		<cfif practice.accountId EQ 90>
			<cfset addressRequired = TRUE>
		</cfif>


		<cfif isAdvertiser IS TRUE>
			<cfset latestPictures		= model("GalleryCase")
												.findAll(
													select	= "gallerycases.id AS galleryCaseId, procedures.name, procedures.siloName, gallerycasedoctors.accountDoctorId, gallerycaseangles.id AS galleryCaseAngleId, accountdoctors.firstName, accountdoctors.lastName, accountdoctors.middleName",
													include	= "galleryCaseProcedures(procedure),galleryCaseDoctors(accountDoctor),galleryCaseAngles",
													where	= "accountDoctorId=#params.key# AND gallerycaseprocedures.isPrimary = 1 AND gallerycaseangles.id IS NOT NULL",
													order	= "gallerycases.id DESC, gallerycaseangles.orderNumber asc",
													group	= "gallerycases.id",
													$limit	= "4")>
		<cfelse>
			<cfset latestPictures = QueryNew("")>
		</cfif>

		<cfset accountInfo			= model("AccountLocationSpecialty")
											.findAll(
												select	= "accountlocationspecialties.id,accountlocationspecialties.specialtyId,accountlocationspecialties.accountDoctorLocationId,accountlocationspecialties.accountDescriptionId,accountlocationspecialties.accountInformationId,accountlocationspecialties.accountFeaturedStatementId,accountlocationspecialties.accountWebsiteId,
															accountinformation.content,accountwebsites.url",
												include	= "accountInformation,accountWebsite",
												where	= "accountDoctorLocationId=#doctorLocation.id#")>
		<cfset accountName			= model("Account")
											.findAll(
												select	= "name",
												where	= "id=#practice.accountId#")>

		<cfset certifications	= model("AccountDoctorCertification").GetDoctorsCertifications( accountDoctorId	= params.key)>

		<cfset spokenLanguages	= model("AccountLocationLanguage").findAll(
												select	= "languages.name",
												include = "Language",
												where	= "accountDoctorLocationId = #val(currentLocation.id)#")>

		<!--- <cfset topSpecialties		= model("SpecialtyProcedureRankingSummary")
											.getTopSpecialtiesForDoctor(accountDoctorId = params.key, limit = 5)>

		<cfset mainSpecialty		= model("SpecialtyProcedureRankingSummary")
											.getTopSpecialtiesForDoctor(accountDoctorId = params.key, limit = 1)> --->

		<cfset topSpecialties 		= model("Specialty").topSpecialtyForDoctorLocation(
												doctorLocationID = doctorLocation.id,
												limit			 = 5)>
		<cfset mainSpecialty 		= model("Specialty").topSpecialtyForDoctorLocation(
												doctorLocationID = doctorLocation.id,
												limit			 = 1)>
		<cfset specialtyInfo = mainSpecialty>

		<cfset isPremier	= model("AccountLocationSpecialty").findAll(
												select	= "specialties.isPremier",
												include	= "Specialty",
												where	= "accountLocationSpecialties.accountDoctorLocationId = #val(currentLocation.id)# AND specialties.isPremier = 1",
												$limit	= "1")>
		<cfset isPremier = isPremier.recordCount>


		<cfset DoctorOrPracticeName = trim(doctor.fullNameWithTitle) neq "" ? doctor.fullNameWithTitle : practice.name>
		<cfset FormalDoctorOrPracticeName = trim(doctor.fullNameWithTitle) neq "" ? "#mainSpecialty.doctorSingular# #doctor.fullNameWithTitle#" : practice.name>

		<cfset topProcedures		= model("AccountDoctorSpecialtyTopProcedure")
											.findAllByAccountDoctorId(
												select	= "accountdoctorspecialtytopprocedures.procedureId, accountdoctorspecialtytopprocedures.specialtyId, accountdoctorspecialtytopprocedures.accountDoctorId, procedures.name, procedures.siloName",
												value	= params.key,
												include	= "procedure",
												where	= "specialtyId = #Iif(mainSpecialty.recordcount,mainSpecialty.id,0)#",
												group="procedureId")>
		<cfset topProcedureIds		=	ValueList(topProcedures.procedureId)>
		<cfif topProcedureIds eq "">
			<cfset topProcedureIds = ValueList(procedures.id)>
		</cfif>
		<cfset topProcedureNames	=	ValueList(topProcedures.name,", ")>

		<cfset insider				=	model("AccountDoctorInsiderQuestionAnswer")
											.findAllByAccountDoctorId(
												value 	= params.key,
												select	= "name, answer",
												include	= "insiderQuestion")>

		<cfset top5Benefits			=	model("AccountPracticeTopBenefit")
											.findAllByAccountPracticeId(
												select	= "accountpracticetopbenefits.id,accountpracticetopbenefits.accountPracticeId,accountpracticetopbenefits.sequence,accountpracticetopbenefits.name",
												value	= practice.accountPracticeId,
												order	= "sequence")>
		<cfset feederMarkets		=	model("AccountPracticeFeederMarket")
											.findAllByAccountPracticeId(
												select	= "accountpracticefeedermarkets.id,accountpracticefeedermarkets.accountPracticeId,accountpracticefeedermarkets.sequence,accountpracticefeedermarkets.name",
												value	= practice.accountPracticeId,
												order	= "sequence")>
		<cfset staffInfo			=	model("AccountDoctorLocationStaff")
											.findAll(
												select	= "accountdoctorlocationstaffs.id, accountdoctorlocationstaffs.photofilename, accountdoctorlocationstaffs.name, accountdoctorlocationstaffs.title, accountdoctorlocationstaffs.description, accountdoctorlocationstaffs.testimonial",
												include	= "accountDoctorLocation",
												where	= "accountDoctorId = #params.key# AND accountLocationId = #val(currentLocation.id)# AND accountdoctorlocationstaffs.display = 1")>
		<cfset coupons				=	model("Coupon")
											.findAll(
												select	= "accountdoctorlocations.accountDoctorId, coupons.id, coupons.title, coupons.details, coupons.ExpirationDate",
												include	= "accountDoctorLocationCoupon(accountDoctorLocation(accountLocation))",
												where	= "accountDoctorId = #params.key# AND accountLocationId = #val(currentLocation.id)# AND expirationDate >= Now() AND display = 1" & (isAdvertiser ? "" : " AND display = 0"),
												group	= "coupons.id")>
		<cfset recommendations		=	model("AccountDoctorLocationRecommendation")
											.findAll(
												select	= "accountdoctorlocationrecommendations.stateId,
											accountdoctorlocationrecommendations.showEmail,
											accountdoctorlocationrecommendations.specialtyId,
											accountdoctorlocationrecommendations.accountDoctorLocationId,
											accountdoctorlocationrecommendations.firstName,
											accountdoctorlocationrecommendations.content,
											accountdoctorlocationrecommendations.id,
											accountdoctorlocationrecommendations.email,
											accountdoctorlocationrecommendations.city,
											accountdoctorlocationrecommendations.approvedAt,
											accountdoctorlocationrecommendations.rating,
											accountdoctorlocationrecommendations.lastName,
											accountdoctorlocationrecommendations.showName,
											accountdoctorlocationrecommendations.createdAt,
											case when showPhoto = 1 then photoLocation else '' end as photoLocation,
											states.abbreviation as state,
											'' as procedureList",
												include	= "accountDoctorLocation,state,user",
												where	= "accountDoctorId=#params.key# AND approvedAt IS NOT NULL",
												order	= "accountdoctorlocationrecommendations.createdAt DESC")>
		<cfset creditcards				=	model("accountDoctorCreditCard")
											.findAll(
												select	= "creditcards.logoPath",
												include	= "creditCard",
												where	= "accountDoctorId = #params.key#")>
		<cfset financingoptions			=	model("Association")
											.findAll(
												select	= "associations.id, associations.name",
												include	= "accountDoctorAssociations",
												where	= "accountDoctorId = #params.key# AND associations.type = 'FINANCING'")>

		<cfset financingSpecialties	= model("AccountDoctorLocation").findAll(
									select	= "specialties.id",
									include	= "accountLocationSpecialties(specialty)",
									where	= "accountdoctorlocations.accountDoctorId = #params.key# AND specialties.hasFinancing = 1")>

		<cfif financingSpecialties.recordCount>
			<cfset HasFinancingSpeciaties = TRUE>
		<cfelse>
			<cfset HasFinancingSpeciaties = FalSE>
		</cfif>

		<cfset insurance				=	model("AccountDoctorInsurance")
											.findAll(
												select	= "insurance.name",
												include	= "insurance",
												where	= "accountDoctorId = #params.key#",
												order   = "mostPlansAccepted asc,callOffice asc,name asc")>
		<cfset isAdvisoryBoard			=	model("accountDoctorAssociation").findAll(
												where	= "accountDoctorId = #params.key# AND associationId = 9"
											).recordcount gt 0>

		<cfset hasQAs = model("AskADocQuestion").GetDoctorsQAs(	accountDoctorId = params.key, limit = 1).recordCount>

		<cfset UPS = model("UPS3D").findall(
			select="url,width,height",
			where="accountId = #practice.AccountID#"
		)>
		<cfif UPS.RecordCount>
			<cfif not Server.isInteger(UPS.width)>
				<cfset UPS.width = 701>
			</cfif>
			<cfif not Server.isInteger(UPS.height)>
				<cfset UPS.height = 557>
			</cfif>
		</cfif>

		<cfif val(params.m) gt 0>
			<cfif model("ProfileMiniLead").findAll(where="id = #val(params.m)# AND accountDoctorId = #val(params.key)#").recordcount>
				<cfset params.miniID = val(params.m)>
			</cfif>
		</cfif>

		<cfset tabs = getTabs()>

		<cfset arrayAppend(breadcrumbs,linkTo(controller="doctors",text="Find a Doctor"))>
		<cfset arrayAppend(breadcrumbs,linkTo(href="/doctors/#mainSpecialty.siloname#/#currentLocation.citysiloname#-#LCase(currentLocation.stateabbreviation)#",text="#currentLocation.cityname# #mainSpecialty.name#"))>
		<cfset arrayAppend(breadcrumbs,doctor.fullNameWithTitle)>

		<cfif isBasic AND recommendations.recordCount EQ 0 AND NOT isPremier>
			<cfset doNotIndex = true>
		</cfif>

		<!--- <cfoutput>
			ArrayLen(tabs) = #ArrayLen(tabs)#<br />
			<cfdump var="#tabs#"><br />
		</cfoutput>
		<cfabort> --->

		<cfif isBasic AND recommendations.recordCount EQ 0 AND isPremier
				AND ArrayLen(tabs) EQ 1 AND ListContainsNoCase(tabs[1], "reviews")>
			<cfset doNotIndex = true>
		</cfif>

		<!--- Flash variables seem to be unable to survive https -> http
			  transitions, so client variables are used to preserve them. --->
		<cfparam name="Client.miniErrorList" default="">
		<cfparam name="Client.miniFormData" default="">
		<cfset Variables.miniErrorList = "">
		<cfset Variables.miniFormData = "">
		<cfif Client.miniErrorList neq "">
			<cfset Variables.miniErrorList = Client.miniErrorList>
			<cfset Variables.miniFormData = Client.miniFormData>
		</cfif>
		<cfset Client.miniErrorList = "">
		<cfset Client.miniFormData = "">

		<cfset stylesheetLinkTag(sources="profile/main", head=true)>

		<!--- TODO: make sure data for view exists --->
	</cffunction>

	<cffunction name="flexVideo" access="private">
		<cfset var Local = {}>
		<cfset Local.flexVideoDoctorIds = "1020,314988,315002">
		<cfset flexVideo = {}>
		<cfif ListFind(Local.flexVideoDoctorIds, params.key)>
			<!--- Arabitg --->
			<cfset flexVideo[1020] = {}>
			<cfset flexVideo[1020].name = "arabitg">
			<cfset flexVideo[1020].description = "This Insider video is an informative question and answer session with Doctor Arabitg of the Cosmabella Center for Plastic Surgery. Doctor Arabitg is an Orlando, Fl plastic surgeon who performs procedures such as Face and Neck Lifts, Nasal and Sinus Surgery, Rhinoplasty, BOTOX, CosmoDerm and Cosmoplast, Sculptra, Hylaform Gel, Radiance for lip augmentation, Eyelid Surgery, and Otoplasty otherewise known as ear pinning.">
			<!--- Jabor --->
			<cfset flexVideo[314988] = {}>
			<cfset flexVideo[314988].name = "jabor">
			<cfset flexVideo[314988].description = "Dr. Mark Jabor, at the Cosmetic Laser & Surgery Center of El Paso, has treated well over ten thousand patients. His practice offers eye lifts, eyelid surgery, and endoscopic brow lift, BOTOX and more.">
			<cfset flexVideo[315002] = flexVideo[314988]>
		</cfif>
	</cffunction>

	<cffunction name="pixelfish" access="private">
		<cfparam name="params.key" type="integer" default="0"><!--- Should be accountDoctorID --->
		<cfset var Local = StructNew()>
		<cfset var i = 0>
		<cfset pixelfish = StructNew()>


		<cfset Local.rgxBadForHtml = "[^a-zA-Z0-9 _:&;=##\n\r\-\?!\.,]">
		<cfset Local.quotes = "'," & '",' & "#Chr(8220)#,#Chr(8221)#,#Chr(8216)#,#Chr(8217)#">
		<cfset Local.quoteReplacements = "&##39;,&##34;,&ldquo;,&rdquo;,&lsquo;,&rsquo;">

		<cfset pixelfish.show = false>
		<cfset pixelfish.width = 560><!--- was 550 --->
		<cfset pixelfish.height = 339><!---was 334 --->

		<!--- Only show video carousel for advertisers --->
		<cfif not isAdvertiser><cfreturn></cfif>

		<cfset Local.docsVideos = model("Video").GetDoctorsVideos( accountDoctorId	= params.key)>

		<cfif Local.docsVideos.RecordCount>
			<!--- Prevent unwanted characters from breaking the page. --->
			<cfloop query="Local.docsVideos">
			 <cfscript>
				i = CurrentRow;

				Local.docsVideos.headline[i] = ReplaceList(Local.docsVideos.headline[i], Local.quotes, Local.quoteReplacements);
				Local.docsVideos.description[i] = ReplaceList(Local.docsVideos.description[i], Local.quotes, Local.quoteReplacements);
 				Local.docsVideos.headline[i] = REReplace(Local.docsVideos.headline[i], Local.rgxBadForHtml, "_", "ALL");
 				Local.docsVideos.description[i] = REReplace(Local.docsVideos.description[i], Local.rgxBadForHtml, "_", "ALL");

				//Make the description safe for use as a JS function argument
				Local.docsVideos.description[i] = REReplace(Local.docsVideos.description[i], "[\n\r]{2,}", "</p><p>", "ALL");
				Local.docsVideos.description[i] = REReplace(Local.docsVideos.description[i], "[\n\r]", "<br />", "ALL");
				Local.docsVideos.description[i] = '<p style=\"margin-top: 0;\">' & Local.docsVideos.description[i] & '</p>';


				if(get('environment') NEQ 'production')
				{
					Local.docsVideos.imagePreview[i] = 'http://dev3.locateadoc.com' & Local.docsVideos.imagePreview[i];
					Local.docsVideos.imageThumbnail[i] = 'http://dev3.locateadoc.com' & Local.docsVideos.imageThumbnail[i];
				}
			 </cfscript>
			</cfloop>


			<cfset pixelfish.videos = Local.docsVideos>
			<cfset pixelfish.show = true>
		</cfif>
	</cffunction>

	<cffunction name="getTabs" access="private">
		<cfparam name="params.miniID" default="0">
		<cfparam name="form.process_contact" default="0">
		<cfset var Local = {}>
		<cfset Local.tabs = []>
		<cfset redirectToFirst = false>

		<cfset Local.baseSiloURL = "/#params.siloname##params.silodoctorid neq "" ? "-#params.silodoctorid#" : ""#">
		<!--- Order: li class, text, action, "a tag" class --->
		<cfif (certifications.recordCount or len(trim(doctor.pledge)) or len(trim(doctor.patientTestimonial)) or len(trim(accountInfo.content)) or top5Benefits.recordCount or topProcedures.recordCount or feederMarkets.recordCount)>
			<cfset ArrayAppend(Local.tabs, "welcome|Welcome| |Welcome| ")>
		<cfelseif params.action eq "welcome">
			<cfset redirectToFirst = true>
		</cfif>

		<cfif insider.recordCount or len(trim(doctor.education)) or len(trim(doctor.affiliation))>
			<cfset ArrayAppend(Local.tabs, "about|About the Doctor|about|About| ")>
			<cfif redirectToFirst>
				<cflocation url="#Local.baseSiloURL#/about" addtoken="no" statuscode="301">
			</cfif>
		<cfelseif params.action eq "about">
			<cflocation url="#Local.baseSiloURL#" addtoken="no" statuscode="301">
		</cfif>

		<cfif staffInfo.recordCount>
			<cfset ArrayAppend(Local.tabs, "practice|Our Staff|staff|Staff| ")>
			<cfif redirectToFirst>
				<cflocation url="#Local.baseSiloURL#/staff" addtoken="no" statuscode="301">
			</cfif>
		<cfelseif params.action eq "staff">
			<cflocation url="#Local.baseSiloURL#" addtoken="no" statuscode="301">
		</cfif>

		<cfif coupons.recordCount>
			<cfset ArrayAppend(Local.tabs, "offers|Special Offers|offers|Offers| ")>
			<cfif redirectToFirst>
				<cflocation url="#Local.baseSiloURL#/offers" addtoken="no" statuscode="301">
			</cfif>
		<cfelseif params.action eq "offers">
			<cflocation url="#Local.baseSiloURL#" addtoken="no" statuscode="301">
		</cfif>

		<cfif latestPictures.recordCount and isAdvertiser>
			<cfif params.action is "case">
				<cfset ArrayAppend(Local.tabs, "before|Before and After Pictures|pictures|Pictures|active")>
			<cfelse>
				<cfset ArrayAppend(Local.tabs, "before|Before and After Pictures|pictures|Pictures| ")>
			</cfif>
			<cfif redirectToFirst>
				<cflocation url="#Local.baseSiloURL#/pictures" addtoken="no" statuscode="301">
			</cfif>
		<cfelseif params.action eq "pictures">
			<cflocation url="#Local.baseSiloURL#" addtoken="no" statuscode="301">
		</cfif>

		<cfif isAdvertiser OR (isBasicPlus AND hasContactForm) OR hasQAs>
			<cfset ArrayAppend(Local.tabs, "askadoctor|Ask A Doctor|askadoctor|Ask| ")>
		<cfelseif params.action eq "askadoctor">
			<cfset redirectToFirst = true>
		</cfif>

		<cfset ArrayAppend(Local.tabs, "reviews|Reviews|reviews|Reviews| ")>

		<cfif redirectToFirst>
			<cflocation url="#Local.baseSiloURL#/reviews" addtoken="no" statuscode="301">
		</cfif>

		<cfif financingoptions.recordCount>
			<cfset ArrayAppend(Local.tabs, "financing|Financing|financing|Financing| ")>
		<cfelseif params.action eq "financing">
			<cflocation url="#Local.baseSiloURL#" addtoken="no" statuscode="301">
		</cfif>

		<cfif hasContactForm>
			<cfset ArrayAppend(Local.tabs, "contact|Contact Doctor|contact|Contact| ")>
		<cfelseif params.action eq "contact" and val(params.miniID) eq 0 and val(form.process_contact) eq 0>
			<cflocation url="#Local.baseSiloURL#" addtoken="no" statuscode="301">
		</cfif>


		<!--- Set current --->
		<cfset Local.currentTab = ListContains(ArrayToList(Local.tabs),params.action)>
		<cfif Local.currentTab neq 0>
			<cfset Local.tabs[Local.currentTab] = Local.tabs[Local.currentTab] & "active">
		</cfif>

		<cfreturn Local.tabs>
	</cffunction>

	<cffunction name="AddComment" access="private">
		<cfparam name="params.firstname" default="">
		<cfparam name="params.lastname" default="">
		<cfparam name="params.showname" default="1">
		<cfparam name="params.showphoto" default="0">
		<cfparam name="params.city" default="">
		<cfparam name="params.state" default="0">
		<cfparam name="params.email" default="">
		<cfparam name="params.procedures" default="">
		<cfparam name="params.reviewComment" default="">
		<cfparam name="params.rating" default="5">
		<cfparam name="params.captcha_input" default="">
		<cfparam name="params.captcha_check" default="">
		<cfparam name="Client.FacebookID" default="0">

		<!--- Filter and validate input --->
		<cfset errorList = "">
		<cfset params.firstname = HTMLEditFormat(trim(params.firstname))>
		<cfif params.firstname eq "">
			<cfset errorList = ListAppend(errorList,"firstname")>
		</cfif>
		<cfset params.lastname = HTMLEditFormat(trim(params.lastname))>
		<cfif params.lastname eq "">
			<cfset errorList = ListAppend(errorList,"lastname")>
		</cfif>
		<cfset params.city = HTMLEditFormat(trim(params.city))>
		<cfif params.city eq "">
			<cfset errorList = ListAppend(errorList,"city")>
		</cfif>
		<cfset params.state = Val(trim(params.state))>
		<cfif params.state eq 0>
			<cfset errorList = ListAppend(errorList,"state")>
		</cfif>
		<cfset params.email = trim(params.email)>
		<!--- <cfif REFind("^[a-z0-9!##$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!##$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$",params.email) eq 0> --->
		<cfif not isEmail(params.email)>
			<cfset errorList = ListAppend(errorList,"email")>
		</cfif>
		<cfset params.procedures = trim(params.procedures)>
		<cfif params.procedures neq "" and REFind("^([0-9]+,?)+$",params.procedures) eq 0 and variables.procedures.recordcount gt 0>
			<cfset errorList = ListAppend(errorList,"procedures")>
		</cfif>
		<cfset params.reviewComment = trim(params.reviewComment)>
		<cfif params.reviewComment eq "">
			<cfset errorList = ListAppend(errorList,"comments")>
		</cfif>
		<cfset params.rating = trim(params.rating)>
		<cfif (REFind("^[0-9]+$",params.rating) eq 0) or (val(params.rating) lt 0 or val(params.rating) gt 10)>
			<cfset errorList = ListAppend(errorList,"rating")>
		</cfif>
		<cfif params.captcha_input eq "" or params.captcha_check eq ""
			or Decrypt(URLDecode(params.captcha_check), captcha_key, "BLOWFISH") neq params.captcha_input>
			<cfset errorList = ListAppend(errorList,"captcha")>
		</cfif>
		<cfif params.showname neq 1><cfset params.showname = 0></cfif>
		<!--- Verify facebook user logged in for photo opt-in --->
		<cfif params.showphoto eq 1>
			<cfif isNumeric(Request.oUser.id)>

				<cfset VerifyFB = model("FacebookUser").VerifyFB()>
				<!---
					I think the cfwheels orm does not like that uid is a big int. I converted to a query above
					<cfset verifyFB = model("FacebookUser").findAll(
					where="uid	= '#Client.FacebookID#' AND userID	= '#Request.oUser.id#'"
				)> --->
			<cfelse>
				<cfset verifyFB = queryNew("")>
			</cfif>
			<cfif verifyFB.recordcount eq 0>
				<cfset params.showphoto = 0>
			</cfif>
		<cfelse>
			<cfset params.showphoto = 0>
		</cfif>

		<cfif errorList eq "">
			<!--- duplicate check --->
			<cfset dupeCheck = model("AccountDoctorLocationRecommendation").dupeCheck(
					accountDoctorLocationId = "#doctorLocation.id#",
					email = "#params.email#",
					content = "#params.reviewComment#"
			)>
			<cfif dupeCheck eq 0>
				<cfset Request.oUser.saveUserInfo(params)>
				<cfset newComment = model("AccountDoctorLocationRecommendation").create(
					accountDoctorLocationId = "#doctorLocation.id#",
					firstName = "#params.firstname#",
					lastName = "#params.lastname#",
					email = "#params.email#",
					city = "#left(params.city, 32)#",
					stateId = "#params.state#",
					content = "#params.reviewComment#",
					rating = "#(isnumeric(params.rating) ? params.rating : NULL)#",
					showName = "#params.showname#",
					showEmail = 0,
					showPhoto = params.showphoto,
					userid = "#(val(Request.oUser.id) gt 0) ? Request.oUser.id : ''#",
					specialtyId = topSpecialties.id
				)>
				<cfloop list="#params.procedures#" index="i">
					<cfset newProcedure = model("AccountDoctorLocationRecommendationProcedure").create(
						accountDoctorLocationRecommendationId = "#newComment.id#",
						procedureID = "#i#"
					)>
				</cfloop>

				<cfset stateAbbreviation = Model('State').findByKey(newComment.stateId).abbreviation>
				<!--- Forward comment to 2.0 --->
				<cfquery datasource="myLocateadoc">
					INSERT INTO myLocateadoc.doc_recommendations
					(sid, info_id, firstname, lastname, from_email, from_city, from_st,
					show_name, show_email, rec_tx, procedure_name_ids, added_dt, womm)
					VALUES (
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#val(newComment.specialtyId)#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#newComment.accountDoctorLocationId#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#newComment.firstName#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#newComment.lastName#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#newComment.email#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#newComment.city#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#stateAbbreviation#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#newComment.showName#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#newComment.showEmail#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#newComment.content#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.procedures#">,
					now(),
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#newComment.rating#">
					);
				</cfquery>

				<cfset successMessage = "Thanks for sharing your experience with us.  You will receive an email confirmation once your review is added below.">
			</cfif>
			<!--- clear out the form variables --->
			<cfloop collection="#params#" item="i">
				<cfif ListContains("firstname,lastname,showname,city,email,procedures,reviewComment,rating,captcha_input,captcha_check",LCase(i))>
					<cfset params[i] = "">
				<cfelseif ListContains("state",LCase(i))>
					<cfset params[i] = 0>
				</cfif>
			</cfloop>
		</cfif>

	</cffunction>

	<cffunction name="processMiniLead" access="private">
		<cfparam name="params.process_mini" default="0">
		<cfparam name="params.firstname" default="">
		<cfparam name="params.lastname" default="">
		<cfparam name="params.email" default="">
		<cfparam name="params.phone" default="">
		<cfparam name="params.leadTypeId" default="">
		<cfparam name="params.procedures" default="">

		<!--- Filter and validate input --->
		<cfset errorList = "">
		<cfset params.firstname = HTMLEditFormat(trim(params.firstname))>
		<cfif params.firstname eq "" or params.firstname eq "First Name" or len(params.firstname) gt 50>
			<cfset errorList = ListAppend(errorList,"firstname")>
		</cfif>
		<cfset params.lastname = HTMLEditFormat(trim(params.lastname))>
		<cfif params.lastname eq "" or params.lastname eq "Last Name" or len(params.lastname) gt 50>
			<cfset errorList = ListAppend(errorList,"lastname")>
		</cfif>
		<cfset params.email = trim(params.email)>
		<cfif not isEmail(params.email)>
			<cfset errorList = ListAppend(errorList,"email")>
		</cfif>
		<cfset params.phone = HTMLEditFormat(trim(params.phone))>
		<cfif Len(REReplace(params.phone,"[^0-9]","","all")) lt 10>
			<cfset errorList = ListAppend(errorList,"phone")>
		</cfif>
		<cfset params.procedures = REReplace(params.procedures,"[^0-9,]","")>

		<cfif errorList neq "" or ListFind("1,2,3",params.process_mini) eq 0>
			<cfset Client.miniErrorList = "#params.process_mini#,#errorList#">
			<cfset Client.miniFormData = "fn=#params.firstname#,ln=#params.lastname#,em=#params.email#,ph=#params.phone#">
			<cfset redirectTo(back=true)>
		<cfelse>
			<!--- Save user info --->
			<cfset Request.oUser.saveUserInfo(params)>

			<!--- Mark any duplicates detected within the last 24 hours --->
			<cfset model("ProfileMiniLead").updateAll(
				isDuplicate = 1,
				where = "email = '#params.email#' AND accountDoctorId = #doctor.id# AND createdAt > '#DateAdd('h',-24,now())#'"
			)>

			<!--- Create mini lead record --->
			<cfset newMiniLead	= model("ProfileMiniLead").create(
				accountDoctorId	= "#params.key#",
				firstName		= "#params.firstname#",
				lastName		= "#params.lastname#",
				email			= "#params.email#",
				phone			= "#params.phone#",
				ipAddress		= "#CGI.REMOTE_ADDR#",
				refererExternal	= "#(Client.ReferralFull neq "")?Client.ReferralFull:"N/A"#",
				refererInternal	= "#(CGI.HTTP_REFERER neq "")?CGI.HTTP_REFERER:"N/A"#",
				entryPage		= "#Client.EntryPage#",
				keywords		= "#Client.KEYWORDS#",
				cfId			= "#client.CFID#",
				cfToken			= "#client.CFTOKEN#"
			)>

			<!--- Storing lead to 2.0 DB --->
			<cfset params.miniID = model("ProfileMiniLead").submitToLAD2(
				accountDoctorId	= "#params.key#",
				firstName		= "#params.firstname#",
				lastName		= "#params.lastname#",
				email			= "#params.email#",
				phone			= "#params.phone#",
				specialtyId		= "#Iif(mainSpecialty.recordcount,mainSpecialty.id,0)#",
				ipAddress		= "#CGI.REMOTE_ADDR#",
				refererExternal	= "#(Client.ReferralFull neq "")?Client.ReferralFull:"N/A"#",
				refererInternal	= "#(CGI.HTTP_REFERER neq "")?CGI.HTTP_REFERER:"N/A"#",
				entryPage		= "#Client.EntryPage#",
				keywords		= "#Client.KEYWORDS#",
				leadTypeId		= "#params.leadTypeId#",
				cfId			= "#client.CFID#",
				cfToken			= "#client.CFTOKEN#",
				miniProcedures	= "#params.procedures#"
			)>

			<!--- <cfset params.miniID = newMiniLead.key()>	 --->

			<cfinvoke method="leadEmail"
				firstName="#params.firstname#"
				lastName="#params.lastname#"
				email="#params.email#"
				leadTypeId="#params.leadTypeId#"
				miniID="#params.miniID#"
			>

			<!--- Check if the doctor is a basic plus who just used up their free leads. If so, notify them. --->
			<cfif model("AccountDoctor").BasicPlusOverLeadThreshold(params.key)>
				<cfset model("AccountDoctorLocation").BasicPlusThresholdEmail(doctorLocation.id,params.email)>
			</cfif>

		</cfif>
	</cffunction>

	<cffunction name="processContact" access="private">
		<cfparam name="form.process_contact" default="0">
		<cfparam name="params.contactID" default="">

		<cfparam name="params.firstname" default="">
		<cfparam name="params.lastname" default="">
		<cfparam name="params.address" default="">
		<cfparam name="params.city" default="">
		<cfparam name="params.state" default="0">
		<cfparam name="params.postalCode" default="">
		<cfparam name="params.country" default="0">
		<cfparam name="params.Phone" default="">
		<cfparam name="params.altPhone" default="">
		<cfparam name="params.email" default="">
		<cfparam name="params.age" default="">
		<cfparam name="params.patientGender" default="">
		<cfparam name="params.procedures" default="">
		<cfparam name="params.time" default="">
		<cfparam name="params.information" default="">
		<cfparam name="params.miniID" default="0">

		<cfparam name="params.contactoption" default="">
		<cfparam name="params.height" default="">
		<cfparam name="params.weight" default="">
		<cfparam name="params.smoke" default="">
		<cfparam name="params.contactday" default="">
		<cfparam name="params.contacttime" default="">
		<cfparam name="params.question1" default="">
		<cfparam name="params.question2" default="">
		<cfparam name="params.question3" default="">
		<cfparam name="params.question4" default="">
		<cfparam name="params.question5" default="">
		<cfparam name="params.question6" default="">
		<cfparam name="params.seminar" default="">
		<cfparam name="params.financing" default="">
		<cfparam name="params.newsletter" default="">
		<!--- <cfparam name="params.spa" default=""> --->

		<cfset specialtyQuestions = model("ProfileSpecialtyQuestion").findAll(
			select="profilespecialtyquestions.id, name, fieldType, display, value",
			include="profileQuestionAnswers",
			where="specialtyid IN (#ListAppend('0',topSpecialties.id)#) AND fieldName != 'howsoon'",
			order="profilespecialtyquestions.sequence asc, profilequestionanswers.sequence asc")>

		<cfquery name="questionIDs" dbtype="query">
			SELECT DISTINCT id, fieldType FROM specialtyQuestions;
		</cfquery>
		<cfloop query="questionIDs">
			<cfparam name="params.q_#questionIDs.id#" default="">
		</cfloop>

		<cfset errorList = "">

		<cfif form.process_contact eq 1>

			<!--- Filter and validate page 1 input --->
			<cfset params.firstname = HTMLEditFormat(trim(params.firstname))>
			<cfif params.firstname eq "" or len(params.firstname) gt 50>
				<cfset errorList = ListAppend(errorList,"firstname")>
			</cfif>
			<cfset params.lastname = HTMLEditFormat(trim(params.lastname))>
			<cfif params.lastname eq "" or len(params.lastname) gt 50>
				<cfset errorList = ListAppend(errorList,"lastname")>
			</cfif>
			<cfset params.address = HTMLEditFormat(trim(params.address))>
			<cfif params.address eq "" AND addressRequired IS TRUE>
				<cfset errorList = ListAppend(errorList,"address")>
			</cfif>
			<cfset params.city = HTMLEditFormat(trim(params.city))>
			<cfif params.city eq "" or len(params.city) gt 50>
				<cfset errorList = ListAppend(errorList,"city")>
			</cfif>
			<cfset params.state = Val(trim(params.state))>
			<cfif params.state eq 0>
				<cfset errorList = ListAppend(errorList,"state")>
			</cfif>
			<cfset params.postalCode = HTMLEditFormat(trim(params.postalCode))>
			<cfif params.postalCode eq "" or len(params.postalCode) gt 15>
				<cfset errorList = ListAppend(errorList,"postalCode")>
			</cfif>
			<cfset params.phone = HTMLEditFormat(trim(params.phone))>
			<cfif Len(REReplace(params.phone,"[^0-9]","","all")) lt 10>
				<cfset errorList = ListAppend(errorList,"phone")>
			</cfif>
			<cfset params.email = trim(params.email)>
			<cfif not isEmail(params.email) or len(params.email) gt 100>
				<cfset errorList = ListAppend(errorList,"email")>
			</cfif>
			<cfset params.age = HTMLEditFormat(trim(params.age))>
			<cfif params.age eq "">
				<cfset errorList = ListAppend(errorList,"age")>
			</cfif>
			<cfif ListFind("m,f",params.patientGender) eq 0>
				<cfset errorList = ListAppend(errorList,"patientGender")>
			</cfif>

			<!--- If any of the first page info is invalid, return to page 1 --->
			<cfif errorList neq "">
				<cfreturn {page=1,errorList=errorList}>
			</cfif>

			<!--- Save user info --->
			<cfset Request.oUser.saveUserInfo(params)>

			<!--- Submit lead to 2.0 database --->
			<cfset newLeadLAD2 = model("ProfileLead").submitToLAD2Page1(
				accountDoctorLocationId = "#doctorLocation.id#",
				firstName			= "#params.firstname#",
				lastName			= "#params.lastname#",
				address				= "#params.address#",
				city				= "#params.city#",
				stateId				= "#params.state#",
				postalCode			= "#params.postalCode#",
				phoneHome			= "#params.phone#",
				email				= "#params.email#",
				age					= "#params.age#",
				gender				= "#params.patientGender#",
				ipAddress			= "#CGI.REMOTE_ADDR#",
				refererExternal		= "#Client.ReferralFull#",
				refererInternal		= "#CGI.HTTP_REFERER#",
				entryPage			= "#Client.EntryPage#",
				keywords			= "#Client.KEYWORDS#",
				cfId				= "#client.CFID#",
				cfToken				= "#client.CFTOKEN#"
			)>
			<cfset params.contactIDLAD2 = newLeadLAD2>

			<!--- Mark any duplicates detected within the last hour --->
			<cfset model("ProfileLead").updateAll(
				isDuplicate = 1,
				where = "email = '#params.email#' AND accountDoctorId = #doctor.id# AND createdAt > '#DateAdd('h',-1,now())#'"
			)>

			<!--- Write the first page data into the database --->
			<!--- <cfset newLead = model("ProfileLead").create(
				accountDoctorId	= "#doctor.id#",
				firstName = "#params.firstname#",
				lastName = "#params.lastname#",
				address = "#params.address#",
				city = "#params.city#",
				stateId = "#params.state#",
				postalCode = "#params.postalCode#",
				phoneHome = "#params.phone#",
				email = "#params.email#",
				age = "#params.age#",
				gender = "#params.patientGender#",
				pageNumber = 1,
				ipAddress = "#CGI.REMOTE_ADDR#",
				refererExternal = "#Client.ReferralFull#",
				refererInternal = "#CGI.HTTP_REFERER#",
				entryPage = "#Client.EntryPage#",
				keywords = "#Client.KEYWORDS#",
				cfId = "#client.CFID#",
				cfToken = "#client.CFTOKEN#"
			)>
			<cfset params.contactID = newLead.key()> --->

			<!--- If there was a mini lead, indicate that it had lead to a full lead --->
			<cfif val(params.miniID) gt 0>
				<cfset model("ProfileMiniLead").updateAll(
					hasProfileLead = 1,
					where = "id = #val(params.miniID)# AND email = '#params.email#' AND accountDoctorId = #doctor.id#"
				)>
			</cfif>

			<cfif params.newsletter eq 1>
				<!--- If they opted for the newsletter, add them to the newsletter table --->
				<cfset state = {}>
				<cfif Server.isInteger(params.state)>
					<cfset state = model("State").findByKey(params.state)>
				<cfelse>
					<cfset state.name = "">
				</cfif>
				<cfset newsletterCheck = model("NewsletterBeautifulLiving").findAll(where="email = '#params.email#'",includeSoftDeletes=true)>
				<cfif newsletterCheck.recordcount eq 0>
					<cfset newNewsletter = model("NewsletterBeautifulLiving").create(
						specialtyId = topSpecialties.id,
						firstName = params.firstname,
						lastName = params.lastname,
						email = params.email,
						city = params.city,
						state = state.name,
						zip = params.postalCode
					)>
				<cfelse>
					<cfset updateNewsletter = model("NewsletterBeautifulLiving").updateByKey(
						key = newsletterCheck.id,
						deletedAt = "null",
						validate = false,
						includeSoftDeletes=true
					)>
				</cfif>
			</cfif>

			<cfif params.contactIDLAD2 gt 0>
				<!--- Add procedure selections to database --->
				<!--- <cfloop list="#params.procedures#" index="i">
					<cfset newProcedure = model("ProfileLeadProcedure").create(
						profileLeadId = "#params.contactID#",
						procedureId = "#i#"
					)>
				</cfloop> --->

				<!--- Go to page 2 --->
				<cfreturn {page=2,errorList=errorList}>
			<cfelse>
				<cfset errorList = ListAppend(errorList,"writeError")>
			</cfif>

		<cfelseif form.process_contact eq 2>

			<cfset params.contactIDLAD2 = Decrypt(URLDecode(params.contactIDLAD2), captcha_key, "BLOWFISH")>

			<!--- Filter and validate page 2 input --->
			<cfset params.procedures = trim(params.procedures)>
			<cfif REFind("^([0-9]+,?)+$",params.procedures) eq 0>
				<cfset errorList = ListAppend(errorList,"procedures")>
			</cfif>
			<cfset params.time = HTMLEditFormat(trim(params.time))>
			<cfif params.time eq "">
				<cfset errorList = ListAppend(errorList,"time")>
			</cfif>
			<cfset params.information = HTMLEditFormat(trim(params.information))>

			<!--- If any of the first page info is invalid, return to page 2 --->
			<cfif errorList neq "">
				<cfreturn {page=2,errorList=errorList}>
			</cfif>

			<!--- Submit page 2 to LAD2 DB --->
			<cfset newLeadLAD2 = model("ProfileLead").submitToLAD2Page2(
				contactID		= "#params.contactIDLAD2#",
				procedures		= "#params.procedures#",
				howSoon			= "#params.time#",
				comments		= "#params.information#"
			)>
			<!--- Write the data from page 2 into the database --->
			<!--- <cfset lead = model("ProfileLead").findByKey(params.contactID)>
			<cfset lead.update(
				pageNumber 			= 2,
				howSoon				= "#params.time#",
				comments			= "#params.information#"
			)> --->

			<cfif newLeadLAD2>
				<!--- Add procedure selections to database --->
				<!--- <cfloop list="#params.procedures#" index="i">
					<cfset newProcedure = model("ProfileLeadProcedure").create(
						profileLeadId = "#params.contactID#",
						procedureId = "#i#"
					)>
				</cfloop> --->

				<!--- Go to page 3 --->
				<cfreturn {page=3,errorList=errorList}>
			<cfelse>
				<cfset errorList = ListAppend(errorList,"writeError")>
			</cfif>

		<cfelseif form.process_contact eq 3>

			<cfset params.contactIDLAD2 = Decrypt(URLDecode(params.contactIDLAD2), captcha_key, "BLOWFISH")>

			<!--- Filter and validate the page 2 input --->
			<cfloop query="questionIDs">
				<cfset "params.q_#questionIDs.id#" = HTMLEditFormat(trim(Evaluate('params.q_#questionIDs.id#')))>
			</cfloop>
			<cfset params.contactoption = HTMLEditFormat(trim(params.contactoption))>
			<cfset params.height = HTMLEditFormat(trim(params.height))>
			<cfset params.weight = trim(params.weight)>
			<cfif params.weight neq "" and not isNumeric(params.weight)>
				<cfset errorList = ListAppend(errorList,"weight")>
			</cfif>
			<cfset params.smoke = Val(trim(params.smoke))>
			<cfset params.contactday = HTMLEditFormat(trim(params.contactday))>
			<cfif params.contactday neq "" and ListFind("Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday",params.contactday) eq 0>
				<cfset errorList = ListAppend(errorList,"contacttime")>
			</cfif>
			<cfset params.contacttime = HTMLEditFormat(trim(params.contacttime))>
			<cfif params.contacttime neq "" and ListFind("Morning,Afternoon,Evening",params.contacttime) eq 0>
				<cfset errorList = ListAppend(errorList,"contacttime")>
			</cfif>
			<cfset params.question1 = HTMLEditFormat(trim(params.question1))>
			<cfset params.question2 = HTMLEditFormat(trim(params.question2))>
			<cfset params.question3 = HTMLEditFormat(trim(params.question3))>
			<cfset params.question4 = HTMLEditFormat(trim(params.question4))>
			<cfset params.question5 = HTMLEditFormat(trim(params.question5))>
			<cfset params.question6 = HTMLEditFormat(trim(params.question6))>

			<!--- If any of the second page info is invalid, return to page 2 --->
			<cfif errorList neq "">
				<cfreturn {page=2,errorList=errorList}>
			<cfelse>
				<!--- Submit page 2 to LAD2 DB --->
				<cfset newLeadLAD2 = model("ProfileLead").submitToLAD2Page3(
					contactID		= "#params.contactIDLAD2#",
					weight			= "#params.weight#",
					height			= "#params.height#",
					appointmentDay	= "#params.contactday#",
					appointmentTime	= "#params.contacttime#",
					questionText1	= "#params.question1#",
					questionText2	= "#params.question2#",
					questionText3	= "#params.question3#",
					questionText4	= "#params.question4#",
					questionText5	= "#params.question5#",
					questionText6	= "#params.question6#",
					issmoker		= "#params.smoke#",
					contactoption	= "#params.contactoption#",
					wantsSeminar	= "#params.seminar#",
					wantsFinancing	= "#params.financing#",
					wantsNewsletter	= "#params.newsletter#"
				)>
				<cfset lead = newLeadLAD2>
				<!--- Write the data from page 2 into the database --->
				<!--- <cfset lead = model("ProfileLead").findByKey(params.contactID)>
				<cfset lead.update(
					weight = "#params.weight#",
					height = "#params.height#",
					appointmentDay = "#params.contactday#",
					appointmentTime = "#params.contacttime#",
					questionText1 = "#params.question1#",
					questionText2 = "#params.question2#",
					questionText3 = "#params.question3#",
					questionText4 = "#params.question4#",
					questionText5 = "#params.question5#",
					questionText6 = "#params.question6#",
					issmoker = "#params.smoke#",
					wantsContactByPhone = "#Iif(ListFind(params.contactoption,'phone') gt 0,1,0)#",
					wantsContactByMail = "#Iif(ListFind(params.contactoption,'mail') gt 0,1,0)#",
					wantsContactByEmail = "#Iif(ListFind(params.contactoption,'email') gt 0,1,0)#",
					wantsSeminar = "#Iif(params.seminar eq 1,1,0)#",
					wantsFinancing = "#Iif(params.financing eq 1,1,0)#",
					pageNumber = 3
				)> --->

				<!--- Write specialty question answers to database --->
				<!--- <cfloop query="questionIDs">
					<cfif Evaluate('params.q_'&questionIDs.id) neq "">
						<cfif fieldType eq "checkbox">
							<cfloop list="#Evaluate('params.q_'&questionIDs.id)#" index="answer">
								<cfset newQuestion = model("ProfileLeadSpecialtyQuestionAnswer").create(
									profileLeadId = "#params.contactID#",
									profileSpecialtyQuestionId = "#questionIDs.id#",
									answer="#answer#"
								)>
							</cfloop>
						<cfelse>
							<cfset newQuestion = model("ProfileLeadSpecialtyQuestionAnswer").create(
								profileLeadId = "#params.contactID#",
								profileSpecialtyQuestionId = "#questionIDs.id#",
								answer="#Evaluate('params.q_'&questionIDs.id)#"
							)>
						</cfif>
					</cfif>
				</cfloop> --->

				<cfset state = {}>
				<cfif Server.isInteger(lead.stateId)>
					<cfset state = model("State").findByKey(lead.stateId)>
				<cfelse>
					<cfset state.name = "">
				</cfif>

				<!--- If a mini lead was not generated for this submission, send email --->
				<cfif val(params.miniID) eq 0>
					<!--- <cfset leadProcedures = model("ProfileLeadProcedure").findAllByProfileLeadId(params.contactID)> --->
					<cfinvoke method="leadEmail"
						firstName="#lead.firstname#"
						lastName="#lead.lastname#"
						email="#lead.email#"
						fullLead="true"
						procedureIds="#ValueList(lead.procedure_ids)#"
						lead_city="#lead.city#"
						lead_state="#state#"
					>

					<!--- Check if the doctor is a basic plus who just used up their free leads. If so, notify them. --->
					<cfif model("AccountDoctor").BasicPlusOverLeadThreshold(params.key)>
							<cfset model("AccountDoctorLocation").BasicPlusThresholdEmail(doctorLocation.id,lead.email)>
					</cfif>
				</cfif>

				<!--- Proceed to thank you page --->
				<cfreturn {page=4,errorList=errorList}>

			</cfif>

		</cfif>

		<cfreturn {page=1,errorList=errorList}>

	</cffunction>

	<cffunction name="leadEmail" access="private">
		<cfargument name="firstName"	type="string"	required="true">
		<cfargument name="lastName"		type="string"	required="true">
		<cfargument name="email"		type="string"	required="true">
		<cfargument name="fullLead"		type="boolean"	required="false" default="false">
		<cfargument name="leadTypeId"					required="false" default="0">
		<cfargument name="procedureIds"					required="false" default="">
		<cfargument name="lead_state"					required="false" default="">
		<cfargument name="lead_city"					required="false" default="">
		<cfargument name="miniID"						required="false" default="">
		<cfset var Local = {}>
		<cfset Local.procedureList = "">
		<cfset Local.procedureIdList = "">
		<cfset Local.procedureListWithLinks = "">
		<cfset Local.leadProcedures = "">
		<cfif Arguments.procedureIds neq "">
			<cfset Local.leadProcedures = model("procedure").findAll(where="id IN (#Arguments.procedureIds#)")>
			<cfloop query="Local.leadProcedures">
				<cfset Local.procedureList = ListAppend(Local.procedureList, " " & Local.leadProcedures.name)>
				<cfset Local.procedureIdList = ListAppend(Local.procedureIdList, Local.leadProcedures.id)>
				<cfset Local.procedureListWithLinks = ListAppend(Local.procedureListWithLinks, " " & LinkTo(controller=Local.leadProcedures.siloName, text=Local.leadProcedures.name, onlyPath=false))>
			</cfloop>
		</cfif>

		<cfset Local.doc_emails = model("accountDoctorEmail").findAll(where="accountDoctorId=#params.key# AND categories='doctor'", include="accountEmail")>
		<cfset Local.doc_emails = valueList(Local.doc_emails.email)>
		<cfif Arguments.leadTypeId eq 5>
			<cfset fullCoupon = true>
			<cfset isEmailed = true>
			<cfset coupon = model("coupon").findByKey(key=params.couponId, include="accountDoctorLocationCoupon(accountDoctorLocation)", where="accountdoctorlocations.id = #val(currentLocation.id)#", group="couponId", returnAs="query")>
			<cfloop list="#coupon.columnList#" index="Local.i">
				<cfset variables[Local.i] = coupon[Local.i]>
			</cfloop>
		</cfif>
		<cfset Local.locationStr = "">
		<cfset Local.state_prefix = "">
		<cfif Arguments.lead_city neq "">
			<cfset Local.locationStr &= LCase(Arguments.lead_city)>
			<cfset Local.state_prefix = "-">
		</cfif>
		<cfif isStruct(Arguments.lead_state) and structKeyExists(Arguments.lead_state, "abbreviation")>
			<cfset Local.locationStr &= LCase("#Local.state_prefix##Arguments.lead_state.abbreviation#")>
		</cfif>
		<!--- Define email body --->
		<cfsavecontent variable="emailBody">
			<cfoutput>
			<html>
				<head>
					<title>
						LocateADoc.com: searching, finding, locating, asking, doctors, physicians, lasik, laser vision correction, cosmetic surgery, lasik
					</title>
					<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
					<style>
						body { font: 13px arial; color: ##231F20; }
						.docImage { border:1px solid ##E1E1E1; padding:2px; width:113px; height:129px; }
					</style>
				</head>
				<body bgcolor="##FFFFFF" text="##231F20" link="##582890" style="font: 13px arial;">
					<p style="font-size:10px;">This is an automated message - Please do not reply to this email. See contact instructions below. Thank you.</p>
					<table width="600" cellspacing="0" cellpadding="0" style="border:1px solid ##C4C4C4; border-bottom:0;">
						<tr>
							<td>
								<a href="http://#cgi.server_name#/redirect.cfm?target=#URLEncodedFormat('/')#&infoId=#val(currentLocation.id)#&source=ProfileContactPatientEmailLADLink">
									<img src="http://#CGI.SERVER_NAME#/images/layout/email/lead_patient.gif" width="600" height="68" border="0" style="border:0;">
								</a>
							</td>
						</tr>
					</table>
					<table width="602" cellspacing="0" cellpadding="20" style="border:1px solid ##C4C4C4; border-top:0;">
						<tr>
							<td>
								<cfif trim(arguments.firstName) neq "">
									<p>
										#arguments.firstName#,<br />
									</p>
								</cfif>
								<cfif Arguments.leadTypeId eq 5>
									<p>Below is the special offer coupon you requested from #doctor.firstName# #doctor.lastName#.</p>
								<cfelseif Arguments.leadTypeId gt 0>
									<p>Below is the information you requested from LocateADoc.com.</p>
								<cfelse>
									<p>Thank you for contacting #doctor.firstName# #doctor.lastName# through LocateADoc.com. This message is to confirm they have been notified.</p>
								</cfif>
								<p style="font: 16px arial; color: ##9A546C;"><strong>Contact information:</strong></p>
								<cfif not arguments.fullLead>
									<p>
										<cfif Arguments.leadTypeId eq 5>
											Would you like #doctor.firstName# #doctor.lastName# to contact you?
										<cfelse>
											#doctor.firstName# #doctor.lastName# would like more information about your request:
										</cfif>
										#LinkTo(controller=doctor.siloName,action="contact",params=("l=#val(currentLocation.id)#" & ((val(arguments.miniID) gt 0) ? "&m=#val(arguments.miniID)#" : "")),text="Please click here to respond.",onlyPath=false)#
									</p>
								</cfif>
								<table cellpadding="0" cellspacing="0">
									<tr valign="top">
										<cfif doctor.photoFilename neq "">
											<td width="153" align="center">
												<img src="http://#CGI.SERVER_NAME#/images/profile/doctors/thumb/#doctor.photoFilename#" class="docImage" width="113" height="129" style="border:1px solid ##E1E1E1; padding:2px; width:113px; height:129px;">
											</td>
										</cfif>
										<td>
											<!--- #LinkTo(controller=doctor.siloName,action="welcome",params="l=#val(currentLocation.id)#",text="#doctor.firstName# #doctor.lastName#",onlyPath=false)# --->
											<cfset local.profileLink = "/#doctor.siloName#/?l=#val(currentLocation.id)#">
											#LinkTo(href="http://#cgi.server_name#/redirect.cfm?target=#URLEncodedFormat(local.profileLink)#&infoId=#val(currentLocation.id)#&source=ProfileContactPatientEmailDoctorname",text="#doctor.firstName# #doctor.lastName#",onlyPath=false)#<cfif doctor.firstName NEQ "" OR doctor.lastName NEQ ""><br /></cfif>
											#currentLocation.address#<cfif currentLocation.address NEQ ""><br /></cfif>
											#currentLocation.cityName#, #currentLocation.stateAbbreviation# #currentLocation.postalCode#
											<cfif currentLocation.cityName NEQ "" OR currentLocation.stateAbbreviation NEQ "" OR currentLocation.postalCode NEQ "">
												<cfset local.profileMapLink = "/#doctor.siloName#/?l=#val(currentLocation.id)#&showMap=true">
	 											#LinkTo(href="http://#cgi.server_name#/redirect.cfm?target=#URLEncodedFormat(local.profileMapLink)#&infoId=#val(currentLocation.id)#&source=ProfileContactPatientEmailMap",text="Map",onlyPath=false)#<br />
												<!--- #LinkTo(controller=doctor.siloName,params="l=#val(currentLocation.id)#&showMap=true",text="Map",onlyPath=false)#<br /> --->
											</cfif>
											<cfif currentLocationDetails.phonePlus neq "">
												Phone: #formatPhone(currentLocationDetails.phonePlus)#<br />
											<cfelseif isYext and currentLocationDetails.phoneYext neq "">
												Phone: #formatPhone(currentLocationDetails.phoneYext)#<br />
											<cfelseif currentLocation.phone NEQ "">
												Phone: #formatPhone(currentLocation.phone)#<br />
											</cfif>
											<cfif currentLocation.phoneTollFree NEQ "">
												Toll Free: #formatPhone(currentLocation.phoneTollFree)#<br />
											</cfif>
											<!--- <cfif ListLen(Local.doc_emails)>
												Email Address<cfif ListLen(Local.doc_emails) gt 1>es</cfif>: #ListChangeDelims(Local.doc_emails, ", ")#<br />
											</cfif> --->
											<cfset websiteLink = FindNoCase("http://",accountInfo.url) ? "" : "http://" & accountInfo.url>
											<cfif accountInfo.url neq "" and isValid("URL",websiteLink)>
												Website: #LinkTo(href="http://#cgi.server_name#/redirect.cfm?target=#URLEncodedFormat(websiteLink)#&infoId=#val(currentLocation.id)#&source=ProfileContactPatientEmailWebsiteLink",text=websiteLink,onlyPath=false)#<br />
											</cfif>
											<cfif listLen(procedureIds) gt 0>
												Selected Procedure<cfif ListLen(Local.procedureList gt 1)>s</cfif>: #Local.procedureListWithLinks#
											</cfif>
										</td>
									</tr>
								</table>
								<cfif Arguments.leadTypeId eq 5>
									<br />
									<cfinclude template="/views/profile/_coupon.cfm">
								</cfif>
								<br />
								<hr>
								<cfif isQuery(Local.leadProcedures) and Local.leadProcedures.recordCount>
									<p style="font: 16px arial; color: ##9A546C;"><strong>Would you like more doctors to contact you?</strong></p>
									<p>
										<cfloop query="Local.leadProcedures">
											Find more
											<cfset local.procedureDoctorsLink = "/doctors/#Local.leadProcedures.siloName#/#trim(Local.locationStr)#">
											<!--- #LinkTo(href="http://#cgi.server_name#/redirect.cfm?target=#URLEncodedFormat(websiteLink)#&infoId=#val(currentLocation.id)#&source=ProfileContactPatientEmailWebsiteLink",text=websiteLink,onlyPath=false)# --->
											<!--- #LinkTo(controller="doctors", action=Local.leadProcedures.siloName, key=trim(Local.locationStr), text="#Local.leadProcedures.name# doctors", onlyPath=false)# now.<br /> --->
											#LinkTo(href="http://#cgi.server_name#/redirect.cfm?target=#URLEncodedFormat(Local.procedureDoctorsLink)#&infoId=#val(currentLocation.id)#&source=ProfileContactPatientEmailProcedureDoctorLocationsLink", text="#Local.leadProcedures.name# doctors", onlyPath=false)# now.<br />
										</cfloop>
									</p>
								</cfif>


								<cfif financingoptions.recordCount>
									<p style="font: 16px arial; color: ##9A546C;"><strong>Would you like to finance your procedure?</strong></p>
									<cfset local.profileFinancingLink = "/#doctor.siloName#/financing?l=#val(currentLocation.id)#">
									<p>#LinkTo(href="http://#cgi.server_name#/redirect.cfm?target=#URLEncodedFormat(local.profileFinancingLink)#&infoId=#val(currentLocation.id)#&source=ProfileContactPatientEmailProfileFinancingLink",text="Click here to see if you qualify.",onlyPath=false)#</p>
								<cfelseif HasFinancingSpeciaties>
									<p style="font: 16px arial; color: ##9A546C;"><strong>Would you like to finance your procedure?</strong></p>
									<cfset local.financingLink = "/financing">
									<p>#LinkTo(href="http://#cgi.server_name#/redirect.cfm?target=#URLEncodedFormat(local.financingLink)#&infoId=#val(currentLocation.id)#&source=ProfileContactPatientEmailMainFinancingLink",text="Click here to see if you qualify.",onlyPath=false)#</p>
								</cfif>
								<p style="font: 16px arial; color: ##9A546C;"><strong>What Happens Next?</strong></p>
								<p>
									You should receive a reply from the practice shortly. However, please feel free to call the practice at your convenience if you don't hear back right away.
								</p>
								<p>
									Remember to remind them that you originally contacted them through LocateADoc.com.
								</p>
								<p>
									A follow up email will be sent to you in five (5) business days to help make your contact successful. Please let us know then how your experience with the practice has progressed.
								</p>
								<p>Have a question<cfif Local.procedureList neq ""> about#Local.procedureList#</cfif>? Feel free to ask us on:</p>

								<a href="http://#cgi.server_name#/redirect.cfm?target=#URLEncodedFormat('http://www.facebook.com/locateadoc')#&infoId=#val(currentLocation.id)#&source=ProfileContactPatientEmailFacebookLink"><img src="http://#CGI.SERVER_NAME#/images/coupon/facebook-icon.png" align="left" border="0"></a>&nbsp;
								<a href="http://#cgi.server_name#/redirect.cfm?target=#URLEncodedFormat('http://twitter.com/locateadoc')#&infoId=#val(currentLocation.id)#&source=ProfileContactPatientEmailTwitterLink"><img src="http://#CGI.SERVER_NAME#/images/coupon/twitter-icon.png" border="0"></a>
								<p>
									Sincerely,<br>
									The LocateADoc.com Staff
								</p>
								<p>
									P.S. Have some feedback for us? <a href="http://#cgi.server_name#/redirect.cfm?target=#URLEncodedFormat('/home/feedback')#&infoId=#val(currentLocation.id)#&source=ProfileContactPatientEmailFeedbackLink">Tell us what's on your mind.</a>
								</p>
							</td>
						</tr>
					</table>

						<!--- <div style="padding:8px;">
							<p>
								If you do not wish to receive follow up email(s) concerning this doctor, please click on the following link:
								<a href="http://#cgi.server_name#/Newsletters/unsubscribe.cfm?UnSub_Type=1&email=#variables.patient_email#&id=#variables.folio_id#">Please do not follow up with me on this doctor</a>.
							</p>
						</div> --->
					<p>
						&nbsp;
					</p>
				</body>
			</html>
			</cfoutput>
		</cfsavecontent>

		<cfif doctor.firstName NEQ "" OR doctor.lastName NEQ "">
			<cfset emailSubject = "LocateADoc.com - Thank you for contacting #doctor.firstName# #doctor.lastName#">
		<cfelse>
			<cfset emailSubject = "LocateADoc.com - Thank you for contacting #practice.name#">
		</cfif>

		<cfmail from="contact@locateadoc.com"
				to="#arguments.email#"
				subject="#emailSubject#"
				type="html">
			#emailBody#
		</cfmail>
	</cffunction>

	<cffunction name="practiceTour" returntype="struct" access="private">
		<cfset tour = {}>
		<cfset tour.tourStops = model("OfficeTourAccountDoctorLocation").findAll(
			select="officetourpracticelocations.name,officetourpractices.categoryName,officetourstops.title,"
			& "officetourstops.description,officetourstops.locationImage1,officetourstops.locationImage2,"
			& "officetourstops.websiteImage1,officetourstops.websiteImage2,officetourstops.sequence,"
			& "officetourstops.showLAD,officetourstops.showWebsite,officetourstops.isShown,"
			& "officetourstops.isShownStop",
			include="officeTourPracticeLocation(officeTourPractice,officeTourStops)",
			where="accountDoctorLocationId = #doctorLocation.id# AND showLAD = 1 AND isShown = 1 AND isShownStop = 1",
			order="sequence asc"
		)>
		<cfset tour.imgPath = "http://admin.patientreferraloffice.com/admin/images/virtualtour/">

		<cfreturn tour>
	</cffunction>

	<cffunction name="recordHit" access="private">
		<cfparam name="params.state"				default="">
		<cfparam name="params.city" 				default="">
		<cfparam name="params.procedure"			default="">
		<cfparam name="params.specialty"			default="">

		<cfif not Client.IsSpider OR server.thisServer EQ "dev">

			<cfset keylist = REReplace(LCase(CGI.PATH_INFO),'/?(#LCase(params.controller)#|#LCase(params.action)#)/?','','all')>

			<cfset newHit = model("HitsProfile").RecordHit(
						action		= params.action,
						keylist		= keylist,
						specialty	= params.specialty,
						procedure	= params.procedure,
						state		= params.state,
						city		= params.city,
						accountDoctorId	= doctor.id)>
		</cfif>
	</cffunction>

</cfcomponent>