<cfcomponent extends="Model" output="false">

<cffunction name="GetBestBets">
</cffunction>

<cffunction name="GetSiteSearch" returntype="query">
	<cfargument name="terms" required="true">

	<cfset var qSiteSearch = "">
	<cfset var articleTerms = "">
	<cfset var listedTerms = ListChangeDelims(arguments.terms, ",", " ")>
	<cfset var listedQuotedTerms = ListQualify(listedTerms, '"')>
	<cfset var CanadaPostalRegex = "[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}">
	<cfset var hasCanadaPostal = (ReFindNoCase(CanadaPostalRegex, terms) GT 0 ? TRUE : FALSE)>
	<cfset var st = "">
	<cfset var canadaPostalCode = "">

	<cfif hasCanadaPostal>
		<cfset st = ReFindNoCase(CanadaPostalRegex, terms, 1, TRUE)>
		<cfset canadaPostalCode = trim(ReReplace(Mid(terms,st.pos[1],st.len[1]), "\s", "", "all"))>
	</cfif>


	<cfset arguments.terms = trim(arguments.terms)>
	<cfset articleTerms = arguments.terms>

	<cfquery datasource="#get('dataSourceName')#" name="qSiteSearch">
		SELECT results.recordType, results.id, results.title, results.name, results.score,
			results.extra1, cast(results.extra2 AS char) AS extra2, results.extra3
		FROM
		(
			(SELECT "states" AS recordType, s.id, "" AS title, s.name,
				IF(s.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#">, 20, 10) AS score,
				cast(s.countryId AS char) AS extra1, NULL AS extra2, NULL AS extra3
			FROM states s
			WHERE (<cfqueryparam cfsqltype="cf_sql_varchar"
								value="#arguments.terms#">
					REGEXP concat('[[:<:]]', s.name, '[[:>:]]')
					OR
					<cfqueryparam cfsqltype="cf_sql_varchar"
								value="#arguments.terms#">
					REGEXP concat('[[:<:]]', s.abbreviation, '[[:>:]]')
					)
					AND s.deletedAt IS NULL
			Limit 10)

			UNION

			(SELECT "cities" AS recordType, c.id, "" AS title, c.name,
			(MATCH (c.name) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#">)) AS score,
					cast(s.countryId AS char) AS extra1, NULL AS extra2, NULL AS extra3
			FROM citiesfulltextsummaries c
			INNER JOIN accountlocations al ON al.cityId = c.id AND al.deletedAt IS NULL AND al.countryId IN (12,48,102)
			LEFT JOIN states s ON s.id = al.stateId AND
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#">
										REGEXP concat('[[:<:]]', s.name, '[[:>:]]')
									AND s.deletedAt IS NULL
			WHERE MATCH (c.name) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#"> IN BOOLEAN MODE)
					AND c.deletedAt IS NULL
			GROUP BY al.stateId, al.cityId
			ORDER BY score DESC
			LIMIT 10)

			UNION

			(SELECT "postalCodesUS" AS recordType, p.id, "" AS title, p.postalCode, 15 AS score,
					cast(p.latitude AS char) AS extra1, cast(p.longitude AS char) AS extra2, NULL AS extra3
			FROM postalcodes p
			INNER JOIN accountlocations al ON al.postalCode = p.postalCode AND al.deletedAt IS NULL
			WHERE p.postalCode IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#listedQuotedTerms#">)
					AND p.deletedAt IS NULL
			ORDER BY score DESC
			LIMIT 1)

			UNION


			<cfif canadaPostalCode NEQ "">
				(SELECT "postalCodesCanada" AS recordType, p.id, "" AS title, p.postalCode, 15 AS score,
						cast(p.latitude AS char) AS extra1, cast(p.longitude AS char) AS extra2, cast(p.stateId AS char) AS extra3
				FROM postalcodecanadas p
				INNER JOIN accountlocations al ON replace(al.postalCode, " ", "") = p.postalCode AND al.deletedAt IS NULL
				WHERE p.postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#canadaPostalCode#">
						AND p.deletedAt IS NULL
				ORDER BY score DESC
				LIMIT 1)

				UNION
			</cfif>

			(SELECT sp.recordType, sp.id, "" AS title, sp.name,
					-- A score of 100 creates an exact match for specialties/procedures submitted from an auto-suggestion
					CASE
					WHEN LOCATE(sp.name, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#">)
						OR
						(	sp.technicalName <> "" AND
							LOCATE(sp.technicalName, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#">)
						)
						OR
						(	sp.commonName <> "" AND
							LOCATE(sp.commonName, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#">)
						)
					THEN 100
					ELSE
						MATCH (sp.name,sp.technicalName,sp.commonName) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#">)
					END
					AS score,
					cast(sp.isExplicit AS char) AS extra1, cast(sp.hasGallery AS char) AS extra2, NULL AS extra3
			FROM specialtiesproceduresfulltextsummary sp
			WHERE MATCH (sp.name,sp.technicalName,sp.commonName) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#">)
				AND sp.deletedAt IS NULL
			ORDER BY score desc
			LIMIT 5)

		) results
		ORDER BY results.score desc
	</cfquery>

	<cfreturn qSiteSearch>
</cffunction>

<cffunction name="GetDoctorAndPracticeNames" returntype="query">
	<cfargument name="terms" required="true">
	<cfargument name="limitCount" required="true">

	<cfset var qDoctors = "">
	<cfset var articleTerms = "">

	<cfset articleTerms = trim(arguments.terms)>

	<!--- Keep IN BOOLEAN MODE in the conditional or terms like Cosmetic Surger won't return because of the 50% threshold --->
	<cfquery datasource="#get('dataSourceName')#" name="qDoctors">
		SELECT SQL_CALC_FOUND_ROWS
				adss.doctorId, adss.photoFilename, adss.firstName, adss.lastName, adss.title,
				adss.city, adss.state, adss.phone,
				adss.specialtyNames AS specialtyList,
				adss.practice, adss.siloName,
				CASE
					WHEN adss.fullName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#"> THEN 100
					ELSE MATCH (adss.fullName) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#">)
				END AS score
			FROM accountdoctorsearchsummary adss
			WHERE MATCH (adss.fullName) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#">)
			GROUP BY adss.doctorId
			ORDER BY score DESC
			<cfif isnumeric(arguments.limitCount)>
				LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.limitCount)#">
			</cfif>
	</cfquery>

	<cfreturn qDoctors>
</cffunction>

<cffunction name="GetGuides" returntype="query">
	<cfargument name="terms" required="true">
	<cfargument name="limitCount" default="" required="false">
	<cfargument name="page" default="" required="false">

	<cfset var qGuideSearch = "">
	<cfset var articleTerms = "">

	<cfset articleTerms = trim(arguments.terms)>

	<!--- Keep IN BOOLEAN MODE in the conditional or terms like Cosmetic Surger won't return because of the 50% threshold --->
	<cfquery datasource="#get('dataSourceName')#" name="qGuideSearch">
		SELECT SQL_CALC_FOUND_ROWS rg.id, rg.title, rg.teaser,
				MATCH (rg.content) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#articleTerms#">) AS score,
				rg.link, rg.publishAt, rg.`type`
		FROM resourceguidesfulltextsummary rg
		WHERE MATCH (rg.content) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#articleTerms#"> IN BOOLEAN MODE)
				AND rg.deletedAt IS NULL
		ORDER BY score desc
		<cfif isnumeric(arguments.limitCount)>
			LIMIT
			<cfif isnumeric(arguments.page)>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#( (val(arguments.page) - 1) * val(arguments.limitCount))#">,
			</cfif>
		 	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.limitCount)#">
		</cfif>
	</cfquery>

	<cfreturn qGuideSearch>
</cffunction>

<cffunction name="GetFeaturesAndArticles">
	<cfargument name="terms" required="true">
	<cfargument name="limitCount" default="" required="false">
	<cfargument name="page" default="" required="false">

	<cfset var qFeaturesAndArticles = "">
	<cfset var articleTerms = "">

	<cfset arguments.terms = trim(arguments.terms)>
	<cfset articleTerms = arguments.terms>

	<!--- Keep IN BOOLEAN MODE in the conditional or terms like Cosmetic Surger won't return because of the 50% threshold --->
	<cfquery datasource="#get('dataSourceName')#" name="qFeaturesAndArticles">
		SELECT SQL_CALC_FOUND_ROWS recordType, id, title, content AS name,
			MATCH (title,content) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#articleTerms#">) AS score,
			teaser, postDate AS publishAt, link
		FROM resourcearticlesblogsfulltextsummary
		WHERE MATCH (title,content) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#articleTerms#"> IN BOOLEAN MODE)
		ORDER BY score desc
		<cfif isnumeric(arguments.limitCount)>
			LIMIT
			<cfif isnumeric(arguments.page)>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#( (val(arguments.page) - 1) * val(arguments.limitCount))#">,
			</cfif>
		 	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.limitCount)#">
		</cfif>
	</cfquery>

	<cfreturn qFeaturesAndArticles>
</cffunction>

<cffunction name="GetAskADoctor">
	<cfargument name="terms" required="true">
	<cfargument name="limitCount" default="" required="false">
	<cfargument name="page" default="" required="false">

	<cfset var qAskADoctor = "">
	<cfset var askADoctorTerms = "">

	<cfset arguments.terms = trim(arguments.terms)>
	<cfset askADoctorTerms = reReplaceNoCase(arguments.terms, "[^A-Za-z0-9\s]", "", "all")>

	<!--- Keep IN BOOLEAN MODE in the conditional or terms like Cosmetic Surger won't return because of the 50% threshold --->
	<cfquery datasource="#get('dataSourceName')#" name="qAskADoctor">
		SELECT SQL_CALC_FOUND_ROWS id, title, question AS name,
			MATCH (title,question,answers) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#askADoctorTerms#">) AS score,
			teaser, postDate AS publishAt, link
		FROM askadoctorfulltextsummary
		WHERE MATCH (title,question,answers) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#askADoctorTerms#"> IN BOOLEAN MODE)
		GROUP BY id
		ORDER BY score desc
		<cfif isnumeric(arguments.limitCount)>
			LIMIT
			<cfif isnumeric(arguments.page)>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#( (val(arguments.page) - 1) * val(arguments.limitCount))#">,
			</cfif>
		 	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.limitCount)#">
		</cfif>
	</cfquery>

	<cfreturn qAskADoctor>
</cffunction>

<cffunction name="GetAutoSuggest" returntype="query">
	<cfargument name="terms" required="true">

	<cfset var qAutoSuggest = "">

	<cfset var CanadaPostalRegex = "[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}">
	<cfset var hasCanadaPostal = (ReFindNoCase(CanadaPostalRegex, terms) GT 0 ? TRUE : FALSE)>
	<cfset var st = "">
	<cfset var canadaPostalCode = "">

	<cfif hasCanadaPostal>
		<cfset st = ReFindNoCase(CanadaPostalRegex, terms, 1, TRUE)>
		<cfset canadaPostalCode = trim(ReReplace(Mid(terms,st.pos[1],st.len[1]), "\s", "", "all"))>
	</cfif>

	<cfset arguments.terms = trim(arguments.terms)>
	<cfset articleTerms = arguments.terms>

	<cfquery datasource="#get('dataSourceName')#" name="qAutoSuggest">
		SELECT results.name AS id, results.name AS label, results.name AS value
		FROM
		(
 			(SELECT s.name
			FROM states s
			WHERE	(
						s.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.terms#%">
						OR
						s.abbreviation LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.terms#%">
					)
					AND s.deletedAt IS NULL
			ORDER BY IF(s.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#%">, 0, 1)
			Limit 5)

			UNION

			(SELECT c.name
			FROM citiesfulltextsummaries c
			-- INNER JOIN accountlocations al ON al.cityId = c.id AND al.deletedAt IS NULL
			WHERE c.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.terms#%">
					AND c.deletedAt IS NULL
			ORDER BY IF(c.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#%">, 0, 1)
			LIMIT 5)

			UNION

			(SELECT sp.name
			FROM specialtiesproceduresfulltextsummary sp
			WHERE sp.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.terms#%">
				AND sp.deletedAt IS NULL
			ORDER BY IF(sp.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#%">, 0, 1)
			LIMIT 5)

		) results
		ORDER BY IF(results.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#%">, 0, 1)
		LIMIT 15
	</cfquery>

	<cfreturn qAutoSuggest>
</cffunction>


<cffunction name="GetAutoSuggestJoined" returntype="query">
	<cfargument name="terms" required="true">

	<cfset var qAutoSuggest = "">

	<cfset var listedTerms = ListChangeDelims(arguments.terms, ",", " ")>
	<cfset var listedQuotedTerms = ListQualify(listedTerms, '"')>

	<cfset var CanadaPostalRegex = "[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}">
	<cfset var hasCanadaPostal = (ReFindNoCase(CanadaPostalRegex, terms) GT 0 ? TRUE : FALSE)>
	<cfset var st = "">
	<cfset var canadaPostalCode = "">

	<cfif hasCanadaPostal>
		<cfset st = ReFindNoCase(CanadaPostalRegex, terms, 1, TRUE)>
		<cfset canadaPostalCode = trim(ReReplace(Mid(terms,st.pos[1],st.len[1]), "\s", "", "all"))>
	</cfif>

	<cfset arguments.terms = trim(arguments.terms)>
	<cfset articleTerms = arguments.terms>

	<cfquery datasource="#get('dataSourceName')#" name="qAutoSuggest">
		SELECT results.terms AS id, results.terms AS label, results.terms AS value
		FROM
		(
			SELECT cast(trim(concat_ws(" ", sp.name, cities.name, s.name)) AS char) AS terms
				FROM states temp
				LEFT JOIN states s ON
							(
								s.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.terms#%">
								OR
								s.abbreviation LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.terms#%">
								OR
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#">
								REGEXP concat('[[:<:]]', s.name, '[[:>:]]')
							)
							AND s.deletedAt IS NULL

				LEFT JOIN citiesfulltextsummaries cities ON cities.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.terms#%">
														AND cities.deletedAt IS NULL
				LEFT JOIN accountlocations al ON al.cityId = cities.id AND al.deletedAt IS NULL

				LEFT JOIN specialtiesproceduresfulltextsummary sp ON
					(
						sp.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.terms#%">
						OR
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#">
						REGEXP concat('[[:<:]]', sp.name, '[[:>:]]')
					)

						AND sp.deletedAt IS NULL
				WHERE temp.id = 1
		) results
		ORDER BY length(results.terms) desc
		LIMIT 15
	</cfquery>

	<cfreturn qAutoSuggest>
</cffunction>

<cffunction name="GetSpecialtyProcedureIds" returntype="string">
	<cfargument name="specialtyId">

	<cfset var qSpecialtyProcedure = "">

	<cfquery datasource="#get('dataSourceName')#" name="qSpecialtyProcedure">
		SELECT cast(group_concat(sp.procedureId) AS char) AS ids
		FROM specialtyprocedures sp
		INNER JOIN specialties s On s.id = sp.specialtyId AND s.deletedAt IS NULL
		INNER JOIN procedures p ON p.id = sp.procedureId AND p.deletedAt IS NULL
		WHERE sp.specialtyId = <cfqueryparam value="#arguments.specialtyId#" cfsqltype="cf_sql_integer">
			AND sp.deletedAt IS NULL
		GROUP BY sp.specialtyId
	</cfquery>

	<cfreturn qSpecialtyProcedure.ids>
</cffunction>

<cffunction name="GetFoundRows" returntype="numeric">
	<cfset var q = "">

	<cfquery datasource="myLocateadocLB3" name="q">
		Select Found_Rows() AS foundrows
	</cfquery>

	<cfreturn q.foundRows>
</cffunction>

</cfcomponent>