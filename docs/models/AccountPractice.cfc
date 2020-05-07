<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset hasMany(name="accountDoctorLocations", shortcut="accountDoctors")>
		<cfset hasMany("accountPracticeTopBenefits")>
		<cfset hasMany("accountPracticeFeederMarkets")>
		<cfset belongsTo("account")>
	</cffunction>

	<cffunction name="getAllLocations" returntype="query">
		<cfargument name="practiceID" type="numeric" required="true">
		<cfargument name="doctorID" type="numeric" required="true">
		<cfargument name="state" type="numeric" required="false" default="0">

		<cfquery name="searchResults" datasource="#get('dataSourceName')#">
			SELECT adl.id, adl.accountdoctorid as doctorID, al.id as locationID,
			al.address, cities.name as city, states.abbreviation as state, al.postalCode
			FROM accountdoctorlocations adl
			JOIN accountlocations al ON adl.accountlocationid = al.id
			JOIN cities on al.cityid = cities.id
			JOIN states on al.stateid = states.id
			WHERE adl.accountpracticeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.practiceID#">
			AND adl.accountdoctorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doctorID#">
			<cfif state gt 0>
			AND al.stateId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.state#">
			</cfif>
			AND adl.deletedAt is null
			AND al.deletedAt is null
			ORDER BY states.abbreviation asc, cities.name asc;
		</cfquery>

		<cfreturn searchResults>
	</cffunction>

</cfcomponent>