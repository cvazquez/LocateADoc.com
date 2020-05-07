<cfcomponent extends="Controller" output="false">

	<cfset breadcrumbs = []>
	<cfset arrayAppend(breadcrumbs,linkTo(href="/",text="Home"))>

	<cfset baseURL = "http://#Globals.domain#">

	<cfset encrypt_key = "VOiOeTCJsX9NBzd9X+9YEA==">

	<cfset isMobile = false>
	<cfset mobileSuffix = "">

	<cfif server.thisServer EQ "dev" OR listFirst(cgi.server_name, ".") EQ "alpha1">
		<cfset variables.charge1APIKey = "2F822Rw39fx762MaV7Yy86jXGTC7sCDy">
		<cfset variables.paymentGatewayURL = "http://#cgi.server_name#/doctor-marketing/payment-gateway">
		<cfset variables.billingAddressAmount = 1>
	<cfelse>
		<cfset variables.charge1ApiKey = "mccyZ56K3k636ve9thUv5373Zqr9Qfx4">
		<cfset variables.paymentGatewayURL = "https://#cgi.server_name#/doctor-marketing/payment-gateway">
		<cfset variables.billingAddressAmount = 5.95>
	</cfif>

	<cfset introListingAmount = variables.billingAddressAmount>

	<cfset variables.oScrypt = createObject("component", "com#Application.SharedModulesSuffix#.util.validation.scrypt")>




 	<cffunction name="init">
		<cfset filters(through="recordHit",type="after",except="")>
		<cfset usesLayout("checkPrint")>
		<cfset provides("html,json")>
	</cffunction>

	<cffunction name="checkPrint">
		<cfif Find("/print-view",CGI.PATH_INFO)>
			<cfreturn "/print">
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>

	<cffunction name="index">
		<cfset title = "Marketing Resources for Doctors, Patient Referrals">
		<cfset metaDescriptionContent = "Physician marketing information, patient lead generation tips, medical advertising options and doctor testimonials on LocateADoc.com.">
		<cfset breadcrumbs = []>

		<cfset headerContent = model("SpecialContent").findAll(
			select="title, header, content",
			where="name = 'Doctors Only Header'"
		)>

		<cfset latestArticles = model("ResourceArticle").searchArticles(category=2,limit=2)>

		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">

			<cfset specialties = model("Specialty").findAll(	select	= "id, name",
																where	= "hasDoctorsOnly = 1",
																order	="name")>

			<cfset renderPage(layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="testimonials">
		<cfset title = "What Others Doctors Say About Marketing on LocateADoc.com for Patient Referrals">
		<cfset metaDescriptionContent = "Reviews from LocateADoc.com doctors who receive patient referrals by marketing on LocateADoc.com">

		<cfset arrayAppend(breadcrumbs,linkTo(action="index",text="Doctors Only"))>
		<cfset arrayAppend(breadcrumbs,"Testimonials")>

		<cfset testimonialInfo = model("SpecialContent").findAll(
						 where = "name LIKE 'Doctors Only Testimonial%'",
						 order = "name asc")>

		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">

			<cfset renderPage(layout="/layout_mobile")>
		</cfif>
	</cffunction>

<!---
	<cffunction name="search">
		<cfset title = "Doctors Only">


	</cffunction>

	<cffunction name="listing">
		<cfset title = "Doctors Only">


	</cffunction>
 --->

	<cffunction name="advertising">
		<cfset title = "LocateADoc.com Medical Advertising and Physician Marketing Options">
		<cfset metaDescriptionContent = "Advertising information for doctors and medical practices looking for patient referrals through LocateADoc.com">
		<cfset arrayAppend(breadcrumbs,linkTo(action="index",text="Doctors Only"))>
		<cfset arrayAppend(breadcrumbs,"Advertising")>

		<cfset headerContent = model("SpecialContent").findAll(
			select="title, header, content",
			where="name = 'Advertising Options Header'"
		)>

		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">

			<cfset renderPage(layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="articles">
		<cfparam name="params.specialty" default="0">
		<cfparam name="params.procedure" default="0">
		<cfparam name="params.tag" default="">
		<cfparam name="params.page" default="1">

		<cfset title = "Articles and Advice on Physician Marketing Strategies and Practice Management Techniques">
		<cfset metaDescriptionContent = "Read information on how to run your medical practice, tips on marketing to patients, and operating effective marketing plans on LocateADoc.com.">
		<cfset arrayAppend(breadcrumbs,linkTo(action="index",text="Doctors Only"))>
		<cfset arrayAppend(breadcrumbs,"<span>Articles</span>")>

		<!---Search the URL for filter params and reformat them for the search--->
		<cfloop collection="#params#" item="i">
			<cfif left(i,6) is "filter">
				<cfset Local.filtername = listFirst(params[i],"-")>
				<cfset Local.filtervalue = Replace(params[i],"#Local.filtername#-","")>
				<cfset params[Local.filtername] = Local.filtervalue>
			</cfif>
		</cfloop>

		<!--- filter the params --->
		<cfset params.specialty = val(params.specialty)>
		<cfset params.procedure = val(params.procedure)>
		<cfset params.tag = REReplace(params.tag,"[^a-zA-Z0-9 ]","","all")>

		<!--- Init pagination variables --->
		<cfset search = {}>
		<cfset search.page = Max(val(params.page),1)>
		<cfset offset = (search.page-1)*10>
		<cfset limit = 10>

		<!--- Get the list of articles --->
		<cfset articleInfo = model("ResourceArticle").searchArticles(
			category = 2,
			specialty = params.specialty,
			procedure = params.procedure,
			tag = params.tag,
			offset = offset,
			limit = limit
		)>

		<cfif params.tag NEQ "" AND articleInfo.recordCount EQ 0>
			<cfheader statuscode="410" statustext="gone">
			<cfset doNotIndex = true>
		<cfelseif params.tag NEQ "">
			<cfset doNotIndex = true>

			<cfset title = "Articles and Advice on Physician Marking Search Results for: #params.tag#">
		</cfif>

		<!--- Get the number of records and pages from the full result set --->
		<cfquery datasource="#get('dataSourceName')#" name="count">
			Select Found_Rows() AS foundrows
		</cfquery>
		<cfset search.totalrecords = count.foundrows>
		<cfset search.pages = ceiling(search.totalrecords/limit)>

		<cfset relNext = getNextPage(search.page,search.pages)>
		<cfset relPrev = getPrevPage(search.page)>


		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">

			<cfset specialties = model("Specialty").findAll(	select	= "id, name",
																where	= "hasDoctorsOnly = 1",
																order	="name")>

			<cfset renderPage(action="article", layout="/layout_mobile")>
		<cfelse>
			<cfset renderPage(action="article")>
		</cfif>

	</cffunction>

	<cffunction name="article">
		<cfparam name="params.rewrite" default="0">
		<cfparam name="params.articlesilo" default="">
		<cfparam name="params.key" default="0">
		<cfparam name="params.preview" default="0">
		<cfset var Local = {}>

		<cfif params.rewrite>
			<!--- This lock is exclusive with the one in pDock to make sure we're not reading partially updated data --->
			<cflock name="articleSiloNameUpdate" type="exclusive" timeout="10">
				<!--- Get article id for current silo name --->
				<cfset Local.articleSilo = model("resourceArticleSiloName")
										.findAll(
											select="resourceArticleId, isActive",
											where="siloName = '#params.articlesilo#'"
											)>
				<cfif Local.articleSilo.recordCount>
					<cfif Local.articleSilo.isActive neq 1>
						<!--- Get active silo name for article id --->
						<cfset Local.articleSilo = model("resourceArticleSiloName")
											.findAll(
												select="siloName",
												where="resourceArticleId = '#Local.articleSilo.resourceArticleId#' AND isActive = 1"
												)>
						<cfif Local.articleSilo.recordCount>
							<!--- Redirect to current silo name --->
							<cflocation url="/doctor-marketing/#Local.articleSilo.siloName#" addtoken="no" statuscode="301">
						<cfelse>
							<!--- If there's no active silo name for guide id (this should never happen) --->
							<cflocation url="/doctor-marketing/articles" addtoken="no" statuscode="301">
						</cfif>
					</cfif>
				<cfelse>
					<!--- No article for silo name --->
					<cflocation url="/doctor-marketing/articles" addtoken="no" statuscode="301">
				</cfif>
			</cflock>
			<cfif not Server.isInteger(Local.articleSilo.resourceArticleId)>
				<cflocation url="/doctor-marketing/articles" addtoken="no" statuscode="301">
			</cfif>
			<cfset params.key = Local.articleSilo.resourceArticleId>
		</cfif>

		<cfset articleID = val(params.key)>
		<cfif articleID eq 0>
			<cfset dumpStruct = {local=local,params=params}>
			<cfset fnCthulhuException(	scriptName="DoctorMarketing.cfc",
										message="Invalid article id (id: 0).",
										detail="You can't make a half sandwich. If it's not half of a whole sandwich, it's just a small sandwich.",
										dumpStruct=dumpStruct,
										redirectURL="/doctor-marketing/articles"
										)>
			<cfset redirectTo(action="articles")>
		</cfif>

		<cfset articleInfo = model("ResourceArticle").searchArticles(article=articleID,preview=(params.preview ? 1 : 0),category=2,limit=1)>
		<cfif articleInfo.recordcount eq 0>
			<cfset dumpStruct = {articleInfo=articleInfo,local=local,params=params}>
			<cfset fnCthulhuException(	scriptName="DoctorMarketing.cfc",
										message="Can't find article (id: #articleID#).",
										detail="If ifs and buts were candies and nuts, we would all have a merry Christmas.",
										dumpStruct=dumpStruct,
										redirectURL="/doctor-marketing/articles"
										)>
			<cfset redirectTo(action="articles")>
		</cfif>
		<cfset articleSiloName = model("resourceArticleSiloName").findAll(
			select="siloName",
			where="resourceArticleId = #articleID# AND isActive = 1"
		).siloName>
		<cfset specialtyID = ListFirst(ListAppend(articleInfo.specialtyIDs,0))>
		<cfset procedureID = ListFirst(ListAppend(articleInfo.procedureIDs,0))>

		<cfset metaDescriptionContent = articleInfo.metaDescription>
		<cfset metaKeywordsContent = articleInfo.metaKeywords>

		<cfset title = "#articleInfo.title#">
		<cfset metaDescriptionContent = "#articleInfo.metaDescription#">
		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,linkTo(action="index",text="Doctors Only"))>
		<cfif Find("resources/articles",CGI.HTTP_REFERER)>
			<cfset arrayAppend(breadcrumbs,LinkTo(href=CGI.HTTP_REFERER,text="Articles"))>
		<cfelse>
			<cfset arrayAppend(breadcrumbs,LinkTo(action="articles",text="Articles"))>
		</cfif>
		<cfset arrayAppend(breadcrumbs,"<span>#articleInfo.title#</span>")>

		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">

			<cfset specialties = model("Specialty").findAll(	select	= "id, name",
																where	= "hasDoctorsOnly = 1",
																order	="name")>

			<cfset renderPage(layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="addListing">
		<cfparam name="params.page" default="1">
		<cfparam name="params.doctorfirstname" default="">
		<cfparam name="params.doctorlastname" default="">
		<cfparam name="params.doctortitle" default="">
		<cfparam name="params.doctoremail" default="">
		<cfparam name="params.website" default="">
		<cfparam name="params.contactfirstname" default="">
		<cfparam name="params.contactlastname" default="">
		<cfparam name="params.contactemail" default="">
		<cfparam name="params.practicename" default="">
		<cfparam name="params.address" default="">
		<cfparam name="params.city" default="">
		<cfparam name="params.state" default="">
		<cfparam name="params.zip" default="">
		<cfparam name="params.country" default="">
		<cfparam name="client.introductoryListing" default="FALSE" type="boolean">
		<cfparam name="params.introductoryAccept" default="FALSE" type="boolean">
		<!--- <cfparam name="params.license" default=""> --->
		<cfparam name="params.physician" default="0">
		<cfparam name="params.doctorphone" default="">
		<cfparam name="params.specialty" default="">
		<cfparam name="params.specialtyID" default="">
		<cfparam name="params.specialty2ID" default="">
		<cfparam name="params.specialty3ID" default="">
		<cfparam name="params.specialty4ID" default="">
		<cfparam name="params.procedureID" default="">
		<cfparam name="params.procedure2ID" default="">
		<cfparam name="params.procedure3ID" default="">
		<cfparam name="params.procedure4ID" default="">
		<cfparam name="params.passwordA" default="">
		<cfparam name="params.passwordB" default="">
		<cfparam name="params.password" default="">
		<cfparam name="params.comments" default="">
		<cfparam name="params.websitecontrol" default="0">
		<cfparam name="params.seomarketing" default="0">
		<cfparam name="params.calltracking" default="0">
		<cfparam name="params.merchantservices" default="0">
		<cfparam name="params.videoservices" default="0">
		<cfparam name="params.patienteducation" default="0">
		<cfparam name="params.keywordmarketing" default="0">
		<cfparam name="params.campaignID" default="70160000000MC9x">

		<cfparam default="" name="params.doctorsOnlyId">
		<cfparam default="" name="params.billingAddressCompany">
		<cfparam default="" name="params.billingAddressFirstName">
		<cfparam default="" name="params.billingAddressLastName">
		<cfparam default="" name="params.billingAddressAddress1">
		<cfparam default="" name="params.billingAddressAddress2">
		<cfparam default="" name="params.billingAddressCity">
		<cfparam default="" name="params.billingAddressStateId">
		<cfparam default="" name="params.billingAddressZip">
		<cfparam default="" name="params.billingAddressCountryId">
		<cfparam default="" name="params.billingAddressPhone">
		<cfparam default="" name="params.billingAddressFax">
		<cfparam default="" name="params.billingAddressEmail">
		<cfparam default="" name="params.billingAddressAmount">
		<cfparam default="" name="params.termsAndConditions">


		<cfset specialtyList = "">
		<cfset procedureList = "">
		<cfset isPremier = FALSE>
		<cfset introListingAmount = variables.billingAddressAmount>
		<cfset arrayAppend(breadcrumbs,linkTo(action="index",text="Doctors Only"))>
		<cfset arrayAppend(breadcrumbs,"Add Listing")>

		<cfsavecontent variable="IE8PasswordFix">
			<!--[if lte IE 8]>
			<style>
			  #passwordA, #passwordB  {
			    font-family: Arial;
			  }
			</style>
			<![endif]-->
		</cfsavecontent>

		<cfhtmlhead text="#IE8PasswordFix#">

		<!--- Input filtering --->
		<cfset params.doctorfirstname = HTMLEditFormat(trim(params.doctorfirstname))>
		<cfset params.doctorlastname = HTMLEditFormat(trim(params.doctorlastname))>
		<cfset params.doctortitle = HTMLEditFormat(trim(params.doctortitle))>
		<cfset params.doctoremail = trim(params.doctoremail)>
		<cfset params.website = HTMLEditFormat(trim(params.website))>
		<cfset params.contactfirstname = HTMLEditFormat(trim(params.contactfirstname))>
		<cfset params.contactlastname = HTMLEditFormat(trim(params.contactlastname))>
		<cfset params.contactemail = trim(params.contactemail)>
		<cfset params.practicename = HTMLEditFormat(trim(params.practicename))>
		<cfset params.address = HTMLEditFormat(trim(params.address))>
		<cfset params.city = HTMLEditFormat(trim(params.city))>
		<cfset params.state = Val(trim(params.state))>
		<cfset params.zip = HTMLEditFormat(trim(params.zip))>
		<cfset params.country = Val(trim(params.country))>
		<cfset params.doctorphone = HTMLEditFormat(trim(params.doctorphone))>


		<!--- Input validation --->
		<cfset errorList = "">
		<cfif params.page gt 1>
			<cfset doNotIndex = true>
			<cfif params.doctorfirstname eq "" or len(params.doctorfirstname) gt 25>
				<cfset errorList = ListAppend(errorList,"doctorfirstname")>
			</cfif>
			<cfif params.doctorlastname eq "" or len(params.doctorlastname) gt 25>
				<cfset errorList = ListAppend(errorList,"doctorlastname")>
			</cfif>
			<cfif params.practicename eq "" or len(params.practicename) gt 50>
				<cfset errorList = ListAppend(errorList,"practicename")>
			</cfif>
			<cfset var phoneFormatter = CreateObject("component", 'com.util.formatting.Phone')>
			<cfset var phoneNumber = SpanExcluding(params.doctorphone, "x")>
			<cfif Len(phoneFormatter.StripPhoneNumber(phoneNumber)) LT 10 or len(params.doctorphone) gt 20>
				<cfset errorList = ListAppend(errorList,"doctorphone")>
			</cfif>
			<cfif not isEmail(params.doctoremail) or len(params.doctoremail) gt 50>
				<cfset errorList = ListAppend(errorList,"doctoremail")>
			<cfelseif params.page EQ 2 and params.contactemail EQ "">
				<cfset params.contactemail = params.doctoremail>
			</cfif>
			<cfif params.state eq 0>
				<cfset errorList = ListAppend(errorList,"state")>
			</cfif>
			<cfif params.zip eq "" or len(params.zip) gt 10>
				<cfset errorList = ListAppend(errorList,"zip")>
			</cfif>
			<cfif params.country eq 0>
				<cfset errorList = ListAppend(errorList,"country")>
			</cfif>
			<!--- <cfif params.license eq "">
				<cfset errorList = ListAppend(errorList,"license")>
			</cfif> --->
			<cfif params.physician eq 0>
				<cfset errorList = ListAppend(errorList,"physician")>
			</cfif>
			<cfif val(params.specialtyID) eq 0>
				<cfif params.specialty NEQ "">
					<cfquery datasource="myLocateadocLB3" name="qSpecialty">
						SELECT id
						FROM specialties
						WHERE name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.specialty#">
					</cfquery>

					<cfif qSpecialty.recordCount GT 0>
						<cfset params.specialtyID = qSpecialty.id>
					<cfelse>
						<cfset errorList = ListAppend(errorList,"specialtyID")>
					</cfif>

				<cfelse>
					<cfset errorList = ListAppend(errorList,"specialtyID")>
				</cfif>

			</cfif>
			<cfif errorList neq "">
				<cfset params.page = (params.page eq 2) ? 1 : 2>
			</cfif>
		</cfif>
		<cfif params.page gt 2>
			<cfif len(params.doctortitle) gt 25>
				<cfset errorList = ListAppend(errorList,"doctortitle")>
			</cfif>
			<cfif len(params.website) gt 75>
				<cfset errorList = ListAppend(errorList,"website")>
			</cfif>
			<cfif params.contactfirstname eq "" or len(params.contactfirstname) gt 25>
				<cfset errorList = ListAppend(errorList,"contactfirstname")>
			</cfif>
			<cfif params.contactlastname eq "" or len(params.contactlastname) gt 25>
				<cfset errorList = ListAppend(errorList,"contactlastname")>
			</cfif>
			<cfif not isEmail(params.contactemail) or len(params.contactemail) gt 50>
				<cfset errorList = ListAppend(errorList,"contactemail")>
			</cfif>
			<cfif params.address eq "" or len(params.city) gt 50>
				<cfset errorList = ListAppend(errorList,"address")>
			</cfif>
			<cfif params.city eq "" or len(params.city) gt 30>
				<cfset errorList = ListAppend(errorList,"city")>
			</cfif>
			<cfif val(params.procedureID) eq 0>
				<cfset errorList = ListAppend(errorList,"procedureID")>
			</cfif>
			<cfif params.page eq 3>
				<cfif NOT passwordCheck(params.passwordA) or params.passwordA NEQ params.passwordB>
					<cfset errorList = ListAppend(errorList,"password")>
				<cfelse>
					<!--- <cfset params.password = URLEncodedFormat(Encrypt(params.passwordA, encrypt_key, "BLOWFISH"))> --->
					<cfset params.password = params.passwordA>
				</cfif>
			</cfif>
			<cfif errorList neq "">
				<cfset params.page = 2>
			</cfif>


			<!--- ID list assembly --->
			<cfif val(params.specialtyID) gt 0><cfset specialtyList = ListAppend(specialtyList,val(params.specialtyID))></cfif>
			<cfif val(params.specialty2ID) gt 0><cfset specialtyList = ListAppend(specialtyList,val(params.specialty2ID))></cfif>
			<cfif val(params.specialty3ID) gt 0><cfset specialtyList = ListAppend(specialtyList,val(params.specialty3ID))></cfif>
			<cfif val(params.specialty4ID) gt 0><cfset specialtyList = ListAppend(specialtyList,val(params.specialty4ID))></cfif>

			<cfif val(params.procedureID) gt 0><cfset procedureList = ListAppend(procedureList,val(params.procedureID))></cfif>
			<cfif val(params.procedure2ID) gt 0><cfset procedureList = ListAppend(procedureList,val(params.procedure2ID))></cfif>
			<cfif val(params.procedure3ID) gt 0><cfset procedureList = ListAppend(procedureList,val(params.procedure3ID))></cfif>
			<cfif val(params.procedure4ID) gt 0><cfset procedureList = ListAppend(procedureList,val(params.procedure4ID))></cfif>

			<!--- Determine if a premier specialty was selected --->
			<cfset isPremier = false>
			<cfif ListLen(specialtyList) gt 0>
				<cfset isPremier = model("Specialty").findAll(where="isPremier = 1 AND id IN (#specialtyList#)").recordcount gt 0>
			</cfif>

			<cfif params.page eq 4 AND NOT isPremier>
				<cfif params.billingAddressCompany eq "">
					<cfset errorList = ListAppend(errorList,"billingAddressCompany")>
				</cfif>
				<cfif params.billingAddressfirstName eq "">
					<cfset errorList = ListAppend(errorList,"billingAddressfirstName")>
				</cfif>
				<cfif params.billingAddressLastName eq "">
					<cfset errorList = ListAppend(errorList,"billingAddressLastName")>
				</cfif>
				<cfif params.billingAddressAddress1 eq "">
					<cfset errorList = ListAppend(errorList,"billingAddressAddress1")>
				</cfif>
				<cfif params.billingAddressCity eq "">
					<cfset errorList = ListAppend(errorList,"billingAddressCity")>
				</cfif>
				<cfif params.billingAddressStateId eq "">
					<cfset errorList = ListAppend(errorList,"billingAddressStateId")>
				</cfif>
				<cfif params.billingAddressZip eq "">
					<cfset errorList = ListAppend(errorList,"billingAddressZip")>
				</cfif>
				<cfif params.billingAddressCountryId eq "">
					<cfset errorList = ListAppend(errorList,"billingAddressCountryId")>
				</cfif>
				<cfif params.billingAddressPhone eq "">
					<cfset errorList = ListAppend(errorList,"billingAddressPhone")>
				</cfif>
				<cfif params.billingAddressEmail eq "">
					<cfset errorList = ListAppend(errorList,"billingAddressEmail")>
				</cfif>
				<cfif params.termsAndConditions NEQ 1>
					<cfset errorList = ListAppend(errorList,"termsAndConditions")>
				</cfif>
				<cfif errorList neq "">
					<cfset params.page = 3>
				</cfif>
			</cfif>

		</cfif>


		<!--- Specialty/Procedure translation --->
		<cfset SP_titles = {}>
		<cfset SP_titles.specialty = (val(params.specialtyID) gt 0) ? formatForSelectBox(model("Specialty").findAll(select="name",where="id=#val(params.specialtyID)#").name) : "">
		<cfset SP_titles.specialty2 = (val(params.specialty2ID) gt 0) ? formatForSelectBox(model("Specialty").findAll(select="name",where="id=#val(params.specialty2ID)#").name) : "">
		<cfset SP_titles.specialty3 = (val(params.specialty3ID) gt 0) ? formatForSelectBox(model("Specialty").findAll(select="name",where="id=#val(params.specialty3ID)#").name) : "">
		<cfset SP_titles.specialty4 = (val(params.specialty4ID) gt 0) ? formatForSelectBox(model("Specialty").findAll(select="name",where="id=#val(params.specialty4ID)#").name) : "">
		<cfset SP_titles.procedure = (val(params.procedureID) gt 0) ? formatForSelectBox(model("Procedure").findAll(select="name",where="id=#val(params.procedureID)#").name) : "">
		<cfset SP_titles.procedure2 = (val(params.procedure2ID) gt 0) ? formatForSelectBox(model("Procedure").findAll(select="name",where="id=#val(params.procedure2ID)#").name) : "">
		<cfset SP_titles.procedure3 = (val(params.procedure3ID) gt 0) ? formatForSelectBox(model("Procedure").findAll(select="name",where="id=#val(params.procedure3ID)#").name) : "">
		<cfset SP_titles.procedure4 = (val(params.procedure4ID) gt 0) ? formatForSelectBox(model("Procedure").findAll(select="name",where="id=#val(params.procedure4ID)#").name) : "">


		<cfif params.page eq 1>
			<cfset qSettings = model("Settings").findOne(	WHERE	=	'`key` = "BasicPlusLeadThreshold"',
															SELECT	=	'value')>
		<cfelseif params.page gt 1>
			<cfquery name="submissionCheck" datasource="myLocateadoc">
				SELECT id, is_sent
				FROM doctors_only_doctors
				WHERE dr_first_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctorfirstname#">
				  AND dr_last_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctorlastname#">
				  AND practice_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.practicename#">
				  AND specialty_id_1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#val(params.specialtyID)#">
				  AND practice_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctorphone#">
				  AND dr_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctoremail#">
				  AND practice_country_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#params.country#">
				  AND practice_postal_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.zip#">
				  AND practice_state_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#params.state#">
				ORDER BY id desc
			</cfquery>
			<cfset docOnlyID = (submissionCheck.recordcount) ? val(submissionCheck.id) : 0>
			<cfset docSubmitted = (submissionCheck.recordcount) ? val(submissionCheck.is_sent) : 0>

			<cfif docOnlyID gt 0>

				<!--- Determine if a premier specialty was selected --->
				<cfset isPremier = false>
				<cfif isnumeric(params.specialtyID) AND val(params.specialtyID) GT 0>
					<cfset isPremier = model("Specialty").findAll(where="isPremier = 1 AND id = #params.specialtyID#").recordcount gt 0>

					<cfif NOT isPremier>
						<cfset client.introductoryListing = TRUE>
					</cfif>
				</cfif>

				<!--- Update existing record if active --->
				<cfquery name="qUpdateDr" datasource="myLocateadoc">
					UPDATE doctors_only_doctors SET
					dr_first_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctorfirstname#">,
					dr_last_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctorlastname#">,
					dr_designation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctortitle#">,
					dr_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctoremail#">,
					dr_website = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.website#">,
					contact_first_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.contactfirstname#">,
					contact_last_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.contactlastname#">,
					contact_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.contactemail#">,
					practice_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.practicename#">,
					practice_phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctorphone#">,
					practice_address_1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.address#">,
					practice_country_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#params.country#">,
					practice_postal_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.zip#">,
					practice_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.city#">,
					practice_state_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#params.state#">,
					<!--- pro_password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.password#">, --->
					<cfif params.password NEQ "">
						<cfset passwordHash = oSCrypt.SCrypt(params.password)>
						passwordHash = <cfqueryparam cfsqltype="cf_sql_char" value="#passwordHash#">,
					</cfif>
					specialty_id_1 =
					<cfif val(params.specialtyID) gt 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#val(params.specialtyID)#">,
					<cfelse>
						NULL,
					</cfif>
					specialty_id_2 =
					<cfif val(params.specialty2ID) gt 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#val(params.specialty2ID)#">,
					<cfelse>
						NULL,
					</cfif>
					specialty_id_3 =
					<cfif val(params.specialty3ID) gt 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#val(params.specialty3ID)#">,
					<cfelse>
						NULL,
					</cfif>
					specialty_id_4 =
					<cfif val(params.specialty4ID) gt 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#val(params.specialty4ID)#">,
					<cfelse>
						NULL,
					</cfif>
					procedure_ids =
					<cfif procedureList neq "">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#procedureList#">,
					<cfelse>
						NULL,
					</cfif>
					keywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Client.KEYWORDS#">,
			        referralfull = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Client.ReferralFull#">,
			        sf_campaign_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.campaignID#">,
			        forms_completed =
			        	<cfif params.page EQ 2 AND NOT isPremier AND params.introductoryAccept IS FALSE>
			        		1
			        	<cfelse>
			        		<cfqueryparam cfsqltype="cf_sql_numeric" value="#val(params.page)#">
			        	</cfif>,
			        updated_dt = now()
					WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#docOnlyID#">
				</cfquery>

			<cfelseif params.page eq 2>

				<!--- Determine if a premier specialty was selected --->
				<cfset isPremier = false>
				<cfif isnumeric(params.specialtyID) AND val(params.specialtyID) GT 0>
					<cfset isPremier = model("Specialty").findAll(where="isPremier = 1 AND id = #params.specialtyID#").recordcount gt 0>

					<cfif NOT isPremier>
						<cfset client.introductoryListing = TRUE>
					</cfif>
				</cfif>


				<!--- Create new record --->
				<cfquery name="qSaveDr" datasource="myLocateadoc">
					Insert Into doctors_only_doctors
					(
					dr_first_name,
					dr_last_name,
					dr_designation,
					dr_email,
					dr_website,
					contact_first_name,
					contact_last_name,
					contact_email,
					practice_name,
					practice_phone,
					practice_address_1,
					practice_country_id,
					practice_postal_code,
					practice_city,
					practice_state_id,
					<!--- passwordHash, --->
					<!--- pro_password, --->
					specialty_id_1,
					specialty_id_2,
					specialty_id_3,
					specialty_id_4,
					procedure_ids,
			        keywords,
			        referralfull,
					sf_campaign_id,
					<!--- medicalLicenseCode, --->
					physicianRepresentative,
					forms_completed,

					ipAddress,
					refererInternal,
					userAgent,
					cfId,
					cfToken,
					entryPage,

					created_dt
					)
					Values
					(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctorfirstname#">, <!--- dr_first_name --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctorlastname#">,<!--- dr_last_name --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctortitle#">,<!--- dr_designation --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctoremail#">,<!--- dr_email --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.website#">,<!--- dr_website --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.contactfirstname#">,<!--- contact_first_name --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.contactlastname#">,<!--- contact_last_name --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.contactemail#">,<!--- contact_email --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.practicename#">,<!--- practice_name --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.doctorphone#">,<!--- practice_phone --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.address#">,<!--- practice_address_1 --->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#params.country#">,<!--- practice_country_id --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.zip#">,<!--- practice_postal_code --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.city#">,<!--- practice_city --->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#params.state#">,	<!--- practice_state_id --->
					<!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#oSCrypt.SCrypt(params.password)#">, ---><!--- pro_password --->
					<cfif val(params.specialtyID) gt 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#val(params.specialtyID)#">,
					<cfelse>
						NULL,
					</cfif>
					<cfif val(params.specialty2ID) gt 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#val(params.specialty2ID)#">,
					<cfelse>
						NULL,
					</cfif>
					<cfif val(params.specialty3ID) gt 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#val(params.specialty3ID)#">,
					<cfelse>
						NULL,
					</cfif>
					<cfif val(params.specialty4ID) gt 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#val(params.specialty4ID)#">,
					<cfelse>
						NULL,
					</cfif>
					<cfif procedureList neq "">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#procedureList#">,
					<cfelse>
						NULL,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Client.KEYWORDS#">,
			        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Client.ReferralFull#">,
			        <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.campaignID#">,
			        <!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.license#">, --->
			        <cfqueryparam cfsqltype="cf_sql_tinyint" value="#params.physician#">,

			        <cfif params.page EQ 2 AND NOT isPremier AND params.introductoryAccept IS FALSE>
		        		1
		        	<cfelse>
		        		<cfqueryparam cfsqltype="cf_sql_numeric" value="#val(params.page)#">
		        	</cfif>,

			        <cfqueryparam value="#cgi.remote_addr#">,
			        <cfqueryparam value="#cgi.http_referer#">,
			        <cfqueryparam value="#cgi.http_user_agent#">,
			        <cfqueryparam cfsqltype="cf_sql_integer" value="#val(client.CFID)#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#val(client.CFTOKEN)#">,
					<cfqueryparam value="#Client.EntryPage#">,

					now()
					)
				</cfquery>
				<cfquery datasource="myLocateadoc" name="qDoc">
					SELECT last_insert_id() AS id
				</cfquery>
				<cfset docOnlyID = qDoc.id>
			<cfelse>
				<cfset params.page eq 1>
			</cfif>
		</cfif>

		<cfif params.page eq 4 and docOnlyID gt 0>

			<cfscript>
				params.doctorsOnlyId = docOnlyId;
				if (NOT isPremier){
					processPayment();
				}
			</cfscript>

			<cfif not docSubmitted>
				<cfset PostSalesforceLead(id=docOnlyID,comments=params.comments,ladCampaignID=params.campaignID)>
			</cfif>
		</cfif>

		<!--- Page-specific information --->
		<cfset title = "Add Your Practice Listing on LocateADoc.com for local medical marketing, and doctor marketing">
		<cfset metaDescriptionContent = "Built for physicians to advertise your medical practice and generate patient referrals through LocateADoc.com.">
		<cfswitch expression="#params.page#">
			<cfcase value="1">
				<cfset testimonialInfo = model("SpecialContent").findAll(
					 where = "name = 'Add Listing Testimonial'",
					 $limit = "1")>
			</cfcase>
			<cfcase value="2">
				<cfset states	= model("State").findAll(
					select="states.name, states.abbreviation, states.id, countries.name as country, countries.id as countryid",
					include="country",
					where="countries.showOnDirectory = 1",
					<!--- where="states.id NOT IN (72,73)", ---> <!--- Temporary fix to exclude states that have California as a subset --->
					order="countries.directoryOrder asc, countries.name asc, states.name asc")>
				<cfset countries = model("Country").findAll(
					select="id,name",
					where="directoryOrder IS NOT NULL",
					order="directoryOrder asc,name asc")>
			</cfcase>
			<cfcase value="3">
				<cfset stateInfo = model("State").findAll(select="name",where="id = #params.state#")>
				<cfset countryInfo = model("Country").findAll(select="name",where="id = #params.country#")>

				<cfset states = model("State").findAll( 	where	= "countryId IN (12,48,102)",
													select	= "id, name",
													order	= "name")>
				<cfset countries = model("Country").findAll(	where	= "id IN (12,48,102)",
																select	= "id, name",
																order	= "name")>
				<cfset params.doctorsOnlyId = docOnlyId>
			</cfcase>
		</cfswitch>

		<cfset Request.mobileLayout = true>
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">

			<cfset specialties = model("Specialty").findAll(	select	= "id, name",
																where	= "hasDoctorsOnly = 1",
																order	="name")>

			<cfset procedures = model("Procedure").findAll(	select	= "procedures.id, procedures.name",
															include	= "specialtyprocedures",
															where	= "specialtyprocedures.specialtyId = '#params.specialtyId#'")>

			<cfset renderPage(layout="/layout_mobile")>
		</cfif>
	</cffunction>


	<cffunction name="processPayment" access="public">
		<!---
			Step Two: Create an HTML form that collects the customer's sensitive payment information and use the form-url that the Payment Gateway returns as the submit action in that form.

			Next, during step two, you must develop an HTML form that collects at least the customer's sensitive payment information such as cc-number, cc-exp, and cvv.
			You must use the form-url obtained in step one as the action in the HTML of your payment form.
			When the customer submits the form, the customer's browser will transparently POST the contents of the payment form directly to the Payment Gateway.
			This methodology keeps your web server and payment application from seeing or transmitting any credit card data or other sensitive data.
			Once the Payment Gateway has collected the customer's sensitive payment details, the customer's browser will be instructed to return to the redirect-url on your web server.
			Furthermore, the Payment Gateway will generate and append a unique variable named token-id to the redirect-url in the GET query string.
			This token-id is an abstraction of the customer's sensitive payment information that the Payment Gateway collected.
			Your redirect-url script must parse the token-id for use in step three. --->

		<cfset var xmlRequestString = "">

		<cfparam default="" name="params.doctorsOnlyId">
		<cfparam default="" name="params.billingAddressCompany">
		<cfparam default="" name="params.billingAddressFirstName">
		<cfparam default="" name="params.billingAddressLastName">
		<cfparam default="" name="params.billingAddressAddress1">
		<cfparam default="" name="params.billingAddressAddress2">
		<cfparam default="" name="params.billingAddressCity">
		<cfparam default="" name="params.billingAddressStateId">
		<cfparam default="" name="params.billingAddressZip">
		<cfparam default="" name="params.billingAddressCountryId">
		<cfparam default="" name="params.billingAddressPhone">
		<cfparam default="" name="params.billingAddressFax">
		<cfparam default="" name="params.billingAddressEmail">
		<cfparam default="" name="params.billingAddressAmount">

		<!--- Save Billing Address --->
		<cfset  newTransaction = model("DoctorsOnlyPayment").new()>

		<cfset newTransaction.doctorsOnlyId = params.doctorsOnlyId>
		<cfset newTransaction.billingAddressCity = params.billingAddressCity>
		<cfset newTransaction.billingAddressStateId = params.billingAddressStateId>
		<cfset newTransaction.billingAddressCountryId = params.billingAddressCountryId>
		<cfset newTransaction.billingAddressFirstName = params.billingAddressFirstName>
		<cfset newTransaction.billingAddressLastName = params.billingAddressLastName>
		<cfset newTransaction.billingAddressCompany = params.billingAddressCompany>
		<cfset newTransaction.billingAddressAddress1 = params.billingAddressAddress1>
		<cfset newTransaction.billingAddressAddress2 = params.billingAddressAddress2>
		<cfset newTransaction.billingAddressZip = params.billingAddressZip>
		<cfset newTransaction.billingAddressEmail = params.billingAddressEmail>
		<cfset newTransaction.billingAddressPhone = StripPhoneNumber(params.billingAddressPhone)>
		<cfset newTransaction.billingAddressFax = StripPhoneNumber(params.billingAddressFax)>
		<cfset newTransaction.amount = variables.billingAddressAmount>

		<cfif params.termsAndConditions EQ 1>
			<cfset newTransaction.termsAndConditionsAt = now()>
		</cfif>

		<cfset newTransaction.step1At = now()>

		<cfset saved = newTransaction.save()>


		<!--- Check for any errors saving the Billing Address --->
		<cfif newTransaction.HASERRORS()>
			<cfoutput>
				<cfset fnCthulhuException(	message		= "Doctor Marketing - Save Payment Error",
											dumpStruct	= newTransaction.ALLERRORS()[1])>

				<cfif server.thisServer EQ "dev">
					<cfdump var="#newTransaction.ALLERRORS()#" label="ALLERRORS" abort="true"><br />
				</cfif>
			</cfoutput>
		</cfif>

		<cfset state = model("State").findByKey(	key		= params.billingAddressStateId,
													select	= "abbreviation")>

		<cfset country = model("Country").findByKey(	key		= params.billingAddressCountryId,
														select	= "abbreviation")>


		<cfscript>
			// Create XML Document for submitting the billing address to secure.charge1

			var xmlRequestDoc = xmlNew();
			xmlRequestDoc.xmlRoot = XmlElemNew(xmlRequestDoc, "", "sale");

			xmlRequestDoc.xmlRoot.XmlChildren[1] = XmlElemNew(xmlRequestDoc,"api-key");
			xmlRequestDoc.xmlRoot.XmlChildren[1].xmlText = variables.charge1ApiKey;


			xmlRequestDoc.xmlRoot.XmlChildren[2] = XmlElemNew(xmlRequestDoc,"redirect-url");
			xmlRequestDoc.xmlRoot.XmlChildren[2].xmlText = paymentGatewayURL;

			xmlRequestDoc.xmlRoot.XmlChildren[3] = XmlElemNew(xmlRequestDoc,"ip-address");
			xmlRequestDoc.xmlRoot.XmlChildren[3].xmlText = cgi.REMOTE_ADDR;

			xmlRequestDoc.xmlRoot.XmlChildren[4] = XmlElemNew(xmlRequestDoc,"industry");
			xmlRequestDoc.xmlRoot.XmlChildren[4].xmlText = "ecommerce";

			xmlRequestDoc.xmlRoot.XmlChildren[5] = XmlElemNew(xmlRequestDoc,"billing-method");
			xmlRequestDoc.xmlRoot.XmlChildren[5].xmlText = "recurring";

			xmlRequestDoc.xmlRoot.XmlChildren[6] = XmlElemNew(xmlRequestDoc,"billing-number");
			xmlRequestDoc.xmlRoot.XmlChildren[6].xmlText = 0;

			xmlRequestDoc.xmlRoot.XmlChildren[7] = XmlElemNew(xmlRequestDoc,"order-description");
			xmlRequestDoc.xmlRoot.XmlChildren[7].xmlText = "Paid Basic Plus";

			xmlRequestDoc.xmlRoot.XmlChildren[8] = XmlElemNew(xmlRequestDoc,"customer-id");
			xmlRequestDoc.xmlRoot.XmlChildren[8].xmlText = params.doctorsOnlyId;

			xmlRequestDoc.xmlRoot.XmlChildren[9] = XmlElemNew(xmlRequestDoc,"merchant-receipt-email");
			xmlRequestDoc.xmlRoot.XmlChildren[9].xmlText = "order@locateadoc.com";

			xmlRequestDoc.xmlRoot.XmlChildren[10] = XmlElemNew(xmlRequestDoc,"customer-receipt");
			xmlRequestDoc.xmlRoot.XmlChildren[10].xmlText = "true";


			xmlRequestDoc.xmlRoot.XmlChildren[11] = XmlElemNew(xmlRequestDoc,"amount");
			xmlRequestDoc.xmlRoot.XmlChildren[11].xmlText = variables.billingAddressAmount;


			// **** BILLING ***
			xmlBilling = XmlElemNew(xmlRequestDoc, "", "billing");

			xmlBilling.xmlChildren[1] = XmlElemNew(xmlRequestDoc,"first-name");
			xmlBilling.xmlChildren[1].xmlText = params.billingAddressFirstName;

			xmlBilling.xmlChildren[2] = XmlElemNew(xmlRequestDoc,"last-name");
			xmlBilling.xmlChildren[2].xmlText = params.billingAddressLastName;

			xmlBilling.xmlChildren[3] = XmlElemNew(xmlRequestDoc,"address1");
			xmlBilling.xmlChildren[3].xmlText = params.billingAddressAddress1;

			xmlBilling.xmlChildren[4] = XmlElemNew(xmlRequestDoc,"city");
			xmlBilling.xmlChildren[4].xmlText = params.billingAddressCity;

			xmlBilling.xmlChildren[5] = XmlElemNew(xmlRequestDoc,"state");
			xmlBilling.xmlChildren[5].xmlText = state.abbreviation;

			xmlBilling.xmlChildren[6] = XmlElemNew(xmlRequestDoc,"postal");
			xmlBilling.xmlChildren[6].xmlText = params.billingAddressZip;

			xmlBilling.xmlChildren[7] = XmlElemNew(xmlRequestDoc,"country");
			xmlBilling.xmlChildren[7].xmlText = country.abbreviation;

			xmlBilling.xmlChildren[8] = XmlElemNew(xmlRequestDoc,"address2");
			xmlBilling.xmlChildren[8].xmlText = params.billingAddressAddress2;

			xmlBilling.xmlChildren[9] = XmlElemNew(xmlRequestDoc,"phone");
			xmlBilling.xmlChildren[9].xmlText = params.billingAddressPhone;

			xmlBilling.xmlChildren[10] = XmlElemNew(xmlRequestDoc,"fax");
			xmlBilling.xmlChildren[10].xmlText = params.billingAddressFax;

			xmlBilling.xmlChildren[11] = XmlElemNew(xmlRequestDoc,"email");
			xmlBilling.xmlChildren[11].xmlText = params.billingAddressEmail;

			xmlBilling.xmlChildren[12] = XmlElemNew(xmlRequestDoc,"company");
			xmlBilling.xmlChildren[12].xmlText = params.billingAddressCompany;


			// Append to Root
			xmlRequestDoc.xmlRoot.XmlChildren[12] = xmlBilling;


			xmlSubscription = XmlElemNew(xmlRequestDoc, "", "add-subscription");

			xmlSubscription.xmlChildren[1] = XmlElemNew(xmlRequestDoc,"start-date");
			xmlSubscription.xmlChildren[1].xmlText = DateFormat(dateAdd("d", 1, now()), 'YYYYMMDD');


			xmlPlan = XmlElemNew(xmlRequestDoc, "", "plan");

			xmlPlan.xmlChildren[1] = XmlElemNew(xmlRequestDoc,"payments");
			xmlPlan.xmlChildren[1].xmlText = 0;

			xmlPlan.xmlChildren[2] = XmlElemNew(xmlRequestDoc,"amount");
			xmlPlan.xmlChildren[2].xmlText = variables.billingAddressAmount;

			xmlPlan.xmlChildren[3] = XmlElemNew(xmlRequestDoc,"month-frequency");
			xmlPlan.xmlChildren[3].xmlText = 1;

			xmlPlan.xmlChildren[4] = XmlElemNew(xmlRequestDoc,"day-of-month");
			xmlPlan.xmlChildren[4].xmlText = day(now());


			xmlSubscription.xmlChildren[2] = xmlPlan;

			xmlRequestDoc.xmlRoot.XmlChildren[13] = xmlSubscription;


			local.xmlRequestString = ToString(xmlRequestDoc);
		</cfscript>


		<!--- Fixes some bug that doesn't read the ssl certificate correctly --->
		<cfset objSecurity = createObject("java", "java.security.Security") />
		<cfset storeProvider = objSecurity.getProvider("JsafeJCE") />
		<cfset objSecurity.removeProvider("JsafeJCE") />

		<cftry>

			<cfmail from="order@locateadoc.com"
					to="test@locateadoc.com"
					subject="Doctor Marketing Monitoring: processPayment - CHARGE1 HTTP Request"
					type="html">
				<p><cfdump var="#xmlRequestDoc#"></p>
				<p><cfdump var="#local.xmlRequestString#"></p>
				<p><cfdump var="#params#"></p>
				<cfdump var="#local#">
			</cfmail>

			<!--- Submit the Billing address XML document to secure.charge1. The response will include a redirect URL to submit the CC numbers --->
			<cfhttp url="https://secure.charge1.com/api/v2/three-step"
					method="post">
				<cfhttpparam type="XML" value="#local.xmlRequestString#">
			</cfhttp>

			<cfmail from="order@locateadoc.com"
					to="test@locateadoc.com"
					subject="Doctor Marketing Monitoring: processPayment - CHARGE1 HTTP REsponse"
					type="html">
				<p><cfdump var="#CFHTTP#"></p>
				<cfdump var="#local#">
			</cfmail>

			<!--- Fixes some bug that doesn't read the ssl certificate correctly --->
			<!--- <cfset objSecurity.insertProviderAt(storeProvider, 1) /> --->


			<cfcatch type="any">
				<!--- Gracefully handle any errors --->

				<cfmail from="order@locateadoc.com"
						to="test@locateadoc.com"
						subject="Doctor Marketing Monitoring: processPayment error"
						type="html">
					<cfdump var="#local#">
				</cfmail>

				<cfif not isDefined("CFHTTP")>
					<cfsavecontent variable="responseText"><h1>Error</h1><p>The payment gateway service seems to be down. Please try again later.</p></cfsavecontent>
					<cfset response = "response=3&responsetext=#responseText#">

					<cfoutput>
						<cfdump var="#response#" label="responseError">
					</cfoutput>

					<cfset fnCthulhuException(	message		= "Doctor Marketing - Save Payment Error",
												dumpStruct	= cfcatch)>
				<cfelse>
					<cfoutput>
						<cfdump var="#CFHTTP.FileContent#" label="CFHTTPError">

						<cfset fnCthulhuException(	message		= "Doctor Marketing - Save Payment Error",
													dumpStruct	= cfcatch)>
					</cfoutput>
				</cfif>
			</cfcatch>
		</cftry>

		<cfset xmlDoc = XmlParse(CFHTTP.FileContent)>

		<cfquery datasource="myLocateadocEdits">
			UPDATE doctorsonlypayments
			SET responseStep1 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#CFHTTP.FileContent#">,
				responseStep1ResultText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xmlDoc.response["result-text"].xmlText#">,
				responseStep1FormURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xmlDoc.response["form-url"].xmlText#">,
				responseStep1SubscriptionId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xmlDoc.response["subscription-id"].xmlText#">,
				responseStep1ResultCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xmlDoc.response["result-code"].xmlText#">,
				responseStep1Result = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xmlDoc.response["result"].xmlText#">,
				step1At = now()
			WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#newTransaction.id#">
		</cfquery>

		<cfset client.doctorMarketingResponseStep1FormURL = xmlDoc.response["form-url"].xmlText>
		<cfset client.doctorMarketingTransactionId = newTransaction.id>

		<cfmail from="order@locateadoc.com"
				to="test@locateadoc.com"
				subject="Doctor Marketing Monitoring: processPayment"
				type="html">
			<cfdump var="#local#">
		</cfmail>

		<cfif params.action EQ "process-payment">
		<cfelse>
			<cfreturn>
		</cfif>


	</cffunction>

	<cffunction name="PaymentGateway">
		<cfparam default="" name="url.token-id">

		<cfset userMessages = {}>
		<cfset receipt = {}>

		<!--- Step Three: Once the customer has been redirected, obtain the token-id
			and complete the transaction through an HTTPS POST including the token-id which abstracts the sensitive payment information that was collected directly by the Payment Gateway.

			To complete the transaction, you will submit another behind-the-scenes HTTPS direct POST including only the token-id and api-key.
			This token-id is used to "tie" together the initial customer information with the sensitive payment information that the payment gateway collected directly. --->
		<cfquery datasource="myLocateadocEdits">
			UPDATE doctorsonlypayments
			SET responseStep2TokenId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url['token-id']#">,
				step2At = now()
			WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.doctorMarketingTransactionId#">
		</cfquery>

		<cfscript>
			var xmlResponseDoc = "";
			var xmlRequestString = "";
			var xmlRequestDoc = xmlNew();

			local.xmlRequestDoc.xmlRoot = XmlElemNew(xmlRequestDoc, "", "complete-action");

			local.xmlRequestDoc.xmlRoot.XmlChildren[1] = XmlElemNew(xmlRequestDoc,"api-key");
			local.xmlRequestDoc.xmlRoot.XmlChildren[1].xmlText = variables.charge1ApiKey;

			local.xmlRequestDoc.xmlRoot.XmlChildren[2] = XmlElemNew(xmlRequestDoc,"token-id");
			local.xmlRequestDoc.xmlRoot.XmlChildren[2].xmlText = url["token-id"];

			local.xmlRequestString = toString(local.xmlRequestDoc);
		</cfscript>


		<cfset objSecurity = createObject("java", "java.security.Security") />
		<cfset storeProvider = objSecurity.getProvider("JsafeJCE") />
		<cfset objSecurity.removeProvider("JsafeJCE") />

		<cftry>

			<cfhttp url="https://secure.charge1.com/api/v2/three-step"
					method="post">
				<cfhttpparam type="XML" value="#local.xmlRequestString#">
			</cfhttp>

			<!--- Fixes some bug that doesn't read the ssl certificate correctly --->
			<!--- <cfset objSecurity.insertProviderAt(storeProvider, 1) /> --->


			<cfcatch type="any">

				<cfif not isDefined("CFHTTP")>

					<cfset fnCthulhuException(	message		= "Doctor Marketing - PaymentGateway CFHTTP Not Defined Error",
												details		= "There was an error in your payment submission. Please check your email for additional information.",
												scriptName	= "/controllers/DoctorMarketing.cfc")>

				<cfelse>
					<cfoutput>

						<cfset fnCthulhuException(	message		= "Doctor Marketing - PaymentGateway Error",
													dumpStruct	= CFHTTP,
													details		= "There was an error in your payment submission. Please check your email for additional information.",
													scriptName	= "/controllers/DoctorMarketing.cfc")>
					</cfoutput>
				</cfif>
			</cfcatch>
		</cftry>

		<cfset local.xmlResponseDoc = XmlParse(CFHTTP.FileContent)>

		<cfset userMessages.responseCode = local.xmlResponseDoc.response["result-code"].xmlText>
		<cfset userMessages.ResponseText = local.xmlResponseDoc.response["result-text"].xmlText>

		<cfscript>
			if(userMessages.responseCode == 100){
				saveCreditCardPostResponse(	xmlResponseDoc	= local.xmlResponseDoc);
			} else if(userMessages.responseCode == 300 && userMessages.ResponseText != '') {
				saveCreditCardPostResponseError(	xmlResponseDoc	= local.xmlResponseDoc);
				/* Redirect back to the Credit Card page
				 * <?xml version="1.0" encoding="UTF-8"?>
					<response>
					  <result>3</result>
					  <result-text>The cc payment type [Hipercard] and/or currency [USD] is not accepted REFID:3171470397</result-text>
					  <result-code>300</result-code>
					</response>

				 **/
			}
		</cfscript>



		<cfif NOT isNumeric(client.doctorMarketingTransactionId) OR val(client.doctorMarketingTransactionId) EQ 0>
			<cfset fnCthulhuException(	message		= "Transaction Identifier is Missing",
										details		= "There was an error in your payment submission. Please check your email for additional information.",
										scriptName	= "/controllers/DoctorMarketing.cfc")>
		</cfif>


		<cfif userMessages.responseCode NEQ 100>
			<!--- Check if the user already submitted the payment  --->
			<cfif isNumeric(client.doctormarketingtransactionid)>
				<cfset payment = model("DoctorsOnlyPayment").findByKey(
											key		= client.doctormarketingtransactionid,
											select	= "responseStep3, responseStep3ResultCode, step3At")>

				<cfif isObject(payment) AND payment.responseStep3ResultCode EQ 100>
					<cfset local.xmlResponseDoc = xmlParse(payment.responseStep3)>
					<cfset userMessages.responseCode = payment.responseStep3ResultCode>

					<cfset receipt = getReceipt(local.xmlResponseDoc)>
					<cfset receipt.orderDate = payment.step3At>
				<cfelseif isObject(payment) AND payment.responseStep3ResultCode EQ 300>
					<cfset local.xmlResponseDoc = xmlParse(payment.responseStep3)>
					<cfset userMessages.responseCode = payment.responseStep3ResultCode>

				<cfelse>
					<!--- Something wrong occurred. Redirect back to  --->
					<!---
						<?xml version="1.0" encoding="UTF-8"?>
						<response>
						  <result>3</result>
						  <result-text>The cc payment type [Hipercard] and/or currency [USD] is not accepted REFID:3171519944</result-text>
						  <result-code>300</result-code>
						</response>
					 --->

				</cfif>
			</cfif>

		<cfelseif userMessages.responseCode EQ 100>
			<cfset createNewAccount = model("Account").CreateNew(	doctorsOnlyPaymentId	 = client.doctorMarketingTransactionId)>

			<cfif createNewAccount.success>
				<cfset salesForceConvertLeadToOpportunity(accountId = createNewAccount.doctor.accountId)>
				<cfset salesForceCreateContract(accountId = createNewAccount.doctor.accountId)>
				<cfset salesForceUpdateOpportunity(accountId = createNewAccount.doctor.accountId)>
			</cfif>

			<cfset receipt = getReceipt(local.xmlResponseDoc)>
			<cfset receipt.orderDate = now()>

			<cfset emailContent = renderPartial(	partial = "paymentemail", returnAs="String")>
			<cfset isNonPremier = true>

			<cfmail from		= "order@locateadoc.com"
					to			= "#createNewAccount.receiptTo#"
					bcc			= "order@locateadoc.com"
					subject		= "LocateADoc.com: Your New Listing Order is Ready"
					type		= "html">
				#includePartial("/shared/email")#
			</cfmail>
		</cfif>

		<cflocation addtoken="false" url="/doctor-marketing/payment-status">

	</cffunction>


<cfscript>

	public void function paymentStatus(){
		param name="client.doctormarketingtransactionid" default="";

		missingGateway = false;

		if (!isNumeric(client.doctormarketingtransactionid)){
			missingGateway = true;
		} else {

			userMessages = {};
			userMessages.responseCode = '';
			userMessages.responseText = "No record found for this transaction";

			payment = model("DoctorsOnlyPayment").findByKey(
										key		= client.doctormarketingtransactionid,
										select	= "responseStep3, responseStep3ResultCode, step3At");

			if (isObject(payment) AND payment.responseStep3ResultCode EQ 100){
				local.xmlResponseDoc = xmlParse(payment.responseStep3);
				userMessages.responseCode = payment.responseStep3ResultCode;
				userMessages.ResponseText = local.xmlResponseDoc.response["result-text"].xmlText;
				receipt = getReceipt(local.xmlResponseDoc);
				receipt.orderDate = payment.step3At;
			} else if (isObject(payment) AND payment.responseStep3ResultCode EQ 300) {
				local.xmlResponseDoc = xmlParse(payment.responseStep3);
				userMessages.responseCode = payment.responseStep3ResultCode;
				userMessages.ResponseText = local.xmlResponseDoc.response["result-text"].xmlText;
			}
		}
	}

	private void function saveCreditCardPostResponse(	required xml xmlResponseDoc){

		// Save the results of the updated Credit Card Information
		var updateResponseStep3 = model("DoctorsOnlyPayment").findByKey(client.doctorMarketingTransactionId);
		local.updateResponseStep3.responseStep3 = toString(arguments.xmlResponseDoc);
		local.updateResponseStep3.responseStep3ResultText = arguments.xmlResponseDoc.response["result-text"].xmlText;
		local.updateResponseStep3.responseStep3ResultCode = arguments.xmlResponseDoc.response["result-code"].xmlText;
		local.updateResponseStep3.responseStep3Result = arguments.xmlResponseDoc.response["result"].xmlText;
		local.updateResponseStep3.responseStep3SubscriptionId = arguments.xmlResponseDoc.response["subscription-id"].xmlText;
		local.updateResponseStep3.step3At = now();
		local.updateResponseStep3Saved = updateResponseStep3.save();

		// Check for any errors saving the Billing Address
		if (local.updateResponseStep3.HASERRORS())
		{
			fnCthulhuException(	message		= "Doctor Marketing - Update Credit Card Post Response Error",
								details		= "Doctor Marketing - Update Credit Card Post Response Error",
								scriptName	= "/controllers/DoctorMarketing.cfc",
								dumpStruct	= local.updateResponseStep3.ALLERRORS()[1]);
		}
	}

	private void function saveCreditCardPostResponseError(	required xml xmlResponseDoc){

		// Save the results of the updated Credit Card Information
		var updateResponseStep3 = model("DoctorsOnlyPayment").findByKey(client.doctorMarketingTransactionId);
		local.updateResponseStep3.responseStep3 = toString(arguments.xmlResponseDoc);
		local.updateResponseStep3.responseStep3ResultText = arguments.xmlResponseDoc.response["result-text"].xmlText;
		local.updateResponseStep3.responseStep3ResultCode = arguments.xmlResponseDoc.response["result-code"].xmlText;
		local.updateResponseStep3.responseStep3Result = arguments.xmlResponseDoc.response["result"].xmlText;
		local.updateResponseStep3.step3At = now();
		local.updateResponseStep3Saved = updateResponseStep3.save();

		// Check for any errors saving the Billing Address
		if (local.updateResponseStep3.HASERRORS())
		{
			fnCthulhuException(	message		= "Doctor Marketing - Update Credit Card Post Response Error",
								details		= "Doctor Marketing - Update Credit Card Post Response Error",
								scriptName	= "/controllers/DoctorMarketing.cfc",
								dumpStruct	= local.updateResponseStep3.ALLERRORS()[1]);
		}
	}
</cfscript>

	<cffunction name="addlistingform" returntype="struct" access="private">
		<cfparam name="params.doctorfirstname" default="">
		<cfparam name="params.doctorlastname" default="">
		<cfparam name="params.practicename" default="">
		<cfparam name="params.specialty" default="">
		<cfparam name="params.specialty2" default="">
		<cfparam name="params.doctorphone" default="">
		<cfparam name="params.doctoremail" default="">
		<cfparam name="params.zip" default="">
		<cfparam name="params.state" default="">
		<cfparam name="params.country" default="">
		<cfparam name="params.physician" default="">
		<cfparam name="params.campaignID" default="70160000000MC9x">

		<cfif params.action neq "addListing">
			<cfset SP_titles = {specialty='',specialty2=''}>
		</cfif>

		<cfset formcontent = {}>
		<cfset formcontent.states = model("State").findAll(
				select="states.name, states.abbreviation, states.id, countries.name as country, countries.id as countryid",
				include="country",
				where="countries.showOnDirectory = 1",
				<!--- where="states.id NOT IN (72,73)", ---> <!--- Temporary fix to exclude states that have California as a subset --->
				order="countries.directoryOrder asc, countries.name asc, states.name asc")>
		<cfset formcontent.countries = model("Country").findAll(
				select="id,name",
				where="directoryOrder IS NOT NULL",
				order="directoryOrder asc,name asc")>
		<cfreturn formcontent>
	</cffunction>

	<cffunction name="PostSalesforceLead" access="public" output="true" returntype="void">
		<cfargument name="id" default="">
		<cfargument name="comments" default="">
		<cfargument name="ladCampaignID" default="70160000000MC9x">

		<cfset var merchantCampaignId = "7013000000020jp">
		<cfset var campaignIdList = "">
		<cfset var campaignId = "">
		<cfset var productIdList = "">
		<cfset var leadFormSourceExtra = "">
		<cfset var local.thisCounty = "">
		<cfset var local.thisState = "">
		<cfset var local.thisCity = "">
		<cfset var local.qDoc = "">

		<cfset var local.serverURL = "">
		<cfset var local.sessionID = "">
		<cfset var local.xmlResponse = "">
		<cfset var local.leadId = "">
		<cfset var local.ownerId = "">



		<cfinvoke component="com#Application.SharedModulesSuffix#.patientreferraloffice.salesforce.CreateSession"
				  method="getSessionSOAP"
				  returnVariable="local.rsfdc">

		<cfset local.serverURL = local.rsfdc.serverUrl>
		<cfset local.sessionID = local.rsfdc.sessionId>


		<cfmail from="order@locateadoc.com"
				to="test@locateadoc.com"
				subject="Doctor Marketing Monitoring: PostSalesforceLead1">
			PostSalesforceLead1
		</cfmail>

		<cfif NOT isnumeric(arguments.id)>
			<cfreturn>
		</cfif>

		<cfmail from="order@locateadoc.com"
				to="test@locateadoc.com"
				subject="Doctor Marketing Monitoring: PostSalesforceLead2">
			PostSalesforceLead2
		</cfmail>

		<cfquery datasource="myLocateadoc" name="local.qDoc">
			SELECT d.id,
				d.dr_first_name as firstName,
				d.dr_last_name as lastName,
				d.dr_designation as designation,
				d.dr_email as drEmail,
				d.dr_website as website,
				d.contact_first_name as contactFirstName,
				d.contact_last_name as contactLastName,
				d.contact_email as contactEmail,
				d.practice_name as company,
				<!--- Concat( --->d.practice_address_1<!--- , " ", d.practice_address_2) ---> as address,
				d.practice_country_id as country_id,
				d.practice_postal_code as zip,
				d.practice_city as city,
				d.practice_state_id as stateid,
				d.practice_phone as practicePhone,
				d.passwordHash as password,
				d.specialty_id_1 as specialtyId1,
				d.specialty_id_2 as specialtyId2,
				d.specialty_id_3 as specialtyId3,
				d.specialty_id_4 as specialtyId4,
				d.procedure_ids,
				d.suggested_specialty as specialty_suggested,
				d.suggested_procedure as procedures_suggested,
				d.contact_days as contact_phone_day,
				d.contact_times as contactphonetime,
				d.contact_phone as contactPhone,
				d.is_sent,
				d.sf_campaign_id,
				d.created_dt AS createdAt,
				concat(group_concat(DISTINCT s.name ORDER BY s.name SEPARATOR ';')) AS specialtiesSelected,
				/*concat(group_concat(DISTINCT s.name ORDER BY s.name), IF(d.suggested_specialty <> "", concat(",", d.suggested_specialty), "")) AS specialtiesSelected,*/
				max(s.is_premier) AS hasPremier
			FROM doctors_only_doctors d
			LEFT OUTER JOIN specialty s ON s.id IN (d.specialty_id_1,d.specialty_id_2,d.specialty_id_3,d.specialty_id_4)
			WHERE d.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
					 and d.sentAt IS NULL and (d.info_id is null OR d.info_id = 0)
			GROUP BY d.id
		</cfquery>

		<cfif local.qDoc.recordcount EQ 0>
			<cfreturn>
		</cfif>

		<cfset docOnlyID = arguments.id>

		<cfmail from="order@locateadoc.com"
				to="test@locateadoc.com"
				subject="Doctor Marketing Monitoring: PostSalesforceLead3">
			PostSalesforceLead3
		</cfmail>


		<cfquery datasource="myLocateadoc" name="local.qProducts">
			SELECT doq.id, doq.products AS name
			FROM doctors_only_answers doa
			INNER JOIN doctors_only_questions doq ON doq.id = doa.question_id AND doq.is_active = 1
			WHERE doa.doctor_id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer"> AND doa.is_active = 1
		</cfquery>

		<cfset local.productIdList = valueList(local.qProducts.id)>

		<cfset local.productNames = model("DoctorsOnlyQuestion").findAll(
			select="doctorsonlyproducts.name",
			include="DoctorsOnlyProduct",
			where="doctorsonlyquestions.id IN (#ListAppend(local.productIdList,0)#)"
		)>

		<cfif isnumeric(local.qDoc.zip)>
			<cfquery datasource="myLocateadocLB3" name="local.qCounty">
				SELECT c.name AS county, us.abbreviation AS State, cities.name AS City
				FROM postalcodes up
				INNER JOIN cities ON cities.id = up.cityId
				INNER JOIN states us ON us.id = up.stateId
				INNER JOIN counties c ON c.id = up.countyId
				WHERE up.postalCode = <cfqueryparam value="#REreplace(left(qDoc.zip,5), "\D", "", "all")#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfset local.thisCounty = local.qCounty.county>
			<cfset local.thisState = local.qCounty.state>
			<cfset local.thisCity = local.qCounty.City>
		<cfelse>
			<cfquery datasource="myLocateadocLB3" name="local./qCounty">
				SELECT us.abbreviation AS State, cities.name AS City
				FROM postalCanada upc
				INNER JOIN cities ON cities.id = upc.cityId
				INNER JOIN states us ON us.id = upc.stateId
				WHERE upc.postalCode = <cfqueryparam value="#REreplace(left(qDoc.zip,5), "\D", "", "all")#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfset local.thisState = local.qCounty.state>
			<cfset local.thisCity = local.qCounty.City>
		</cfif>


		<cfset local.leadFormSourceExtra = "">

		<cfsavecontent variable="local.xmlDoc">
			<cfoutput><?xml version="1.0" encoding="utf-8"?>
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
			  xmlns:urn="urn:enterprise.soap.sforce.com"
			  xmlns:urn1="urn:sobject.enterprise.soap.sforce.com"
			  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			  <soapenv:Header>
			     <urn:SessionHeader>
			        <urn:sessionId>#xmlFormat(local.sessionID)#</urn:sessionId>
			     </urn:SessionHeader>
			  </soapenv:Header>
			  <soapenv:Body>
			     <urn:create>
			        <urn:sObjects xsi:type="urn1:Lead">
			            <Lead_Form_Source__c>#xmlFormat("Doctors Only Addition Form")#</Lead_Form_Source__c>
			            <FirstName>#xmlFormat(local.qDoc.firstName)#</FirstName>
			            <LastName>#xmlFormat(local.qDoc.lastName)#</LastName>
			            <Email>#xmlFormat(local.qDoc.drEmail)#</Email>
			            <AgencyContactName__c>#xmlFormat(local.qDoc.contactFirstName)# #xmlFormat(local.qDoc.contactLastName)#</AgencyContactName__c>
			            <LeadSource>#xmlFormat("Web Referral")#</LeadSource>
			            <Decision_Maker_Phone__c>#xmlFormat(local.qDoc.contactPhone)#</Decision_Maker_Phone__c>
			            <Decision_Maker_Email__c>#xmlFormat(local.qDoc.ContactEmail)#</Decision_Maker_Email__c>
			            <company>#xmlFormat(local.qDoc.company)#</company>
			            <Street>#xmlFormat(local.qDoc.address)#</Street>
			            <City>#xmlFormat(local.thisCity)#</City>
			            <State>#xmlFormat(local.thisState)#</State>
			           <PostalCode>#xmlFormat(local.qDoc.zip)#</PostalCode>
			           <Website>#xmlFormat(local.qDoc.website)#</Website>
			           <County__c>#xmlFormat(thisCounty)#</County__c>
			           <Phone>#xmlFormat(local.qDoc.practicePhone)#</Phone>
			           <Specialties__c>#xmlFormat(local.qDoc.specialtiesSelected)#</Specialties__c>
			           <Other_Speciality__c>#xmlFormat(local.qDoc.specialty_suggested)#</Other_Speciality__c>
						<cfloop query="local.productNames">
							<Products_Interested_In__c>#xmlFormat(local.productNames.name)#</Products_Interested_In__c>
						</cfloop>
			           <Listing__c>#xmlFormat("http://admin.locateadoc.com/admin/LocateADoc/docsearch/doview.cfm?id=#local.qDoc.id#")#</Listing__c>
			           <Notes__c>#xmlFormat(arguments.comments)#</Notes__c>
			        </urn:sObjects>
			     </urn:create>
			  </soapenv:Body>
			</soapenv:Envelope></cfoutput>
		</cfsavecontent>

		<cfset local.xmlDoc = trim(local.xmlDoc)>

		<cfhttp url="#local.serverURL#" method="POST" timeout="10">
		 <cfhttpparam type="HEADER" name="Content-Type" value="text/xml; charset=utf-8">
		 <cfhttpparam type="HEADER" name="Accept" value="application/soap+xml, application/dime, multipart/related, text/*">
		 <cfhttpparam type="HEADER" name="User-Agent" value="Axis/1.1">
		 <cfhttpparam type="HEADER" name="Host" value="www.salesforce.com">
		 <cfhttpparam type="HEADER" name="Cache-Control" value="no-cache">
		 <cfhttpparam type="HEADER" name="Pragma" value="no-cache">
		 <!--- Leave SOAPAction blank. --->
		 <cfhttpparam type="HEADER" name="SOAPAction" value="Hello">
		 <cfhttpparam type="HEADER" name="Content-Length" value="#len(trim(local.xmlDoc))#">
		 <cfhttpparam type="BODY" value="#trim(local.xmlDoc)#">
		</cfhttp>

		<cfset local.xmlResponse = trim(CFHTTP.FileContent)>

		<cfset local.xmlDoc = xmlParse(trim(local.xmlResponse))>
		<cfset local.salesForce = {}>
		<cfset local.salesForce.validResponse = false>
		<cfset local.salesForce.success = ''>
		<cfset local.salesForce.errorsNil = ''>
		<cfset local.salesForce.leadId = ''>

		<cfif 	structKeyExists(local.xmlDoc, "soapenv:Envelope") AND
				structKeyExists(local.xmlDoc['soapenv:Envelope'], "soapenv:Body") AND
				structKeyExists(local.xmlDoc['soapenv:Envelope']['soapenv:Body'], "createResponse") AND
				structKeyExists(local.xmlDoc['soapenv:Envelope']['soapenv:Body'].createResponse, "result")>

			<cfset local.salesForce.validResponse = true>
			<cfset local.salesForce.success = local.xmlDoc['soapenv:Envelope']['soapenv:Body'].createResponse.result.success.XmlText>
			<cfset local.salesForce.errorsNil = local.xmlDoc['soapenv:Envelope']['soapenv:Body'].createResponse.result.errors.xmlAttributes["xsi:nil"]>
			<cfset local.salesForce.leadId = local.xmlDoc['soapenv:Envelope']['soapenv:Body'].createResponse.result.id.xmlText>
		</cfif>

		<cfquery datasource="myLocateadoc">
			UPDATE doctors_only_doctors
			SET is_sent = 1,
				sentAt = now(),
				salesForceWebToLeadResponse = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#CFHTTP.FileContent#">,
				salesForceLeadId =
					<cfif local.salesForce.leadId NEQ ''>
						"#local.salesForce.leadId#"
					<cfelse>
						NULL
					</cfif>
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfmail from="order@locateadoc.com"
				to="test@locateadoc.com"
				subject="Doctor Marketing Monitoring: PostSalesforceLead4"
				type="html">

			<p><cfdump var="#local.salesForce#"></p>

			<p>PostSalesforceLead4</p>
			<p>xmlDoc - <cfdump var="#local.xmlDoc#"></p>
			<p>IsXML - #IsXML(local.xmlDoc)#</p>
			<cfif IsXML(local.xmlDoc)>
				<p>xmlDoc2 - <cfdump var="#XmlParse(local.xmlDoc)#"></p>
			</cfif>
			<p>FileContent = #CFHTTP.FileContent#</p>
			<p><cfdump var="#CFHTTP#"></p>

			<cfif isXML(local.xmlResponse)>
				<p><cfdump var="#xmlParse(local.xmlResponse)#"></p>
			</cfif>
		</cfmail>


	</cffunction>

	<cffunction name="PostSalesforceLeadOLD" access="public" output="true" returntype="void">
		<cfargument name="id" default="">
		<cfargument name="comments" default="">
		<cfargument name="ladCampaignID" default="70160000000MC9x">

		<cfset var merchantCampaignId = "7013000000020jp">
		<cfset var campaignIdList = "">
		<cfset var campaignId = "">
		<cfset var thisCounty = "">
		<cfset var thisCity = "">
		<cfset var productIdList = "">
		<cfset var leadFormSourceExtra = "">

		<cfif NOT isnumeric(arguments.id)>
			<cfreturn>
		</cfif>

		<cfquery datasource="myLocateadoc" name="qDoc">
			SELECT d.id,
				d.dr_first_name as firstName,
				d.dr_last_name as lastName,
				d.dr_designation as designation,
				d.dr_email as drEmail,
				d.dr_website as website,
				d.contact_first_name as contactFirstName,
				d.contact_last_name as contactLastName,
				d.contact_email as contactEmail,
				d.practice_name as company,
				<!--- Concat( --->d.practice_address_1<!--- , " ", d.practice_address_2) ---> as address,
				d.practice_country_id as country_id,
				d.practice_postal_code as zip,
				d.practice_city as city,
				d.practice_state_id as stateid,
				d.practice_phone as practicePhone,
				d.passwordHash as password,
				<!--- d.pro_password as password, --->
				d.specialty_id_1 as specialtyId1,
				d.specialty_id_2 as specialtyId2,
				d.specialty_id_3 as specialtyId3,
				d.specialty_id_4 as specialtyId4,
				d.procedure_ids,
				d.suggested_specialty as specialty_suggested,
				d.suggested_procedure as procedures_suggested,
				d.contact_days as contact_phone_day,
				d.contact_times as contactphonetime,
				d.contact_phone as contactPhone,
				d.is_sent,
				d.sf_campaign_id,
				d.created_dt AS createdAt,
				concat(group_concat(DISTINCT s.name ORDER BY s.name SEPARATOR ';')) AS specialtiesSelected,
				/*concat(group_concat(DISTINCT s.name ORDER BY s.name), IF(d.suggested_specialty <> "", concat(",", d.suggested_specialty), "")) AS specialtiesSelected,*/
				max(s.is_premier) AS hasPremier
			FROM doctors_only_doctors d
			LEFT OUTER JOIN specialty s ON s.id IN (d.specialty_id_1,d.specialty_id_2,d.specialty_id_3,d.specialty_id_4)
			WHERE d.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
					 and d.sentAt IS NULL and (d.info_id is null OR d.info_id = 0)
			GROUP BY d.id
		</cfquery>

		<cfif qDoc.recordcount EQ 0>
			<cfreturn>
		</cfif>

		<cfquery datasource="myLocateadoc" name="qProducts">
			SELECT doq.id, doq.products AS name
			FROM doctors_only_answers doa
			INNER JOIN doctors_only_questions doq ON doq.id = doa.question_id AND doq.is_active = 1
			WHERE doa.doctor_id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer"> AND doa.is_active = 1
		</cfquery>

		<cfset productIdList = valueList(qProducts.id)>

		<cfset productNames = model("DoctorsOnlyQuestion").findAll(
			select="doctorsonlyproducts.name",
			include="DoctorsOnlyProduct",
			where="doctorsonlyquestions.id IN (#ListAppend(productIdList,0)#)"
		)>

		<cfif isnumeric(qDoc.zip)>
			<cfquery datasource="myLocateadocLB" name="qCounty">
				SELECT up.county_tx AS county, us.state_code_tx AS State, up.city_tx AS City
				FROM util_postal up
				INNER JOIN util_states us ON us.state_id = up.state_id
				WHERE up.postal_code_tx = <cfqueryparam value="#REreplace(left(qDoc.zip,5), "\D", "", "all")#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfset thisCounty = qCounty.county>
			<cfset thisState = qCounty.state>
			<cfset thisCity = qCounty.City>
		<cfelse>
			<cfquery datasource="myLocateadocLB" name="qCounty">
				SELECT us.state_code_tx AS State, upc.city AS City
				FROM util_postal_canada upc
				INNER JOIN util_states us ON us.state_id = upc.state_id
				WHERE upc.postal_code = <cfqueryparam value="#REreplace(left(qDoc.zip,5), "\D", "", "all")#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfset thisState = qCounty.state>
			<cfset thisCity = qCounty.City>
		</cfif>

		<cfset campaignIdList = ladCampaignId>
		<cfif ListFind(productIdList, 2)>
			<cfset campaignIdList = ListAppend(campaignIdList,merchantCampaignId)>
		</cfif>


		<cfloop list="#campaignIdList#" index="campaignId">
			<cfif campaignId EQ "7013000000020jp">
				<cfset leadFormSourceExtra = " - B">
			<cfelse>
				<cfset leadFormSourceExtra = "">
			</cfif>

			<cfhttp	url = "http://www.salesforce.com/servlet/servlet.WebToLead?encoding=UTF-8"
					method = "post"
					resolveURL = "yes"
					throwOnError = "yes"
					redirect = "no"
					timeout = "15"
					charset = "UTF-8">
				<cfhttpparam name="oid" type="FormField" value="00D300000000Z6Q"> <!--- Sales force lead ID(type) --->
				<cfhttpparam name="reURL" type="FormField" value="http://www.locateadoc.com/doctors_only/index.cfm"> <!--- Unecessary for our purposes, but here to prevent SalesForce from throwing an error --->
				<cfhttpparam name="00N30000000mDRJ" type="FORMFIELD" value="Doctors Only Addition Form#leadFormSourceExtra#">

				<cfhttpparam name="first_name" type="FormField" value="#qDoc.firstName#">
				<cfhttpparam name="last_name" type="FormField" value="#qDoc.lastName#">
				<cfhttpparam name="email" type="FormField" value="#qDoc.drEmail#">

				<cfhttpparam name="00N30000000kBID" type="FormField" value="#qDoc.contactFirstName# #qDoc.contactLastName#">

				<cfhttpparam name="Campaign_ID" type="FormField" value="#campaignId#">
				<cfhttpparam name="lead_source" type="FormField" value="Web Referral">

				<cfhttpparam name="00N30000000lKfk" type="FormField" value="#qDoc.contactPhone#">
				<cfhttpparam name="00N30000000lKgG" type="FormField" value="#qDoc.ContactEmail#">

				<cfhttpparam name="company" type="FormField" value="#qDoc.company#">
				<cfhttpparam name="street" type="FormField" value="#qDoc.address#">
				<cfhttpparam name="city"  type="FormField" value="#thisCity#">
				<cfhttpparam name="state"  type="FormField" value="#thisState#">
				<cfhttpparam name="zip"  type="FormField" value="#qDoc.zip#">
				<cfhttpparam name="URL"  type="FormField" value="#qDoc.website#">
				<cfhttpparam name='00N60000001HWzt' type="FormField" value="#thisCounty#">
				<cfhttpparam name="phone" type="FormField" value="#qDoc.practicePhone#">
				<cfhttpparam name="00N30000000l2um" type="FormField" value="#qDoc.specialtiesSelected#">
				<cfhttpparam name="00N30000000qhZT" type="FormField" value="#qDoc.specialty_suggested#">

				<cfoutput query="productNames">
					<cfhttpparam name="00N30000000lBg9" type="FormField" value="#productNames.name#">
				</cfoutput>

				<cfhttpparam name="creation_date" type="FormField" value="#qDoc.createdAt#">
				<cfhttpparam name="sfga" type="FormField" value="00D300000000Z6Q">

				<cfhttpparam name="00N30000000r8jZ" type="FormField" value="http://admin.locateadoc.com/admin/LocateADoc/docsearch/doview.cfm?id=#qDoc.id#">
				<cfhttpparam name="00N30000000m93k" type="FormField" value="#arguments.comments#">
			</cfhttp>
		</cfloop>

		<cfquery datasource="myLocateadoc">
			UPDATE doctors_only_doctors
			SET is_sent = 1,
				sentAt = now()
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
		</cfquery>

	</cffunction>

	<cffunction name="salesForceConvertLeadToOpportunity" access="private">
		<cfargument name="accountId" default="">

		<cfset var local.serverURL = "">
		<cfset var local.sessionID = "">
		<cfset var local.xmlResponse = "">
		<cfset var local.leadId = "">
		<cfset var local.ownerId = "">

		<cfset local.salesForce = {}>
		<cfset local.salesForce.subject = "Doctor Marketing SalesForce Lead to Opportunity Error">
		<cfset local.salesForce.validResponse = false>
		<cfset local.salesForce.success = ''>
		<cfset local.salesForce.errorsNil = ''>
		<cfset local.salesForce.leadId = ''>
		<cfset local.salesForce.accountId = ''>
		<cfset local.salesForce.contactId = ''>
		<cfset local.salesForce.opportunityId = ''>
		<cfset local.salesForce.xmlResponse = "">
		<cfset local.salesForce.xmlResponseDoc = "">


		<!--- Retrieve salesforceleadid to convert the lead to an opportunity --->
		<cfquery datasource="myLocateadocLB3" name="qAccount">
			SELECT a.name, dod.salesForceLeadId, dod.id AS doctorsOnlyId
			FROM accounts a
			INNER JOIN doctorsonlypayments dop ON dop.accountId = a.id
			INNER JOIN myLocateadoc.doctors_only_doctors dod ON dod.id = dop.doctorsOnlyid
			WHERE a.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountId#">
		</cfquery>

		<cfif qAccount.salesForceLeadId NEQ "">
			<cfinvoke component="com#Application.SharedModulesSuffix#.patientreferraloffice.salesforce.CreateSession"
					  method="getSessionSOAP"
					  returnVariable="rsfdc">

			<cfset local.serverURL = rsfdc.serverUrl>
			<cfset local.sessionID = rsfdc.sessionId>

			<cfsavecontent variable="local.xmlDoc"><cfoutput><?xml version="1.0" encoding="utf-8"?>
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:enterprise.soap.sforce.com">
			<soapenv:Header>
			<urn:SessionHeader>
			<urn:sessionId>#local.sessionID#</urn:sessionId>
			</urn:SessionHeader>
			</soapenv:Header>
			<soapenv:Body>
			<urn:convertLead>
			<urn:leadConverts>
			<urn:convertedStatus>#xmlFormat("Qualified / Converted")#</urn:convertedStatus>
			<urn:doNotCreateOpportunity>false</urn:doNotCreateOpportunity>
			<urn:leadId>#xmlFormat(qAccount.salesForceLeadId)#</urn:leadId>
			<urn:opportunityName>#xmlFormat(qAccount.name)# - Paid Introductory Listing</urn:opportunityName>
			<urn:overwriteLeadSource>true</urn:overwriteLeadSource>
			<urn:sendNotificationEmail>true</urn:sendNotificationEmail>
			</urn:leadConverts>
			</urn:convertLead>
			</soapenv:Body>
			</soapenv:Envelope></cfoutput></cfsavecontent>


			<p><cfdump var="#xmlParse(trim(local.xmlDoc))#"></p>

			<cfhttp url="#replace(local.serverURL, "7.0", "5.0")#" method="POST" timeout="10">
			 <cfhttpparam type="HEADER" name="Content-Type" value="text/xml; charset=utf-8">
			 <cfhttpparam type="HEADER" name="Accept" value="application/soap+xml, application/dime, multipart/related, text/*">
			 <cfhttpparam type="HEADER" name="User-Agent" value="Axis/1.1">
			 <cfhttpparam type="HEADER" name="Host" value="www.salesforce.com">
			 <cfhttpparam type="HEADER" name="Cache-Control" value="no-cache">
			 <cfhttpparam type="HEADER" name="Pragma" value="no-cache">
			 <!--- Leave SOAPAction blank. --->
			 <cfhttpparam type="HEADER" name="SOAPAction" value="Hello">
			 <cfhttpparam type="HEADER" name="Content-Length" value="#len(trim(local.xmlDoc))#">
			 <cfhttpparam type="BODY" value="#trim(local.xmlDoc)#">
			</cfhttp>

			<cfset local.xmlResponse = trim(CFHTTP.FileContent)>
			<cfset local.xmlResponseDoc = xmlParse(local.xmlResponse)>

			<cfdump var="#local.xmlResponseDoc#">

			<cfset local.salesForce.xmlResponse = local.xmlResponse>
			<cfset local.salesForce.xmlResponseDoc = local.xmlResponseDoc>

			<cfif 	structKeyExists(local.salesForce.xmlResponseDoc, "soapenv:Envelope") AND
					structKeyExists(local.salesForce.xmlResponseDoc['soapenv:Envelope'], "soapenv:Body") AND
					structKeyExists(local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'], "convertLeadResponse") AND
					structKeyExists(local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].convertLeadResponse, "result") AND
					structKeyExists(local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].convertLeadResponse.result, "success")>

				<cfset local.salesForce.success = local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].convertLeadResponse.result.success.XmlText>

				<cfif local.salesForce.success EQ true>
					<cfset local.salesForce.validResponse = true>
					<cfset local.salesForce.accountId = local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].convertLeadResponse.result.accountId.xmlText>
					<cfset local.salesForce.contactId = local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].convertLeadResponse.result.contactId.xmlText>
					<cfset local.salesForce.leadId = local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].convertLeadResponse.result.leadId.xmlText>
					<cfset local.salesForce.opportunityId = local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].convertLeadResponse.result.opportunityId.xmlText>
					<cfset local.salesForce.subject = "Doctor Marketing SalesForce Lead to Opportunity Success">
				</cfif>
			</cfif>

			<cfquery datasource="myLocateadoc">
				UPDATE doctors_only_doctors
				SET <cfif local.salesForce.accountId NEQ "">
						salesForceAccountId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.salesForce.accountId#">,
					</cfif>
					<cfif local.salesForce.contactId NEQ "">
						salesForceContactId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.salesForce.contactId#">,
					</cfif>
					<cfif local.salesForce.opportunityId NEQ "">
						salesForceOpportunityId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.salesForce.opportunityId#">,
					</cfif>
					salesForceConversionAt = now(),
					salesForceLeadToOpportunityResponse = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#local.salesForce.xmlResponse#">,
					forms_completed = 5
				WHERE id = <cfqueryparam value="#qAccount.doctorsOnlyId#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfset docOnlyID = qAccount.doctorsOnlyId>

			<cfquery datasource="myLocateadocEdits" name="qAddSalesForceIdToAccount">
				UPDATE accounts a
				SET salesForceId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.salesForce.accountId#">
				WHERE a.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountId#">
			</cfquery>


		</cfif><!--- salesForceLeadId neq '' --->


		<cfmail from="order@locateadoc.com"
				to="test@locateadoc.com"
				subject="Doctor Marketing Monitoring: #local.salesForce.subject#"
				type="html">
			<p>http://<cfif server.thisServer EQ "dev">alpha1<cfelse>www</cfif>.practicedock.com/admin/accounts/setupwizard.cfm?a=account_tree&type=extended&account_id=#arguments.accountId#</p>

			<cfdump var="#local.salesForce#">
		</cfmail>


	</cffunction>

	<cffunction name="salesForceUpdateOpportunity" access="private">
		<cfargument name="accountId" required="true" type="numeric">

		<cfset var local.serverURL = "">
		<cfset var local.sessionID = "">
		<cfset var local.xmlResponse = "">
		<cfset var local.leadId = "">
		<cfset var local.ownerId = "">


		<cfset var local.salesForce = {}>
		<cfset local.salesForce.requestText = "">
		<cfset local.salesForce.requestObject = "">
		<cfset local.salesForce.subject = "Doctor Marketing SalesForce Update Opportunity URL Error">
		<cfset local.salesForce.validResponse = false>
		<cfset local.salesForce.success = ''>
		<cfset local.salesForce.errorsNil = ''>
		<cfset local.salesForce.contractId = ''>
		<cfset local.salesForce.xmlResponse = "">
		<cfset local.salesForce.xmlResponseDoc = "">


		<!--- Retrieve Purchase information to attach the contract id to --->
		<cfquery datasource="myLocateadocLB3" name="local.qAccount">
			SELECT a.name, dod.salesForceLeadId, dod.salesForceAccountId, dod.salesForceContactId, dod.salesForceOpportunityId, dod.id AS doctorsOnlyId,
				dop.billingAddressCity, dop.billingAddressStateId, dop.billingAddressCountryId,	dop.billingAddressFirstName, dop.billingAddressLastName, dop.billingAddressCompany,
				dop.billingAddressAddress1, dop.billingAddressAddress2, dop.billingAddressZip, dop.billingAddressEmail, dop.billingAddressPhone,
				dop.billingAddressFax, dop.amount, dop.createdAt,
				states.name AS state, states.abbreviation AS stateCode,  countries.name AS country, specialties.name AS specialtyName,
				app.id AS accountPurchasedId, app.amount, app.dateStart
			FROM accounts a
			INNER JOIN doctorsonlypayments dop ON dop.accountId = a.id
			INNER JOIN myLocateadoc.doctors_only_doctors dod ON dod.id = dop.doctorsOnlyid
			LEFT JOIN states ON states.id = dop.billingAddressStateId
			LEFT JOIN countries ON countries.id = dop.billingAddressCountryId
			LEFT JOIN specialties ON specialties.id = dod.specialty_id_1
			LEFT JOIN accountproductspurchased app ON app.accountId = dop.accountId AND app.accountProductId = 12 AND (app.dateEnd >= now() OR app.dateEnd IS NULL) AND app.deletedAt IS NULL
			WHERE a.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountId#">
		</cfquery>


		<cfif local.qAccount.salesForceAccountId NEQ "">
			<cfinvoke component="com#Application.SharedModulesSuffix#.patientreferraloffice.salesforce.CreateSession"
					  method="getSessionSOAP"
					  returnVariable="rsfdc">

			<cfset local.serverURL = rsfdc.serverUrl>
			<cfset local.sessionID = rsfdc.sessionId>

			<cfset local.domain = (server.thisServer EQ 'dev' ? 'alpha1' : 'www')>
			<cfset local.listingURL = "http://#local.domain#.practicedock.com/admin/accounts/setupwizard.cfm?a=account_tree&type=extended&account_id=#arguments.accountId#">


			<!--- Update listing url on the opportunity --->
			<!--- https://na4.salesforce.com/p/setup/layout/LayoutFieldList?type=Opportunity&setupid=OpportunityFields&retURL=%2Fui%2Fsetup%2FSetup%3Fsetupid%3DOpportunity --->
			<cfsavecontent variable="local.salesForce.requestText"><cfoutput><?xml version="1.0" encoding="utf-8"?>
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
			  xmlns:urn="urn:enterprise.soap.sforce.com"
			  xmlns:urn1="urn:sobject.enterprise.soap.sforce.com"
			  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			  <soapenv:Header>
			     <urn:SessionHeader>
			        <urn:sessionId>#xmlFormat(local.sessionID)#</urn:sessionId>
			     </urn:SessionHeader>
			  </soapenv:Header>
			  <soapenv:Body>
			     <urn:update>
			        <urn:sObjects xsi:type="urn1:Opportunity">
			           <urn1:Id>#xmlFormat(local.qAccount.salesForceOpportunityId)#</urn1:Id>
			           <Listing__c>#xmlFormat(local.listingURL)#</Listing__c>
			           <StageName>5</StageName>
			           <CloseDate>#xmlFormat(dateformat(local.qAccount.dateStart, "yyyy-mm-dd"))#</CloseDate>
			           <Probability>100</Probability>
			           <Amount>#xmlFormat(local.qAccount.amount)#</Amount>
			           <Product_Sold__c>#xmlFormat("Introductory Listing")#</Product_Sold__c>
			        </urn:sObjects>
			     </urn:update>
			  </soapenv:Body>
			</soapenv:Envelope></cfoutput></cfsavecontent>
			<!--- 5 - Closed Won	Closed/Won	100%	Closed --->
			<!--- T#xmlFormat(timeformat(local.qAccount.createdAt, "HH:MM:SS.l"))#Z --->

			<p><cfoutput>#local.salesForce.requestText#</cfoutput></p>
			<p><cfdump var="#xmlParse(trim(local.salesForce.requestText))#"></p>

			<cfhttp url="#replace(local.serverURL, "7.0", "5.0")#" method="POST" timeout="10">
			 <cfhttpparam type="HEADER" name="Content-Type" value="text/xml; charset=utf-8">
			 <cfhttpparam type="HEADER" name="Accept" value="application/soap+xml, application/dime, multipart/related, text/*">
			 <cfhttpparam type="HEADER" name="User-Agent" value="Axis/1.1">
			 <cfhttpparam type="HEADER" name="Host" value="www.salesforce.com">
			 <cfhttpparam type="HEADER" name="Cache-Control" value="no-cache">
			 <cfhttpparam type="HEADER" name="Pragma" value="no-cache">
			 <!--- Leave SOAPAction blank. --->
			 <cfhttpparam type="HEADER" name="SOAPAction" value="Hello">
			 <cfhttpparam type="HEADER" name="Content-Length" value="#len(trim(local.salesForce.requestText))#">
			 <cfhttpparam type="BODY" value="#trim(local.salesForce.requestText)#">
			</cfhttp>

			<cfset local.salesForce.xmlResponse = trim(CFHTTP.FileContent)>
			<cfset local.salesForce.xmlResponseDoc = xmlParse(local.salesForce.xmlResponse)>

			<cfoutput><p>#local.salesForce.xmlResponse#</p></cfoutput>
			<cfdump var="#local.salesForce.xmlResponseDoc#">

			<cfif 	structKeyExists(local.salesForce.xmlResponseDoc, "soapenv:Envelope") AND
					structKeyExists(local.salesForce.xmlResponseDoc['soapenv:Envelope'], "soapenv:Body") AND
					structKeyExists(local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'], "updateResponse") AND
					structKeyExists(local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].updateResponse, "result") AND
					structKeyExists(local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].updateResponse.result, "success")>

				<cfset local.salesForce.success = local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].updateResponse.result.success.XmlText>

				<cfif local.salesForce.success EQ true>
					<cfset local.salesForce.validResponse = true>

					<cfset local.salesForce.subject = "Doctor Marketing SalesForce Update Opportunity Listing URL Success">
				</cfif>
			</cfif>
		</cfif><!--- salesForceLeadId neq '' --->


		<cfmail from="order@locateadoc.com"
				to="test@locateadoc.com"
				subject="Doctor Marketing Monitoring: #local.salesForce.subject#"
				type="html">
			<p>http://<cfif server.thisServer EQ "dev">alpha1<cfelse>www</cfif>.practicedock.com/admin/accounts/setupwizard.cfm?a=account_tree&type=extended&account_id=#arguments.accountId#</p>
			<cfdump var="#local.salesForce#">
		</cfmail>


	</cffunction>


	<cffunction name="salesForceCreateContract" access="private">
		<cfargument name="accountId" required="true" type="numeric">

		<cfset var local.serverURL = "">
		<cfset var local.sessionID = "">
		<cfset var local.xmlResponse = "">
		<cfset var local.leadId = "">
		<cfset var local.ownerId = "">


		<cfset var local.salesForce = {}>
		<cfset local.salesForce.subject = "Doctor Marketing SalesForce Create and Link Contract Error">
		<cfset local.salesForce.validResponse = false>
		<cfset local.salesForce.success = ''>
		<cfset local.salesForce.errorsNil = ''>
		<cfset local.salesForce.contractId = ''>
		<cfset local.salesForce.xmlResponse = "">
		<cfset local.salesForce.xmlResponseDoc = "">


		<!--- Retrieve Purchase information to attach the contract id to --->
		<cfquery datasource="myLocateadocLB3" name="local.qAccount">
			SELECT a.name, dod.salesForceLeadId, dod.salesForceAccountId, dod.salesForceContactId, dod.salesForceOpportunityId, dod.id AS doctorsOnlyId,
				dop.billingAddressCity, dop.billingAddressStateId, dop.billingAddressCountryId,	dop.billingAddressFirstName, dop.billingAddressLastName, dop.billingAddressCompany,
				dop.billingAddressAddress1, dop.billingAddressAddress2, dop.billingAddressZip, dop.billingAddressEmail, dop.billingAddressPhone,
				dop.billingAddressFax, dop.amount, dop.createdAt,
				states.name AS state, states.abbreviation AS stateCode,  countries.name AS country, specialties.name AS specialtyName,
				app.id AS accountPurchasedId, app.amount, app.dateStart
			FROM accounts a
			INNER JOIN doctorsonlypayments dop ON dop.accountId = a.id
			INNER JOIN myLocateadoc.doctors_only_doctors dod ON dod.id = dop.doctorsOnlyid
			LEFT JOIN states ON states.id = dop.billingAddressStateId
			LEFT JOIN countries ON countries.id = dop.billingAddressCountryId
			LEFT JOIN specialties ON specialties.id = dod.specialty_id_1
			LEFT JOIN accountproductspurchased app ON app.accountId = dop.accountId AND app.accountProductId = 12 AND (app.dateEnd >= now() OR app.dateEnd IS NULL) AND app.deletedAt IS NULL
			WHERE a.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountId#">
		</cfquery>


		<cfif local.qAccount.salesForceAccountId NEQ "">
			<cfinvoke component="com#Application.SharedModulesSuffix#.patientreferraloffice.salesforce.CreateSession"
					  method="getSessionSOAP"
					  returnVariable="rsfdc">

			<cfset local.serverURL = rsfdc.serverUrl>
			<cfset local.sessionID = rsfdc.sessionId>


			<cfsavecontent variable="local.xmlDoc"><cfoutput><?xml version="1.0" encoding="utf-8"?>
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
			  xmlns:urn="urn:enterprise.soap.sforce.com"
			  xmlns:urn1="urn:sobject.enterprise.soap.sforce.com"
			  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			  <soapenv:Header>
			     <urn:SessionHeader>
			        <urn:sessionId>#xmlFormat(local.sessionID)#</urn:sessionId>
			     </urn:SessionHeader>
			  </soapenv:Header>
			  <soapenv:Body>
			     <urn:create>
				      <urn:sObjects xsi:type="urn1:Contract">
				        <AccountId>#xmlFormat(local.qAccount.salesForceAccountId)#</AccountId>
						<StartDate>#xmlFormat(dateformat(local.qAccount.dateStart, "yyyy-mm-dd"))#T#xmlFormat(timeformat(local.qAccount.dateStart, "HH:MM:SS.l"))#Z</StartDate>
						<Product__c>Introductory Listing</Product__c>
						<ABS_Purchased_ID__c>#local.qAccount.accountPurchasedId#</ABS_Purchased_ID__c>
						<Specialty__c>#xmlFormat(local.qAccount.specialtyName)#</Specialty__c>
						<Contract_Amount__c>#xmlFormat(local.qAccount.amount)#</Contract_Amount__c>
			        </urn:sObjects>
			     </urn:create>
			  </soapenv:Body>
			</soapenv:Envelope>
			</cfoutput></cfsavecontent>


			<p><cfoutput>#local.xmlDoc#</cfoutput></p>
			<p><cfdump var="#xmlParse(trim(local.xmlDoc))#"></p>

			<cfhttp url="#replace(local.serverURL, "7.0", "5.0")#" method="POST" timeout="10">
			 <cfhttpparam type="HEADER" name="Content-Type" value="text/xml; charset=utf-8">
			 <cfhttpparam type="HEADER" name="Accept" value="application/soap+xml, application/dime, multipart/related, text/*">
			 <cfhttpparam type="HEADER" name="User-Agent" value="Axis/1.1">
			 <cfhttpparam type="HEADER" name="Host" value="www.salesforce.com">
			 <cfhttpparam type="HEADER" name="Cache-Control" value="no-cache">
			 <cfhttpparam type="HEADER" name="Pragma" value="no-cache">
			 <cfhttpparam type="HEADER" name="SOAPAction" value="Hello">
			 <cfhttpparam type="HEADER" name="Content-Length" value="#len(trim(local.xmlDoc))#">
			 <cfhttpparam type="BODY" value="#trim(local.xmlDoc)#">
			</cfhttp>

			<cfset local.xmlResponse = trim(CFHTTP.FileContent)>
			<cfset local.xmlResponseDoc = xmlParse(local.xmlResponse)>

			<cfoutput><p>#local.xmlResponse#</p></cfoutput>
			<cfdump var="#local.xmlResponseDoc#">

			<!---	https://developer.salesforce.com/page/Enterprise_Convert_Lead
					https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_calls_convertlead.htm
					https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_opportunity.htm
			 --->

			<cfset local.salesForce.xmlResponse = local.xmlResponse>
			<cfset local.salesForce.xmlResponseDoc = local.xmlResponseDoc>

			<cfif 	structKeyExists(local.salesForce.xmlResponseDoc, "soapenv:Envelope") AND
					structKeyExists(local.salesForce.xmlResponseDoc['soapenv:Envelope'], "soapenv:Body") AND
					structKeyExists(local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'], "createResponse") AND
					structKeyExists(local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].createResponse, "result") AND
					structKeyExists(local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].createResponse.result, "success")>

				<cfset local.salesForce.success = local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].createResponse.result.success.XmlText>

				<cfif local.salesForce.success EQ true>
					<cfset local.salesForce.validResponse = true>
					<cfset local.salesForce.contractId = local.salesForce.xmlResponseDoc['soapenv:Envelope']['soapenv:Body'].createResponse.result.id.xmlText>
					<cfset local.salesForce.subject = "Doctor Marketing SalesForce Opportunity Contract Creation Success">

					<cfif local.salesForce.contractId NEQ "">
						<cfquery datasource="myLocateadocEdits">
							UPDATE accountproductspurchased
							SET contractId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.salesForce.contractId#">
							WHERE id = <cfqueryparam value="#local.qAccount.accountPurchasedId#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>
			</cfif>

		</cfif><!--- salesForceLeadId neq '' --->


		<cfmail from="order@locateadoc.com"
				to="test@locateadoc.com"
				subject="Doctor Marketing Monitoring: #local.salesForce.subject#"
				type="html">
			<p>http://<cfif server.thisServer EQ "dev">alpha1<cfelse>www</cfif>.practicedock.com/admin/accounts/setupwizard.cfm?a=account_tree&type=extended&account_id=#arguments.accountId#</p>
			<cfdump var="#local.salesForce#">
		</cfmail>

	</cffunction>


	<cffunction name="passwordCheck" access="private" returntype="boolean" hint="Check if the password passes my requirements.">
		<cfargument name="password" required="true">
		<!--- https://www.schneier.com/blog/archives/2014/03/choosing_secure_1.html
				"use a meaningless sentence with random punctuation and at least one uncommon typo"
				The 20 Streets I Walk Down are Paved with Gold -> T20S!WDaPwG
				Include at least 1 letter, 1 number and 1 symbol
		--->

		<cfif len(arguments.password) GTE 8 AND reFind("[a-zA-Z]+", arguments.password) AND reFind("[0-9]+", arguments.password) AND reFind("[[:punct:]]", arguments.password)>
			<cfreturn true>
		</cfif>

		<cfreturn false>

	</cffunction>

	<cffunction name="addlistingcheckduplicate" access="public" returntype="void">
		<!--- carlos3.locateadoc.com/doctor-marketing/addlistingcheckduplicate?email=test@locateadoc.com --->
		<cfset data = {}>
		<cfset data.findPDockuser = QueryNew("")>

		<!--- Look for email in LAD Account --->
		<cfset data.checkDuplicateAccounts = model("AccountEmail").findAll(	include	= "accountdoctoremails(accountdoctor(accountdoctorlocations(accountpractice(account))))",
																	where		= "accountemails.email = '#params.email#'",
																	select		= "accounts.id AS accountId, accounts.name AS accountName",
																	GROUP		= "accounts.id")>

		<cfif data.checkDuplicateAccounts.recordCount GT 0>
			<cfset data.findPDockuser = model("Account").GetPDockUsernames(valueList(data.checkDuplicateAccounts.accountId))>
		</cfif>

		<cfif data.findPDockuser.recordCount EQ 0>
			<cfset renderNothing()>
		<cfelse>
			<cfset renderWith(	data					= data,
								hideDebugInformation	= true,
								layout					= false)>
		</cfif>
	</cffunction>

	<cffunction name="getReceipt" access="private" returntype="struct">
		<cfargument name="xmlResponseDoc" required="true" type="xml">

		<cfset local.receipt = {}>
		<cfset local.receipt.transactionId = arguments.xmlResponseDoc.response["transaction-id"].xmlText>
		<cfset local.receipt.subscriptionId = arguments.xmlResponseDoc.response["subscription-id"].xmlText>
		<cfset local.receipt.amount = arguments.xmlResponseDoc.response["amount"].xmlText>
		<cfset local.receipt.ipAddress = arguments.xmlResponseDoc.response["ip-address"].xmlText>
		<cfset local.receipt.currency = arguments.xmlResponseDoc.response["currency"].xmlText>
		<cfset local.receipt.authorizationCode = arguments.xmlResponseDoc.response["authorization-code"].xmlText>
		<cfset local.receipt.customerId = arguments.xmlResponseDoc.response["customer-id"].xmlText>
		<cfset local.receipt.orderDescription = arguments.xmlResponseDoc.response["order-description"].xmlText>

		<cfset local.receipt.plan = {}>
		<cfset local.receipt.plan.dayOfMonth = arguments.xmlResponseDoc.response.plan["day-of-month"].xmlText>

		<cfset local.receipt.billing = {}>
		<cfset local.receipt.billing.firstName = arguments.xmlResponseDoc.response.billing["first-name"].xmlText>
		<cfset local.receipt.billing.lastName = arguments.xmlResponseDoc.response.billing["last-name"].xmlText>
		<cfset local.receipt.billing.address1 = arguments.xmlResponseDoc.response.billing["address1"].xmlText>
		<cfset local.receipt.billing.city = arguments.xmlResponseDoc.response.billing["city"].xmlText>
		<cfset local.receipt.billing.state = arguments.xmlResponseDoc.response.billing["state"].xmlText>
		<cfset local.receipt.billing.postal = arguments.xmlResponseDoc.response.billing["postal"].xmlText>
		<cfset local.receipt.billing.country = arguments.xmlResponseDoc.response.billing["country"].xmlText>
		<cfset local.receipt.billing.phone = arguments.xmlResponseDoc.response.billing["phone"].xmlText>
		<cfset local.receipt.billing.email = arguments.xmlResponseDoc.response.billing["email"].xmlText>
		<cfset local.receipt.billing.company = arguments.xmlResponseDoc.response.billing["company"].xmlText>
		<cfset local.receipt.billing.ccNumber = arguments.xmlResponseDoc.response.billing["cc-number"].xmlText>
		<cfset local.receipt.billing.ccExp = arguments.xmlResponseDoc.response.billing["cc-exp"].xmlText>

		<cfreturn local.receipt>
	</cffunction>


	<cffunction name="paymentTest" access="public">
		<!---
			http://carlos3.locateadoc.com/doctor-marketing/payment-test
			Step One: Submit all transaction details to the Payment Gateway except the customer's sensitive payment information. The Payment Gateway will return a variable form-url.

			To start step one, your payment application will submit a behind-the-scenes HTTPS direct POST that includes transaction variables, including an additional variable redirect-url, which is a URL that must exist on your web server that handles a future browser redirect.
			Sensitive payment information such as cc-number, cc-exp, and cvv cannot be submitted during step one.
			The Payment Gateway will generate and return the form-url variable containing a unique URL to be used in Step 2. --->

		<cfset params.doctorsOnlyId = 18013>


		<cfset states = model("State").findAll( 	where	= "countryId IN (12,48,102)",
													select	= "id, name",
													order	= "name")>
		<cfset countries = model("Country").findAll(	where	= "id IN (12,48,102)",
														select	= "id, name",
														order	= "name")>

		<!--- <cfset salesForceConvertLeadToOpportunity(352425)> --->
		<!--- <cfset salesForceCreateContract(352427)> --->
		<cfset salesForceUpdateOpportunity(352431)>
		<cfabort>

	</cffunction>


	<cffunction name="recordHit" access="private">
		<cfset var local.keylist = "">

		<cfif not Client.IsSpider>

		<cfparam name="params.country"			default="">
		<cfparam name="params.state"			default="">
		<cfparam name="params.city"				default="">
		<cfparam name="params.zip"				default="">
		<cfparam name="params.procedureID"		default="">
		<cfparam name="params.specialtyID"		default="">
		<cfparam name="docOnlyID"	default="">
		<cfparam name="params.page"				default="">
		<cfparam name="params.articlesilo" default="">


		<cfset params.country = val(params.country)>
		<cfset params.state = val(params.state)>
		<cfset params.city = val(params.city)>
		<cfset params.procedureID = val(params.procedureID)>
		<cfset params.specialtyID = val(params.specialtyID)>

			<cfset local.keylist = REReplace(LCase(CGI.PATH_INFO),'/?(#LCase(params.controller)#|#LCase(params.action)#)/?','','all')>

			<cfif params.country neq "" and val(params.country) eq 0>
				<cfset countryID = model("Country").findAll(select="id",where="abbreviation='#params.country#'")>
				<cfset params.country = countryID.id>
			</cfif>
			<cfif not isNumeric(params.country)>
				<cfset params.country = "">
			</cfif>

			<cfset model("HitsDoctorMarketing").RecordHit(
										thisAction		= params.action,
										thisController	= params.controller,
										keylist			= local.keylist,
										specialtyId		= params.specialtyID,
										procedureId		= params.procedureID,
										postalCode		= params.zip,
										stateId			= params.state,
										cityId			= params.city,
										countryId		= params.country,
										doctorsOnlyId	= docOnlyID,
										pageId			= params.page,
										articlesilo		= params.articlesilo)>
		</cfif>
	</cffunction>

</cfcomponent>