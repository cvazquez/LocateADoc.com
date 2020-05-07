<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("accountDoctor")>
		<cfset belongsTo("accountLocation")>
		<cfset hasOne("accountLocationDetail")>
		<cfset hasMany("accountLocationSpecialties")>
		<cfset hasMany(name="accountLocationSpecialtiesInner",modelName="accountLocationSpecialties",joinType="inner")>
		<cfset belongsTo("accountPractice")>
		<cfset hasMany("accountDoctorLocationStaffs")>
		<cfset hasMany("accountDoctorLocationCoupons")>
		<cfset hasMany("accountDoctorLocationRecommendations")>
		<cfset hasMany("accountProductsPurchasedDoctorLocations")>
		<cfset hasMany("accountDoctorLocationSpecialtyProductZones")>

		<cfset property(name="randomNumber", sql="RAND()")>
	</cffunction>

	<cffunction name="GetCitiesWithinDistance" returntype="query" hint="If we are searching by zip and distance, get a list of nearby cities to search within to speed up the query">
		<cfargument name="dInfo"				type="string"	required="false" default="search">
		<cfargument name="country"				type="numeric"	required="false" default="0">
		<cfargument name="distance"				type="numeric"	required="false" default="0">
		<cfargument name="latitude"				type="numeric"	required="false" default="0">
		<cfargument name="longitude"			type="numeric"	required="false" default="0">
		<cfargument name="shape"				type="struct"	required="false" default="#{coordinates = [],hull = "",lines=[]}#">
		<cfargument name="isOverrideCityIds"	type="boolean"	required="false" default="true">

		<cfset var Cities = QueryNew("")>
		<cfset var coordPrefix = "">


		<cfif arguments.isOverrideCityIds IS TRUE AND
			arguments.latitude neq 0 and arguments.longitude neq 0 and arguments.distance gt 0 and arguments.dInfo neq "featured">

			<cfquery datasource="#get('dataSourceName')#" name="Cities">
				SELECT cast(group_concat(DISTINCT concat('(', data.stateId, ',', data.cityid,')')) AS char) AS stateAndCityIds,
						cast(group_concat(DISTINCT data.cityId) AS char) AS cityIds,
						cast(group_concat(DISTINCT data.stateId) AS char) AS stateIds
				FROM(
					SELECT pc.stateId, pc.cityid,
					sqrt(POW((69.1*(pc.avgLatitude-(#arguments.latitude#))),2)
					+POW(69.1*(pc.avgLongitude-(#arguments.longitude#))
					*cos((#arguments.latitude#)/57.3),2)) as distance
					<cfif arguments.country eq 12>
						FROM postalcodecanadacoordinateaverages pc
					<cfelse>
						FROM postalcodecoordinateaverages pc
					</cfif>
					HAVING distance <= <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.distance + 5#">) data
			</cfquery>
		<cfelseif arguments.isOverrideCityIds IS TRUE AND ArrayLen(arguments.shape.lines)>
			<cfquery datasource="#get('dataSourceName')#" name="Cities">
				SELECT cast(group_concat(DISTINCT concat('(', data.stateId, ',', data.cityid,')')) AS char) AS stateAndCityIds,
						cast(group_concat(DISTINCT data.cityId) AS char) AS cityIds,
						cast(group_concat(DISTINCT data.stateId) AS char) AS stateIds
				FROM(
					SELECT distinct stateId, cityId
					FROM postalcodes
					WHERE latitude BETWEEN <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.shape.zoneBottom#"> AND <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.shape.zoneTop#">
					AND longitude BETWEEN <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.shape.zoneLeft#"> AND <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.shape.zoneRight#">
					<cfif arguments.shape.zoneTop gt 41.7841 and arguments.shape.zoneBottom lt 82.4916 and arguments.shape.zoneLeft gt -140.8976 and arguments.shape.zoneRight lt -52.6412>
						UNION
						SELECT distinct stateId, cityId
						FROM postalcodecanadas
						WHERE latitude BETWEEN <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.shape.zoneBottom#"> AND <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.shape.zoneTop#">
						AND longitude BETWEEN <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.shape.zoneLeft#"> AND <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.shape.zoneRight#">
					</cfif>
				) data
			</cfquery>
		</cfif>

		<cfreturn Cities>
	</cffunction>

	<cffunction name="GetFeatured" returntype="query">
		<cfargument name="procedureId"			type="numeric"	required="false" default="0">
		<cfargument name="procedureIdList"		type="string"	required="false" default="">
		<cfargument name="specialtyId"			type="numeric"	required="false" default="0">
		<cfargument name="country"				type="numeric"	required="false" default="0">
		<cfargument name="latitude"				type="numeric"	required="false" default="0">
		<cfargument name="longitude"			type="numeric"	required="false" default="0">
		<cfargument name="distance"				type="numeric"	required="false" default="0">
		<cfargument name="zipCode"				type="string"	required="false" default="">
		<cfargument name="city"					type="numeric"	required="false" default="0">
		<cfargument name="state"				type="numeric"	required="false" default="0">
		<cfargument name="bodypartId"			type="numeric"	required="false" default="0">
		<cfargument name="languageId"			type="numeric"	required="false" default="0">
		<cfargument name="sortBy"				type="string"	required="false" default="nameSort ASC">
		<cfargument name="limit"				type="numeric"	required="false" default="10">
		<cfargument name="overrideClient"		type="boolean"	required="false" default="false">
		<cfargument name="overrideZoneLimit"	type="boolean"	required="false" default="false">
		<cfargument name="usePowerPosition"		type="boolean"	required="false" default="true">
		<cfargument name="recordHit"			type="boolean"	required="false" default="false">
		<cfargument name="thisAction"			type="string"	required="false" default="">
		<cfargument name="thisController"		type="string"	required="false" default="">

		<cfset var local = {}>
		<cfset var Search = "">
		<cfset var Zone = "">
		<cfset var zoneId = "">


		<!--- Load featured listings search area from session --->
		<cfif (arguments.state eq 0) and not arguments.overrideClient>
			<cfif ((not isDefined("client.city")) or (not isDefined("client.state")))>
				<cfset setUserLocation()>
			</cfif>
			<cfif val(client.city) eq 0 or val(client.state) eq 0>
				<cfset setUserLocation()>
			</cfif>
			<cfset arguments.city = client.city>
			<cfset arguments.state = client.state>
		</cfif>

		<cfquery datasource="#get('dataSourceName')#" name="Zone">
			SELECT stateId, <cfif arguments.country eq 12> 0 AS </cfif>zone
			<cfif arguments.country eq 12>
				FROM postalcodecanadas pc
			<cfelse>
				FROM postalcodes pc
			</cfif>
			<cfif city neq 0>
				WHERE cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city#">
				<cfif arguments.state neq 0>
					AND stateId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.state#">
				</cfif>
			<cfelseif arguments.zipCode neq "">
				WHERE postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.zipCode#">
			<cfelse>
				WHERE stateId = 0 <!--- no zone --->
			</cfif>
				LIMIT 1;
		</cfquery>
		<cfset zoneID = Zone.zone>
		<cfif arguments.state eq 0><cfset arguments.state = Val(Zone.stateid)></cfif>

		<cfquery datasource="#get('dataSourceName')#" name="Search">
			SELECT SQL_CALC_FOUND_ROWS
					a.zoneId, a.stateId AS zoneStateId,
					a.accountDoctorLocationID AS ID, a.accountDoctorID AS doctorId, a.accountLocationID AS locationID, a.accountPracticeID AS practiceId,
					a.firstName, a.middleName, a.lastName, a.title, a.siloName,
					a.address, a.cityName AS city, a.stateAbbreviation AS abbreviation, a.stateAbbreviation AS state,
					a.latitude, a.longitude, a.postalCode, a.phone,
					a.practice, a.photoFilename,
					<cfif arguments.specialtyId neq 0>
						a.SpecialtyPracticeRank as PracticeRank
					<cfelseif arguments.procedureId neq 0>
						max(CASE
							WHEN FIND_IN_SET(<cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.procedureId#">,
												  (SELECT GROUP_CONCAT(procedureId)
													FROM accountdoctorspecialtytopprocedures
													WHERE accountDoctorId = a.accountDoctorID AND specialtyId = a.productsSpecialtyId
												  )
											)
							THEN a.specialtyPracticeRank
							ELSE a.practiceRank END
						   ) AS practiceRank
					<cfelse>
						a.PracticeRank as PracticeRank
					</cfif>,
					specialtyName AS specialty,
					specialtyList,
					specialtyList AS specialties,
					commentCount AS comments, rating, nameSort

					<cfif arguments.latitude neq 0 and arguments.longitude neq 0 and arguments.overrideClient>
						,sqrt(POW((69.1*(if(a.latitude is not null, a.latitude, pc.latitude)-(#arguments.latitude#))),2)
						 +POW(69.1*(if(a.longitude is not null, a.longitude, pc.longitude)-(#arguments.longitude#))
						 *cos((#arguments.latitude#)/57.3),2)) as distance
					<cfelse>
						,-1 as distance
					</cfif>

					<cfif arguments.usePowerPosition and (arguments.specialtyId gt 0 or arguments.procedureId gt 0)>
						<!--- ,(SELECT showTopDocSeal FROM accountdoctorsearchsummary WHERE doctorLocationID = a.accountDoctorLocationID) as hasPowerPosition --->
						<cfif arguments.procedureId gt 0>
							,(SELECT IfNull(max(hasPowerPosition),0)
							FROM accountproductspurchasedproceduresummaryall
							WHERE accountDoctorLocationID = a.accountDoctorLocationID
							AND zonesProcedureId = adp.procedureId) as hasPowerPosition
						<cfelse>
							,a.hasPowerPosition
						</cfif>
					<cfelse>
						,0 as hasPowerPosition
					</cfif>

			FROM accountproductspurchasedsummaryall a
			<!--- Do I need to join on languages? --->
			<cfif arguments.languageId neq 0>
				JOIN accountlocationlanguages allang on a.accountDoctorLocationID = allang.accountDoctorLocationId
			</cfif>
			<cfif arguments.bodyPartId NEQ 0>
				INNER JOIN accountdoctorfilterbodypartsummary adfbs ON
							adfbs.accountDoctorLocationId = a.accountDoctorLocationID
							AND adfbs.bodyPartId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bodyPartId#">
			</cfif>
			<cfif (arguments.procedureId neq 0 or ListLen(arguments.procedureIdList))>
				<!--- LEFT OUTER JOIN accountdoctorprocedures adp ON a.accountDoctorId = adp.accountDoctorId AND adp.deletedAt IS NULL --->
				JOIN accountdoctorprocedures adp ON a.accountDoctorId = adp.accountDoctorId AND adp.deletedAt IS NULL
					<cfif ListLen(arguments.procedureIdList)>
						AND adp.procedureId IN (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" separator="," value="#arguments.procedureIdList#">)
					</cfif>
				<cfif ListLen(arguments.procedureIdList)>
					JOIN procedures p on adp.procedureid = p.id AND p.deletedAt is null
				</cfif>
				JOIN specialtyprocedures sp ON adp.procedureId = sp.procedureId
				JOIN accountlocationspecialties als ON a.accountDoctorLocationID = als.accountDoctorLocationId AND sp.specialtyId = als.specialtyId
			</cfif>
			<cfif arguments.overrideZoneLimit IS TRUE>
				JOIN postalcodes zone ON zone.cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city#">
										AND zone.deletedAt IS NULL
			</cfif>

			<cfif arguments.latitude neq 0 and arguments.longitude neq 0 and arguments.overrideClient>
				<cfif arguments.country eq 12>
					JOIN postalcodecanadas pc
				<cfelse>
					JOIN postalcodes pc
				</cfif>
				on a.postalCode = pc.postalCode AND a.accountLocationCityId = pc.cityId
			</cfif>

			WHERE a.photoFilename != ''
			<cfif arguments.procedureId neq 0>
				AND adp.procedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.procedureId#"> AND adp.deletedAt IS NULL
			</cfif>

			<cfif zoneID neq "" AND arguments.overrideZoneLimit IS FALSE>
				AND (a.zoneId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#zoneID#">
				OR a.zoneId is null)
			<cfelseif arguments.overrideZoneLimit IS TRUE>
				AND a.stateId = zone.stateId AND a.zoneId = zone.zone
			</cfif>
			<cfif arguments.state neq 0 AND arguments.overrideZoneLimit IS FALSE>
				AND a.stateId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.state#">
			</cfif>
			<cfif arguments.specialtyId neq 0>
				AND a.zonesSpecialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.specialtyId#">
				AND a.productsSpecialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.specialtyId#">
				AND a.listingsSpecialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.specialtyId#">
			</cfif>
			GROUP BY a.accountDoctorID
			<cfif arguments.distance gt 0>
				HAVING distance < <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.distance#">
			</cfif>
			ORDER BY hasPowerPosition DESC,
			<cfif ListLen(arguments.procedureIdList)>
				Field(adp.procedureId, #arguments.procedureIdList#),
			</cfif>
			PracticeRank DESC, #arguments.sortBy#
			<cfif arguments.limit gt 0>LIMIT #arguments.limit#</cfif>
		</cfquery>

		<cfif not Client.IsSpider AND Search.recordCount GT 0 AND arguments.recordHit IS TRUE>
			<cfset Local.keylist = REReplace(LCase(CGI.PATH_INFO),'/?(#LCase(arguments.thisController)#|#LCase(arguments.thisAction)#)/?','','all')>

			<cfset model("HitsDoctorCarouselImpression").RecordImpression(
							thisAction					= "#arguments.thisAction#",
							thisController				= "#arguments.thisController#",
							keylist						= "#Local.keylist#",
							searchRecordCount			= "#Search.recordCount#",
							accountDoctorLocationIDs	= "#valueList(Search.id)#",
							specialtyId					= "#arguments.specialtyId#",
							procedureId					= "#arguments.procedureId#",
							procedureIdList				= "#arguments.procedureIdList#",
							latitude					= "#arguments.latitude#",
							longitude					= "#arguments.longitude#",
							postalCode					= "#arguments.zipCode#",
							stateId						= "#arguments.state#",
							cityId						= "#arguments.city#",
							zoneStateId					= "#Zone.stateId#",
							zoneID						= "#zoneID#",
							bodypartId					= "#arguments.bodypartId#",
							languageId					= "#arguments.languageId#",
							overrideClient				= "#arguments.overrideClient#"
			)>

		</cfif>


		<cfreturn Search>
	</cffunction>

	<!--- Contains a flexible form of the search query that can be used to further analyze the result set --->
	<cffunction name="doctorSearchMultiQuery" returntype="query">
		<cfargument name="info"					type="string"	required="true">
		<cfargument name="procedureId"			type="numeric"	required="false" default="0">
		<cfargument name="procedureIdList"		type="string"	required="false" default="">
		<cfargument name="specialtyId"			type="numeric"	required="false" default="0">
		<cfargument name="country"				type="numeric"	required="false" default="0">
		<cfargument name="distance"				type="numeric"	required="false" default="0">
		<cfargument name="latitude"				type="numeric"	required="false" default="0">
		<cfargument name="longitude"			type="numeric"	required="false" default="0">
		<cfargument name="zipCode"				type="string"	required="false" default="">
		<cfargument name="city"					type="numeric"	required="false" default="0">
		<cfargument name="state"				type="numeric"	required="false" default="0">
		<cfargument name="doctorName"			type="string"	required="false" default="">
		<cfargument name="bodypartId"			type="numeric"	required="false" default="0">
		<cfargument name="gender"				type="string"	required="false" default="">
		<cfargument name="languageId"			type="numeric"	required="false" default="0">
		<cfargument name="shape"				type="struct"	required="false" default="#{coordinates = [],hull = "",lines=[]}#">
		<cfargument name="sortBy"				type="string"	required="false" default="nameSort ASC">
		<cfargument name="offset"				type="numeric"	required="false" default="0">
		<cfargument name="limit"				type="numeric"	required="false" default="10">
		<cfargument name="basicPlusOnly"		type="boolean"	required="false" default="false">
		<cfargument name="overrideClient"		type="boolean"	required="false" default="false">
		<cfargument name="overrideZoneLimit"	type="boolean"	required="false" default="false">
		<cfargument name="isOverrideCityIds"	type="boolean"	required="false" default="true">
		<cfargument name="cityIds"				type="string"	required="false" default="">
		<cfargument name="stateIds"				type="string"	required="false" default="">
		<cfargument name="stateAndCityIds"		type="string"	required="false" default="">

		<cfset var local = {}>

		<cfset local.Cities = "">

		<!--- If we are searching by zip and distance, get a list of nearby cities to search within to speed up the query --->
		<cfif arguments.isOverrideCityIds IS TRUE>
			<cfset Cities = GetCitiesWithinDistance(
							dInfo			= arguments.info,
							country			= arguments.country,
							distance		= arguments.distance,
							latitude		= arguments.latitude,
							longitude		= arguments.longitude,
							shape			= arguments.shape,
							isOverrideCityIds	= arguments.isOverrideCityIds)>

			<cfif Cities.recordCount GT 0>
				<cfset arguments.cityIds 			= Cities.cityIds>
				<cfset arguments.stateIds 			= Cities.stateIds>
				<cfset arguments.stateAndCityIds	= Cities.stateAndCityIds>
			</cfif>
		</cfif>

		<!--- Strip trailing comma and broken tuples --->
		<cfset arguments.stateAndCityIds = ReReplace(arguments.stateAndCityIds, "^(.*),$", "\1")>
		<cfset arguments.stateAndCityIds = ReReplace(arguments.stateAndCityIds, "^(.*),\($", "\1")>
		<cfset arguments.stateAndCityIds = ReReplace(arguments.stateAndCityIds, "^(.*),\([0-9]+$", "\1")>
		<cfset arguments.stateAndCityIds = ReReplace(arguments.stateAndCityIds, "^(.*),\([0-9]+,$", "\1")>
		<cfset arguments.stateAndCityIds = ReReplace(arguments.stateAndCityIds, "^(.*),\([0-9]+,[0-9]+$", "\1")>

		<!--- <cfoutput>
			<p>arguments.stateAndCityIds = #arguments.stateAndCityIds#</p>
		</cfoutput><cfabort> --->


		<cfif arguments.info eq "search">
			<!--- Set the city and state for future featured listing searches
			      to the current city and state if the information exists --->
			<cfif arguments.city neq 0 and arguments.state neq 0>
				<cfset client.city = arguments.city>
				<cfset client.state = arguments.state>
			<cfelseif arguments.zipCode neq "">
				<cfquery datasource="#get('dataSourceName')#" name="getCityState">
					SELECT cityid, stateid
					<cfif arguments.country eq 12>
						FROM postalcodecanadas
					<cfelse>
						FROM postalcodes
					</cfif>
					WHERE postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#zipCode#">;
				</cfquery>
				<cfset client.city = getCityState.cityid>
				<cfset client.state = getCityState.stateid>
			</cfif>
		</cfif>

		<!--- If we are searching in Canada by postal code, stuff a percent sign into the
		      postal code, since doctors manually define their zip codes and the Canadian
		      postal code may be split in half at the doctor's discretion.           --->
		<cfif arguments.country eq 12 and Len(arguments.zipCode) eq 6>
			<cfset arguments.zipCode = Left(arguments.zipCode,3) & '%' & Right(arguments.zipCode,3)>
		</cfif>


		<cfif arguments.info eq "search">
			<cfquery datasource="#get('dataSourceName')#" name="Search">
				SELECT SQL_CALC_FOUND_ROWS
					adss.doctorLocationId as ID, adss.doctorID, adss.locationID, adss.siloName,
					adss.firstName, adss.middleName, adss.lastName, adss.title, adss.city, adss.state,
					adss.practice, adss.photoFilename, adss.specialtyNames AS specialtyList,
					"" AS description,
					adss.descriptionCount,
					adss.topProcedureNames AS topprocedures, adss.latitude, adss.longitude, adss.postalCode, adss.address,
					adss.stateAbbreviation AS abbreviation,
					adss.phone, adss.comments, adss.rating,
					adss.isFeatured,
					adss.isYext,
					adss.isBasicPlus,
					adss.inforank,
					adss.topProcedureIds,
					adss.languagesSpokenIds,
					adss.languagesSpokenNames AS languagesSpoken,
					adss.financingOptionIds,
					adss.financingOptionNames AS financingoptions,
					adss.yearStartedPracticing,
					adss.yearsInPractice,
					adss.showTopDocSeal,
					adss.isAdvisoryBoard

					<cfif NOT ListLen(arguments.stateAndCityIds) AND arguments.latitude neq 0 and arguments.longitude neq 0 and arguments.distance gt 0>
						,sqrt(POW((69.1*(if(adss.latitude is not null, adss.latitude, pc.latitude)-(#arguments.latitude#))),2)
						+POW(69.1*(if(adss.longitude is not null, adss.longitude, pc.longitude)-(#arguments.longitude#))
						*cos((#arguments.latitude#)/57.3),2)) as distance
					<cfelseif ListLen(shape.hull) and ArrayLen(shape.lines)>
						,case
						<!--- distance to edges --->
						<cfloop from="1" to="#ListLen(shape.hull)#" index="Local.DE_hullIndex">
							<cfset Local.DE_current = shape.coordinates[ListGetAt(shape.hull,Local.DE_hullIndex)]>
							<cfset Local.DE_next = shape.coordinates[ListGetAt(shape.hull,Iif(Local.DE_hullIndex lt ListLen(shape.hull),DE(Local.DE_hullIndex+1),1))]>
							when ((adss.longitude - #Local.DE_current.x#)*(#Local.DE_next.x-Local.DE_current.x#)+(adss.latitude - #Local.DE_current.y#)*(#Local.DE_next.y-Local.DE_current.y#))/(#(Local.DE_next.x-Local.DE_current.x)^2+(Local.DE_next.y-Local.DE_current.y)^2#) BETWEEN 0 AND 1
							AND ((#Local.DE_next.x-Local.DE_current.x#)*(adss.latitude - #Local.DE_current.y#) - (#Local.DE_next.y-Local.DE_current.y#)*(adss.longitude - #Local.DE_current.x#)) > 0
							then ABS((#69.1*(Local.DE_next.x-Local.DE_current.x)#)*(#Local.DE_current.y# - adss.latitude) - (#Local.DE_current.x# - adss.longitude)*(#69.1*Cos(Local.DE_current.y/57.3)*(Local.DE_next.y-Local.DE_current.y)#))/#Sqr((Local.DE_next.x-Local.DE_current.x)^2+(Local.DE_next.y-Local.DE_current.y)^2)# - 2
						</cfloop>
						<!--- distance to corners --->
						<cfloop from="1" to="#ListLen(shape.hull)#" index="Local.DC_hullIndex">
							<cfset Local.DC_current = shape.coordinates[ListGetAt(shape.hull,Local.DC_hullIndex)]>
							<cfset Local.DC_next = shape.coordinates[ListGetAt(shape.hull,Iif(Local.DC_hullIndex lt ListLen(shape.hull),DE(Local.DC_hullIndex+1),1))]>
							<cfset Local.DC_prev = shape.coordinates[ListGetAt(shape.hull,Iif(Local.DC_hullIndex gt 1,DE(Local.DC_hullIndex-1),DE(ListLen(shape.hull))))]>
							when ((#Local.DC_prev.y-Local.DC_current.y#)*(adss.latitude - #Local.DC_current.y#) - (#Local.DC_current.x-Local.DC_prev.x#)*(adss.longitude - #Local.DC_current.x#)) < 0
							AND ((#Local.DC_current.y-Local.DC_next.y#)*(adss.latitude - #Local.DC_current.y#) - (#Local.DC_next.x-Local.DC_current.x#)*(adss.longitude - #Local.DC_current.x#)) > 0
							then SQRT(POW(#69.1*Cos(Local.DC_current.y/57.3)#*(#Local.DC_current.x#-adss.longitude),2)+POW(69.1*(#Local.DC_current.y#-adss.latitude),2)) - 2
						</cfloop>
						else -2 end as distance
					<cfelse>
						,-1 as distance
					</cfif>
					<!--- Sorting hierarchy --->
					,(case when lastName = '' then practice else lastName end) as nameSort
					,(case when (SELECT count(a.id)
						<cfif ListLen(arguments.procedureIdList) or procedureId gt 0>
						FROM accountproductspurchasedproceduresummaryall a
						<cfelse>
						FROM accountproductspurchasedsummaryall a
						</cfif>
						WHERE a.accountdoctorlocationID = adss.doctorLocationId
						<cfif ListLen(arguments.procedureIdList)>
							AND a.zonesProcedureId IN (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" separator="," value="#arguments.procedureIdList#">) AND adp.deletedAt IS NULL
						<cfelseif procedureId gt 0>
							AND a.zonesProcedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
						<cfelseif specialtyId neq 0>
							AND a.zonesSpecialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
						</cfif>
						AND a.hasPowerPosition = 1) > 0 then 5
					 when isFeatured then 4 when isYext then 3 when isBasicPlus then 2 else 1 end) as featuredSort

				FROM accountdoctorsearchsummary adss
				<cfif bodyPartId neq 0>
					INNER JOIN accountdoctorfilterbodypartsummary adfbps ON adfbps.accountDoctorLocationId = adss.doctorLocationId AND adfbps.bodyPartId = <cfqueryparam cfsqltype="cf_sql_integer" value="#bodyPartId#">
				</cfif>

					<cfif NOT ListLen(arguments.stateAndCityIds) AND arguments.latitude neq 0 and arguments.longitude neq 0 and arguments.distance gt 0>
						<cfif arguments.country eq 12>
							JOIN postalcodecanadas pc
						<cfelse>
							JOIN postalcodes pc
						</cfif>
						on adss.postalCode = pc.postalCode AND adss.cityId = pc.cityId
					</cfif>
					<cfif ListLen(arguments.procedureIdList) OR procedureId neq 0>
						INNER JOIN accountdoctorprocedures adp ON adp.accountDoctorId = adss.doctorID AND adp.procedureId
								<cfif ListLen(arguments.procedureIdList)>
									IN (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" separator="," value="#arguments.procedureIdList#">) AND adp.deletedAt IS NULL
								<cfelse>
									= <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
								</cfif>
								AND adp.deletedAt IS NULL
					</cfif>
				WHERE 1 = 1
					<cfif basicPlusOnly>
						AND (isBasicPlus = 1 OR isFeatured = 1) AND isYext = 0
					</cfif>
					<cfif doctorName neq "">
						AND adss.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#doctorName#%">
					</cfif>
					<cfif specialtyId neq 0>
						AND FIND_IN_SET(<cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">,adss.specialtyIds)
					</cfif>
					<cfif languageId neq 0>
						AND FIND_IN_SET(<cfqueryparam cfsqltype="cf_sql_smallint" value="#languageId#">,adss.languagesSpokenIds)
					</cfif>
					<cfif gender neq "">
						AND adss.gender = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gender#">
					</cfif>
					<cfif ArrayLen(shape.lines) AND listLen(arguments.cityIds)>
						AND adss.cityid IN (#arguments.cityIds#)
					<cfelseif ListLen(arguments.stateIds) AND ListLen(arguments.cityIds)>
						AND adss.stateId IN (#arguments.stateIds#)
						AND adss.cityId IN (#arguments.cityIds#)
					</cfif>

					<cfif ArrayLen(shape.lines)>
						<cfloop from="1" to="#ArrayLen(shape.lines)#" index="Local.S_current">
							<cfset Local.S_next = Iif(Local.S_current eq ArrayLen(shape.lines),1,DE(Local.S_current+1))>
							AND ((#shape.lines[Local.S_next].x - shape.lines[Local.S_current].x#)*(adss.latitude - #shape.lines[Local.S_current].y#) - (#shape.lines[Local.S_next].y - shape.lines[Local.S_current].y#)*(adss.longitude - #shape.lines[Local.S_current].x#)) <= 0
						</cfloop>
					<cfelse>
						<cfif city neq 0>
							AND adss.cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#city#">
						</cfif>
						<cfif state neq 0>
							AND adss.stateId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#state#">
						</cfif>
						<cfif zipCode neq "" and distance eq 0>
							AND adss.postalCode LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#zipCode#">
						</cfif>
						<cfif country neq 0>
							AND adss.countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#country#">
						</cfif>
					</cfif>

				<cfif NOT ListLen(arguments.stateAndCityIds) AND arguments.latitude neq 0 and arguments.longitude neq 0 and arguments.distance gt 0>
					GROUP BY adss.doctorLocationId
					HAVING distance <= <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.distance#">
				</cfif>
				ORDER BY
				<cfif NOT ListLen(arguments.stateAndCityIds) AND arguments.latitude neq 0 and arguments.longitude neq 0 and arguments.distance gt 0>
					distance ASC,
				</cfif>
					featuredSort DESC, adss.inforank DESC, #sortBy#
				LIMIT #limit# OFFSET #offset#
			</cfquery>

		<cfelseif arguments.info eq "multimatchbasicplus">
			<cfquery datasource="#get('dataSourceName')#" name="Search">
				SELECT adss.doctorLocationId as ID,
					adss.locationID, adss.firstName, adss.middleName, adss.lastName, adss.siloName, adss.title, adss.city,
					adss.practice, adss.photoFilename, adss.postalCode, adss.address, adss.stateAbbreviation AS abbreviation,
					'' AS phone
					<!--- Sorting hierarchy --->
					,(case when lastName = '' then practice else lastName end) as nameSort
					,(case when isFeatured then 4 when isYext then 3 when isBasicPlus then 2 else 1 end) as featuredSort
					,sqrt(POW((69.1*(if(adss.latitude is not null, adss.latitude, pc.latitude)-(#arguments.latitude#))),2)
						+POW(69.1*(if(adss.longitude is not null, adss.longitude, pc.longitude)-(#arguments.longitude#))
						*cos((#arguments.latitude#)/57.3),2)) as distance, adss.showTopDocSeal, adss.isAdvisoryBoard
					, ap.accountId
					,(SELECT count(1) FROM profilethresholdleademails WHERE accountId = ap.accountId) as thresholdReached
				FROM accountdoctorsearchsummary adss
				INNER JOIN accountdoctorlocations adl ON adl.accountDoctorId = adss.doctorID AND adl.deletedAt IS NULL
				INNER JOIN accountpractices ap ON ap.id = adl.accountPracticeId AND ap.deletedAt IS NULL
					<cfif ListLen(arguments.procedureIdList) OR procedureId neq 0>
						INNER JOIN accountdoctorprocedures adp ON adp.accountDoctorId = adss.doctorID AND adp.procedureId
								<cfif ListLen(arguments.procedureIdList)>
									IN (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" separator="," value="#arguments.procedureIdList#">) AND adp.deletedAt IS NULL
								<cfelse>
									= <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
								</cfif>
								AND adp.deletedAt IS NULL
					</cfif>
					<cfif arguments.country eq 12>
						JOIN postalcodecanadas pc
					<cfelse>
						JOIN postalcodes pc
					</cfif>
					on adss.postalCode = pc.postalCode AND adss.cityId = pc.cityId
				WHERE 1 = 1
						AND (adss.isBasicPlus = 1) AND adss.isYext = 0
					<cfif specialtyId neq 0>
						AND FIND_IN_SET(<cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">,adss.specialtyIds)
					</cfif>
						<cfif ListLen(arguments.stateIds) AND ListLen(arguments.cityIds)>
							AND adss.stateId IN (#arguments.stateIds#)
							AND adss.cityId IN (#arguments.cityIds#)
						</cfif>
				GROUP BY ap.accountId
				HAVING distance <= <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.distance#">
					AND thresholdReached = 0
				ORDER BY distance ASC, featuredSort DESC, adss.inforank DESC, #sortBy#
				LIMIT #limit# OFFSET #offset#
			</cfquery>


		<cfelseif arguments.info eq "procedures" >

			<cfif gender eq "" AND specialtyId eq 0 AND languageId eq 0
				AND NOT ArrayLen(shape.lines)
				AND ListLen(arguments.cityIds) eq 0 AND state eq 0  AND city eq 0 AND zipCode eq ""
				AND val(arguments.bodypartId) EQ 0
				AND doctorName eq "">

				<cfquery datasource="#get('dataSourceName')#" name="Search">
					SELECT procedureId AS id, procedureName As name, doctorCount
					FROM accountdoctorfilterprocedures
					WHERE procedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
				</cfquery>

			<cfelseif specialtyId neq 0 AND procedureId EQ 0 AND gender eq "" AND languageId eq 0
				AND NOT ArrayLen(shape.lines)
				AND ListLen(arguments.cityIds) eq 0 AND state eq 0  AND city eq 0 AND zipCode eq ""
				AND val(arguments.bodypartId) EQ 0
				AND doctorName eq "">

				<cfquery datasource="#get('dataSourceName')#" name="Search">
					SELECT procedureId AS id, procedureName AS name, doctorCount
					FROM accountdoctorfilterspecialtyprocedures
					WHERE specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">;
				</cfquery>

			<cfelseif specialtyId neq 0 AND procedureId EQ 0 AND gender eq "" AND languageId eq 0
					AND NOT ArrayLen(shape.lines)
					AND (state neq 0 OR ListLen(arguments.stateAndCityIds))
					AND val(arguments.bodypartId) EQ 0
					AND doctorName eq "">

				<cfquery datasource="#get('dataSourceName')#" name="Search">
					select procedureId AS id, procedureName AS name, sum(doctorCount) AS doctorCount
					from accountdoctorfilterspecialtystatecityprocedures
					WHERE specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
						<cfif ListLen(arguments.stateIds) AND ListLen(arguments.cityIds)>
							AND stateId IN (#arguments.stateIds#)
							AND cityid IN (#arguments.cityIds#)
						<cfelse>
							AND stateId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#state#">
							<cfif city neq 0>
								AND cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#city#">
							</cfif>
						</cfif>
					GROUP BY procedureId
					order by procedureName
				</cfquery>

			<cfelse>

				<cfquery datasource="#get('dataSourceName')#" name="Search">
					SELECT procedure1.procedureId AS id, procedure1.procedureName AS name, count(distinct(procedure1.accountDoctorLocationId)) AS doctorCount
						,-1 as distance
					FROM accountdoctorfilterproceduresummary procedure1
					<cfif gender neq "">
						INNER JOIN accountdoctorfiltergendersummary gender ON
	 						gender.gender = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gender#">
							AND gender.accountDoctorLocationId = procedure1.accountDoctorLocationId
					</cfif>
					<cfif specialtyId neq 0>
						INNER JOIN accountdoctorfilterspecialtysummary specialty ON
	 						specialty.specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
							AND specialty.accountDoctorLocationId = procedure1.accountDoctorLocationId
					</cfif>
					<cfif languageId neq 0>
						INNER JOIN accountdoctorfilterlanguagesummary language ON
	 						language.languageId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#languageId#">
							AND language.accountDoctorLocationId = procedure1.accountDoctorLocationId
					</cfif>
					<cfif val(arguments.bodypartId) NEQ 0>
						INNER JOIN procedurebodyparts pbp ON pbp.bodyPartId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.bodypartId#">
								AND procedure1.procedureId = pbp.procedureId AND pbp.deletedAt IS NULL
					</cfif>
					<cfif doctorName neq "">
						INNER JOIN accountdoctorsearchsummary adss ON
							adss.doctorLocationId =	procedure1.accountDoctorLocationId AND adss.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#doctorName#%">
					</cfif>
					WHERE 1
						<cfif ArrayLen(shape.lines) AND ListLen(arguments.stateIds) AND ListLen(arguments.cityIds)>
							AND procedure1.stateId IN (#arguments.stateIds#)
							AND procedure1.cityid IN (#arguments.cityIds#)
						<cfelseif ListLen(arguments.stateAndCityIds)>
							AND (procedure1.stateId,procedure1.cityid) IN (#arguments.stateAndCityIds#)
						</cfif>
						<cfif ArrayLen(shape.lines)>
							<cfloop from="1" to="#ArrayLen(shape.lines)#" index="Local.FP_current">
								<cfset Local.FP_next = Iif(Local.FP_current eq ArrayLen(shape.lines),1,DE(Local.FP_current+1))>
								AND ((#shape.lines[Local.FP_next].x - shape.lines[Local.FP_current].x#)*(procedure1.latitude - #shape.lines[Local.FP_current].y#) - (#shape.lines[Local.FP_next].y - shape.lines[Local.FP_current].y#)*(procedure1.longitude - #shape.lines[Local.FP_current].x#)) <= 0
							</cfloop>
						<cfelse>
							<cfif country neq 0>
								AND procedure1.countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#country#">
							</cfif>
							<cfif state neq 0>
								AND procedure1.stateId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#state#">
							</cfif>
							<cfif city neq 0>
								AND procedure1.cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#city#">
							</cfif>
							<cfif zipCode neq "" and distance eq 0>
								AND procedure1.postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#zipCode#">
							</cfif>
						</cfif>
						<cfif procedureId neq 0>
							AND procedure1.procedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
						</cfif>
					GROUP BY procedure1.procedureId
	 				<cfif arguments.latitude neq 0 and arguments.longitude neq 0 and arguments.distance gt 0>
						HAVING distance <= <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.distance#">
					</cfif>
					ORDER BY procedure1.procedureName;
				</cfquery>
			</cfif>
		<cfelseif arguments.info eq "specialties">

			<cfif procedureId neq 0 AND gender eq "" AND specialtyId eq 0 AND languageId eq 0
				AND NOT ArrayLen(shape.lines)
				AND ListLen(arguments.cityIds) eq 0 AND state eq 0  AND city eq 0 AND zipCode eq ""
				AND val(arguments.bodypartId) EQ 0
				AND doctorName eq "">

				<cfquery datasource="#get('dataSourceName')#" name="Search">
					SELECT specialtyId AS id, specialtyName As name, doctorCount
					FROM accountdoctorfilterproceduresspecialties
					WHERE procedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
				</cfquery>

			<cfelseif specialtyId neq 0 AND procedureId eq 0 AND gender eq "" AND languageId eq 0
					AND NOT ArrayLen(shape.lines)
					AND ListLen(arguments.cityIds) eq 0 AND state eq 0  AND city eq 0 AND zipCode eq ""
					AND val(arguments.bodypartId) EQ 0
					AND doctorName eq "">

				<cfquery datasource="#get('dataSourceName')#" name="Search">
					SELECT specialtyId AS id, specialtyName As name, doctorCount
					FROM accountdoctorfilterspecialties
					WHERE specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
				</cfquery>
			<cfelse>

				<cfif val(arguments.bodypartId) NEQ 0>
					<!--- Don't display specialties for body parts, because procedures take care of it --->
					<cfset Search = QueryNew("")>
				<cfelse>

					<cfquery datasource="#get('dataSourceName')#" name="Search">
						SELECT specialty.specialtyId AS id, specialty.specialtyName AS name, count(distinct(specialty.accountDoctorLocationId)) AS doctorCount
						FROM accountdoctorfilterspecialtysummary specialty
						<cfif gender neq "">
							INNER JOIN accountdoctorfiltergendersummary gender ON
		 						gender.gender = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gender#">
								AND  gender.accountDoctorLocationId = specialty.accountDoctorLocationId
						</cfif>
						<cfif procedureId neq 0>
							INNER JOIN accountdoctorfilterproceduresummary procedure1 ON
								procedure1.procedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
								AND  procedure1.accountDoctorLocationId = specialty.accountDoctorLocationId
						</cfif>
						<cfif languageId neq 0>
							INNER JOIN accountdoctorfilterlanguagesummary language ON
		 						language.languageId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#languageId#">
								AND  language.accountDoctorLocationId = specialty.accountDoctorLocationId
						</cfif>
						<cfif val(arguments.bodypartId) NEQ 0>
							INNER JOIN procedurebodyparts pbp ON pbp.bodyPartId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.bodypartId#">
																AND pbp.deletedAt IS NULL
							INNER JOIN specialtyprocedures sp ON sp.procedureId = pbp.procedureId
									AND specialty.specialtyId = sp.specialtyId AND sp.deletedAt IS NULL
						</cfif>
						<cfif doctorName neq "">
							INNER JOIN accountdoctorsearchsummary adss ON
								adss.doctorLocationId =	specialty.accountDoctorLocationId AND adss.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#doctorName#%">
						</cfif>
						WHERE 1
							<cfif ListLen(arguments.stateAndCityIds)>
								AND (specialty.stateId,specialty.cityid) IN (#arguments.stateAndCityIds#)
							</cfif>
							<cfif ArrayLen(shape.lines)>
								<cfloop from="1" to="#ArrayLen(shape.lines)#" index="Local.FS_current">
									<cfset Local.FS_next = Iif(Local.FS_current eq ArrayLen(shape.lines),1,DE(Local.FS_current+1))>
									AND ((#shape.lines[Local.FS_next].x - shape.lines[Local.FS_current].x#)*(specialty.latitude - #shape.lines[Local.FS_current].y#) - (#shape.lines[Local.FS_next].y - shape.lines[Local.FS_current].y#)*(specialty.longitude - #shape.lines[Local.FS_current].x#)) <= 0
								</cfloop>
							<cfelse>
								<cfif country neq 0>
									AND specialty.countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#country#">
								</cfif>
								<cfif state neq 0>
								AND specialty.stateId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#state#">
								</cfif>
								<cfif city neq 0>
									AND specialty.cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#city#">
								</cfif>
								<cfif zipCode neq "" and distance eq 0>
									AND specialty.postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#zipCode#">
								</cfif>
							</cfif>
							<cfif specialtyId neq 0>
								AND specialty.specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
							</cfif>
						GROUP BY specialty.specialtyId
						ORDER BY specialty.specialtyName;
					</cfquery>
				</cfif>
			</cfif>

		<cfelseif arguments.info eq "gender">

			<cfif procedureId neq 0 AND gender eq "" AND specialtyId eq 0 AND languageId eq 0
				AND NOT ArrayLen(shape.lines)
				AND ListLen(arguments.cityIds) eq 0 AND state eq 0  AND city eq 0 AND zipCode eq ""
				AND doctorName eq "">

				<cfquery datasource="#get('dataSourceName')#" name="Search">
					SELECT genderId AS id, genderName As name, doctorCount
					FROM accountdoctorfilterproceduresgenders
					WHERE procedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
				</cfquery>

			<cfelseif specialtyId neq 0 AND procedureId eq 0 AND gender eq "" AND languageId eq 0
				AND NOT ArrayLen(shape.lines)
				AND ListLen(arguments.cityIds) eq 0 AND state eq 0  AND city eq 0 AND zipCode eq ""
				AND doctorName eq "">

				<cfquery datasource="#get('dataSourceName')#" name="Search">
					SELECT genderId AS id, genderName As name, doctorCount
					FROM accountdoctorfilterspecialtygenders
					WHERE specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
				</cfquery>

			<cfelse>

				<cfquery datasource="#get('dataSourceName')#" name="Search">
					SELECT gender.gender AS id, gender.gender AS name, count(distinct(gender.accountDoctorLocationId)) AS doctorCount
					FROM accountdoctorfiltergendersummary gender
					<cfif specialtyId neq 0>
						INNER JOIN accountdoctorfilterspecialtysummary specialty ON
	 						specialty.specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
							AND  specialty.accountDoctorLocationId = gender.accountDoctorLocationId
					</cfif>
					<cfif procedureId neq 0>
						INNER JOIN accountdoctorfilterproceduresummary procedure1
						USE INDEX (procedureAccountDoctorLocationIdx)
						ON
	 						procedure1.procedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
							AND procedure1.accountDoctorLocationId = gender.accountDoctorLocationId
					</cfif>
					<cfif languageId neq 0>
						INNER JOIN accountdoctorfilterlanguagesummary language ON
							language.languageId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#languageId#">
							AND language.accountDoctorLocationId = gender.accountDoctorLocationId
					</cfif>
					<cfif val(arguments.bodypartId) NEQ 0>
						INNER JOIN accountdoctorfilterbodypartsummary bodypart ON
	 						bodypart.bodyPartId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.bodypartId#">
							AND bodypart.accountDoctorLocationId = gender.accountDoctorLocationId
					</cfif>
					<cfif doctorName neq "">
						INNER JOIN accountdoctorsearchsummary adss ON
							adss.doctorLocationId =	gender.accountDoctorLocationId AND adss.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#doctorName#%">
					</cfif>
					WHERE 1
						<cfif ArrayLen(shape.lines) AND ListLen(arguments.stateIds) AND ListLen(arguments.cityIds)>
							AND gender.stateId IN (#arguments.stateIds#)
							AND gender.cityid IN (#arguments.cityIds#)
						<cfelseif ListLen(arguments.stateAndCityIds)>
							AND (gender.stateId,gender.cityid) IN (#arguments.stateAndCityIds#)
						</cfif>
						<cfif ArrayLen(shape.lines)>
							<cfloop from="1" to="#ArrayLen(shape.lines)#" index="Local.FG_current">
								<cfset Local.FG_next = Iif(Local.FG_current eq ArrayLen(shape.lines),1,DE(Local.FG_current+1))>
								AND ((#shape.lines[Local.FG_next].x - shape.lines[Local.FG_current].x#)*(gender.latitude - #shape.lines[Local.FG_current].y#) - (#shape.lines[Local.FG_next].y - shape.lines[Local.FG_current].y#)*(gender.longitude - #shape.lines[Local.FG_current].x#)) <= 0
							</cfloop>
						<cfelse>
							<cfif country neq 0>
								AND gender.countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#country#">
							</cfif>
							<cfif state neq 0>
								AND gender.stateId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#state#">
							</cfif>
							<cfif city neq 0>
								AND gender.cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#city#">
							</cfif>
							<cfif zipCode neq "" and distance eq 0>
								AND gender.postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#zipCode#">
							</cfif>
						</cfif>
						<cfif gender neq "">
							AND gender.gender = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gender#">
						</cfif>
					GROUP BY gender.gender
					ORDER BY gender.gender;
				</cfquery>
			</cfif>

		<cfelseif arguments.info eq "languages">

			<cfif procedureId neq 0 AND gender eq "" AND specialtyId eq 0 AND languageId eq 0
				AND NOT ArrayLen(shape.lines)
				AND ListLen(arguments.cityIds) eq 0 AND state eq 0  AND city eq 0 AND zipCode eq ""
				AND doctorName eq "">

				<cfquery datasource="#get('dataSourceName')#" name="Search">
					SELECT languageId AS id, languageName As name, doctorCount
					FROM accountdoctorfilterprocedureslanguages
					WHERE procedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
				</cfquery>

			<cfelseif specialtyid neq 0 AND procedureId eq 0 AND gender eq "" AND languageId eq 0
				AND NOT ArrayLen(shape.lines)
				AND ListLen(arguments.cityIds) eq 0 AND state eq 0  AND city eq 0 AND zipCode eq ""
				AND doctorName eq "">

				<cfquery datasource="#get('dataSourceName')#" name="Search">
					SELECT languageId AS id, languageName As name, doctorCount
					FROM accountdoctorfilterspecialtylanguages
					WHERE specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyid#">
				</cfquery>

			<cfelse>
				<cfquery datasource="#get('dataSourceName')#" name="Search">
					SELECT language.languageId AS id, language.languageName AS name, count(distinct(language.accountDoctorLocationId)) AS doctorCount
					FROM accountdoctorfilterlanguagesummary language
					<cfif specialtyId neq 0>
						INNER JOIN accountdoctorfilterspecialtysummary specialty ON
							specialty.specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
							AND  specialty.accountDoctorLocationId = language.accountDoctorLocationId
					</cfif>
					<cfif procedureId neq 0>
						INNER JOIN accountdoctorfilterproceduresummary procedure1 ON
							procedure1.procedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
							AND procedure1.accountDoctorLocationId = language.accountDoctorLocationId
					</cfif>
					<cfif gender neq "">
						INNER JOIN accountdoctorfiltergendersummary gender ON
							gender.gender = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gender#">
							AND  gender.accountDoctorLocationId = language.accountDoctorLocationId
					</cfif>
					<cfif val(arguments.bodypartId) NEQ 0>
						INNER JOIN accountdoctorfilterbodypartsummary bodypart ON
	 						bodypart.bodyPartId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.bodypartId#">
							AND bodypart.accountDoctorLocationId = language.accountDoctorLocationId
					</cfif>
					<cfif doctorName neq "">
						INNER JOIN accountdoctorsearchsummary adss ON
							adss.doctorLocationId =	language.accountDoctorLocationId AND adss.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#doctorName#%">
					</cfif>
					WHERE 1
						<cfif ListLen(arguments.stateAndCityIds)>
							AND (language.stateId,language.cityid) IN (#arguments.stateAndCityIds#)
						</cfif>
						<cfif ArrayLen(shape.lines)>
							<cfloop from="1" to="#ArrayLen(shape.lines)#" index="Local.FL_current">
								<cfset Local.FL_next = Iif(Local.FL_current eq ArrayLen(shape.lines),1,DE(Local.FL_current+1))>
								AND ((#shape.lines[Local.FL_next].x - shape.lines[Local.FL_current].x#)*(language.latitude - #shape.lines[Local.FL_current].y#) - (#shape.lines[Local.FL_next].y - shape.lines[Local.FL_current].y#)*(language.longitude - #shape.lines[Local.FL_current].x#)) <= 0
							</cfloop>
						<cfelse>
							<cfif country neq 0>
							AND language.countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#country#">
							</cfif>
							<cfif state neq 0>
								AND language.stateId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#state#">
							</cfif>
							<cfif city neq 0>
								AND language.cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#city#">
							</cfif>
							<cfif zipCode neq "" and distance eq 0>
								AND language.postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#zipCode#">
							</cfif>
						</cfif>
						<cfif languageId neq 0>
							AND language.languageId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#languageId#">
						</cfif>
					GROUP BY language.languageId
					ORDER BY language.languageName;
				</cfquery>
			</cfif>

		<cfelseif arguments.info eq "bodyparts">

				<cfquery datasource="#get('dataSourceName')#" name="Search">
					SELECT bodypart.bodyPartId AS id, bodypart.bodyPartName AS name, count(distinct(bodypart.accountDoctorLocationId)) AS doctorCount
					FROM accountdoctorfilterbodypartsummary bodypart
					<cfif specialtyId neq 0>
						INNER JOIN accountdoctorfilterspecialtysummary specialty
							ON
							specialty.specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
							AND  specialty.accountDoctorLocationId = bodypart.accountDoctorLocationId
					</cfif>
					<cfif procedureId neq 0>
						INNER JOIN accountdoctorfilterproceduresummary procedure1
									USE INDEX (procedureAccountDoctorLocationIdx)
						ON
							procedure1.procedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
							AND procedure1.accountDoctorLocationId = bodypart.accountDoctorLocationId
					</cfif>
					<cfif gender neq "">
						INNER JOIN accountdoctorfiltergendersummary gender ON
							gender.gender = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gender#">
							AND  gender.accountDoctorLocationId = bodypart.accountDoctorLocationId
					</cfif>
					<cfif languageId neq 0>
						INNER JOIN accountdoctorfilterlanguagesummary language ON
							language.languageId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#languageId#">
							AND language.accountDoctorLocationId = bodypart.accountDoctorLocationId
					</cfif>
					<cfif doctorName neq "">
						INNER JOIN accountdoctorsearchsummary adss ON
							adss.doctorLocationId =	bodypart.accountDoctorLocationId AND adss.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#doctorName#%">
					</cfif>
					WHERE 1
						<cfif ListLen(arguments.stateAndCityIds)>
							AND (bodypart.stateId,bodypart.cityid) IN (#arguments.stateAndCityIds#)
						</cfif>
						<cfif ArrayLen(shape.lines)>
							<cfloop from="1" to="#ArrayLen(shape.lines)#" index="Local.FL_current">
								<cfset Local.FL_next = Iif(Local.FL_current eq ArrayLen(shape.lines),1,DE(Local.FL_current+1))>
								AND ((#shape.lines[Local.FL_next].x - shape.lines[Local.FL_current].x#)*(bodypart.latitude - #shape.lines[Local.FL_current].y#) - (#shape.lines[Local.FL_next].y - shape.lines[Local.FL_current].y#)*(bodypart.longitude - #shape.lines[Local.FL_current].x#)) <= 0
							</cfloop>
						<cfelse>
							<cfif country neq 0>
								AND bodypart.countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#country#">
							</cfif>
							<cfif state neq 0>
								AND bodypart.stateId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#state#">
							</cfif>
							<cfif city neq 0>
								AND bodypart.cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#city#">
							</cfif>
							<cfif zipCode neq "" and distance eq 0>
								AND bodypart.postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#zipCode#">
							</cfif>
						</cfif>
						<cfif val(arguments.bodyPartId) neq 0>
							AND bodypart.bodyPartId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.bodyPartId#">
						</cfif>
					GROUP BY bodypart.bodyPartId
					ORDER BY bodypart.bodyPartName;
				</cfquery>

		<cfelse>

			<cfquery datasource="#get('dataSourceName')#" name="Search">
				<cfif arguments.info eq "search">
					SELECT DISTINCT SQL_CALC_FOUND_ROWS adl.ID as ID, ad.id as doctorID, al.ID as locationID,
						ad.firstName, ad.middleName, ad.lastName, ad.title, cities.name as city, states.name as state,
						ap.name as practice, ad.photoFilename, '' as specialtyList, '' as description,
						'' as topprocedures, '' as financingoptions, al.latitude, al.longitude, al.postalCode, al.address, states.abbreviation,
						ald.languagesSpoken, ad.yearsInPractice, ad.yearStartedPracticing
						,case when (SELECT app.id FROM accountproductspurchaseddoctorlocations appdl
							JOIN accountproductspurchased app on appdl.accountProductsPurchasedId = app.id
							WHERE adl.id = appdl.accountDoctorLocationId
							AND app.accountProductId = 1
							AND now() <= app.dateEnd
							LIMIT 1) is not null then 1 else 0 end as isFeatured
						,case when (SELECT count(BP_aD.id)
							FROM accountdoctors BP_aD
							INNER JOIN accountdoctorlocations BP_adl ON BP_adl.accountDoctorId = BP_aD.id AND BP_adl.deletedAt IS NULL
							INNER JOIN accountdoctoremails BP_aDE ON BP_aDE.accountDoctorId = BP_aD.id AND BP_aDE.categories = "lead" AND BP_aDE.deletedAt IS NULL
							INNER JOIN accountpractices BP_aP ON BP_aP.id = BP_adl.accountPracticeId AND BP_aP.deletedAt IS NULL
							LEFT JOIN accountproductspurchased BP_app ON BP_app.accountId = BP_aP.accountId AND BP_app.deletedAt IS NULL
							LEFT JOIN accountproductspurchasedhistory BP_apph ON BP_apph.accountId = BP_aP.accountId AND BP_apph.deletedAt IS NULL
							WHERE BP_aD.id = ad.id AND BP_aD.deletedAt IS NULL AND BP_app.id IS NULL AND BP_apph.id IS NULL
							) > 0 then 1 else 0 end as isBasicPlus
						,case when yext.associationId is not null then 1 else 0 end as isYext
						,case when (ad.photoFilename != '' and count(ads.id) > 0) then 2
							 when (count(ads.id) > 0) then 1
							 else 0 end
							 as inforank
				<cfelseif arguments.info eq "featured">
					SELECT DISTINCT SQL_CALC_FOUND_ROWS adl.ID as ID, ad.id as doctorID, al.ID as locationID, ap.ID as practiceID,
						ad.firstName, ad.middleName, ad.lastName, ad.title, cities.name as city, states.abbreviation as state,
						ap.name as practice, ad.photoFilename, al.latitude, al.longitude, al.postalCode, al.address, states.abbreviation
						,(SELECT specialties.name FROM specialties WHERE specialties.id = min(als.specialtyid) LIMIT 1) as specialty,
						(SELECT GROUP_CONCAT(DISTINCT specialties.name ORDER BY specialties.name SEPARATOR  ", ") FROM specialties WHERE specialties.id = als.specialtyid) as specialtyList,
						<cfif specialtyId neq 0>
						max(appdl.PracticeRankSpecialtyScore) as PracticeRank
						<cfelse>
						max(appdl.PracticeRankScore) as PracticeRank
						</cfif>
				<cfelse>
					SELECT id, name, count(doctorID) as doctorcount FROM(
				</cfif>
				<cfif arguments.info eq "search" or arguments.info eq "featured">
					,case when(
						SELECT 1
						FROM accountproductspurchaseddoctorlocations
						JOIN accountproductspurchased ON accountproductspurchaseddoctorlocations.accountProductsPurchasedId = accountproductspurchased.id
														AND accountproductspurchased.accountProductId = 7 AND accountproductspurchased.dateEnd >= now()
														AND accountproductspurchased.deletedAt is null
						WHERE accountproductspurchaseddoctorlocations.accountDoctorLocationId = adl.ID
						LIMIT 1) is null
						then ald.phoneYext else ald.phonePlus end as phone
					,(SELECT count(adlr.id) FROM accountdoctorlocationrecommendations adlr
						WHERE adlr.accountDoctorLocationId = adl.id AND adlr.deletedAt is null) as comments
					,(SELECT sum(adlr.rating * Log10(10-9*DateDiff(now(),adlr.createdAt)/365)) / sum(Log10(10-9*DateDiff(now(),adlr.createdAt)/365))
						FROM accountdoctorlocationrecommendations adlr
						WHERE adlr.accountDoctorLocationId = adl.id
						AND DateDiff(now(),adlr.createdAt) < 365
						AND adlr.deletedAt is null) as rating
					,(case when ad.lastName = '' then ap.name else ad.lastName end) as nameSort
				</cfif>
				<cfif arguments.latitude neq 0 and arguments.longitude neq 0 and (arguments.overrideClient or (arguments.distance gt 0 and arguments.info neq "featured"))>
					,sqrt(POW((69.1*(if(al.latitude is not null, al.latitude, pc.latitude)-(#arguments.latitude#))),2)
					 +POW(69.1*(if(al.longitude is not null, al.longitude, pc.longitude)-(#arguments.longitude#))
					 *cos((#arguments.latitude#)/57.3),2)) as distance
				<cfelse>
					,-1 as distance
				</cfif>

					FROM accountdoctorlocations adl
						JOIN accountlocations al ON adl.accountLocationId = al.id
						JOIN accountdoctors ad ON adl.accountDoctorId = ad.id
						JOIN accountpractices ap on adl.accountPracticeId = ap.id
					<cfif (arguments.info eq "search") or (arguments.info eq "featured") or (arguments.info eq "specialties") or (specialtyId neq 0)>
						LEFT OUTER JOIN accountlocationspecialties als ON adl.id = als.accountDoctorLocationId
					</cfif>
					<cfif (arguments.info eq "search") or (arguments.info eq "featured")>
						JOIN cities on al.cityid = cities.id
						LEFT OUTER JOIN states on al.stateid = states.id
						LEFT OUTER JOIN accountlocationdetails ald on adl.id = ald.accountDoctorLocationId
					</cfif>
					<cfif languageId neq 0>
						JOIN accountlocationlanguages allang on adl.id = allang.accountDoctorLocationId
					</cfif>
					<cfif (procedureId neq 0 or bodypartId neq 0 or ListLen(arguments.procedureIdList))>
						LEFT OUTER JOIN accountdoctorprocedures adp ON adl.accountDoctorId = adp.accountDoctorId AND adp.deletedAt IS NULL
							<cfif ListLen(arguments.procedureIdList)>
								AND adp.procedureId IN (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" separator="," value="#arguments.procedureIdList#">)
							</cfif>
						<cfif bodypartId neq 0 or ListLen(arguments.procedureIdList)>
							JOIN procedures p on adp.procedureid = p.id AND p.deletedAt is null
							<cfif bodypartId neq 0>
								JOIN procedurebodyparts pbp on p.id = pbp.procedureId
							</cfif>
						</cfif>
					</cfif>
					<cfif arguments.info eq "search">
						LEFT OUTER JOIN accountdescriptions ads ON als.accountDescriptionId = ads.id
						LEFT OUTER JOIN (SELECT ada.associationId, ada.accountDoctorId
						   FROM accountdoctorassociations ada
							WHERE ada.associationId = 7
							AND ada.deletedAt IS NULL) as yext
							ON yext.accountDoctorId = ad.id
					</cfif>
					<cfif arguments.info eq "featured">
						JOIN accountproductspurchaseddoctorlocations appdl on adl.id = appdl.accountDoctorLocationId
						JOIN accountproductspurchased app on appdl.accountProductsPurchasedId = app.id
							AND app.accountProductId = 1
						JOIN accountdoctorlocationspecialtyproductzones adlspz on adl.id = adlspz.accountDoctorLocationId

						<cfif arguments.overrideZoneLimit IS TRUE>
							JOIN postalcodes zone ON zone.cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#city#">
													AND zone.deletedAt IS NULL
						</cfif>
					</cfif>
					<cfif arguments.latitude neq 0 and arguments.longitude neq 0 and (arguments.overrideClient or (arguments.distance gt 0 and arguments.info neq "featured"))>
						<cfif arguments.country eq 12>
							JOIN postalcodecanadas pc
						<cfelse>
							JOIN postalcodes pc
						</cfif>
						on replace(al.postalCode, " ", "") = pc.postalCode AND al.cityId = pc.cityId
					</cfif>

					WHERE adl.deletedAt is null AND al.deletedAt is null
					AND ad.deletedAt is null AND ap.deletedAt is null
				<cfif procedureId neq 0>
					AND adp.procedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#"> AND adp.deletedAt IS NULL
				</cfif>
				<cfif bodyPartId neq 0>
					AND pbp.bodyPartId = <cfqueryparam cfsqltype="cf_sql_integer" value="#bodyPartId#">
				</cfif>
				<cfif arguments.info eq "featured">
					AND ad.photoFilename != ""
					AND appdl.deletedAt is null AND app.deletedAt is null
					AND now() <= app.dateEnd
					<cfif zoneID neq "" AND arguments.overrideZoneLimit IS FALSE>
						AND (adlspz.zoneId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#zoneID#">
						OR adlspz.zoneId is null)
					<cfelseif arguments.overrideZoneLimit IS TRUE>
						AND adlspz.stateId = zone.stateId AND adlspz.zoneId = zone.zone
					</cfif>
					<cfif state neq 0 AND arguments.overrideZoneLimit IS FALSE>
						AND adlspz.stateId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#state#">
					</cfif>
					<cfif specialtyId neq 0>
						AND adlspz.specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
						AND appdl.specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
						AND als.specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
					</cfif>
				<cfelse>
					<cfif doctorName neq "">
						AND ad.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#doctorName#%">
					</cfif>
					<cfif gender neq "">
						AND ad.gender = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gender#">
					</cfif>
					<cfif specialtyId neq 0>
						AND als.specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
					</cfif>
					<cfif languageId neq 0>
						AND allang.languageId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#languageId#">
					</cfif>
					<cfif ListLen(arguments.stateAndCityIds)>
							AND (al.stateId,al.cityid) IN (#arguments.stateAndCityIds#)
					</cfif>

					<cfif ArrayLen(shape.lines)>
						<cfloop from="1" to="#ArrayLen(shape.lines)#" index="Local.OS_current">
							<cfset Local.OS_next = Iif(Local.OS_current eq ArrayLen(shape.lines),1,DE(Local.OS_current+1))>
							AND ((#shape.lines[Local.OS_next].x - shape.lines[Local.OS_current].x#)*(al.latitude - #shape.lines[Local.OS_current].y#) - (#shape.lines[Local.OS_next].y - shape.lines[Local.OS_current].y#)*(al.longitude - #shape.lines[Local.OS_current].x#)) <= 0
						</cfloop>
					<cfelse>
						<cfif city neq 0>
							AND al.cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#city#">
						</cfif>
						<cfif state neq 0>
							AND al.stateId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#state#">
						</cfif>
						<cfif zipCode neq "" and distance eq 0>
							AND al.postalCode LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#zipCode#">
						</cfif>
						<cfif country neq 0>
							AND al.countryid = <cfqueryparam cfsqltype="cf_sql_integer" value="#country#">
						</cfif>
					</cfif>
				</cfif>

				<cfif arguments.info eq "search">
					GROUP BY adl.ID, ad.id, al.ID, ad.firstName, ad.middleName, ad.lastName, ad.title,
					cities.name, states.name, ap.name, ad.photoFilename, al.latitude, al.longitude, al.postalCode,
					al.address, states.abbreviation
					<cfif arguments.latitude neq 0 and arguments.longitude neq 0 and arguments.distance gt 0>
						HAVING distance <= <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.distance#">
					</cfif>
					ORDER BY
					<cfif arguments.latitude neq 0 and arguments.longitude neq 0 and arguments.distance gt 0>
						distance ASC,
					</cfif>
					isFeatured DESC, isYext DESC, isBasicPlus DESC, inforank DESC, #sortBy#
					LIMIT #limit# OFFSET #offset#
				<cfelseif arguments.info eq "featured">
					GROUP BY ad.id
					ORDER BY
						<cfif ListLen(arguments.procedureIdList)>
							Field(adp.procedureId, #arguments.procedureIdList#),
						</cfif>
					PracticeRank DESC, #sortBy#
					<cfif limit gt 0>LIMIT #limit#</cfif>
				<cfelse>
					<cfif arguments.latitude neq 0 and arguments.longitude neq 0 and arguments.distance gt 0>
						HAVING distance <= <cfqueryparam cfsqltype="cf_sql_double" value="#arguments.distance#">
					</cfif>
					) data
					GROUP BY id, name
					ORDER BY name
				</cfif>;
			</cfquery>
		</cfif>
		<cfreturn Search>
	</cffunction>

	<!--- Determine if a location will return any results --->
	<cffunction name="testLocation" returntype="numeric">
		<cfargument name="country"		type="numeric" 	required="false" default="0">
		<cfargument name="zipCode"		type="string"	required="false" default="">
		<cfargument name="city"			type="numeric"	required="false" default="0">
		<cfargument name="state"		type="numeric"	required="false" default="0">
		<cfargument name="doctorName"	type="string"	required="false" default="">
		<cfargument name="procedureId"	type="numeric"	required="false" default="0">
		<cfargument name="specialtyId"	type="numeric"	required="false" default="0">

		<cfset determinedDistance = 0>

		<!--- Determine if current criteria will return any results --->
		<cfquery datasource="#get('dataSourceName')#" name="SearchTest">
			SELECT COUNT(1) as doctorcount
			FROM accountdoctorsearchsummary adss
			WHERE 1=1
			<cfif city neq 0>
				AND adss.cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#city#">
			</cfif>
			<cfif state neq 0>
				AND adss.stateId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#state#">
			</cfif>
			<cfif zipCode neq "">
				AND adss.postalCode LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#zipCode#">
			</cfif>
			<cfif doctorName neq "">
				AND adss.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#doctorName#%">
			</cfif>
			<cfif procedureId neq 0>
				AND FIND_IN_SET(<cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">,adss.procedureIds)
			</cfif>
			<cfif specialtyId neq 0>
				AND FIND_IN_SET(<cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">,adss.specialtyIds)
			</cfif>
		</cfquery>

		<cfif SearchTest.doctorcount eq 0>
			<!--- If no results, find distance to closest match --->
			<cfquery datasource="#get('dataSourceName')#" name="GetCoordinates">
				SELECT latitude,longitude
				<cfif arguments.country eq 12>
					FROM postalcodecanadas pc
				<cfelse>
					FROM postalcodes pc
				</cfif>
				WHERE 1=1
				<cfif city neq 0>
					AND pc.cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#city#">
				</cfif>
				<cfif state neq 0>
					AND pc.stateId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#state#">
				</cfif>
				<cfif zipCode neq "">
					AND pc.postalCode LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#zipCode#">
				</cfif>
			</cfquery>

			<cfif GetCoordinates.recordcount>
				<cfquery datasource="#get('dataSourceName')#" name="GetNearest">
					SELECT min(sqrt(POW((69.1*(adss.latitude-(#GetCoordinates.latitude#))),2)
						+POW(69.1*(adss.longitude-(#GetCoordinates.longitude#))
						*cos((#GetCoordinates.latitude#)/57.3),2))) as distance
					FROM accountdoctorsearchsummary adss
					<cfif procedureId neq 0>
						INNER JOIN accountdoctorprocedures adp ON adp.accountDoctorId = adss.doctorID AND adp.procedureId
									= <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
								AND adp.deletedAt IS NULL
					</cfif>
					<cfif specialtyId neq 0>
						INNER JOIN accountlocationspecialties als ON als.specialtyId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#specialtyId#">
																AND adss.doctorLocationId = als.accountDoctorLocationId
					</cfif>
					WHERE 1=1
					<cfif doctorName neq "">
						AND adss.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#doctorName#%">
					</cfif>
				</cfquery>
				<cfset determinedDistance = Ceiling(val(GetNearest.distance)/10) * 10>
			</cfif>
		</cfif>
		<cfreturn determinedDistance>
	</cffunction>

	<cffunction name="GetDoctorLocations" returntype="query">
		<cfargument name="accountDoctorId" required="true" type="numeric">

		<cfset var qDoctorLocations  = "">

		<cfquery datasource="#get('dataSourceName')#" name="qDoctorLocations">
			SELECT accountlocations.id AS id, accountlocations.latitude, accountlocations.longitude, accountlocations.address, cities.name, states.abbreviation, accountlocations.postalCode, accountlocations.phone AS phonePlus <!--- accountlocationdetails.phonePlus --->
			FROM accountlocations
			INNER JOIN accountdoctorlocations ON accountlocations.id = accountdoctorlocations.accountLocationId
			INNER JOIN accountlocationspecialties ON accountdoctorlocations.id = accountlocationspecialties.accountDoctorLocationId
			INNER JOIN cities ON accountlocations.cityId = cities.id
			INNER JOIN states ON accountlocations.stateId = states.id
			LEFT JOIN accountlocationdetails ON accountdoctorlocations.id = accountlocationdetails.accountDoctorLocationId
			WHERE
			 (
			accountdoctorlocations.accountDoctorId =
			<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorId#">
			 AND
			accountlocationspecialties.specialtyId IS NOT
			NULL
			) AND (
			accountlocations.deletedAt IS NULL AND accountdoctorlocations.deletedAt IS NULL AND accountlocationdetails.deletedAt IS NULL AND accountlocationspecialties.deletedAt IS NULL AND cities.deletedAt IS NULL AND states.deletedAt IS NULL
			)
			GROUP BY accountdoctorlocations.id
			ORDER BY states.abbreviation ASC, cities.name ASC
		</cfquery>

		<cfreturn qDoctorLocations>
	</cffunction>

	<cffunction name="BasicPlusThresholdEmail">
		<cfargument name="doctorLocationId" required="true">
		<cfargument name="clientEmail" required="true">

		<cfquery datasource="#get('dataSourceName')#" name="doctorInfo">
			SELECT accountDoctorId, accountId, firstname, lastname
			FROM accountdoctorlocations
			JOIN accountpractices ON accountdoctorlocations.accountPracticeId = accountpractices.id
			JOIN accountdoctors ON accountdoctorlocations.accountDoctorId = accountdoctors.id
			WHERE accountdoctorlocations.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doctorLocationId#">
		</cfquery>

		<!--- If doctor already received this email, stop --->
		<cfquery datasource="#get('dataSourceName')#" name="emailCheck">
			SELECT id
			FROM profilethresholdleademails
			WHERE accountId = <cfqueryparam cfsqltype="cf_sql_integer" value="#doctorInfo.accountId#">
			AND deletedAt is null;
		</cfquery>
		<cfif emailCheck.recordcount gt 0><cfreturn></cfif>

		<cfset emailQuery = model("AccountDoctorEmail").findAll(
							select="email",
							distinct="true",
							include="accountEmail",
							where="accountDoctorId = #doctorInfo.accountDoctorId# AND (categories = 'Lead' OR categories = 'Doctor')"
		)>
		<!--- compose unique email list --->
		<cfset docEmails = "">
		<cfloop query="emailQuery">
			<cfif ListContains(docEmails,emailQuery.email) eq 0>
				<cfset docEmails = ListAppend(docEmails,emailQuery.email)>
			</cfif>
		</cfloop>

		<cfif Find("@mojointeractive.com",arguments.clientEmail) gt 0>
			<cfset emailTo = arguments.clientEmail>
		<cfelseif server.thisServer EQ "dev">
			<cfset emailTo = "jason@mojointeractive.com">
		<cfelse>
			<cfset emailTo = docEmails>
		</cfif>

		<cfif emailTo eq "">
			<cfreturn>
		</cfif>

		<cfif server.thisServer EQ "dev">
			<cfset strEnvironment = "http://dev">
		<cfelse>
			<cfset strEnvironment = "https://www">
		</cfif>

		<!--- <cfset allLeads = model("ProfileLead").getLAD2Leads(arguments.doctorLocationId)> --->
		<cfstoredproc procedure="BasicPlusLeads" datasource="myLocateadocEdits">
			<cfprocresult name="allLeads">
			<cfprocparam cfsqltype="cf_sql_integer" value="#doctorInfo.accountId#">
			<cfprocparam cfsqltype="cf_sql_date" null="yes">
		</cfstoredproc>
		<cfset salesManager = model("Account").getManager(doctorInfo.accountId)>
		<cfset PDockUsername = model("Account").getPDockUsername(doctorInfo.accountId)>

		<!--- Define email body --->
		<cfsavecontent variable="emailBody">
			<cfoutput>
			<HTML>
			<BODY>
			<cfif Find("@mojointeractive.com",arguments.clientEmail) gt 0 or server.thisServer EQ "dev">
				<p>(Test email. Intended recipient: #docEmails#)</p>
			</cfif>
			<P style="margin-left:3px;"><A HREF="http://www.practicedock.com"><IMG SRC="http://www.locateadoc.com/images/layout/email/PDock_header.jpg" BORDER="0"></A></P>
			<table style="margin:0px; padding:0px; border-spacing:0px;"><tr style="margin:0px; padding:0px;"><td style="border:1px solid ##C4C4C4; width:586px; margin:0px; padding:15px;">
			<FONT FACE="Arial,Helvetica,Sans-serif" SIZE="2">

			<P>#doctorInfo.firstname# #doctorInfo.lastname#,</P>

			<p>Your complimentary trial period has ended on the new LocateADoc.com site.
			During this time you received <span style="color: red; font-weight: bold;">#allLeads.recordcount# patient leads</span>.</p>

			<p>If you would like to continue to receive patient leads, please contact
				<b>#salesManager.FirstName# #salesManager.LastName#</b> at <b>877-809-1777</b> or email
				<a href="mailto:#salesManager.email#"><b>#salesManager.email#</b></a>.</p>

			<p>Here is a snap shot of all of your patient leads received on the new site:</p>

			<table style="width: 100%; font: 12px Arial, Helvetica, sans-serif;	cell-spacing: 0; border-width: 0px;	border-collapse: collapse;">
				<thead style="background-color: ##5eb6e7;color: ##ffffff;font-weight: bold;">
					<tr>
						<th style="padding: 5px; text-align:left;">Lead Name</th>
						<th style="padding: 5px; text-align:left;">Procedure/Treatment Interested In</th>
						<th style="padding: 5px; text-align:left;">Date Received</th>
						<th style="padding: 5px; text-align:left;">Lead Status</th>
					</tr>
				</thead>
				<tbody>
				  <cfloop query="allLeads">
					<tr style="height: 30px;">
						<td style="padding: 5px;">
							<cfif allLeads.leadType neq "phone">
							<a href="#strEnvironment#.practicedock.com/admin/LocateADoc/leads/index.cfm?id=#allLeads.id#&type=#allLeads.leadType#">
								#allLeads.firstname# #allLeads.lastname#
							</a>
							<cfelse>
								#allLeads.firstname# #allLeads.lastname#
							</cfif>
						</td>
						<td style="padding: 5px;">
							<cfif ListLen(allLeads.procedureIDs) gt 0>
								#model("Procedure").findAll(select="name",where="id=#ListFirst(allLeads.procedureIDs)#").name#
							</cfif>
						</td>
						<td style="padding: 5px;">#DateFormat(allLeads.date,'m-d-yyyy')#</td>
						<td style="padding: 5px;">
							<cfif allLeads.isLeadOpened eq 0>
								<span style="color: red; font-weight: bold;">Unopened</span>
							<cfelse>
								<p>Opened</p>
							</cfif>
						</td>
					</tr>
					<cfif currentrow lt recordcount>
						<tr style="background-color: ##EEEEEE; height: 1px;">
							<td style="padding: 0;" colspan="4"></td>
						</tr>
					</cfif>
				  </cfloop>
				</tbody>
			</table>

			<p style="color: red;">You will no longer be receiving patient leads from LocateADoc.com.</p>

			<p>View and respond to your patient leads by logging into PracticeDock.
			<a href="https://www.practicedock.com/index.cfm/PageID/7151">www.practicedock.com</a></p>

			<cfif PDockUsername neq "">
				<p>
				PracticeDock username: <b>#PDockUsername#</b>
				<br/>
				Password: <b>(see below)</b>
				</p>

				<p>Forgot your password? Using the PracticeDock login email address #PDockUsername#
				we have on file for you, visit the PracticeDock password reminder page and you can request
				your password be emailed to that address.</p>
			</cfif>

			<p>Thank you,<br/>
			The LocateADoc.com Support Team</p>

			</FONT>
			</td></tr></table>
			</BODY>
			</HTML>
			</cfoutput>
		</cfsavecontent>

		<cfmail from="contact@locateadoc.com"
				to="#emailTo#"
				bcc="#ListAppend('glen@mojointeractive.com,exclusiveleads@locateadoc.com,emailtosalesforce@c-19ynglnp98d89opsn0ysty2on.3z6qeau.6.le.salesforce.com',salesManager.email)#"
				subject="Immediate Attention Required"
				type="html">
			#emailBody#
		</cfmail>

		<cfquery datasource="myLocateadocEdits">
			INSERT INTO profilethresholdleademails (accountId, emailedAt, createdAt)
			VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#doctorInfo.accountId#">, now(), now());
		</cfquery>
	</cffunction>
</cfcomponent>