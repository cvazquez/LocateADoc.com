<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<!--- Associations --->
		<cfset hasMany(name="accountDoctorLocations", shortcut="accountPractices")>
		<cfset hasMany(name="accountDoctorLocations", shortcut="accountLocations")>
		<cfset hasMany(name="accountDoctorProcedures", shortcut="procedures")>
		<cfset hasMany(name="accountDoctorCertifications", shortcut="certifications")>
		<cfset hasMany(name="accountDoctorInsiderQuestionAnswers", shortcut="insiderQuestions")>
		<cfset hasMany(name="accountDoctorSpecialtyTopProcedures")>
		<cfset hasMany(name="galleryCaseDoctors", shortcut="galleryCases")>
		<cfset hasMany(name="accountDoctorCreditCards", shortcut="creditCard")>
		<cfset hasMany(name="accountDoctorAssociation", shortcut="association")>
		<cfset hasMany(name="accountDoctorInsurance", shortcut="insurance")>
		<cfset hasMany(name="profileMiniLeads")>
		<cfset hasMany(name="accountDoctorSiloNames")>

		<!--- Calculated Properties --->
		<cfset property(name="fullName",
						sql="CONCAT(firstName, IF(middleName<>'',CONCAT(' ',middleName),''), ' ', lastName)")>
		<cfset property(name="fullNameWithTitle",
						sql="CONCAT(firstName, IF(middleName<>'',CONCAT(' ',middleName),''), ' ', lastName, IF(title<>'',CONCAT(', ',title),''))")>
	</cffunction>

	<cffunction name="GetProfile" returntype="query">
		<cfargument name="accountDoctorId" required="true" type="numeric">

		<cfset var qProfile = "">

		<cfquery datasource="#get('dataSourceName')#" name="qProfile">
			SELECT accountdoctors.id,accountdoctors.googlePlusId,accountdoctors.firstName,accountdoctors.middleName,accountdoctors.lastName,accountdoctors.title,accountdoctors.gender,accountdoctors.yearsInPractice,cast(accountdoctors.yearStartedPracticing AS UNSIGNED) AS yearStartedPracticing,accountdoctors.patientsPerWeek,accountdoctors.headline,accountdoctors.pledge,accountdoctors.education,accountdoctors.affiliation,accountdoctors.financing,accountdoctors.photoFilename,accountdoctors.question1,accountdoctors.question2,accountdoctors.question3,accountdoctors.question4,accountdoctors.question5,accountdoctors.question6,accountdoctors.patientTestimonial,accountdoctors.patientName,accountdoctors.patientOccupation,accountdoctors.patientPhoto,accountdoctors.consultationCost,accountdoctors.consultationCost1,accountdoctors.consultationCost2,accountdoctors.consultPrice,accountdoctors.consultDiscount,accountdoctors.isTileadToWebsite,accountdoctors.isEmailText,accountdoctors.isShutOffLeads,accountdoctors.isLowQualityLead,accountdoctors.hasMap,accountdoctors.isFinancingOn,
			(CONCAT(firstName, IF(middleName<>'',CONCAT(' ',middleName),''), ' ', lastName, IF(title<>'',CONCAT(', ',title),''))) AS fullNameWithTitle,(CONCAT(firstName, IF(middleName<>'',CONCAT(' ',middleName),''), ' ', lastName)) AS fullName,
				accountdoctorsilonames.id AS accountDoctorSiloNameid,accountdoctorsilonames.accountDoctorId AS accountDoctorSiloNameaccountDoctorId,accountdoctorsilonames.siloName AS siloName,accountdoctorsilonames.isActive AS accountDoctorSiloNameisActive
			FROM accountdoctors
			LEFT OUTER JOIN accountdoctorsilonames ON accountdoctors.id = accountdoctorsilonames.accountDoctorId AND accountdoctorsilonames.isActive = 1
			WHERE accountdoctors.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorId#">
					AND	accountdoctors.deletedAt IS NULL AND accountdoctorsilonames.deletedAt IS NULL
			ORDER BY accountdoctors.id ASC
		</cfquery>

		<cfreturn qProfile>
	</cffunction>

	<cffunction name="practiceDoctorsByDoctorId">
		<cfargument name="doctorID" required="true">

		<cfset var practice = model("AccountDoctorLocation").findOneByAccountDoctorId(arguments.doctorId)>
		<cfreturn practice.accountDoctors(order="firstName")>
	</cffunction>

	<cffunction name="HasCallTracking" returntype="boolean">
		<cfargument name="doctorID" required="true">

		<cfset var qCallTracking = "">

		<cfquery datasource="#get("datasourcename")#" name="qCallTracking">
			SELECT count(*) AS ifExists
			FROM accountdoctorlocations a
			JOIN accountproductspurchaseddoctorlocations b on a.id = b.accountdoctorlocationid
			JOIN accountproductspurchased c ON b.accountProductsPurchasedId = c.id
			WHERE a.accountdoctorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doctorID#">
			AND a.deletedAt is null
			AND c.accountProductId = 7
			AND now() <= c.dateEnd;
		</cfquery>

		<cfquery datasource="#get("datasourcename")#" name="qFeatured">
			SELECT count(*) AS ifExists
			FROM accountdoctorlocations a
			JOIN accountproductspurchaseddoctorlocations b on a.id = b.accountdoctorlocationid
			JOIN accountproductspurchased c ON b.accountProductsPurchasedId = c.id
			WHERE a.accountdoctorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doctorID#">
			AND a.deletedAt is null
			AND c.accountProductId = 1
			AND now() <= c.dateEnd;
		</cfquery>

		<cfreturn ((qCallTracking.ifExists GT 0 AND qFeatured.ifExists GT 0) ? TRUE : FALSE)>
	</cffunction>

	<cffunction name="BasicPlus" returntype="boolean">
		<cfargument name="doctorID" required="true">

		<cfset var qBasicPlus = "">


		<!--- Check if they are a paid basic plus --->
		<cfquery datasource="#get("datasourcename")#" name="qPaidBasicPlus">
			SELECT count(*) AS ifExists
			FROM accountdoctors aD
			INNER JOIN accountdoctorlocations adl ON adl.accountDoctorId = aD.id AND adl.deletedAt IS NULL
			INNER JOIN accountdoctoremails aDE ON aDE.accountDoctorId = aD.id AND aDE.categories = "lead" AND aDE.deletedAt IS NULL
			INNER JOIN accountpractices aP ON aP.id = adl.accountPracticeId AND aP.deletedAt IS NULL
			INNER JOIN accountproductspurchased app ON app.accountId = aP.accountId AND
										app.accountProductId = 12 AND
										app.dateStart <= now() AND
										app.dateEnd > date(date_add(now(), INTERVAL 1 day)) AND
										app.deletedAt IS NULL
			WHERE aD.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doctorID#"> AND aD.deletedAt IS NULL;
		</cfquery>

		<cfif qpaidBasicPlus.ifExists GT 0>
			<cfreturn true>
		</cfif>


		<!--- Check if they are a free basic plus --->
		<cfquery datasource="#get("datasourcename")#" name="qBasicPlus">
			SELECT count(*) AS ifExists
			FROM accountdoctors aD
			INNER JOIN accountdoctorlocations adl ON adl.accountDoctorId = aD.id AND adl.deletedAt IS NULL
			INNER JOIN accountdoctoremails aDE ON aDE.accountDoctorId = aD.id AND aDE.categories = "lead" AND aDE.deletedAt IS NULL
			INNER JOIN accountpractices aP ON aP.id = adl.accountPracticeId AND aP.deletedAt IS NULL
			LEFT JOIN accountproductspurchased app ON app.accountId = aP.accountId AND app.deletedAt IS NULL
			LEFT JOIN accountproductspurchasedhistory apph ON apph.accountId = aP.accountId AND apph.deletedAt IS NULL
			WHERE aD.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doctorID#"> AND aD.deletedAt IS NULL
				AND app.id IS NULL AND apph.id IS NULL;
		</cfquery>


		<cfreturn (qBasicPlus.ifExists GT 0 ? TRUE : FALSE)>
	</cffunction>

	<cffunction name="BasicPlusOver2Leads" returntype="boolean">
		<cfargument name="accountDoctorId" type="numeric" required="true">
		<cfset var Local = {}>

		<cfset Local.account = model("AccountDoctor")
								.findAll(
									include		= "accountDoctorLocations(accountPractice)",
									select		= "accountId as id",
									where		= "accountDoctorId = #arguments.accountDoctorId#"
								)>

		<!--- <cfquery datasource="myLocateadoc" name="Local.FolioLeads">
			SELECT count(distinct(f.folio_id)) AS folio_lead_count
			FROM lad_account_entities lae
			INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id
			INNER JOIN folio f ON f.info_id = di.info_id AND year(f.date) = year(now()) AND month(f.date) = month(now()) AND f.is_duplicate = 0 AND f.is_active = 1
			WHERE lae.account_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Local.account.id#">
		</cfquery>

		<cfquery datasource="myLocateadoc" name="Local.MiniLeads">
			SELECT count(distinct(uah.id)) AS mini_lead_count
			FROM lad_account_entities lae
			INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id
			INNER JOIN user_accounts_hits uah ON uah.info_id = di.info_id AND year(uah.date) = year(now()) AND month(uah.date) = month(now()) AND uah.is_cover_up = 1 AND uah.is_active = 1 AND uah.has_folio_lead = 0
			WHERE lae.account_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Local.account.id#">
		</cfquery>

		<cfif Local.FolioLeads.folio_lead_count + Local.MiniLeads.mini_lead_count gte Server.Settings.LocateADoc.BasicPlusLeadThreshold> --->
		<cfstoredproc procedure="BasicPlusLeadCount" datasource="myLocateadocEdits">
			<cfprocresult name="qryLeads">
			<cfprocparam cfsqltype="cf_sql_integer" value="#Local.account.id#">
			<cfprocparam cfsqltype="cf_sql_date" value="#Server.Settings.LocateADoc.BasicPlusLeadStartDate#">
		</cfstoredproc>

		<cfif qryLeads.leadCount gte Server.Settings.LocateADoc.BasicPlusLeadThreshold>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>

	</cffunction>

	<cffunction name="BasicPlusOverLeadThreshold" returntype="boolean">
		<cfargument name="accountDoctorId" type="numeric" required="true">
		<cfset var Local = {}>

		<cfif not BasicPlus(arguments.accountDoctorId)><cfreturn false></cfif>

		<cfset Local.account = model("AccountDoctor")
								.findAll(
									include		= "accountDoctorLocations(accountPractice)",
									select		= "accountId as id",
									where		= "accountDoctorId = #arguments.accountDoctorId#"
								)>

		<!--- <cfquery datasource="myLocateadoc" name="Local.FolioLeads">
			SELECT count(distinct(f.folio_id)) AS folio_lead_count
			FROM lad_account_entities lae
			INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id
			INNER JOIN folio f ON f.info_id = di.info_id AND year(f.date) = year(now()) AND month(f.date) = month(now()) AND f.is_duplicate = 0 AND f.is_active = 1
			WHERE lae.account_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Local.account.id#">
		</cfquery>

		<cfquery datasource="myLocateadoc" name="Local.MiniLeads">
			SELECT count(distinct(uah.id)) AS mini_lead_count
			FROM lad_account_entities lae
			INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id
			INNER JOIN user_accounts_hits uah ON uah.info_id = di.info_id AND year(uah.date) = year(now()) AND month(uah.date) = month(now()) AND uah.is_cover_up = 1 AND uah.is_active = 1 AND uah.has_folio_lead = 0
			WHERE lae.account_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Local.account.id#">
		</cfquery>

		<cfif Local.FolioLeads.folio_lead_count + Local.MiniLeads.mini_lead_count eq Server.Settings.LocateADoc.BasicPlusLeadThreshold> --->
		<cfstoredproc procedure="BasicPlusLeadCount" datasource="myLocateadocEdits">
			<cfprocresult name="qryLeads">
			<cfprocparam cfsqltype="cf_sql_integer" value="#Local.account.id#">
			<cfprocparam cfsqltype="cf_sql_date" value="#Server.Settings.LocateADoc.BasicPlusLeadStartDate#">
		</cfstoredproc>

		<cfif qryLeads.leadCount eq Server.Settings.LocateADoc.BasicPlusLeadThreshold>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>

	</cffunction>

	<cffunction name="Basic" returntype="boolean">
		<cfargument name="doctorID" required="true">

		<cfset var qBasic = "">

		<cfquery datasource="#get("datasourcename")#" name="qBasic">
			SELECT count(*) AS ifExists
			FROM accountdoctors aD
			INNER JOIN accountdoctorlocations adl ON adl.accountDoctorId = aD.id AND adl.deletedAt IS NULL
			INNER JOIN accountpractices aP ON aP.id = adl.accountPracticeId AND aP.deletedAt IS NULL
			LEFT JOIN accountdoctoremails aDE ON aDE.accountDoctorId = aD.id AND aDE.categories = "lead" AND aDE.deletedAt IS NULL
			LEFT JOIN accountproductspurchased app ON app.accountId = aP.accountId AND app.deletedAt IS NULL
			LEFT JOIN accountproductspurchasedhistory apph ON apph.accountId = aP.accountId AND apph.deletedAt IS NULL
			WHERE aD.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doctorID#"> AND aD.deletedAt IS NULL
				AND app.id IS NULL AND apph.id IS NULL AND aDE.id IS NULL;
		</cfquery>

		<cfreturn (qBasic.ifExists GT 0 ? TRUE : FALSE)>
	</cffunction>

	<cffunction name="Yext" returntype="boolean">
		<cfargument name="doctorID" required="true">

		<cfset var qYext = "">

		<cfquery datasource="#get("datasourcename")#" name="qYext">
			SELECT count(*) AS ifExists
			FROM accountdoctors aD
			INNER JOIN accountdoctorassociations ada ON ada.accountDoctorId = aD.id AND ada.associationId = 7 AND ada.deletedAt IS NULL
			INNER JOIN accountdoctorlocations adl ON adl.accountDoctorId = aD.id AND adl.deletedAt IS NULL
			INNER JOIN accountpractices aP ON aP.id = adl.accountPracticeId AND aP.deletedAt IS NULL
			WHERE aD.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doctorID#"> AND aD.deletedAt IS NULL
		</cfquery>

		<cfreturn (qYext.ifExists GT 0 ? TRUE : FALSE)>
	</cffunction>

</cfcomponent>