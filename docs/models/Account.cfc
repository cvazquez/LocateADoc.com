<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset hasMany("AccountProductsPurchasedHistories")>
		<cfset hasMany("AccountProductsPurchased")>
		<cfset hasMany("AccountPractices")>
		<cfset hasMany("Videos")>
	</cffunction>

	<cffunction name="GetManager" returntype="query">
		<cfargument name="accountID" required="true" type="numeric">

		<cfquery datasource="#get('dataSourceName')#" name="qManager">
			SELECT t.FirstName, t.LastName, t.Email
			FROM accounts a
			JOIN myMojo.test t On t.id = a.salesManagerId
			WHERE a.id = <cfqueryparam cfsqltype="cf_sql_int" value="#arguments.accountID#">
		</cfquery>

		<cfreturn qManager>
	</cffunction>

	<cffunction name="GetPDockUsername" returntype="string">
		<cfargument name="accountID" required="true" type="numeric">

		<cfquery datasource="#get('dataSourceName')#" name="qUsername">
			SELECT u.username_tx
			FROM accountprousers a
			JOIN myPro.pro_users u on a.proUserId = u.user_id
			WHERE a.accountId = <cfqueryparam cfsqltype="cf_sql_int" value="#arguments.accountID#">
		</cfquery>

		<cfreturn qUsername.username_tx>
	</cffunction>


	<cffunction name="GetPDockUsernames" returntype="query">
		<cfargument name="accountIDs" required="true">

		<cfquery datasource="#get('dataSourceName')#" name="qUsername">
			SELECT u.username_tx, u.email_tx
			FROM accountprousers a
			JOIN myPro.pro_users u on a.proUserId = u.user_id
			WHERE a.accountId IN (<cfqueryparam cfsqltype="cf_sql_int" value="#arguments.accountIDs#" list="true">)
		</cfquery>

		<cfreturn qUsername>
	</cffunction>

	<cffunction name="BasicPlusUnopenedLeadThreshold" returntype="boolean">
		<cfargument default="" name="accountId" required="true" type="numeric">
		<cfset var BPULTLocal = {}>

		<cfset BPULTLocal.qUnopenedLeadCount = "">
		<cfset BPULTLocal.unopenedLeadThreshold = false>


		<cfquery datasource="#get("datasourcename")#" name="BPULTLocal.qUnopenedLeadCount">
			call UnopenedLeads(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountId#">, "#Server.Settings.LocateADoc.BasicPlusLeadStartDate#");
		</cfquery>

		<cfif BPULTLocal.qUnopenedLeadCount.total GTE Server.Settings.LocateADoc.BasicPlusUnopenedLeadThreshold>
			<cfset BPULTLocal.unopenedLeadThreshold = true>
		</cfif>

		<cfreturn BPULTLocal.unopenedLeadThreshold>

	</cffunction>

	<cffunction name="BasicPlusAccountsUnopenedLeadThreshold" returntype="query">
		<cfargument name="limit" default="" required="false" type="numeric">

		<cfset var qBasicPlusAccountsUnopenedLeadThreshold = "">

		<cfquery datasource="#get('dataSourceName')#" name="qBasicPlusAccountsUnopenedLeadThreshold">
			SELECT acc.accountId, acc.accountName, sum(acc.UnopenedTotal) AS UnopenedTotal
			FROM
			(
				SELECT a.id AS accountId, a.name AS accountName, count(distinct(folio.folio_id)) AS UnopenedTotal
				FROM myLocateadoc.folio
				INNER JOIN accountdoctorlocations adl ON adl.id = folio.info_id
				INNER JOIN accountdoctors ad ON ad.id = adl.accountDoctorId
				INNER JOIN accountpractices ap ON ap.id = adl.accountPracticeId
				INNER JOIN accounts a ON a.id = ap.accountId AND a.deletedAt IS NULL
				INNER JOIN myLocateadoc3.accountdoctoremails ade On ade.accountDoctorId = ad.id AND ade.categories = "lead" AND ade.deletedAt IS NULL
				INNER JOIN myLocateadoc3.accountemails ae On ae.id = ade.accountEmailId AND ae.deletedAt IS NULL
				LEFT JOIN accountproductspurchased app ON app.accountId = a.id
				LEFT JOIN accountproductspurchased apph ON apph.accountId = a.id
				LEFT JOIN profilethresholdunopenedleademails pt ON pt.accountId = a.id AND pt.deletedAt IS NULL
				WHERE folio.info_id = adl.id AND folio.is_lead_opened = 0 AND folio.is_active = 1 AND folio.is_duplicate = 0
								AND folio.date >= (SELECT value FROM settings WHERE `key` = "BasicPlusLeadStartDate")
								AND app.id IS NULL AND apph.id IS NULL AND pt.id IS NULL
				GROUP BY a.id

				UNION ALL

				SELECT a.id AS accountId, a.name AS accountName, count(distinct(uah.id)) AS UnopenedTotal
				FROM myLocateadoc.user_accounts_hits uah
				INNER JOIN accountdoctorlocations adl ON adl.id = uah.info_id
				INNER JOIN accountdoctors ad ON ad.id = adl.accountDoctorId
				INNER JOIN accountpractices ap ON ap.id = adl.accountPracticeId
				INNER JOIN accounts a ON a.id = ap.accountId AND a.deletedAt IS NULL
				INNER JOIN myLocateadoc3.accountdoctoremails ade On ade.accountDoctorId = ad.id AND ade.categories = "lead" AND ade.deletedAt IS NULL
				INNER JOIN myLocateadoc3.accountemails ae On ae.id = ade.accountEmailId AND ae.deletedAt IS NULL
				LEFT JOIN accountproductspurchased app ON app.accountId = a.id
				LEFT JOIN accountproductspurchased apph ON apph.accountId = a.id
				LEFT JOIN profilethresholdunopenedleademails pt ON pt.accountId = a.id AND pt.deletedAt IS NULL
				WHERE uah.info_id = adl.id AND uah.lead_opened = 0 AND uah.is_active = 1 AND uah.has_folio_lead = 0 AND uah.is_duplicate = 0
								AND uah.date >= (SELECT value FROM settings WHERE `key` = "BasicPlusLeadStartDate")
								AND app.id IS NULL AND apph.id IS NULL AND pt.id IS NULL
				GROUP BY a.id
			) acc
			GROUP BY acc.accountId
			HAVING UnopenedTotal >= (SELECT value FROM settings WHERE `key` = "BasicPlusUnopenedLeadThreshold")
			<cfif isnumeric(arguments.limit)>
				LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limit#">
			</cfif>
		</cfquery>

		<cfreturn qBasicPlusAccountsUnopenedLeadThreshold>

	</cffunction>


	<cffunction name="CreateNew" hint="Create a new account from a Doctor's Only submission" returntype="struct">
		<cfargument required="true" type="numeric" name="doctorsOnlyPaymentId">

		<cfset var local.qNewDoctor = "">
		<cfset var siloObj = CreateObject("component", "com#Application.SharedModulesSuffix#.locateadoc.siloing.silo")>
		<cfset var local.createPDockUser = "">
		<cfset var local.qPDockUser = "">
		<cfset var local.createAccount = "">
		<cfset var local.qAccount = "">
		<cfset var local.CreateContact = "">
		<cfset var local.qAccountContact = "">
		<cfset var local.CreateAccountContact = "">
		<cfset var local.CreatePracticeContact = "">
		<cfset var local.qPractice = "">
		<cfset var local.qDoctor = "">
		<cfset var local.qWebsite = "">

		<cfset var local.accountId = "">
		<cfset var local.websiteId = "">
		<cfset var local.specialtyIds = "">

		<cfset var local.return = {}>

		<cfset local.return.success = false>

		<cfquery datasource="myLocateadocEdits" name="local.qNewDoctor">
			SELECT p.id AS paymentId, p.amount,
					d.salesForceAccountId,
					d.id AS doctorsOnlyId, d.`dr_first_name` AS firstName, d.`dr_last_name` AS lastName, d.`dr_designation` AS title, d.`dr_email` AS doctorEmail, d.`dr_website` aS website,
					d.`contact_first_name` AS contactFirstName, d.`contact_last_name` AS contactLastname, d.`contact_email` AS contactEmail,
					d.`practice_name` AS practiceName, d.`practice_phone` AS practicePhone, d.`practice_address_1` AS practiceAddress, d.`practice_address_2` AS practiceAddress2,
					 d.`practice_country_id` AS practiceCountryId, d.`practice_postal_code` AS practicePostalCode, d.`practice_city` AS practiceCity, d.`practice_state_id` AS practiceStateId,
					d.`passwordHash`,
					d.`specialty_id_1`, d.`specialty_id_2`, d.`specialty_id_3`, d.`specialty_id_4`, d.`procedure_ids` AS procedureIds, d.`suggested_specialty`, d.`suggested_procedure`,
					d.`contact_days`, d.`contact_times`, d.`contact_phone` AS contactPhone,
					d.`is_sent`, d.`info_id`, d.`forms_completed`,
					d.`keywords`, d.`referralfull`, d.`refering_site`, d.`ipAddress`, d.`refererInternal`, d.`entryPage`, d.`userAgent`, d.`cfId`, d.`cfToken`,
					d.`sf_campaign_id`, d.`medicalLicenseCode`, d.`physicianRepresentative`,
					d.`is_active`, d.`sentAt`, d.`created_by`, d.`created_dt`, d.`updated_by`, d.`updated_dt`, d.`deactivated_by`, d.`deactivated_dt`, d.`timestamp`,
					cities.id AS cityId
			FROM doctorsonlypayments p
			INNER JOIN myLocateadoc.`doctors_only_doctors` d ON d.id = p.doctorsOnlyId
			LEFT JOIN cities ON cities.name = d.practice_city AND cities.stateId = d.practice_state_id
			WHERE p.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doctorsOnlyPaymentId#">
		</cfquery>

		<cfset var local.sales = model("Territory").findOne(	SELECT		= "salesManagerid, salesAssistantId",
																WHERE		= "stateId = #local.qNewDoctor.practiceStateId#",
																returnAs	= "object")>


		<cflock name="NewLocateADocAccount" timeout="60">
		<cftransaction>

			<!--- <cfoutput>
				arguments.doctorsOnlyId = #local.qNewDoctor.doctorsOnlyId#<br />
				local.qNewDoctor.contactEmail = #local.qNewDoctor.contactEmail#</cfoutput><cfabort> --->

			<!--- Create a new pdock user with this username/password --->
			<cfquery datasource="myLocateadocEdits" name="local.createPDockUser">
				INSERT INTO myPro.`pro_users`
				SET	`sid` 				= <cfqueryparam cfsqltype="cf_sql_integer" value="#local.qNewDoctor.specialty_id_1#">,
					`sales_manager_id` 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#local.sales.salesManagerId#">,
					`username_tx` 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.contactEmail#">,
					`passwordHash`		= <cfqueryparam cfsqltype="cf_sql_char" value="#local.qNewDoctor.passwordHash#">,
					`firstname_tx` 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.firstName#">,
					`lastname_tx` 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.lastName#">,
					`email_tx` 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.doctorEmail#">,
					`title_tx`			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.title#">,
					`contact_firstname_tx`	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.contactFirstName#">,
					`contact_city_tx`	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.practiceCity#">,
					`contact_state_id`	= <cfqueryparam cfsqltype="cf_sql_integer" value="#local.qNewDoctor.practiceStateId#">,
					`contact_country_id`	= <cfqueryparam cfsqltype="cf_sql_integer" value="#local.qNewDoctor.practiceCountryId#">,
					`contact_zip_tx`	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.practicePostalCode#">,
					`contact_lastname_tx`	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.contactLastName#">,
					`contact_address_tx`	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.practiceAddress#">,
					`contact_email_tx`	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.contactEmail#">,
					`contact_phone_tx`	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.contactPhone#">,
					`is_lead_to_doc`	= 1,
					`is_cc_on_file`		= 1,
					`is_boctor_billed_monthly`	= 1,
					`db_created_dt`		= now(),
					`db_created_by`		= user_id,
					`is_active`			= 1,
					`noEmail`			= 0,
					`sales_css`			= 159
			</cfquery>

			<cfquery datasource="myLocateadocEdits" name="local.qPDockUser">
				SELECT last_insert_id() AS id
			</cfquery>


			<!--- Add to appropriate PracticeDock groups --->
			<cfquery datasource="myLocateadocEdits" name="local.AddToPDockGroups">
				INSERT INTO myPro.pro_user_groups (user_id, group_id)
				VALUES 	(#local.qpDockUser.id#, 2), /* Clients (PracticeDock) */
						(#local.qpDockUser.id#, 5081101),  /* LAD Account PRO Client User */
						(#local.qpDockUser.id#, 15082101) /* LAD Subscription */
			</cfquery>



			<!---  Create the account record --->
			<cfquery datasource="myLocateadocEdits" name="local.createAccount">
				INSERT INTO accounts (salesForceId, salesManagerId, salesAssistantId, name, leadVersion, leadViewVersion, createdAt, createdBy)
				VALUES (
						<cfif local.qNewDoctor.salesForceAccountId NEQ "">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.salesForceAccountId#">
						<cfelse>''</cfif>,
						#local.sales.salesManagerId#, #local.sales.salesAssistantId#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.qNewDoctor.practiceName)#">,
						1, 1, now(), #local.qPDockUser.id#)
			</cfquery>

			<cfquery datasource="myLocateadocEdits" name="local.qAccount">
				SELECT last_insert_id() AS id
			</cfquery>

			<cfset local.accountId = qAccount.id>

			<cfquery datasource="myLocateadocEdits" name="AddAccountIdToPayment">
				UPDATE doctorsonlypayments
				SET accountId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.accountId#">
				WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.qNewDoctor.paymentId#">
			</cfquery>


			<!--- Associate PracticeDock user with LocateADoc account --->
			<cfquery datasource="myLocateadocEdits" name="local.AssociatePDockLocateADoc">
				INSERT INTO accountprousers (proUserId, accountId, createdAt, createdBy)
				VALUES (#local.qPDockUser.id#, #local.accountId#, now(), #local.qPDockUser.id#)
			</cfquery>


			<!--- Setup a the Basic Plus product purchased --->
			<cfquery datasource="myLocateadocEdits" name="local.InsertProductPurchased">
				INSERT INTO `accountproductspurchased`
					(`accountId`, `accountProductId`, `amount`, `isPartial`, `isPayment`, notes, `dateStart`, `dateEnd`, `createdAt`, `createdBy`)
				VALUES
					(#local.accountId#, 12, #local.qNewDoctor.amount#, 0, 1, '', now(), date_add(now(), INTERVAL 100 YEAR), now(), #local.qPDockUser.id#);
			</cfquery>

			<cfquery datasource="myLocateadocEdits" name="local.qAccountProductsPurchased">
				SELECT last_insert_id() AS id
			</cfquery>


			<!--- Create Contact Record --->
			<cfquery datasource="myLocateadocEdits" name="local.CreateContact">
				INSERT INTo accountcontacts
				SET firstName	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.contactFirstName#">,
					lastName	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.contactLastName#">,
					address		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.practiceAddress#">,
					city		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.practiceCity#">,
					stateId		= <cfqueryparam cfsqltype="cf_sql_integer" value="#local.qNewDoctor.practiceStateId#">,
					countryId	= <cfqueryparam cfsqltype="cf_sql_integer" value="#local.qNewDoctor.practiceCountryId#">,
					zipCode		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.practicePostalCode#">,
					phone		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.contactPhone#">,
					createdAt	= now(),
					createdBy	= #qPDockUser.id#
			</cfquery>

			<cfquery datasource="myLocateadocEdits" name="local.qAccountContact">
				SELECT last_insert_id() AS id
			</cfquery>

			<cfquery datasource="myLocateadocEdits" name="local.CreateAccountContact">
				INSERT INTO accountcontactaccounts (accountId, accountContactId, createdAt, createdBy)
				VALUES (#local.accountId#, #local.qAccountContact.id#, now(), #qPDockUser.id#)
			</cfquery>


			<!--- Check if an email address exists for the contact --->
			<cfquery datasource="myLocateadocEdits" name="local.findContactEmail">
				SELECT id
				FROM accountemails
				WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.contactEmail#">
			</cfquery>

			<cfif local.findContactEmail.recordCount EQ 0>
				<!--- The contact email address doesn't exist, so insert it --->
				<cfquery datasource="myLocateadocEdits" name="local.CreateEmail">
					INSERT INTO accountemails (email, createdAt, createdBy)
					VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.contactEmail#">, now(), #qPDockUser.id#)
				</cfquery>

				<cfquery datasource="myLocateadocEdits" name="local.findContactEmail">
					SELECT last_insert_id() AS id
				</cfquery>

			<cfelse>
				<!--- Make sure it's active --->
				<cfquery datasource="myLocateadocEdits" name="local.CreateEmail">
					UPDATE accountemails
					SET deletedAt = NULL
					WHERE id = #local.findContactEmail.id#
				</cfquery>
			</cfif>

			<cfquery datasource="myLocateadocEdits" name="AssociateContactEmail">
				INSERT INTO accountaccountemails (accountId, accountEmailId, categories, createdAt, createdBy)
				VALUES (#local.accountId#, #local.findContactEmail.id#, "contact", now(), #qPDockUser.id#)
			</cfquery>





			<!--- Create Practice Record --->
			<cfquery datasource="myLocateadocEdits">
				INSERT INTO accountpractices (accountId, name, createdAt, createdBy)
				VALUES (#qAccount.id#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.practiceName#">,
						now(), #qPDockUser.id#
						)
			</cfquery>

			<cfquery datasource="myLocateadocEdits" name="local.qPractice">
				SELECT last_insert_id() as id
			</cfquery>

			<cfquery datasource="myLocateadocEdits" name="local.CreatePracticeContact">
				INSERT INTO accountcontactpractices (accountPracticeId, accountContactId, createdAt, createdBy)
				VALUES (#local.qPractice.id#, #local.qAccountContact.id#, now(), #qPDockUser.id#)
			</cfquery>

			<cfset local.accountDoctorId = local.qPractice.id + 1>

			<!--- Create Doctor Record --->
			<cfquery datasource="myLocateadocEdits">
				INSERT INTO accountdoctors
				(id, title, firstName, lastName, siloName, websiteLinkTemp, createdAt, createdBy)
				VALUES (#local.accountDoctorId#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.title#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.FIRSTNAME#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.LASTNAME#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.siloObj.CreateFolioSiloName(local.qNewDoctor.FIRSTNAME, local.qNewDoctor.LASTNAME)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.website#">,
					now(), #qPDockUser.id#
				)
			</cfquery>

			<cfquery datasource="myLocateadocEdits" name="local.qDoctor">
				SELECT last_insert_id() as id
			</cfquery>

			<!--- Check if a siloname exists --->
			<cfquery datasource="myLocateadocEdits" name="CheckDoctorSiloName">
				SELECT count(*) `exists`
				FROM accountdoctorsilonames
				WHERE siloName = "#local.siloObj.CreateFolioSiloName(local.qNewDoctor.FIRSTNAME, local.qNewDoctor.LASTNAME)#"
			</cfquery>

			<cfif CheckDoctorSiloName.exists EQ 0>
				<cfset local.doctorSiloName = local.siloObj.CreateFolioSiloName(local.qNewDoctor.FIRSTNAME, local.qNewDoctor.LASTNAME)>
			<cfelse>
				<!--- Doctor's silo name already exists. Append the doctor's id to it --->
				<cfset local.doctorSiloName = local.siloObj.CreateFolioSiloName(local.qNewDoctor.FIRSTNAME, local.qNewDoctor.LASTNAME) & "-" & local.accountDoctorId>
			</cfif>

			<cfquery datasource="myLocateadocEdits" name="CreateDoctorSiloName">
				INSERT INTO accountdoctorsilonames
				(accountDoctorId, siloName, isActive, createdAt, createdBy)
				VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#local.accountDoctorId#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.doctorSiloName#">,
					1,
					now(), #qPDockUser.id#
				)
			</cfquery>

			<!--- Check if an email address exists for the doctor --->
			<cfquery datasource="myLocateadocEdits" name="local.findDoctorEmail">
				SELECT id
				FROM accountemails
				WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.doctorEmail#">
			</cfquery>

			<cfif local.findDoctorEmail.recordCount EQ 0>
				<!--- The doctor email address doesn't exist, so insert it --->
				<cfquery datasource="myLocateadocEdits" name="local.CreateEmail">
					INSERT INTO accountemails (email, createdAt, createdBy)
					VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.doctorEmail#">, now(), #qPDockUser.id#)
				</cfquery>

				<cfquery datasource="myLocateadocEdits" name="local.findDoctorEmail">
					SELECT last_insert_id() AS id
				</cfquery>

			<cfelse>
				<!--- Make sure it's active --->
				<cfquery datasource="myLocateadocEdits" name="local.CreateEmail">
					UPDATE accountemails
					SET deletedAt = NULL
					WHERE id = #local.findDoctorEmail.id#
				</cfquery>
			</cfif>

			<cfquery datasource="myLocateadocEdits" name="AssociateDoctorEmail">
				INSERT INTO accountdoctoremails (accountDoctorId, accountEmailId, categories, createdAt, createdBy)
				VALUES (#local.accountDoctorId#, #local.findDoctorEmail.id#, "doctor", now(), #qPDockUser.id#),
						(#local.accountDoctorId#, #local.findDoctorEmail.id#, "lead", now(), #qPDockUser.id#),
						(#local.accountDoctorId#, #local.findDoctorEmail.id#, "enews", now(), #qPDockUser.id#)
			</cfquery>



			<!--- Create Address Location record --->
			<cfquery datasource="myLocateadocEdits">
				INSERT IGNORE INTO accountlocations
				(countryId, stateId, address, cityId, postalCode, phone, createdAt, createdBy)
				VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#local.qNewDoctor.practiceCountryId#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#local.qNewDoctor.practiceStateId#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.practiceAddress#">,
                <cfif isnumeric(local.qNewDoctor.cityId)>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#local.qNewDoctor.cityId#">
				<cfelse>
					NULL
				</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.practicePostalCode#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.practicePhone#">,
                now(),
				<cfqueryparam cfsqltype="cf_sql_integer" value="#qPDockUser.id#">
                )
			</cfquery>

			<cfquery datasource="myLocateadocEdits" name="local.qAccountLocation">
				SELECT last_insert_id() AS id
			</cfquery>


			<!--- Associate the Doctor Marketing id as the source of this new account  --->
			<cfquery datasource="myLocateadocEdits">
				INSERT IGNORE INTO accountlocationsources (accountLocationId, dbSourceId, createdAt, createdBy)
				VALUES (#local.qAccountLocation.id#, 42, now(),
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#qPDockUser.id#">)
			</cfquery>


			<!--- Map the Practice, Doctor and Location records --->
			<cfquery datasource="myLocateadocEdits">
				INSERT INTO accountdoctorlocations (accountPracticeId, accountDoctorId, accountLocationId, createdAt, createdBy)
				VALUES (#local.qPractice.id#, #local.accountDoctorId#, #local.qAccountLocation.id#, now(), #qPDockUser.id#)
			</cfquery>

			<cfquery datasource="myLocateadocEdits" name="local.qAccountDoctorLocation">
				SELECT last_insert_id() AS id
			</cfquery>


			<!--- Create a website record if it exists --->
			<cfset local.websiteId = "">
			<cfif local.qNewDoctor.website NEQ "">
				<cfquery datasource="myLocateadocEdits">
					INSERT INTO accountwebsites (url, createdAt, createdBy)
					VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qNewDoctor.website#">, now(), #qPDockUser.id#)
				</cfquery>

				<cfquery datasource="myLocateadocEdits" name="local.qWebsite">
					SELECT last_insert_id() AS id
				</cfquery>

				<cfset local.websiteId = qWebsite.id>
			</cfif>


			<!--- Associate Specialties with each doctor's office location --->
			<cfset local.specialtyIds = "">
			<cfif isnumeric(local.qNewDoctor.specialty_id_1)>
				<cfset local.specialtyIds = listAppend(local.specialtyIds, local.qNewDoctor.specialty_id_1)>
			</cfif>
			<cfif isnumeric(local.qNewDoctor.specialty_id_2)>
				<cfset local.specialtyIds = listAppend(local.specialtyIds, local.qNewDoctor.specialty_id_2)>
			</cfif>
			<cfif isnumeric(local.qNewDoctor.specialty_id_3)>
				<cfset local.specialtyIds = listAppend(local.specialtyIds, local.qNewDoctor.specialty_id_3)>
			</cfif>
			<cfif isnumeric(local.qNewDoctor.specialty_id_4)>
				<cfset local.specialtyIds = listAppend(local.specialtyIds, local.qNewDoctor.specialty_id_4)>
			</cfif>

			<cfloop list="#local.specialtyIds#" index="i">
				<cfif isnumeric(i) AND structKeyExists(Application.strctSpecialty, i)>
					<cfquery datasource="myLocateadocEdits">
						INSERT IGNORE INTO accountlocationspecialties (specialtyId, accountDoctorLocationId, accountWebsiteId, createdAt, createdBy)
						VALUES (#i#, #local.qAccountDoctorLocation.id#, <cfif val(local.websiteId) GT 0>#local.websiteId#<cfelse>NULL</cfif>, now(), #qPDockUser.id#)
					</cfquery>


					<cfquery datasource="myLocateadocEdits" name="AssociateSpecialtiesAndProduct">
						INSERT INTO `accountproductspurchaseddoctorlocations`
						(`accountDoctorLocationId`, `specialtyId`, `accountProductsPurchasedId`, `createdAt`, `createdBy`)
						VALUES (#local.qAccountDoctorLocation.id#, #i#, #local.qAccountProductsPurchased.id#, now(), #qPDockUser.id#);
					</cfquery>
				</cfif>
			</cfloop>


			<!--- Associate procedures with the doctor --->
			<cfloop list="#local.qNewDoctor.procedureIds#" index="i">
				<cfif isnumeric(i)>
					<cfquery datasource="myLocateadocEdits">
						INSERT IGNORE INTO accountdoctorprocedures (accountDoctorId, procedureId, createdAt, createdBy)
						VALUES (#local.accountDoctorId#, #i#, now(), #qPDockUser.id#)
					</cfquery>
				</cfif>
			</cfloop>


			<cfquery datasource="myLocateadocEdits" name="UpdateDoctorsOnly">
				UPDATE myLocateadoc.doctors_only_doctors
				SET info_id = #local.qAccountDoctorLocation.id#
				WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.qNewDoctor.doctorsOnlyId#">
			</cfquery>


			<cfset variables.accountId = local.accountId> <!--- arguments and local variables don't seem to work in cfthread' --->
			<cfset SummaryTableUpdate()>

			<cfset local.return.success = true>
		</cftransaction>
		</cflock>

		<cfset local.return.login = local.qNewDoctor.doctorEmail>
		<cfset local.return.receiptTo = local.qNewDoctor.contactEmail>
		<cfset local.return.doctor = {}>
		<cfset local.return.doctor.firstName = local.qNewDoctor.firstName>
		<cfset local.return.doctor.lastName = local.qNewDoctor.lastName>
		<cfset local.return.doctor.title = local.qNewDoctor.title>
		<cfset local.return.doctor.userName = local.qNewDoctor.doctorEmail>
		<cfset local.return.doctor.siloname = local.doctorSiloName>
		<cfset local.return.doctor.accountId = local.accountId>

		<cfreturn local.return>

	</cffunction>


<cffunction name="SummaryTableUpdate" access="private">

	<cfif isnumeric(variables.accountId)>
		<cfthread action="run" name="AccountDoctorSearchSummarySingle#variables.accountId#">
			<cftry>
				<cfquery datasource="myLocateadocEdits">
					call AccountDoctorSearchSummarySingle(#variables.accountId#);
				</cfquery>

				<cfcatch type="any">
					<cfmail to="lad3_errors@locateadoc.com"
							from="lad3_errors@locateadoc.com"
							subject="AccountDoctorSearchSummarySingle Thread Error"
							type="html">
						<p>#cgi.SCRIPT_NAME#</p>

						<p>
						CALL AccountDoctorSearchSummarySingle();
						</p>

						<cfdump var="#CFCATCH#" label="CFCATCH">
						<cfdump var="#client#" label="CLIENT">
						<cfdump var="#CGI#" label="CGI">
					</cfmail>
				</cfcatch>
			</cftry>
		</cfthread>

		<cfthread action="run" name="AccountDoctorSearchFilterSummarySingle#variables.accountId#">
			<cftry>
				<cfquery datasource="myLocateadocEdits">
					call AccountDoctorSearchFilterSummarySingle(#variables.accountId#);
				</cfquery>
			<cfcatch type="any">
					<cfmail to="lad3_errors@locateadoc.com"
							from="lad3_errors@locateadoc.com"
							subject="AccountDoctorSearchFilterSummarySingle Thread Error"
							type="html">
						<p>#cgi.SCRIPT_NAME#</p>

						<p>
						CALL AccountDoctorSearchFilterSummarySingle();
						</p>

						<cfdump var="#CFCATCH#" label="CFCATCH">
						<cfdump var="#client#" label="CLIENT">
						<cfdump var="#CGI#" label="CGI">
					</cfmail>
				</cfcatch>
			</cftry>
		</cfthread>

		<cfthread action="run" name="AccountProductsPurchasedSummaryAll#variables.accountId#">
			<cftry>
				<cfquery datasource="myLocateadocEdits">
					call AccountProductsPurchasedSummaryAll(#variables.accountId#);
				</cfquery>
			<cfcatch type="any">
					<cfmail to="lad3_errors@locateadoc.com"
							from="lad3_errors@locateadoc.com"
							subject="AccountProductsPurchasedSummaryAll Thread Error"
							type="html">
						<p>#cgi.SCRIPT_NAME#</p>

						<p>
						CALL AccountProductsPurchasedSummaryAll();
						</p>

						<cfdump var="#CFCATCH#" label="CFCATCH">
						<cfdump var="#client#" label="CLIENT">
						<cfdump var="#CGI#" label="CGI">
					</cfmail>
				</cfcatch>
			</cftry>
		</cfthread>

		<cfthread action="run" name="AccountProductsPurchasedProcedureSummaryAll#variables.accountId#">
			<cftry>
				<cfquery datasource="myLocateadocEdits">
					call AccountProductsPurchasedProcedureSummaryAll(#variables.accountId#);
				</cfquery>

				<cfcatch type="any">
					<cfmail to="lad3_errors@locateadoc.com"
							from="lad3_errors@locateadoc.com"
							subject="AccountProductsPurchasedProcedureSummaryAll Thread Error"
							type="html">
						<p>#cgi.SCRIPT_NAME#</p>

						<p>
						CALL AccountProductsPurchasedProcedureSummaryAll();
						</p>

						<cfdump var="#CFCATCH#" label="CFCATCH">
						<cfdump var="#client#" label="CLIENT">
						<cfdump var="#CGI#" label="CGI">
					</cfmail>
				</cfcatch>
			</cftry>
		</cfthread>
	</cfif>
</cffunction>
</cfcomponent>