<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset belongsTo("accountDoctorLocation")>
	</cffunction>

	<cffunction name="GetPhoneDetails" returntype="query">
		<cfargument name = "accountLocationId">
		<cfargument name = "accountDoctorId">

		<cfset var qPhoneDetails = "">

		<cfquery datasource="#get('dataSourceName')#" name="qPhoneDetails">
			SELECT ald.phonePlus, ald.phoneYext, ald.hasSeminar, ald.officeHours, ald.languagesSpoken,
					ald.staffPageTitle, ald.staffMetaKeywords, ald.staffMetaDescription,
					ald.practicePageTitle, ald.practiceMetaDescription, ald.practiceMetaKeywords,
					ald.doctorPageTitle, ald.doctorMetaKeywords, ald.doctorMetaDescription,
					ald.offersPageTitle, ald.offersMetaKeywords, ald.offersMetaDescription,
					ald.financingPageTitle, ald.financingMetaKeywords, ald.financingMetaDescription,
					ald.picturesPageTitle, ald.picturesMetaKeywords, ald.picturesMetaDescription,
					ald.casePageTitle, ald.caseMetaKeywords, ald.caseMetaDescription,
					ald.reviewsPageTitle, ald.reviewsMetaKeywords, ald.reviewsMetaDescription,
					ald.contactPageTitle, ald.contactMetaKeywords, ald.contactMetaDescription

			FROM accountdoctorlocations adl
			INNER JOIN accountlocationdetails ald ON ald.accountDoctorLocationId = adl.id AND ald.deletedAt IS NULL
			WHERE adl.accountDoctorId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorId#">
					AND adl.accountLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountLocationId#">
					AND adl.deletedAt IS NULL
		</cfquery>

		<cfreturn qPhoneDetails>
	</cffunction>

</cfcomponent>