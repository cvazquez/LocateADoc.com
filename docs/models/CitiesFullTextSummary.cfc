<cfcomponent extends="Model" output="false">

	<cffunction name='GetCityStates' access="public" returntype="query" hint="Matches a city and returns its state, country, lat and long">
		<cfargument name="city" default="" required="true">
		<cfargument name="postalTable" default="" required="true">
		<cfargument name="inState" default="" required="false">
		<cfargument name="inCountry" default="" required="false">
		<cfargument name="inLimit" default="10" required="false">

		<cfset var qCity = "">

		<cfquery datasource="#get('dataSourceName')#" name="qCity">
			SELECT DISTINCT	c.id, cities.siloname, c.name AS cityname, states.id AS stateId, states.name AS statename,
					states.abbreviation, states.countryId, states.latitude, states.longitude, countries.name AS countryname
			FROM citiesfulltextsummaries c
			INNER JOIN cities ON cities.id = c.id AND cities.deletedAt IS NULL
			INNER JOIN states ON cities.stateId = states.id AND states.deletedAt IS NULL
			INNER JOIN countries ON states.countryId = countries.id AND countries.deletedAt IS NULL
			WHERE MATCH (c.name) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city#*"> IN BOOLEAN MODE)
				#arguments.inState & arguments.inCountry#
			ORDER BY MATCH (c.name) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city#">) desc,
					 states.siloname asc
			<cfif val(arguments.inLimit) GT 0>LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inLimit#"></cfif>
			;
		</cfquery>

		<cfreturn qCity>
	</cffunction>

	<cffunction name="GetCities" access="public" returntype="query" hint="Used for Auto-Complete">
		<cfargument name="city" default="" required="true">
		<cfargument name="state" default="" required="false">
		<cfargument name="country" default="" required="false">

		<cfset var qCities = ''>

		<cfquery datasource="#get('dataSourceName')#" name="qCities">
			SELECT c.name, states.abbreviation
			FROM citiesfulltextsummaries c
			INNER JOIN cities ON cities.id = c.id AND cities.deletedAt IS NULL
			INNER JOIN states ON cities.stateId = states.id
			INNER JOIN countries ON states.countryId = countries.id
			WHERE (	MATCH (c.name) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city#*"> IN BOOLEAN MODE)
					<cfif arguments.state NEQ "">
						AND (
							states.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.state#%">
							OR states.abbreviation LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.state#%">
						)
					</cfif>
					<cfif arguments.country NEQ "">
						AND
						countries.abbreviation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country#">
					</cfif>
					) AND (
					c.deletedAt IS NULL AND states.deletedAt IS NULL AND countries.deletedAt IS NULL
					)
			GROUP BY c.name, states.abbreviation
			ORDER BY MATCH (c.name) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city#*"> IN BOOLEAN MODE) desc,
					 MATCH (c.name) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city#">) desc
			LIMIT 5
		</cfquery>

		<cfreturn qCities>
	</cffunction>



</cfcomponent>