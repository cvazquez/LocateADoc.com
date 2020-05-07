<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<!--- Associations --->
		<cfset hasMany(name="galleryCaseProcedures", shortcut="galleryCases")>
		<cfset hasMany(name="accountDoctorProcedures",shortcut="accountDoctors")>
		<cfset hasMany(name="accountDoctorSpecialtyTopProcedures")>
		<cfset hasMany(name="accountDoctorLocationRecommendationProcedures", shortcut="accountDoctorLocationRecommendations")>
		<cfset hasMany(name="specialtyProcedures", shortcut="procedures")>
		<cfset hasMany(name="procedureBodyParts", shortcut="bodyParts")>
		<cfset hasMany(name="resourceArticleProcedures", joinType="inner")>
		<cfset hasMany(name="resourceGuideProcedures", joinType="inner")>
		<cfset hasMany(name="resourceGuideSubProcedures")>
		<cfset hasOne(name="procedureRankingSummary",modelName="ProcedureRankingSummary",foreignKey="procedureId")>
		<cfset hasMany(name="specialtyProcedureRankingSummary",modelName="SpecialtyProcedureRankingSummary",foreignKey="procedureId")>
		<cfset hasMany(name="resourceGuideTrendingTopicSummaries")>

		<cfset hasOne(name="procedureRedirects")>

		<!--- Calculated properties --->
		<cfset property(name="letterCompare",sql="STRCMP(name,'A')")>
	</cffunction>

	<cffunction name="findDominantProcedure" returntype="query">
		<cfargument name="terms" required="true">
		<cfargument name="title" required="true">
		<cfargument name="body" required="true">
		<cfargument name="specialties" required="false" default="">
		<cfargument name="specialtyNames" required="false" default="">

		<cfset firstTerm = ListFirst(arguments.terms)>
		<cfset otherTerms = ListDeleteAt(arguments.terms,1)>

		<cfquery name="dominantProcedure" datasource="#get('dataSourceName')#">
			SELECT DISTINCT p.id, p.name,
			terms.weight
			<cfif ListLen(arguments.specialtyNames)>
				* CASE WHEN 1=0
				<cfloop list="#arguments.specialtyNames#" index="specialtyName">
					OR (p.name LIKE '%#specialtyName#%')
				</cfloop>
				THEN 0.5 ELSE 1 END
			</cfif>
			* CASE
			WHEN (p.name = terms.name) then 10000
			WHEN (p.name LIKE CONCAT('%',terms.name,'%')) then 9000
			WHEN (terms.name LIKE CONCAT('%',p.name,'%')) then
			8000 - (CHAR_LENGTH(terms.name) - CHAR_LENGTH(p.name)) * 50
			WHEN (p.name LIKE CONCAT('%',terms.name,'%')) then
			8000
			- (SELECT count(1) FROM procedures WHERE procedures.name LIKE CONCAT('%',terms.name,'%')) * 400
			- (CHAR_LENGTH(p.name) - CHAR_LENGTH(terms.name)) * 50
			ELSE -100000 END
			+ (SELECT count(1) FROM gallerycaseprocedures WHERE gallerycaseprocedures.procedureId = p.id) * 0.1
			+ (CAST(prs.profileLeadCount AS SIGNED INT) * 3)
			as rank

			FROM procedures p
			<cfif arguments.specialties neq "">
				JOIN specialtyprocedures sp ON p.id = sp.procedureId
			</cfif>
			JOIN procedurerankingsummary prs ON p.id = prs.procedureId
			,(
			SELECT <cfqueryparam cfsqltype="cf_sql_varchar" value="#firstTerm#"> as name,
				   #(FindNoCase(firstTerm,arguments.title) ? 2 : 1) + (0.2 * FindAndCount(firstTerm,arguments.body))# as weight
			<cfloop list="#otherTerms#" index="term">
				UNION SELECT <cfqueryparam cfsqltype="cf_sql_varchar" value="#term#">,
				#(FindNoCase(term,arguments.title) ? 2 : 1) + (0.2 * FindAndCount(term,arguments.body))#
			</cfloop>

			) terms

			WHERE p.deletedAt IS NULL
			AND p.isPrimary = 1
			<cfif arguments.specialties neq "">
				AND sp.specialtyId IN (<cfqueryparam cfsqltype="cf_sql_specialty" value="#arguments.specialties#" list=true>)
			</cfif>
			ORDER BY rank DESC
			LIMIT 10;
		</cfquery>

		<cfreturn dominantProcedure>
	</cffunction>

</cfcomponent>