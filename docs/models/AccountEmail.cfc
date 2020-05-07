<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset hasMany("accountDoctorEmails")>
	</cffunction>


	<cffunction name="GetAccountEmails" returntype="query">
		<cfargument name="accountId" required="true" type="numeric">

		<cfset var qAccountEmails = "">

		<cfquery datasource="#get('dataSourceName')#" name="qAccountEmails">
			SELECT distinct(e.emails) AS email
			FROM
			(
				SELECT distinct(ae.email) AS emails
				FROM accounts a
				INNER JOIN accountpractices ap ON ap.accountId = a.id AND ap.deletedAt IS NULL
				INNER JOIN accountdoctorlocations adl On adl.accountPracticeId = ap.id AND adl.deletedAt IS NULL
				INNER JOIN accountdoctoremails ade ON ade.accountDoctorId = adl.accountDoctorId AND ade.deletedAt IS NULL
				INNER JOIN accountemails ae ON ae.id = ade.accountEmailId AND ae.deletedAt IS NULL
				WHERE a.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountId#"> AND a.deletedAt IS NULL

				UNION

				SELECT distinct(ae.email) AS emails
				FROM accounts a
				INNER JOIN accountpractices ap ON ap.accountId = a.id AND ap.deletedAt IS NULL
				INNER JOIN accountpracticeemails ape ON ape.accountPracticeId = ap.id AND ape.deletedat IS NULL
				INNER JOIN accountemails ae ON ae.id = ape.accountEmailId AND ae.deletedAt IS NULL
				WHERE a.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountId#"> AND a.deletedAt IS NULL

				UNION

				SELECT distinct(ae.email) AS emails
				FROM accounts a
				INNER JOIN accountaccountemails aae ON aae.accountId = a.id AND aae.deletedAt IS NULL
				INNER JOIN accountemails ae ON ae.id = aae.accountEmailId AND ae.deletedAt IS NULL
				WHERE a.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountId#"> AND a.deletedAt IS NULL
			) e
		</cfquery>

		<cfreturn qAccountEmails>

	</cffunction>

</cfcomponent>