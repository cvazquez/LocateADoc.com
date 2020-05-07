<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset hasMany(name="galleryCaseProcedures",shortcut="procedures")>
		<cfset hasMany("galleryCaseBodyParts")>
		<cfset hasMany("galleryCaseAngles")>
		<cfset hasMany(name="galleryCaseDoctors",shortcut="accountDoctors")>
		<cfset belongsTo(	name	 	= "galleryGender",
							joinType	= "outer")>
	</cffunction>

	<cffunction name="gallerySearch" returntype="struct" output="true">
		<cfargument name="specificCase"			type="numeric"	required="false" default="0">
		<cfargument name="distance"				type="numeric"	required="false" default="0">
		<cfargument name="location"				type="struct"	required="false">
		<cfargument name="procedureId"			type="string"	required="false" default="">
		<cfargument name="accountDoctorId"		type="numeric"	required="false" default="0">
		<cfargument name="doctorLastName"		type="string"	required="false" default="">
		<cfargument name="doctorSpecialty"		type="numeric"	required="false" default="0">
		<cfargument name="bodyPartId"			type="numeric"	required="false" default="0">
		<cfargument name="genderId"				type="numeric"	required="false" default="0">
		<cfargument name="skinToneId"			type="numeric"	required="false" default="0">
		<cfargument name="afterPhotosTakenId"	type="numeric"	required="false" default="0">
		<cfargument name="breastStartingSizeId"	type="numeric"	required="false" default="0">
		<cfargument name="breastEndingSizeId"	type="numeric"	required="false" default="0">
		<cfargument name="TypeOfImplantId"		type="numeric"	required="false" default="0">
		<cfargument name="ImplantPlacementId"	type="numeric"	required="false" default="0">
		<cfargument name="PointOfEntryId"		type="numeric"	required="false" default="0">
		<cfargument name="ageStart"				type="numeric"	required="false" default="0">
		<cfargument name="ageEnd"				type="numeric"	required="false" default="0">
		<cfargument name="heightStart"			type="numeric"	required="false" default="0">
		<cfargument name="heightEnd"			type="numeric"	required="false" default="0">
		<cfargument name="weightStart"			type="numeric"	required="false" default="0">
		<cfargument name="weightEnd"			type="numeric"	required="false" default="0">
		<cfargument name="sortBy"				type="string"	required="false" default="">
		<cfargument name="page"					type="numeric"	required="false" default="1">
		<cfargument name="perpage"				type="numeric"	required="false" default="10">
		<cfargument name="exclude"				type="numeric"	required="false" default="0">
		<cfargument name="onePerDoctor"			type="boolean"	required="false" default="false">
		<cfargument name="debug"				type="numeric"	required="false" default="0">
		<cfargument name="filtersOn"			type="boolean"	required="false" default="true">
		<cfargument name="PracticeRanked"		type="boolean"	required="false" default="false">
		<cfargument name="aroundrow"			type="numeric"	required="false" default="0">

		<cfif not structKeyExists(arguments,"location")>
			<cfset arguments.location = {
									country		= "",
									countryname	= "",
									state		= "",
									statename	= "",
									city		= "",
									cityname	= "",
									zipcode		= "",
									zipfound	= false,
									longitude	= "",
									latitude	= "",
									cityFound	= false,
									stateFound	= false
								}>
			<cfset thisExists = "false">
		<cfelse>
			<cfset thisExists = "hello = #arguments.location.cityFound#">
			<cfparam default="TRUE" name="arguments.location.cityFound">
			<cfparam default="TRUE" name="arguments.location.stateFound">
		</cfif>

		<cfset var thisQuery		= "">
		<cfset var Local			= {}>
		<cfset Local.qPostalCode	= QueryNew("")>
		<cfset Local.return			= {}>
		<cfset Local.return.page	= arguments.page>
		<cfset Local.return.perpaGe	= arguments.perpage>
		<cfset Local.offset			= ((arguments.page-1)*arguments.perpage)>
		<cfset Local.limit			= arguments.perpage>
		<cfset Local.cityId			= "">
		<cfset Local.stateId		= "">
		<cfset Local.postalCode		= "">

		<cfif arguments.aroundrow gt 0>
			<cfset Local.offset = arguments.aroundrow eq 1 ? 0 : arguments.aroundrow - 2>
			<cfset Local.limit = arguments.aroundrow eq 1 ? 2 : 3>
			<cfset arguments.filtersOn = false>
		</cfif>

		<cfset Local.filters							= {}>
		<cfset Local.filters.procedures					= {}>
		<cfset Local.filters.doctors					= {}>
		<cfset Local.filters.bodyparts					= {}>
		<cfset Local.return.filters 					= {}>
		<cfset Local.return.filters.procedures			= []>
		<cfset Local.return.filters.doctors				= []>
		<cfset Local.return.filters.bodyparts			= []>
		<cfset Local.return.filters.genders				= []>
		<cfset Local.return.filters.skintones			= []>
		<cfset Local.return.filters.apts				= []>
		<cfset Local.return.filters.startingbreastsizes	= []>
		<cfset Local.return.filters.endingbreastsizes	= []>
		<cfset Local.return.filters.implanttypes		= []>
		<cfset Local.return.filters.implantplacements	= []>
		<cfset Local.return.filters.entrypoints			= []>
		<cfset Local.return.filters.heights				= []>
		<cfset Local.return.filters.weights				= []>
		<cfset Local.return.filters.ages				= []>
		<cfset Local.accountDoctorIds					= "">

		<cfif val(len(trim(arguments.doctorLastName)))>
			<cfset docsByName	= model("AccountDoctor")
									.findAll(
										select	= "id",
										where	= "lastName LIKE '#arguments.doctorLastName#%'"
									)>
			<cfset Local.accountDoctorIds = valueList(docsByName.id)>
		</cfif>

		<cfif arguments.location.city neq 0 and arguments.location.state neq 0 and arguments.distance gt 0 and arguments.location.zipCode eq "">
			<cfset Local.return.shape = plotCity(val(arguments.location.city),val(arguments.location.state))>
			<cfset Local.return.shape = enlargeArea(Local.return.shape,val(arguments.distance))>
		<cfelse>
			<cfset Local.return.shape = {coordinates = [],hull = "",lines = [],
								  zoneTop = -200,zoneLeft = 200,zoneBottom = 200,zoneRight = -200}>
		</cfif>

		<cfsavecontent variable="Local.whereClause">
			<cfoutput>
				AND g.galleryCaseAngleIds IS NOT NULL
			<cfif val(arguments.accountDoctorId)>

			<cfelseif val(listlen(Local.accountDoctorIds))>
				AND	g.galleryCaseId IN (SELECT DISTINCT galleryCaseId FROM gallerycasedoctors WHERE accountDoctorId IN (#Local.accountDoctorIds#))
			</cfif>

			<cfif val(arguments.genderId)>
				AND g.galleryGenderId = #val(arguments.genderId)#
			</cfif>
			<cfif val(arguments.skinToneId)>
				AND g.gallerySkinToneId = #val(arguments.skinToneId)#
			</cfif>
			<cfif val(arguments.afterPhotosTakenId)>
				AND g.galleryAfterPhotosTakenId = #val(arguments.afterPhotosTakenId)#
			</cfif>
			<cfif val(arguments.breastStartingSizeId)>
				AND g.galleryBreastStartingSizeId = #val(arguments.breastStartingSizeId)#
			</cfif>
			<cfif val(arguments.breastEndingSizeId)>
				AND g.galleryBreastEndingSizeId = #val(arguments.breastEndingSizeId)#
			</cfif>
			<cfif val(arguments.TypeOfImplantId)>
				AND g.galleryTypeOfImplantId = #val(arguments.TypeOfImplantId)#
			</cfif>
			<cfif val(arguments.ImplantPlacementId)>
				AND g.galleryImplantPlacementId = #val(arguments.ImplantPlacementId)#
			</cfif>
			<cfif val(arguments.PointOfEntryId)>
				AND g.galleryPointOfEntryId = #val(arguments.PointOfEntryId)#
			</cfif>
			<cfif val(arguments.ageEnd)>
				AND g.age BETWEEN #max(0,val(arguments.ageStart))# AND #min(122,val(arguments.ageEnd))#
			</cfif>
			<cfif val(arguments.heightEnd)>
				AND g.height BETWEEN #max(0,val(arguments.heightStart))# AND  #min(120,val(arguments.heightEnd))#
			</cfif>
			<cfif val(arguments.weightEnd)>
				AND g.weight BETWEEN #max(0,val(arguments.weightStart))# AND #min(1400,val(arguments.weightEnd))#
			</cfif>
			<cfif val(arguments.exclude)>
				AND g.galleryCaseId != #arguments.exclude#
			</cfif>
			</cfoutput>
		</cfsavecontent>

		<cfsavecontent variable="Local.whereClauseOptimized">
			<cfoutput>
			<cfif val(arguments.procedureId) AND ListLen(arguments.procedureId) EQ 1>
				AND g.procedureId = #val(arguments.procedureId)#
			</cfif>

			<cfif ListLen(arguments.procedureId) GT 1>
				AND g.procedureId IN (#arguments.procedureId#)
			</cfif>

			<cfif val(arguments.accountDoctorId)>
				AND g.accountDoctorId = #val(arguments.accountDoctorId)#
			<cfelseif val(listlen(Local.accountDoctorIds))>
				AND	g.accountDoctorId IN (#Local.accountDoctorIds#)
			</cfif>

			<cfif val(arguments.bodyPartId)>
				AND g.bodyPartId = #val(arguments.bodyPartId)#
			</cfif>

			<cfif val(arguments.genderId)>
				AND g.galleryGenderId = #val(arguments.genderId)#
			</cfif>

			<cfif val(arguments.skinToneId)>
				AND g.gallerySkinToneId = #val(arguments.skinToneId)#
			</cfif>

			<cfif val(arguments.afterPhotosTakenId)>
				AND g.galleryAfterPhotosTakenId = #val(arguments.afterPhotosTakenId)#
			</cfif>

			<cfif val(arguments.breastStartingSizeId)>
				AND g.galleryBreastStartingSizeId = #val(arguments.breastStartingSizeId)#
			</cfif>

			<cfif val(arguments.breastEndingSizeId)>
				AND g.galleryBreastEndingSizeId = #val(arguments.breastEndingSizeId)#
			</cfif>

			<cfif val(arguments.TypeOfImplantId)>
				AND g.galleryTypeOfImplantId = #val(arguments.TypeOfImplantId)#
			</cfif>

			<cfif val(arguments.ImplantPlacementId)>
				AND g.galleryImplantPlacementId = #val(arguments.ImplantPlacementId)#
			</cfif>

			<cfif val(arguments.PointOfEntryId)>
				AND g.galleryPointOfEntryId = #val(arguments.PointOfEntryId)#
			</cfif>

			<cfif val(arguments.ageEnd)>
				AND g.age BETWEEN #max(0,val(arguments.ageStart))# AND #min(122,val(arguments.ageEnd))#
			</cfif>

			<cfif val(arguments.heightEnd)>
				AND g.height BETWEEN #max(0,val(arguments.heightStart))# AND #min(120,val(arguments.heightEnd))#
			</cfif>

			<cfif val(arguments.weightEnd)>
				AND g.weight BETWEEN #max(0,val(arguments.weightStart))# AND #min(1400,val(arguments.weightEnd))#
			</cfif>

			<cfif val(arguments.exclude)>
				AND g.galleryCaseId != #arguments.exclude#
			</cfif>
			</cfoutput>
		</cfsavecontent>

		<cfset Local.return.searchfilters = {}>
		<cfif val(arguments.specificCase) eq 0 AND val(arguments.aroundrow) eq 0 AND (val(procedureId) or ListLen(arguments.procedureId) GT 1 OR val(accountDoctorId) or val(bodyPartId) or val(genderId) or val(skinToneId) or val(afterPhotosTakenId) or val(breastStartingSizeId) or val(breastEndingSizeId) or val(TypeOfImplantId) or val(ImplantPlacementId) or val(PointOfEntryId))>
			<cfset allowUnion = false>
			<cfquery datasource="#get("datasourceName")#" name="Local.searchfilters">
				<cfif ListLen(arguments.procedureId) GT 1>
					<cfset allowUnion = true>
					SELECT
						name,
						"procedure" AS type
					FROM procedures
					WHERE id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.procedureId#">)
							AND deletedAt IS NULL
				<cfelseif val(procedureId)>
					<cfset allowUnion = true>
					SELECT
						name,
						"procedure" AS type
					FROM procedures
					WHERE id = #val(procedureId)# AND deletedAt IS NULL
				</cfif>
				<cfif val(accountDoctorId)>
					<!--- Had to put a redundant check because allowUnion was losing its value for some reason --->
					<cfif allowUnion OR ListLen(arguments.procedureId) GT 1 OR val(procedureId)>
						UNION
					</cfif>
					<cfset allowUnion = true>
					SELECT
						CONCAT(firstName, IF(middleName<>'',CONCAT(' ',middleName),''), ' ', lastName, IF(title<>'',CONCAT(', ',title),'')) AS name,
						"doctor" AS type
					FROM accountdoctors
					WHERE id = #val(accountDoctorId)#
				</cfif>
				<cfif val(bodyPartId)>
					<cfif allowUnion OR val(accountDoctorId) OR val(procedureId) OR ListLen(arguments.procedureId) GT 1>
						UNION
					</cfif>
					<cfset allowUnion = true>
					SELECT
						name,
						"bodypart" AS type
					FROM bodyparts
					WHERE id = #val(bodyPartId)#
				</cfif>
				<cfif val(genderId)>
					<cfif allowUnion>
						UNION
					</cfif>
					<cfset allowUnion = true>
					SELECT
						name,
						"gender" AS type
					FROM gallerygenders
					WHERE id = #val(genderId)#
				</cfif>
				<cfif val(skinToneId)>
					<cfif allowUnion>
						UNION
					</cfif>
					<cfset allowUnion = true>
					SELECT
						name,
						"skintone" AS type
					FROM galleryskintones
					WHERE id = #val(skinToneId)#
				</cfif>
				<cfif val(afterPhotosTakenId)>
					<cfif allowUnion>
						UNION
					</cfif>
					<cfset allowUnion = true>
					SELECT
						name,
						"afterphotostaken" AS type
					FROM galleryafterphotostaken
					WHERE id = #val(afterPhotosTakenId)#
				</cfif>
				<cfif val(breastStartingSizeId)>
					<cfif allowUnion>
						UNION
					</cfif>
					<cfset allowUnion = true>
					SELECT
						name,
						"breast_size_start" AS type
					FROM gallerybreastsizes
					WHERE id = #val(breastStartingSizeId)#
				</cfif>
				<cfif val(breastEndingSizeId)>
					<cfif allowUnion>
						UNION
					</cfif>
					<cfset allowUnion = true>
					SELECT
						name,
						"breast_size_end" AS type
					FROM gallerybreastsizes
					WHERE id = #val(breastEndingSizeId)#
				</cfif>
				<cfif val(TypeOfImplantId)>
					<cfif allowUnion>
						UNION
					</cfif>
					<cfset allowUnion = true>
					SELECT
						name,
						"implant_type" AS type
					FROM gallerytypeofimplants
					WHERE id = #val(TypeOfImplantId)#
				</cfif>
				<cfif val(ImplantPlacementId)>
					<cfif allowUnion>
						UNION
					</cfif>
					<cfset allowUnion = true>
					SELECT
						name,
						"implant_placement" AS type
					FROM galleryimplantplacements
					WHERE id = #val(ImplantPlacementId)#
				</cfif>
				<cfif val(PointOfEntryId)>
					<cfif allowUnion>
						UNION
					</cfif>
					<cfset allowUnion = true>
					SELECT
						name,
						"point_of_entry" AS type
					FROM gallerypointofentries
					WHERE id = #val(PointOfEntryId)#
				</cfif>
			</cfquery>
			<cfloop query="Local.searchfilters">
				<cfset Local.return.searchfilters[type] = name>
			</cfloop>
		</cfif>

		<cfset arguments.location.zipcode = REReplace(arguments.location.zipcode,"[^0-9a-zA-Z]","","all")>
		<cfif arguments.location.zipfound and len(arguments.location.zipcode)>
			<cfif val(arguments.distance) OR arguments.location.country EQ 12>
				<cfif arguments.location.country EQ 12 AND val(arguments.distance) EQ 0>
					<cfset arguments.distance = 100>
				</cfif>

				<cfset Local.Distance	= arguments.distance/3958.754*180/Pi()>
				<cfset Local.LatMin		= arguments.location.latitude - Local.Distance>
				<cfset Local.LatMax		= arguments.location.latitude + Local.Distance>
				<cfset Local.LonMin		= arguments.location.longitude - Local.Distance>
				<cfset Local.LonMax		= arguments.location.longitude + Local.Distance>
				<cfset Local.whereClause= Local.whereClause & " AND (g.latitude BETWEEN #Local.LatMin# AND #Local.LatMax#)">
				<cfset Local.whereClauseOptimized= Local.whereClauseOptimized & " AND (g.latitude BETWEEN #Local.LatMin# AND #Local.LatMax#)">

				<cfset Local.whereClause= Local.whereClause & " AND (g.longitude BETWEEN #Local.LonMin# AND #Local.LonMax#)">
				<cfset Local.whereClauseOptimized= Local.whereClauseOptimized & " AND (g.longitude BETWEEN #Local.LonMin# AND #Local.LonMax#)">
			<cfelseif arguments.location.country EQ 12 AND val(arguments.location.city) GT 0 AND val(arguments.location.state) GT 0>
				<cfset Local.whereClause= Local.whereClause & " AND g.stateId = #arguments.location.state# AND g.cityId = #arguments.location.city#">
				<cfset Local.whereClauseOptimized= Local.whereClauseOptimized & " AND g.stateId = #arguments.location.state# AND g.cityId = #arguments.location.city#">
			<cfelse>
				<cfset Local.whereClause= Local.whereClause & " AND g.postalCode = '#arguments.location.zipcode#'">
				<cfset Local.whereClauseOptimized= Local.whereClauseOptimized & " AND g.postalCode = '#arguments.location.zipcode#'">
			</cfif>
		<cfelseif ArrayLen(Local.return.shape.lines)>
			<cfloop from="1" to="#ArrayLen(Local.return.shape.lines)#" index="Local.S_current">
				<cfset Local.S_next = Iif(Local.S_current eq ArrayLen(Local.return.shape.lines),1,DE(Local.S_current+1))>
				<cfset Local.whereClause= Local.whereClause & " AND ((#Local.return.shape.lines[Local.S_next].x - Local.return.shape.lines[Local.S_current].x#)*(g.latitude - #Local.return.shape.lines[Local.S_current].y#) - (#Local.return.shape.lines[Local.S_next].y - Local.return.shape.lines[Local.S_current].y#)*(g.longitude - #Local.return.shape.lines[Local.S_current].x#)) <= 0">
				<cfset Local.whereClauseOptimized= Local.whereClauseOptimized & " AND ((#Local.return.shape.lines[Local.S_next].x - Local.return.shape.lines[Local.S_current].x#)*(g.latitude - #Local.return.shape.lines[Local.S_current].y#) - (#Local.return.shape.lines[Local.S_next].y - Local.return.shape.lines[Local.S_current].y#)*(g.longitude - #Local.return.shape.lines[Local.S_current].x#)) <= 0">
			</cfloop>
		<cfelse>
			<cfif val(arguments.location.state) AND arguments.location.stateFound>
				<cfset Local.whereClause= Local.whereClause & " AND g.stateId = #arguments.location.state#">
				<cfset Local.whereClauseOptimized= Local.whereClauseOptimized & " AND g.stateId = #arguments.location.state#">
			</cfif>
			<cfif val(arguments.location.city) AND arguments.location.cityFound>
				<cfset Local.whereClause= Local.whereClause & " AND g.cityId = #arguments.location.city#">
				<cfset Local.whereClauseOptimized= Local.whereClauseOptimized & " AND g.cityId = #arguments.location.city#">
			</cfif>
		</cfif>

		<cfsaveContent variable="local.CasesSelect">
			<cfoutput>
				<cfif Local.qPostalCode.recordCount GT 0>
					<CFSET Local.DistanceAlg="SQRT(POW(69.1*((if(g.latitude IS NOT NULL AND g.latitude > 0, g.latitude, #Local.qPostalCode.latitude#))-#Local.qPostalCode.latitude#),2)+POW(69.1*((if(g.longitude IS NOT NULL AND g.longitude < 0, g.longitude, #Local.qPostalCode.longitude#))-#Local.qPostalCode.longitude#)*cos(#Local.qPostalCode.latitude#/57.3),2))">
					#Local.DistanceAlg# AS EstDistance,
				</cfif>
				g.galleryCaseId, g.galleryGenderId,	g.galleryGenderName, g.gallerySkinToneId, g.gallerySkinToneName, g.galleryAfterPhotosTakenId,
				g.galleryAfterPhotosTakenName, g.galleryBreastStartingSizeId, g.galleryBreastStartingSizeName, g.galleryBreastEndingSizeId,
				g.galleryBreastEndingSizeName, g.galleryTypeOfImplantId, g.galleryTypeOfImplantName, g.galleryImplantPlacementId,
				g.galleryImplantPlacementName, g.galleryPointOfEntryId, g.galleryPointOfEntryName, g.title, g.performedBy,
				g.height, g.weight, g.age, g.doctorsFullName, g.accountDoctorId, g.isPastAdvertiser,
				g.state, g.stateAbbreviation, g.city, g.isExplicit, g.updatedAt
			</cfoutput>
		</cfsaveContent>
		<cfsaveContent variable="local.CasesSelectOuter">
			#local.CasesSelect#, g.procedureIds, g.procedureName AS procedureNames, g.procedureSiloName AS procedureSiloNames, g.galleryCaseAngleId AS galleryCaseAngleIds,
			(SELECT description FROM gallerycases WHERE id = g.galleryCaseId) as description,
			(SELECT phone FROM accountproductspurchasedsummaryall where accountDoctorId = g.accountDoctorId LIMIT 1) as phone,
			(SELECT siloName FROM accountdoctorsilonames where accountDoctorId = g.accountDoctorId AND isActive = 1 AND deletedAt IS NULL LIMIT 1) as doctorSiloName,
			(SELECT group_concat(DISTINCT bodyparts.name) FROM gallerycasebodyparts JOIN bodyparts ON gallerycasebodyparts.bodypartid = bodyparts.id WHERE gallerycasebodyparts.gallerycaseid = g.gallerycaseid) as bodyPartList
		</cfsaveContent>
		<cfsaveContent variable="local.CasesSelectInner">
			#local.CasesSelect#, cast(group_concat(DISTINCT g.procedureId) AS char) AS procedureIds, g.primaryProcedureName AS procedureName, g.primaryProcedureSiloName AS procedureSiloName, g.galleryCaseAngleId
		</cfsaveContent>

		<cfif onePerDoctor>
			<cfquery datasource="#get("datasourceName")#" name="Local.casesGalleryDoctorIds" >
				SELECT cast(group_concat(DISTINCT concat('(', g.galleryCaseId, ',', g.accountDoctorId,')')) AS char) AS maxGalleryIdsDoctorIds
				FROM
					(SELECT <!--- max(g.galleryCaseId) AS maxGalleryCaseId, --->
						max(g.updatedAt) as lastUpdated, g.accountDoctorId
						FROM gallerysummaryall g
						WHERE 1 #PreserveSingleQuotes(Local.whereClauseOptimized)#
						GROUP BY g.accountDoctorId
					) data
				JOIN gallerysummaryall g ON g.accountDoctorId = data.accountDoctorId AND g.updatedAt = data.lastUpdated;
			</cfquery>
		</cfif>

		<cfquery datasource="#get("datasourceName")#" name="Local.cases">

			<cfif val(arguments.specificCase) eq 0>
				SELECT SQL_CALC_FOUND_ROWS #local.CasesSelectOuter#
			<cfelse>
				SELECT FIND_IN_SET(<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.specificCase)#">,GROUP_CONCAT(galleryCaseId)) as RowNumber FROM(
				SELECT g.galleryCaseId
			</cfif>
			FROM
				(
					<cfif onePerDoctor>
						SELECT
							1 AS thisOrder, #local.CasesSelectInner#
						FROM
							<cfif onePerDoctor>
								gallerysummaryall g
								WHERE (g.galleryCaseId, g.accountDoctorId) IN
									<cfif ListLen(Local.casesGalleryDoctorIds.maxGalleryIdsDoctorIds)>
										(#Local.casesGalleryDoctorIds.maxGalleryIdsDoctorIds#)
									<cfelse>
										((NULL, NULL))
									</cfif>
									#PreserveSingleQuotes(Local.whereClauseOptimized)#
							<cfelse>
								gallerysummaryall g
								WHERE 1 #PreserveSingleQuotes(Local.whereClauseOptimized)#
							</cfif>
						<cfif onePerDoctor>
							GROUP BY g.galleryCaseId desc
						<cfelse>
							GROUP BY g.galleryCaseId<!--- #arguments.sortby# --->
							ORDER BY 	<cfif arguments.PracticeRanked>
										<cfif ListLen(arguments.procedureId) GT 1>
											FIELD(g.procedureId, <cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.procedureId#">),
										</cfif>
										g.practiceRankScore DESC,
									</cfif>
								#arguments.sortby#
						</cfif>
					UNION ALL
					</cfif>

					SELECT 2 AS thisOrder, #local.CasesSelectInner#
					FROM
						<cfif onePerDoctor>
							gallerysummaryall g
							WHERE (g.galleryCaseId, g.accountDoctorId) NOT IN
									<cfif ListLen(Local.casesGalleryDoctorIds.maxGalleryIdsDoctorIds)>
										(#Local.casesGalleryDoctorIds.maxGalleryIdsDoctorIds#)
									<cfelse>
										((NULL, NULL))
									</cfif>
									#PreserveSingleQuotes(Local.whereClauseOptimized)#
						<cfelse>
							gallerysummaryall g
							WHERE 1 #PreserveSingleQuotes(Local.whereClauseOptimized)#
						</cfif>
					<cfif onePerDoctor>
						GROUP BY g.galleryCaseId desc
						<!--- ORDER BY rand(#client.CFToken##client.cfid#) --->
					<cfelse>
						GROUP BY g.galleryCaseId<!--- #arguments.sortby# --->
						ORDER BY 	<cfif arguments.PracticeRanked>
									<cfif ListLen(arguments.procedureId) GT 1>
										FIELD(g.procedureId, <cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.procedureId#">),
									</cfif>
									g.practiceRankScore DESC,
								</cfif>
							#arguments.sortby#<!--- , rand(#client.CFToken##client.cfid#) --->
					</cfif>
				) g
			ORDER BY thisOrder, #arguments.sortby#
			<cfif val(arguments.specificCase) eq 0>
				LIMIT #Local.offset#, #Local.limit#
			<cfelse>
				) idList;
			</cfif>
		</cfquery>

		<cfif val(arguments.specificCase) neq 0>
			<cfreturn {rowNumber = Local.cases.rowNumber}>
		</cfif>

		<cfquery datasource="#get("datasourceName")#" name="Local.caseStats">
			SELECT Found_Rows() AS TotalRecords
		</cfquery>

		<cfif not val(Local.caseStats.TotalRecords)>
			<!--- not exactly sure what i was gonan do here --->
		</cfif>

		<!--- ***************  START FILTERS *********** --->
		<cfif arguments.filtersOn>
			<cfset Local.queryFilters = GetQueryFilters(Local.whereClauseOptimized)>

			<cfloop query="Local.queryFilters">
				<cfset arrayAppend(Local.return.filters[Local.queryFilters.RecordName], "#Local.queryFilters.name#|#Local.queryFilters.id#|#Local.queryFilters.cnt#")>
			</cfloop>

			<cfset arraySort(Local.return.filters.doctors,			"textnocase")>
			<cfset arraySort(Local.return.filters.genders,			"textnocase")>
			<cfset arraySort(Local.return.filters.implanttypes,		"textnocase")>
			<cfset arraySort(Local.return.filters.implantplacements,"textnocase")>
			<cfset arraySort(Local.return.filters.entrypoints,		"textnocase")>
			<cfset arraySort(Local.return.filters.procedures,		"textnocase")>
			<cfset arraySort(Local.return.filters.bodyParts,		"textnocase")>

			<cfset thisQuery = Local.queryFilters>
			<cfquery dbtype="query" name="Local.procedures">
				SELECT id as procedureId
				FROM thisQuery
		 		WHERE RecordName = 'procedures'
				ORDER BY name
			</cfquery>

			<cfset procedureIds = ValueList(Local.procedures.procedureId)>

			<cfif len(procedureIds)>
				<cfloop list="#procedureIds#" index="Local.GC_ProcedureIndex">
					<cfif structKeyExists(Local.filters.procedures,Local.GC_ProcedureIndex)>
						<cfset Local.filters.procedures[Local.GC_ProcedureIndex][2]++>
					<cfelse>
						<cfif structKeyExists(Local.procedures,Local.GC_ProcedureIndex)>
							<cfset Local.filters.procedures[Local.GC_ProcedureIndex] = [Local.procedures[Local.GC_ProcedureIndex],1]>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>

			<cfquery dbtype="query" name="Local.bodyParts">
				SELECT id as bodyPartId
				FROM thisQuery
		 		WHERE RecordName = 'bodyParts'
				ORDER BY name
			</cfquery>

			<cfset bodyPartIds = ValueList(Local.bodyParts.bodyPartId)>

			<cfif len(bodyPartIds)>
				<cfloop list="#bodyPartIds#" index="Local.GC_BPIndex">
					<cfif structKeyExists(Local.filters.bodyparts,Local.GC_BPIndex)>
						<cfset Local.filters.bodyparts[Local.GC_BPIndex][2]++>
					<cfelse>
						<cfif structKeyExists(Local.bodyparts,Local.GC_BPIndex)>
							<cfset Local.filters.bodyparts[Local.GC_BPIndex] = [Local.bodyparts[Local.GC_BPIndex],1]>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>

			<cfquery dbtype="query" name="Local.doctors">
				SELECT id as doctorId
				FROM thisQuery
		 		WHERE RecordName = 'doctors'
				ORDER BY name
			</cfquery>

			<cfset doctorIds = ValueList(Local.doctors.doctorId)>

			<cfif len(doctorIds)>
				<cfloop list="#doctorIds#" index="Local.GC_DoctorIndex">
					<cfif structKeyExists(Local.filters.doctors,Local.GC_DoctorIndex)>
						<cfset Local.filters.doctors[Local.GC_DoctorIndex][2]++>
					<cfelse>
						<cfif structKeyExists(Local.doctors,Local.GC_DoctorIndex)>
							<cfset Local.filters.doctors[Local.GC_DoctorIndex] = [Local.doctors[Local.GC_DoctorIndex],1]>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		<!--- End filter Check --->

		<cfset Local.return.totalrecords= Local.caseStats.TotalRecords>
		<cfset Local.return.results		= Local.cases>
		<cfset Local.return.pages		= ceiling(Local.return.totalrecords/Local.return.perpage)>

		<cfreturn Local.return>
	</cffunction>

	<cffunction name="GetQueryFilters" returntype="query" access="private">
		<cfargument name="whereClause">

		<cfset var Local = {}>

		<cfset arguments.whereClause = "WHERE 1 " & arguments.whereClause>

		<cfquery datasource="#get("datasourceName")#" name="Local.queryFilters">
			SELECT
				CAST(filters.id AS CHAR) AS id,
				CAST(filters.name AS CHAR) AS name,
				cnt,
				CAST(filters.RecordName AS CHAR) AS RecordName
			FROM (

				(SELECT g.accountDoctorId AS id, g.doctorsFullName AS name,	COUNT(distinct(g.galleryCaseId)) AS cnt, "doctors" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.accountDoctorId IS NOT NULL
				GROUP BY g.accountDoctorId
				ORDER BY g.doctorsFullName)

				UNION

				(SELECT g.procedureId AS id, g.procedureName AS name, COUNT(distinct(g.galleryCaseId)) AS cnt, "procedures" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.procedureId IS NOT NULL
				GROUP BY g.procedureId
				ORDER BY g.procedureName)

				UNION

				(SELECT g.bodyPartId AS id, g.bodyPartName AS name, COUNT(distinct(g.galleryCaseId)) AS cnt, "bodyparts" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.bodyPartId IS NOT NULL
				GROUP BY g.bodyPartId
				ORDER BY g.bodyPartName)

				UNION

				(SELECT g.galleryGenderId AS id, g.galleryGenderName AS name, COUNT(distinct(g.galleryCaseId)) AS cnt, "genders" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.galleryGenderId IS NOT NULL
				GROUP BY g.galleryGenderId
				ORDER BY g.galleryGenderName)

				UNION

				(SELECT g.gallerySkinToneId AS id, g.gallerySkinToneName AS name, COUNT(distinct(g.galleryCaseId)) AS cnt, "skintones" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.gallerySkinToneId IS NOT NULL
				GROUP BY g.gallerySkinToneId
				ORDER BY g.gallerySkinToneNameName)

				UNION

				(SELECT g.galleryAfterPhotosTakenId AS id, g.galleryAfterPhotosTakenName AS name, COUNT(distinct(g.galleryCaseId)) AS cnt, "apts" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.galleryAfterPhotosTakenId IS NOT NULL
				GROUP BY g.galleryAfterPhotosTakenId
				ORDER BY g.galleryAfterPhotosTakenName)

				UNION

				(SELECT g.galleryBreastStartingSizeId AS id, g.galleryBreastStartingSizeName AS name, COUNT(distinct(g.galleryCaseId)) AS cnt, "startingbreastsizes" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.galleryBreastStartingSizeId IS NOT NULL
				GROUP BY g.galleryBreastStartingSizeId
				ORDER BY g.galleryBreastStartingSizeName)

				UNION

				(SELECT g.galleryBreastEndingSizeId AS id, g.galleryBreastEndingSizeName AS name, COUNT(distinct(g.galleryCaseId)) AS cnt, "endingbreastsizes" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.galleryBreastEndingSizeId IS NOT NULL
				GROUP BY g.galleryBreastEndingSizeId
				ORDER BY g.galleryBreastEndingSizeName)

				UNION

				(SELECT g.galleryTypeOfImplantId AS id, g.galleryTypeOfImplantName AS name, COUNT(distinct(g.galleryCaseId)) AS cnt, "implanttypes" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.galleryTypeOfImplantId IS NOT NULL
				GROUP BY g.galleryTypeOfImplantId
				ORDER BY g.galleryTypeOfImplantName)

				UNION

				(SELECT g.galleryImplantPlacementId AS id, g.galleryImplantPlacementName AS name, COUNT(distinct(g.galleryCaseId)) AS cnt, "implantplacements" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.galleryImplantPlacementId IS NOT NULL
				GROUP BY g.galleryImplantPlacementId
				ORDER BY g.galleryImplantPlacementName)

				UNION

				(SELECT g.galleryPointOfEntryId AS id, g.galleryPointOfEntryName AS name, COUNT(distinct(g.galleryCaseId)) AS cnt, "entrypoints" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.galleryPointOfEntryId IS NOT NULL
				GROUP BY g.galleryPointOfEntryId
				ORDER BY g.galleryPointOfEntryName)

				UNION

				(SELECT g.height AS id, g.height AS name, COUNT(distinct(g.galleryCaseId)) AS cnt, "heights" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.height IS NOT NULL
				GROUP BY g.height)

				UNION

				(SELECT g.weight AS id, g.weight AS name, COUNT(distinct(g.galleryCaseId)) AS cnt, "weights" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.weight IS NOT NULL
				GROUP BY g.weight)

				UNION

				(SELECT g.age AS id, g.age AS name, COUNT(distinct(g.galleryCaseId)) AS cnt, "ages" AS RecordName
				FROM gallerysummaryall g
				#PreserveSingleQuotes(arguments.whereClause)#
				AND g.age IS NOT NULL
				GROUP BY g.age)

			) AS filters
			</cfquery>

		<cfreturn Local.queryFilters>
	</cffunction>

	<cffunction name="queryPage" access="private" returntype="query">
		<cfargument name="query" type="query" required="yes">
		<cfargument name="row"	type="numeric" default="0">
		<cfargument name="count" type="numeric" default="#(query.recordcount-row)#">
		<cfset row = max(0,row-1)>

		<cfif query.recordcount gte row+count>
			<cfset start = row+count>
			<cfset query.RemoveRows(start,query.recordcount-start)>
		</cfif>
		<cfif row gt 0>
			<cfset query.RemoveRows(0,max(row,0))>
		</cfif>

		<cfreturn query>
	</cffunction>

	<cffunction name="getPracticeRankedGallery" returntype="query">
		<cfargument name="limit" type="numeric" default="4">
		<cfargument name="censored" type="boolean" required="false" default="false">
		<cfargument name="specialty" type="numeric" default="0">
		<cfargument name="procedure" type="numeric" default="0">
		<cfargument name="statewide" type="boolean" required="false" default="false">

		<cfif ((not isDefined("client.city")) or (not isDefined("client.state")))>
			<cfset setUserLocation()>
		</cfif>
		<cfif val(client.city) eq 0 or val(client.state) eq 0>
			<cfset setUserLocation()>
		</cfif>

		<cfquery datasource="#get('dataSourceName')#" name="Zone">
			SELECT zone
			FROM postalcodes
			WHERE cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.city#">
			AND stateId = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.state#">
			<cfif arguments.statewide>
				AND 1=0
			</cfif>
			LIMIT 1;
		</cfquery>

		<cfquery datasource="#get('datasourceName')#" name="carouselContent">
			SELECT DISTINCT gc.id,gc.id as galleryCaseId,procedures.siloName,procedures.name,firstname,middlename,lastname,
				gca.id as galleryCaseAngleId,accountdoctors.title,dataB.accountdoctorid, dataB.siloName as doctorSiloName, dataB.practiceRank,
				"#Zone.zone#" AS zoneId, "#client.state#" AS zoneStateId, dataB.city, dataB.state <!--- For carousel tracking --->
			FROM gallerycases gc
			JOIN gallerycaseangles gca ON gc.id = gca.galleryCaseId
			JOIN gallerycasedoctors gcd ON gc.id = gcd.galleryCaseId
			JOIN (SELECT dataA.accountDoctorId, dataA.siloName, dataA.PracticeRank, MAX(gc2.createdAt) latesttime, dataA.city, dataA.state
				FROM
				(SELECT adl.accountdoctorid, adsn.siloName,  MAX(appdl.practiceRankScore) as PracticeRank, cities.name AS city, states.name AS state
					FROM accountproductspurchaseddoctorlocations appdl
					JOIN accountproductspurchased app on appdl.accountproductspurchasedid = app.id
					JOIN accountdoctorlocations adl on appdl.accountdoctorlocationid = adl.id
					JOIN accountdoctorlocationspecialtyproductzones adlspz on adlspz.accountDoctorLocationId = adl.id
					JOIN accountdoctorsilonames adsn on adl.accountDoctorId = adsn.accountDoctorId AND adsn.isActive = 1 AND adsn.deletedAt IS NULL
					INNER JOIN accountlocations al ON al.id = adl.accountLocationid AND al.deletedAt IS NULL
					INNER JOIN cities ON cities.id = al.cityId
					INNER JOIN states ON states.id = cities.stateId
					WHERE now() <= app.dateEnd
						<cfif isnumeric(Zone.zone) AND val(zone.zone) GT 0>
						AND adlspz.zoneId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(Zone.zone)#">
						</cfif>
						AND adlspz.stateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.state#">
						AND appdl.deletedAt IS NULL
						AND app.deletedAt IS NULL
						AND adl.deletedAt IS NULL
						AND adlspz.deletedAt IS NULL
					GROUP BY adl.accountdoctorid
					ORDER BY PracticeRank DESC) dataA
				JOIN gallerycasedoctors gcd2 ON dataA.accountDoctorId = gcd2.accountDoctorId
				JOIN gallerycases gc2 ON gc2.id = gcd2.galleryCaseId
				<cfif arguments.procedure gt 0 or arguments.specialty gt 0 or arguments.censored>
					JOIN gallerycaseprocedures gcp2 ON gc2.id = gcp2.galleryCaseId
					JOIN procedures p2 ON gcp2.procedureId = p2.id
					<cfif arguments.specialty gt 0>
						JOIN specialtyprocedures sp2 ON p2.id = sp2.procedureId
					</cfif>
				</cfif>
				WHERE gcd2.deletedAt IS NULL
					AND gc2.deletedAt IS NULL
					<cfif arguments.procedure gt 0>
						AND gcp2.procedureId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.procedure#">
					</cfif>
					<cfif arguments.specialty gt 0>
						AND sp2.specialtyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.specialty#">
					</cfif>
					<cfif arguments.censored>
						AND p2.isExplicit = 0
					</cfif>
			   GROUP BY dataA.accountDoctorId, dataA.PracticeRank) dataB
				on gcd.accountDoctorId = dataB.accountDoctorId AND gc.createdAt = dataB.latesttime
			JOIN gallerycaseprocedures ON gc.id = gallerycaseprocedures.galleryCaseId
			JOIN procedures ON gallerycaseprocedures.procedureId = procedures.id
								<cfif arguments.censored>
									AND procedures.isExplicit = 0
								</cfif>
			JOIN accountdoctors ON gcd.accountDoctorId = accountdoctors.id
			WHERE gallerycaseprocedures.deletedAt IS NULL
				AND procedures.deletedAt IS NULL
				AND accountdoctors.deletedAt IS NULL
			GROUP BY gc.id
			ORDER BY PracticeRank DESC
			LIMIT #val(arguments.limit)#;
		</cfquery>

		<cfif carouselContent.recordcount lt 2 AND not arguments.statewide>
			<cfset carouselContent = getPracticeRankedGallery(
				limit = arguments.limit,
				censored = arguments.censored,
				specialty = arguments.specialty,
				procedure = arguments.procedure,
				statewide = true
			)>
		</cfif>

		<cfreturn carouselContent>
	</cffunction>

	<!--- Determine if a location will return any results --->
	<cffunction name="testLocation" returntype="numeric">
		<cfargument name="country"		type="numeric" 	required="false" default="0">
		<cfargument name="zipCode"		type="string"	required="false" default="">
		<cfargument name="city"			type="numeric"	required="false" default="0">
		<cfargument name="state"		type="numeric"	required="false" default="0">
		<cfargument name="doctor"		type="numeric"	required="false" default="0">
		<cfargument name="procedureId"	type="numeric"	required="false" default="0">
		<cfargument name="genderId"		type="numeric"	required="false" default="0">
		<cfargument name="ageStart"		type="numeric"	required="false" default="0">
		<cfargument name="ageEnd"		type="numeric"	required="false" default="0">
		<cfargument name="heightStart"	type="numeric"	required="false" default="0">
		<cfargument name="heightEnd"	type="numeric"	required="false" default="0">
		<cfargument name="weightStart"	type="numeric"	required="false" default="0">
		<cfargument name="weightEnd"	type="numeric"	required="false" default="0">

		<cfset determinedDistance = 0>

		<!--- Determine if current criteria will return any results --->
		<cfquery datasource="#get('dataSourceName')#" name="SearchTest">
			SELECT COUNT(1) as doctorcount
			FROM gallerysummaryall g
			WHERE 1=1
			<cfif city neq 0>
				AND g.cityId = <cfqueryparam cfsqltype="cf_sql_integer" value="#city#">
			</cfif>
			<cfif state neq 0>
				AND g.stateId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#state#">
			</cfif>
			<cfif zipCode neq "">
				AND g.postalCode LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#zipCode#">
			</cfif>
			<cfif doctor neq 0>
				AND g.accountDoctorId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#doctor#">
			</cfif>
			<cfif procedureId neq 0>
				AND g.procedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
			</cfif>
			<cfif genderId neq 0>
				AND g.galleryGenderId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.genderId#">
			</cfif>
			<cfif ageStart neq 0>
				AND g.age >= <cfqueryparam cfsqltype="cf_sql_integer" value="#max(0,val(arguments.ageStart))#">
			</cfif>
			<cfif ageEnd neq 0>
				AND g.age <= <cfqueryparam cfsqltype="cf_sql_integer" value="#min(120,val(arguments.ageEnd))#">
			</cfif>
			<cfif heightStart neq 0>
				AND g.height >= <cfqueryparam cfsqltype="cf_sql_integer" value="#max(0,val(arguments.heightStart))#">
			</cfif>
			<cfif heightEnd neq 0>
				AND g.height <= <cfqueryparam cfsqltype="cf_sql_integer" value="#min(120,val(arguments.heightEnd))#">
			</cfif>
			<cfif weightStart neq 0>
				AND g.weight >= <cfqueryparam cfsqltype="cf_sql_integer" value="#max(0,val(arguments.weightStart))#">
			</cfif>
			<cfif weightEnd neq 0>
				AND g.weight <= <cfqueryparam cfsqltype="cf_sql_integer" value="#min(120,val(arguments.weightEnd))#">
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
					SELECT min(sqrt(POW((69.1*(g.latitude-(#GetCoordinates.latitude#))),2)
						+POW(69.1*(g.longitude-(#GetCoordinates.longitude#))
						*cos((#GetCoordinates.latitude#)/57.3),2))) as distance
					FROM gallerysummaryall g
					WHERE 1=1
					<cfif doctor neq 0>
						AND g.accountDoctorId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#doctor#">
					</cfif>
					<cfif procedureId neq 0>
						AND g.procedureId = <cfqueryparam cfsqltype="cf_sql_smallint" value="#procedureId#">
					</cfif>
					<cfif genderId neq 0>
						AND g.galleryGenderId = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.genderId#">
					</cfif>
					<cfif ageStart neq 0>
						AND g.age >= <cfqueryparam cfsqltype="cf_sql_integer" value="#max(0,val(arguments.ageStart))#">
					</cfif>
					<cfif ageEnd neq 0>
						AND g.age <= <cfqueryparam cfsqltype="cf_sql_integer" value="#min(120,val(arguments.ageEnd))#">
					</cfif>
					<cfif heightStart neq 0>
						AND g.height >= <cfqueryparam cfsqltype="cf_sql_integer" value="#max(0,val(arguments.heightStart))#">
					</cfif>
					<cfif heightEnd neq 0>
						AND g.height <= <cfqueryparam cfsqltype="cf_sql_integer" value="#min(120,val(arguments.heightEnd))#">
					</cfif>
					<cfif weightStart neq 0>
						AND g.weight >= <cfqueryparam cfsqltype="cf_sql_integer" value="#max(0,val(arguments.weightStart))#">
					</cfif>
					<cfif weightEnd neq 0>
						AND g.weight <= <cfqueryparam cfsqltype="cf_sql_integer" value="#min(120,val(arguments.weightEnd))#">
					</cfif>
				</cfquery>
				<cfset determinedDistance = Ceiling(val(GetNearest.distance)/10) * 10>
			</cfif>
		</cfif>
		<cfreturn determinedDistance>
	</cffunction>

	<cffunction name="GetGalleryCaseAngles" returntype="query">
		<cfargument name="galleryCaseId" required="true" type="numeric">

		<cfset var qGalleryCaseAngles = "">

		<cfquery datasource="#get("datasourceName")#" name="qGalleryCaseAngles">
			SELECT gallerycases.id,gallerycases.galleryGenderId,gallerycases.gallerySkinToneId,gallerycases.galleryAfterPhotosTakenId,gallerycases.galleryBreastStartingSizeId,gallerycases.galleryBreastEndingSizeId,gallerycases.galleryTypeOfImplantId,gallerycases.galleryImplantPlacementId,gallerycases.galleryPointOfEntryId,gallerycases.title,gallerycases.description,gallerycases.performedBy,gallerycases.height,gallerycases.weight,gallerycases.age,gallerycases.showLad,gallerycases.showWebsiteDock,gallerycases.isFeatured,
					gallerycases.pageTitle, gallerycases.pageMetaDescription, gallerycases.pageMetaKeywords, gallerycases.pageH1,
					gallerycaseangles.id AS galleryCaseAngleid,gallerycaseangles.galleryCaseId AS galleryCaseAnglegalleryCaseId,gallerycaseangles.description AS galleryCaseAngledescription,gallerycaseangles.orderNumber AS galleryCaseAngleorderNumber,gallerycaseangles.beforeX AS galleryCaseAnglebeforeX,gallerycaseangles.beforeY AS galleryCaseAnglebeforeY,gallerycaseangles.beforeZ AS galleryCaseAnglebeforeZ,gallerycaseangles.afterX AS galleryCaseAngleafterX,gallerycaseangles.afterY AS galleryCaseAngleafterY,gallerycaseangles.afterZ AS galleryCaseAngleafterZ,gallerycaseangles.beforeThumbX AS galleryCaseAnglebeforeThumbX,gallerycaseangles.beforeThumbY AS galleryCaseAnglebeforeThumbY,gallerycaseangles.beforeThumbZ AS galleryCaseAnglebeforeThumbZ,gallerycaseangles.afterThumbX AS galleryCaseAngleafterThumbX,gallerycaseangles.afterThumbY AS galleryCaseAngleafterThumbY,gallerycaseangles.afterThumbZ AS galleryCaseAngleafterThumbZ,
					gallerycaseangles.beforeTopPixel, gallerycaseangles.beforeLeftCoords,
					gallerycaseangles.afterTopPixel, gallerycaseangles.afterLeftCoords,
					gallerycaseprocedures.galleryCaseId AS galleryCaseProceduregalleryCaseId,gallerycaseprocedures.procedureId AS galleryCaseProcedureprocedureId,gallerycaseprocedures.isPrimary AS galleryCaseProcedureisPrimary,
					gallerygenders.name AS galleryGendername,gallerygenders.short AS galleryGendershort, GROUP_CONCAT(DISTINCT bodyparts.name) as bodyPartList
			FROM gallerycases
			LEFT OUTER JOIN gallerycaseangles ON gallerycases.id = gallerycaseangles.galleryCaseId
			LEFT OUTER JOIN gallerycaseprocedures ON gallerycases.id = gallerycaseprocedures.galleryCaseId
			LEFT OUTER JOIN gallerygenders ON gallerycases.galleryGenderId = gallerygenders.id
			LEFT OUTER JOIN gallerycasebodyparts
				JOIN bodyparts ON gallerycasebodyparts.bodypartId = bodyparts.id
			ON gallerycases.id = gallerycasebodyparts.galleryCaseId
			WHERE gallerycases.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.galleryCaseId#">
			 AND gallerycases.deletedAt IS NULL AND gallerycaseangles.deletedAt IS NULL AND gallerycaseprocedures.deletedAt IS NULL AND gallerygenders.deletedAt IS NULL
			GROUP BY gallerycaseangles.id
			ORDER BY gallerycaseangles.orderNumber ASC,gallerycases.id ASC;
		</cfquery>

		<cfreturn qGalleryCaseAngles>
	</cffunction>

	<cffunction name="GetGalleryCaseProcedures" returntype="query">
		<cfargument name="galleryCaseId" required="true" type="numeric">

		<cfset var qGalleryCaseProcedures = "">

		<cfquery datasource="#get("datasourceName")#" name="qGalleryCaseProcedures">
			SELECT procedures.id, procedures.name, procedures.siloName, procedures.isExplicit
			FROM procedures
			INNER JOIN gallerycaseprocedures ON procedures.id = gallerycaseprocedures.procedureId
			WHERE gallerycaseprocedures.galleryCaseId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.galleryCaseId#">
				AND procedures.deletedAt IS NULL AND gallerycaseprocedures.deletedAt IS NULL
			ORDER BY gallerycaseprocedures.isPrimary DESC, procedures.name
		</cfquery>

		<cfreturn qGalleryCaseProcedures>
	</cffunction>

	<cffunction name="GetInactiveGalleryCaseProcedure" returntype="string">
		<cfargument name="galleryCaseId" required="true" type="numeric">

		<cfset var qGalleryCaseProcedure = "">

		<cfquery datasource="#get("datasourceName")#" name="qGalleryCaseProcedure">
			SELECT procedures.siloName
			FROM procedures
			INNER JOIN gallerycaseprocedures ON procedures.id = gallerycaseprocedures.procedureId
			WHERE gallerycaseprocedures.galleryCaseId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.galleryCaseId#">
				AND procedures.deletedAt IS NULL
			ORDER BY gallerycaseprocedures.isPrimary DESC
			LIMIT 1
		</cfquery>

		<cfreturn qGalleryCaseProcedure.siloName>
	</cffunction>

	<cffunction name="GetGalleryCaseSpecialties" returntype="query">
		<cfargument name="galleryCaseId" required="true" type="numeric">

		<cfset var qGalleryCaseSpecialties = "">

		<cfquery datasource="#get("datasourceName")#" name="qGalleryCaseSpecialties">
			SELECT s.id, s.name, s.siloName
			FROM specialties s
			JOIN specialtyprocedures sp ON s.id = sp.specialtyID
			JOIN gallerycaseprocedures gcp ON sp.procedureID = gcp.procedureID
			JOIN gallerycasedoctors gcd ON gcp.galleryCaseId = gcd.galleryCaseId
			JOIN accountdoctorlocations adl ON gcd.accountDoctorId = adl.accountDoctorId
			JOIN accountlocationspecialties als ON als.accountDoctorLocationId = adl.id AND als.specialtyId = s.id
			WHERE gcp.galleryCaseId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.galleryCaseId#">
		</cfquery>

		<cfreturn qGalleryCaseSpecialties>
	</cffunction>

	<cffunction name="GetGalleryCaseDoctorLocations" returntype="query">
		<cfargument name="galleryCaseId" required="true" type="numeric">
		<cfargument name="expired" required="false" type="boolean" default="false">

		<cfset var qGalleryCaseDoctorLocations = "">

		<cfquery datasource="#get("datasourceName")#" name="qGalleryCaseDoctorLocations">
			SELECT gallerycasedoctors.accountDoctorId, accountdoctorlocations.id AS accountDoctorLocationid,
				(CONCAT(accountdoctors.firstName, IF(accountdoctors.middleName<>'',CONCAT(' ',accountdoctors.middleName),''), ' ', accountdoctors.lastName, IF(accountdoctors.title<>'',CONCAT(', ',accountdoctors.title),''))) AS fullNameWithTitle,(CONCAT(accountdoctors.firstName, IF(accountdoctors.middleName<>'',CONCAT(' ',accountdoctors.middleName),''), ' ', accountdoctors.lastName)) AS fullName,
				<!--- cities.name,
				states.name AS statename,
				states.abbreviation as stateabbr, --->

				/* Check if a city/state was selected */
				IF(s2.id IS NOT NULL, s2.name, states.name ) AS statename,
				IF(s2.abbreviation IS NOT NULL, s2.abbreviation, states.abbreviation) AS stateabbr,
				IF(c2.name IS NOT NULL, c2.name, cities.name) AS name,
				IF(al2.id IS NOT NULL, al2.postalCode, accountlocations.postalCode) AS postalCode,

				accountpractices.name AS accountPracticename,
				accountdoctors.photoFileName,
				gallerycasedoctors.galleryCaseId,accountdoctors.id,
				accountdoctorlocations.accountLocationId,(RAND()) AS randomNumber,
				adsn.siloname AS doctorSiloName
				<cfif not arguments.expired>,accountproductspurchasedsummaryall.phone</cfif>
				FROM gallerycasedoctors
				INNER JOIN accountdoctors ON gallerycasedoctors.accountDoctorId = accountdoctors.id
				INNER JOIN accountdoctorsilonames adsn On adsn.accountDoctorId = accountdoctors.id AND adsn.isActive = 1 AND adsn.deletedAt IS NULL
				INNER JOIN accountdoctorlocations ON accountdoctors.id = accountdoctorlocations.accountDoctorId
				INNER JOIN accountlocations ON accountdoctorlocations.accountLocationId = accountlocations.id
				INNER JOIN cities ON accountlocations.cityId = cities.id
				INNER JOIN states ON accountlocations.stateId = states.id
				INNER JOIN accountpractices ON accountdoctorlocations.accountPracticeId = accountpractices.id

				/* Check an accountDoctorlocation was selected and use those city/states */
				LEFT JOIN accountdoctorlocations adl2 On adl2.id = gallerycasedoctors.accountDoctorLocationId AND adl2.deletedAt IS NULL
				LEFT JOIN accountlocations al2 ON al2.id = adl2.accountLocationId AND al2.deletedAt IS NULL
				LEFT JOIN cities c2 ON c2.id = al2.cityId
				LEFT JOIN states s2 ON s2.id = c2.stateId

				<cfif not arguments.expired>INNER JOIN accountproductspurchasedsummaryall ON accountpractices.accountId = accountproductspurchasedsummaryall.accountId</cfif>
				WHERE gallerycasedoctors.galleryCaseId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.galleryCaseId#">
					AND gallerycasedoctors.deletedAt IS NULL AND accountdoctors.deletedAt IS NULL AND accountdoctorlocations.deletedAt IS NULL AND accountlocations.deletedAt IS NULL AND cities.deletedAt IS NULL AND states.deletedAt IS NULL AND accountpractices.deletedAt IS NULL
				GROUP BY accountdoctors.id
				ORDER BY fullName
		</cfquery>

		<cfreturn qGalleryCaseDoctorLocations>
	</cffunction>

	<cffunction name="GetDoctorsImagesWithSameProcedures" returntype="query">
		<cfargument default="" name="caseId" type="numeric">

		<cfset var qDoctorsImagesWithSameProcedures = "">

		<cfquery datasource="myLocateadocLB3" name="qDoctorsImagesWithSameProcedures">
			<!--- Output deleted cases
				SELECT concat("http://www.locateadoc.com/pictures/gallery/", p.siloName, "-before-regular-", gc.id, "-", gca.id, ".jpg")
				FROM gallerycases gc
				INNER JOIN gallerycaseangles gca ON gca.galleryCaseId = gc.id
				INNER JOIN gallerycaseprocedures gcp ON gcp.galleryCaseId = gca.galleryCaseId
				INNER JOIN procedures p ON p.id = gcp.procedureId
				where gc.deletedAt IS NOT nULL

			---->
			SELECT gc2.id AS caseId, gca2.id AS angleId, p.siloName AS procedureSiloName
			FROM gallerycases gc
			INNER JOIN gallerycaseangles gca ON gca.galleryCaseId = gc.id
			INNER JOIN gallerycasedoctors gcd ON gcd.galleryCaseId = gca.galleryCaseId
			INNER JOIN gallerycaseprocedures gcp ON gcp.galleryCaseId = gcd.galleryCaseId
			INNER JOIN gallerycasedoctors gcd2 ON gcd2.accountDoctorId = gcd.accountDoctorId AND gcd2.deletedAt IS NULL
			INNER JOIN gallerycaseprocedures gcp2 ON gcp2.galleryCaseId = gcd2.galleryCaseId AND gcp2.procedureId = gcp.procedureId AND gcp2.deletedAt IS NULL
			INNER JOIN gallerycaseangles gca2 ON gca2.galleryCaseId = gcp2.galleryCaseId AND gca2.deletedAt IS NULL
			INNER JOIN gallerycases gc2 ON gc2.id = gca2.galleryCaseId AND gc2.deletedAt IS NULL AND gc2.showLad = 1
			INNER JOIN procedures p ON p.id = gcp2.procedureId AND p.deletedAt IS NULL
			WHERE gc.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.caseId#">
			GROUP BY gc2.id, gca2.id
		</cfquery>

		<cfreturn qDoctorsImagesWithSameProcedures>
	</cffunction>


	<cffunction name="GetOtherDoctorsImagesWithSameProcedures" returntype="query">
		<cfargument default="" name="caseId" type="numeric">

		<cfset var qOtherDoctorsImagesWithSameProcedures = "">

		<cfquery datasource="myLocateadocLB3" name="qOtherDoctorsImagesWithSameProcedures">
			SELECT gc2.id AS caseId, gca2.id AS angleId, p.siloName AS procedureSiloName
			FROM gallerycases gc
			INNER JOIN gallerycaseangles gca ON gca.galleryCaseId = gc.id
			INNER JOIN gallerycaseprocedures gcp ON gcp.galleryCaseId = gca.galleryCaseId
			INNER JOIN gallerycaseprocedures gcp2 ON gcp2.galleryCaseId <> gcp.galleryCaseId AND gcp2.procedureId = gcp.procedureId AND gcp2.deletedAt IS NULL
			INNER JOIN gallerycaseangles gca2 ON gca2.galleryCaseId = gcp2.galleryCaseId AND gca2.deletedAt IS NULL
			INNER JOIN gallerycases gc2 ON gc2.id = gca2.galleryCaseId AND gc2.deletedAt IS NULL AND gc2.showLad = 1
			INNER JOIN procedures p ON p.id = gcp2.procedureId AND p.deletedAt IS NULL
			WHERE gc.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.caseId#">
			GROUP BY gc2.id, gca2.id
		</cfquery>

		<cfreturn qOtherDoctorsImagesWithSameProcedures>
	</cffunction>

	<cffunction name="GetImagesProcedure" returntype="query">
		<cfargument default="" name="caseId" type="numeric">

		<cfset var qImagesProcedure = "">

		<cfquery datasource="myLocateadocLB3" name="qImagesProcedure">
			SELECT p.siloName
			FROM gallerycases gc
			INNER JOIN gallerycaseprocedures gcp ON gcp.galleryCaseId = gc.id
			INNER JOIN procedures p ON p.id = gcp.procedureId AND p.deletedAt IS NULL
			WHERE gc.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.caseId#">
		</cfquery>

		<cfreturn qImagesProcedure>
	</cffunction>
</cfcomponent>