<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocEdits")>
	</cffunction>


	<cffunction name="GetAnswer" returntype="query">
		<cfargument default="" name="siloname">
		<cfargument default="" name="id">
		<cfargument default="FALSE" name="preview" type="boolean" required="false">

		<cfset var qAnswer = "">
		<cfset var tableNames = {}>
		<cfset var tableNames.answers = "askadocquestionanswers">

		<cfif arguments.preview AND isnumeric(arguments.id)>
			<cfset tableNames.answers = "askadocquestionanswerpreviews">
		</cfif>

		<cfquery datasource="#get('dataSourceName')#" name="qAnswer">
			SELECT 	a.accountDoctorId, a.content, a.approvedAt AS publishAt, a.createdAt,
					ad.firstName, ad.middleName, ad.lastName, ad.title, ad.photoFileName,
					adsn.siloName AS doctorSiloName,
					cities.name AS city, states.abbreviation AS state,
					IF(ad.deletedAt IS NOT NULL OR adl.deletedAt IS NOT NULL OR al.deletedAt IS NOT NULL, 1, 0) AS isDeactivated,
					IF(max(appPhone.id) IS NOT NULL, ald.phonePlus, "") AS phone
			FROM #tableNames.answers# a
			LEFT JOIN accountdoctors ad ON ad.id = a.accountDoctorId<!---  AND ad.deletedAt IS NULL --->
			LEFT JOIN accountdoctorsilonames adsn ON adsn.accountDoctorId = ad.id AND adsn.isActive = 1 AND adsn.deletedAt IS NULL
			LEFT JOIN accountdoctorlocations adl ON adl.accountDoctorId = ad.id<!---  AND adl.deletedAt IS NULL --->
			LEFT JOIn accountlocations al ON al.id = adl.accountLocationId<!---  AND al.deletedAt IS NULL --->
			LEFT JOIN accountlocationdetails ald ON ald.accountDoctorLocationId = adl.id AND ald.deletedAt IS NULL
			LEFT JOIN cities ON cities.id = al.cityId AND cities.deletedAt IS NULL
			LEFT JOIN states ON states.id = cities.stateId AND states.deletedAt IS NULL
			LEFT JOIN accountpractices ap On ap.id = adl.accountPracticeId AND ap.deletedAt IS NULL
			LEFT JOIN accounts ON accounts.id = ap.accountId AND accounts.deletedAt IS NULL
			LEFT JOIN accountproductspurchased app ON app.accountId = accounts.id AND app.dateEnd >= now() AND app.deletedAt IS NULL

			LEFT JOIN accountproductspurchaseddoctorlocations appdl ON appdl.accountDoctorLocationId = adl.id AND appdl.deletedAt IS NULL
			LEFT JOIN accountproductspurchased appPhone ON appPhone.id = appdl.accountProductsPurchasedId AND appPhone.accountProductId = 7 AND appPhone.dateEnd >= now() AND appPhone.deletedAt IS NULL

			WHERE a.askADocQuestionId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
					<cfif NOT arguments.preview>
						AND a.approvedAt <= now()
					</cfif>
					AND a.deletedAt IS NULL
			GROUP BY a.accountDoctorId
			ORDER BY IF(app.id IS NOT NULL, 1, 0) desc, a.approvedAt
		</cfquery>

		<cfreturn qAnswer>

	</cffunction>

</cfcomponent>