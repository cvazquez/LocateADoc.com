<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("accountDoctor")>
		<cfset belongsTo("procedure")>
	</cffunction>

	<cffunction name="GetDoctorsProcedures" returntype="query">
		<cfargument name="accountDoctorId" required="true" type="numeric">

		<cfset var qDoctorsProcedures = "">

		<cfquery datasource="#get('dataSourceName')#" name="qDoctorsProcedures">
			SELECT procedures.id, procedures.name, procedures.siloName, accountdoctorprocedures.cost, accountdoctorprocedures.notes
			FROM accountdoctorprocedures
			INNER JOIN procedures ON procedures.id = accountdoctorprocedures.procedureId AND procedures.deletedAt IS NULL
			WHERE accountdoctorprocedures.accountDoctorId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorId#">
				AND accountdoctorprocedures.deletedAt IS NULL
			ORDER BY procedures.name ASC
		</cfquery>

		<cfreturn qDoctorsProcedures>
	</cffunction>

	<cffunction name="TopProceduresWithGalleries">
		<cfargument name="doctorID" required="true">

		<cfquery datasource="#get("datasourceName")#" name="qryProcedures">
			SELECT * FROM(
			SELECT accountdoctorprocedures.procedureId, accountdoctorprocedures.accountDoctorId, procedures.name, procedures.siloName
			FROM accountdoctorprocedures
			JOIN procedures ON accountdoctorprocedures.procedureId = procedures.id
			JOIN gallerycasedoctors ON accountdoctorprocedures.accountDoctorId = gallerycasedoctors.accountDoctorId
			JOIN gallerycaseprocedures ON gallerycasedoctors.galleryCaseId = gallerycaseprocedures.galleryCaseId AND accountdoctorprocedures.procedureId = gallerycaseprocedures.procedureId
			WHERE accountdoctorprocedures.accountDoctorId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.doctorID)#">
			AND accountdoctorprocedures.deletedAt IS NULL
			AND procedures.deletedAt IS NULL
			AND gallerycasedoctors.deletedAt IS NULL
			AND gallerycaseprocedures.deletedAt IS NULL
			GROUP BY accountdoctorprocedures.procedureId
			ORDER BY count(gallerycasedoctors.galleryCaseId) DESC
			LIMIT 10
			) data ORDER BY name ASC;
		</cfquery>

		<cfreturn qryProcedures>
	</cffunction>
</cfcomponent>