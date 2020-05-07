<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset dataSource("myLocateadocEdits")>
		<cfset belongsTo("accountDoctor")>

		<cfset validatesPresenceOf(properties="refererExternal",condition=false)>
	</cffunction>

	<cffunction name="submitToLAD2" returntype="numeric" hint="Submits mini lead to the 2.0 database">
		<cfargument name="accountDoctorId"	type="numeric"	default=""		required="true">
		<cfargument name="firstName"		type="string"	default=""		required="true">
		<cfargument name="lastName"			type="string"	default=""		required="true">
		<cfargument name="email"			type="string"	default=""		required="true">
		<cfargument name="phone"			type="string"	default="N/A">
		<cfargument name="ipAddress"		type="string"	default="N/A">
		<cfargument name="refererExternal"	type="string"	default="N/A">
		<cfargument name="refererInternal"	type="string"	default="N/A">
		<cfargument name="entryPage"		type="string"	default="N/A">
		<cfargument name="keywords"			type="string"	default="N/A">
		<cfargument name="cfId"				type="string"	default="N/A">
		<cfargument name="cfToken"			type="string"	default="N/A">
		<cfargument name="LeadSourceId"		type="numeric"	default="53">
		<cfargument name="infoId"			type="numeric"	default="0">
		<cfargument name="specialtyId"		type="numeric"	default="0">
		<cfargument name="procedureId"		type="numeric"	default="0">
		<cfargument name="comments" 		type="string"	default="">
		<cfargument name="postalCode" 		type="string"	default="">
		<cfargument name="isPaid" 			type="numeric"	default="0">
		<cfargument name="SWleadId"			type="numeric"	default="0">
		<cfargument name="leadTypeId"						default="">
		<cfargument name="miniProcedures" 	type="string"	default="">
		<cfset var Local = {}>
		<cfset Local.success = true><!--- Because we're optimistic --->
		<cfset folio_mini_lead_id = 0>

		<cftry>
			<cfif Arguments.accountDoctorId neq 0>
				<cfset Local.info = model("AccountDoctorLocation").findAll(
											select		= "id AS infoId",
											where		= "accountDoctorId = #Arguments.accountDoctorId#"
											)>
				<cfif Local.info.recordCount>
					<cfset Arguments.infoId = Local.info.infoId>
				</cfif>
			</cfif>
			<cfif arguments.infoId eq 0>
				<cfset dumpStruct = {Arguments=arguments}>
				<cfset fnCthulhuException(	scriptName="ProfileMiniLead.cfc",
											message="Invalid infoID (#Arguments.infoId#)",
											detail="Jason has a window to the Arctic so he can watch the penguins be.",
											dumpStruct=dumpStruct,
											errorCode=503
											)>
			</cfif>
			<cfif arguments.specialtyid eq 0 and arguments.procedureid gt 0>
				<cfset getSpecialty = model("SpecialtyProcedure").findAll(select="specialtyId", where="procedureId = #arguments.procedureid#")>
				<cfif getSpecialty.recordCount>
					<cfset arguments.specialtyid = getSpecialty.specialtyId>
				<cfelse>
					<cfset dumpStruct = {getSpecialty=getSpecialty,arguments=arguments}>
					<cfset fnCthulhuException(	scriptName="ProfileMiniLead.cfc",
												message="Can't find specialty for procedure id #arguments.procedureid#.",
												detail="The penguins in the Arctic have a window through Jason's monitor so they can watch him be.",
												dumpStruct=dumpStruct,
												errorCode=503
												)>
				</cfif>
			</cfif>
			<cfquery datasource="myLocateadoc" name="qEmailCheck">
				SELECT count(*) AS email_check
				from folio_mini_leads
				WHERE email = <cfqueryparam value="#arguments.email#">
					AND created_dt > date_add(now(), INTERVAL -1 DAY)
					AND info_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.infoId#">
			</cfquery>
			<cfif qEmailCheck.email_check eq 0>
				<cfquery datasource="myLocateadoc" name="SetFolioMiniLead">
					INSERT INTO folio_mini_leads (specialty_id, procedure_name_id, info_id, firstname, lastname, email, home_phone, zip, comments, ipaddress, referral_full, entry_page, keywords, cfid_cftoken, is_active, created_dt)
					VALUES (<cfqueryparam value="#arguments.specialtyId#" cfsqltype="cf_sql_tinyint">,
							<cfif isnumeric(arguments.procedureId) and arguments.procedureId gt 0>
								<cfqueryparam value="#arguments.procedureId#" cfsqltype="cf_sql_smallint">
							<cfelse>
								NULL
							</cfif>,
							<cfqueryparam value="#Arguments.infoId#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#arguments.firstName#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#arguments.lastName#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#arguments.postalCode#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#arguments.comments#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#cgi.REMOTE_ADDR#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#Client.ReferralFull#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#Client.EntryPage#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#Client.KEYWORDS#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#val(client.CFID)#:#val(client.CFTOKEN)#" cfsqltype="cf_sql_char">,
							1, now())
				</cfquery>

				<cfquery datasource="myLocateadoc" name="qLast">
					SELECT last_insert_id() AS last_id
				</cfquery>

				<cfset folio_mini_lead_id = qLast.last_id>
			<cfelseif isEmail(arguments.email)>
				<!--- Find the mini lead id --->
				<cfquery datasource="myLocateadoc" name="GetMinilead">
					/* Find the mini lead id */
					SELECT id
					FROM folio_mini_leads
					WHERE info_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.infoId#"> AND
					      email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_char"> AND
					      created_dt > date_add(now(), INTERVAL -1 DAY)
				</cfquery>

				<cfset folio_mini_lead_id = GetMinilead.id>
			</cfif>
			<!--- <cfquery datasource="myLocateadoc">
				INSERT INTO folio_mini_leads
				SET	info_id			= <cfqueryparam cfsqltype="cf_sql_integer"	value="#Local.info.infoId#">,
					specialty_id	= <cfqueryparam cfsqltype="cf_sql_integer"	value="#Local.info.specialtyId#">,
					firstname		= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.firstName#">,
					lastname		= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.lastName#">,
					home_phone		= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.phone#">,
					email			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.email#">,
					ipaddress		= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.ipAddress#">,
					referral_full	= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.refererExternal#">,
					entry_page		= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.entryPage#">,
					keywords		= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.keywords#">,
					cfid_cftoken	= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.cfId#:#Arguments.cfToken#">,
					is_active		= 1,
					<cfif Arguments.LeadSourceId gt 0>
					source_id		= #Arguments.LeadSourceId#,
					</cfif>
					created_dt		= now()
			</cfquery>
			<cfquery datasource="myLocateadoc" name="Local.lastInsertedMiniLead">
				SELECT LAST_INSERT_ID() as id;
			</cfquery> --->
			<cfquery datasource="myLocateadoc" name="Local.user">
				SELECT id
				FROM user_accounts
				WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.email#">
			</cfquery>
			<cfif not Local.user.recordCount>
				<cflock name="miniLeadInsertUser" throwontimeout="true" timeout="30" type="readOnly">
					<cfquery datasource="myLocateadoc">
						INSERT INTO user_accounts
							(
							firstname,
							lastname,
							hphone,
							email,
							is_active
							)
						VALUES
							(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.firstName#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.lastName#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.phone#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.email#">,
							1
							)
					</cfquery>
					<cfquery datasource="myLocateadoc" name="Local.lastInsertedUser">
						SELECT LAST_INSERT_ID() as id;
					</cfquery>
				</cflock>
				<cfset Local.user = {id=Local.lastInsertedUser.id}>
			</cfif>

			<cfset var quserhits = "">
			<cfset var qUAH = "">

			<!--- We should check if any doctor in this account received this lead --->
			<cfquery datasource="myLocateadoc" name="qHitCheck">
				SELECT id
				from user_accounts_hits
				WHERE user_id = #Local.user.id#
					AND date > date_add(now(), INTERVAL -1 DAY)
					AND info_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.infoId#">
			</cfquery>

			<cfif qHitCheck.recordCount eq 0>
				<cfquery datasource="myLocateadoc" name="quserhits">
					INSERT INTO user_accounts_hits
						(
						info_id,
						sid,
						procedure_name_id,
						user_id,
						source_id,
						ipAddress,
						refererExternal,
						refererInternal,
						keywords,
						entryPage,


						<cfif isdefined("client.facebookid") AND isnumeric(client.facebookid)>
							faceBookId,
						</cfif>

						<cfif isdefined("client.pagehistory_1") AND client.pagehistory_1 NEQ "">
							pagehistory1,
						</cfif>

						<cfif isdefined("client.pagehistory_2") AND client.pagehistory_2 NEQ "">
							pagehistory2,
						</cfif>

						<cfif isdefined("client.pagehistory_3") AND client.pagehistory_3 NEQ "">
							pagehistory3,
						</cfif>

						<cfif isdefined("client.pagehistory_4") AND client.pagehistory_4 NEQ "">
							pagehistory4,
						</cfif>

						<cfif isdefined("client.pagehistory_5") AND client.pagehistory_5 NEQ "">
							pagehistory5,
						</cfif>

						`userAgent`,


						is_cover_up,
						is_send,
						is_paid,
						date,
						cfid,
						cftoken,
						comments
						)
					VALUES
						(
						<cfqueryparam value="#Arguments.infoId#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.specialtyId#" cfsqltype="cf_sql_tinyint">,
						<cfif isnumeric(arguments.procedureId) and arguments.procedureId gt 0>
							<cfqueryparam value="#arguments.procedureId#" cfsqltype="cf_sql_smallint">
						<cfelse>
							NULL
						</cfif>,
						0#Local.user.id#,
						<cfif isnumeric(Arguments.LeadSourceId) and arguments.LeadSourceId gt 0>
							<cfqueryparam value="#Arguments.LeadSourceId#" cfsqltype="cf_sql_smallint">
						<cfelse>
							NULL
						</cfif>,
						<cfqueryparam value="#cgi.REMOTE_ADDR#" cfsqltype="cf_sql_char">,
						<cfqueryparam value="#Client.referralfull#">,
						<cfqueryparam value="#CGI.HTTP_REFERER#">,
						<cfqueryparam value="#Client.keywords#">,
						<cfqueryparam value="#Client.entryPage#">,


						<cfif isdefined("client.facebookid") AND isnumeric(client.facebookid)>
							<cfqueryparam cfsqltype="cf_sql_bigint" value="#client.facebookid#">,
						</cfif>

						<cfif isdefined("client.pagehistory_1") AND client.pagehistory_1 NEQ "">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_1#">,
						</cfif>

						<cfif isdefined("client.pagehistory_2") AND client.pagehistory_2 NEQ "">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_2#">,
						</cfif>

						<cfif isdefined("client.pagehistory_3") AND client.pagehistory_3 NEQ "">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_3#">,
						</cfif>

						<cfif isdefined("client.pagehistory_4") AND client.pagehistory_4 NEQ "">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_4#">,
						</cfif>

						<cfif isdefined("client.pagehistory_5") AND client.pagehistory_5 NEQ "">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_5#">,
						</cfif>

						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#">,



						1,
						1,
						#arguments.isPaid#,
						now(),
						`cfId` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFID)#">,
						`cfToken` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFTOKEN)#">,
						<cfqueryparam value="#arguments.comments#">
						)
				</cfquery>

				<cfquery datasource="myLocateadoc" name="qUAH">
					SELECT last_insert_id() AS id
				</cfquery>

				<cfif arguments.SWleadId gt 0>
					<cfquery datasource="myLocateadoc">
						INSERT IGNORE INTO folio_swm_uah_mapped (folioMiniLeadSiteWideId, userAccountsHitsId, createdAt)
						VALUES (#arguments.SWleadId#, #qUAH.id#, now());
					</cfquery>
				</cfif>
				<cfset qHitCheck = {id = qUAH.id}>
			</cfif>

			<!--- Innovation day --->
			<cfif Server.IsInteger(arguments.leadTypeId) and Server.IsInteger(qHitCheck.id)>
				<cfquery datasource="myLocateadocLB" name="Local.qryTypes">
					SELECT user_accounts_hits_id
					FROM user_accounts_hits_types
					WHERE user_accounts_hits_id = #qHitCheck.id#
						AND user_accounts_hits_type_name_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.leadTypeId#">
						AND deletedAt IS NULL
				</cfquery>
				<cfif Local.qryTypes.recordCount eq 0>
					<cfquery datasource="myLocateadoc">
						INSERT INTO user_accounts_hits_types
							(
							user_accounts_hits_id,
							user_accounts_hits_type_name_id,
							<cfif Server.IsInteger(Request.oUser.id)>createdBy,</cfif>
							createdAt
							)
						VALUES
							(
							#qHitCheck.id#,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.leadTypeId#">,
							<cfif Server.IsInteger(Request.oUser.id)>#Request.oUser.id#,</cfif>
							now()
							)
					</cfquery>
				</cfif>
			</cfif>

			<!--- Loop through all the procedures ids for this mini lead, and if the procedure submitted doesn't exist, then insert and associate with this mini leads --->
			<cfif val(folio_mini_lead_id) gt 0>
				<cfset existingMiniLeadProcedure = model("ProfileMiniLeadProcedure").findAll(
							select = "procedureId",
							where = "profileMiniLeadId = #folio_mini_lead_id#"
				)>
				<cfset existingMiniLeadProcedures = ValueList(existingMiniLeadProcedure.procedureId)>
				<cfloop list="#arguments.miniProcedures#" index="MLprocedure">
					<cfif val(MLprocedure) gt 0 and ListFind(existingMiniLeadProcedures,val(MLprocedure)) eq 0>
						<cfset newMiniLeadProcedure	= model("ProfileMiniLeadProcedure").create(
							profileMiniLeadId = folio_mini_lead_id,
							procedureId = MLprocedure
						)>
					</cfif>
				</cfloop>
			</cfif>

			<cfcatch type="all">
				<cfset dumpStruct = {thearguments=arguments, Local=Local}>
				<cfset fnCthulhuException(		scriptName="ProfileMiniLead.cfc",
												message="Site Wide Mini Lead Error",
												detail="Creation of Mini Leads function: submitToLAD2",
												dumpStruct=dumpStruct)>
				<cfset folio_mini_lead_id = 0>
			</cfcatch>
		</cftry>
		<cfreturn val(folio_mini_lead_id)>
	</cffunction>

	<cffunction name="primeSiteWideMini">
		<cfargument name = "listingIds" default="">
		<cfargument name = "positionId" default="">
		<cfargument name = "firstname" default="">
		<cfargument name = "lastname" default="">
		<cfargument name = "email" default="">
		<cfargument name = "postalCode" default="">
		<cfargument name = "specialtyId" default="0">
		<cfargument name = "procedureId" default="0">
		<cfargument name = "phone" default="">
		<cfargument name = "comments" default="">
		<cfargument name = "searchType" default="">

		<cfset var li = "">

		<!--- Check if user is double clicking submission --->
		<cfquery datasource="myLocateadoc" name="qFolioMiniLeadSiteWide">
			SELECT id
			FROM folio_mini_lead_site_wide
			WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
				AND postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postalCode#">
				AND specialtyId
					<cfif arguments.specialtyId>
						= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.specialtyId#">
					<cfelse>
						IS NULL
					</cfif>
				AND procedureId
					<cfif arguments.procedureId>
						= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.procedureId#">
					<cfelse>
						IS NULL
					</cfif>
				AND date(createdAt) = date(now())
			ORDER BY id desc
			LIMIT 1
		</cfquery>

		<cfif qFolioMiniLeadSiteWide.recordcount EQ 0>
			<cfquery datasource="myLocateadoc">
				INSERT IGNORE INTO	folio_mini_lead_site_wide
				(
					position_id, specialtyId, procedureId, searchResultsType, firstname, lastname, email,
					postalCode, phone, comments, `ipAddress`, `refererExternal`, `refererInternal`, `entryPage`,
					`keywords`, `cfId`, `cfToken`, `userAgent`, createdAt
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.positionId#">,
				<cfif arguments.specialtyId>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.specialtyId#">,
				<cfelse>
					NULL,
				</cfif>

				<cfif arguments.procedureId>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.procedureId#">,
				<cfelse>
					NULL,
				</cfif>

				<cfif trim(arguments.searchType) EQ "">
					NULL
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchType#">
				</cfif>,

					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstname#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastname#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postalCode#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phone#">,
					<cfqueryparam value="#arguments.comments#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Client.REFERRALFULL#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_REFERER#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Client.ENTRYPAGE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Client.KEYWORDS#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFID)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFTOKEN)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#">,
					now()
				)
			</cfquery>

			<cfquery datasource="myLocateadoc" name="qFolioMiniLeadSiteWide">
				SELECT last_insert_id() AS id
			</cfquery>
		</cfif>

		<cfif listLen(arguments.listingIds)>
			<cfloop list = "#arguments.listingIds#" index="li">
				<cfquery datasource="myLocateadoc">
					INSERT IGNORE INTO `folio_mini_lead_site_wide_listings` (`folio_mini_lead_site_wide_id`, `info_id`, `createdAt`)
					VALUES (#qFolioMiniLeadSiteWide.id#, <cfqueryparam cfsqltype="cf_sql_integer" value="#li#">, now())
				</cfquery>
			</cfloop>
		</cfif>

		<cfreturn qFolioMiniLeadSiteWide.id>


	</cffunction>

	<cffunction name="refreshSiteWideMini">
		<cfargument name = "listingIds" default="">
		<cfargument name = "FolioMiniLeadSiteWideId" default="">

		<cfquery datasource="myLocateadoc">
			UPDATE folio_mini_lead_site_wide_listings
			SET deletedAT = now()
			WHERE folio_mini_lead_site_wide_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FolioMiniLeadSiteWideId#">
				<cfif listLen(arguments.listingIds)>
					AND info_id NOT IN (#arguments.listingIds#)
				</cfif>
		</cfquery>

	</cffunction>

	<cffunction name="submitSiteWideMini">
		<cfargument name = "listingIds" default="">
		<cfargument name = "specialtyid" default="0">
		<cfargument name = "procedureId" default="0">
		<cfargument name = "firstname" default="">
		<cfargument name = "lastname" default="">
		<cfargument name = "email" default="">
		<cfargument name = "phone" default="">
		<cfargument name = "comments" default="">
		<cfargument name = "FolioMiniLeadSiteWideId" default="">

		<cfset var Local = {}>

		<cfif listLen(arguments.listingIds)>

			<cfquery datasource="myLocateadoc" name="qLeads">
				SELECT fw.id, fmlswl.info_id, adl.accountDoctorId, fw.specialtyId, fw.procedureId, fw.firstname, fw.lastname, fw.email, fw.phone, fw.comments, fw.postalCode, fw.createdAt
				FROM folio_mini_lead_site_wide fw
				INNER JOIN folio_mini_lead_site_wide_listings fmlswl On fmlswl.folio_mini_lead_site_wide_id = fw.id AND fmlswl.deletedAT IS NULL
				INNER JOIN myLocateadoc3.accountdoctorlocations adl ON adl.id = fmlswl.info_id AND adl.deletedAt IS NULL
				INNER JOIN myLocateadoc3.accountpractices ap ON ap.id = adl.accountPracticeId AND ap.deletedAt IS NULL

				/* Pull all the listings in this account and make sure a lead did not go to any of the accounts listings from this email address*/
				INNER JOIN myLocateadoc3.accountpractices ap2 ON ap2.accountId = ap.accountId
				INNER JOIN myLocateadoc3.accountdoctorlocations adl2 ON adl2.accountPracticeId = ap2.id

				LEFT JOIN user_accounts ua ON ua.email = fw.email
				LEFT JOIN user_accounts_hits uah ON uah.user_id = ua.id AND uah.info_id = adl2.id
				<!--- LEFT JOIN user_accounts_hits uah ON uah.user_id = ua.id AND uah.info_id IN (<cfqueryparam list="true" value="#arguments.listingIds#">) --->
				WHERE fw.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FolioMiniLeadSiteWideId#">
						AND uah.id IS NULL
						AND fw.deletedAT IS NULL
				GROUP BY ap.accountId
				/* Group by accountId to prevent an account with multiple listings from receiving multiple leads */
			</cfquery>

			<!--- Submit Leads --->
			<cfloop query="qLeads">
				<cfset submitToLAD2(
					accountDoctorId = 0,
					firstName = qLeads.firstname,
					lastName = qLeads.lastname,
					email = qLeads.email,
					phone = qLeads.phone,
					ipAddress = cgi.REMOTE_ADDR,
					refererExternal = Client.REFERRALFULL,
					refererInternal = cgi.HTTP_REFERER,
					entryPage = Client.ENTRYPAGE,
					keywords = Client.KEYWORDS,
					cfId = client.cfid,
					cfToken = client.cftoken,
					LeadSourceId = 54,
					infoId = qLeads.info_id,
					specialtyId = val(qLeads.specialtyId),
					procedureId = val(qLeads.procedureId),
					comments = qLeads.comments,
					postalCode = qLeads.postalCode,
					SWleadId = qLeads.id,
					miniProcedures = val(qLeads.procedureId)
				)>
				<!--- Check if the doctor is a basic plus who just used up their free leads. If so, notify them. --->
				<cfif model("AccountDoctor").BasicPlusOverLeadThreshold(qLeads.accountDoctorID)>
					<cfset model("AccountDoctorLocation").BasicPlusThresholdEmail(qLeads.info_id,arguments.email)>
				</cfif>
			</cfloop>

			<!--- Send email --->

			<cfif LCase(Server.ThisServer) eq "dev">
				<cfset LAD2URL = "alpha1.locateadoc.com">
			<cfelse>
				<cfset LAD2URL = "www.locateadoc.com">
			</cfif>

			<cfif val(qLeads.id) gt 0>
				<cfset sendSiteWideMiniEmail(
					leadID		= qLeads.id,
					listingIds 	= arguments.listingIDs,
					firstname 	= arguments.firstname,
					email 		= arguments.email,
					procedureId = arguments.procedureId,
					postalCode	= qLeads.postalCode,
					comments 	= arguments.comments
				)>
			</cfif>

		</cfif>
	</cffunction>

	<cffunction name="sendSiteWideMiniEmail">
		<cfargument name = "leadID" default="0">
		<cfargument name = "listingIds" default="">
		<cfargument name = "firstname" default="">
		<cfargument name = "email" default="">
		<cfargument name = "procedureId" default="">
		<cfargument name = "postalCode" default="">
		<cfargument name = "comments" default="">
		<cfargument name = "abandoned" default=false>
		<cfargument name = "test" default=false>

		<cfset Local.leadProcedure = "">
		<cfif Server.IsInteger(Arguments.procedureId)>
			<cfset Local.leadProcedure = model("procedure").findByKey(key=Arguments.procedureId, returnAs="query")>
		</cfif>

		<cfset Local.locationStr = "">
		<cfif Arguments.postalCode neq "">
			<cfset Local.locationStr = "/location-#Arguments.postalCode#">
		</cfif>

		<cfquery datasource="#get('dataSourceName')#" name="qMultipleDoctorData">
			SELECT	ss.doctorLocationID as info_id, ss.doctorID AS doctor_entity_id, ss.siloName,
					ss.firstname, ss.lastname, ss.city, ss.stateAbbreviation as state, ss.stateId AS state_id, ss.address,
					ss.postalCode as zip, l.phone, l.phonetollfree as tollfree, ld.phonePlus as phone_plus_num,
					max(pp.dateEnd) AS phoneplus_date_end, w.url AS website, ss.photoFilename AS photo
			FROM accountdoctorsearchsummary ss
			JOIN accountlocations l on ss.locationID = l.id
			JOIN accountlocationdetails ld on ss.doctorLocationID = ld.accountDoctorLocationId
			LEFT OUTER JOIN accountproductspurchaseddoctorlocations ppdl
				JOIN accountproductspurchased pp ON ppdl.accountproductspurchasedid = pp.id AND pp.accountproductid = 7
			ON ss.doctorLocationID = ppdl.accountDoctorLocationId
			LEFT OUTER JOIN accountlocationspecialties ls
				JOIN accountwebsites w ON ls.accountWebsiteID = w.id
			ON ss.doctorLocationID = ls.accountDoctorLocationId
			WHERE ss.doctorLocationID IN (#arguments.listingIds#)
			GROUP BY ss.doctorLocationID;
		</cfquery>

		<cfif arguments.abandoned>
			<cfset variables.subject = "LocateADoc.com: Your doctor search results">
		<cfelseif qMultipleDoctorData.recordcount EQ 1>
			<cfset variables.subject = "LocateADoc.com: Your doctor has been notified.">
		<cfelseif qMultipleDoctorData.recordcount GT 1>
			<cfset variables.subject = "LocateADoc.com: Your doctors have been notified.">
		</cfif>

		<cfif qMultipleDoctorData.recordcount GT 0>
			<cfsavecontent variable="variables.email_body">
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
										<a href="http://#CGI.SERVER_NAME#">
											<img src="http://#CGI.SERVER_NAME#/images/layout/email/lead_patient.gif" width="600" height="68" border="0" style="border:0;">
										</a>
									</td>
								</tr>
							</table>
							<table width="602" cellspacing="0" cellpadding="20" style="border:1px solid ##C4C4C4; border-top:0;">
								<tr>
									<td>
										<cfif trim(arguments.firstName) neq "">
											<p>#arguments.firstName#,<br /></p>
										</cfif>

										<cfif arguments.abandoned>
											<p>Thank you for inquiring with LocateADoc.com.  It appears you filled out the "Contact a Doctor" form and neglected to select a doctor.  For your convenience, listed below are the doctor(s) that you searched for and their contact information.</p>
											<p style="font: 16px arial; color: ##9A546C;"><strong>What Can You Do Now?</strong></p>
											<p>The information you provided helps doctors get more details on how to take care of your needs.  Click on the Dr.'s Name below and fill out the contact form with your specific information.  It takes less than a minute and the doctor of your choice will be in touch with your shortly.</p>
										<cfelse>
											<p>Thank you for contacting the practice<cfif qMultipleDoctorData.recordCount gt 1>s</cfif> below through LocateADoc.com. This message is to confirm each has been notified.</p>
										</cfif>

										<p style="font: 16px arial; color: ##9A546C;"><strong>Contact information:</strong></p>
										<table cellpadding="0" cellspacing="0">
											<cfloop query = "qMultipleDoctorData">
												<cfset link = URLFor(onlyPath=false,controller="#qMultipleDoctorData.siloName#")>
												<!--- Check if a phone plus advertiser and use phone plus number if it is --->
												<cfset doctor_phone = "">
												<cfif qMultipleDoctorData.phoneplus_date_end GTE dateFormat(now(), "yyyy-mm-dd") AND qMultipleDoctorData.phone_plus_num NEQ "">
													<cfset doctor_phone = formatPhone(qMultipleDoctorData.phone_plus_num)>
												<cfelse>
													<cfset doctor_phone = formatPhone(qMultipleDoctorData.phone)>
												</cfif>
												<cfset qMultipleDoctorData.website = (FindNoCase("http:",qMultipleDoctorData.website) ? "" : "http://") & qMultipleDoctorData.website>
												<tr valign="top">
													<td colspan="2">
														<p>
															#qMultipleDoctorData.firstName# #qMultipleDoctorData.lastName# would like more information about your request:
															<a href="http#(CGI.SERVER_PORT_SECURE?"s":"")#://#CGI.SERVER_NAME#/#qMultipleDoctorData.siloName#/contact/?l=#qMultipleDoctorData.info_id#">Please click here to respond.</a>
															<!--- #LinkTo(controller="profile",action="contact",key=qMultipleDoctorData.doctor_entity_id,params="l=#qMultipleDoctorData.info_id#",text="Please click here to respond.",onlyPath=false)# --->
														</p><br />
													</td>
												</tr>
												<tr valign="top">
													<cfif qMultipleDoctorData.photo neq "">
														<td width="153" align="center">
															<img src="http://#CGI.SERVER_NAME#/images/profile/doctors/thumb/#qMultipleDoctorData.photo#" class="docImage" width="113" height="129" style="border:1px solid ##E1E1E1; padding:2px; width:113px; height:129px;">
														</td>
													</cfif>
													<td<cfif qMultipleDoctorData.photo eq ""> colspan="2"</cfif>>
														<a href="#link#" style="text-decoration: none; color: black;" target="_blank">
														<a href="http#(CGI.SERVER_PORT_SECURE?"s":"")#://#CGI.SERVER_NAME#/#qMultipleDoctorData.siloName#?l=#qMultipleDoctorData.info_id#">
															#qMultipleDoctorData.firstname# #qMultipleDoctorData.lastname#
														</a>
														<cfif qMultipleDoctorData.firstname neq "" or qMultipleDoctorData.lastname neq ""><br /></cfif>
														#qMultipleDoctorData.address#<cfif qMultipleDoctorData.address neq ""><br /></cfif>
														#qMultipleDoctorData.city#, #qMultipleDoctorData.state# #qMultipleDoctorData.zip#
														<cfif qMultipleDoctorData.city neq "" or qMultipleDoctorData.state neq "" or qMultipleDoctorData.zip neq "">
															<a href="http#(CGI.SERVER_PORT_SECURE?"s":"")#://#CGI.SERVER_NAME#/#qMultipleDoctorData.siloName#/contact/?l=#qMultipleDoctorData.info_id#&showMap=true">
																Map
															</a><br />
														</cfif>
														<cfif doctor_phone neq "" and not arguments.abandoned>Phone: #doctor_phone#<br /></cfif>
														<cfif qMultipleDoctorData.tollfree neq "" and not arguments.abandoned>
															Toll Free: #formatPhone(qMultipleDoctorData.tollfree)#<br />
														</cfif>
														<cfif qMultipleDoctorData.website neq "" and isValid("URL",qMultipleDoctorData.website) and not arguments.abandoned>
															Website:
															<a href="#qMultipleDoctorData.website#">#qMultipleDoctorData.website#</a><br />
														</cfif>
														<!--- <cfif qMultipleDoctorData.doctor_email_tx neq "" and not arguments.abandoned>
															Email Address: #qMultipleDoctorData.doctor_email_tx#
														</cfif> --->
														<br />
													</td>
												</tr>
												<tr>
													<td colspan="2"><br /><hr></td>
												</tr>
											</cfloop>
										</table>
										<cfif isQuery(Local.leadProcedure) and Local.leadProcedure.recordCount>
											<p style="font: 16px arial; color: ##9A546C;"><strong>Would you like to learn more about #Local.leadProcedure.name#?</strong></p>
											<p>Find out more from our <a href="http#(CGI.SERVER_PORT_SECURE?"s":"")#://#CGI.SERVER_NAME#/resources/procedure/#Local.leadProcedure.id#">#Local.leadProcedure.name# Guide</a>.</p>
											<p style="font: 16px arial; color: ##9A546C;"><strong>Would you like more doctors to contact you?</strong></p>
											<p>
												Find more
												<a href="http#(CGI.SERVER_PORT_SECURE?"s":"")#://#CGI.SERVER_NAME#/doctors/search/procedure-#Local.leadProcedure.id##Local.locationStr#">#Local.leadProcedure.name# doctors</a>
												now.
											</p>
										</cfif>
										<p style="font: 16px arial; color: ##9A546C;"><strong>Would you like to finance your procedure?</strong></p>
										<p>
											<a href="http#(CGI.SERVER_PORT_SECURE?"s":"")#://#CGI.SERVER_NAME#/financing">Click here to see if you qualify.</a>
										</p>
										<p style="font: 16px arial; color: ##9A546C;"><strong>What Happens Next?</strong></p>
										<cfif not arguments.abandoned>
										<p>
											You should receive a reply from the practice shortly. However, please feel free to call the practice at your convenience if you don't hear back right away.
										</p>
										<p>
											Remember to remind them that you originally contacted them through LocateADoc.com.
										</p>
										</cfif>
										<p>
											A follow up email will be sent to you in five (5) business days to help make your contact successful. Please let us know then how your experience with the practice has progressed.
										</p>
										<p>Have a question<cfif isQuery(Local.leadProcedure) and Local.leadProcedure.recordCount> about #Local.leadProcedure.name#</cfif>? Feel free to ask us on:</p>
										<a href="http://www.facebook.com/locateadoc"><img src="http://#CGI.SERVER_NAME#/images/coupon/facebook-icon.png" align="left" border="0"></a>&nbsp;
										<a href="http://twitter.com/locateadoc"><img src="http://#CGI.SERVER_NAME#/images/coupon/twitter-icon.png" border="0"></a>
										<p>
											Sincerely,<br>
											The LocateADoc.com Staff
										</p>
										<p>
											P.S. Have some feedback for us? <a href="http://#CGI.SERVER_NAME#/home/feedback">Tell us what's on your mind.</a>
										</p>
									</td>
								</tr>
							</table>
						</body>
					</html>
				</cfoutput>
			</cfsavecontent>

			<cfmail from="contact@locateadoc.com"
					to="#Arguments.email#"
					subject="#variables.subject#"
					type="html">
				#variables.email_body#
			</cfmail>

			<!--- Make sure this user doesn't get an abandoned lead email --->
			<cfif arguments.test>
				<cfoutput>
				<p>
				from="contact@locateadoc.com"<br />
				to="#Arguments.email#"<br />
				subject="#variables.subject#"<br />
				#variables.email_body#<br />
				</p>
				</cfoutput>
			<cfelse>
				<cfquery datasource="myLocateadoc">
					UPDATE				folio_mini_lead_site_wide fmlsw
					SET					fmlsw.patientEmailSentAt = now()
									<cfif arguments.comments neq "">
										,fmlsw.comments = <cfqueryparam value="#arguments.comments#">
									</cfif>
					WHERE				fmlsw.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.leadID#">
				</cfquery>
			</cfif>

		</cfif>
	</cffunction>

</cfcomponent>