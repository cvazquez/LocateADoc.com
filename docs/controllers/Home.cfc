<cfcomponent extends="Controller" output="false">
<!--- Global vars --->
<cfset baseURL = "http://#Globals.domain#">
<cfset galleryImageBase	= "#baseURL#/images/gallery/thumb">
<cfset rgxEmail ="([-a-zA-Z0-9_.+!]+@[-a-zA-Z0-9_.]+)">

<!--- Controller functions --->
<!---
	When looking to add a new controller for a page, you may need to look in /views/layout.cfm at the
	cfswitch labeled "HOME CONTROLLER ACTION-SPECIFIC CONTENT ENCAPSULATION/STYLING"
 --->

<cffunction name="init">
	<cfset usesLayout("checkPrint")>
</cffunction>

<cffunction name="index">

	<cfset welcomeContent = model("SpecialContent").findAll(
				select="title, header, content, metaKeywords, metaDescription",
				where="id = 17"
			)>

	<!--- <cfset title = "Find a Doctor"> --->
	<cfset title = welcomeContent.title>
	<cfset metaDescriptionContent = welcomeContent.metaDescription>
	<cfset pageTitle = welcomeContent.header>

	<!--- Strip keyword from URL --->
	<cfif Find("keyword",Request.currentURL) gt 0>
		<cflocation url="http://#CGI.SERVER_NAME#" addtoken="no" statuscode="301">
	</cfif>

	<cfset Procedures = getProcedures()>
	<cfset Specialties = getSpecialties()>

	<cfquery name="Blogs" datasource="wordpress">
		SELECT p.ID, p.post_date, p.post_content, p.post_title, p.post_date as createdAt,
		p.siloName
		FROM lad_posts p
		WHERE p.post_type = 'post' AND p.post_status = 'publish'
			AND p.post_date < now() AND p.post_author <> 13
		ORDER BY p.post_date desc
		LIMIT 4
	</cfquery>

	<cfset topPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,censored=true)>
	<cfset featuredResources = model("ResourceGuide").featuredResources(limit=12)>
	<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=8)>

	<cfif isDefined("client.city") and isDefined("client.state") and client.city gt 0 and client.state gt 0>
		<cfset cityInfo			= model("Cities").findAll(select="name",where="id=#client.city#")>
		<cfset stateInfo		= model("State").findAll(select="abbreviation",where="id=#client.state#")>
		<cfset locationSilo 	= "/location-#LCase(Replace(CityInfo.name," ","_","all")&'-'&StateInfo.abbreviation)#">
	<cfelse>
		<cfset locationSilo 	= "">
	</cfif>
	<cfset videoCarousel = model("Video").getVideoSearch(limit=8)>

	<!--- <cfset welcomeContent = model("SpecialContent").findAll(
				select="title, header, content",
				where="name = 'Home Page Welcome'"
			)> --->

	<cfset popularGuidesContent = model("SpecialContent").findAll(
				select="title, header, content",
				where="name = 'Home Page Popular Guides'"
			)>

	<cfset mostPopularArticlesContent = model("SpecialContent").findAll(
				select="title, header, content",
				where="name = 'Home Page Most Popular Articles'"
			)>

	<!--- Render mobile page --->
	<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
		<cfset latestPictures = topPictures>
		<cfset displayCasesDoctorName = TRUE>
		<cfset renderPage(template="index_mobile", layout="/layout_mobile")>
	</cfif>

</cffunction>

<cffunction name="advanced">
	<cfset title = "Home">
	<cfparam name="params.location" default="">
	<cfset Procedures = getProcedures()>
	<cfset ProcedureAlphas = getProcedures(true)>
	<cfset Specialties = getSpecialties()>
	<cfset SpecialtyAlphas = getSpecialties(true)>
	<cfset topPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,censored=true)>
</cffunction>

<cffunction name="about">
	<cfset title = "About Us">

	<cfset advisoryBoardContent = model("SpecialContent").findAll(
		select="title, header, content",
		where="name = 'Advisory Board'"
	)>

	<!--- Render mobile page --->
	<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
		<cfset renderPage(layout="/layout_mobile")>
	</cfif>
</cffunction>

<cffunction name="feedback">
	<cfset var i = 0>
	<cfset var astcSections = ArrayNew(1)>
	<cfset var strSection = "">
	<cfset var strMsg = "">

	<cfset title = "Leave Feedback">

	<cfparam name="form.processing" default="0">
	<cfparam name="form.name" default="">
	<cfparam name="form.phone" default="">
	<cfparam name="form.email" default="">
	<cfparam name="url.query" default="">
	<cfparam name="form.query" default="#url.query#">
	<cfparam name="form.feedback" default="">
	<cfparam name="form.contactType" default="">
	<cfparam name="form.url_addr" default="#CGI.HTTP_REFERER#">
	<cfparam name="form.url_section" default="">


	<cfif form.query NEQ "">
		<cfset textAreaLeadIn = "Please tell us what specific information you were seeking. Also tell us why " &
				"you were dissatisfied with the search results."
		>
	<cfelseif form.contactType EQ "articles">
		<cfset textAreaLeadIn = "Please tell us why you were dissatisfied with the information you found, or " &
				"submit your article idea in the space provided bellow. If you have a personal " &
				"experience that you would like to share on this site, please submit a brief note " &
				"about it with your email address and we will attempt to contact you as time permits."
		>
	<cfelse>
		<cfset textAreaLeadIn = "* Please write your feedback, question, or issue here:">
	</cfif>

	<cfset strMsg = "">
	<cfset successMsg = "">
	<cfset errorMsg = "">
	<cfset formPrompt = "">


	<!--- START: FEEDBACK FORM PROCESSING --->
	<cfif form.processing EQ 1>
		<!--- Pre-trim form items --->
		<cfloop collection="#form#" item="key">
			<cfset form[key] = trim(form[key])>
		</cfloop>

		<cfif form.name EQ "">
			<cfset strMsg &= "<li>Your name is required.</li>">
		</cfif>

		<cfif form.phone EQ "">
			<cfset strMsg &= "<li>Your phone number is required.</li>">
		</cfif>

		<cfif form.contactType EQ "">
			<cfset strMsg &= "<li>Please specify what type of feedback you're giving us.</li>">
		</cfif>

		<cfif form.feedback EQ "">
			<cfset strMsg &= "<li>Please write your feedback in the large text area below.</li>">
		</cfif>


		<!--- START: PROCESS FORM IF NO ERRORS WERE DETECTED --->
		<cfif strMsg EQ "">
			<!--- START: ATTEMPT TO COMMIT TO DB AND SALESFORCE IF FILTERING(?) CONDITIONS ARE MET --->
			<cfif	form.feedback DOES NOT CONTAIN "href"
					AND form.feedback DOES NOT CONTAIN "http"
					AND CGI.REMOTE_ADDR IS NOT "207.150.184.62"
					AND form.remote IS NOT "207.150.184.62"
			>
				<cfquery datasource="myLocateadoc">
					INSERT INTO			feedback
					(
						search_request,
						feedback,
						doctor_sought,
						name,
						phone,
						email,
						db_created_dt,
						remote_addr,
						http_referer,
						contact_type
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.search_request#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.feedback#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.doctor_sought#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
						now(),
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.remote#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.url_addr#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contactType#">
					);
				</cfquery>



				<!--- Set Salesforce section constants --->
				<cfscript>
					astcSections[1] = StructNew();
					astcSections[1].url_section = 1;
					astcSections[1].url_addr = 'directory';
					astcSections[1].section = 'Directory';


					astcSections[2] = StructNew();
					astcSections[2].url_section = 2;
					astcSections[2].url_addr = 'articles';
					astcSections[2].section = 'Articles';


					astcSections[3] = StructNew();
					astcSections[3].url_section = 3;
					astcSections[3].url_addr = 'questions';
					astcSections[3].section = 'Q&A';


					astcSections[4] = StructNew();
					astcSections[4].url_section = 4;
					astcSections[4].url_addr = 'gallery';
					astcSections[4].section = 'Before & After Gallery';


					astcSections[5] = StructNew();
					astcSections[5].url_section = 5;
					astcSections[5].url_addr = 'folio';
					astcSections[5].section = 'Folio Page';


					astcSections[6] = StructNew();
					astcSections[6].url_section = 6;
					astcSections[6].url_addr = 'index';
					astcSections[6].section = 'Doctors Only';


					astcSections[7] = StructNew();
					astcSections[7].url_section = 7;
					astcSections[7].url_addr = 'surgery-guide';
					astcSections[7].section = 'Surgery Guide';
				</cfscript>



				<!--- Determine section value to pass to SalesForce --->
				<cfloop from="1" to="#ArrayLen(astcSections)#" index="i">
					<cfif	form.url_section EQ astcSections[i].url_section
							OR find(astcSections[i].url_addr, form.url_addr)
					>
						<cfset strSection = astcSections[i].section>
						<cfbreak>
					</cfif>
				</cfloop>


				<cfif strSection EQ "">
					<cfset strSection = 'Other'>
				</cfif>


				<!--- START: SEND LEAD TO SALESFORCE CRM --->
				<cftry>
					<cfhttp
							url = "http://www.salesforce.com/servlet/servlet.WebToCase?encoding=UTF-8"
							method = "post"
							resolveURL = "yes"
							throwOnError = "yes"
							redirect = "no"
							timeout = "15"
							charset = "UTF-8"
					>

						<cfhttpparam name="orgid" type="FormField" value="00D300000000Z6Q"> <!--- Sales force Case ID(type) --->
						<cfhttpparam name="reURL" type="FormField" value="http://"> <!--- Unnecessary for our purposes, but here to prevent SalesForce from throwing an error --->
						<!--- FORM FIELDS--->
						<cfhttpparam name="external" type="FormField" value="1">
						<cfhttpparam name="name" type="FormField" value="#form.name#">
						<cfhttpparam name="phone" type="FormField" value="#form.phone#">
						<cfhttpparam name="email" type="FormField" value="#form.email#">
						<cfhttpparam name="priority" type="FormField" value="Low">
						<cfhttpparam name="00N300000014XAB" type="FormField" value="#strSection#">
						<cfhttpparam name="type" type="FormField" value="LAD">
						<cfhttpparam name="subject" type="FormField" value="LAD Feedback">
						<cfhttpparam name="Company" type="FormField" value="company">
						<cfhttpparam name="00N300000012J3q" type="FormField" value="#form.contactType#">
						<cfhttpparam name="00N300000012J4e" type="FormField" value="#form.doctor_sought#">
						<cfhttpparam name="recordType" type="FormField" value="01230000000DF7g">
						<cfhttpparam name="00N300000012J5N" type="FormField" value="#Now()#">
						<cfhttpparam name="00N3000000145Hj" type="FormField" value="#form.url_addr#">
						<cfhttpparam name="description" type="FormField" value="#form.feedback#">
					</cfhttp>


					<cfcatch type="Any">
						<cfmail
								from="feedback_error@locateadoc.com"
								to="feedback_error@locateadoc.com"
								subject="Feedback Sales Force lead generation error"
								type="HTML"
						>
								<p><cfdump var="#cfcatch#" label="cfcatch"></p>
								<p><cfdump var="#form#" label="form"></p>
						</cfmail>
					</cfcatch>
				</cftry>
			</cfif>
			<!--- END: ATTEMPT TO COMMIT TO DB AND SALESFORCE IF FILTERING(?) CONDITIONS ARE MET --->


			<cfsavecontent variable="strMsg">
			  <cfoutput>
				<h2>Thank You.</h2>
				<p>
					We will use your responses to help us in our ongoing efforts to improve the quality of
					our website. While we do not send responses to information submitted using this form,
					you can find more information, including our user support email addresses
					<a href="http://www.locateadoc.com/Site_Tools/Help.cfm">here</a>
				</p>

				<ul>
					<li>
						Return to the #linkTo(controller="doctors", action="index", text="find a doctor directory")#.
					</li>
					<li>
						Return to the <a href="/">LocateADoc.com home page.</a>
					</li>
				</ul>
			  </cfoutput>
			</cfsavecontent>
			<cfset successMsg = strMsg>
		<!--- END: PROCESS FORM IF NO ERRORS WERE DETECTED --->
		<!--- START: REPORT ERRORS DETECTED WITH USER INPUT --->
		<cfelse>
			<cfset errorMsg = "<ul>#strMsg#</ul>">
		</cfif>
		<!--- START: REPORT ERRORS DETECTED WITH USER INPUT --->
	<!--- END: FEEDBACK FORM PROCESSING --->
	<cfelse>
		<cfif form.query NEQ "">
			<cfset formPrompt = "You searched for <b>#params.query#</b>.">
		</cfif>
	</cfif>

	<!--- Render mobile page --->
	<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
		<cfset renderPage(layout="/layout_mobile")>
	</cfif>
</cffunction>

<cffunction name="privacy">
	<cfset title = "Privacy Notice">

	<!--- Render mobile page --->
	<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
		<cfset renderPage(layout="/layout_mobile")>
	</cfif>
</cffunction>

<cffunction name="terms">
	<cfset title = "Conditions of Use">

	<!--- Render mobile page --->
	<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
		<cfset renderPage(layout="/layout_mobile")>
	</cfif>
</cffunction>

<cffunction name="unsubscribe">
	<cfset var strMsg = "">
	<cfset var lstrUnsubscribeFrom = "">
	<cfset blnUnsubSuccess = false><!--- Do not "var" this; it is needed in the view. --->
	<!---
		Unsubscribe type 1 is supposed to be an automatic unsubscribe, while other types require the
		user to identify their email address.  Sometimes Type 1 is used with insufficient or erroneous
		data, so we have to make sure it actually worked and default to the default behavior if it
		didn't.
	--->
	<cfparam name="URL.unsub_type" default="0">
	<cfparam name="URL.email" default="">
	<cfparam name="URL.id" default="0">

	<cfparam name="Form.processing" default="0">
	<cfparam name="Form.unsub_type" default="#URL.unsub_type#">
	<cfparam name="Form.email" default="#URL.email#">
	<cfparam name="Form.id" default="#URL.id#">
	<cfparam name="Form.table_id" default="">

	<cfset successMsg = "">
	<cfset errorMsg = "">

	<cfset title = "Unsubscribe From Newsletters">


	<!--- START: FOLIO ID BASED UNSUBSCRIPTION --->
	<cfif URL.unsub_type EQ 1 AND IsNumeric(Form.id)>
	  <cftry>
		<cfquery name="qryIdCheck" datasource="myLocateadocLB">
			SELECT				count(1) as valid
			FROM				folio
			WHERE				folio_id = <cfqueryparam cfsqltype="integer" value="#Form.id#">
		</cfquery>

		<cfif qryIdCheck.valid GT 0>
			<cfquery datasource="#Application.dsn#">
				UPDATE				folio
				SET					contact_followup_unsubscribe = 1
				WHERE				folio_id = <cfqueryparam cfsqltype="integer" value="#Form.id#">
			</cfquery>


			<cfsavecontent variable="strMsg">
			  <cfoutput>
				<p>
					Your email address, <i>#email#</i>, will no longer receive any follow up emails
					concerning this doctor.
				</p>
				<p>
					Thank you.
				</p>
			  </cfoutput>
			</cfsavecontent>


			<cfset successMsg = strMsg>


			<!--- Note that the user was successfully unsubscribed, so the rest of the page won't load --->
			<cfset blnUnsubSuccess = true>
		</cfif>



		<cfcatch type="any">
			<cfif get("environment") NEQ "production">
				<cfdump label="Form" var="#Form#" expand="no">
				<br clear="all" />

				<cfdump label="Error Detail" var="#cfcatch#" expand="yes">
				<br clear="all" />
				<cfabort>
			</cfif>


			<cfset blnUnsubSuccess = false>
		</cfcatch>
	  </cftry>
	</cfif>
	<!--- END: FOLIO ID BASED UNSUBSCRIPTION --->




	<!--- START: MANUAL EMAIL UNSUBSCRIPTION --->
	<cfif Form.processing EQ 1 AND blnUnsubSuccess EQ false>
		<!--- Error trapping --->
		<cfset strMsg = "">


		<!--- Pre-trim Form elements --->
		<cfloop collection="#form#" item="key">
			<cfset form[key] = trim(form[key])>
		</cfloop>


		<cfscript>
			if(Form.email EQ "")
			{
				strMsg &= "<li>You must provide an email address.</li>";
			}
			else if(REFindNoCase(rgxEmail, Form.email) EQ 0)
			{
				strMsg &= "<li>The Email Address you entered, <i>#Form.email#</i>, to unsubscribe " &
						"is invalid. Please make any corrections. Thank you.</li>";
			}


			if(Form.table_id EQ "")
			{
				strMsg &= "<li>You must select at least one newsletter to opt out of.</li>";
			}
		</cfscript>


		<!--- If errors occurred, set the error message and exit function --->
		<cfif strMsg NEQ "">
			<cfset strMsg = "There were some problems with your input:<ul>#strMsg#</ul>">
			<cfset errorMsg = strMsg>


		<!--- START: MANUAL UNSUBSCRIPTION PROCESSING --->
		<cfelse>
			<cfset strMsg = "">

			<cfif listContains(Form.table_id,"21")>
				<cfset model("NewsletterBeautifulLiving").deleteAll(
					where = "email = '#Form.email#'"
				)>
			</cfif>

			<!--- Get the table details for any table that this user's email might be subscribed
			to, which will be used to build dynamic unsubscribe queries later. --->
			<cfquery name="qryTables" datasource="myLocateadocLB">
				SELECT				table_id, table_name, name, is_newsletter, email_field, dsn
				FROM				newsletter_email_tables
				WHERE				is_active = 1
				AND					is_newsletter = 1

				<!--- If the user didn't select "All" we're looking for specific tables. --->
				<cfif left(Form.table_id, 3) NEQ "all">
					AND					table_id IN(#Form.table_id#)
				</cfif>
			</cfquery>



			<!--- START: FIND AND UNSUBSCRIBE THE USER'S EMAIL ADDRESS --->
			<cfloop query="qryTables">
				<cfif NOT ListFind("[specialty.tablename],[LAD.PRO.Users],pro_users", qryTables.table_name, ",")>
					<cfquery name="qryEmailRecords" datasource="#qryTables.dsn#">
						SELECT				count(1) as 'found'
						FROM				#table_name#
						WHERE				#email_field# = '#Form.email#'
					</cfquery>



					<cfquery datasource="myLocateadoc">
						UPDATE				#table_name#
						SET					noEmail = 1

						<cfif is_newsletter EQ 1>
											, is_active = 0,
											date_unsubscribed = now()
						</cfif>

						WHERE #email_field# = '#Form.email#'
					</cfquery>



					<cfif qryEmailRecords.found GT 0>
						<cfset lstrUnsubscribeFrom &= "<li>#qryTables.name[CurrentRow]#</li>">
					</cfif>
				</cfif>
			</cfloop>
			<!--- END: FIND AND UNSUBSCRIBE THE USER'S EMAIL ADDRESS --->



			<!--- START: NOTIFY USER OF UNSUBSCRIPTION --->
			<cfif lstrUnsubscribeFrom NEQ "">
				<cfset lstrUnsubscribeFrom = "<ul>#lstrUnsubscribeFrom#</ul>">

				<cfset strMsg = "<p><b>Your email address, <i>#Form.email#</i>, has been removed " &
						"from the following Mailing Lists:#lstrUnsubscribeFrom#</b>" &
						"</p>">

				<cfset strMsg &= "<p><b>Thank you for using locateadoc.com.</b></p>">

				<cfset successMsg = strMsg>



				<cfmail	from="newsletters@locateadoc.com"
						to="#trim(Form.email)#"
						subject="LocateADoc.com: You have been Unsubscribed"
						type="html"
				>
					<p>
						This email is to confirm your removal from the following LocateADoc.com
						newsletters: #lstrUnsubscribeFrom#
					</p>

					<p>
						If you would like to subscribe again to our other newsletters,
						please visit here:

					<cfif Form.email contains "@aol.com">
						<a href="http://www.locateadoc.com/Newsletters/">
					</cfif>
							http://www.locateadoc.com/Newsletters/
					<cfif Form.email contains "@aol.com">
						</a>
					</cfif>
					</p>

					<p>
						Thank You,<br />
						LocateADoc.com Team
					</p>
				</cfmail>
			<!--- END: NOTIFY USER OF UNSUBSCRIPTION --->

			<!--- START: NOTIFY USER OF FAILURE TO FIND THEIR EMAIL ADDRESS --->
			<cfelse>
				<cfset strMsg = "<p>We could not find your email address <i>#Form.email#</i>. " &
						"Please make sure it is spelled correctly or you are not subscribed " &
						"under a different email address.</p>">
				<cfset errorMsg = strMsg>
			</cfif>
			<!--- END: NOTIFY USER OF FAILURE TO FIND THEIR EMAIL ADDRESS --->
		</cfif>
		<!--- END: MANUAL UNSUBSCRIPTION PROCESSING --->
	</cfif>
	<!--- END: MANUAL EMAIL UNSUBSCRIPTION --->

	<!--- Render mobile page --->
	<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
		<cfset renderPage(layout="/layout_mobile")>
	</cfif>
</cffunction>

<cffunction name="doctorReviews">
	<cfset title = "Find Doctor Reviews">
	<cfset metaDescriptionContent = "Doctor reviews and patient ratings to help you make healthy decisions, available on LocateADoc.com.">

	<cfset ProcedureList = model("AccountDoctorLocationRecommendation").getProceduresWithComments()>

	<!--- Render mobile page --->
	<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
		<cfset renderPage(layout="/layout_mobile")>
	</cfif>
</cffunction>

<!--- Common queries --->

<cffunction name="checkPrint">
	<cfif structKeyExists(params, "print-view")>
		<cfreturn "/print">
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>

<cffunction name="getProcedures" access="private">
	<cfargument name="alphasOnly" type="boolean" required="false" default="false">

	<cfif alphasOnly>
		<cfset Local.procedures = model("Procedure").findAll(
			select="distinct left(name,1) as letter",
			where="lettercompare >= 0 AND isPrimary = 1",
			order="name asc"
		)>
	<cfelse>
		<cfset Local.procedures = model("Procedure").findAll(
			select="procedures.id, procedures.name",
			where="isPrimary = 1",
			order="name asc"
		)>
	</cfif>
	<cfreturn Local.procedures>
</cffunction>

<cffunction name="getSpecialties" access="private">
	<cfargument name="alphasOnly" type="boolean" required="false" default="false">

	<cfif alphasOnly>
		<cfset Local.specialties = model("Specialty").findAll(
			select="distinct left(name,1) as letter",
			where="lettercompare >= 0 AND categoryId = 1",
			order="name asc"
		)>
	<cfelse>
		<cfset Local.specialties = model("Specialty").findAll(
			select="specialties.id, specialties.name",
			where="categoryId = 1",
			order="name asc"
		)>
	</cfif>
	<cfreturn Local.specialties>
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