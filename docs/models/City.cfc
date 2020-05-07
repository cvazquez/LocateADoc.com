<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocLB3")>
		<cfset hasOne(name="stateCity", shortcut="state", joinType="inner")>
		<cfset hasMany(name="AccountLocations", joinType="inner")>
		<cfset hasMany(name="postalCodes", joinType="inner")>
		<cfset hasMany(name="postalCodeCanadas", joinType="inner")>
	</cffunction>


	<cffunction name="AbbreviationToFullName">
		<cfargument default="" name="stateId">
		<cfargument default="" name="abbreviation">


		<cfquery datasource="myLocateadocLB3" name="qCityFull">
			SELECT cities.siloNameNew, cities.name
			FROM cityabbreviations ca
			INNER JOIN cities ON cities.name = ca.fullName AND cities.deletedAt IS NULL
			INNER JOIN cities AS cities2 ON cities2.id = cities.id AND cities2.deletedAt IS NULL
								AND cities2.stateId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stateId#">
			WHERE ca.shortName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.abbreviation#"> AND ca.deletedAt IS NULL
		</cfquery>

		<cfreturn qCityFull>

	</cffunction>

</cfcomponent>