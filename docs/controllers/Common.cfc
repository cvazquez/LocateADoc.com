<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
	    <cfset provides("html,json")>
	</cffunction>

	<cffunction name="subscribeNewsletter">
		<cfargument default="TRUE" name="render" required="false" type="boolean">

		<cfsetting showdebugoutput="false">

		<cfif arguments.render>
			<cfset provides("html,json")>
		</cfif>

		<cfparam name="params.email" default="">
		<cfparam name="params.procedure" default="">
		<cfset results = {}>

		<!--- Filter the email --->
		<cfset params.email = trim(params.email)>
		<cfset params.procedure = val(params.procedure) gt 0 ? val(params.procedure) : "">
		<cfif params.email eq "">
			<cfset results["result"] = "blank">
		<cfelse>
			<cfif not isEmail(params.email)>
				<!--- If the email was improperly formatted, return invalid response --->
				<cfset results["result"] = "invalid">
			<cfelse>
				<!--- Check to see if this user already signed up for the newsletter --->
				<cfset newsletterCheck = model("NewsletterBeautifulLiving").findAll(where="email = '#params.email#'",includeSoftDeletes=true)>
				<cfif newsletterCheck.recordcount eq 0>
					<!--- If they haven't, add them to the table --->
					<cfset newNewsletter = model("NewsletterBeautifulLiving").create(email = params.email)>
					<cfset results["result"] = "success">
				<cfelse>
					<cfif newsletterCheck.deletedAt eq "">
						<cfset results["result"] = "duplicate">
					<cfelse>
						<cfset updateNewsletter = model("NewsletterBeautifulLiving").updateByKey(
							key = newsletterCheck.id,
							deletedAt = "null",
							validate = false,
							includeSoftDeletes=true
						)>
						<cfset results["result"] = "success">
					</cfif>
				</cfif>
			</cfif>
		</cfif>

		<cfif arguments.render>
			<cfset renderWith(results)>
		</cfif>
	</cffunction>

	<!--- Site wide mini lead lightbox content --->

	<cffunction name="contactadoctor">
		<cfargument name="isModule" default="false">
		<cfargument name="paramstruct" default="">
		<cfargument name="processing" default="">
		<cfsetting showdebugoutput="false">
		<cfset Request.overrideDebug = "false">
		<cfparam name="params.specialty" default="0">
		<cfparam name="params.procedure" default="0">
		<cfparam name="params.name" default="">
		<cfparam name="params.email" default="">
		<cfparam name="params.zip" default="">
		<cfparam name="params.phone" default="">
		<cfparam name="params.doctors" default="">
		<cfparam name="params.SWID" default="">
		<cfparam name="params.newsletter" default="">
		<cfparam name="params.processing" default="false">
		<cfparam name="params.comments" default="">
		<cfparam name="params.position" default="0">

		<cfset var Local = {}>
		<cfset Local.featuredListingIds = "">
		<cfset local.excludeFeaturedListingIds = "">

		<cfif Arguments.isModule>
			<cfset structAppend(params,Arguments.paramstruct,true)>
			<cfif Arguments.processing neq "">
				<cfset params.processing = Arguments.processing>
			</cfif>
		</cfif>
		<cfset invalidCriteria = "">

		<!--- Filtering and validation --->
		<cfset params.specialty = val(params.specialty)>
		<cfset params.procedure = val(params.procedure)>
		<cfif params.specialty eq 0 and params.procedure eq 0>
			<cfset invalidCriteria = ListAppend(invalidCriteria,"specialty")>
			<cfset invalidCriteria = ListAppend(invalidCriteria,"procedure")>
			<cfset invalidCriteria = ListAppend(invalidCriteria,"specialtyprocedure")>
		<cfelseif params.specialty eq 0>
			<!--- Get specialty ID if only procedure defined --->
			<!--- <cfset getSpecialty = model("SpecialtyProcedure").findAll(
				select="specialtyId",
				where="procedureId = #params.procedure#"
			)>
			<cfset params.specialty = getSpecialty.specialtyId> --->
		</cfif>
		<cfif trim(params.name) eq "">
			<cfset invalidCriteria = ListAppend(invalidCriteria,"name")>
		<cfelse>
			<cfset firstname = trim(ListFirst(params.name, " "))>
			<cfset lastname = trim(listRest(params.name, " "))>
			<cfif firstname eq "" or lastname eq "">
				<cfset invalidCriteria = ListAppend(invalidCriteria,"name")>
			</cfif>
		</cfif>
		<cfif not isEmail(params.email)><cfset invalidCriteria = ListAppend(invalidCriteria,"email")></cfif>
		<cfif trim(params.zip) eq "">
			<cfset invalidCriteria = ListAppend(invalidCriteria,"zip")>
		<cfelse>
			<cfset userLocation = ParseLocation(params.zip)>
			<cfif userLocation.city eq "" or userLocation.state eq "" or userLocation.zipFound eq false>
				<cfset invalidCriteria = ListAppend(invalidCriteria,"zip")>
			</cfif>
		</cfif>
		<cfif REFind("^[0-9() ext\.+-]{10,}$",params.phone) eq 0
				OR Len(REReplace(params.phone,"[^0-9]","","all")) lt 10
				OR Len(params.phone) GT 20>
			<cfset invalidCriteria = ListAppend(invalidCriteria,"phone")>
		</cfif>
		<cfif params.doctors neq REReplace(params.doctors,"[^0-9,]","")>
			<cfset params.doctors = "">
		</cfif>
		<cfif params.SWID neq REReplace(params.SWID,"[^0-9]","")>
			<cfset params.SWID = "">
			<cfset params.processing = false>
		</cfif>
		<cfset params.comments = REReplace(params.comments,"[<>]","")>
		<cfif ListFind("7,8,9,10,11",params.position) eq 0>
			<cfset invalidCriteria = ListAppend(invalidCriteria,"position")>
		</cfif>

		<cfif invalidCriteria eq "">
			<cfif params.processing>

				<!--- Remove leads that were unchecked --->
				<cfset model("ProfileMiniLead").refreshSiteWideMini(
					listingIds = params.doctors,
					FolioMiniLeadSiteWideId = params.SWID
				)>

				<!--- Record leads into real mini lead table --->
				<cfset model("ProfileMiniLead").submitSiteWideMini(
					listingIds = params.doctors,
					firstname = firstname,
					lastname = lastname,
					email = trim(params.email),
					postalCode = trim(params.zip),
					specialtyId = params.specialty,
					procedureId = params.procedure,
					FolioMiniLeadSiteWideId = params.SWID,
					comments = params.comments
				)>

				<!--- If user unchecked newsletter subscription, unsubscribe the user --->
				<cfif val(params.newsletter) eq 0 AND params.newsletter NEQ "checked">
					<!--- Subscribe user to newsletter --->
					<cfset model("NewsletterBeautifulLiving").LAD2Unsubscribe(email = trim(params.email))>
				</cfif>

				<cfif isModule>
					<cfreturn true>
				<cfelse>
					<cfset renderPage(layout=false)>
				</cfif>

			<cfelse>
				<!--- Save user info --->
				<cfset Request.oUser.saveUserInfo(params)>

				<!--- Attempt 1: Get featured listings from zip location zone --->
				<cfset featuredListings = model("AccountDoctorLocation").GetFeatured(
					info = "featured",
					city = userLocation.city,
					state = userLocation.state,
					country = userLocation.country,
					specialtyID = params.specialty,
					procedureID = params.procedure,
					latitude = userLocation.latitude,
					longitude =	userLocation.longitude,
					limit =	30,
					overrideClient = true
				)>
				<cfset local.featuredListingIds = ValueList(featuredListings.id)>
				<cfset searchType = "Advertiser">
 				<cfif featuredListings.recordcount eq 0>
					<!--- Attempt 2: Get featured listings within state and 50 miles --->
					<cfset featuredListings = model("AccountDoctorLocation").GetFeatured(
						info = "featured",
						state = userLocation.state,
						country = userLocation.country,
						specialtyID = params.specialty,
						procedureID = params.procedure,
						latitude = userLocation.latitude,
						longitude =	userLocation.longitude,
						distance = 100,
						limit =	30,
						overrideClient = true
					)>

					<cfset local.featuredListingIds = ValueList(featuredListings.id)>

					<cfif featuredListings.recordcount eq 0>
						<!--- Attempt 3: Get basic plus listings --->
						<cfset featuredListings = model("AccountDoctorLocation").doctorSearchMultiQuery(
							info =			"multimatchbasicplus",
							procedureId =	params.procedure,
							specialtyId =	params.specialty,
							country =   	userLocation.country,
							distance =		100,
							zipCode =		trim(params.zip),
							latitude =		userLocation.latitude,
							longitude =		userLocation.longitude,
							limit = 		30,
							basicPlusOnly	=	true
						)>
						<cfset searchType = "Basic Plus">

						<!--- Parse out listing ids who have reached their unopened lead threshold --->
						<cfif featuredListings.recordCount GT 0 AND isdefined("featuredListings.accountId") AND isdefined("featuredListings.id")>
							<cfloop query="featuredListings">
								<cfset BasicPlusUnopenedLeadThreshold = model("Account").BasicPlusUnopenedLeadThreshold(accountId=featuredListings.accountId)>
								<cfif BasicPlusUnopenedLeadThreshold IS FALSE>
									<cfset local.featuredListingIds = ListAppend(local.featuredListingIds, featuredListings.id)>
								<cfelse>
									<cfset local.excludeFeaturedListingIds = ListAppend(local.excludeFeaturedListingIds, featuredListings.id)>
								</cfif>
							</cfloop>
						</cfif>

						<cfif listLen(local.excludeFeaturedListingIds)>
							<cfquery name="featuredListings" dbtype="query">
								SELECT *
								FROM featuredListings
								WHERE id NOT IN (#local.excludeFeaturedListingIds#)
							</cfquery>
						</cfif>

					</cfif>
				</cfif>

				<!--- <cfdump var="#featuredListings#">
				<cfdump var="#local.featuredListingIds#">
				<cfabort> --->

				<cfif featuredListings.recordcount gt 0>
					<!--- Prime leads for each result --->
					<cfset params.SWID = model("ProfileMiniLead").primeSiteWideMini(
						listingIds = local.featuredListingIds,
						positionId = params.position,
						firstname = firstname,
						lastname = lastname,
						email = trim(params.email),
						postalCode = trim(params.zip),
						specialtyId = params.specialty,
						procedureId = params.procedure,
						phone = params.phone,
						comments = params.comments,
						searchType = searchType
					)>

					<!--- Subscribe user to LAD 2.0 newsletter table, which should be removed --->
					<cfset model("NewsletterBeautifulLiving").LAD2Subscribe(
						specialtyId = params.specialty,
						firstname = firstname,
						lastname = lastname,
						country = userLocation.country,
						email = trim(params.email),
						postalCode = trim(params.zip),
						wantsNewsletter = true,
						leadSourceId = 54
					)>

					<!--- Subscribe user to LAD 3.0 newsletter table --->
					<cfset subscribeNewsletter(	render = FALSE)>
				</cfif>

				<cfif isModule>
					<cfset Local.results.featuredListings = featuredListings>
					<cfset Local.results.SWID = params.SWID>
					<cfreturn Local.results>
				<cfelse>
					<cfset renderPage(layout=false)>
				</cfif>
			</cfif>
		<cfelse>
			<!--- If there was invalid data, output some code that the javascript will interpret to highlight the invalid fields --->
			<cfif isModule>
				<cfreturn invalidCriteria>
			<cfelse>
				<cfoutput>
					invalid--[#invalidCriteria#]
				</cfoutput>
				<cfabort>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="forgetMyInfo" hint="Remove user's information">
		<cfsetting showdebugoutput="false">
		<cfset Request.overrideDebug = "false">
		<!--- TODO: Make it secure by passing in more info to make sure they can't just submit any id --->
		<cfset var Local = {}>
		<cfset Local.success = false>
		<cfset Client.FacebookID = 0>
		<cfset Client.FacebookPhoto = "">
		<cfif structKeyExists(params, "key") and Server.IsInteger(params.key)>
			<cfset Local.user = model("user").findByKey(params.key)>
			<cfif isObject(Local.user)>
				<cfset Local.user.saveMyInfo = 0>
				<cfset Local.user.updatedBy = Local.user.id>
				<cfset Local.success = Local.user.save()>
			</cfif>
		</cfif>
		<cfset renderWith(Local.success)>
	</cffunction>

	<cffunction name="recordClick">
		<cfset var local = {}>
		<cfset local.clickStats = {}>
		<cfset local.debugOutput = "">
		<cfset local.inside = 0>

		<cfparam name="params.thisHREF" default="">
		<cfparam name="params.thisSection" default="">
		<cfparam name="params.thisLabel" default="">
		<cfparam name="params.thisKeyValues" default="">


		<!--- Parse and save information about the link and page --->
		<cfif not Client.IsSpider AND params.thisHREF NEQ "" AND params.thisHREF NEQ "##">
			<cfset local.reEscape = createObject( "java", "java.util.regex.Pattern" )>

			<cfset local.clickStats.paramsHref = params.thisHREF>
			<cfset local.clickStats.paramsSection = params.thisSection>
			<cfset local.clickStats.paramsLabel = params.thisLabel>
			<cfset local.clickStats.thisKeyValues = params.thisKeyValues>

			<cfset local.clickStats.targetController = listFirst(params.thisHREF, "/")>

			<cfif ListLen(params.thisHREF, "/") GT 1>
				<cfset local.clickStats.targetAction = listGetAt(params.thisHREF, 2, "/")>
			<cfelse>
				<cfset local.clickStats.targetAction = "">
			</cfif>

			<cfset local.clickStats.targetKeyList = REReplace(LCase(params.thisHREF),'/?(#local.reEscape.quote(LCase(local.clickStats.targetController))#|#local.reEscape.quote(LCase(local.clickStats.targetAction))#)/?','','all')>
			<cfset local.clickStats.targetQueryString = ListRest(local.clickStats.targetKeyList, "?")>
			<cfset local.clickStats.targetKeyList = ListFirst(local.clickStats.targetKeyList, "?")>

			<cfset local.clickStats.refererPathInfo = ReplaceNoCase(cgi.HTTP_REFERER, "http#(cgi.SERVER_PORT_SECURE EQ 1 ? "s" : "")#://#cgi.server_name#", "")>
			<cfset local.clickStats.refererController = listFirst(local.clickStats.refererPathInfo, "/")>

			<cfif ListLen(local.clickStats.refererPathInfo, "/") GT 1>
				<cfset local.clickStats.refererAction = listGetAt(local.clickStats.refererPathInfo, 2, "/")>
			<cfelse>
				<cfset local.clickStats.refererAction = "">
			</cfif>

			<cfset local.clickStats.refererKeyList = REReplace(LCase(local.clickStats.refererPathInfo),'/?(#local.reEscape.quote(reEscapeMe(LCase(local.clickStats.refererController)))#|#local.reEscape.quote(reEscapeMe(LCase(local.clickStats.refererAction)))#)/?','','all')>
			<cfset local.clickStats.refererQueryString = ListRest(local.clickStats.refererKeyList, "?")>
			<cfset local.clickStats.refererKeyList = ListFirst(local.clickStats.refererKeyList, "?")>

			<cfset local.clickStats.refererKeyList = urlDecode(local.clickStats.refererKeyList)>
			<cfset local.clickStats.refererPathInfo = urlDecode(local.clickStats.refererPathInfo)>

			<cfset local.HitsClickId = model("HitsClick").recordClick(	clickStats	= local.clickStats)>

			<cfif listLen(params.thisKeyValues) AND val(local.HitsClickId) GT 0>
				<cfloop list="#params.thisKeyValues#" index="local.kv" delimiters=";">
					<cfset local.theKey = trim(listFirst(local.kv, ":"))>
					<cfset local.theValue = listLast(local.kv, ":")>

					<cfif isnumeric(local.theValue) AND val(local.theValue) EQ local.theValue>
						<cfset model("HitsClickKeyValue").recordClick(	HitsClickId	= local.HitsClickId,
																		theKey		= local.theKey,
																		theValue	= local.theValue)>
					</cfif>
				</cfloop>

				<cfif ListFindNoCase("DoctorProfileWebsiteLink,ProfileConfirmationWebsiteLink", local.clickStats.paramsLabel)>
					<!--- Email the doctor that a patient clicked on their website --->

					<cfloop list="#params.thisKeyValues#" index="local.kv" delimiters=";">
						<cfset local.theKey = trim(listFirst(local.kv, ":"))>
						<cfset local.theValue = listLast(local.kv, ":")>

						<cfif local.theKey EQ "accountDoctorid" AND val(local.theValue) GT 0>
							<cfset EmailDoctorWebsiteClick(	accountDoctorid	= local.theValue)>
							<cfbreak>
						</cfif>

						<cfset local.inside = 2>
					</cfloop>
				</cfif>
			</cfif>


			<!--- <cfif server.thisServer EQ "dev" OR ListFind(server.officeIps, cgi.REMOTE_ADDR)>
				<cfsavecontent variable="local.debugOutput">
				<cfoutput>
					<p>local.clickStats<br /><cfdump var="#local.clickStats#"></p>
					<p>CLIENT<br /><cfdump var="#client#"></p>
					<p>PARAMS<br /><cfdump var="#params#"></p>
					<cfoutput><p>local.clickStats.paramsLabel = #local.clickStats.paramsLabel#</p>
							<p>local.inside = #local.inside#</p>
					</cfoutput>
				</cfoutput>
				</cfsavecontent>
			</cfif> --->
		</cfif>

		<cfset renderText(debugOutput)>
	</cffunction>

	<cffunction name="EmailDoctorWebsiteClick">
		<cfargument name="accountDoctorId" required="true" type="numeric">

		<cfset qUser = "">
		<cfset qDoctor = model("AccountDoctorEmail").EmailDoctorWebsiteClick(accountDoctorId	= arguments.accountDoctorId)>

		<cfif isdefined("client.user_account_id") AND isnumeric(client.user_account_id) AND val(client.user_account_id) GT 0>
			<cfset qUser = model("User").findOneById(	value	= client.user_account_id,
														select	= "users.firstName, users.lastName, users.address, users.city, users.postalCode, users.phone, users.alternatePhone, users.email, users.age, users.gender",
														where	= "users.saveMyInfo = 1")>
		</cfif>

		<cfif qDoctor.recordCount GT 0>

			<cfif server.thisServer EQ "dev" OR ListFind(server.officeIps, cgi.REMOTE_ADDR)>
				<cfset qExisting = "">
			<cfelse>
				<cfset qExisting = model("ProfileWebsiteClick").findOne(	SELECT	= "id",
																			WHERE	= "ipAddress = #cgi.REMOTE_ADDR# OR (cfId = #client.cfid# AND cfToken = #client.cfToken#)")>
			</cfif>

			<cfif NOT ISOBJECT(qExisting)>

				<!--- Save information about this user --->
				<cfquery datasource="myLocateadocEdits">
					INSERT IGNORE INTO profilewebsiteclicks
					SET	accountDoctorId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorId#">,
						<cfif isdefined("client.user_account_id") AND isnumeric(client.user_account_id)>
							userId = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.user_account_id#">,
						</cfif>
						<cfif isdefined("client.facebookid") AND isnumeric(client.facebookid)>
							faceBookId = <cfqueryparam cfsqltype="cf_sql_bigint" value="#client.facebookid#">,
						</cfif>

						<cfif isdefined("client.pagehistory_1") AND client.pagehistory_1 NEQ "">
							pagehistory1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_1#">,
						</cfif>

						<cfif isdefined("client.pagehistory_2") AND client.pagehistory_2 NEQ "">
							pagehistory2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_2#">,
						</cfif>

						<cfif isdefined("client.pagehistory_3") AND client.pagehistory_3 NEQ "">
							pagehistory3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_3#">,
						</cfif>

						<cfif isdefined("client.pagehistory_4") AND client.pagehistory_4 NEQ "">
							pagehistory4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_4#">,
						</cfif>

						<cfif isdefined("client.pagehistory_5") AND client.pagehistory_5 NEQ "">
							pagehistory5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_5#">,
						</cfif>

						`ipAddress` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,

						<cfif isdefined("client.referralfull") AND client.referralfull NEQ "">
							`refererExternal` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.referralfull#">,
						</cfif>

						<cfif isdefined("client.entrypage") AND client.entrypage NEQ "">
							`entryPage` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.entrypage#">,
						</cfif>

						<cfif isdefined("client.keywords") AND client.keywords NEQ "">
							`keywords` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.keywords#">,
						</cfif>

						`refererInternal` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_REFERER#">,
						`cfId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.cfid#">,
						`cfToken` = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.cftoken#">,
						`userAgent` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#">,
						createdAt = now()
				</cfquery>


				<cfif qDoctor.wantsWebsiteLeads>
					<cfquery datasource="myLocateadocEdits" name="qProfileWebsiteClick">
						SELECT last_insert_id() AS id
					</cfquery>

					<cfif server.thisServer EQ "dev" OR ListFind(server.officeIps, cgi.REMOTE_ADDR)>
						<cfset emailTo = "eleads@mojointeractive.com">
					<cfelse>
						<cfset emailTo = qDoctor.emails>
					</cfif>

					<cfmail from	= "#qDoctor.salesFullName# <#qDoctor.salesEmail#>"
							to		= "#emailTo#"
							bcc		= "eleads@mojointeractive.com"
							subject	= "LocateADoc.com sent a potential patient to your website"
							type	= "HTML">
						<cfif server.thisServer EQ "dev" OR ListFind(server.officeIps, cgi.REMOTE_ADDR)>
							<p>EMAIL TO SHOULD BE - #qDoctor.emails#</p>
						</cfif>
						#includePartial(partial="/shared/websiteclickemail")#
					</cfmail>
				</cfif>
			</cfif>

		</cfif>

	</cffunction>

	<cffunction name="procedureSelectData">
		<cfset Request.overrideDebug = "false">
		<cfsavecontent variable="procedureSelections">
			specialtyProcedureSelections = [];
			<cfoutput query="Application.qProceduresAndSpecialties">
				<cfif Application.qProceduresAndSpecialties.name eq 'Acupuncture '>
					<cfset nameString = 'Acupuncture '>
				<cfelse>
					<cfset nameString = formatForSelectBox(Application.qProceduresAndSpecialties.name)>
				</cfif>

				<cfset nameString = deAccent(nameString)>

				specialtyProcedureSelections["#UCase(nameString)#"] = {
					index:	"#trim(UCase(nameString))#",
					value:	"#Application.qProceduresAndSpecialties.type#-#Application.qProceduresAndSpecialties.id#",
					label:	"#nameString#",
					test:	"#nameString#",
					specialtyIds:	[#ListQualify(Application.qProceduresAndSpecialties.specialtyIds, '"')#]
				};
			</cfoutput>
		</cfsavecontent>
		<cfcontent type="text/javascript; charset=utf-8">
		<cfset renderText(procedureSelections)>
	</cffunction>

	<cffunction name="facebookChannel" hint="This is a script that facebook's API requires. Just do what it says.">
		<cfset Request.overrideDebug = false>
		<cfset renderPage(layout=false, cache=1440)>
	</cffunction>

	<cffunction name="facebookResponse" hint="Handles facebook login response and sets client variables">
		<cfset Request.overrideDebug = false>
		<cfset provides("html,json")>
		<cfparam name="params.id" default="">
		<cfparam name="params.picture.data.url" default="">
		<cfparam name="params.locationString" default="">
		<cfparam name="params.locale" default="">
		<cfparam name="params.birthday" default="">
		<cfparam name="params.gender" default="">
		<cfparam name="params.loginClick" default="false">
		<cfparam name="params.callback" default="">
		<cfset userInfo = params>
		<cfset userInfo.location = userInfo.locationString>
		<cfset returnLocation = {city='',state='',age='',userID=0}>
		<cfset var FB_id = userInfo.id>
		<cfif val(FB_id) gt 0>
			<!--- Get the FB user record if it exists --->
			<cfset var FB_User = model("FacebookUser").findOneByUID(FB_id)>
			<cfset userInfo.id = IsObject(FB_User) ? FB_User.userId : ''>
			<!--- Parse location string if in US --->
			<cfif userInfo.locale eq "en_US">
				<cfset objLocation = ParseLocation(userInfo.location)>
				<cfif objLocation.cityFound>
					<cfset returnLocation.city = objLocation.cityname>
					<cfset userInfo.city = objLocation.cityname>
				</cfif>
				<cfif objLocation.stateFound>
					<cfset returnLocation.state = objLocation.state>
					<cfset userInfo.state = objLocation.state>
				</cfif>
			</cfif>
			<!--- Determine age range --->
			<cfif IsDate(userInfo.birthday)>
				<cfset age = DateDiff("yyyy",ParseDateTime(userInfo.birthday),now())>
				<cfif age lte 13>
					<cfset returnLocation.age = "13 and under">
				<cfelseif age gte 14 and age lte 17>
					<cfset returnLocation.age = "14-17">
				<cfelseif age gte 18 and age lte 24>
					<cfset returnLocation.age = "18-24">
				<cfelseif age gte 25 and age lte 34>
					<cfset returnLocation.age = "25-34">
				<cfelseif age gte 35 and age lte 44>
					<cfset returnLocation.age = "35-44">
				<cfelseif age gte 45 and age lte 54>
					<cfset returnLocation.age = "45-54">
				<cfelseif age gte 55>
					<cfset returnLocation.age = "55+">
				</cfif>
				<cfset userInfo.age = returnLocation.age>
			</cfif>
			<!--- Store information if logging in --->
			<cfif userInfo.loginClick>
				<cfif ListFind("male,female",userInfo.gender)>
					<cfset userInfo.patientGender = Left(LCase(userInfo.gender),1)>
				</cfif>
				<cfset userInfo.saveMyInfo1 = 1>
				<cfset userInfo.birthDate = userInfo.birthday>
				<cfset userInfo.photoLocation = userInfo.picture.data.url>
				<cfset Request.oUser.saveUserInfo(userInfo)>
				<!--- Create a new FB user record if it doesn't exist --->
				<cfif not IsObject(FB_User) AND val(Request.oUser.id) gt 0>
					<cfset FB_User = model("FacebookUser").create(
						uid 	= FB_id,
						userID 	= Request.oUser.id
					)>
				</cfif>
			</cfif>
			<cfif structKeyExists(Request.oUser, "saveMyInfo") and Request.oUser.saveMyInfo eq 1>
				<cfset returnLocation.userID = Request.oUser.id>
			</cfif>
			<cfset Client.FacebookID = FB_id>
			<cfset Client.FacebookPhoto = userInfo.picture.data.url>
		</cfif>
		<cfset renderText("#SerializeJSON(returnLocation)#")>
	</cffunction>

	<cffunction name="claim">
		<cfparam default="" name="params.key">

		<cfset qDoctor = model("AccountDoctor").findOneById(	select	= "firstName, lastName, title",
																value	= val(params.key))>

		<cfif isnumeric(params.key) AND not Client.IsSpider>
			<cfset model("HitsProfileClaim").RecordClick(accountDoctorId =	params.key)>
		</cfif>

		<cfset renderPage(layout=false, hideDebugInformation=true)>

	</cffunction>
</cfcomponent>