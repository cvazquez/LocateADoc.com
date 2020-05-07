<cfcomponent extends="Model" output="false">

<cffunction name="init">
		<cfset dataSource("myLocateadocEdits")>
		<cfset belongsTo("accountDoctor")>
		<cfset belongsTo("state")>
		<cfset belongsTo("country")>

		<cfset validatesPresenceOf(properties="address,phoneWork,comments,fax,refererExternal",condition=false)>
</cffunction>

<cffunction name="countByEmail" returntype="numeric">
	<cfargument name="email" type="string">

	<cfquery datasource="#get('dataSourceName')#" name="Leads">
		SELECT count(1) as leadcount
		FROM profileleads
		WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">;
	</cfquery>

	<cfreturn Leads.leadcount>
</cffunction>

<cffunction name="submitToLAD2Page1" returntype="numeric" hint="Submits lead to the 2.0 database and returns the folio_id of the new lead, 0 if error">
	<cfargument name="AccountDoctorLocationID" type="numeric" default="0">
	<cfargument name="firstname"			type="string"	default="">
	<cfargument name="lastname"				type="string"	default="">
	<cfargument name="address"				type="string"	default="">
	<cfargument name="city"					type="string"	default="">
	<cfargument name="stateId"				type="numeric"	default="0">
	<cfargument name="postalCode"			type="string"	default="">
	<cfargument name="phoneHome"			type="string"	default="">
	<cfargument name="email"				type="string"	default="">
	<cfargument name="age"					type="string"	default="">
	<cfargument name="gender"				type="string"	default="">
	<cfargument name="refererExternal"		type="string"	default="">
	<cfargument name="entryPage"			type="string"	default="">
	<cfargument name="keywords"				type="string"	default="">
	<cfargument name="cfId"					type="string"	default="">
	<cfargument name="cfToken"				type="string"	default="">

	<cfset var Local = {}>
	<cfset Local.LeadSourceId = 53>
	<cfset Local.returnFolioId = 0>

	<cftry>
		<!--- Retrieve all the listing ids for this doctor ---->
		<cfquery datasource="myLocateadocLB3" name="Local.info">
			SELECT adl2.id AS infoId, als.specialtyId
			FROM accountdoctorlocations adl
			INNER JOIN accountdoctorlocations adl2 ON adl2.accountDoctorId = adl.accountDoctorId
			INNER JOIN accountlocationspecialties als ON als.accountDoctorLocationId = adl2.id
			WHERE adl.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AccountDoctorLocationID#">
			GROUP BY adl2.id
		</cfquery>


		<cfquery datasource="myLocateadoc" name="Local.qLead">
			SELECT folio_id
			FROM folio
			WHERE info_id IN (#valueList(Local.info.infoId)#)
				AND email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.email#">
				AND date_add(date, INTERVAL 10 MINUTE) > now()
		</cfquery>

		<cfset Local.state = model("State").findByKey(select="abbreviation",key=Arguments.stateId, returnAs="query")>

		<cfif Local.qlead.recordcount>
			<cfquery datasource="myLocateadoc">
				UPDATE folio
				SET
					stateid				= <cfqueryparam cfsqltype="cf_sql_integer"	value="#Arguments.stateId#">,
					firstname			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.firstName#">,
					lastname			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.lastName#">,
					address				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.address#">,
					city				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.city#">,
					zip					= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.postalCode#">,
					state				= "#Local.state.abbreviation#",
					hphone				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.phoneHome#">,
					email				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.email#">,
					age					= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.age#">,
					gender				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.gender#">,
					se_ipaddress		= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.ipAddress#">,
					<!--- referral_full		= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.refererExternal#">,
					referral_internal	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_REFERER#">, --->
					entry_page			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.entryPage#">,
					keywords			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.keywords#">,

					<cfif isdefined("client.user_account_id") AND isnumeric(client.user_account_id)>
						user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.user_account_id#">,
					</cfif>

					<cfif isdefined("client.facebookid") AND isnumeric(client.facebookid)>
						faceBookId = <cfqueryparam cfsqltype="cf_sql_bigint" value="#client.facebookid#">,
					</cfif>

					<!--- <cfif isdefined("client.pagehistory_1") AND client.pagehistory_1 NEQ "">
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
					</cfif> --->

					`userAgent` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#">,


					`cfId` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFID)#">,
					`cfToken` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFTOKEN)#">,
					screen_number		= 2,
					lastPage			= 2,
					date				= now(),
					source_id			= #Local.LeadSourceId#,
					is_active			= 1
				WHERE folio_id			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Local.qLead.folio_id#">
			</cfquery>
			<cfset Local.returnFolioId = Local.qLead.folio_id>
		<cfelse>
			<cflock name="folioLeadInsert" throwontimeout="true" timeout="30" type="readOnly">
				<cfquery datasource="myLocateadoc">
					INSERT INTO folio
					SET
						info_id				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Local.info.infoId#">,
						sid					= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Local.info.specialtyId#">,
						stateid				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.stateId#">,
						firstname			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.firstName#">,
						lastname			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.lastName#">,
						address				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.address#">,
						city				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.city#">,
						zip					= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.postalCode#">,
						state				= "#Local.state.abbreviation#",
						hphone				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.PhoneHome#">,
						email				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.email#">,
						age					= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.age#">,
						gender				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.gender#">,
						se_ipaddress		= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.ipAddress#">,
						referral_full		= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.refererExternal#">,
						referral_internal	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_REFERER#">,
						entry_page			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.entryPage#">,
						keywords			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.keywords#">,


						<cfif isdefined("client.user_account_id") AND isnumeric(client.user_account_id)>
							user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.user_account_id#">,
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

						`userAgent` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#">,

						`cfId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(client.CFID)#">,
						`cfToken` = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(client.CFTOKEN)#">,
						screen_number		= 2,
						lastPage			= 2,
						date				= now(),
						date_entered		= now(),
						source_id			= #Local.LeadSourceId#
				</cfquery>
				<cfquery datasource="myLocateadoc" name="Local.lastInserted">
					SELECT LAST_INSERT_ID() as id;
				</cfquery>
				<cfset Local.returnFolioId = Local.lastInserted.id>
			</cflock>
		</cfif>


		<cfquery datasource="myLocateadoc" name="Local.miniLead" result="Local.miniResult">
			UPDATE folio_mini_leads
			SET has_folio_lead = 1
			WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.email#">
				AND info_id IN (#valueList(Local.info.infoId)#)
				AND created_dt > date_add(now(), INTERVAL -1 DAY)
		</cfquery>

		<cfquery datasource="myLocateadoc" name="Local.miniLead">
			UPDATE user_accounts ua
			INNER JOIN user_accounts_hits uah ON uah.user_id = ua.id AND uah.info_id IN (#valueList(Local.info.infoId)#)
												AND uah.date > date_add(now(), INTERVAL -1 DAY)
			SET uah.has_folio_lead = 1
			WHERE ua.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.email#">
		</cfquery>


		<!--- 	Check if mini lead was submitted from this user to this doctor, and if it was, then mark the folio lead as already being sent (screen_number = 4).
				I'm not sure this will work all the time because the folio reminder script also needs to check if a mini lead was already sent.
				Something I don't like about this is that the Profile lead has more information. If the doctor doesn't get the email, they won't
				know to check the extra information.
		--->
		<cfquery datasource="myLocateadoc" name="Local.checkMiniLeadNotification">
			SELECT uah.sentAt
			FROM user_accounts ua
			INNER JOIN user_accounts_hits uah ON uah.user_id = ua.id AND uah.info_id IN (#valueList(Local.info.infoId)#)
												AND uah.date > date_add(now(), INTERVAL -1 DAY)
												AND (uah.sentAt IS NOT NULL OR uah.is_send = 2)
			WHERE ua.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.email#">
		</cfquery>

		<cfif Local.checkMiniLeadNotification.recordCount gt 0 AND isDate(Local.checkMiniLeadNotification.sentAt)>
			<!--- If there's a mini lead, flag the lead so it doesn't get an email --->
			<cfquery datasource="myLocateadoc">
				UPDATE folio
				SET	screen_number		= 4,
					sentAt = <cfqueryparam cfsqltype="cf_sql_date" value="#Local.checkMiniLeadNotification.sentAt#">
				WHERE folio_id			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Local.returnFolioId#">
			</cfquery>
		</cfif>


		<cfcatch type="all">
			<cfset dumpStruct = {arguments=arguments, Local=Local}>
			<cfset fnCthulhuException(		scriptName="ProfileLead.cfc",
											message="Profile Lead Error",
											detail="Page 1 Profile Lead Insert in function: submitToLAD2Page1",
											dumpStruct=dumpStruct,
											errorCode=503)>

			<cfset Local.returnFolioId = 0>
		</cfcatch>
	</cftry>
	<cfreturn Local.returnFolioId>
</cffunction>


<cffunction name="submitToLAD2Page2" returntype="boolean" hint="Submits 2nd page of lead to the 2.0 database">
		<cfargument name="procedures"			type="string"	default="">
		<cfargument name="howSoon"				type="string"	default="">
		<cfargument name="comments"				type="string"	default="">
		<cfargument name="contactID"			type="numeric"	default="">

		<cfset var Local = {}>
		<cfset Local.success = true>
		<cfset Local.LeadSourceId = 53>

		<cftry>
			<cfquery datasource="myLocateadoc" name="Local.folioLead">
				SELECT folio_id, email, sid, firstname, lastname, city, stateid, zip
				FROM folio
				WHERE folio_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.contactID#">
			</cfquery>
			<cfif Local.folioLead.recordCount>
				<cfquery datasource="myLocateadoc">
					UPDATE folio
					SET
						procedure_ids		= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.procedures#">,
						procedure_name_ids	= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.procedures#">,
						how_soon			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.howSoon#">,
						comments			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.comments#">,
						lastPage			= 3,
						date_updated		= now()
					WHERE folio_id			= <cfqueryparam cfsqltype="cf_sql_integer"	value="#Arguments.contactID#">
				</cfquery>
			<cfelse>
				<cfset Local.success = false>
			</cfif>

			<cfcatch type="all">
				<cfset dumpStruct = {arguments=arguments, Local=Local}>
				<cfset fnCthulhuException(		scriptName="ProfileLead.cfc",
												message="Profile Lead Error",
												detail="Page 2 Profile Lead Update in function: submitToLAD2Page2",
												dumpStruct=dumpStruct,
												errorCode=503)>
				<cfset Local.success = false>
			</cfcatch>
		</cftry>
		<cfreturn Local.success>

</cffunction>

<cffunction name="submitToLAD2Page3" returntype="query" hint="Submits 3rd page of lead to the 2.0 database">
	<cfargument name="contactID"			type="numeric"	default="">

	<cfargument name="contactoption"		type="string"	default="">
	<cfargument name="height"				type="string"	default="">
	<cfargument name="weight"				type="string"	default="">
	<cfargument name="issmoker"				type="numeric"	default="0">
	<cfargument name="appointmentDay"		type="string"	default="">
	<cfargument name="appointmentTime"		type="string"	default="">
	<cfargument name="questionText1"		type="string"	default="">
	<cfargument name="questionText2"		type="string"	default="">
	<cfargument name="questionText3"		type="string"	default="">
	<cfargument name="questionText4"		type="string"	default="">
	<cfargument name="questionText5"		type="string"	default="">
	<cfargument name="questionText6"		type="string"	default="">
	<cfargument name="wantsSeminar"							default="">
	<cfargument name="wantsFinancing"						default="">
	<cfargument name="wantsNewsletter"						default="">
	<cfset var Local = {}>
	<cfset Local.LeadSourceId = 53>

	<cftry>
		<cfquery datasource="myLocateadoc" name="Local.folioLead">
			SELECT folio_id, stateid, email, sid, firstname, lastname, city, stateid, zip
			FROM folio
			WHERE folio_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.contactID#">
		</cfquery>
		<cfif Local.folioLead.recordCount>
			<cfquery datasource="myLocateadoc">
				UPDATE folio
				SET
					weight				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.weight#">,
					height				= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.height#">,
					appointment_day		= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.appointmentDay#">,
					appointment_time	= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Arguments.appointmentTime#">,
					q1text				= <cfqueryparam 							value="#Arguments.questionText1#">,
					q2text				= <cfqueryparam 							value="#Arguments.questionText2#">,
					q3text				= <cfqueryparam								value="#Arguments.questionText3#">,
					q4text				= <cfqueryparam								value="#Arguments.questionText4#">,
					q5text				= <cfqueryparam								value="#Arguments.questionText5#">,
					q6text				= <cfqueryparam								value="#Arguments.questionText6#">,
					is_smoker			= <cfqueryparam cfsqltype="cf_sql_integer"	value="#Arguments.issmoker#">,
					is_contact_phone	= <cfqueryparam cfsqltype="cf_sql_integer"	value="#(ListFind(Arguments.contactoption,'phone'))?1:0#">,
					is_contact_mail		= <cfqueryparam cfsqltype="cf_sql_integer"	value="#(ListFind(Arguments.contactoption,'mail'))?1:0#">,
					is_contact_email	= <cfqueryparam cfsqltype="cf_sql_integer"	value="#(ListFind(Arguments.contactoption,'email'))?1:0#">,
					is_seminar			= <cfqueryparam cfsqltype="cf_sql_integer"	value="#(Arguments.wantsSeminar eq "")?0:Arguments.wantsSeminar#">,
					is_financing		= <cfqueryparam cfsqltype="cf_sql_integer"	value="#(Arguments.wantsFinancing eq "")?0:Arguments.wantsFinancing#">,
					lastPage			= 4,
					date_updated		= now()
				WHERE folio_id			= <cfqueryparam cfsqltype="cf_sql_integer"	value="#Arguments.contactID#">
			</cfquery>
		<cfelse>
			<cfset dumpStruct = {arguments=arguments, Local=Local}>
			<cfset fnCthulhuException(		scriptName="ProfileLead.cfc",
											message="Profile Lead Error",
											detail="Can't find lead in submitToLAD2Page3",
											dumpStruct=dumpStruct,
											errorCode=503)>
		</cfif>

		<cfquery datasource="myLocateadoc" name="Local.folioLead">
			SELECT folio_id, stateid, email, sid, firstname, lastname, city, stateid, zip as postalCode, procedure_ids
			FROM folio
			WHERE folio_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.contactID#">
		</cfquery>

		<!--- Beatuiful Living --->
		<cfif Arguments.wantsNewsletter eq 1>
			<cfset Local.state = model("State").findByKey(Local.folioLead.stateid)>
			<cfquery datasource="myLocateadoc" name="Local.qNewsletter">
				SELECT id
				FROM newsletter_subscribers
				WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Local.folioLead.email#">
			</cfquery>
			<cfif not Local.qNewsletter.recordCount>
				<cfquery datasource="myLocateadoc">
					INSERT INTO newsletter_subscribers
					SET sid				= <cfqueryparam cfsqltype="cf_sql_integer" value="#Local.folioLead.sid#">,
						firstname		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Local.folioLead.firstname#">,
						lastname		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Local.folioLead.lastname#">,
						email			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Local.folioLead.email#">,
						city			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Local.folioLead.city#">,
						state			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Local.state.name#">,
						zip				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Local.folioLead.postalCode#">,
						source_id		= #Local.LeadSourceId#,
						date_entered	= now()
				</cfquery>
			</cfif>
		</cfif>

		<cfcatch type="all">
			<cfset dumpStruct = {arguments=arguments, Local=Local}>
			<cfset fnCthulhuException(		scriptName="ProfileLead.cfc",
											message="Profile Lead Error",
											detail="Page 3 Profile Lead Update in function: submitToLAD2Page3",
											dumpStruct=dumpStruct,
											errorCode=503)>
		</cfcatch>
	</cftry>
	<cfreturn Local.folioLead>
</cffunction>

<cffunction name="getLAD2Leads">
	<cfargument name="doctorLocationID" required="true">

 	<CFQUERY DATASOURCE="myLocateadoc" NAME="qryLeads">
		<!--- <cfif ListFind(variables.leadTypes, "folio")> --->
		(
            SELECT
			SQL_CALC_FOUND_ROWS
			"folio" AS lead_type, f.sid AS doc_sid,	f.sid, f.folio_id AS id,
			f.email                      ,
			f.hphone                     ,
			f.wphone                     ,
			f.firstname                  ,
			f.firstname AS lead_firstname,
			f.lastname                   ,
			f.address                    ,
			f.city                       ,
			f.city AS lead_city          ,
			f.state                      ,
			f.zip                        ,
			f.is_lead_opened             ,
			f.comments,
			f.date,
			Date_format(f.date, "%Y-%m-%d %H:%i") AS new_date           ,
			Date_Format(f_responses.created_dt, '%m/%d/%y at %I:%i %p') AS 'Response_Dt'      ,
			i.doctor_entity_id                           ,
			i.info_id                                    ,
			i.firstname                            AS doc_first                     ,
			i.lastname                             AS doc_last                      ,
			concat( i.firstname, ' ', i.lastname ) AS doc_fullname                  ,
			i.lastname AS myname   ,
			i.city     AS doc_city ,
			i.state    AS doc_state,
			uf.budget_tx           ,
            uf.is_approved        ,
			##CONVERT( group_concat( DISTINCT dsm.sid ) USING latin1 )
			0 AS sids,
			##CONVERT( group_concat( DISTINCT dsm.is_basic ) USING latin1 )
			0 AS is_basics,
			lapp.date_end                ,
			lapph.date_end AS lapph_date_end,
			f.age			,
			f.gender		,
			f.height		,
			f.weight		,
			f.is_smoker		,
			f.procedure_name_ids,
			f.keywords as keywords,
			f.referral_internal as referrerInternal,
			if(NOT ISNULL(fsr.id), 1, 0) AS has_survey
		FROM
			doc_info i
			INNER JOIN folio f
			ON
				f.info_id = i.info_id
				AND
				f.is_active = 1
				AND
                f.is_duplicate = 0
                <!--- And
				f.date BETWEEN
				"#LSDateFormat(StartDate, "yyyy-mm-dd")#" AND
				"#LSDateFormat(EndDate, "yyyy-mm-dd")#" --->
				<!--- <cfif variables.leadDisplay EQ "Unopened">
					AND f.is_lead_opened = 0
				</cfif> --->

		    LEFT JOIN folio_responses f_responses
		    ON
		    	f.folio_id = f_responses.folio_id
			LEFT JOIN doc_specialty_mapped dsm
			ON
				dsm.info_id = i.info_id
			LEFT JOIN user_financing uf
			ON
				uf.email_tx = f.email
                And uf.is_approved = 1
				AND uf.budget_tx <> ''
			LEFT JOIN
				lad_account_products_purchased_mapped
				lappm
			ON
				lappm.info_id = i.info_id
			LEFT JOIN lad_account_products_purchased lapp
			ON
				lapp.purchased_id = lappm.purchased_id
			LEFT JOIN
				lad_account_products_purchased_history
				lapph
			ON
				lapph.purchased_id = lappm.purchased_id
			LEFT JOIN folio_survey_results fsr ON fsr.lead_id = f.folio_id AND fsr.lead_type = "Folio" AND fsr.is_active = 1
		WHERE 1=1
            AND
            <!--- <cfif ListFind(arguments.LeadTypes, "folio") EQ 0>
                    FALSE AND
            </cfif> --->
			i.info_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doctorLocationID#">
            <!--- <cfif isDefined("arguments.strctLeadIds.Folio")>
                AND f.folio_id in ( <cfqueryparam value="#arguments.strctLeadIds.Folio#"
                                                  list="#ListLen(strctLeadIds.Folio) GT 0#"
                                                  null="#ListLen(strctLeadIds.Folio) EQ 0#" >)
            </cfif> --->
		    and 1=1
		GROUP BY
			f.folio_id
		)
		<!--- </cfif> --->
		<!--- <cfif ListFind(variables.leadTypes, "folio") AND ListFind(variables.leadTypes, "mini")> --->
        UNION
		<!--- </cfif> --->
		<!--- <cfif ListFind(variables.leadTypes, "mini")> --->
			(SELECT
				<!--- <cfif Not ListFind(variables.LeadTypes, "folio")>
				SQL_CALC_FOUND_ROWS
				</cfif> --->
				"mini"  AS lead_type                ,
				uah.sid AS doc_sid                  ,
				uah.sid                             ,
                uah.id                               ,
				ua.email                            ,
				ua.hphone                           ,
				ua.wphone                           ,
				ua.firstname                        ,
				ua.firstname AS lead_firstname      ,
				ua.lastname                         ,
				ua.address                          ,
				ua.city                             ,
				ua.city AS lead_city                ,
				ua.state                            ,
				ua.zip                              ,
				uah.lead_opened as is_lead_opened   ,
				uah.comments,
				uah.date,
				uah.date AS new_date              ,
                (
		          Select Date_Format(created_dt, '%m/%d/%y at %I:%i %p') AS 'Response_Dt'
		          from user_accounts_hits_responses
		          where user_accounts_hits_id = uah.id
		          order by id desc limit 1
		        ) as Response_dt ,
				di.doctor_entity_id                 ,
				di.info_id                          ,
				di.firstname AS doc_first           ,
				di.lastname  AS doc_last            ,
				concat( di.firstname, ' ', di.lastname ) AS doc_fullname,
                 di.lastname as myname    ,
				di.city  AS doc_city    ,
				di.state AS doc_state   ,
                uf.budget_tx            ,
                uf.is_approved          ,
				ua.id as user_id        ,
				s.name                  ,
				s.name AS myname        ,
				s.date_updated 			,
				'' as age				,
				'' as gender			,
				'' as height			,
				'' as weight			,
				'' as is_smoker			,
				cast(uah.procedure_name_id as char) as procedure_name_ids,
				uah.keywords as keywords,
				uah.refererInternal as referrerInternal,
				if(NOT ISNULL(fsr.id), 1, 0) AS has_survey
			FROM
				( user_accounts_hits uah,
		        user_accounts ua,
		        doc_info di )
				LEFT JOIN specialty s
				    ON s.id = uah.sid
                LEFT JOIN user_financing uf
			        ON
						uf.email_tx = ua.email
                        And uf.is_approved = 1
						AND uf.budget_tx <> ''
				LEFT JOIN folio_mini_leads fml ON fml.info_id = uah.info_id AND fml.email = ua.email AND year(fml.created_dt) = year(uah.date) AND month(fml.created_dt) = month(uah.date) AND day(fml.created_dt) = day(uah.date)
				LEFT JOIN folio_survey_results fsr ON fsr.lead_id = fml.id AND fsr.lead_type = "Mini" AND fsr.is_active = 1
			WHERE
               <!---  <cfif ListFind(arguments.LeadTypes, "mini") EQ 0>
                    FALSE AND
                </cfif> --->
                uah.has_folio_lead = 0 AND
				uah.info_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doctorLocationID#">
                <!--- <cfif isDefined("arguments.strctLeadIds.Mini")>
                    AND uah.id in ( <cfqueryparam value="#arguments.strctLeadIds.Mini#"
                                                  list="#ListLen(strctLeadIds.Mini) GT 0#"
                                                  null="#ListLen(strctLeadIds.Mini) EQ 0#" >)
                </cfif> --->
                AND
				uah.is_cover_up = 1
				<!--- <CFIF variables.LeadDisplay EQ "UNOPENED" >
				    AND
				    uah.lead_opened = 0
                <cfelseif variables.LeadDisplay EQ "opened">
                    AND
                    uah.lead_opened > 0
		        </CFIF> --->
                AND
              	ua.id = uah.user_id
				AND
				di.info_id = uah.info_id
				<!--- AND
				uah.date BETWEEN
			        "#LSDateFormat(StartDate, "yyyy-mm-dd")#" AND
				    "#LSDateFormat(EndDate, "yyyy-mm-dd")#" --->
		        And
		        ua.is_active = 1
		        And uah.is_active = 1
                And uah.is_duplicate = 0
                And uah.has_folio_lead = 0
			GROUP BY uah.id
			)
		<!--- </cfif> --->
		<!--- <cfif (ListFind(variables.leadTypes, "folio") OR ListFind(variables.leadTypes, "mini")) AND ListFind(variables.leadTypes, "phone")> --->
		UNION
		<!--- </cfif> --->
		<!--- <cfif ListFind(variables.leadTypes, "phone")> --->
			( SELECT <!--- <cfif Not ListFind(variables.LeadTypes, "folio") AND Not ListFind(variables.LeadTypes, "mini")>
						SQL_CALC_FOUND_ROWS
					</cfif> --->
				DISTINCT
				"phone"                AS lead_type     ,
				"00"                   AS doc_sid       ,
				"00"                   AS sid           ,
				pl.id                                   ,
				"none"                 AS email         ,
				pl.caller_phone_number AS hphone        ,
				pl.caller_phone_number AS wphone        ,
				pl.caller_name         AS firstname     ,
				pl.caller_name         AS lead_firstname,
				pl.caller_name         AS lastname      ,
				pl.caller_address      AS address       ,
				pl.caller_city                          ,
				pl.caller_city AS lead_city             ,
				pl.caller_state                         ,
				pl.caller_zipcode                       ,
				pl.is_active   AS lead_opened             ,
				"" AS comments,
				pl.call_start AS DATE                    ,
				pl.call_length AS happy_date              ,
		        null AS 'Response_Dt'                     ,
				di.doctor_entity_id                       ,
				di.info_id                                ,
				di.firstname AS doc_first                 ,
				di.lastname  AS doc_last                  ,
				concat( di.firstname, ' ', di.lastname )
				              AS doc_fullname,
				pl.created_by AS myname      ,
				di.city       AS doc_city    ,
				di.state      AS doc_state   ,
				'' as budget_tx              ,
                false as is_approved         ,
				pl.is_active  AS is_cover_up ,
				pl.is_active                 ,
				pl.info_id AS not_folio_id   ,
				pl.created_dt				 ,
				'' as age				,
				'' as gender			,
				'' as height			,
				'' as weight			,
				'' as is_smoker			,
				'' as procedure_name_ids,
				'' as keywords,
				'' as referrerInternal,
				0 AS has_survey
			FROM
				( phoneplus_leads pl, doc_info di )
			WHERE
                <!--- <cfif ListFind(arguments.LeadTypes, "phone") EQ 0>
                    FALSE AND
                </cfif> --->
				pl.info_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doctorLocationID#">
                <!--- <cfif isDefined("arguments.strctLeadIds.Phone")>
                    AND pl.id in ( <cfqueryparam value="#arguments.strctLeadIds.Phone#"
                                                  list="#ListLen(strctLeadIds.Phone) GT 0#"
                                                  null="#ListLen(strctLeadIds.Phone) EQ 0#" >)
                </cfif> --->
                AND
				pl.info_id = di.info_id
				AND
				pl.is_active = 1
				<!--- AND
				pl.call_start BETWEEN
		            "#LSDateFormat(StartDate, "yyyy-mm-dd")#" AND
			        "#LSDateFormat(EndDate, "yyyy-mm-dd")#" --->
			)
			<!--- </cfif> --->
		    ORDER BY date DESC;
		</CFQUERY>

		<cfreturn qryLeads>
</cffunction>

</cfcomponent>