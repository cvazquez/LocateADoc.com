<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("city")>
		<cfset belongsTo("state")>
		<cfset hasMany(name="accountDoctorLocations", shortcut="accountDoctors")>
	</cffunction>

	<cffunction name="GetCurrentLocation" returntype="query">
		<cfargument name="accountLocationId" required="true" type="numeric">

		<cfset var qCurrentLocation = "">

		<cfquery datasource="#get('dataSourceName')#" name="qCurrentLocation">
			SELECT accountlocations.id,accountlocations.cityId,accountlocations.stateId,accountlocations.countryId,countries.name AS countryName,accountlocations.fipsCode,
				accountlocations.address,accountlocations.postalCode,accountlocations.postalCodePlus4,accountlocations.latitude,accountlocations.longitude,
				accountlocations.phone,accountlocations.fax,accountlocations.phoneTollFree,cities.name AS cityname,CreateSiloNameWithDash(cities.name) AS citysiloName,
				states.countryId AS statecountryId,states.name AS statename,states.abbreviation AS stateabbreviation,states.siloName AS statesiloName,
				states.latitude AS statelatitude,states.longitude AS statelongitude
			FROM accountlocations
			INNER JOIN cities ON accountlocations.cityId = cities.id
			INNER JOIN states ON accountlocations.stateId = states.id
			INNER JOIN countries ON accountlocations.countryId = countries.id
			WHERE accountlocations.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountLocationId#">
			AND accountlocations.deletedAt IS NULL AND cities.deletedAt IS NULL AND states.deletedAt IS NULL
			ORDER BY accountlocations.id ASC
		</cfquery>

		<cfreturn qCurrentLocation>
	</cffunction>

	<cffunction name="UpdateGeodata">
		<cfargument name="lat" default="">
		<cfargument name="lon" default="">
		<cfargument name="id" default="">

		<!--- Verify that a location exists with this ID, and it has no geodata --->
		<cfset arguments.id = Replace(arguments.id,"pin_","")>
		<cfif val(arguments.lat) neq 0 and REFind("[^0-9\.-]",arguments.lon) eq 0 and REFind("[^0-9\.-]",arguments.id) eq 0>
			<cfset doctor = model("AccountLocation").findByKey(val(arguments.id))>
			<cfif IsObject(doctor) and (doctor.latitude eq "" and doctor.longitude eq "")>
				<!--- CF Wheels creates a model object that fails its own validation
				      function, so let's update the geodata with good ol' SQL   --->
				<cfquery datasource="myLocateadocEdits">
					UPDATE accountlocations
					SET latitude  = <cfqueryparam cfsqltype="cf_sql_double" value="#val(arguments.lat)#">,
						longitude = <cfqueryparam cfsqltype="cf_sql_double" value="#val(arguments.lon)#">
					WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.id)#">;
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>

</cfcomponent>