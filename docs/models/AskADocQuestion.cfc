<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocEdits")>

		<cfset validate(method="validateEmailFormat")>

		<cfset validate(method="validateProcedureOrSpecialtyId")>

		<cfset validatesPresenceOf(	properties	= "email,question")>
		<cfset validatesPresenceOf(	properties	= "firstName,lastName,title,refererInternal,entryPage,refererExternal,faceBookPhoto",
									condition	= false)>
	</cffunction>


	<cffunction name="validateEmailFormat" access="private">
	    <cfif not IsValid("email", this.email)>
	        <cfset addError(property="email", message="Email address is not in a valid format.")>
	    </cfif>
	</cffunction>

	<cffunction name="validateProcedureOrSpecialtyId" access="private" hint="Check if a specialty or procedure id is selected">
		<cfset var hasSpecialtyOrProcedure = false>

		<cfparam default="" name="this.procedureId">
		<cfparam default="" name="this.specialtyId">

	    <cfif val(this.procedureId) GT 0 OR val(this.specialtyId) GT 0>
			<cfset hasSpecialtyOrProcedure = true>
		</cfif>

		<cfif NOT hasSpecialtyOrProcedure>
			 <cfset addError(property="SPECIALTYORPROCEDUREID", message="No Specialty or Procedure Selected")>
		</cfif>
	</cffunction>

	<cffunction name="GetQA" returntype="query">
		<cfargument default="" name="siloname">
		<cfargument default="" name="id">
		<cfargument default="FALSE" name="preview" type="boolean" required="false">

		<cfset var qQA = "">
		<cfset var tableNames = {}>
		<cfset var tableNames.questions = "askadocquestions">
		<cfset var tableNames.answers = "askadocquestionanswers">

		<cfif arguments.preview AND isnumeric(arguments.id)>
			<cfset tableNames.questions = "askadocquestionpreviews">
			<cfset tableNames.answers = "askadocquestionanswerpreviews">
		</cfif>

		<cfquery datasource="#get('dataSourceName')#" name="qQA">
			SELECT 	q.id, q.xfactorQuestionId, sp.procedure_id AS xFactorProcedureId,

					group_concat(DISTINCT sp.procedure_id) AS xFactorProcedureIds,
					group_concat(DISTINCT spn.procedure_name_id) AS xFactorProcedureNameIds,
					group_concat(DISTINCT spn.procedure_name) AS xFactorProcedureNames,

					Capitalize(q.firstName) AS firstName, q.title, q.title AS header, q.question AS content,
					q.metaKeywords, q.metaDescription, q.approvedAt AS publishAt, q.createdAt,
					cast(group_concat(DISTINCT aqs.specialtyId) AS char) AS specialtyIds,
					cast(group_concat(DISTINCT ap.procedureId) AS char) AS procedureIds,
					cast(group_concat(DISTINCT specialties.name SEPARATOR ":") AS char) AS specialties,
					cast(group_concat(DISTINCT specialties.siloName) AS char) AS specialtySiloNames,
					cast(group_concat(DISTINCT procedures.name SEPARATOR ":") AS char) AS procedures,
					cast(group_concat(DISTINCT procedures.siloName) AS char) AS procedureSilonames
			FROM
			<cfif arguments.preview AND isnumeric(arguments.id)>
				#tableNames.questions# q
			<cfelse>
				askadocquestionsilonames silo
				INNER JOIN #tableNames.questions# q ON q.id = silo.askADocQuestionid AND q.deletedAt IS NULL
			</cfif>

			INNER JOIN #tableNames.answers# a ON a.askADocQuestionId = q.id AND
												<cfif NOT arguments.preview>
													a.approvedAt <= now() AND
												</cfif>
												a.deletedAt IS NULL
			INNER JOIN accountdoctors ad ON ad.id = a.accountDoctorId<!---  AND ad.deletedAt IS NULL --->
			LEFT JOIN askadocquestionprocedures ap ON ap.askADocQuestionId = q.id AND ap.deletedAt IS NULL
			LEFT JOIN procedures ON procedures.id = ap.procedureId AND procedures.deletedAt IS NULL
			LEFT JOIN askadocquestionspecialties aqs ON aqs.askADocQuestionId = q.id AND aqs.deletedAt IS NULL
			LEFT JOIN specialties ON specialties.id = aqs.specialtyId AND specialties.deletedAt IS NULL

			/* 2.0 archive check */
			LEFT JOIN myLocateadoc.xfactor_questions AS xa ON xa.id = q.xfactorQuestionId
			LEFT JOIN myLocateadoc.xfactor_questions_procedure_names AS p ON (xa.ID = p.question_id)
			LEFT JOIN myLocateadoc.specialty_procedures AS sp ON (sp.procedure_name_id = p.procedure_name_id)
			LEFT JOIN myLocateadoc.specialty_procedure_names AS spn ON (sp.procedure_name_id = spn.procedure_name_id)

			WHERE 	<cfif arguments.preview AND isnumeric(arguments.id)>
						q.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"> AND q.deletedAt IS NULL
					<cfelse>
						silo.siloName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siloname#">
						AND silo.isActive = 1 AND silo.deletedAt IS NULL
						AND q.approvedAt <= now()
					</cfif>
			GROUP BY q.id
		</cfquery>

		<cfreturn qQA>

	</cffunction>

	<cffunction name="GetArchiveQAs" returntype="query">
		<cfargument default="" name="procedureId">
		<cfargument default="" name="offset">
		<cfargument default="" name="limit">


		<cfset var qQuestions = "">

		<cfquery datasource="myLocateadoc" name="qQuestions">
			SELECT SQL_CALC_FOUND_ROWS
				a.id AS xFactorQuestionId, a.pid AS patientId, adq.firstName AS patientFirstname, adq.title, adq.question, aqa.content AS answer, adq.approvedAt, adqsn.siloName,
				ad.firstName, ad.middleName, ad.lastName, ad.title as doctorTitle, ad.photoFileName, adsn.siloName AS doctorSiloName,
				IF(ad.deletedAt IS NOT NULL OR adl.deletedAt IS NOT NULL OR al.deletedAt IS NOT NULL, 1, 0) AS isDeactivated,
				cities.name AS city, states.name AS state,
				sp.procedure_name_id AS procedureId

			FROM xfactor_questions AS a
			INNER JOIN xfactor_questions_procedure_names AS p ON (a.ID = p.question_id)
			INNER JOIN specialty_procedures AS sp ON (sp.procedure_name_id = p.procedure_name_id)
			INNER JOIN specialty_procedure_names AS spn ON (sp.procedure_name_id = spn.procedure_name_id)
			LEFT JOIN myLocateadoc3.askadocquestions adq ON adq.xfactorQuestionId = a.id
			LEFT JOIN myLocateadoc3.askadocquestionsilonames adqsn ON adqsn.askADocQuestionId = adq.id AND adqsn.isActive = 1 AND adqsn.deletedAt IS NULL

			LEFT JOIN myLocateadoc3.askadocquestionanswers aqa ON aqa.askADocQuestionid = adq.id AND aqa.approvedAt <= now() AND aqa.deletedAT IS NULL
			LEFT JOIN myLocateadoc3.accountdoctors ad ON ad.id = aqa.accountDoctorId<!---  AND ad.deletedAt IS NULL --->
			LEFT JOIN myLocateadoc3.accountdoctorsilonames adsn ON adsn.accountDoctorId = ad.id AND adsn.isActive = 1 AND adsn.deletedAt IS NULL
			LEFT JOIN myLocateadoc3.accountdoctorlocations adl ON adl.accountDoctorId = ad.id<!---  AND adl.deletedAt IS NULL --->
			LEFT JOIn myLocateadoc3.accountlocations al ON al.id = adl.accountLocationId<!---  AND al.deletedAt IS NULL --->
			LEFT JOIN myLocateadoc3.cities ON cities.id = al.cityId AND cities.deletedAt IS NULL
			LEFT JOIN myLocateadoc3.states ON states.id = cities.stateId AND states.deletedAt IS NULL

			WHERE (sp.procedure_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.procedureId#">)
			AND (spn.is_active > 0)
			GROUP BY a.id
			ORDER BY p.order_id, pid DESC, db_updated_dt DESC
			LIMIT 	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offset#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limit#">
		</cfquery>

		<cfreturn qQuestions>

	</cffunction>

	<cffunction name="CheckOldTitle" returntype="query" hint="A user is trying to access a deactivated silo name. Check for an active one to 301 redirect to">
		<cfargument default="" name="siloname">

		<cfset var qCheckOldTitle = "">

		<cfquery datasource="#get('dataSourceName')#" name="qCheckOldTitle">
			SELECT 	silo2.siloName
			FROM askadocquestionsilonames silo
			INNER JOIN askadocquestions q ON q.id = silo.askADocQuestionid AND q.deletedAt IS NULL
			INNER JOIN askadocquestionanswers a ON a.askADocQuestionId = q.id AND a.approvedAt <= now() AND
												a.deletedAt IS NULL
			INNER JOIN accountdoctors ad ON ad.id = a.accountDoctorId
			INNER JOIN askadocquestionsilonames silo2 ON silo2.askADocQuestionId = q.id AND silo2.isActive = 1 AND silo2.deletedAt IS NULL
			WHERE silo.siloName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siloname#">
				  AND (silo.isActive = 0 OR silo.deletedAt IS NOT NULL)
			GROUP BY q.id
			LIMIT 1
		</cfquery>

		<cfreturn qCheckOldTitle>

	</cffunction>

	<cffunction name="GetQuestions" returntype="query">
		<cfargument name="specialty" type="numeric" required="false" default="0">
		<cfargument name="procedure" type="numeric" required="false" default="0">
		<cfargument name="tag" 		 type="string" 	required="false" default="">
		<cfargument name="article" 	 type="numeric" required="false" default="0">
		<cfargument name="order" 	 type="string" 	required="false" default="publishAt desc">
		<cfargument name="preview"	 type="numeric"	required="false" default="0">
		<cfargument name="offset"	 type="numeric"	required="false" default="0">
		<cfargument name="limit"	 type="numeric"	required="false" default="10">


		<cfquery name="searchResults" datasource="#get('dataSourceName')#">
			SELECT SQL_CALC_FOUND_ROWS
			qa.xfactorQuestionId, qa.id, qa.resourceArticleCategoryId, qa.publishAt, qa.sortAt,
			qa.siloName, qa.title, qa.metaKeywords, qa.metaDescription, qa.teaser,
			qa.header, qa.createdAt, qa.content, qa.ogImage,
			qa.specialtyIDs,
			qa.specialties,
			qa.procedureIDs,
			qa.procedures,
			qa.firstName, qa.lastname, qa.doctorTitle, qa.photoFilename, qa.doctorSiloName, qa.city, qa.state,
			qa.patientFirstName

			FROM
			(
				(
				SELECT
				aq.xfactorQuestionId, aq.id, 3 AS resourceArticleCategoryId,
				aq.approvedAt AS publishAt,
				IF(aq.xfactorQuestionId > 0, aq.updatedAt,aq.approvedAt) AS sortAt,
				aqsn.siloName, aq.title, aq.metaKeywords, aq.metaDescription, "" AS teaser,
				aq.firstName AS patientFirstName, aq.title AS header, aq.createdAt, aq.question AS content, ad.photoFileName AS ogImage,
				group_concat(DISTINCT cast(ras.specialtyId as char(10)) ORDER BY s.name) as specialtyIDs,
				group_concat(DISTINCT s.name ORDER BY s.name) as specialties,
				group_concat(DISTINCT cast(rap.procedureId as char(10)) ORDER BY p.name) as procedureIDs,
				group_concat(DISTINCT p.name ORDER BY p.name) as procedures
				 , ad.firstName, ad.lastname, ad.title AS doctorTitle, ad.photoFilename, adsn.siloName AS doctorSiloName, cities.name AS city, states.name AS state,
				 IF(ad.deletedAt IS NOT NULL OR adl.deletedAt IS NOT NULL OR al.deletedAt IS NOT NULL, 1, 0) AS isInactiveDoctor
				FROM askadocquestions aq
				INNER JOIN askadocquestionsilonames aqsn ON aqsn.askADocQuestionId = aq.id AND aqsn.isActive = 1 and aqsn.deletedAt IS NULL
				INNER JOIN askadocquestionanswers aqa ON aqa.askADocQuestionId = aq.id AND aqa.deletedAt IS NULL AND aqa.approvedAt <= now()
				LEFT OUTER JOIN askadocquestionspecialties ras
						JOIN specialties s on ras.specialtyId = s.id
					ON aq.id = ras.askADocQuestionId AND ras.deletedAt IS NULL
				LEFT OUTER JOIN askadocquestionprocedures rap
						JOIN procedures p on rap.procedureId = p.id
					ON aq.id = rap.askADocQuestionId AND rap.deletedAt IS NULL

				LEFT JOIN
					(
						/* Retrieve the advertisers for each question */
						SELECT aqa.askADocQuestionId, aqa.accountDoctorId
						FROM askadocquestions aq
						INNER JOIN askadocquestionsilonames aqsn ON aqsn.askADocQuestionId = aq.id AND aqsn.isActive = 1 and aqsn.deletedAt IS NULL
						INNER JOIN askadocquestionanswers aqa ON aqa.askADocQuestionId = aq.id AND aqa.deletedAt IS NULL AND aqa.approvedAt <= now()
						INNER JOIN accountdoctorlocations adl2 ON adl2.accountDoctorId = aqa.accountDoctorId
						INNER JOIN accountpractices ap2 ON ap2.id = adl2.accountPracticeId
						INNER JOIN accounts a2 ON a2.id = ap2.accountId
						INNER JOIN accountproductspurchased app ON app.accountId = a2.id AND app.dateEnd >= now() AND app.deletedAt IS NULL
						GROUP BY aqa.askADocQuestionId, aqa.accountDoctorId
					) correctDoctorId ON correctDoctorId.askADocQuestionId = aqa.askADocQuestionId

				LEFT JOIN accountdoctors ad On ad.id =
										(IF(correctDoctorId.accountDoctorId > 0, correctDoctorId.accountDoctorId, aqa.accountDoctorId))
										<!---  aqa.accountDoctorId AND ad.deletedAt IS NULL --->
				LEFT JOIN accountdoctorsilonames adsn ON adsn.accountDoctorId = ad.id AND adsn.isActive = 1 AND adsn.deletedAt IS NULL
				LEFT JOIN accountdoctorlocations adl ON adl.accountDoctorId = ad.id<!---  AND adl.deletedAt IS NULL --->
				LEFT JOIN accountlocations al ON al.id = adl.accountLocationId<!---  AND al.deletedAt IS NULL --->
				LEFT JOIN cities ON cities.id = al.cityId AND cities.deletedAt IS NULL
				LEFT JOIN states ON states.id = cities.stateId AND states.deletedAt IS NULL

				WHERE aq.deletedAt IS NULL AND aq.approvedAt <= now()
				<cfif arguments.specialty gt 0>
					AND ras.specialtyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.specialty#">
				</cfif>
				<cfif arguments.procedure gt 0>
					AND rap.procedureId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.procedure#">
				</cfif>
				<cfif arguments.tag neq "">
					AND FIND_IN_SET(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#">,REPLACE(aq.metaKeywords,', ',','))
				</cfif>
				<cfif arguments.article gt 0>
					AND aq.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.article#">
				</cfif>
				GROUP BY aq.id
				ORDER BY #arguments.order#
				)
						<!--- IF(app.accountId IS NOT NULL, 1, 0) desc --->
			) qa
			<cfif arguments.order NEQ "">
				ORDER BY #arguments.order#
			</cfif>
			LIMIT #arguments.limit# OFFSET #arguments.offset#;
		</cfquery>

		<cfreturn searchResults>
	</cffunction>

	<cffunction name="GetDoctorsQAs" returntype="query">
		<cfargument name="accountDoctorId" type="numeric" required="true">
		<cfargument name="offset"	 type="numeric"	required="false" default="0">
		<cfargument name="limit"	 type="numeric"	required="false" default="6">

		<cfset var qDoctorsQAs = "">

		<cfquery name="qDoctorsQAs" datasource="#get('dataSourceName')#">
			SELECT SQL_CALC_FOUND_ROWS
			qa.title,  qa.teaser, qa.patientFirstName,
			qa.header, qa.createdAt, qa.question, qa.answer, qa.siloName, qa.approvedAt
			FROM
			(
				SELECT
				aq.xfactorQuestionId, aq.id, aq.approvedAt,
				aq.title, "" AS teaser, aqsn.siloName,
				aq.firstName AS patientFirstName, aq.title AS header, aq.createdAt, aq.question,
				aqa.content AS answer
				FROM askadocquestionanswers aqa
				INNER JOIN askadocquestions aq ON aq.id = aqa.askADocQuestionId AND aq.deletedAt IS NULL AND aq.approvedAt <= now()
				INNER JOIN askadocquestionsilonames aqsn ON aqsn.askADocQuestionId = aq.id AND aqsn.isActive = 1 and aqsn.deletedAt IS NULL
				LEFT OUTER JOIN askadocquestionspecialties ras
						JOIN specialties s on ras.specialtyId = s.id
					ON aq.id = ras.askADocQuestionId AND ras.deletedAt IS NULL
				LEFT OUTER JOIN askadocquestionprocedures rap
						JOIN procedures p on rap.procedureId = p.id
					ON aq.id = rap.askADocQuestionId AND rap.deletedAt IS NULL

				WHERE aqa.accountDoctorId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorId#"> AND aqa.deletedAt IS NULL AND aqa.approvedAt <= now()

				GROUP BY aq.id
				ORDER BY approvedAt desc
			) qa
			ORDER BY approvedAt desc
			LIMIT #arguments.limit# OFFSET #arguments.offset#;
		</cfquery>

		<cfreturn qDoctorsQAs>
	</cffunction>

	<cffunction name="GetTotal" returntype="query">
		<cfset var qTotal = "">

		<cfquery datasource="#get('dataSourceName')#" name="qTotal">
			SELECT found_rows() AS total
		</cfquery>

		<cfreturn qTotal>
	</cffunction>

	<cffunction name="experts" returntype="query">
		<cfargument name="offset"	 type="numeric"	required="false" default="0">
		<cfargument name="limit"	 type="numeric"	required="false" default="10">

		<cfset var qExperts = "">

		<cfquery datasource="#get('dataSourceName')#" name="qExperts">
			SELECT SQL_CALC_FOUND_ROWS
					experts.accountDoctorId, experts.accountDoctorLocationId, experts.firstName, experts.lastName, experts.title, experts.photoFilename, experts.siloName,
					experts.publishAt, experts.createdAt,
					experts.city, experts.state,
					experts.practiceName,
					max(experts.maxPublishDate) AS maxPublishDate,
					experts.isAdvertiser, experts.phoneNumber
			FROM
			(
				(SELECT adl.id AS accountDoctorLocationId,
						resourcearticledoctors.accountDoctorId, accountdoctors.firstName, accountdoctors.lastName, accountdoctors.title, accountdoctors.photoFilename, adsn.siloName,
						resourcearticles.publishAt, resourcearticles.createdAt,
						cities.name AS city, states.name as state,
						ap.name AS practiceName,
						max(resourcearticles.publishAt) AS maxPublishDate,
						if(app.id IS NULL, 0, 1) AS isAdvertiser,
						CASE WHEN IFNULL((FIND_IN_SET(7, group_concat(app.accountProductId)) AND ald.phonePlus <> '' ), "") THEN ald.phonePlus
							 ELSE ""
							 END AS phoneNumber

				FROM resourcearticles
				INNER JOIN resourcearticledoctors ON resourcearticles.id = resourcearticledoctors.resourceArticleId AND resourcearticledoctors.deletedAt IS NULL
				INNER JOIN accountdoctors ON resourcearticledoctors.accountDoctorId = accountdoctors.id AND accountdoctors.photoFilename <> "" AND accountdoctors.deletedAt IS NULL
				INNER JOIN accountdoctorsilonames adsn On adsn.accountDoctorId = accountdoctors.id AND adsn.isActive = 1 AND adsn.deletedAt IS NULL
				INNER JOIN accountdoctorlocations adl On adl.accountDoctorId = accountdoctors.id AND adl.deletedAt IS NULL
				INNER JOIN accountpractices ap ON ap.id = adl.accountPracticeId AND ap.deletedAt IS NULL
				INNER JOIN accountlocations al ON al.id = adl.accountLocationId AND al.deletedAt IS NULL
				INNER JOIN accountlocationdetails ald ON ald.accountDoctorLocationId = adl.id AND ald.deletedAt IS NULL
				INNER JOIN cities ON cities.id = al.cityId AND cities.deletedAt IS NULL
				INNER JOIN states ON states.id = cities.stateId AND states.deletedAt Is NULL
				INNER JOIN accounts a ON a.id = ap.accountId AND a.deletedAt IS NULL
				LEFT JOIN accountproductspurchased app ON app.accountId = a.id AND app.dateEnd >= now() AND app.deletedAt IS NULL
				WHERE
				(
					resourcearticles.resourceArticleCategoryId = 3
				) AND
				(
					resourcearticles.deletedAt IS NULL
				)
				GROUP BY resourcearticledoctors.accountDoctorId
				ORDER BY maxPublishDate desc)

				UNION

				(SELECT adl.id AS accountDoctorLocationId,
						aqa.accountDoctorId, accountdoctors.firstName, accountdoctors.lastName, accountdoctors.title, accountdoctors.photoFilename, adsn.siloName,
						askadocquestions.approvedAt AS publishAt, askadocquestions.createdAt,
						cities.name AS city, states.name as state,
						ap.name AS practiceName,
						max(askadocquestions.approvedAt) AS maxPublishDate,
						if(app.id IS NULL, 0, 1) AS isAdvertiser,
						CASE WHEN IFNULL((FIND_IN_SET(7, group_concat(app.accountProductId)) AND ald.phonePlus <> '' ), "") THEN ald.phonePlus
							 ELSE ""
							 END AS phoneNumber
				FROM askadocquestions
				INNER JOIN askadocquestionanswers aqa ON aqa.askADocQuestionId = askadocquestions.id AND aqa.approvedAt <= now() AND aqa.deletedAt IS NULL
				INNER JOIN accountdoctors ON aqa.accountDoctorId = accountdoctors.id AND accountdoctors.photoFilename <> "" AND accountdoctors.deletedAt IS NULL
				INNER JOIN accountdoctorsilonames adsn On adsn.accountDoctorId = accountdoctors.id AND adsn.isActive = 1 AND adsn.deletedAt IS NULL
				INNER JOIN accountdoctorlocations adl On adl.accountDoctorId = accountdoctors.id AND adl.deletedAt IS NULL
				INNER JOIN accountpractices ap ON ap.id = adl.accountPracticeId AND ap.deletedAt IS NULL
				INNER JOIN accountlocations al ON al.id = adl.accountLocationId AND al.deletedAt IS NULL
				INNER JOIN accountlocationdetails ald ON ald.accountDoctorLocationId = adl.id AND ald.deletedAt IS NULL
				INNER JOIN cities ON cities.id = al.cityId AND cities.deletedAt IS NULL
				INNER JOIN states ON states.id = cities.stateId AND states.deletedAt IS NULL
				INNER JOIN accounts a ON a.id = ap.accountId AND a.deletedAt IS NULL
				LEFT JOIN accountproductspurchased app ON app.accountId = a.id AND app.dateEnd >= now() AND app.deletedAt IS NULL
				WHERE askadocquestions.deletedAt IS NULL AND askadocquestions.approvedAt <= now()
				GROUP BY aqa.accountDoctorId
				ORDER BY maxPublishDate desc)
			) experts
			GROUP BY experts.accountDoctorId
			ORDER BY maxPublishDate desc
			LIMIT #arguments.offset#, #arguments.limit#;
		</cfquery>

		<cfreturn qExperts>

	</cffunction>

	<cffunction name="recentCategories" returntype="query">
		<cfargument name="limit"	 type="numeric"	required="false" default="10">

		<cfset var qRecentCategories = "">

		<cfquery datasource="#get('dataSourceName')#" name="qRecentCategories">
			SELECT categories.procedureName, categories.siloName,	max(categories.maxPublishDate) AS maxPublishDate
			FROM
			(
				(SELECT p.name AS procedureName, p.siloName,	max(ra.publishAt) AS maxPublishDate
				FROM resourcearticles ra
				INNER JOIN resourcearticleprocedures rap ON rap.resourceArticleId = ra.id AND rap.deletedAt IS NULL
				INNER JOIN procedures p ON p.id = rap.procedureId AND p.deletedAt IS NULL
				WHERE
				(
					ra.resourceArticleCategoryId = 3
				) AND
				(
					ra.deletedAt IS NULL
				)
				GROUP BY p.id
				ORDER BY maxPublishDate desc
				LIMIT #arguments.limit#)

				UNION

				(SELECT p.name AS procedureName, p.siloName, max(aq.approvedAt) AS maxPublishDate
				FROM askadocquestions aq
				INNER JOIN askadocquestionsilonames aqsn ON aqsn.askADocQuestionId = aq.id AND aqsn.isActive = 1 and aqsn.deletedAt IS NULL
				INNER JOIN askadocquestionanswers aqa ON aqa.askADocQuestionId = aq.id AND aqa.approvedAt <= now() AND aqa.deletedAt IS NULL
				INNER JOIn askadocquestionprocedures rap ON rap.askADocQuestionId = aq.id AND rap.deletedAt IS NULL
				INNER JOIN procedures p ON p.id = rap.procedureId AND p.deletedAt IS NULL
				WHERE aq.deletedAt IS NULL AND aq.approvedAt <= now()
				GROUP BY p.id
				ORDER BY maxPublishDate desc
				LIMIT #arguments.limit#)
			) categories
			GROUP BY categories.procedureName
			ORDER BY maxPublishDate desc
			LIMIT #arguments.limit#;
		</cfquery>

		<cfreturn qRecentCategories>

	</cffunction>

	<cffunction name="GetCategories" returntype="query">

		<cfset var qCategories = "">

		<cfquery datasource="#get('dataSourceName')#" name="qCategories">
			SELECT
					/* If the procedure is a cosmetic procedure, then list it under cosmetic surgery only */
					<!--- (CASE
						WHEN ((	SELECT specialtyId
									FROM specialtyprocedures sp2
									where sp2.procedureId = sp.procedureId AND sp2.specialtyId IN (9,25) LIMIT 1) IN (9,25)) THEN
								("Cosmetic And Plastic Surgery")
						ELSE s.name
						END) AS specialtyName, --->
					s.name AS specialtyName,
					s.siloName AS specialtySiloName,
					categories.procedureName, categories.siloName,
					count(categories.questionCount) AS questionCount,
					categories.procedureId,
					cast(group_concat(DISTINCT categories.questionIds) AS char) AS questionIds,
					cast(group_concat(DISTINCT categories.specialtyIds) AS char) AS specialtyIds,
					s.id AS specialtyId
			FROM
			(
				(SELECT p.id AS procedureId, p.name AS procedureName, p.siloName, count(distinct(ra.id)) AS questionCount,
						cast(group_concat(DISTINCT concat("a",ra.id)) AS char) AS questionIds,
						cast(group_concat(DISTINCT ras.specialtyId) AS char) AS specialtyIds
				FROM resourcearticles ra
				INNER JOIN resourcearticleprocedures rap ON rap.resourceArticleId = ra.id AND rap.deletedAt IS NULL
				INNER JOIN procedures p ON p.id = rap.procedureId AND p.deletedAt IS NULL
				LEFT JOIN resourcearticlespecialties ras ON ras.resourceArticleId = ra.id AND ras.deletedAt IS NULL
				WHERE
				(
					ra.resourceArticleCategoryId = 3
				) AND
				(
					ra.deletedAt IS NULL
				)
				GROUP BY p.id)

				UNION

				(SELECT p.id AS procedureId, p.name AS procedureName, p.siloName, count(distinct(aq.id)) AS questionCount,
						cast(group_concat(DISTINCT concat("q",aq.id)) AS char) AS questionIds,
						cast(group_concat(DISTINCT aqs.specialtyId) AS char) AS specialtyIds
				FROM askadocquestions aq
				INNER JOIN askadocquestionsilonames aqsn ON aqsn.askADocQuestionId = aq.id AND aqsn.isActive = 1 and aqsn.deletedAt IS NULL
				INNER JOIN askadocquestionanswers aqa ON aqa.askADocQuestionId = aq.id AND aqa.approvedAt <= now() AND aqa.deletedAt IS NULL
				INNER JOIn askadocquestionprocedures rap ON rap.askADocQuestionId = aq.id AND rap.deletedAt IS NULL
				INNER JOIN procedures p ON p.id = rap.procedureId AND p.deletedAt IS NULL
				LEFT JOIN askadocquestionspecialties aqs ON aqs.askADocQuestionid = aq.id AND aqs.deletedAt IS NULL
				WHERE aq.deletedAt IS NULL AND aq.approvedAt <= now()
				GROUP BY p.id)
			) categories
			INNER JOIN specialtyprocedures sp ON sp.procedureId = categories.procedureId AND sp.deletedAt IS NULL
			INNER JOIN specialties s ON s.id = sp.specialtyId AND s.deletedAt IS NULL
			GROUP BY specialtyName,	categories.procedureName
			ORDER BY specialtyName, categories.procedureName;
		</cfquery>

		<cfreturn qCategories>

	</cffunction>

	<cffunction name="GetCategoryProcedures" returntype="query">
		<cfargument name="specialtySiloName" required="true">

		<cfset var qProcedures = "">

		<cfquery datasource="#get('dataSourceName')#" name="qProcedures">
			SELECT
					/* If the procedure is a cosmetic procedure, then list it under cosmetic surgery only */
					categories.specialtyName,
					categories.specialtySiloName,
					categories.procedureName, categories.siloName AS procedureSiloName,
					count(categories.questionCount) AS questionCount,
					categories.procedureId,
					cast(group_concat(DISTINCT categories.questionIds) AS char) AS questionIds
			FROM
			(
				(SELECT s.name AS specialtyName, s.siloName AS specialtySiloName, p.id AS procedureId, p.name AS procedureName, p.siloName, count(distinct(ra.id)) AS questionCount,
						cast(group_concat(DISTINCT concat("a",ra.id)) AS char) AS questionIds
				FROM specialties s
				INNER JOIN 	specialtyprocedures sp ON sp.specialtyId = s.id AND sp.deletedAt IS NULL
				INNER JOIN resourcearticleprocedures rap ON rap.procedureId = sp.procedureid AND rap.deletedAt IS NULL
				INNER JOIN resourcearticles ra ON rap.resourceArticleId = ra.id AND ra.resourceArticleCategoryId = 3 AND ra.deletedAt IS NULL
				INNER JOIN procedures p ON p.id = rap.procedureId AND p.deletedAt IS NULL
				WHERE s.siloName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.specialtySiloName#"> AND s.deletedAt IS NULL
				GROUP BY p.id)

				UNION

				(SELECT s.name AS specialtyName, s.siloName AS specialtySiloName, p.id AS procedureId, p.name AS procedureName, p.siloName, count(distinct(aq.id)) AS questionCount,
						cast(group_concat(DISTINCT concat("q",aq.id)) AS char) AS questionIds
				FROM specialties s
				INNER JOIN specialtyprocedures sp ON sp.specialtyId = s.id AND sp.deletedAt IS NULL
				INNER JOIN askadocquestionprocedures rap ON rap.procedureId = sp.procedureid AND rap.deletedAt IS NULL
				INNER JOIN askadocquestions aq ON rap.askADocQuestionId = aq.id AND aq.deletedAt IS NULL AND aq.approvedAt <= now()
				INNER JOIN askadocquestionsilonames aqsn ON aqsn.askADocQuestionId = aq.id AND aqsn.isActive = 1 and aqsn.deletedAt IS NULL
				INNER JOIN askadocquestionanswers aqa ON aqa.askADocQuestionId = aq.id AND aqa.approvedAt <= now() AND aqa.deletedAt IS NULL
				INNER JOIN procedures p ON p.id = rap.procedureId AND p.deletedAt IS NULL
				WHERE s.siloName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.specialtySiloName#"> AND s.deletedAt IS NULL
				GROUP BY p.id)
			) categories
			GROUP BY categories.procedureName
			ORDER BY categories.procedureName;
		</cfquery>

		<cfreturn qProcedures>

	</cffunction>

	<cffunction name="ProfileCheck" returntype="query" hint="Check if the patient came from a doctors profile.">
		<cfargument name="askADocQuestionId" required="true" type="numeric">

		<cfset var qProfileCheck = "">

		<cfquery datasource="#get("datasourceName")#" name="qProfileCheck">
			SELECT a.id AS accountId, ad.firstName, ad.lastName, adsn.siloName
			FROM askadocquestions
			INNER JOIN hitsprofilesdaily hp ON hp.cfId = askadocquestions.cfId AND hp.cfToken = askadocquestions.cfToken AND hp.ipAddress = askadocquestions.ipAddress
											AND date(hp.createdAt) = date(askadocquestions.createdAt)
											AND hp.createdAt < askadocquestions.createdAt
			INNER JOIN accountdoctors ad ON ad.id = hp.accountDoctorId
			INNER JOIN accountdoctorsilonames adsn ON adsn.accountDoctorId = ad.id AND adsn.isActive = 1 AND adsn.deletedAt IS NULL
			INNER JOIN accountdoctorlocations adl ON adl.accountDoctorId = ad.id
			INNER JOIN accountpractices ap ON ap.id = adl.accountPracticeId
			INNER JOIN accounts a ON a.id = ap.accountId
			where	askadocquestions.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.askADocQuestionId#">
					AND askadocquestions.cfid > 0 AND askadocquestions.cfToken > 0
			ORDER BY hp.id desc
			LIMIT 1
		</cfquery>

		<cfreturn qProfileCheck>
	</cffunction>

	<cffunction name="CheckSimilarCategoryResults" returntype="query" hint="If a category page has all the same questions as another category page, then canonical them to a more generic category">
		<cfargument name="procedureId" required="true" type="numeric">
		<cfargument name="totalRecords" required="true" type="numeric">

		<cfset var qThisProceduresQuestions = "">
		<cfset var qCheckSimilarCategoryResults = "">

		<cfquery datasource="#get("datasourceName")#" name="qThisProceduresQuestions">
			SELECT group_concat(DISTINCT aqa.askADocQuestionId) AS askADocQuestionIds, count(distinct(aqa.askADocQuestionId)) AS questionCount
			FROM askadocquestionprocedures aqp
			/* Get all the questions for this procedure */
				JOIN procedures p on p.id = aqp.procedureId AND p.deletedAt IS NULL
			INNER JOIN askadocquestions aq ON aq.id = aqp.askADocQuestionId
			INNER JOIN askadocquestionsilonames aqsn ON aqsn.askADocQuestionId = aq.id AND aqsn.isActive = 1 and aqsn.deletedAt IS NULL
			INNER JOIN askadocquestionanswers aqa ON aqa.askADocQuestionId = aqsn.askADocQuestionId AND aqa.deletedAt IS NULL AND aqa.approvedAt <= now()
			where aqp.procedureId = #arguments.procedureId# AND aqp.deletedAt IS NULL
			GROUP BY p.id
		</cfquery>

		<cfquery datasource="#get("datasourceName")#" name="qCheckSimilarCategoryResults">
			/* Find other procedures that have the same questions as this procedure */
			SELECT p2.id AS otherProcedureId, p2.name AS otherProcedureName, p2.siloName AS otherProcedureSiloName,
					count(distinct(aqa2.askADocQuestionId)) AS otherProceduresQuestionCount
			FROM
				(
					SELECT DISTINCT aqa.askADocQuestionId
					FROM askadocquestionprocedures aqp
					/* Get all the questions for this procedure */
					INNER JOIN procedures p on p.id = aqp.procedureId AND p.deletedAt IS NULL
					INNER JOIN askadocquestions aq ON aq.id = aqp.askADocQuestionId
					INNER JOIN askadocquestionsilonames aqsn ON aqsn.askADocQuestionId = aq.id AND aqsn.isActive = 1 and aqsn.deletedAt IS NULL
					INNER JOIN askadocquestionanswers aqa ON aqa.askADocQuestionId = aqsn.askADocQuestionId AND aqa.deletedAt IS NULL AND aqa.approvedAt <= now()
					where aqp.procedureId = #arguments.procedureId# AND aqp.deletedAt IS NULL
				) qs

			INNER JOIN askadocquestionprocedures aqp ON aqp.askADocQuestionId = qs.askADocQuestionId AND aqp.deletedAt IS NULL
											AND (select count(distinct(aqp5.askADocQuestionId))
												FROM askadocquestionprocedures aqp5
												INNER JOIN askadocquestions aq5 ON aq5.id = aqp5.askADocQuestionId AND aq5.deletedAt IS NULL
												INNER JOIN askadocquestionsilonames aqsn5 ON aqsn5.askADocQuestionId = aq5.id AND aqsn5.isActive = 1 and aqsn5.deletedAt IS NULL
												INNER JOIN askadocquestionanswers aqa5 ON aqa5.askADocQuestionId = aqsn5.askADocQuestionId
																						  AND aqa5.deletedAt IS NULL AND aqa5.approvedAt <= now()
												WHERE aqp5.procedureId = aqp.procedureId AND aqp5.deletedAt IS NULL
											) = #qThisProceduresQuestions.questionCount#
			INNER JOIN procedures p2 ON p2.id = aqp.procedureId AND p2.deletedAt IS NULL
			INNER JOIN askadocquestionprocedures aqp2 ON aqp2.procedureId = p2.id AND aqp2.deletedAt IS NULL
			INNER JOIN askadocquestions aq2 ON aq2.id = aqp2.askADocQuestionId AND aq2.deletedAt IS NULL
			INNER JOIN askadocquestionsilonames aqsn2 ON aqsn2.askADocQuestionId = aq2.id AND aqsn2.isActive = 1 and aqsn2.deletedAt IS NULL
			INNER JOIN askadocquestionanswers aqa2 ON aqa2.askADocQuestionId = aqsn2.askADocQuestionId AND aqa2.askADocQuestionId = qs.askADocQuestionId
													  AND aqa2.deletedAt IS NULL AND aqa2.approvedAt <= now()
			##where
				<!--- aqp.askADocQuestionId IN (#qThisProceduresQuestions.askADocQuestionIds#) --->
				<!--- aqp.askADocQuestionId = ALL (select id FROM askadocquestions WHERE id IN (#qThisProceduresQuestions.askADocQuestionIds#) AND deletedAt IS NULL)
				AND --->
				<!--- <cfloop list="#qThisProceduresQuestions.askADocQuestionIds#" index="aqId">
					aqp.askADocQuestionId = #aqId# AND
				</cfloop> --->
				<!--- aqp.askADocQuestionId IN (#qThisProceduresQuestions.askADocQuestionIds#) AND --->
				<!--- aqp.deletedAt IS NULL --->
			GROUP BY p2.id
			HAVING count(distinct(aqa2.askADocQuestionId)) = #qThisProceduresQuestions.questionCount#
			ORDER BY length(p2.name);

<!---
			/* Find other procedures that have the same questions as this procedure */
			SELECT p2.id AS otherProcedureId, p2.name AS otherProcedureName, p2.siloName AS otherProcedureSiloName,
					count(distinct(aqa2.askADocQuestionId)) AS otherProceduresQuestionCount
			FROM askadocquestionprocedures aqp
			INNER	JOIN procedures p2 ON p2.id = aqp.procedureId AND p2.deletedAt IS NULL
			INNER	JOIN askadocquestionprocedures aqp2 ON aqp2.procedureId = p2.id AND aqp2.deletedAt IS NULL
			INNER JOIN askadocquestions aq2 ON aq2.id = aqp2.askADocQuestionId AND aq2.deletedAt IS NULL
			INNER JOIN askadocquestionsilonames aqsn2 ON aqsn2.askADocQuestionId = aq2.id AND aqsn2.isActive = 1 and aqsn2.deletedAt IS NULL
			INNER JOIN askadocquestionanswers aqa2 ON aqa2.askADocQuestionId = aqsn2.askADocQuestionId  AND aqa2.deletedAt IS NULL AND aqa2.approvedAt <= now()
			where
				<!--- aqp.askADocQuestionId IN (#qThisProceduresQuestions.askADocQuestionIds#) --->
				<!--- aqp.askADocQuestionId = ALL (select id FROM askadocquestions WHERE id IN (#qThisProceduresQuestions.askADocQuestionIds#) AND deletedAt IS NULL)
				AND --->
				<!--- <cfloop list="#qThisProceduresQuestions.askADocQuestionIds#" index="aqId">
					aqp.askADocQuestionId = #aqId# AND
				</cfloop> --->
				<!--- aqp.askADocQuestionId IN (#qThisProceduresQuestions.askADocQuestionIds#) AND --->
				<!--- aqp.deletedAt IS NULL --->
			GROUP BY p2.id
			HAVING count(distinct(aqa2.askADocQuestionId)) = #qThisProceduresQuestions.questionCount#
			ORDER BY length(p2.name);
 --->


			<!--- SELECT p2.id AS otherProcedureId, p2.name AS otherProcedureName, p2.siloName AS otherProcedureSiloName,
					count(distinct(aqa2.askADocQuestionId)) AS otherProceduresQuestionCount
			FROM askadocquestionprocedures aqp2
				JOIN procedures p2 ON p2.id = aqp2.procedureId AND p2.deletedAt IS NULL
			INNER JOIN askadocquestions aq2 ON aq2.id = aqp2.askADocQuestionId AND aq2.deletedAt IS NULL
			INNER JOIN askadocquestionsilonames aqsn2 ON aqsn2.askADocQuestionId = aq2.id AND aqsn2.isActive = 1 and aqsn2.deletedAt IS NULL
			INNER JOIN askadocquestionanswers aqa2 ON aqa2.askADocQuestionId = aqsn2.askADocQuestionId  AND aqa2.deletedAt IS NULL AND aqa2.approvedAt <= now()
			where aqp2.askADocQuestionId IN (#qThisProceduresQuestions.askADocQuestionIds#) AND aqp2.deletedAt IS NULL
			GROUP BY p2.id
			HAVING otherProceduresQuestionCount = #qThisProceduresQuestions.questionCount#
			ORDER BY length(p2.name) --->

			<!--- SELECT
				p.id AS procedureId, p.name AS procedureName, p.siloName AS procedureSiloName,
					count(distinct(aqa.askADocQuestionId)) AS thisProceduresQuestionCount,
				p2.id AS otherProcedureId, p2.name AS otherProcedureName, p2.siloName AS otherProcedureSiloName,
					count(distinct(aqa2.askADocQuestionId)) AS otherProceduresQuestionCount
			FROM askadocquestionprocedures aqp
			/* Get all the questions for this procedure */
				JOIN procedures p on p.id = aqp.procedureId AND p.deletedAt IS NULL
			INNER JOIN askadocquestions aq ON aq.id = aqp.askADocQuestionId
			INNER JOIN askadocquestionsilonames aqsn ON aqsn.askADocQuestionId = aq.id AND aqsn.isActive = 1 and aqsn.deletedAt IS NULL
			INNER JOIN askadocquestionanswers aqa ON aqa.askADocQuestionId = aqsn.askADocQuestionId AND aqa.deletedAt IS NULL AND aqa.approvedAt <= now()

			/* Find other procedures that belong to the same number of questions as this procedure */
			INNER JOIN askadocquestionprocedures aqp2 ON aqp2.askADocQuestionId = aqa.askADocQuestionId AND aqp2.procedureId <> p.id AND aqp2.deletedAt IS NULL
				JOIN procedures p2 ON p2.id = aqp2.procedureId AND p2.deletedAt IS NULL
			INNER JOIN askadocquestions aq2 ON aq2.id = aqp2.askADocQuestionId AND aq2.deletedAt IS NULL
			INNER JOIN askadocquestionsilonames aqsn2 ON aqsn2.askADocQuestionId = aq2.id AND aqsn2.isActive = 1 and aqsn2.deletedAt IS NULL
			INNER JOIN askadocquestionanswers aqa2 ON aqa2.askADocQuestionId = aqsn2.askADocQuestionId  AND aqa2.deletedAt IS NULL AND aqa2.approvedAt <= now()

			where aqp.procedureId = #arguments.procedureId# AND aqp.deletedAt IS NULL
			GROUP BY p.id, p2.id
			HAVING thisProceduresQuestionCount = otherProceduresQuestionCount
			ORDER BY length(p2.name) --->

			<!--- SELECT p.id AS procedureId, p.name AS procedureName, p.siloName AS procedureSiloName, count(distinct(aq2.id)) AS questionCount
			FROM askadocquestions aq
			INNER JOIN askadocquestionsilonames aqsn ON aqsn.askADocQuestionId = aq.id AND aqsn.isActive = 1 and aqsn.deletedAt IS NULL
			INNER JOIN askadocquestionanswers aqa ON aqa.askADocQuestionId = aq.id AND aqa.deletedAt IS NULL AND aqa.approvedAt <= now()


			/* Check if these questions belong to other procedures */
			INNER JOIN askadocquestionprocedures aqp ON aqp.askADocQuestionId = aqa.askADocQuestionId
														AND aqp.deletedAt IS NULL
			INNER JOIN procedures p on p.id = aqp.procedureId AND p.deletedAt IS NULL

			/* Get the number of questions for each procedure */
			INNER JOIN askadocquestionprocedures aqp2 ON aqp2.procedureId = p.id AND aqp2.deletedAt IS NULL
			INNER JOIN askadocquestions aq2 ON aq2.id = aqp2.askADocQuestionId AND aq2.deletedAt IS NULL

			where aq.id IN (#arguments.askADocQuestionids#) AND aq.deletedAt IS NULL
			GROUP BY p.id
			HAVING questionCount = #arguments.totalRecords#
			ORDER BY length(p.name) --->

			<!--- Report of procedures with the same number of questions
				SELECT p.id AS procedureId, p.name AS procedureName,
						concat("http://alpha1.locateadoc.com/ask-a-doctor/questions/", p.siloName) AS procedureSiloName,
						count(distinct(aq.id)) AS questionCount, s.name AS specialty
				FROM askadocquestions aq
				INNER JOIN askadocquestionsilonames aqsn ON aqsn.askADocQuestionId = aq.id AND aqsn.isActive = 1 and aqsn.deletedAt IS NULL
				INNER JOIN askadocquestionanswers aqa ON aqa.askADocQuestionId = aq.id AND aqa.deletedAt IS NULL AND aqa.approvedAt <= now()


				/* Check if these questions belong to other procedures */
				INNER JOIN askadocquestionprocedures aqp ON aqp.askADocQuestionId = aqa.askADocQuestionId
															AND aqp.deletedAt IS NULL
				INNER JOIN procedures p on p.id = aqp.procedureId AND p.deletedAt IS NULL
				INNER JOIN specialtyprocedures sp ON sp.procedureId = p.id AND sp.deletedAt IS NULL
				INNER JOIN specialties s ON s.id = sp.specialtyId
				WHERE aq.deletedAt IS NULL
				GROUP BY p.id
				ORDER BY questionCount, s.name
			--->
		</cfquery>

		<cfreturn qCheckSimilarCategoryResults>
	</cffunction>

</cfcomponent>