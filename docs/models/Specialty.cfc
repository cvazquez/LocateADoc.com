<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset hasMany(name="specialtyProcedures", shortcut="specialties")>
		<cfset hasMany(name="resourceArticleSpecialties", joinType="inner")>
		<cfset hasMany(name="resourceGuideSpecialties", joinType="inner")>
		<cfset hasMany(name="specialtyProcedureRankingSummary",modelName="SpecialtyProcedureRankingSummary",foreignKey="specialtyId")>
		<cfset hasMany(name="resourceGuideTrendingTopicSummaries")>
		<cfset hasMany(name="accountLocationSpecialties")>
		<cfset property(name="lettercompare",sql="STRCMP(name,'A')")>
	</cffunction>

	<cffunction name="topSpecialtyForDoctorLocation" returntype="query">
		<cfargument name="limit"			type="numeric"	default="1">
		<cfargument name="doctorLocationId"	type="numeric"	default=""	required="true">
		<cfset var Local = {}>

		<cfquery datasource="#get('dataSourceName')#" name="Local.topSpecialty">
			SELECT c.id, c.name, c.siloName, c.isPremier, c.doctorSingular,
				count(DISTINCT d.procedureId) procedurecount,
				count(DISTINCT f.procedureId) topprocedurecount
			FROM accountdoctorlocations a
				join accountlocationspecialties b ON a.id = b.accountDoctorLocationId
				join specialties c on b.specialtyId = c.id
				left join accountdoctorprocedures d
					join specialtyprocedures e on d.procedureId = e.procedureId
				  on a.accountDoctorId = d.accountDoctorId
				  and b.specialtyId = e.specialtyId
				left join accountdoctorspecialtytopprocedures f on a.accountDoctorId = f.accountDoctorId
																and b.specialtyId = f.specialtyId
																and f.deletedAt IS NULL
			WHERE a.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.doctorLocationId)#">
				and a.deletedAt is null
				and b.deletedAt is null
				and c.deletedAt is null
				and d.deletedAt is null
				and e.deletedAt is null
			GROUP BY c.id
			ORDER BY topprocedurecount desc, procedurecount desc
			LIMIT #val(arguments.limit)#
		</cfquery>

		<cfreturn Local.topSpecialty>
	</cffunction>

	<cffunction name="findDominantSpecialty" returntype="query">
		<cfargument name="terms" required="true">
		<cfargument name="title" required="true">
		<cfargument name="body" required="true">

		<cfset firstTerm = ListFirst(arguments.terms)>
		<cfset otherTerms = ListDeleteAt(arguments.terms,1)>

		<cfquery name="dominantSpecialty" datasource="#get('dataSourceName')#">
			SELECT DISTINCT s.id, s.name,
			terms.weight * CASE
			WHEN (s.name = terms.name) then 10000
			WHEN (s.name LIKE CONCAT('%(',terms.name,'%')) then 9000
			WHEN (terms.name LIKE CONCAT('%',s.name,'%')) then
			8000 - (CHAR_LENGTH(terms.name) - CHAR_LENGTH(s.name)) * 50
			WHEN (s.name LIKE CONCAT('%',terms.name,'%')) then
			8000
			- (SELECT count(1) FROM specialties WHERE specialties.name LIKE CONCAT('%',terms.name,'%')) * 400
			- (CHAR_LENGTH(s.name) - CHAR_LENGTH(terms.name)) * 50
			ELSE -100000 END
			<!--- + (SELECT count(1) FROM gallerycaseprocedures JOIN specialtyprocedures ON gallerycaseprocedures.procedureID = specialtyprocedures.procedureID WHERE specialtyprocedures.specialtyID = s.id) * 0.1 --->
			+ (CAST(sprs.profileLeadCount AS SIGNED INT) * 3) as rank

			FROM specialties s
			JOIN specialtyprocedurerankingsummary sprs ON s.id = sprs.procedureId
			,(
			SELECT <cfqueryparam cfsqltype="cf_sql_varchar" value="#firstTerm#"> as name,
				   #(FindNoCase(firstTerm,arguments.title) ? 2 : 1) + (0.2 * FindAndCount(firstTerm,arguments.body))# as weight
			<cfloop list="#otherTerms#" index="term">
				UNION SELECT <cfqueryparam cfsqltype="cf_sql_varchar" value="#term#">,
				#(FindNoCase(term,arguments.title) ? 2 : 1) + (0.2 * FindAndCount(term,arguments.body))#
			</cfloop>
			) terms

			WHERE s.deletedAt IS NULL
			AND s.categoryId = 1
			ORDER BY rank DESC
			LIMIT 10;
		</cfquery>

		<cfreturn dominantSpecialty>
	</cffunction>

	<cffunction name="GetStates" access="public" returntype="query" output="false" hint="Return the states for doctors in this specialty">
	    <cfargument name="specialtyId" required="true" type="numeric">
	    <cfargument name="countryId" default="102" required="false" type="numeric">

	    <cfset var qStates = QueryNew("")>

		<cfif not isnumeric(arguments.countryId)>
		    <cfset arguments.countryId = 102>
		</cfif>

		<cfquery datasource="#get('dataSourceName')#" name="qStates">
			SELECT s.siloName AS specialtySiloName, ss.siloName AS stateSiloName, ss.name, lower(ss.abbreviation) AS abbreviation
			FROM accountlocationspecialties als
			INNER JOIN accountdoctorlocations adl ON adl.id = als.accountDoctorLocationId AND adl.deletedAt IS NULL
			INNER JOIN accountpractices ap On ap.id = adl.accountPracticeId and ap.deletedAt IS NULL
			INNER JOIN accounts a ON a.id = ap.accountId AND a.deletedAt IS NULL
			INNER JOIN accountlocations al ON al.id = adl.accountLocationId AND al.countryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.countryId#"> AND al.deletedAt IS NULL
			INNER JOIN statesummaries ss ON ss.id = al.stateId AND ss.deletedAt IS NULL
			INNER JOIN specialties s ON s.id = als.specialtyId AND s.deletedAt IS NULL
			WHERE als.specialtyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.specialtyId#"> AND als.deletedAt IS NULL
			GROUP BY ss.name
	     </cfquery>

	    <cfreturn qStates>
	</cffunction>
</cfcomponent>