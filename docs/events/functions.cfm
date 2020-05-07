<!--- Place functions here that should be globally available in your application. --->

<!---
This will convert a 10-digit phone number into a string with a xxx-xxx-xxxx format.
If the number does not have 10 digits, it will return the original value, unchanged.
--->
<cffunction name="formatPhone" returntype="string">
	<cfargument name="phone" required="true">
	<cfset var formattedPhone = REReplace(arguments.phone,"[^0-9]","","all")>
	<cfif len(formattedPhone) eq 10>
		<cfset formattedPhone = "#Left(formattedPhone,3)#-#Mid(formattedPhone,4,3)#-#Right(formattedPhone,4)#">
	<cfelse>
		<cfset formattedPhone = arguments.phone>
	</cfif>
	<cfreturn formattedPhone>
</cffunction>

<cffunction name="StripPhoneNumber">
	<cfargument name="phone_number" default="" required="no">

	<cfscript>
		var l_phone_number = ReplaceList(arguments.phone_number, "(,),-,., ", '');
		return l_phone_number;
	</cfscript>
</cffunction>

<cfinclude template="/LocateADocModules/_isEmail.cfm">

<cffunction name="deAccent" hint="Replace Accented characters with their non-accented equivalents.">
	<cfargument default="" name="str">

	<cfscript>
    //based on the approach found here: http://stackoverflow.com/a/1215117/894061
    var Normalizer = createObject("java","java.text.Normalizer");
    var NormalizerForm = createObject("java","java.text.Normalizer$Form");
    var normalizedString = trim(Normalizer.normalize(arguments.str, createObject("java","java.text.Normalizer$Form").NFD));
    var pattern = createObject("java","java.util.regex.Pattern").compile("\p{InCombiningDiacriticalMarks}+");
    return trim(pattern.matcher(normalizedString).replaceAll(""));
    </cfscript>
</cffunction>

<cffunction name="mapDistance" hint="Calculates the distance between two points">
	<cfargument name="lat1" default="0">
	<cfargument name="lng1" default="0">
	<cfargument name="lat2" default="0">
	<cfargument name="lng2" default="0">
	<cfset var Local = {}>

	<!---
		Constrain result of equation within ACos in order to prevent
		errors due to rounding of floating point numbers
	--->
	<cfset mapDistanceCalc = Sin(arguments.lat1 / 57.2958) * Sin(arguments.lat2 / 57.2958) + (Cos(arguments.lat1 / 57.2958) * Cos(arguments.lat2 / 57.2958) * Cos((arguments.lng2 / 57.2958) - (arguments.lng1 / 57.2958)))>
	<cfif mapDistanceCalc gt 1><cfset mapDistanceCalc = 1></cfif>
	<cfif mapDistanceCalc lt -1><cfset mapDistanceCalc = -1></cfif>

	<cfreturn  6371 * ACos(mapDistanceCalc)>
</cffunction>

<cffunction name="mapZoom" hint="Calculates zoom level based on distance and map container size">
	<cfargument name="distance" default="0">
	<!--- mapDisplay is the size of the div the map is displayed in. mapDisplay = Min(width,height) --->
	<cfargument name="mapDisplay" default="400">

	<cfreturn Fix(8 - Log(1.6446 * arguments.distance / Sqr(2 * (arguments.mapDisplay * arguments.mapDisplay))) / Log(2))-1>
</cffunction>

<cffunction name="ParseLocation" returntype="struct" hint="Extracts city, state, zip from the location field">
	<cfargument name="locationString" type="string" required="yes">
	<cfargument name="country" type="numeric" required="no" default="102">
	<cfargument name="ignoreEmptyCities" type="boolean" required="no" default="true">

	<cfset var postalTable = "">
	<cfset var cityzips = QueryNew("")>
	<!--- Initialize an empty location structure --->
	<cfset var location			= {}>
	<cfset location.querystring	= arguments.locationString>
	<cfset location.country		= arguments.country>
	<cfset location.countryname	= "">
	<cfset location.city		= "">
	<cfset location.cityname	= "">
	<cfset location.state		= "">
	<cfset location.statename	= "">
	<cfset location.statesiloname = "">
	<cfset location.stateabbr	= "">
	<cfset location.zipCode		= "">
	<cfset location.zipFound	= false>
	<cfset location.stateFound	= false>
	<cfset location.cityFound	= false>
	<cfset location.longitude	= "">
	<cfset location.latitude	= "">

	<cfif arguments.country eq 12>
		<cfset postalTable = "PostalCodeCanadas">
	<cfelse>
		<cfset postalTable = "PostalCodes">
	</cfif>

	<!--- Let's pad the string with spaces at the ends in lieu of proper lookahead support --->
	<cfset locationString	= " " & locationString & " ">

	<!--- First, look for a 5-digit number. That might be the zip code. --->
	<cfset zipAt = REFind("[^0-9][0-9]{5}[^0-9]",locationString)>


	<!--- If we find one that's all we need, check the postalcodes DB table to verify that it exists --->
	<cfif zipAt gt 0>
		<cfquery datasource="#get('dataSourceName')#" name="USZip">
			SELECT pc.cityId, c.name AS cityName, pc.stateId, s.name AS stateName, s.abbreviation AS stateAbbreviation, pc.postalCode, pc.longitude, pc.latitude
			FROM postalcodes pc
			INNER JOIN cities c ON c.id = pc.cityId AND c.deletedAt IS NULL
			INNER JOIN states s ON s.id = pc.stateId AND s.deletedAt IS NULL
			WHERE pc.postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(locationString,zipAt+1,5)#"> AND pc.deletedAt IS NULL
			LIMIT 1
		</cfquery>

		<cfif USZip.recordCount GT 0>
			<cfset location.country		= 102>
			<cfset location.countryname	= "United States">
			<cfset location.city		= USZip.cityId>
			<cfset location.cityname	= USZip.cityName>
			<cfset location.state		= USZip.stateId>
			<cfset location.statename	= USZip.stateName>
			<cfset location.stateabbr	= USZip.stateAbbreviation>
			<cfset location.zipCode		= USZip.postalCode>
			<cfset location.zipFound	= true>
			<cfset location.longitude	= USZip.longitude>
			<cfset location.latitude	= USZip.latitude>
		</cfif>
	<cfelse>

		<!--- Check for a possible Canadian postal code. --->
		<cfset zipAt = REFind("[^a-zA-Z0-9][a-zA-Z]\d[a-zA-Z].?\d[a-zA-Z]\d[^a-zA-Z0-9]",locationString)>

		<cfif zipAt gt 0>
			<cfquery datasource="#get('dataSourceName')#" name="CAZip">
				SELECT pc.cityId, c.name AS cityName, pc.stateId, s.name AS stateName, s.abbreviation AS stateAbbreviation, pc.postalCode, pc.longitude, pc.latitude
				FROM postalcodecanadas pc
				INNER JOIN cities c ON c.id = pc.cityId AND c.deletedAt IS NULL
				INNER JOIN states s ON s.id = pc.stateId AND s.deletedAt IS NULL
				WHERE pc.postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REReplace(trim(Mid(locationString,zipAt+1,7)),"[^a-zA-Z0-9]","","all")#"> AND pc.deletedAt IS NULL
				LIMIT 1
			</cfquery>

			<cfif CAZip.recordCount GT 0>
				<cfset postalTable = "PostalCodeCanadas">

				<cfset location.country		= 12>
				<cfset location.countryname	= "Canada">
				<cfset location.city		= CAZip.cityId>
				<cfset location.cityname	= CAZip.cityName>
				<cfset location.state		= CAZip.stateId>
				<cfset location.statename	= CAZip.stateName>
				<cfset location.stateabbr	= CAZip.stateAbbreviation>
				<cfset location.zipCode 	= CAZip.postalCode>
				<cfset location.zipFound 	= true>
				<cfset location.longitude	= CAZip.longitude>
				<cfset location.latitude	= CAZip.latitude>
			</cfif>
		</cfif>

	</cfif>

	<!--- Only do more if we don't alrady have a zip code --->
	<cfif not val(len(location.zipCode))>

		<!--- Now let's treat the string as a space-delimited list containing only letters or hyphens --->
		<cfset locationString = trim(REReplace(LCase(locationString),"[^a-z0-9]"," ","all"))>

		<!--- And make an unbroken version to help find multi-word states and cities --->
		<cfset locationUnbroken = Replace(locationString," ","","all")>

		<cfset inCountry = Iif(arguments.country neq 0, DE(" AND countries.id = #arguments.country#"), DE(""))>

		<cfif val(len(locationString))>
			<!--- We check each item in the list for the first word of a state name or a state
				  abbreviation. If there's a partial match, then we check the unbroken string
				  for a match. If a state match is found, then we stop checking.   		  --->

			<!--- Look for state Abbr --->
			<cfset i = ListLen(locationString,' ')>
			<cfloop condition="i gt 0 and not val(len(location.state))">
				<cfif Len(ListGetAt(locationString,i," ")) lte 4>
					<cfset State	= model("State")
										.findAll(
											select	= "
												states.id,
												states.name AS statename,
												CreateSiloNameWithDash(states.name) AS stateSiloName,
												states.abbreviation,
												states.countryId,
												states.latitude,
												states.longitude,
												countries.name AS countryname",
											include	= "country",
											where	= "abbreviation = '#ListGetAt(locationString,i," ")#'#inCountry#")>
					<cfif State.recordcount gt 0>
						<cfset location.country		= State.countryId>
						<cfset location.countryname	= State.countryname>
						<cfset location.state		= State.id>
						<cfset location.statename	= State.statename>
						<cfset location.stateabbr	= State.abbreviation>
						<cfset location.stateSiloName	= State.stateSiloName>
						<cfset location.stateFound	= true>
						<cfset location.latitude	= State.latitude>
						<cfset location.longitude	= State.longitude>
						<cfset locationString	= ListDeleteAt(locationString,i," ")>
						<!--- Remove abbreviation from unbroken string --->
						<cfset locationUnbroken = Replace(locationString," ","","all")>

						<cfif location.country eq 12>
							<cfset postalTable = "PostalCodeCanadas">
						</cfif>

						<cfbreak>
					</cfif>
				</cfif>
				<cfset i-->
			</cfloop>

			<!--- Look for state name --->
			<cfif not val(len(location.state))>
				<cfset i = 1>
				<cfloop condition="i lte ListLen(locationString,' ') and not val(len(location.state))">
					<cfset State	= model("State")
										.findAll(
											select	= "
												states.id,
												states.name AS statename,
												states.abbreviation,
												states.siloname,
												states.latitude,
												states.longitude,
												states.countryId,
												countries.name AS countryname",
											include	= "country",
											where	= "siloname like '#ListGetAt(locationString,i," ")#%'#inCountry#",
											order	= "siloname asc")>
					<cfloop query="State">
						<cfif locationUnbroken contains State.siloname>
							<cfset location.country		= State.countryId>
							<cfset location.countryname	= State.countryname>
							<cfset location.state		= State.id>
							<cfset location.statename	= State.statename>
							<cfset location.stateabbr	= State.abbreviation>
							<cfset location.stateFound	= true>
							<cfset location.latitude	= State.latitude>
							<cfset location.longitude	= State.longitude>
							<cfloop list="#State.statename#" index="unused" delimiters=" ">
								<cfif i gt ListLen(locationString," ")><cfbreak></cfif>
								<cfset locationString = ListDeleteAt(locationString,i," ")>
							</cfloop>
							<cfbreak>
						</cfif>
					</cfloop>
					<cfset i++>
				</cfloop>
			</cfif>

			<!--- We check each item in the list for the first word of a city name. If there's a
				  partial match, then we check the unbroken string for a match. If a city match
				  is found, then we stop checking. 											 --->
			<cfif val(len(location.state))>
				<cfset inState = " AND states.id = #location.state#">
			<cfelse>
				<cfset inState = "">
			</cfif>

			<!--- Look for city name --->
			<cfset possibles = {}>
			<cfset i = 1>
			<cfloop condition="i lte ListLen(locationString,' ') and not val(len(location.city))">
				<cfset thisterm = ListGetAt(locationString,i," ")>
				<cfset City = model("CitiesFullTextSummary").GetCityStates(
								city		= thisterm,
								postalTable	= postalTable,
								inState		= inState,
								inCountry	= inCountry)>

				<cfloop query="City">
					<cfif locationUnbroken contains City.siloname>
						<cfset possibles["#City.id#_#City.stateId#"] = {
							cityname	= City.cityname,
							state		= City.stateId,
							statename	= City.statename,
							stateabbr	= City.abbreviation,
							country		= City.countryId,
							countryname	= City.countryname,
							longitude	= City.longitude,
							latitude	= City.latitude,
							matched		= len(City.siloname)
						}>
					</cfif>
				</cfloop>
				<cfset i++>
			</cfloop>
			<cfset matchcount	= 0>
			<cfset selectedcity	= 0>
			<cfset stateList = "">
			<cfloop collection="#possibles#" item="key">
				<cfif possibles[key].matched gt matchcount>
					<!--- Ignore cities that do not have doctors --->
					<cfset accountCheck = model("AccountLocation").findAll(
						select="id",
						where="cityid=#listFirst(key,'_')# AND stateid=#listLast(key,'_')#",
						$limit="1"
					)>
					<cfif accountCheck.recordcount eq 1 or not ignoreEmptyCities>
						<cfset matchcount	= possibles[key].matched>
						<cfset selectedcity	= listFirst(key,"_")>
						<cfset selectedstate= listLast(key,"_")>
					</cfif>
					<cfset stateList = possibles[key].state>
				<cfelseif possibles[key].matched eq matchcount and not ListFind(stateList,possibles[key].state)>
					<cfset stateList = ListAppend(stateList,possibles[key].state)>
				</cfif>
			</cfloop>
			<cfset location._alternates = possibles>
			<cfif val(selectedcity)>
				<cfset selcity = possibles["#selectedcity#_#selectedstate#"]>
				<cfset location.country		= selcity.country>
				<cfset location.countryname	= selcity.countryname>
				<cfset location.state		= selcity.state>
				<cfset location.statename	= selcity.statename>
				<cfset location.stateabbr	= selcity.stateabbr>
				<cfset location.city		= selectedcity>
				<cfset location.cityname	= selcity.cityname>
				<cfset location.cityFound	= true>
				<cfset location.longitude	= selcity.longitude>
				<cfset location.latitude	= selcity.latitude>
				<cfif ListLen(stateList) eq 1>
					<cfset location.stateFound = true>
				</cfif>
			</cfif>
		</cfif>
	</cfif>

	<!--- If we still dont have a zip but we do have a city and state, find the zipcode for the center of the city --->
	<cfif not val(len(location.zipcode)) and val(location.city)>
		<cfif location.country eq 102>
			<cfset cityzips =  model("PostalCode").GetAvgCoordinates(
												stateId	= location.state,
												cityId	= location.city)>
		<cfelseif location.country eq 12>
			<cfset cityzips =  model("PostalCode").GetAvgCanadaCoordinates(
												stateId	= location.state,
												cityId	= location.city)>
		</cfif>
		<cfif val(cityzips.recordcount)>
			<cfset location.zipcode		= cityzips.postalCode>
			<cfset location.latitude	= cityzips.latitude>
			<cfset location.longitude	= cityzips.longitude>
		</cfif>
	</cfif>

	<cfreturn location>
</cffunction>

<cffunction name="getSponsoredLink" returntype="struct" hint="Returns a structure containing data for the sponsored link tile ad">
	<cfargument name="city"			type="numeric"	required="false" default="0">
	<cfargument name="state"		type="numeric"	required="false" default="0">
	<cfargument name="zipCode"		type="string"	required="false" default="">
	<cfargument name="specialty"	type="numeric"	required="false" default="0">
	<cfargument name="procedure"	type="numeric"	required="false" default="0">
	<cfargument name="bodyPartId"	type="numeric"	required="false" default="0">
	<cfargument name="paramsAction"	type="string"	required="false" default="">
	<cfargument name="paramsController"	type="string"	required="false" default="">

	<!--- Initialize an empty return structure --->
	<cfset var local = {}>
	<cfset var sponsoredInfo = {}>
	<cfset sponsoredInfo.valid = 0>
	<cfset sponsoredInfo.doctor = "">
	<cfset sponsoredInfo.procedures = "">

	<cfparam default="" name="client.city">
	<cfparam default="" name="client.state">

	<cfif val(arguments.city) EQ 0 AND val(client.city) GT 0>
		<cfset arguments.city = val(client.city)>
	</cfif>

	<cfif val(arguments.state) EQ 0 AND val(client.state) GT 0>
		<cfset arguments.state = val(client.state)>
	</cfif>

	<!--- Get country ID --->
	<cfset countryID = 102>
	<cfif state neq 0>
		<cfquery datasource="#get('dataSourceName')#" name="getCountry">
			SELECT countryID FROM states WHERE id = <cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_integer">;
		</cfquery>
		<cfset countryID = getCountry.countryID>
	</cfif>

	<!--- Get zone ID --->
	<cfif zipCode eq "" and state neq 0 and city eq 0>
		<cfquery datasource="#get('dataSourceName')#" name="zones">
			SELECT <cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_integer"> as stateid, 0 as zone
		</cfquery>
	<cfelse>
		<cfquery datasource="#get('dataSourceName')#" name="zones">
			SELECT stateid,
			<cfif countryID eq 12>
				0 as zone FROM postalcodecanadas
			<cfelse>
				zone FROM postalcodes
			</cfif>
			WHERE
				<cfif city neq 0>
					cityId = <cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_integer">
					<cfif state neq 0>
						AND stateId = <cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_integer">
					</cfif>
				<cfelseif zipCode neq "">
					postalCode = <cfqueryparam value="#arguments.zipCode#" cfsqltype="cf_sql_varchar">
				<cfelse>
					stateid = 0 <!--- no zone --->
				</cfif>
				AND deletedAt IS NULL
			LIMIT 1
		</cfquery>
	</cfif>


	<!--- Get doctor information --->
	<cfif zones.recordcount gt 0>
		<cfquery datasource="#get('dataSourceName')#" name="sponsoredInfo.doctor">
			SELECT DISTINCT firstName,middleName,lastName,title,accountdoctors.id as doctorID, accountdoctorlocations.id AS accountDoctorLocationId,
							photoFilename, cities.name as city,states.abbreviation as state, accountdoctorsilonames.siloName,
							accountpractices.name as practice, accountproductspurchased.accountProductID,
							adlspz.stateId AS zoneStateId, adlspz.zoneId AS zoneId,
							adlspz.specialtyId AS zoneSpecialtyId,
							"#(val(arguments.procedure) EQ 0 ? '' : arguments.procedure)#" AS zoneProcedureId,
							<cfif val(arguments.procedure) neq 0 or val(arguments.bodypartId) neq 0>
							  	CASE WHEN FIND_IN_SET(adlspz.specialtyId,p.specialtyList) > 0 THEN 2
								   WHEN p.docproccount > 0 THEN 1
								   ELSE 0 END
							<cfelse>
								0
							</cfif>
							AS hasTopProcedure,
							<cfif val(arguments.procedure) neq 0>
								(SELECT count(1) FROM accountdoctorprocedures
								  	WHERE accountdoctorprocedures.accountDoctorId = accountdoctors.id
								  	AND accountdoctorprocedures.procedureId = <cfqueryparam value="#val(arguments.procedure)#" cfsqltype="cf_sql_integer">
								  	AND accountdoctorprocedures.deletedAt is null)
							<cfelseif val(arguments.bodypartId) neq 0>
								(SELECT count(1) FROM accountdoctorprocedures
									JOIN procedurebodyparts ON accountdoctorprocedures.procedureId = procedurebodyparts.procedureId
								  	WHERE accountdoctorprocedures.accountDoctorId = accountdoctors.id
								  	AND procedurebodyparts.bodypartID = <cfqueryparam value="#val(arguments.bodypartId)#" cfsqltype="cf_sql_integer">
								  	AND accountdoctorprocedures.deletedAt is null AND procedurebodyparts.deletedAt is null)
							<cfelse>
								0
							</cfif>
							AS hasProcedure,
							if(CallTracking.id IS NOT NULL, accountlocationdetails.phonePlus, "") AS phoneplus
			FROM accountdoctorlocations
			INNER JOIN accountdoctors ON accountdoctorlocations.accountDoctorId = accountdoctors.id
			INNER JOIN accountlocations ON accountdoctorlocations.accountLocationId = accountlocations.id
			LEFT JOIN accountlocationdetails ON accountlocationdetails.accountDoctorLocationId = accountlocations.id
			INNER JOIN cities ON accountlocations.cityId = cities.id
			INNER JOIN states ON accountlocations.stateId = states.id
			INNER JOIN accountpractices ON accountdoctorlocations.accountPracticeId = accountpractices.id
			INNER JOIN accountdoctorsilonames ON accountdoctors.id = accountdoctorsilonames.accountDoctorId AND accountdoctorsilonames.isActive = 1 AND accountdoctorsilonames.deletedAt IS NULL
			INNER JOIN accountproductspurchaseddoctorlocations ON accountdoctorlocations.id = accountproductspurchaseddoctorlocations.accountDoctorLocationId
			INNER JOIN accountproductspurchased ON accountproductspurchaseddoctorlocations.accountProductsPurchasedId = accountproductspurchased.id
			LEFT JOIN  accountproductspurchased AS CallTracking ON accountproductspurchaseddoctorlocations.accountProductsPurchasedId = CallTracking.id AND CallTracking.accountProductId = 7 AND CallTracking.dateEnd >= now() AND CallTracking.deletedAt IS NULL
			LEFT OUTER JOIN accountdoctorlocationspecialtyproductzones adlspz ON accountdoctorlocations.id = adlspz.accountDoctorLocationId AND accountproductspurchased.accountProductId = adlspz.accountProductId
			<cfif val(arguments.procedure) neq 0>
			LEFT OUTER JOIN (
			  	SELECT adp.accountDoctorId, count(adp.id) AS docproccount, adp.specialtyId, GROUP_CONCAT(adp.specialtyId) specialtyList
				FROM accountdoctorspecialtytopprocedures adp
				WHERE adp.procedureId = <cfqueryparam value="#val(arguments.procedure)#" cfsqltype="cf_sql_integer">
				AND adp.deletedAt IS NULL
				GROUP BY adp.accountDoctorId
			) p ON p.accountDoctorId = accountdoctors.id
			<cfelseif val(arguments.bodypartId) neq 0>
			LEFT OUTER JOIN (
			  	SELECT adp.accountDoctorId, count(adp.id) AS docproccount, adp.specialtyId, GROUP_CONCAT(adp.specialtyId) specialtyList
				FROM accountdoctorspecialtytopprocedures adp
				JOIN procedurebodyparts pbp on adp.procedureId = pbp.procedureId
				WHERE pbp.bodypartID = <cfqueryparam value="#val(arguments.bodypartId)#" cfsqltype="cf_sql_integer">
				AND adp.deletedAt IS NULL AND pbp.deletedAt IS NULL
				GROUP BY adp.accountDoctorId
			) p ON p.accountDoctorId = accountdoctors.id
			</cfif>
			WHERE ( accountproductspurchased.accountProductID IN (1,2)
					AND Now() <= accountproductspurchased.dateEnd
					AND (adlspz.zoneId = <cfqueryparam value="#zones.zone#" cfsqltype="cf_sql_integer">
							OR adlspz.zoneId is null
						)
					AND adlspz.stateId = <cfqueryparam value="#zones.stateid#" cfsqltype="cf_sql_integer">
					<cfif val(arguments.specialty) neq 0>
						AND adlspz.specialtyId = <cfqueryparam value="#val(arguments.specialty)#" cfsqltype="cf_sql_integer">
						AND accountproductspurchaseddoctorlocations.specialtyId = <cfqueryparam value="#val(arguments.specialty)#" cfsqltype="cf_sql_integer">
					</cfif>
					)
					AND
					(
						accountdoctorlocations.deletedAt IS NULL AND accountdoctors.deletedAt IS NULL AND accountlocations.deletedAt IS NULL AND cities.deletedAt IS NULL AND states.deletedAt IS NULL AND accountpractices.deletedAt IS NULL AND adlspz.deletedAt IS NULL AND accountproductspurchaseddoctorlocations.deletedAt IS NULL AND accountproductspurchased.deletedAt IS NULL
					)
					AND photoFilename != ''
			GROUP BY accountdoctorlocations.id, hasTopProcedure, hasProcedure, accountproductspurchased.accountProductID
			ORDER BY
			<cfif val(arguments.procedure) neq 0 or val(arguments.bodypartId) neq 0>
				hasTopProcedure DESC, hasProcedure DESC,
			</cfif>
			<cfif val(arguments.specialty) neq 0 or val(arguments.procedure) neq 0 or val(arguments.bodypartId) neq 0>
				accountproductspurchased.accountProductID desc,
			</cfif>
			RAND() ASC
			LIMIT 1;
		</cfquery>

		<cfif sponsoredInfo.doctor.recordcount gt 0>
			<cfset sponsoredInfo.valid = 1>

			<cfquery datasource="#get('dataSourceName')#" name="sponsoredInfo.procedures">
				SELECT procedures.name
				FROM accountdoctorspecialtytopprocedures
				INNER JOIN procedures ON accountdoctorspecialtytopprocedures.procedureId = procedures.id
				WHERE
				 (
					accountdoctorspecialtytopprocedures.accountDoctorId = <cfqueryparam value="#sponsoredInfo.doctor.doctorID#" cfsqltype="cf_sql_integer">
					<cfif val(arguments.specialty) neq 0>
						AND accountdoctorspecialtytopprocedures.specialtyId = <cfqueryparam value="#val(arguments.specialty)#" cfsqltype="cf_sql_integer">
					</cfif>
				) AND (
				accountdoctorspecialtytopprocedures.deletedAt IS NULL AND procedures.deletedAt IS NULL
				)
				LIMIT 3
			</cfquery>

			<cfset local.keylist = REReplace(LCase(CGI.PATH_INFO),'/?(#LCase(arguments.paramsController)#|#LCase(arguments.paramsAction)#)/?','','all')>

			<cfset model("HitsDoctorSponsoredImpression").RecordImpression(
											thisAction				= "#arguments.paramsAction#",
											thisController			= "#arguments.paramsController#",
											keylist					= "#local.keylist#",
											accountDoctorLocationId	= "#sponsoredInfo.doctor.accountDoctorLocationId#",
											specialtyId				= "#arguments.specialty#",
											procedureId				= "#arguments.procedure#",
											postalCode				= "#arguments.zipCode#",
											argumentCityId			= "#arguments.city#",
											argumentStateId			= "#arguments.state#",
											zoneStateId				= "#zones.stateId#",
											zoneID					= "#zones.zone#",
											bodypartId				= "#arguments.bodyPartId#")>
		</cfif>
	</cfif>

	<cfreturn sponsoredInfo>
</cffunction>

<cffunction name="setUserLocation" hint="Sets the user location based on their IP address">
	<cfparam name="Client.IsSpider" default="">
	<cfset UserIP = CGI.REMOTE_ADDR>
	<!---<cfset UserIP = "91.226.212.49">--->
	<cfif ListLen(UserIP,".") eq 4 and not Client.IsSpider>
		<cfset IPCode = 0>
		<cfloop from="1" to="4" index="i">
			<cfset IPCode += Val(ListGetAt(UserIP,i,".")) * (256 ^ (4-i))>
		</cfloop>
		<cfset IPLocation = model("IP2Location").findAll(
			select="ip2locations.cityId,ip2locations.stateId,postalcodes.postalCode",
			include="city(postalcodes),state",
			where="ip2locations.ipFrom <= #val(IPCode)# AND ip2locations.ipTo >= #val(IPCode)#"
		)>
		<cfif IPLocation.recordcount>
			<cfset client.city = IPLocation.cityId>
			<cfset client.state = IPLocation.stateId>
			<cfset client.postalCode = IPLocation.postalCode>
		<cfelse>
			<!--- Default Location, Orlando --->
			<cfset client.city = 5103>
			<cfset client.state = 12>
			<cfset client.postalCode = "32803">
		</cfif>
	<cfelse>
		<!--- Default Location, Orlando --->
		<cfset client.city = 5103>
		<cfset client.state = 12>
		<cfset client.postalCode = "32803">
	</cfif>
</cffunction>

<cffunction name="formatForSelectBox" returntype="string" hint="Converts names of specialties and procedures to a display-friendly format">
	<cfargument name="inString" type="string" required="true">
	<cfset var outString = REReplace(inString,'</?small>','','all')>
	<cfset outString = REReplace(outString,'&amp','&','all')>
	<cfset outString = REReplace(outString,'<sup>[Tt][Mm]</sup>','&trade;','all')>
	<cfset outString = REReplace(outString,'[ ][ ]+',' ','all')>

	<cfreturn trim(outString)>
</cffunction>

<!--- image functions --->
<cffunction name="waterMark" hint="Places a watermark on an image" returntype="any">
	<cfargument name="img" type="any" required="yes">
	<cfargument name="mark" type="string" default="">
	<cfargument name="debug" type="string" default="">

	<cfset img = imageCopy(img,0,0,img.width,img.height)>
	<cfset newmark = REReplace(mark,"[^a-zA-Z0-9_-]","","ALL")>

	<cfif isImage(img)>
		<cfif img.width gte 70 and img.height gte 70>
			<cfset wm			= {}>
			<cfset wm.mark		= mark>
			<cfset wm.len		= val(len(newmark))>
			<cfset wm.unit		= fix(img.width/wm.len)>
			<cfset wm.width		= fix(wm.unit*(wm.len/1.4))>
			<cfset wm.height	= fix(img.height/10)>
			<cfset wm.fontsize	= fix(min(wm.unit,wm.height))>
			<cfset wm_image		= imageReadBase64("data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEHAAEALAAAAAABAAEAAAICTAEAOw==")>
			<cfset imageResize(wm_image,wm.width,wm.height)>
			<cfset imageSetAntialiasing(wm_image,"on")>
			<cfset imageSetDrawingColor(wm_image,"white")>
			<cfset attributes	= {font="DejaVu LGC Sans",size=toString(wm.fontsize),style="bold"}>
			<cfset imageDrawText(wm_image,mark,0,wm.height,attributes)>
			<cfset imageSetAntialiasing(img,"on")>
			<cfset imagePaste(img,wm_image,img.getWidth()-wm_image.getWidth(),(img.getHeight()-(wm_image.getHeight()+5)))>
		</cfif>
		<cfreturn img>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="resizeFromCenter" returntype="any" hint="will zoom/crop/resize image to specified width and height starting from the center of image, not the top left corner">
	<cfargument name="img" type="any" required="yes">
	<cfargument name="width" type="numeric" required="yes">
	<cfargument name="height" type="numeric" required="yes">

	<cfif isImage(img)>
		<cfset img	= imageCopy(img,0,0,img.width,img.height)>
		<cfset img2	= imageCopy(img,0,0,img.width,img.height)>
		<cfset w	= true>

		<cfset imageResize(img2,width,"")>
		<cfif img2.height lt height>
			<cfset w	= false>
			<cfset img2	= imageCopy(img,0,0,img.width,img.height)>
			<cfset imageResize(img2,"",height)>
		</cfif>

		<cfif w>
			<cfset img2 = imageCopy(img2,0,abs(fix((height-img2.height)/2)),width,height)>
		<cfelse>
			<cfset img2 = imageCopy(img2,abs(fix((width-img2.width)/2)),0,width,height)>
		</cfif>

		<cfreturn img2>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="splitInTwo" returntype="array" hint="will split an image into two evenly sized images horiz or vert and return the two image objects in an array">
	<cfargument name="img" type="any" required="yes">
	<cfargument name="horizontal" type="boolean" default="false">

	<cfset img	= arguments.img>
	<cfset ret	= arrayNew(1)>
	<cfif isImage(img)>
		<!--- BEFORE --->
		<cfif horizontal>
			<cfset before	= imageCopy(img,0,0,img.width,fix(img.height/2))>
		<cfelse>
			<cfset before	= imageCopy(img,0,0,fix(img.width/2),img.height)>
		</cfif>
		<!--- Make sure the original is not larger than 1600x1200 --->
		<cfif before.width gt 1600>
			<cfset imageResize(before,1600,"")>
		</cfif>
		<cfif before.height gt 1200>
			<cfset imageResize(before,"",1200)>
		</cfif>
		<cfset arrayAppend(ret,before)>

		<!--- AFTER --->
		<cfif horizontal>
			<cfset after	= imageCopy(img,0,fix(img.height/2),img.width,img.height-fix(img.height/2))>
		<cfelse>
			<cfset after	= imageCopy(img,fix(img.width/2),0,fix(img.width/2),img.height)>
		</cfif>
		<!--- Make sure the original is not larger than 1600x1200 --->
		<cfif after.width gt 1600>
			<cfset imageResize(after,1600,"")>
		</cfif>
		<cfif after.height gt 1200>
			<cfset imageResize(after,"",1200)>
		</cfif>
		<cfset arrayAppend(ret,after)>
	</cfif>

	<cfreturn ret>
</cffunction>

<cffunction name="FindAndCount" returntype="numeric" hint="Recursive function that returns number of appearances of substring within string">
	<cfargument name="substring" type="string" required="true">
	<cfargument name="string" type="string" required="true">
	<cfargument name="start" type="numeric" required="false" default="1">

	<cfset var pos = FindNoCase(arguments.substring,arguments.string,arguments.start)>
	<cfif pos gt 0>
		<cfreturn FindAndCount(arguments.substring,arguments.string,pos + Len(arguments.substring)) + 1>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>
<!--- Geometric calculation functions for city-distance search --->

<cffunction name="plotCity" access="private" returntype="struct" hint="Sets up and runs algorithm to plot a convex polygon around a city">
	<cfargument name="city"	 type="numeric"	required="false" default="0">
	<cfargument name="state" type="numeric"	required="false" default="0">
	<cfset cityCoordinates = model("PostalCode").findAll(
		select = "latitude, longitude",
		where = "cityId = #arguments.city# AND stateId = #arguments.state# AND type != 'P' AND type != 'U'",
		distinct = true
	)>
	<cfset cityPlot = {coordinates = [],hull = "",lines = [],
					   zoneTop = -200,zoneLeft = 200,zoneBottom = 200,zoneRight = -200}>
	<cfset leftmost = 0>
	<cfset rightmost = 0>
	<!--- We need at least 3 points to define an area. If there are less than 3, add extra
		  points in a triangle pattern around those points. --->
	<cfif ListFind("1,2",cityCoordinates.recordcount)>
		<cfloop query="cityCoordinates" startRow="1" endRow="#cityCoordinates.recordcount#">
			<cfset QueryAddRow(cityCoordinates)>
			<cfset QuerySetCell(cityCoordinates,"latitude",cityCoordinates.latitude + 0.0005)>
			<cfset QuerySetCell(cityCoordinates,"longitude",cityCoordinates.longitude + 0.000866)>
			<cfset QueryAddRow(cityCoordinates)>
			<cfset QuerySetCell(cityCoordinates,"latitude",cityCoordinates.latitude + 0.0005)>
			<cfset QuerySetCell(cityCoordinates,"longitude",cityCoordinates.longitude - 0.000866)>
			<cfset QueryAddRow(cityCoordinates)>
			<cfset QuerySetCell(cityCoordinates,"latitude",cityCoordinates.latitude - 0.001)>
			<cfset QuerySetCell(cityCoordinates,"longitude",cityCoordinates.longitude)>
		</cfloop>
	</cfif>
	<cfif cityCoordinates.recordcount gt 2>
		<!--- convert coordinates to array --->
		<cfloop query="cityCoordinates">
			<cfset ArrayAppend(cityPlot.coordinates, {x=longitude,y=latitude})>
			<cfif (leftmost eq 0) or (leftmost GT 0 AND longitude lt cityPlot.coordinates[leftmost].x)>
				<cfset leftmost = ArrayLen(cityPlot.coordinates)>
			</cfif>
			<cfif (rightmost eq 0) or (rightmost GT 0 AND longitude gt cityPlot.coordinates[rightmost].x)>
				<cfset rightmost = ArrayLen(cityPlot.coordinates)>
			</cfif>
		</cfloop>
		<cfset hullCloud = {points = cityPlot.coordinates,topHalf = "",bottomHalf = "",midPoint = rightmost,iteration=0}>
		<cfset cityPlot.hull = calculateHull(hullCloud,leftmost)>
	</cfif>
	<cfreturn cityPlot>
</cffunction>

<cffunction name="isLeft" access="private" returntype="numeric" hint="Determines which side of a line faces the specified point">
	<!--- Determines the orientation of point C from line A->B.
	If result is greater than zero, the point is to the left of the line.
	If it is less than zero, then it is to the right of the line. --->
	<cfargument name="A" type="struct">
	<cfargument name="B" type="struct">
	<cfargument name="C" type="struct">
	<cfreturn (B.x - A.x)*(C.y - A.y) - (B.y - A.y)*(C.x - A.x)>
</cffunction>

<cffunction name="calculateHull" access="private" returntype="string" hint="Recursive function that builds a polygon hull around a set of points">
	<cfargument name="cloud" type="struct">
	<cfargument name="hullPath" type="string">
	<cfargument name="candidates" type="string" required="false" default="">
	<cfargument name="likelyCandidate" type="numeric" required="false" default="0">
	<cfset outsidePoints = "">
	<cfset chosenPoint = likelyCandidate>
	<cfset highestCandidate = 0>
	<cfset highestDeviation = 0>
	<cfset cloud.iteration++>
	<cfif candidates eq "">
		<cfif ListFind(hullPath, cloud.midPoint)>
			<cfif ListLen(hullPath) gt 1><cfset candidates = cloud.bottomHalf></cfif>
			<cfset chosenPoint = ListFirst(hullPath)>
		<cfelse>
			<cfif ListLen(hullPath) gt 1><cfset candidates = cloud.topHalf></cfif>
			<cfset chosenPoint = cloud.midPoint>
		</cfif>
	</cfif>
	<cfif candidates eq "">
		<!--- If no candidates are defined, then we check the entire cloud for outside points --->
		<cfloop from="1" to="#ArrayLen(cloud.points)#" index="i">
			<cfif (i neq ListLast(hullPath)) and (i neq chosenPoint)
					AND ArrayLen(cloud.points) GTE ListLast(hullPath)
					AND ArrayLen(cloud.points) GTE chosenPoint
					AND ArrayLen(cloud.points) GTE i
					AND val(ListLast(hullPath)) GT 0
					AND val(chosenPoint) GT 0>
				<cfif 	arrayLen(cloud.points) GTE chosenPoint AND chosenPoint GT 0
						AND arrayLen(cloud.points) GTE ListLast(hullPath) AND ListLast(hullPath) GT 0
						AND arrayLen(cloud.points) GTE i
						AND val(i) GT 0
						AND ArrayIsDefined(cloud.points, i)
						AND ArrayIsDefined(cloud.points, chosenPoint)
						AND ArrayIsDefined(cloud.points, ListLast(hullPath))>
					<cfset deviation =
							isLeft(	cloud.points[ListLast(hullPath)],
									cloud.points[chosenPoint],
									cloud.points[i])>
				<cfelse>
					<cfset deviation = 0>
				</cfif>

				<cfif deviation gt 0>
					<cfset outsidePoints = ListAppend(outsidePoints,i)>
					<cfif deviation gt highestDeviation>
						<cfset highestDeviation = deviation>
						<cfset highestCandidate = i>
					</cfif>
				</cfif>
				<cfif ListLen(hullPath) eq 1>
					<cfif deviation gt 0>
						<cfset cloud.topHalf = ListAppend(cloud.topHalf,i)>
					<cfelseif deviation lt 0>
						<cfset cloud.bottomHalf = ListAppend(cloud.bottomHalf,i)>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
	<cfelse>
		<!--- Otherwise, we only check the candidates for outside points --->
		<cfloop list="#candidates#" index="i">
			<cfif chosenPoint eq 0>
				<cfset chosenPoint = i>
			<cfelse>
				<cfset chosenPoint = val(chosenPoint)>
				<cfif 	arrayLen(cloud.points) GTE chosenPoint AND
						val(chosenPoint) GT 0 AND
						val(chosenPoint) LTE arrayLen(cloud.points) AND
						arrayLen(cloud.points) GTE ListLast(hullPath) AND
						ListLast(hullPath) LTE arrayLen(cloud.points) AND
						ListLast(hullPath) GT 0 AND
						arrayLen(cloud.points) GTE i AND
						val(i) GT 0 AND
						val(i) LTE arrayLen(cloud.points) AND
						ArrayIsDefined(cloud.points, i)	AND
						ArrayIsDefined(cloud.points, chosenPoint) AND <!--- This one --->
						ArrayIsDefined(cloud.points, ListLast(hullPath))>
					<cftry>
						<cfset deviation =
								isLeft(	cloud.points[ListLast(hullPath)],
										cloud.points[chosenPoint],
										cloud.points[i])>
					<cfcatch type="any">
						<cfset deviation = 0>
					</cfcatch>
					</cftry>
				<cfelse>
					<cfset deviation = 0>
				</cfif>
				<cfif val(deviation) gt 0>
					<cfset outsidePoints = ListAppend(outsidePoints,i)>
					<cfif val(deviation) gt highestDeviation>
						<cfset highestDeviation = deviation>
						<cfset highestCandidate = i>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
	<!--- If any outside points are found, declare them as candidates and recurse. --->
	<cfif ListLen(outsidePoints) gt 0>
		<cfreturn calculateHull(cloud,hullPath,outsidePoints,highestCandidate)>
	<cfelse>
		<!--- Otherwise, we have found the next point of the hull. If the next point is the first,
		then we are done. Otherwise, we move to the next point and recurse. --->
		<cfif chosenPoint eq ListFirst(hullPath)>
			<cfreturn hullPath>
		<cfelse>
			<cfreturn calculateHull(cloud,ListAppend(hullPath,chosenPoint))>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="enlargeArea" access="private" returntype="struct" hint="Expands the sides of a polygon by the specified distance">
	<cfargument name="shape" type="struct">
	<cfargument name="distance" type="numeric" required="false" default="0">

	<cfset x = y = 0>
	<cfset var point = 0>
	<cfset var normalX = 0>
	<cfset var strut = {}>
	<cfset strut.x = 0>
	<cfset strut.y = 0>


	<cfif ListLen(shape.hull) gt 0>
		<cfset newpoints = []>
		<!--- Calculate normals and distances for each point on the hull --->
		<cfloop from="1" to="#ListLen(shape.hull)#" index="i">
			<cftry>
				<cfif 	ListLen(shape.hull) GTE i AND
						ArrayLen(shape.coordinates) GTE ListGetAt(shape.hull,i) AND
						ArrayLen(shape.coordinates) GTE ListGetAt(shape.hull,Iif(i lt ListLen(shape.hull),DE(i+1),1))>
					<cfset pointA = shape.coordinates[ListGetAt(shape.hull,i)]>
					<cfset pointB = shape.coordinates[ListGetAt(shape.hull,Iif(i lt ListLen(shape.hull),DE(i+1),1))]>
				<cfelse>
					<cfset pointA = {}>
					<cfset pointA.x = 0>
					<cfset pointA.y = 0>
					<cfset pointB = {}>
					<cfset pointB.x = 0>
					<cfset pointB.y = 0>
				</cfif>

			<cfcatch type="any">
				<cfset pointA = {}>
				<cfset pointA.x = 0>
				<cfset pointA.y = 0>
				<cfset pointB = {}>
				<cfset pointB.x = 0>
				<cfset pointB.y = 0>
			</cfcatch>
			</cftry>

			<cfset distanceAB = sqr((pointB.x - pointA.x)^2 + (pointB.y - pointA.y)^2)>

			<cfif distanceAB GT 0>
				<cfset ArrayAppend(newpoints,{
					point = pointA,
					<!--- Calculate normal of the line starting from this point --->
					normalX = 0 - (pointB.y - pointA.y)/distanceAB,
					normalY = (pointB.x - pointA.x)/distanceAB,
					<!--- Convert distance from miles to degrees from the current point --->
					distanceX = (2 + arguments.distance)/(69.1 * Cos(pointA.y/57.3)),
					distanceY = (2 + arguments.distance)/69.1
				})>
			</cfif>
		</cfloop>
		<!--- Enlarge the area by defining new points at the given distance from each point --->
		<cfloop from="1" to="#ArrayLen(newpoints)#" index="i">
			<cfset prev = Iif(i gt 1,DE(i-1),DE(ArrayLen(newpoints)))>

			<cfif 	ArrayLen(newpoints) GTE i AND
					ArrayLen(newpoints) GTE prev AND
					val(i) GT 0 AND
					ArrayIsDefined(newpoints, i) AND
					val(prev) GT 0 AND
					ArrayIsDefined(newpoints, prev)>
				<!--- Something in the array is getting lost while bots are visiting, so I'm adding the ArrayIsDefined check again --->
				<cfif 	ArrayIsDefined(newpoints, i) AND
						ArrayIsDefined(newpoints, prev) AND
						StructKeyExists(newpoints[i], normalX) AND
						StructKeyExists(newpoints[prev], normalX) AND
						StructKeyExists(newpoints[i], normalY) AND
						StructKeyExists(newpoints[prev], normalY)>
					<cfset strut = {
						x = newpoints[i].normalX + newpoints[prev].normalX,
						y = newpoints[i].normalY + newpoints[prev].normalY
					}>
				</cfif>
			</cfif>

			<cfset strutLength = sqr((strut.x)^2 + (strut.y)^2)>
			<!--- Point at end of the last parallel line --->

			<cfif 	ArrayLen(newpoints) GTE i AND
					ArrayLen(newpoints) GTE prev AND
					val(i) GT 0 AND
					val(prev) GT 0 AND
					ArrayIsDefined(newpoints, i) AND
					ArrayIsDefined(newpoints, prev)>
				<!--- Something in the array is getting lost while bots are visiting, so I'm adding the ArrayIsDefined check again --->
				<cfif 	ArrayIsDefined(newpoints, i) AND
						ArrayIsDefined(newpoints, prev) AND
						structKeyExists(newpoints[i], point) AND
						structKeyExists(newpoints[prev], normalX) AND
						structKeyExists(newpoints[i], distanceX) AND
						structKeyExists(newpoints[prev], normalY) AND
						structKeyExists(newpoints[i], distanceY)>
					<cfif structKeyExists(newpoints[i].point, x) AND structKeyExists(newpoints[i].point, y)>
						<cfset ArrayAppend(shape.lines,{
							x = newpoints[i].point.x + newpoints[prev].normalX * newpoints[i].distanceX,
						  	y = newpoints[i].point.y + newpoints[prev].normalY * newpoints[i].distanceY
						})>
					</cfif>
				</cfif>
			</cfif>
			<!--- Strut point --->
			<cfif val(strutLength) GT 0 AND
					val(i) GT 0>
				<cfif ArrayLen(newpoints) GTE i AND ArrayIsDefined(newpoints, i)>
					<cfset ArrayAppend(shape.lines,{
						x = newpoints[i].point.x + strut.x/strutLength  * newpoints[i].distanceX,
						y = newpoints[i].point.y + strut.y/strutLength  * newpoints[i].distanceY
					})>
				</cfif>
			</cfif>

			<cfif 	ArrayLen(newpoints) GTE i AND
					val(i) GT 0 AND
					ArrayIsDefined(newpoints, i)>
				<!--- Point at start of the next parallel line --->
				<cfset ArrayAppend(shape.lines,{
					x = newpoints[i].point.x + newpoints[i].normalX * newpoints[i].distanceX,
					y = newpoints[i].point.y + newpoints[i].normalY * newpoints[i].distanceY
				})>
			</cfif>
		</cfloop>
		<!--- Get the boundary zone of the shape --->
		<cfloop array="#shape.lines#" index="linePoint">
			<cfif linePoint.x lt shape.zoneLeft><cfset shape.zoneLeft = linePoint.x></cfif>
			<cfif linePoint.x gt shape.zoneRight><cfset shape.zoneRight = linePoint.x></cfif>
			<cfif linePoint.y lt shape.zoneBottom><cfset shape.zoneBottom = linePoint.y></cfif>
			<cfif linePoint.y gt shape.zoneTop><cfset shape.zoneTop = linePoint.y></cfif>
		</cfloop>
		<cfset shape.zoneLeft -= 0.005>
		<cfset shape.zoneRight += 0.005>
		<cfset shape.zoneBottom -= 0.005>
		<cfset shape.zoneTop += 0.005>
	</cfif>
	<cfreturn shape>
</cffunction>

<cffunction name="fnGetFirstImage" hint="Returns the first image it finds from the passed in HTML">
	<cfargument name="myHtml" default="">
	<cfset var Local = {}>

	<cftry>
		<cfset Local.temp_img = REMatch("<img [^>]+>",Arguments.myHtml)>
		<cfif ArrayLen(Local.temp_img)>
			<cfset Local.temp_img = REMatch("src['"" =]*([^'"" ]+)", Local.temp_img[1])>
		</cfif>
		<cfif ArrayLen(Local.temp_img)>
			<cfset Local.temp_img = ListLast(Local.temp_img[1],"=")>
			<cfset Local.temp_img = Replace(Local.temp_img, '"', "", "ALL")>
		<cfelse>
			<cfset Local.temp_img = "">
		</cfif>
		<cfcatch type="any">
			<cfset Local.temp_img = "">
		</cfcatch>
	</cftry>

	<cfreturn Local.temp_img>
</cffunction>

<cffunction name="fnGetSiloName" hint="Converts text to siloed name">
	<cfargument name="text" default="">
	<cfargument name="allowNumbers" default="true">
	<cfset var Local = {}>

	<cfinvoke component="LocateADocModules#Application.SharedModulesSuffix#.com.locateadoc.siloing.silo" method="getSiloName" originalName="#Arguments.text#" allowNumbers="#Arguments.allowNumbers#" returnvariable="Local.returnString">

	<cfreturn Local.returnString>
</cffunction>

<cffunction name="fnIsSiloLocation" hint="Returns true if the location string is correctly siloed">
	<cfargument name="originalLocation" default="">
	<cfargument name="siloDivider" default="-">
		<cfset var Local = {}>
		<cfset Local.location = Replace(fnGetSiloName(Arguments.originalLocation),"-"," ","all")>

		<!--- See if they passed in a state name --->
		<cfset Local.stateMatch = model("state").findAllByName(value=Local.location, select="name")>
		<cfif Local.stateMatch.recordCount>
			<cfreturn true>
		</cfif>

		<cfset Local.stateMatch = model("state").findAllByAbbreviation(value=Local.location, select="name")>
		<cfif Local.stateMatch.recordCount>
			<cfreturn true>
		</cfif>

		<!--- See if it's city-state --->
		<cfif ListLen(Local.location, " ") gt 1>
			<cfquery datasource="myLocateadocLB3" name="qryCityState">
				SELECT c.name, s.name
				FROM states s
				INNER JOIN cities c ON c.stateId = s.id AND c.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListDeleteAt(Local.location, ListLen(Local.location, " "), " ")#"> AND c.deletedAt IS NULL
				WHERE s.abbreviation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListLast(Local.location, " ")#">
					AND s.deletedAt IS NULL
			</cfquery>
			<cfif qryCityState.recordCount eq 1>
				<cfreturn true>
			</cfif>
		</cfif>

		<cfreturn false>
</cffunction>

<cffunction name="fnSiloLocationAbbreviation" hint="Returns the state abbreviation's silo name">
	<cfargument name="originalLocation" default="">
	<cfargument name="siloDivider" default="-">
		<cfset var Local = {}>
		<cfset Local.location = Replace(fnGetSiloName(Arguments.originalLocation),"-"," ","all")>

		<cfset Local.stateMatch = model("state").findAllByAbbreviation(value=Local.location, select="siloName")>
		<cfif Local.stateMatch.recordCount>
			<cfreturn Local.stateMatch.siloName>
		</cfif>

		<cfreturn "">
</cffunction>

<cffunction name="AddPageFilter" hint="adds page filter to URL, used for below functions">
	<cfargument name="page" default="1">
	<cfparam name="url.silourl" default="">

	<!--- <cfset var URLstring = Replace(REReplace("http://" & CGI.HTTP_HOST & ((url.silourl neq "") ? REReplace(url.silourl,'\?.*?$','') : CGI.PATH_INFO),"/$",""),"resources/articles","articles")> --->
	<cfset URLstring = REReplace(Request.currentURL,"(##|\?).+","")>
	<cfset pageFind = REFind("/page-[0-9]+",URLstring,1,"true")>
	<cfif pageFind.len[1] eq 0>
		<cfreturn "#URLstring#/page-#arguments.page#">
	<cfelse>
		<cfset pageString = Mid(URLstring,pageFind.pos[1],pageFind.len[1])>
		<cfreturn Replace(URLString,pageString,(arguments.page gt 1) ? "/page-#arguments.page#" : "")>
	</cfif>
</cffunction>

<cffunction name="GetNextPage" hint="get url for header link next tag">
	<cfargument name="page" default="0">
	<cfargument name="pageCount" defualt="0">

	<cfif arguments.page gte arguments.pageCount>
		<cfreturn "">
	<cfelse>
		<cfreturn AddPageFilter(arguments.page+1)>
	</cfif>
</cffunction>

<cffunction name="GetPrevPage" hint="get url for header link prev tag">
	<cfargument name="page" default="0">

	<cfif arguments.page lte 1>
		<cfreturn "">
	<cfelse>
		<cfreturn AddPageFilter(arguments.page-1)>
	</cfif>
</cffunction>

<cffunction name="fnCompress" hint="Remove white space from passed in HTML">
	<cfargument name="html" default="">
	<cfset Arguments.html = ReReplace(Arguments.html, "[\s]*(#chr(10)#|#chr(13)#)[\s]*", chr(10), "all")>
	<cfset Arguments.html = ReReplace(Arguments.html, ">[\s]+<", "><", "all")>
	<cfset Arguments.html = ReReplace(Arguments.html, "[ \t]+", " ", "all")>
	<cfreturn Trim(Arguments.html)>
</cffunction>

<cffunction name="pageHistory" hint="Update client trail for error debugging">
	<cfparam name="Client.PageHistory_5" default="">
	<cfparam name="Client.PageHistory_4" default="">
	<cfparam name="Client.PageHistory_3" default="">
	<cfparam name="Client.PageHistory_2" default="">
	<cfparam name="Client.PageHistory_1" default="">
	<cfset Client.PageHistory_5 = Client.PageHistory_4>
	<cfset Client.PageHistory_4 = Client.PageHistory_3>
	<cfset Client.PageHistory_3 = Client.PageHistory_2>
	<cfset Client.PageHistory_2 = Client.PageHistory_1>
	<cfset Client.PageHistory_1 = "(#DateFormat(now(),'yyyy-mm-dd')# #TimeFormat(now(),'HH:mm:ss.L')#) #CGI.HTTP_REFERER# => #Request.currentURL#">
</cffunction>

<cffunction name="mobileImageFormat" hint="Searches a body of HTML for images exceeding 266 pixels in width, and changes their widths and heights to auto.">
	<cfargument name="pageContentInput" required="true">
	<cfset pageContent = pageContentInput>
	<cfset imageFind = REFind("<img[^>]+>",pageContent,1,true)>
	<cfloop condition="imageFind.pos[1] gt 0">
		<cfset foundImage = Mid(pageContent,imageFind.pos[1],imageFind.len[1])>
		<cfset dimensionFind = REFind("width:\s?[0-9]+px",foundImage,1,true)>
		<cfloop condition="dimensionFind.pos[1] gt 0">
			<cfif val(REReplace(Mid(foundImage,dimensionFind.pos[1],dimensionFind.len[1]),'[^0-9]','','all')) gt 266>
				<cfset newImage = REReplace(foundImage,"width:\s?[0-9]+px","width: auto","all")>
				<cfset newImage = REReplace(newImage,"height:\s?[0-9]+px","height: auto","all")>
				<cfset pageContent = Replace(pageContent,foundImage,newImage)>
				<cfbreak>
			</cfif>
			<cfset dimensionFind = REFind("width:\s?[0-9]+px",foundImage,dimensionFind.pos[1]+1,true)>
		</cfloop>
		<cfset imageFind = REFind("<img[^>]+>",pageContent,imageFind.pos[1]+1,true)>
	</cfloop>
	<cfreturn pageContent>
</cffunction>

<cffunction name="FormalCapitalize" hint="Formally Capitalizes A String, Like This">
	<!--- CFWheels' humanize() may break camelcased words, so this function exists! Hooray! --->
	<cfargument name="InString" required="true">
	<cfset outString = "">
	<cfloop list="#InString#" delimiters=" " index="stringWord">
		<cfset outString = ListAppend(outString,capitalize(LCase(stringWord))," ")>
	</cfloop>
	<cfreturn outString>
</cffunction>

<cffunction name="selectiveHTMLFilter" hint="Filters unwanted HTML from strings">
	<cfargument name="inString" required="true">
	<cfset local.filteredDescription = inString>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<img.*?(/>)|(</img>)","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<img[^>]*?>","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,'style=".*?"',"","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,'onclick=".*?"',"","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,">\s*<br\s*/?>",">","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"(</strong>)|(</span>)","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<h[0-9][^>]*?>","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"</h[0-9]>","<br />","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<link[^>]*?>","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<meta[^>]*?>","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<style[^>]*?>.*?</style>","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<script[^>]*?>.*?</script>","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<!--.*?-->","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<p[^>]*?>\s*</p>","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<div[^>]*?>\s*</div>","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"(<strong[^>]*?>)|(<span[^>]*?>)|(<div[^>]*?>)","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"</div>","<br />","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<font[^>]*?>\s*</font>","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<blockquote[^>]*?>\s*</blockquote>","","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<address[^>]*?>","<p><i>","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"</address>","</i></p>","all")>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"&nbsp;"," ","all")>
	<cfset local.filteredDescription = trim(local.filteredDescription)>
	<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"(^<p>)|(</p>$)","","all")>
	<cfif REFind("<(u|o)l[^>]*?>",local.filteredDescription) eq 0 and REFind("<li>",local.filteredDescription) gt 0>
		<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<li>","<br>- ","all")>
		<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"</li>","<br>","all")>
	</cfif>
	<cfif REFind("<p[^>]*?>",local.filteredDescription) eq 0 and REFind("<li>",local.filteredDescription) gt 0>
		<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"</?(u|o)l[^>]*?>","","all")>
		<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"<li>","<p> ","all")>
		<cfset local.filteredDescription = REReplaceNoCase(local.filteredDescription,"</li>","</p>","all")>
	</cfif>
	<cfreturn local.filteredDescription>
</cffunction>

<cffunction name="StripHTML">
	<cfargument name="htmltext" type="string" required="true">

	<cfparam name="Application.SharedModulesSuffix" default="">
	<cfset var oRegex = CreateObject("component", "LocateADocModules#Application.SharedModulesSuffix#.com.util.regexp")>

	<!--- <cfreturn arguments.htmltext> --->
	<cfreturn oRegex.fStripHTML(arguments.htmltext)>
</cffunction>

<cffunction name="StripHTMLInclusiveReplaceScripts" hint="Replace Super and Sub scripts, along with html">
	<cfargument name="htmltext" type="string" required="true">

	<cfparam name="Application.SharedModulesSuffix" default="">
	<cfset var oRegex = CreateObject("component", "LocateADocModules#Application.SharedModulesSuffix#.com.util.regexp")>

	<cfset arguments.htmltext = replaceNoCase(arguments.htmltext, "<sup>tm</sup>", "&##8482;", "all")>

	<cfreturn oRegex.fStripHTMLInclusive(arguments.htmltext)>
</cffunction>

<cffunction name="MakeSet">
	<cfargument name="list" type="string" required="true">

	<cfparam name="Application.SharedModulesSuffix" default="">
	<cfset var oSet = CreateObject("component", "LocateADocModules#Application.SharedModulesSuffix#.com.util.Set")>

	<!--- <cfreturn arguments.htmltext> --->
	<cfreturn oSet.makeSet(arguments.list)>
</cffunction>

<cffunction name="MakeNumericSet">
	<cfargument name="list" type="string" required="true">

	<cfparam name="Application.SharedModulesSuffix" default="">
	<cfset var oSet = CreateObject("component", "LocateADocModules#Application.SharedModulesSuffix#.com.util.Set")>

	<!--- <cfreturn arguments.htmltext> --->
	<cfreturn oSet.MakeNumericSet(arguments.list)>
</cffunction>

<cffunction name="CutText">
	<cfargument name="myText" type="String" required="true">
	<cfargument name="cutOffLength" default="25" type="numeric" required="false">

	<cfparam name="Application.SharedModulesSuffix" default="">
	<cfset var oRegexp = CreateObject("component", "LocateADocModules#Application.SharedModulesSuffix#.com.util.regexp")>

	<cfreturn oRegexp.fCutText(my_text = arguments.myText, cut_off_length = arguments.cutOffLength)>
</cffunction>

<cffunction name="reEscapeMe" hint="Escapes text to use in a regular expression">
	<cfargument default="" name="text">

	<cfset var local = {}>
	<cfset local.reReplaceListFrom = "\,.,[,{,(,*,+,?,^,$,|">
	<cfset local.reReplaceListTo = "\\,\.,\[,\{,\(,\*,\+,\?,\^,\$,\|">

	<cfreturn replaceList(arguments.text, local.reReplaceListFrom, local.reReplaceListTo)>
</cffunction>


<!--- fnCthulhuException --->
<cfif not isDefined("fnCthulhuException") or not isCustomFunction("fnCthulhuException")>
	<cfparam name="Application.SharedModulesSuffix" default="">
	<cfinclude template="/LocateADocModules#Application.SharedModulesSuffix#/_cthulhuException.cfm">
</cfif>
