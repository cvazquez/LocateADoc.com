<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset table("specialtyprocedurerankingsummary")>
		<cfset belongsTo("specialty")>
		<cfset belongsTo("procedure")>
	</cffunction>

	<cffunction name="getTopSpecialtiesForDoctor" returntype="query">
		<cfargument name="limit"			type="numeric"	default="2">
		<cfargument name="accountDoctorId"	type="numeric"	default=""	required="true">
		<cfset var Local = {}>

		<cfquery datasource="#get('dataSourceName')#" name="Local.queryResult">
			SELECT specialties.id, specialties.name, specialties.siloName, specialties.isPremier, SUM(profileLeadCount) as leadCount, specialties.doctorSingular
			FROM specialtyprocedurerankingsummary
			INNER JOIN specialties ON specialtyprocedurerankingsummary.specialtyId = specialties.id
			LEFT OUTER JOIN accountlocationspecialties ON specialties.id = accountlocationspecialties.specialtyId
			INNER JOIN accountdoctorlocations ON accountlocationspecialties.accountDoctorLocationId = accountdoctorlocations.id
			WHERE accountdoctorlocations.accountDoctorId = #arguments.accountDoctorId#
				AND specialtyprocedurerankingsummary.deletedAt IS NULL
				AND specialties.id IS NOT NULL
				AND specialties.deletedAt IS NULL
				AND accountlocationspecialties.deletedAt IS NULL
				AND accountdoctorlocations.deletedAt IS NULL
			GROUP BY specialtyprocedurerankingsummary.specialtyId
			ORDER BY leadCount DESC
			LIMIT #arguments.limit#
		</cfquery>

		<cfreturn Local.queryResult>
	</cffunction>

</cfcomponent>