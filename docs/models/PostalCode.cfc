<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("city")>
		<cfset belongsTo("state")>
	</cffunction>

	<cffunction name="getMapInfo" returntype="query" access="public">
		<cfargument name="country"	type="numeric"	required="false" default="0">
		<cfargument name="zipCode"	type="string"	required="false" default="">
		<cfargument name="city"		type="numeric"	required="false" default="0">
		<cfargument name="state"	type="numeric"	required="false" default="0">

		<cfquery datasource="#get('dataSourceName')#" name="mapCenter">
			SELECT avg(p.latitude) as latitude, avg(p.longitude) as longitude,
			max(p.latitude) - min(p.latitude) as latrange,
			max(p.longitude) - min(p.longitude) as lonrange
			FROM
			<cfif arguments.country eq 12>
				postalcodecanadas p
			<cfelse>
				postalcodes p
			</cfif>
			WHERE latitude <> 0 and longitude <> 0
			<cfif arguments.zipCode neq ''>
				AND p.postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.zipCode#">
			</cfif>
			<cfif arguments.city neq 0 and arguments.state neq 0>
				AND p.cityID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city#">
			</cfif>
			<cfif arguments.state neq 0>
				AND p.stateID = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.state#">
			</cfif>
			<cfif (arguments.zipCode eq '') and (arguments.state eq 0)>
				<cfif arguments.country eq 102>
					AND p.postalCode = '66858'
				<cfelseif arguments.country eq 12>
					AND p.postalCode = 'R8N1W9'
				</cfif>
			</cfif>
		</cfquery>

		<cfreturn mapCenter>
	</cffunction>

<cffunction name="GetAvgCoordinates" returntype="query">
	<cfargument name="stateId" required="true" type="numeric">
	<cfargument name="cityId" required="true" type="numeric">

	<cfset var qAvgCoordinates = "">

	<CFQUERY datasource="#get('dataSourceName')#" name="qAvgCoordinates">
		SELECT avg(latitude) AS latitude, avg(longitude) AS longitude, postalCode
		FROM postalcodes
		WHERE stateId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.stateId#">
				AND cityId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.cityId#">
				AND lastLine = 'L'
		GROUP BY stateId, cityId
	</CFQUERY>

	<cfreturn qAvgCoordinates>
</cffunction>



<cffunction name="GetAvgCanadaCoordinates" returntype="query">
	<cfargument name="stateId" required="true" type="numeric">
	<cfargument name="cityId" required="true" type="numeric">

	<cfset var qAvgCoordinates = "">

	<CFQUERY datasource="#get('dataSourceName')#" name="qAvgCoordinates">
		SELECT avgLatitude AS latitude, avgLongitude AS longitude, randomPostalCode AS postalCode
		FROM postalcodecanadacoordinateaverages
		WHERE stateId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.stateId#">
				AND cityId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.cityId#">
	</CFQUERY>

	<cfreturn qAvgCoordinates>
</cffunction>
</cfcomponent>
