<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("accountDoctor")>
		<cfset belongsTo("accountEmail")>
	</cffunction>


	<cffunction name="EmailDoctorWebsiteClick" returntype="query">
		<cfargument name="accountDoctorId" required="true" type="numeric">

		<cfquery datasource="#get('dataSourceName')#" name="qDoctor">
			SELECT ad.firstName, ad.lastname, a.id AS accountId, cast(group_concat(DISTINCT ae.email) AS char) AS emails,
					cast(concat(users.firstName, " ", users.lastName) AS char) AS salesFullName, users.email AS salesEmail,
					wantsWebsiteLeads
			FROM accountdoctoremails ade
			INNER JOIN accountemails ae On ae.id = ade.accountEmailId AND ae.deletedAt IS NULL
			INNER JOIN accountdoctors ad ON ad.id = ade.accountDoctorId AND ad.deletedAt IS NULL
			INNER JOIN accountdoctorlocations adl ON adl.accountDoctorId = ad.id AND adl.deletedAt IS NULL
			INNER JOIN accountpractices ap On ap.id = adl.accountPracticeId AND ap.deletedAt IS NULL
			INNER JOIN accounts a On a.id = ap.accountId AND a.deletedAt IS NULL
			INNER JOIN myMojo.users users ON users.id = a.salesManagerId
			WHERE 	ade.accountDoctorId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorId#">
					AND ade.categories = "lead"
					AND ade.deletedAt IS NULL
			GROUP BY ade.accountDoctorId
		</cfquery>

		<cfreturn qDoctor>
	</cffunction>
</cfcomponent>