<cfcomponent extends="Controller" output="false">

	<cffunction name="setPracticeRank">
		<cfsetting requesttimeout="600">

		<cfset oDCV = createObject("component", "models.DashboardClientsVisual")>

		<!--- Check for any PracticeRank data created today. If any exists, stop. --->
		<cfquery datasource="#get('dataSourceName')#" name="runOnceCheck">
			SELECT 1
			FROM accountproductspurchasedpracticerankscorehistory
			WHERE createdAt > '#DateFormat(now(),"yyyy-mm-dd")# 00:00:00'
			LIMIT 1
		</cfquery>
		<!--- <cfif runOnceCheck.recordcount gt 0>
			<cfabort>
		</cfif> --->

		<!--- Define Constants --->
		<cfset constants = {}>
		<!--- <cfset constants.PPWeight = 3010>
		<cfset constants.SELGWeight = 334>
		<cfset constants.AgeWeight = 1008>
		<cfset constants.CPLWeight = 1> --->
		<cfset constants.PPWeight = 7500>
		<cfset constants.AgeWeight = 2000>
		<cfset constants.BAAGWeight = 1000>
		<cfset constants.CPLWeight = 1000>
		<cfset constants.ProfileWeight = 500>
		<cfset constants.LongevityWeight = 500>

		<cfset constants.NewDuration = 14>
		<cfset constants.ExpiringUpDuration = 14>
		<cfset constants.ExpiringPeakDuration = 2>
		<cfset constants.ExpiringDownDuration = 30>

		<cfset constants.BAAGThreshold = 1000>
		<cfset constants.BAAGFrequencyThreshold = 15>
		<cfset constants.CPLThreshold = 2000>
		<cfset constants.LongevityThreshold = 10>

		<cfset constants.BAAGFrequencyMultiplier = 1>

		<cfset currentAccount = 0>
		<cfset ProfileComplete = 0>
		<cfset yearsOfService = 0>

		<!--- Retrieve all records for featured listings --->
		<cfquery datasource="#get('dataSourceName')#" name="featuredListings">
			SELECT dataA.*, CASE WHEN dataB.CPL IS NULL THEN 0 ELSE dataB.CPL END AS CPL
				,(SELECT 1 FROM accountproductspurchased app2
				  JOIN accountproductspurchaseddoctorlocations appdl2 on app2.id = appdl2.accountProductsPurchasedId
				  WHERE app2.accountproductid = 5
				  AND appdl2.accountDoctorLocationId = dataA.accountDoctorLocationId
				  AND appdl2.specialtyId = dataA.specialtyId
				  AND now() <= app2.dateEnd	LIMIT 1) as topSpot
				,(SELECT 1 FROM accountproductspurchased app2
				  JOIN accountproductspurchaseddoctorlocations appdl2 on app2.id = appdl2.accountProductsPurchasedId
				  WHERE app2.accountproductid = 4
				  AND appdl2.accountDoctorLocationId = dataA.accountDoctorLocationId
				  AND appdl2.specialtyId = dataA.specialtyId
				  AND now() <= app2.dateEnd	LIMIT 1) as secondSpot
				,(SELECT 1 FROM accountproductspurchased app2
				  JOIN accountproductspurchaseddoctorlocations appdl2 on app2.id = appdl2.accountProductsPurchasedId
				  WHERE app2.accountproductid = 9
				  AND appdl2.accountDoctorLocationId = dataA.accountDoctorLocationId
				  AND appdl2.specialtyId = dataA.specialtyId
				  AND now() <= app2.dateEnd	LIMIT 1) as thirdSpot
				,(SELECT 1 FROM accountproductspurchased app2
				  JOIN accountproductspurchaseddoctorlocations appdl2 on app2.id = appdl2.accountProductsPurchasedId
				  WHERE app2.accountproductid = 10
				  AND appdl2.accountDoctorLocationId = dataA.accountDoctorLocationId
				  AND appdl2.specialtyId = dataA.specialtyId
				  AND now() <= app2.dateEnd	LIMIT 1) as fourthSpot
			FROM(
				SELECT DISTINCT app.id, app.accountid, datediff(now(),app.dateStart) as age,
					datediff(app.dateEnd,now()) as timeLeft, count(apph.id) as historycount,
					appdl.accountDoctorLocationId, appdl.specialtyId, appdl.practiceRankScore,
					<!--- FLOOR(DATEDIFF(now(),CASE WHEN min(apph.dateStart) IS NOT NULL THEN min(apph.dateStart) ELSE app.dateStart END)/365) AS yearsServiced, --->
					CAST(GROUP_CONCAT(CONCAT(apph.dateStart,'|',CASE WHEN now() > apph.dateEnd THEN apph.dateEnd ELSE DATE(now()) END)) AS CHAR) as dateSpans,
					CAST(CASE WHEN now() > app.dateStart THEN CONCAT(app.dateStart,'|',DATE(now())) ELSE '' END AS CHAR) as currentDateSpan,
					(SELECT count(1)
						FROM gallerycasedoctors gcd JOIN gallerycases gc ON gcd.galleryCaseId = gc.id
						WHERE gcd.accountdoctorid = adl.accountDoctorId
						AND gc.deletedAt IS NULL) AS BAAGCases,
					(SELECT count(DISTINCT DATE(gc.createdAt))
						FROM gallerycasedoctors gcd JOIN gallerycases gc ON gcd.galleryCaseId = gc.id
						WHERE gcd.accountdoctorid = adl.accountDoctorId
						AND gc.createdAt > DATE_ADD(now(),INTERVAL -30 DAY)
						AND gc.deletedAt IS NULL) AS BAAGFrequency
				FROM accountproductspurchased app
					LEFT OUTER JOIN accountproductspurchasedhistory apph on apph.accountId = app.accountId
					JOIN accountproductspurchaseddoctorlocations appdl on app.id = appdl.accountProductsPurchasedId
					JOIN accountdoctorlocations adl on appdl.accountDoctorLocationId = adl.id
				WHERE app.deletedAt is null
					AND appdl.deletedAt is null
					AND app.accountProductId = 1
					AND now() <= app.dateEnd
				GROUP BY app.id, appdl.accountDoctorLocationId, appdl.specialtyId
			) dataA
			JOIN(
				SELECT dataC.accountid,
					(SELECT cplFolioPhonePlusMini FROM accountproductspurchasedcplreports
					 WHERE accountproductspurchasedcplreports.accountid = dataC.accountid
					 ORDER BY createdAt desc LIMIT 1) as CPL
				  FROM(
					SELECT DISTINCT app.accountid
					FROM accountproductspurchased app
					WHERE app.deletedAt is null
						AND app.accountProductId = 1
						AND now() <= app.dateEnd
				  ) dataC
			) dataB on dataA.accountid = dataB.accountid
			ORDER BY accountid asc, accountDoctorLocationId asc, specialtyId asc;
		</cfquery>

		<cfloop query="featuredListings">
			<!--- Translate primary package to a numeric value --->
			<cfif featuredListings.topSpot eq 1>
				<cfset PrimaryPlacement = 4>
			<cfelseif featuredListings.secondSpot eq 1>
				<cfset PrimaryPlacement = 3>
			<cfelseif featuredListings.thirdSpot eq 1>
				<cfset PrimaryPlacement = 2>
			<cfelseif featuredListings.fourthSpot eq 1>
				<cfset PrimaryPlacement = 1>
			<cfelse>
				<cfset PrimaryPlacement = 0>
			</cfif>
			<cfset newListing = Iif(featuredListings.historycount eq 0,DE(1),DE(2))>

			<!--- Calculate Profile Completion --->
			<cfif currentAccount neq featuredListings.accountid>
				<cfset currentAccount = featuredListings.accountid>
				<cfset oDCV.init(featuredListings.accountid)>
				<cfset qProfileMissingItems = oDCV.GetProfileMissingItems()>
				<cfset ProfileComplete = val(oDCV.ProfileComplete(qProfileMissingItems))>
				<cfset DateList = ListSort(ListAppend(featuredListings.DateSpans,featuredListings.CurrentDateSpan), "text", "asc")>
				<cfset DateArray = []>
				<cfloop list="#DateList#" index="dateCouple">
					<cfset coupleStart = ParseDateTime(ListFirst(dateCouple,'|'))>
					<cfset coupleEnd = ParseDateTime(ListLast(dateCouple,'|'))>
					<cfif ArrayLen(DateArray) eq 0>
						<cfset ArrayAppend(DateArray,{start=coupleStart,end=coupleEnd})>
					<cfelse>
						<cfif DateCompare(coupleStart,DateArray[ArrayLen(DateArray)].end) lt 0>
							<cfset DateArray[ArrayLen(DateArray)].end = coupleEnd>
						<cfelseif DateCompare(coupleEnd,DateArray[ArrayLen(DateArray)].end) gt 0>
							<cfset ArrayAppend(DateArray,{start=coupleStart,end=coupleEnd})>
						</cfif>
					</cfif>
				</cfloop>
				<cfset yearsOfService = 0>
				<cfloop array="#DateArray#" index="dateCouple">
					<cfset yearsOfService += DateDiff("d",dateCouple.start,dateCouple.end)>
				</cfloop>
				<cfset yearsOfService = Int(yearsOfService/365)>
			</cfif>

			<!--- Product Placement bonus --->
			<cfset PPvalue = constants.PPWeight*PrimaryPlacement>
			<!--- New Listing bonus --->
			<cfif featuredListings.age gte 0 AND featuredListings.age lt constants.NewDuration>
				<cfset AgeValue = (1-(featuredListings.age/constants.NewDuration))*(constants.AgeWeight/newListing)>
			<!--- Expiring bonus: rising --->
			<cfelseif featuredListings.timeLeft gte (constants.ExpiringDownDuration + constants.ExpiringPeakDuration)
			 AND featuredListings.timeLeft lt (constants.ExpiringDownDuration + constants.ExpiringPeakDuration + constants.ExpiringUpDuration)>
				<cfset AgeValue = (1-((featuredListings.timeLeft-constants.ExpiringDownDuration-constants.ExpiringPeakDuration)/constants.ExpiringUpDuration))*constants.AgeWeight>
			<!--- Expiring bonus: peak --->
			<cfelseif featuredListings.timeLeft gte constants.ExpiringDownDuration
			 AND featuredListings.timeLeft lt (constants.ExpiringDownDuration + constants.ExpiringPeakDuration)>
				<cfset AgeValue = constants.AgeWeight>
			<!--- Expiring bonus: decline --->
			<cfelseif featuredListings.timeLeft gte 0 AND featuredListings.timeLeft lt constants.ExpiringDownDuration>
				<cfset AgeValue = (featuredListings.timeLeft/constants.ExpiringDownDuration)*constants.AgeWeight>
			<cfelse>
				<cfset AgeValue = 0>
			</cfif>
			<!--- BAAG bonus --->
			<cfset BAAGValue = constants.BAAGWeight * LOG10(1+((featuredListings.BAAGCases/constants.BAAGThreshold)*(1 + (constants.BAAGFrequencyMultiplier - 1) * LOG10(1+(featuredListings.BAAGFrequency/constants.BAAGFrequencyThreshold)*9)))*9)>
			<!--- CPL bonus --->
			<cfset CPLValue = constants.CPLWeight * LOG10(1+(featuredListings.CPL/constants.CPLThreshold)*9)>
			<!--- Profile Completion bonus --->
			<cfset ProfileValue = constants.ProfileWeight * (ProfileComplete/100)>
			<!--- Longevity bonus --->
			<cfset LongevityValue = constants.LongevityWeight * (yearsOfService/constants.LongevityThreshold)>

			<!--- Calculate PracticeRank --->
			<cfset PracticeRank = Round(AgeValue+BAAGValue+CPLValue+ProfileValue+LongevityValue)>
			<cfset PracticeRankSpecialty = PracticeRank + Round(PPvalue)>
			<!--- Update PracticeRank history --->
			<cfif featuredListings.practiceRankScore neq "">
				<cfquery datasource="myLocateadocEdits">
					INSERT INTO accountproductspurchasedpracticerankscorehistory
					(accountProductsPurchasedId,practiceRankScore,createdAt)
					VALUES(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#id#">,
						<cfqueryparam cfsqltype="cf_sql_smallint" value="#featuredListings.practiceRankScore#">,
						now()
					);
				</cfquery>
			</cfif>
			<!--- Update PracticeRank --->
			<cfquery datasource="myLocateadocEdits">
				UPDATE accountproductspurchaseddoctorlocations
				SET practiceRankScore = <cfqueryparam cfsqltype="cf_sql_smallint" value="#PracticeRank#">,
					practiceRankSpecialtyScore = <cfqueryparam cfsqltype="cf_sql_smallint" value="#PracticeRankSpecialty#">,
				    updatedAt = now()
				WHERE accountDoctorLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#accountDoctorLocationId#">
				AND specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
				AND accountProductsPurchasedId = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">;
			</cfquery>
			<cfoutput>#accountDoctorLocationId#|#specialtyId#|#PracticeRank# [Age:#AgeValue# BAAG:#BAAGValue# CPL:#CPLValue# Profile:#ProfileValue# Longevity:#LongevityValue#] [PP:#PPvalue#]<br></cfoutput>
		</cfloop>

		<cfabort>
	</cffunction>

	<cffunction name="abandonedMiniLeads">
		<cfparam name="url.test" default="0">
		<cfparam name="url.testing_email" default="">
		<cfparam name="url.limit" default="0">

		<cfset intEmailCount = 0>

		<cfquery name="qryAbandonedLeads" datasource="myLocateadoc">
			SELECT				fmlsw.id, cast(group_concat(DISTINCT fmlswl.info_id) AS char) AS infoIds, fmlsw.specialtyId, fmlsw.procedureId, fmlsw.email,
								fmlsw.firstname, fmlsw.lastname, fmlsw.postalCode, fmlsw.createdAt, fmlsw.deletedAt
			FROM				folio_mini_lead_site_wide fmlsw
			INNER JOIN			folio_mini_lead_site_wide_listings fmlswl ON fmlswl.folio_mini_lead_site_wide_id = fmlsw.id
			WHERE				fmlsw.patientEmailSentAt IS NULL
			AND					fmlsw.createdAt < (now() - INTERVAL 1 DAY)
			AND					fmlsw.deletedAt IS NULL
			GROUP BY fmlsw.id
			ORDER BY fmlsw.id desc
			<cfif val(url.limit) gt 0> LIMIT #val(url.limit)#</cfif>
		</cfquery>

		<cfloop query="qryAbandonedLeads">
			<cfif listLen(qryAbandonedLeads.infoIds)>
				<cfif url.test EQ 1>
					<cfset emailTo = url.testing_email>
				<cfelse>
					<cfset emailTo = qryAbandonedLeads.email>
				</cfif>

				<cfset model("ProfileMiniLead").sendSiteWideMiniEmail(
					leadID		= qryAbandonedLeads.id,
					listingIds 	= qryAbandonedLeads.infoIds,
					firstname 	= qryAbandonedLeads.firstname,
					email 		= emailTo,
					procedureId = qryAbandonedLeads.procedureId,
					postalCode	= qryAbandonedLeads.postalCode,
					abandoned	= true,
					test		= url.test
				)>

				<cfset intEmailCount++><!--- Update email count --->
			</cfif>
		</cfloop>

		<cfoutput>Sent #intEmailCount# emails.</cfoutput>
		<cfabort>
	</cffunction>

	<cffunction name="painPoke">
		<cfquery datasource="myLocateadocReporting" name="qryDoctors">
			SELECT accountID, accountDoctorID, firstname, lastname, expireDate, visitorDate, lastEmailDate,
			IFNULL((SELECT sum(hitCount) AS newVisitors
				FROM myLocateadocReports.hitsaccountprofilesdaily
				WHERE accountId = data.accountID AND hitDate > lastEmailDate
				GROUP BY accountId),0) as newVisitors,
			IFNULL((SELECT sum(hitCount) AS totalVisitors
				FROM myLocateadocReports.hitsaccountprofilesdaily
				WHERE accountId = data.accountID AND hitDate > expireDate
				GROUP BY accountId),0) as totalVisitors
			FROM (SELECT ap.accountID, adl.accountDoctorID, ad.firstname, ad.lastname,
				max(ptle.emailedAt) as expireDate, max(ptve.emailedAt) as visitorDate,
					cast(case when max(ptve.emailedAt) is null
						then max(ptle.emailedAt)
						else max(ptve.emailedAt)
						end as datetime) as lastEmailDate
				FROM myLocateadoc3.accountdoctorlocations adl
				JOIN myLocateadoc3.accountdoctors ad ON adl.accountDoctorID = ad.id AND ad.deletedAt is null
				JOIN myLocateadoc3.accountdoctoremails ade ON ade.accountDoctorId = ad.id AND ade.categories = "lead" AND ade.deletedAt IS NULL
				JOIN myLocateadoc3.accountpractices ap ON adl.accountPracticeID = ap.id AND ap.deletedAt is null
				JOIN myLocateadoc3.profilethresholdleademails ptle ON ap.accountID = ptle.accountID AND ptle.deletedAt is null
				LEFT JOIN myLocateadoc3.profilethresholdvisitoremails ptve ON ap.accountID = ptve.accountID
				LEFT JOIN myLocateadoc3.accountproductspurchased app ON app.accountId = ap.accountId AND app.deletedAt IS NULL
				LEFT JOIN myLocateadoc3.accountproductspurchasedhistory apph ON apph.accountId = ap.accountId AND apph.deletedAt IS NULL
				WHERE adl.deletedAt is null AND app.id IS NULL AND apph.id IS NULL
				GROUP BY ap.accountId
				HAVING max(ptle.emailedAt) < Date_Sub(now(), INTERVAL 7 DAY)
					AND (max(ptve.emailedAt) < Date_Sub(now(), INTERVAL 7 DAY)
					  OR max(ptve.emailedAt) is null) ) data
			GROUP BY accountID HAVING newVisitors >= 10;
		</cfquery>

		<cfset successCount = 0>

		<cfloop query="qryDoctors">
			<cfset emailQuery = model("AccountDoctorEmail").findAll(
						select="email",
						distinct="true",
						include="accountEmail",
						where="accountDoctorId = #qryDoctors.accountDoctorID# AND (categories = 'Lead' OR categories = 'Doctor')"
			)>
			<!--- compose unique email list --->
			<cfset docEmails = "">
			<cfloop query="emailQuery">
				<cfif ListContains(docEmails,emailQuery.email) eq 0>
					<cfset docEmails = ListAppend(docEmails,emailQuery.email)>
				</cfif>
			</cfloop>

			<cfset salesManager = model("Account").getManager(qryDoctors.accountId)>
			<cfif server.thisServer EQ "dev">
				<cfset emailTo = "jason@mojointeractive.com">
				<cfset bccTo = "">
			<cfelse>
				<cfset emailTo = docEmails>
				<cfset bccTo = ListAppend("glen@mojointeractive.com,exclusiveleads@locateadoc.com,emailtosalesforce@c-19ynglnp98d89opsn0ysty2on.3z6qeau.6.le.salesforce.com",salesManager.email)>
			</cfif>

			<cfif emailTo neq "">
				<!--- Define email body --->
				<cfsavecontent variable="emailBody">
					<cfoutput>
					<HTML>
					<BODY>
					<cfif server.thisServer EQ "dev">
						<p>(Test email. Intended recipient: #docEmails#)</p>
					</cfif>
					<P style="margin-left:3px;"><A HREF="http://www.practicedock.com"><IMG SRC="http://www.locateadoc.com/images/layout/email/PDock_header.jpg" BORDER="0"></A></P>
					<table style="margin:0px; padding:0px; border-spacing:0px;"><tr style="margin:0px; padding:0px;"><td style="border:1px solid ##C4C4C4; width:586px; margin:0px; padding:15px;">
					<FONT FACE="Arial,Helvetica,Sans-serif" SIZE="2">

					<P>#qryDoctors.firstname# #qryDoctors.lastname#,</P>

					<P><span style="color: red;	font-weight: bold;">Good news:</span>
					<cfif qryDoctors.totalVisitors gt qryDoctors.newVisitors>
						#qryDoctors.newVisitors# new patients visited your LocateADoc.com profile page.
						That is #qryDoctors.totalVisitors# total patients looking to contact you since your trial period expired.
					<cfelse>
						#qryDoctors.totalVisitors# new patients visited your LocateADoc.com profile page.
					</cfif>
					</P>

					<P><span style="color: red;	font-weight: bold;">Bad news:</span> Your LocateADoc.com account expired
					on #DateFormat(qryDoctors.expireDate,"m/d/yyyy")#
					and we are sending these new patient leads to other doctors in your area.</P>

					<P>Interested in receiving unlimited patient leads each month?</P>

					<P><A HREF="http://www.practicedock.com/index.cfm/PageID/7150">Click here to contact me</A>,
					call <B>877-809-1777</B>, or email <a href="mailto:#salesManager.email#">#salesManager.email#</a>.</P>

					<P>Best regards,<BR>#salesManager.FirstName# #salesManager.LastName#</P>

					<P>Learn more about our <A HREF="http://www.practicedock.com/documents/2013%20LocateADoc_com%20Top%20Doctor%20program.pdf">Top Doctor</A>
					and <A HREF="http://www.practicedock.com//documents/power%20position(1).pdf">Power Position</A> programs on LocateADoc.com.</P>

					</FONT>
					</td></tr></table>
					</BODY>
					</HTML>
					</cfoutput>
				</cfsavecontent>

				<cfmail from="contact@locateadoc.com"
						to="#emailTo#"
						bcc="#bccTo#"
						subject="Your Profile Had Many New Visitors"
						type="html">
					#emailBody#
				</cfmail>

				<cfquery datasource="myLocateadocEdits">
					INSERT INTO profilethresholdvisitoremails (accountId, emailedAt, createdAt)
					VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#qryDoctors.accountId#">, now(), now());
				</cfquery>
				<cfset successCount++>
			</cfif>
		</cfloop>

		<cfoutput>Sent #successCount#/#qryDoctors.recordcount# emails.</cfoutput>
		<cfabort>
	</cffunction>

	<cffunction name="BPexpiration">
		<cfquery datasource="#get('dataSourceName')#" name="qryDoctors">
			SELECT doctorLocationId, a.id AS accountId, a.name,
			sum(leads.TotalFolio) AS TotalFolioLeads, sum(leads.TotalMini) AS TotalMiniLeads,
							sum(leads.TotalFolio) + sum(leads.TotalMini) AS TotalLeads,
						(SELECT IF(FIND_IN_SET(1,group_concat(leads.isPremier)) > 0, "Premier", "Non-Premier")) AS isPremier, group_concat(leads.isPremier)

			FROM
			(
				SELECT adl.id AS doctorLocationId, a.id AS accountId, count(distinct(f.folio_id)) AS TotalFolio, 0 AS TotalMini,
						(SELECT 1 IN (group_concat(s.isPremier))) AS isPremier
				FROM accounts a
				INNER JOIN accountpractices ap ON ap.accountId = a.id AND ap.deletedAt IS NULL
				INNER JOIN accountdoctorlocations adl ON adl.accountPracticeId = ap.id AND adl.deletedAt IS NULL
				INNER JOIN accountdoctors ad ON ad.id = adl.accountDoctorId AND ad.deletedAt IS NULL
				INNER JOIN accountdoctoremails ade On ade.accountDoctorId = ad.id AND ade.categories = "lead" AND ade.deletedAt IS NULL
				INNER JOIN accountemails ae On ae.id = ade.accountEmailId AND ae.deletedAt IS NULL
				INNER JOIN accountlocationspecialties als ON als.accountDoctorLocationid = adl.id AND als.deletedAt IS NULL
				INNER JOIN specialties s ON s.id = als.specialtyId AND s.deletedAt IS NULL
				LEFT JOIN accountproductspurchased app ON app.accountId = a.id
				LEFT JOIN accountproductspurchasedhistory apph ON apph.accountId = a.id
				INNER JOIN myLocateadoc.folio f On f.info_id = adl.id
							AND f.date > "2012-07-07" AND f.is_active = 1 AND f.is_duplicate = 0
				WHERE app.id IS  NULL AND apph.id IS NULL AND a.deletedAt IS NULL
				GROUP BY a.id

				UNION

				SELECT adl.id AS doctorLocationId ,a.id AS accountId, 0 AS TotalFolio, count(distinct(uah.id)) AS TotalMini,
						(SELECT 1 IN (group_concat(s.isPremier))) AS isPremier
				FROM accounts a
				INNER JOIN accountpractices ap ON ap.accountId = a.id AND ap.deletedAt IS NULL
				INNER JOIN accountdoctorlocations adl ON adl.accountPracticeId = ap.id AND adl.deletedAt IS NULL
				INNER JOIN accountdoctors ad ON ad.id = adl.accountDoctorId AND ad.deletedAt IS NULL
				INNER JOIN accountdoctoremails ade On ade.accountDoctorId = ad.id AND ade.categories = "lead" AND ade.deletedAt IS NULL
				INNER JOIN accountemails ae On ae.id = ade.accountEmailId AND ae.deletedAt IS NULL
				INNER JOIN accountlocationspecialties als ON als.accountDoctorLocationid = adl.id AND als.deletedAt IS NULL
				INNER JOIN specialties s ON s.id = als.specialtyId AND s.deletedAt IS NULL
				LEFT JOIN accountproductspurchased app ON app.accountId = a.id
				LEFT JOIN accountproductspurchasedhistory apph ON apph.accountId = a.id
				INNER JOIN myLocateadoc.user_accounts_hits uah On uah.info_id = adl.id
							AND uah.date > "2012-07-07"
							AND uah.is_active = 1 AND uah.has_folio_lead = 0 AND uah.is_duplicate = 0
				WHERE app.id IS  NULL AND apph.id IS NULL AND a.deletedAt IS NULL
				GROUP BY a.id
			) leads
			INNER JOIN accounts a On a.id = leads.accountId
			GROUP BY leads.accountId
			having TotalLeads >= #Server.Settings.LocateADoc.BasicPlusLeadThreshold#
			ORDER BY TotalLeads desc;
		</cfquery>

		<!--- SELECT adl.id, ap.accountID, adl.accountDoctorID, ad.firstname, ad.lastname,
			(SELECT count(distinct(f.folio_id)) AS folio_lead_count
				FROM myLocateadoc.folio f
				WHERE f.info_id = adl.id AND f.date > '2012-07-07' AND f.is_duplicate = 0 AND f.is_active = 1
				) as folio_count,
			(SELECT count(distinct(uah.id)) AS mini_lead_count
				FROM myLocateadoc.user_accounts_hits uah
				WHERE uah.info_id = adl.id AND uah.date > '2012-07-07' AND uah.is_cover_up = 1 AND uah.is_active = 1 AND uah.has_folio_lead = 0
				) AS mini_count
			FROM myLocateadoc3.accountdoctorlocations adl
			JOIN myLocateadoc3.accountdoctors ad ON adl.accountDoctorID = ad.id
			JOIN myLocateadoc3.accountdoctoremails ade ON ade.accountDoctorId = ad.id AND ade.categories = "lead" AND ade.deletedAt IS NULL
			JOIN myLocateadoc3.accountpractices ap ON adl.accountPracticeID = ap.id
			LEFT JOIN myLocateadoc3.accountproductspurchased app ON app.accountId = ap.accountId AND app.deletedAt IS NULL
			LEFT JOIN myLocateadoc3.accountproductspurchasedhistory apph ON apph.accountId = ap.accountId AND apph.deletedAt IS NULL
			WHERE adl.deletedAt is null AND ad.deletedAt is null AND ap.deletedAt is null
				AND app.id IS NULL AND apph.id IS NULL
			GROUP BY ap.accountId
			HAVING (folio_count + mini_count) >= 10; --->

		<cfloop query="qryDoctors">
			<cfset model("AccountDoctorLocation").BasicPlusThresholdEmail(qryDoctors.doctorLocationId,'noreply@locateadoc.com')>
		</cfloop>

		<cfoutput>Sent #qryDoctors.recordcount# emails.</cfoutput>
		<cfabort>
	</cffunction>

	<cffunction name="exclusivePainPoke">
		<cfquery datasource="myLocateadocReporting" name="qryDoctors">
			SELECT accountID, accountDoctorID, firstname, lastname, expireDate, visitorDate, lastDate,
				IFNULL((SELECT sum(hitCount) AS newVisitors
					FROM myLocateadocReports.hitsaccountprofilesdaily
					WHERE accountId = data.accountID AND hitDate > lastDate
					GROUP BY accountId),0) as newVisitors,
				IFNULL((SELECT sum(hitCount) AS totalVisitors
					FROM myLocateadocReports.hitsaccountprofilesdaily
					WHERE accountId = data.accountID AND hitDate > expireDate
					GROUP BY accountId),0) as totalVisitors
			FROM (
				SELECT ap.accountId, adl.accountDoctorID, ad.firstname, ad.lastname,
				 max(apph.dateEnd) as expireDate, max(ptve.emailedAt) as visitorDate,
				 cast(case when max(ptve.emailedAt) is null
										then max(apph.dateEnd)
										else max(ptve.emailedAt)
										end as datetime) as lastDate
				FROM myLocateadoc3.accountdoctorlocations adl
				JOIN myLocateadoc3.accountdoctors ad ON adl.accountDoctorID = ad.id AND ad.deletedAt is null
				JOIN myLocateadoc3.accountpractices ap ON adl.accountPracticeID = ap.id AND ap.deletedAt is null
				LEFT JOIN myLocateadoc3.profilethresholdvisitoremails ptve ON ap.accountID = ptve.accountID
				LEFT JOIN myLocateadoc3.accountproductspurchased app ON ap.accountId = app.accountId AND app.accountProductId = 1 AND app.deletedAt is null
				JOIN myLocateadoc3.accountproductspurchasedhistory apph ON ap.accountId = apph.accountId AND apph.deletedAt is null AND apph.dateEnd > '2012-07-07' AND apph.accountProductId = 1
				WHERE app.id is null
				GROUP BY ap.accountId
				HAVING expireDate < Date_Sub(now(), INTERVAL 30 DAY)
								AND (visitorDate < Date_Sub(now(), INTERVAL 7 DAY)
								  OR visitorDate is null) ) data
			GROUP BY accountID HAVING newVisitors >= 10;
		</cfquery>

		<cfset successCount = 0>

		<cfloop query="qryDoctors">
			<cfset emailQuery = model("AccountDoctorEmail").findAll(
						select="email",
						distinct="true",
						include="accountEmail",
						where="accountDoctorId = #qryDoctors.accountDoctorID# AND (categories = 'Lead' OR categories = 'Doctor')"
			)>
			<!--- compose unique email list --->
			<cfset docEmails = "">
			<cfloop query="emailQuery">
				<cfif ListContains(docEmails,emailQuery.email) eq 0>
					<cfset docEmails = ListAppend(docEmails,emailQuery.email)>
				</cfif>
			</cfloop>

			<cfset salesManager = model("Account").getManager(qryDoctors.accountId)>
			<cfif server.thisServer EQ "dev">
				<cfset emailTo = "sean@mojointeractive.com">
				<cfset bccTo = "">
			<cfelse>
				<cfset emailTo = docEmails>
				<cfset bccTo = ListAppend("glen@mojointeractive.com,exclusiveleads@locateadoc.com,emailtosalesforce@c-19ynglnp98d89opsn0ysty2on.3z6qeau.6.le.salesforce.com",salesManager.email)>
			</cfif>

			<cfif emailTo neq "">
				<!--- Define email body --->
				<cfsavecontent variable="emailBody">
					<cfoutput>
					<HTML>
					<BODY>
					<cfif server.thisServer EQ "dev">
						<p>(Test email. Intended recipient: #docEmails#)</p>
						<p>(BCC sales manager: #salesManager.email#)</p>
					</cfif>
					<P style="margin-left:3px;"><A HREF="http://www.practicedock.com"><IMG SRC="http://www.locateadoc.com/images/layout/email/PDock_header.jpg" BORDER="0"></A></P>
					<table style="margin:0px; padding:0px; border-spacing:0px;"><tr style="margin:0px; padding:0px;"><td style="border:1px solid ##C4C4C4; width:586px; margin:0px; padding:15px;">
					<FONT FACE="Arial,Helvetica,Sans-serif" SIZE="2">

					<P>#qryDoctors.firstname# #qryDoctors.lastname#,</P>

					<P><span style="color: red;	font-weight: bold;">Good news:</span>
					<cfif qryDoctors.totalVisitors gt qryDoctors.newVisitors>
						#qryDoctors.newVisitors# new patients visited your LocateADoc.com profile page.
						That is #qryDoctors.totalVisitors# total patients looking to contact you since your listing expired.
					<cfelse>
						#qryDoctors.totalVisitors# new patients visited your LocateADoc.com profile page.
					</cfif>
					</P>

					<P><span style="color: red;	font-weight: bold;">Bad news:</span> Your LocateADoc.com account expired
					on #DateFormat(qryDoctors.expireDate,"m/d/yyyy")#
					and we are sending these new patient leads to other doctors in your area.</P>

					<P>Interested in receiving unlimited patient leads each month?</P>

					<P><A HREF="http://www.practicedock.com/index.cfm/PageID/7150">Click here to contact me</A>,
					call <B>877-809-1777</B>, or email <a href="mailto:#salesManager.email#">#salesManager.email#</a>.</P>

					<P>Best regards,<BR>#salesManager.FirstName# #salesManager.LastName#</P>

					<P>Learn more about our <A HREF="http://www.practicedock.com/documents/2013%20LocateADoc_com%20Top%20Doctor%20program.pdf">Top Doctor</A>
					and <A HREF="http://www.practicedock.com//documents/power%20position(1).pdf">Power Position</A> programs on LocateADoc.com.</P>

					</FONT>
					</td></tr></table>
					</BODY>
					</HTML>
					</cfoutput>
				</cfsavecontent>

				<cfmail from="contact@locateadoc.com"
						to="#emailTo#"
						bcc="#bccTo#"
						subject="Your Profile Had Many New Visitors"
						type="html">
					#emailBody#
				</cfmail>

				<cfquery datasource="myLocateadocEdits">
					INSERT INTO profilethresholdvisitoremails (accountId, emailedAt, createdAt)
					VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#qryDoctors.accountId#">, now(), now());
				</cfquery>
				<cfset successCount++>
			</cfif>
		</cfloop>

		<cfoutput>Sent #successCount#/#qryDoctors.recordcount# emails.</cfoutput>
		<cfabort>
	</cffunction>

	<cffunction name="UnopenedLeadThresholdEmail">
		<!--- http://carlos3.locateadoc.com/scheduled/unopenedleadthresholdemail --->

		<cfset qBasicPlusAccountsUnopenedLeadThreshold = model("Account").BasicPlusAccountsUnopenedLeadThreshold(limit = 10)>


		<cfoutput>
		<cfdump var = "#qBasicPlusAccountsUnopenedLeadThreshold#">
		</cfoutput>

		<cfloop query="qBasicPlusAccountsUnopenedLeadThreshold">
			<cfset BasicPlusUnopenedThresholdEmail(accountId = qBasicPlusAccountsUnopenedLeadThreshold.accountId)>
		</cfloop>


		<cfabort>


		<cfset renderNothing()>

	</cffunction>

	<cffunction name="BasicPlusUnopenedThresholdEmail" access="public" hint="Send an email to the Basic+ Account informing them they are turned off for unopened leads">
		<cfargument name="accountId" required="true">
		<cfargument name="clientEmail" required="false" default="">

		<!--- http://carlos3.locateadoc.com/sheduled/basicplusunopenedthresholdemail --->


		<cfset qAccount = model("Account").FindOneById(	select	= "id, name",
														value	= arguments.accountId)>


		<!--- If doctor already received this email, stop --->
		<cfset emailCheck = model("ProfileThresholdUnopenedLeadEmails").FindOneByAccountId(	value	= arguments.accountId,
																							select	= "id")>
		<cfif isObject(emailCheck) gt 0><cfreturn></cfif>


		<cfset qAccountEmails = model("AccountEmail").GetAccountEmails(accountId = arguments.accountId)>

		<!--- compose unique email list --->
		<cfset docEmails = "">
		<cfloop query="qAccountEmails">
			<cfif ListContains(docEmails,qAccountEmails.email) eq 0>
				<cfset docEmails = ListAppend(docEmails,qAccountEmails.email)>
			</cfif>
		</cfloop>

		<cfset salesManager = model("Account").getManager(arguments.accountId)>

		<cfif server.thisServer EQ "dev">
			<cfset emailTo = "carlos@mojointeractive.com">
			<cfset bccTo = "carlos@mojointeractive.com">
		<cfelse>
			<cfset emailTo = docEmails>
			<cfset bccTo = ListAppend('exclusiveleads@locateadoc.com',salesManager.email)>
		</cfif>

		<cfif emailTo eq "">
			<cfreturn>
		</cfif>

		<cfif server.thisServer EQ "dev">
			<cfset strEnvironment = "http://dev">
		<cfelse>
			<cfset strEnvironment = "https://www">
		</cfif>

		<cfstoredproc procedure="BasicPlusLeads" datasource="myLocateadocEdits">
			<cfprocresult name="allLeads">
			<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.accountId#">
			<cfprocparam cfsqltype="cf_sql_date" value="#Server.Settings.LocateADoc.BasicPlusLeadStartDate#">
		</cfstoredproc>

		<cfset PDockUsername = model("Account").getPDockUsername(qAccount.id)>

		<cfquery datasource="#get("datasourcename")#" name="qUnopenedLeadCount">
			call UnopenedLeads(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountId#">, "#Server.Settings.LocateADoc.BasicPlusLeadStartDate#");
		</cfquery>

		<cfif qUnopenedLeadCount.total LT Server.Settings.LocateADoc.BasicPlusUnopenedLeadThreshold>
			<cfoutput>Not over threshold</cfoutput>
			<cfreturn>
		</cfif>


		<!--- Define email body --->
		<cfsavecontent variable="emailBody">
			<cfoutput>
			<HTML>
			<BODY>
			<cfif Find("@mojointeractive.com",arguments.clientEmail) gt 0 or server.thisServer EQ "dev">
				<p>(Test email. Intended recipient: #docEmails#)</p>
			</cfif>
			<A HREF="http://www.practicedock.com"><IMG SRC="http://www.locateadoc.com/images/layout/email/PDock_header.jpg" BORDER="0"></A>
			<table style="margin:0px; padding:0px; border-spacing:0px;"><tr style="margin:0px; padding:0px;"><td style="border:1px solid ##C4C4C4; width:553px; margin:0px; padding:15px;">
			<FONT FACE="Arial,Helvetica,Sans-serif" SIZE="2">

			<P><strong>#qAccount.name#,</strong></P>

			<p><strong>You have not opened #qUnopenedLeadCount.total# of your leads,</strong> which exceeds our unopened lead limit of #Server.Settings.LocateADoc.BasicPlusUnopenedLeadThreshold#.
				During this time you received <span style="color: red; font-weight: bold;">#allLeads.recordcount# complimentary patient leads from LocateADoc.com</span>.
				We have paused your complimentary trial period at this time.
			</p>

			<p>If you would like to continue to receive patient leads, please contact
				<b>#salesManager.FirstName# #salesManager.LastName#</b> at <b>877-809-1777</b> or email
				<a href="mailto:#salesManager.email#"><b>#salesManager.email#</b></a>.</p>

			<p>Here is a snap shot of all of your patient leads received on the new site:</p>

			<table style="width: 100%; font: 12px Arial, Helvetica, sans-serif;	cell-spacing: 0; border-width: 0px;	border-collapse: collapse;">
				<thead style="background-color: ##5eb6e7;color: ##ffffff;font-weight: bold;">
					<tr>
						<th style="padding: 5px; text-align:left;">Lead Name</th>
						<th style="padding: 5px; text-align:left;">Procedure/Treatment Interested In</th>
						<th style="padding: 5px; text-align:left;">Date Received</th>
						<th style="padding: 5px; text-align:left;">Lead Status</th>
					</tr>
				</thead>
				<tbody>
				  <cfloop query="allLeads">
					<tr style="height: 30px;">
						<td style="padding: 5px;">
							<cfif allLeads.leadType neq "phone">
							<a href="#strEnvironment#.practicedock.com/admin/LocateADoc/leads/index.cfm?id=#allLeads.id#&type=#allLeads.leadType#">
								#allLeads.firstname# #allLeads.lastname#
							</a>
							<cfelse>
								#allLeads.firstname# #allLeads.lastname#
							</cfif>
						</td>
						<td style="padding: 5px;">
							<cfif ListLen(allLeads.procedureIDs) gt 0>
								#model("Procedure").findAll(select="name",where="id=#ListFirst(allLeads.procedureIDs)#").name#
							</cfif>
						</td>
						<td style="padding: 5px;">#DateFormat(allLeads.date,'m-d-yyyy')#</td>
						<td style="padding: 5px;">
							<cfif allLeads.isLeadOpened eq 0>
								<span style="color: red; font-weight: bold;">Unopened</span>
							<cfelse>
								<p>Opened</p>
							</cfif>
						</td>
					</tr>
					<cfif currentrow lt recordcount>
						<tr style="background-color: ##EEEEEE; height: 1px;">
							<td style="padding: 0;" colspan="4"></td>
						</tr>
					</cfif>
				  </cfloop>
				</tbody>
			</table>

			<p style="color: red;">You will no longer be receiving patient leads from LocateADoc.com.</p>

			<p>View and respond to your patient leads by logging into PracticeDock.
			<a href="https://www.practicedock.com/index.cfm/PageID/7151">www.practicedock.com</a></p>

			<cfif PDockUsername neq "">
				<p>
				PracticeDock username: <b>#PDockUsername#</b>
				<br/>
				Password: <b>(see below)</b>
				</p>

				<p>Forgot your password? Using the PracticeDock login email address #PDockUsername#
				we have on file for you, visit the PracticeDock password reminder page and you can request
				your password be emailed to that address.</p>
			</cfif>

			<p>Thank you,<br/>
			The LocateADoc.com Support Team</p>

			</FONT>
			</td></tr></table>
			</BODY>
			</HTML>
			</cfoutput>
		</cfsavecontent>


		<cfoutput>#emailBody#</cfoutput>


		<cfmail from="#salesManager.email#"
				to="#emailTo#"
				bcc="#bccTo#"
				subject="#qAccount.name# - Your LocateADoc Unopened Leads Limit Has Been Reached"
				type="html">
			#emailBody#
		</cfmail>

		<cfquery datasource="myLocateadocEdits">
			INSERT INTO profilethresholdunopenedleademails (accountId, emailedAt, createdAt)
			VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#qAccount.id#">, now(), now());
		</cfquery>
	</cffunction>
</cfcomponent>