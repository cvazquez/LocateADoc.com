<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocLB3")>
		<cfset table("accountproductspurchasedhistory")>
		<cfset belongsTo("account")>
	</cffunction>

	<cffunction name="DoctorHasProductsPurchasedHistory" returntype="boolean">
		<cfargument name="accountDoctorId" required="true" type="numeric">

		<cfset var qDoctor = "">

		<cfquery datasource="#get("datasourcename")#" name="qDoctor">
			SELECT count(*) AS hasPast
			FROM accountdoctorlocations
			INNER JOIN accountpractices ON accountpractices.id = accountdoctorlocations.accountPracticeId AND accountpractices.deletedAt IS NULL
			INNER JOIN accountproductspurchasedhistory ON accountproductspurchasedhistory.accountId = accountpractices.accountId AND accountproductspurchasedhistory.deletedAt IS NULL
			INNER JOIN accounts ON accounts.id = accountpractices.accountId AND accounts.deletedAt IS NULL
			WHERE accountdoctorlocations.accountDoctorId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorId#"> AND accountdoctorlocations.deletedAt IS NULL
		</cfquery>

		<cfreturn (qDoctor.hasPast GT 0 ? true : false)>
	</cffunction>
</cfcomponent>