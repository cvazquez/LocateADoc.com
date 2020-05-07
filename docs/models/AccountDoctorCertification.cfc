<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("accountDoctor")>
		<cfset belongsTo("certification")>
	</cffunction>

	<cffunction name="GetDoctorsCertifications" returntype="query">
		<cfargument name="accountDoctorId" required="true" type="numeric">

		<cfset var qDoctorsCertifications = "">

		<cfquery datasource="#get('dataSourceName')#" name="qDoctorsCertifications">
			SELECT certifications.name, certifications.logoFileName
			FROM certifications
			INNER JOIN accountdoctorcertifications ON certifications.id = accountdoctorcertifications.certificationId
			WHERE accountdoctorcertifications.accountDoctorId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorId#">
				AND	certifications.deletedAt IS NULL AND accountdoctorcertifications.deletedAt IS NULL
		</cfquery>

		<cfreturn qDoctorsCertifications>
	</cffunction>
</cfcomponent>