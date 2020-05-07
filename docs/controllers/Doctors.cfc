<cfcomponent extends="Controller" output="false">

	<cfset isMobile = false>
	<cfset mobileSuffix = "">

 	<cffunction name="init">
		<cfset filters(through="recordHit",type="after",except="location")>
		<cfset usesLayout("checkLayout")>
	</cffunction>

	<cffunction name="checkLayout">
		<cfset var returnValue = true>

		<cfif Find("print-view",CGI.QUERY_STRING)>
			<!--- http://carlos3.locateadoc.com/doctors/breast-augmentation-breast-implants/orlando-fl?print-view --->
			<cfset returnValue = "/print">
		</cfif>

		<cfif Find("email-view",CGI.QUERY_STRING)>
			<!--- http://carlos3.locateadoc.com/doctors/breast-augmentation-breast-implants/orlando-fl?email-view --->
			<cfset returnValue = "/email">
		</cfif>

		<cfreturn returnValue>
	</cffunction>

	<cffunction name="index">
		<cfparam name="params.key"			default="">
		<cfparam name="params.country"		default="">
		<cfparam name="params.location"		default="">
		<cfparam name="params.distance"		default="">
		<cfparam name="params.name"			default="">
		<cfparam name="params.specialty"	default="">

		<cfset title = "Find A Local Doctor">
		<cfset metaDescriptionContent = "Find a local doctor quickly and easily with LocateADoc.com. We have 150,000+ doctors and counting!">

		<cfset Procedures = getProcedures(false)>
		<cfset ProcedureAlphas = getProcedures(true)>
		<cfset Specialties = getSpecialties()>

		<cfset quickSelect = getCities()>

		<cfset bodyParts = model("BodyRegion").findAll(
			select  = "bodyregions.id AS bodyRegionId,bodyregions.name AS bodyRegionName,
					   bodyparts.id AS bodyPartId,bodyparts.name AS bodyPartName,bodyparts.siloName,
					   xCoordinate, yCoordinate",
			include	= "bodyParts(procedureBodyParts)",
			group   = "bodyregions.id, bodyparts.id",
			order	= "bodyregions.name asc, bodyparts.name asc"
		)>

		<cfsavecontent variable="pageTitle">
			<cfoutput>
				<h1>Find a Doctor</h1>
			</cfoutput>
		</cfsavecontent>

		<!--- <cfset breadcrumbs = initBreadcrumbs()> --->
		<cfset breadcrumbs = ["&nbsp;"]>

		<!--- If we are brought back here via a modify search link, extract variables from the referring URL --->
		<cfif params.key eq "modify">
			<cfset countrySearch = REFind("country-[^/]+",CGI.HTTP_REFERER,1,true)>
			<cfif countrySearch.len[1]>
				<cfset params.country = URLDecode(Replace(Mid(CGI.HTTP_REFERER,countrySearch.pos[1],countrySearch.len[1]),"country-",""))>
			</cfif>
			<cfset locationSearch = REFind("location-[^/]+",CGI.HTTP_REFERER,1,true)>
			<cfif locationSearch.len[1]>
				<cfset params.location = URLDecode(Replace(Mid(CGI.HTTP_REFERER,locationSearch.pos[1],locationSearch.len[1]),"location-",""))>
			</cfif>
			<cfset distanceSearch = REFind("distance-[^/]+",CGI.HTTP_REFERER,1,true)>
			<cfif distanceSearch.len[1]>
				<cfset params.distance = URLDecode(Replace(Mid(CGI.HTTP_REFERER,distanceSearch.pos[1],distanceSearch.len[1]),"distance-",""))>
			</cfif>
			<cfset nameSearch = REFind("name-[^/]+",CGI.HTTP_REFERER,1,true)>
			<cfif nameSearch.len[1]>
				<cfset params.name = URLDecode(Replace(Mid(CGI.HTTP_REFERER,nameSearch.pos[1],nameSearch.len[1]),"name-",""))>
			</cfif>
			<cfset specialtySearch = REFind("specialty-[^/]+",CGI.HTTP_REFERER,1,true)>
			<cfif specialtySearch.len[1]>
				<cfset params.specialty = URLDecode(Replace(Mid(CGI.HTTP_REFERER,specialtySearch.pos[1],specialtySearch.len[1]),"specialty-",""))>
			</cfif>
		</cfif>

		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset bodyPartsMobile = model("BodyRegion").findAll(
			select  = "DISTINCT bodyregions.name AS bodyRegionName,bodyparts.name AS bodyPartName,
						procedures.name AS procedureName,procedures.id AS procedureId,procedures.siloName",
			include	= "bodyParts(procedureBodyParts(procedure(resourceGuideProcedures(resourceGuide))))",
			where = "procedures.isPrimary = 1 AND resourceguides.content is not null",
			order	= "bodyregions.name asc, bodyparts.name asc, procedures.name asc")>

			<!--- Render mobile page --->
			<cfset Request.mobileLayout = true>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="featured">
		<cfset Request.overrideDebug = "false">
		<cfset featuredListings = getFeaturedListings(includeSpecialties=true, recordHit=true)>
		<cfset renderPartial("/shared/featureddoctors")>
	</cffunction>

	<cffunction name="search">
		<cfparam name="params.silourl" default="">
		<cfparam name="params.originalFilter" default="http://#cgi.server_name & params.silourl#">
		<cfparam name="params.rewrite" default="0">
		<cfparam name="params.siloname" default="">
		<cfparam name="params.silolocation" default="">
		<cfparam name="params.distanceFound" default="false">
		<cfparam name="params.contactadoctor" default="0">
		<cfparam name="params.procedureid" default="0">
		<cfparam name="params.specialtyid" default="0">
		<cfparam name="params.perpage" default="10">
		<cfset var Local = {}>

		<cfset params.perpage = val(params.perpage)>

		<cfif params.contactadoctor>
			<cfset params.procedureid = val(params.procedureid)>
			<cfset params.specialtyid = val(params.specialtyid)>
			<cfset clientLocationSilo = "">
			<!--- Get silo names for procedure and specialty --->
			<cfset procedureSilo = model("Procedure").findAll(select="siloName",where="id=#params.procedureId#")>
			<cfset specialtySilo = model("Specialty").findAll(select="id,siloName",where="id=#params.specialtyId#")>
			<!--- Get location string from client vars --->
			<cfif specialtySilo.siloName neq "" and procedureSilo.siloName eq "">
				<!--- If specialty only, use specialty silo --->
				<cflocation url="/doctors/#specialtySilo.siloName & clientLocationSilo#" addtoken="no" statuscode="301">
			<cfelseif procedureSilo.siloName neq "">
				<!--- Otherwise, use procedure, and specialty ID if defined --->
				<cflocation url="/doctors/#procedureSilo.siloName & clientLocationSilo & ((val(specialtySilo.id) neq 0) ? '/specialty-'&specialtySilo.id : '')#" addtoken="no" statuscode="301">
			</cfif>
			<!--- If neither, just use location, or just go to the form --->
			<cflocation url="/doctors#clientLocationSilo#" addtoken="no" statuscode="301">
		</cfif>

		<cfif params.rewrite>
			<cfset siloedFilters = "">
			<cfset siloedNames = "">
			<cfset Local.filterStruct = {}>
			<cfset Local.locationFilterId = "">
			<cfset Local.filterSilo = "">

			<cfloop from="1" to="20" index="Local.i">
				<cfif structKeyExists(params, "filter#Local.i#")>
					<cfset Local.currentFilter = params["filter#Local.i#"]>
					<cfset Local.filterSilo &= "/#Local.currentFilter#">
					<cfif ReFind("location-[^/]+", Local.currentFilter)>
						<cfset Local.filterStruct["location"] = ListRest(fnGetSiloName(Local.currentFilter), "-")>
						<cfset locationFilterId = Local.i>
					<cfelse>
						<cfset Local.filterStruct[ListFirst(Local.currentFilter, "-")] = ListLast(Local.currentFilter, "-")>
					</cfif>
				<cfelse>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfset Local.newFilterId = Local.i>

			<!--- Check for unsiloed location --->
			<cfif trim(params.siloname) eq "" and structKeyExists(Local.filterStruct, "location") and fnIsSiloLocation(Local.filterStruct.location)>
				<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/location-[^/]+", "", "all")>
				<cflocation url="/doctors/#Local.filterStruct.location##Local.filterSilo#" addtoken="no" statuscode="301">
			</cfif>

			<!--- Silo / un-silo URLs --->
			<cfif trim(params.siloname) neq "">
				<cfset Local.siloProcedure = model("Procedure").findOneBySiloName(value=params.siloname, select="id")>
				<cfset Local.siloSpecialty = model("Specialty").findOneBySiloName(value=params.siloname, select="id")>
				<cfset Local.siloBodyPart = model("bodyPart").findOneBySiloName(value=params.siloname, select="id")>
				<cfquery datasource="myLocateadocLB3" name="Local.qrySiloState">
					SELECT s.id AS stateId, s.name, CreateSiloNameWithDash(s.name) AS siloName, co.abbreviation AS country
					FROM states s
					INNER JOIN countries co ON co.id = s.countryID AND co.deletedAt IS NULL
					WHERE s.siloName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ReReplaceNoCase(params.siloname,"[^a-z]+", "", "all")#">
						AND s.deletedAt IS NULL
				</cfquery>
				<cfquery datasource="myLocateadocLB3" name="Local.qrySiloCityState">
					SELECT concat(c.name,", ",s.abbreviation) AS name, concat(CreateSiloNameWithDash(c.name),"-",s.abbreviation) AS siloName, c.name AS cityName, co.abbreviation AS country, s.id AS stateId, c.id AS cityId
					FROM states s
					INNER JOIN cities c ON c.stateId = s.id AND c.deletedAt IS NULL
					INNER JOIN countries co ON co.id = s.countryID AND co.deletedAt IS NULL
					WHERE s.abbreviation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListLast(params.siloname, "-")#">
						AND c.siloName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ReReplaceNoCase(Reverse(ListRest(Reverse(params.siloname), "-")),"[^a-z]+", "", "all")#">
						AND s.deletedAt IS NULL
				</cfquery>
				<cfif structKeyExists(Local.filterStruct, "location") and (Local.qrySiloState.recordCount or Local.qrySiloCityState.recordCount)>
					<!--- If location is siloed and there's a location filter, redirect to location filter --->
					<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/location-[^/]+", "", "all")>
					<cflocation url="/doctors/#Local.filterStruct.location##Local.filterSilo#" addtoken="no" statuscode="301">
				</cfif>
				<cfif structKeyExists(Local.filterStruct, "specialty") and (Local.qrySiloState.recordCount or Local.qrySiloCityState.recordCount)>
					<!--- If location is siloed and there's a specialty filter, redirect to specialty/location --->
					<cfset Local.qrySpecialty = model("Specialty").findByKey(key=Local.filterStruct.specialty, select="siloName")>
					<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/specialty-[^/]+", "", "all")>
					<cfif isObject(Local.qrySpecialty)>
						<cfset Local.siloLocation = Local.qrySiloCityState.recordCount gt 0 ? Local.qrySiloCityState.siloName : Local.qrySiloState.siloName>
						<cflocation url="/doctors/#Local.qrySpecialty.siloName#/#Local.siloLocation##Local.filterSilo#" addtoken="no" statuscode="301">
					<cfelse>
						<cfset dumpStruct = {params=params}>
						<cfset fnCthulhuException(	scriptName="Doctors.cfc",
													message="Can't find specialty (id: #Local.filterStruct.specialty#)",
													detail="Cannot locate a record in the specialties table that posesses an id that is equal to #Local.filterStruct.specialty#.",
													dumpStruct=dumpStruct,
													redirectURL=""
													)>
					</cfif>
				</cfif>
				<cfif structKeyExists(Local.filterStruct, "procedure") and (Local.qrySiloState.recordCount or Local.qrySiloCityState.recordCount)>
					<!--- If location is siloed and there's a procedure filter, redirect to procedure/location --->
					<cfset Local.qryProcedure = model("Procedure").findByKey(
								key			= Local.filterStruct.procedure,
								select		= "siloName",
								returnAs	= "query")>


					<cfif Local.qryProcedure.recordCount EQ 0>
						<!--- Check if procedure should redirect to another
								http://carlos3.locateadoc.com/doctors/winchester-va/procedure-531
						--->
						<cfset Local.qryProcedure = model("ProcedureRedirect").findOne(
										where	= "procedureredirects.procedureIdFrom = '#Local.filterStruct.procedure#'",
										include	= "procedure",
										select	= "procedures.siloName",
										returnAs	= "query")>
					</cfif>


					<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/procedure-[^/]+", "", "all")>
					<cfif Local.qryProcedure.recordCount GT 0>
						<cfset Local.siloLocation = Local.qrySiloCityState.recordCount gt 0 ? Local.qrySiloCityState.siloName : Local.qrySiloState.siloName>
						<cflocation url="/doctors/#Local.qryProcedure.siloName#/#Local.siloLocation##lcase(Local.filterSilo)#" addtoken="no" statuscode="301">
					<cfelse>

						<cfset dumpStruct = {params=params}>
						<cfset fnCthulhuException(	scriptName="Doctors.cfc",
													message="Can't find procedure (id: #Local.filterStruct.procedure#)",
													detail="Cannot locate a record in the procedures table that posesses an id that is equal to #Local.filterStruct.procedure#.",
													dumpStruct=dumpStruct,
													redirectURL=""
													)>
					</cfif>
				</cfif>

				<cfif Server.isInteger(params.siloname)>
					<!--- Fixing URLs like http://www.locateadoc.com/doctors/23/ohio.html --->
					<!--- Fixing URLs like http://www.locateadoc.com/doctors/18/edison-nj.html --->
					<cfset params.silolocation = ReplaceNoCase(params.silolocation, ".html", "")>
					<cfset Local.state = model("State").findAllByAbbreviation(value=ListLast(params.silolocation, "-"), select="id")>
					<cfif Local.state.recordCount>
						<cfset Local.city = ListFirst(params.silolocation, "-")>
						<cfset Local.state = ListLast(params.silolocation, "-")>
						<cfquery datasource="myLocateadocLB3" name="Local.qryState">
							SELECT abbreviation as name
							FROM states
							WHERE abbreviation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Local.state#">
								AND deletedAt IS NULL
						</cfquery>
					<cfelse>
						<cfset Local.city = "">
						<cfset Local.state = params.silolocation>
						<cfquery datasource="myLocateadocLB3" name="Local.qryState">
							SELECT CreateSiloNameWithDash(name) as name
							FROM states
							WHERE siloName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Local.state#">
								AND deletedAt IS NULL
						</cfquery>
					</cfif>
					<cfset Local.location = qryState.name>
					<cfif Local.city neq "">
						<cfquery datasource="myLocateadocLB3" name="Local.qryCity">
							SELECT CreateSiloNameWithDash(name) as name
							FROM cities
							WHERE siloName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Local.city#">
								AND deletedAt IS NULL
						</cfquery>
						<cfif qryCity.recordCount>
							<cfset Local.location = "#qryCity.name#-#Local.location#">
						</cfif>
					</cfif>
					<cfif val(params.siloname) LT 256>
						<cfset Local.specialty = model("Specialty").findByKey(key=val(params.siloname), select="siloName")>
					<cfelse>
						<cfset Local.specialty = "">
					</cfif>
					<cfif isObject(Local.specialty)>
						<cfif Local.location eq "">
							<cfset dumpStruct = {params=params, local=local}>
							<cfset fnCthulhuException(	scriptName="Doctors.cfc",
														message="Can't find state #params.silolocation#.",
														detail="In what Universe is '#params.silolocation#' a location?",
														dumpStruct=dumpStruct,
														redirectURL="/doctors/#Local.specialty.siloName#"
														)>
						</cfif>
						<cflocation url="/doctors/#Local.specialty.siloName#/#Local.location#" addtoken="no" statuscode="301">
					<cfelse>
						<cfset dumpStruct = {params=params}>
						<cfset fnCthulhuException(	scriptName="Doctors.cfc",
													message="Can't find specialty (id: #params.siloname#).",
													detail="Here I am trying to fix this URL and BAM! can't find the stupid specialty.",
													dumpStruct=dumpStruct,
													redirectURL="/doctors"
													)>
					</cfif>
				<cfelseif isObject(Local.siloProcedure)>
					<cfset siloedFilters = "/procedure-#Local.siloProcedure.id#">
					<cfset "params.filter#Local.newFilterId#" = "procedure-#Local.siloProcedure.id#">
				<cfelseif isObject(Local.siloSpecialty)>
					<cfset siloedFilters = "/specialty-#Local.siloSpecialty.id#">
					<cfset "params.filter#Local.newFilterId#" = "specialty-#Local.siloSpecialty.id#">
				<cfelseif isObject(Local.siloBodyPart)>
					<cfset siloedFilters = "/bodypart-#Local.siloBodyPart.id#">
					<cfset "params.filter#Local.newFilterId+1#" = "bodypart-#Local.siloBodyPart.id#">
				<cfelseif Local.qrySiloState.recordCount>
					<!--- State only --->
					<cfif params.siloname eq Local.qrySiloState.siloName>
						<cfset params["filter#Local.locationFilterId#"] = "location-#Local.qrySiloState.name#">
						<cfset params.location = Local.qrySiloState.siloName>
						<cfset params.country = Local.qrySiloState.country>
						<cfset siloedFilters &= "/location-#ReReplace(Local.qrySiloState.name, "[\s]+", "_", "all")#">
						<cfset siloedNames &= "/#Local.qrySiloState.siloName#">
						<cfset title = "#Local.qrySiloState.name# Doctors - Find the Best Doctors in #Local.qrySiloState.name#">
					<cfelse>
						<cflocation url="#ReplaceNoCase(params.silourl,params.siloname,Local.qrySiloState.siloName)#" addtoken="no" statuscode="301">
					</cfif>
				<cfelseif Local.qrySiloCityState.recordCount>
					<!--- City State silo --->
					<cfif params.siloname eq Local.qrySiloCityState.siloName>
						<cfset params.country = Local.qrySiloCityState.country>
						<cfset params["filter#Local.locationFilterId#"] = "location-#Local.qrySiloCityState.cityName#, #UCase(ListLast(params.siloname, "-"))#">
						<cfset params.location = "#Local.qrySiloCityState.cityName#, #UCase(ListLast(params.siloname, "-"))#">
						<cfset siloedFilters &= "/location-#ReReplace(Local.qrySiloCityState.name, "[\s]+", "_", "all")#">
						<cfset siloedNames &= "/#Local.qrySiloCityState.siloName#">
						<cfset title = "#Local.qrySiloCityState.cityName# Doctors - Find the Best Doctors in #Local.qrySiloCityState.name#">
					<cfelse>
						<cflocation url="#ReplaceNoCase(params.silourl,params.siloname,Local.qrySiloCityState.siloName)#" addtoken="no" statuscode="301">
					</cfif>
				<cfelse>
					<!--- Check for merged procedures --->
					<cfset Local.siloProcedure = model("Procedure").findOneBySiloName(value=params.siloname, select="id", includeSoftDeletes="true")>
					<cfif isObject(Local.siloProcedure)>
						<cfset Local.procedureRedirect = model("procedureRedirect").findOneByProcedureIdFrom(value=Local.siloProcedure.id, select="procedureIdTo", order="id DESC")>
						<cfif isObject(Local.procedureRedirect)>
							<cfset Local.siloProcedure = model("Procedure").findByKey(key=Local.procedureRedirect.procedureIdTo, select="siloName")>
							<cfif isObject(Local.siloProcedure)>
								<cflocation url="#ReplaceNoCase(params.silourl, params.siloname, Local.siloProcedure.siloName)#" addtoken="no" statuscode="301">
							</cfif>
						</cfif>
					</cfif>
					<cfset dumpStruct = {params=params, siloProcedure=Local.siloProcedure}>
					<cfset fnCthulhuException(	scriptName="Doctors.cfc",
												message="Can't match silo name (silo name: #params.siloname#) to any of our procedures, specialties, body part, or location.",
												detail="FOREVER ALONE GUY, Y U NO GET CAT?",
												dumpStruct=dumpStruct,
												redirectURL="/doctors"
												)>
				</cfif>
				<cfset siloedNames = "/#params.siloname#">
				<cfif not isObject(Local.siloBodyPart)>
					<!--- Check location --->
					<cfif params.silolocation neq "">
						<!--- Location siloed --->
						<cfset Local.location = ReReplace(LCase(params.silolocation), "[^a-z]+", "-", "all")>
						<cfif not fnIsSiloLocation(Local.location)>
							<!--- Not valid silo name -> un-silo it --->
							<cfset Local.filtersilo &= "/location-#Local.location#">
							<cflocation url="http://#CGI.SERVER_NAME#/doctors/#params.siloname##Local.filterSilo#" addtoken="no" statuscode="301">
						<cfelseif params.silolocation neq Local.location>
							<!--- Silo location is not correctly formatted -> redirect to correct silo name --->
							<cflocation url="http://#CGI.SERVER_NAME#/doctors/#params.siloname#/#Local.location##Local.filterSilo#" addtoken="no" statuscode="301">
						</cfif>
						<!--- Check if the silo location is an alternate form of the one we use --->
						<cfquery datasource="myLocateadocLB3" name="Local.siloStateCheck">
							SELECT CreateSiloNameWithDash(s.name) AS siloName
							FROM states s
							INNER JOIN countries co ON co.id = s.countryID AND co.deletedAt IS NULL
							WHERE s.siloName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ReReplaceNoCase(params.silolocation,"[^a-z]+", "", "all")#">
								AND s.deletedAt IS NULL
						</cfquery>
						<cfquery datasource="myLocateadocLB3" name="Local.siloCityStateCheck">
							SELECT concat(CreateSiloNameWithDash(c.name),"-",s.abbreviation) AS siloName
							FROM states s
							INNER JOIN cities c ON c.stateId = s.id AND c.deletedAt IS NULL
							INNER JOIN countries co ON co.id = s.countryID AND co.deletedAt IS NULL
							WHERE s.abbreviation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListLast(params.silolocation, "-")#">
								AND c.siloName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ReReplaceNoCase(Reverse(ListRest(Reverse(params.silolocation), "-")),"[^a-z]+", "", "all")#">
								AND s.deletedAt IS NULL
						</cfquery>
						<!--- Redirect if silo location is an alternate form --->
						<cfif Local.siloStateCheck.recordCount AND params.silolocation neq Local.siloStateCheck.siloName>
							<cflocation url="#ReplaceNoCase(params.silourl,params.silolocation,Local.siloStateCheck.siloName)#" addtoken="no" statuscode="301">
						<cfelseif Local.siloCityStateCheck.recordCount AND params.silolocation neq Local.siloCityStateCheck.siloName>
							<cflocation url="#ReplaceNoCase(params.silourl,params.silolocation,Local.siloCityStateCheck.siloName)#" addtoken="no" statuscode="301">
						</cfif>
						<cfset params["filter#Local.newFilterId+1#"] = "location-#Replace(params.silolocation, "-", " ", "all")#">
						<cfset siloedFilters &= "/location-#Replace(params.silolocation, "-", " ", "all")#">
						<cfset siloedNames &= "/#params.silolocation#">
					<cfelseif structKeyExists(Local.filterStruct, "location") and fnIsSiloLocation(Local.filterStruct["location"])>
						<!--- Location non-siloed but it's silo-able -> redirect --->

						<cfset local.stateSiloName = fnSiloLocationAbbreviation(Local.filterStruct["location"])>

						<cfif fnSiloLocationAbbreviation(Local.filterStruct["location"]) EQ "">
							<!--- http://www.locateadoc.com/doctors/hair-restoration/location--connecticut --->
							<cfset Local.filterSilo = Local.filterStruct["location"] & ReReplaceNoCase(Local.filterSilo, "/location-[^/]+", "", "all")>
						<cfelse>
							<!--- http://www.locateadoc.com/doctors/hair-restoration/location--ct --->
							<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/location-[^/]+", local.stateSiloName, "all")>
						</cfif>

						<cflocation url="http://#CGI.SERVER_NAME#/doctors/#params.siloname#/#Local.filterSilo#" addtoken="no" statuscode="301">
					</cfif>
				</cfif>
			<cfelseif structKeyExists(Local.filterStruct, "procedure")>
				<!--- Procedure filter, need to redirect to siloed --->
				<cfset Local.siloProcedure = model("Procedure").findByKey(key=Local.filterStruct["procedure"], select="siloName")>
				<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/procedure-[^/]+", "", "all")>
				<cfif isObject(Local.siloProcedure)>
					<cfif structKeyExists(Local.filterStruct, "location") and fnIsSiloLocation(Local.filterStruct["location"])>
						<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/location-[^/]+", "", "all")>
						<cflocation url="http://#CGI.SERVER_NAME#/doctors/#Local.siloProcedure.siloName#/#fnGetSiloName(Local.filterStruct["location"])##Local.filterSilo#" addtoken="no" statuscode="301">
					<cfelse>
						<cflocation url="http://#CGI.SERVER_NAME#/doctors/#Local.siloProcedure.siloName##Local.filterSilo#" addtoken="no" statuscode="301">
					</cfif>
				<cfelse>
					<cfset Local.siloProcedure = model("Procedure").findByKey(key=Local.filterStruct["procedure"], select="id", includeSoftDeletes="true")>
					<cfif isObject(Local.siloProcedure)>
						<cfset Local.procedureRedirect = model("procedureRedirect").findOneByProcedureIdFrom(value=Local.siloProcedure.id, select="procedureIdTo", order="id DESC")>
						<cfif isObject(Local.procedureRedirect)>
							<cfset Local.siloProcedure = model("Procedure").findByKey(key=Local.procedureRedirect.procedureIdTo, select="siloName")>
							<cflocation url="#ReplaceNoCase(params.silourl, "procedure-#Local.filterStruct["procedure"]#", Local.siloProcedure.siloName)#" addtoken="no" statuscode="301">
						</cfif>
					</cfif>
					<cfset dumpStruct = {params=params, siloProcedure=Local.siloProcedure}>
					<cfset fnCthulhuException(	scriptName="Doctors.cfc",
												message="Can't find procedure (id: #Local.filterStruct["procedure"]#)",
												detail="DEGREE, Y U NO GIVE ME JOB?",
												dumpStruct=dumpStruct,
												redirectURL="/doctors#Local.filterSilo#"
												)>
				</cfif>
			<cfelseif structKeyExists(Local.filterStruct, "specialty")>
				<!--- Specialty filter, need to redirect to siloed --->
				<cfset Local.siloSpecialty = model("Specialty").findByKey(key=Local.filterStruct["specialty"], select="siloName")>
				<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/specialty-[^/]+", "", "all")>
				<cfif isObject(Local.siloSpecialty)>
					<cfif structKeyExists(Local.filterStruct, "location") and fnIsSiloLocation(Local.filterStruct["location"])>
						<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/location-[^/]+", "", "all")>
						<cflocation url="http://#CGI.SERVER_NAME#/doctors/#Local.siloSpecialty.siloName#/#fnGetSiloName(Local.filterStruct["location"])##Local.filterSilo#" addtoken="no" statuscode="301">
					<cfelse>
						<cflocation url="http://#CGI.SERVER_NAME#/doctors/#Local.siloSpecialty.siloName##Local.filterSilo#" addtoken="no" statuscode="301">
					</cfif>
				<cfelse>
					<cfset dumpStruct = {params=params, siloSpecialty=Local.siloSpecialty}>
					<cfset fnCthulhuException(	scriptName="Doctors.cfc",
												message="Can't find specialty (id: #Local.filterStruct["specialty"]#)",
												detail="DELICIOUS FOOD, Y U NO HEALTHY?",
												dumpStruct=dumpStruct,
												redirectURL="/doctors#Local.filterSilo#"
												)>
				</cfif>
			<cfelseif structKeyExists(Local.filterStruct, "bodypart")>
				<!--- Have body part filter -> silo it --->
				<cfset Local.siloBodyPart = model("bodyPart").findByKey(key=Local.filterStruct["bodypart"], select="siloName")>
				<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/bodypart-[^/]+", "", "all")>
				<cfif isObject(Local.siloBodyPart)>
					<cflocation url="http://#CGI.SERVER_NAME#/doctors/#Local.siloBodyPart.siloName##Local.filterSilo#" addtoken="no" statuscode="301">
				<cfelse>
					<cfset dumpStruct = {params=params, filterStruct=Local.filterStruct}>
					<cfset fnCthulhuException(	scriptName="Doctors.cfc",
												message="Can't find body part (body part id: #Local.filterStruct["bodypart"]#)",
												detail="I'm not insane, my mother had me tested!",
												dumpStruct=dumpStruct,
												redirectURL="/doctors#Local.filterSilo#"
												)>
				</cfif>
			</cfif>

			<cfif structKeyExists(Local.filterStruct, "location")>
				<cfset params["filter#Local.locationFilterId#"] = "location-#ReReplace(Local.filterStruct["location"], "[^a-z0-9]+", " ", "all")#">
			</cfif>

			<!--- Generate JS for specialty, procedure, and body part DB --->
			<cfsavecontent variable="siloJS">
				<cfoutput>
					<script type="text/javascript">
						siloedFilters = "#siloedFilters#";
						siloedNames = "#siloedNames#";
					</script>
				</cfoutput>
			</cfsavecontent>
			<cfhtmlhead text="#fnCompress(siloJS)#">
		</cfif>

		<cfset search = getSearchResults()>
		<cfset breadcrumbs = initBreadcrumbs()>
		<cfif search.stateBreadcrumb neq "">
			<cfset arrayAppend(breadcrumbs,search.stateBreadcrumb)>
		</cfif>
		<cfif search.results.recordcount and search.landingHeader neq "">
			<cfset arrayAppend(breadcrumbs,search.landingHeader)>
		<cfelseif search.results.recordcount and search.searchSummary neq "">
			<cfset arrayAppend(breadcrumbs,search.searchSummary)>
		</cfif>

		<cfif (not isDefined("title") or title eq "") and search.pagetitle neq "">
			<cfset title = search.pagetitle>
		</cfif>
		<cfif search.metadescription neq "">
			<cfset metaDescriptionContent = search.metadescription>
		</cfif>

		<cfif Find("?",Request.currentURL)>
			<cfset canonicalURL = trim(REReplace(Request.currentURL,"\?.*$",""))>
		</cfif>

		<cfset doNotIndex = ((val(params.distance) and not params.distanceFound)
								or params.name neq ""
								<!--- or val(params.bodypart)  --->
								or params.gender neq ""
			  					or val(params.language)
			  					or (val(params.bodypart) and params.location neq "")
			  				)
			  or (params.location neq "" and not fnIsSiloLocation(params.location))
			  or (1 lt ((val(params.procedure) gt 0) + (val(params.specialty) gt 0) + (val(params.bodypart) gt 0)))
			  or (search.results.recordcount eq 0)>
		<cfif not doNotIndex>
			<cfset relNext = getNextPage(search.page,search.pages)>
			<cfset relPrev = getPrevPage(search.page)>
		</cfif>

		<cfif (search.results.recordcount eq 0)>
			<!--- Following these instructions https://support.google.com/webmasters/answer/2409443?hl=en&ref_topic=4610835 --->
			<cfheader statuscode="410" statustext="Not Found">
		</cfif>

		<cfif checkLayout() EQ "/email">
			<cfset renderPage(	template = "searchemail")>
		<cfelseif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<!--- Render mobile page --->
			<cfset Request.mobileLayout = true>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="states">
		<cfquery datasource="myLocateadocLB3" name="qryUSStates">
			SELECT name, siloName
			FROM statesummaries
			WHERE countryId = 102
			ORDER BY name
		</cfquery>
		<cfquery datasource="myLocateadocLB3" name="qryCAStates">
			SELECT name, siloName
			FROM statesummaries
			WHERE countryId = 12
			ORDER BY name
		</cfquery>
		<cfquery datasource="myLocateadocLB3" name="qryMXStates">
			SELECT name, siloName
			FROM statesummaries
			WHERE countryId = 48
			ORDER BY name
		</cfquery>
		<cfset title = "Find Doctors in the United States">
	</cffunction>

	<cffunction name="cities">
		<cfparam name="params.silostate" default="">

		<cfset state = model("state").findOneBySiloName(value=ReReplace(params.silostate,"[^a-z]+","","all"), select="id, name, abbreviation")>
		<cfif not isObject(state)>
			<cflocation url="/doctors/states" addtoken="no" statuscode="301">
		<cfelse>
			<cfquery datasource="myLocateadocLB3" name="qryCities">
				SELECT cityName as name, citySiloName as siloName
				FROM statecitysummaries
				WHERE stateId = <cfqueryparam cfsqltype="cf_sql_integer" value="#state.id#">
				ORDER BY cityName
			</cfquery>
		</cfif>
		<cfset title = "Find the Best Doctors in #state.name#">
	</cffunction>

	<cffunction name="location">
		<cfsetting showdebugoutput="false">
		<cfset provides("html,json")>
		<cfparam name="params.term" default="">
		<cfparam name="params.country" default="">
		<cfparam name="params.callback" default="">
		<cfset Request.overrideDebug = "false">

		<cfset results = {}>
		<cfset results.tick = GetTickCount()>

		<!--- Filter the term --->
		<cfset params.term = REReplace(params.term,"[^A-Za-z\.,\' ]","","all")>

		<cfif params.term neq "">
			<cfset cities = model("CitiesFullTextSummary").GetCities(	city	= trim(ListFirst(params.term)),
																		state	= ListLen(params.term) gt 1 ? trim(ListGetAt(params.term,2)) : "",
																		country	= params.country)>

			<cfset results.content = ArrayNew(1)>
			<cfloop query="cities">
				<cfset ArrayAppend(results.content,"#cities.name#, #cities.abbreviation#")>
			</cfloop>
		</cfif>
		<cfset renderText("#params.callback#(#SerializeJSON(results)#)")>
	</cffunction>

	<cffunction name="names">
		<cfsetting showdebugoutput="false">
		<cfset provides("html,json")>
		<cfparam name="params.term" default="">
		<cfparam name="params.callback" default="">

		<cfset results = {}>
		<cfset results.tick = GetTickCount()>

		<!--- Filter the state --->
		<cfset params.term = REReplace(params.term,"[^A-Za-z\.\' ]","","all")>

		<cfif params.term neq "">
			<cfset doctorNames = model("accountDoctor").findAll(
				select="lastName",
				where="lastName LIKE '#params.term#%'",
				group="lastName",
				order="lastName ASC",
				$limit="5"
			)>
			<cfif doctorNames.recordcount>
				<cfset results.content = ArrayNew(1)>
				<cfloop query="doctorNames">
					<cfset ArrayAppend(results.content,lastName)>
				</cfloop>
			</cfif>
		</cfif>
		<cfset renderText("#params.callback#(#SerializeJSON(results)#)")>
	</cffunction>

	<cffunction name="featuredCarousel">
		<!--- This will be invoked by other controllers to include the featured carousel in other sections --->
		<cfargument name="city"			type="numeric"	required="false" default="0">
		<cfargument name="state"		type="numeric"	required="false" default="0">
		<cfargument name="procedureId"	type="numeric"	required="false" default="0">
		<cfargument name="specialtyId"	type="numeric"	required="false" default="0">
		<cfargument name="bodyPartId"	type="numeric"	required="false" default="0">
		<cfargument name="limit" 		type="numeric"	required="false" default="30">
		<cfargument name="paramsAction"		type="string"	required="true" default="">
		<cfargument name="paramsController"	type="string"	required="true" default="">

		<cfreturn getFeaturedListings(city=arguments.city,
										state=arguments.state,
										procedureId=arguments.procedureId,
										specialtyId=arguments.specialtyId,
										bodyPartId=arguments.bodyPartId,
										limit=arguments.limit,
										recordHit=true,
										paramsAction = arguments.paramsAction,
										paramsController = arguments.paramsController)>
	</cffunction>

	<cffunction name="UpdateGeodata">
		<cfsetting showdebugoutput="false">
		<cfparam name="params.lat" default="">
		<cfparam name="params.lon" default="">
		<cfparam name="params.id" default="">

		<cfset model("AccountLocation").UpdateGeodata(
			lat = params.lat,
			lon = params.lon,
			id = params.id
		)>

		<cfset renderNothing()>
	</cffunction>

	<!--- Private functions --->

	<cffunction name="initBreadcrumbs" access="private" returntype="array">
		<cfset breadcrumbs = []>
		<cfset arrayAppend(breadcrumbs,linkTo(href="/",text="Home"))>
		<cfset arrayAppend(breadcrumbs,linkTo(controller="doctors",text="Find a Doctor"))>
		<cfreturn breadcrumbs>
	</cffunction>

	<cffunction name="getProcedures" access="private">
	 <cfargument name="alphasOnly" type="boolean" required="false" default="false">
	 <cfargument name="letter" type="string" required="false" default="">
		<cfif alphasOnly>
			<cfset Local.procedures = model("Procedure").findAll(
				select="distinct left(name,1) as letter",
				where="lettercompare >= 0 AND isPrimary = 1",
				order="name asc"
			)>
		<cfelse>

			<cfset Local.procedures = model("Procedure").findAll(
				select="procedures.id, procedures.name, procedures.siloName",
				where="isPrimary = 1#Iif(letter neq '',DE(' AND left(procedures.name,1) = "' & letter & '"'),DE(''))#",
				order="name asc"
			)>
		</cfif>
		<cfreturn Local.procedures>
	</cffunction>

	<cffunction name="getSpecialties" access="private">
	 <cfargument name="alphasOnly" type="boolean" required="false" default="false">
		<cfif alphasOnly>
			<cfset Local.specialties = model("Specialty").findAll(
				select="distinct left(name,1) as letter",
				where="lettercompare >= 0 AND categoryId = 1",
				order="name asc"
			)>
		<cfelse>
			<cfset Local.specialties = model("Specialty").findAll(
				select="specialties.id, specialties.name",
				where="categoryId = 1",
				order="name asc"
			)>
		</cfif>
		<cfreturn Local.specialties>
	</cffunction>

	<cffunction name="getCities" access="private" returntype="struct">
		<cfargument name="statename" type="string" required="false" default="">
		<cfargument name="twocolumns" type="boolean" required="false" default="false">
		<cfargument name="addendum" type="string" required="false" default="">
		<cfargument name="addendumSilo" type="string" required="false" default="">
		<cfif addendum contains "specialty">
			<cfset whereAddendum = " AND FIND_IN_SET(#REReplace(addendum,'[^0-9]','','all')#,specialtyIDs)">
		<cfelseif addendum contains "procedure">
			<cfset whereAddendum = " AND FIND_IN_SET(#REReplace(addendum,'[^0-9]','','all')#,procedureIDs)">
		<cfelse>
			<cfset includeAddendum = "">
			<cfset whereAddendum = "">
		</cfif>

		<cfquery name="cities" datasource="#get('dataSourceName')#">
			SELECT DISTINCT cityId as id, city as name, state, stateAbbreviation, stateId, LEFT(state,1) AS letter
			FROM accountdoctorsearchsummary
			WHERE isFeatured = 1 AND cityId > 0 AND city is not null#whereAddendum#
			ORDER BY state asc, city asc
		</cfquery>

		<cfquery name="citycount" dbtype="query">
			SELECT count(1) most FROM cities GROUP BY stateid ORDER BY most desc;
		</cfquery>

		<cfif twocolumns>
			<cfset columnbreak = ceiling(val(citycount.most)/2)>
		<cfelse>
			<cfset columnbreak = ceiling(val(citycount.most)/5)>
		</cfif>

		<cfset result = "">
		<cfset currentState = "">
		<cfset RowInSet = 1>

		<cfparam default="" name="Application.stCachedContent.DoctorsGetCities">
		<cfif Application.stCachedContent.DoctorsGetCities EQ "">
			<cfloop query="cities">
				<cfif state neq currentState>
					<cfset currentState = state>
					<cfset RowInSet = 1>
					<cfif cities.currentrow gt 1>
						<cfset result &= "</div>">
					</cfif>
					<cfset result &= '<div id="#Replace(state," ","-","all")#">'>
				</cfif>
				<cfif ((columnbreak gt 1) and (RowInSet mod columnbreak) eq 1) or (cities.currentrow eq 1) or (RowInSet eq 1)>
					<cfset result &= "<ul>">
				</cfif>
				<cfif addendumSilo eq "">
					<!--- <cfset result &= '<li>#linkTo(text=name, route="doctorSearch1", filter1="location-#Replace(Replace("#cities.name#, #cities.stateAbbreviation#"," ","_","all"),",","%2C","all")#")#</li>'> --->
					<cfset result &= '<li>#linkTo(text=name, href="/doctors/location-#Replace(cities.name & ", " & cities.stateAbbreviation," ","_","all")#")#</li>'>
				<cfelse>
					<!--- <cfset result &= '<li>#linkTo(text=name, route="doctorSearch2", filter1="location-#Replace(Replace("#cities.name#, #cities.stateAbbreviation#"," ","_","all"),",","%2C","all")#", filter2=addendum)#</li>'> --->
					<cfset result &= '<li>#linkTo(text=name, href="/doctors/#addendumSilo#/#LCase(Replace(cities.name & "-" & cities.stateAbbreviation," ","_","all"))#")#</li>'>
				</cfif>
				<cfif ((columnbreak gt 1) and (RowInSet mod columnbreak) eq 0) or (cities.currentrow eq cities.recordcount)>
					<cfset result &= "</ul>">
				</cfif>
				<cfif cities.currentrow eq cities.recordcount>
					<cfset result &= "</div>">
				</cfif>
				<cfset RowInSet++>
			</cfloop>

			<cfset Application.stCachedContent.DoctorsGetCities = result>
		</cfif>

		<cfquery name="States" dbtype="query">
			SELECT state as name, letter FROM cities GROUP BY state, letter ORDER BY state asc;
		</cfquery>
		<cfquery name="StateAlphas" dbtype="query">
			SELECT letter FROM States GROUP BY letter ORDER BY name asc;
		</cfquery>

		<cfreturn {cities=Application.stCachedContent.DoctorsGetCities, states=States, stateAlphas=StateAlphas}>
	</cffunction>

	<cffunction name="sponsoredlink" returntype="struct" access="private">
		<cfparam name="params.specialty" default="">
		<cfparam name="params.procedure" default="">
		<cfparam name="params.bodypart" default="">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">
		<cfparam name="params.city" default="">
		<cfparam name="params.state" default="">
		<cfparam name="params.zipcode" default="">

		<cfif (params.action eq "search") AND NOT (val(params.city) eq 0 AND val(params.state) eq 0)>
			<cfset linkCity = val(params.city)>
			<cfset linkState = val(params.state)>
		<cfelseif params.zipcode neq "">
			<cfset zipLocation = model("PostalCodes").findAll(where="postalCode = '#params.zipcode#'")>
			<cfif zipLocation.recordcount>
				<cfset linkCity = "#zipLocation.cityId#">
				<cfset linkState = "#zipLocation.stateId#">
			<cfelse>
				<cfset zipLocation = model("PostalCodeCanadas").findAll(where="postalCode = '#params.zipcode#'")>
				<cfif zipLocation.recordcount>
					<cfset linkCity = "#zipLocation.cityId#">
					<cfset linkState = "#zipLocation.stateId#">
				<cfelse>
					<cfset linkCity = "#client.city#">
					<cfset linkState = "#client.state#">
				</cfif>
			</cfif>
		<cfelse>
			<cfset linkCity = "#client.city#">
			<cfset linkState = "#client.state#">
		</cfif>

		<cfset sponsoredLink = getSponsoredLink(	city		= "#linkCity#",
													state		= "#linkState#",
													specialty	= "#val(params.specialty)#",
													procedure	= "#val(params.procedure)#",
													bodyPartId	= "#val(params.bodypart)#",
													paramsAction		= "#params.action#",
													paramsController	= "#params.controller#")>
		<cfreturn sponsoredLink>
	</cffunction>

	<cffunction name="getFeaturedListings" access="private" returntype="query">
		<cfargument name="city"					type="numeric"	required="false" default="0">
		<cfargument name="state"				type="numeric"	required="false" default="0">
		<cfargument name="procedureId"			type="numeric"	required="false" default="0">
		<cfargument name="specialtyId"			type="numeric"	required="false" default="0">
		<cfargument name="bodyPartId"			type="numeric"	required="false" default="0">
		<cfargument name="limit"				type="numeric"	required="false" default="30">
		<cfargument name="includeSpecialties"	type="boolean"	required="false" default="false">
		<cfargument name="recordHit"			type="boolean"	required="false" default="false">
		<cfargument name="paramsAction"			type="string"	required="false" default="">
		<cfargument name="paramsController"		type="string"	required="false" default="">

		<cfif isdefined("params.action") AND arguments.paramsAction EQ "">
			<cfset arguments.paramsAction = params.action>
		</cfif>

		<cfif isdefined("params.controller") AND arguments.paramsController EQ "">
			<cfset arguments.paramsController = params.controller>
		</cfif>

		<cfset featuredListings = model("AccountDoctorLocation").GetFeatured(
			city 			=	val(arguments.city),
			state 			=	val(arguments.state),
			procedureId 	=	val(arguments.procedureId),
			specialtyId 	=	val(arguments.specialtyId),
			bodyPartId		=	val(arguments.bodyPartId),
			limit 			=	val(arguments.limit),
			recordHit		=	arguments.recordHit,
			thisAction		=	arguments.paramsAction,
			thisController	=	arguments.paramsController
		)>

		<cfreturn featuredListings>
	</cffunction>

	<!--- Performs variable filtering and processing and returns search results --->
	<cffunction name="getSearchResults" access="private">
		<cfset var Local = {}>
		<cfset var pathInfoLevel = "">
		<cfset var aPathInfoLevels = "">
		<cfset var qSpecialty = "">
		<cfset var qProcedure = "">
		<cfset var qState = "">
		<cfset var qCity = "">
		<cfset var location = {}>

		<cfset location.statename = "">
		<cfset location.statesiloname = "">
		<cfset location.stateabbr = "">
		<cfset location.cityName = "">

		<cfset noIndex = false>
		<cfset countryId = 0>
		<cfset latitude = 0>
		<cfset longitude = 0>
		<cfset citySuggestion = "">

		<!---PARAM all the search options to make sure we have them all regardless--->
		<cfparam name="params.distance"				default="">
		<cfparam name="params.distanceFound"		default="false">
		<cfparam name="params.location"				default="">
		<cfparam name="params.state"				default="">
		<cfparam name="params.city" 				default="">
		<cfparam name="params.zipCode"  			default="">
		<cfparam name="params.country"				default="">
		<cfparam name="params.name"					default="">
		<cfparam name="params.procedure"			default="">
		<cfparam name="params.specialty"			default="">
		<cfparam name="params.bodypart"				default="">
		<cfparam name="params.sortby"				default="nameSort ASC">
		<cfparam name="params.page"					default="1">
		<cfparam name="params.perpage"				default="10">

		<cfparam name="params.gender"				default="">
		<cfparam name="params.age"					default="">
		<cfparam name="params.language"				default="">
		<cfparam name="params.officeHours"			default="">



			<cfset noIndex = true>

			<!---Search the URL for filter params and reformat them for the search--->
			<cfloop collection="#params#" item="i">
				<cfif left(i,6) is "filter">
					<cfset Local.filtername = listFirst(params[i],"-")>
					<cfset Local.filtervalue = Replace(params[i],"#Local.filtername#-","")>
					<cfset params[Local.filtername] = Local.filtervalue>
				</cfif>
			</cfloop>

			<!--- Filtering the params --->
			<cfif REFind("[^0-9]",params.distance) gt 0 OR params.distance EQ 0>
				<!---
					http://www.locateadoc.com/doctors/dermatology/olney-md/distance-0
				--->
				<cfset url.siloUrl = RereplaceNoCase(url.siloUrl, "/distance-([^0-9]|0)", "")>
				<cflocation addtoken="false" statuscode="301" url="#url.siloUrl#">

			</cfif>
			<cfif params.distance gt 250>
				<cfset url.siloUrl = replaceNoCase(url.siloUrl, "/distance-#params.distance#", "/distance-250")>
				<cflocation addtoken="false" statuscode="301" url="#url.siloUrl#">
			</cfif>
			<cfif ListFindNoCase("US,CA,MX",params.country) eq 0>
				<cfset params.country = "">
			</cfif>
			<cfset CountryCheck = model("Country").findAll(
				select="id",
				where="abbreviation = '#params.country#'"
			)>
			<cfif CountryCheck.recordcount gt 0>
				<cfset countryID = CountryCheck.id>
			<cfelse>
				<cfset countryID = 0>
			</cfif>
			<cfset params.name = Replace(params.name,"_"," ","all")>
			<cfif REFind("[^A-Za-z-',\. ]",params.name) gt 0>
				<cfset params.name = "">
			</cfif>
			<cfif REFind("[^0-9]",params.procedure) gt 0>
				<cfset params.procedure = 0>
			</cfif>
			<cfif REFind("[^0-9]",params.specialty) gt 0>
				<cfset params.specialty = 0>
			</cfif>
			<cfif REFind("[^0-9]",params.bodypart) gt 0>
				<cfset params.bodypart = 0>
			</cfif>
			<cfif REFind("^[a-zA-Z]+ (ASC|DESC)$",params.sortby) eq 0>
				<cfset params.sortby = "nameSort ASC">
			</cfif>
			<cfif (REFind("[^0-9]",params.page) gt 0) or (params.page lt 1)>
				<cfset params.page = 1>
			</cfif>
			<cfif (REFind("[^0-9]",params.perpage) gt 0) or (params.perpage lt 1)>
				<cfset params.perpage = 10>
			</cfif>
			<cfif REFindNoCase("[^MF]",params.gender) gt 0>
				<cfset params.gender = "">
			</cfif>
			<cfif REFind("[^0-9]",params.language) gt 0>
				<cfset params.language = 0>
			</cfif>
			<cfset latitude = 0>
			<cfset longitude = 0>
			<cfset citySuggestion = "">

			<cfif params.city eq "" and params.state eq "" and params.zipCode eq "">
				<cfif params.location neq "">
					<!--- If a location string is specified, parse it --->
					<cfset location = ParseLocation(params.location,countryID,false)>

					<cfif location.cityFound>
						<cfset params.city = location.city>
						<cfif not location.stateFound and StructCount(location._alternates) gt 1>
							<cfloop collection="#location._alternates#" item="locationKey">
								<cfset alternativeLocation = StructFind(location._alternates,locationKey)>
							 	<cfset citySuggestion = ListAppend(citySuggestion,alternativeLocation.cityname & ", " & alternativeLocation.stateabbr,"|")>
							</cfloop>
							<cfset citySuggestion = ListSort(citySuggestion,"text","asc","|")>
						</cfif>
					</cfif>
					<cfif location.stateFound>
						<cfset params.state = location.state>
						<cfif location.cityFound><cfset countryID = location.country></cfif>

						<cfif NOT location.cityFound AND location.STATESILONAME NEQ "">
							<!--- Something else is in the location variable besides a city. Redirect to just a state search for this query type --->

							<!--- <cfoutput>
								<cfdump var="#params#" label="params">
								<cfdump var="#location#" label="location">
							</cfoutput> --->


							<cfif params.siloLocation NEQ params.state AND params.siloLocation NEQ "">
								<!--- http://carlos3.locateadoc.com/doctors/lip-augmentation/srasota-fl/distance-25/specialty-25/gender-m --->
								<cfset newSiloURL = replaceNoCase(params.siloURL, params.siloLocation, location.STATESILONAME)>
								<cflocation addtoken="false" statuscode="301" url="#newSiloURL#">

							<cfelseif NOT listFindNoCase(params.siloURL, location.STATESILONAME, "/") AND params.siloLocation EQ "" AND trim(params.location) NEQ "">
								<!--- http://carlos3.locateadoc.com/doctors/pbg-fl/page-45 --->

								<cfset newLocation = ListChangeDelims(ReReplace(params.location, "\s", ""), "-")>
								<cfset newSiloURL = replaceNoCase(params.siloURL, newLocation, location.STATESILONAME)>

								<!--- <cfoutput>
									<p>params.siloURL = #params.siloURL#</p>
									<p>location.STATESILONAME = #location.STATESILONAME#</p>
									<p>location.state = #location.state#</p>
									<p>location.stateabbr = #location.stateabbr#</p>
									<p>params.location = #params.location#</p>
									<p>newSiloURL = #newSiloURL#</p>
									<p>newLocation = #newLocation#</p>
								</cfoutput> --->

								<cfif newSiloURL NEQ params.siloURL>
									<!--- Make sure the new and previous silo url aren't equal, to prevent a redirect loop --->
									<cflocation addtoken="false" statuscode="301" url="#newSiloURL#">
								<cfelseif isnumeric(location.state) AND val(location.state) GT 0>
									<!--- 	Check if the city is an abbreviation and redirect to full city name
											http://www.locateadoc.com/doctors/sunny-isles-bch-fl ->
											http://www.locateadoc.com/doctors/sunny-isles-beach-fl

									--->
									<cfset parseCity = replaceNoCase(params.siloURL, "/doctors/", "")>
									<cfset parseCitySiloName = replaceNoCase(parseCity, "-" & location.stateabbr, "")>
									<cfset parseCity = replaceNoCase(parseCitySiloName, "-", " ", "all")>

									<!--- <cfoutput>
										<p>parseCitySiloName = #parseCitySiloName#</p>
										<p>parseCity = #parseCity#</p></cfoutput> --->

									<!--- <cfquery datasource="myLocateadocLB3" name="qCityFull">
										SELECT cities.siloNameNew
										FROM cityabbreviations ca
										INNER JOIN cities ON cities.name = ca.fullName AND cities.deletedAt IS NULL
										INNER JOIN cities AS cities2 ON cities2.id = cities.id AND cities2.deletedAt IS NULL
															AND cities2.stateId = <cfqueryparam cfsqltype="cf_sql_integer" value="#location.state#">
										WHERE ca.shortName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#parseCity#"> AND ca.deletedAt IS NULL
									</cfquery> --->

									<cfset qCityFull = model("City").AbbreviationToFullName(	stateId = location.state,
																							abbreviation	= parseCity)>

									<cfif qCityFull.recordCount GT 0>
										<cfset newSiloURL = replaceNoCase(params.siloURL, parseCitySiloName, qCityFull.siloNameNew)>

										<!--- <cfoutput>
										<p>qCityFull.siloNameNew = #qCityFull.siloNameNew#</p>
										<p>newSiloURL = #newSiloURL#</p>
										</cfoutput><cfabort> --->


										<cflocation addtoken="false" statuscode="301" url="#newSiloURL#">

									</cfif>

								</cfif>
							</cfif>

						</cfif>
					</cfif>

					<cfif location.zipFound>
						<cfset params.zipCode = location.zipCode>
						<cfset latitude = location.latitude>
						<cfset longitude = location.longitude>
						<cfset citySuggestion = location.cityname & ", " & location.stateabbr>
						<cfset countryID = location.country>
					</cfif>

					<cfif params.city eq "" and params.state eq "" and params.zipCode eq "">
						<cfif REFind("location-[^/]+",CGI.HTTP_REFERER)>
							<!--- If the location was not found, check to see if the referring page had a
							  location specified. If so, the user likely changed the location to an invalid
							  string. Use the old location. --->
							<cfset newLocationSearch = REFind("location-[^/]+",CGI.HTTP_REFERER,1,true)>
							<cfset newLocation = URLDecode(Replace(Mid(CGI.HTTP_REFERER,newLocationSearch.pos[1],newLocationSearch.len[1]),"location-",""))>
							<cfset location = ParseLocation(newLocation,countryID,false)>
							<cfif location.cityFound or location.stateFound or location.zipFound>
								<cfset Client.locationError = '"#Replace(params.location,"_"," ","all")#" was invalid. Using previous location.'>
								<cfset redirectTo(back=true)>
							</cfif>
						<cfelse>
							<!--- If not, then rig the search to find nothing due to an invalid location. --->
							<cfset params.zipCode = "">
							<cfset params.city = -1>
							<cfset params.state = -1>
						</cfif>
					</cfif>
				</cfif>
			</cfif>

			<!--- If no criteria is specified, take the user to the search form --->
			<cfif params.name eq "" and params.procedure eq "" and params.specialty eq "" and params.bodypart eq ""
				and params.city eq "" and params.state eq "" and params.zipCode eq "">
				<cfset redirectTo(controller="doctors")>
			<cfelseif params.name eq "" and params.procedure eq "" and params.specialty eq "" and params.bodypart eq ""
				and params.city eq "" and params.zipCode eq "" AND val(params.state) GT 0 AND location.stateSiloName NEQ "">
				<!--- If a an invalid city is searched, and a valid state exists, then redirect to the state results
						http://www.locateadoc.com/doctors/pbg-fl/page-45
						http://carlos3.locateadoc.com/doctors/lip-augmentation/srasota-fl/distance-25/specialty-25/gender-m
				 --->

				<cfset local.pageNumber = "">
				<cfif val(params.page) GT 0>
					<cfset local.pageNumber = "/page-" & val(params.page)>
				</cfif>

				<cflocation addtoken="false" statuscode="301" url="/doctors/#location.stateSiloName##local.pageNumber#">
			</cfif>


			<cfif params.country EQ "us" AND params.state neq "">
				<!--- Detect if country-us was expiclity added to a url with a state and redirect to a plain url --->
				<cfset findCountryInList = listFindNoCase(params.siloURL, "country-us", "/")>
				<cfif findCountryInList GT 0 AND listLen(params.siloURL, "/") GT 2>
					<!--- http://carlos3.locateadoc.com/doctors/michigan/country-us --->

					<cfset newSiloURL = listDeleteAt(params.siloURL, findCountryInList, "/")>
					<cflocation addtoken="false" statuscode="301" url="#newSiloURL#">
				</cfif>
			</cfif>

			<!--- If the distance is not specified and the search will not return any results
			      from the specified location alone, then add a distance to the search criteria --->
			<cfif val(params.distance) eq 0 and (params.zipCode neq "" or (val(params.city) gt 0 and val(params.state) gt 0))>
				<cfset searchCheck = model("accountDoctorLocation").testLocation(
					country =		countryID,
					zipCode =		params.zipCode,
					city =			val(params.city),
					state =			val(params.state),
					doctorName =	params.name,
					procedureId =	val(params.procedure),
					specialtyId =	val(params.specialty)
				)>
				<cfif searchCheck gt 0 and searchCheck lte 100>
					<cfset params.distance = searchCheck>
					<cfset params.distanceFound = true>
				</cfif>
			</cfif>


		<cfset Local.search = getDoctorSearch(
			procedureId =			val(params.procedure),
			specialtyId =			val(params.specialty),
			country =				countryID,
			distance =				val(params.distance),
			latitude = 				latitude,
			longitude = 			longitude,
			zipCode =				params.zipCode,
			city =					val(params.city),
			state =					val(params.state),
			doctorName =			params.name,
			bodyPartId =			val(params.bodypart),
			gender =				params.gender,
			languageId =			val(params.language),
			sortBy =				params.sortby,
			page =					val(params.page),
			perpage =				val(params.perpage)
		)>

		<cfset doctorType = "Doctor">
		<cfif val(params.specialty)>
			<cfset specialtyInfo = Model('Specialty').findAll(	select="specialties.directoryTopContent,specialties.name,specialties.doctorSingular,specialties.directoryH1Tag,specialties.directoryTitle,specialties.directoryMetaDescription,directoryMetaKeywords",
																where='id=#val(params.specialty)#')>
			<cfset specialtyname = specialtyInfo.name>
			<cfif SpecialtyInfo.doctorSingular neq ""><cfset doctorType = SpecialtyInfo.doctorSingular></cfif>
		</cfif>
		<cfif val(params.procedure)>
			<cfset procedureInfo = Model('Procedure').findAll(where='id=#val(params.procedure)#')>
			<cfset procedurename = #procedureInfo.name#>
			<cfif val(params.specialty) eq 0>
				<cfset specialtyInfo = Model('Specialty').findAll(
					select="specialties.directoryTopContent,specialties.name,specialties.doctorSingular,specialties.directoryH1Tag,specialties.directoryTitle,specialties.directoryMetaDescription,specialties.directoryMetaKeywords",
					include="SpecialtyProcedures(Procedure)",
					where='procedures.id=#val(params.procedure)#',
					$limit="1"
				)>
				<cfset specialtyname = specialtyInfo.name>
				<cfif SpecialtyInfo.doctorSingular neq ""><cfset doctorType = SpecialtyInfo.doctorSingular></cfif>
			</cfif>
		</cfif>

		<cfset Local.search.citySuggestion = citySuggestion>
		<cfset Local.search.searchSummary = "">
		<cfset Local.search.landingHeader = "">
		<cfset Local.search.landingContent = "">
		<cfset Local.search.landingSubHeader = "">
		<cfset local.search.pagetitle = "">
		<cfset local.search.metadescription = "">
		<cfset local.search.stateBreadcrumb = "">

		<cfif val(params.procedure)>
			<cfif val(params.specialty)>
				<cfset local.search.pagetitle = "#specialtyname# Doctors - Find a #procedurename# Doctor">
				<cfset local.search.metadescription = "Find a #LCase(doctorType)# near you using the LocateADoc.com online directory for #LCase(procedurename)# doctors.">
			<cfelseif params.gender neq "">
				<cfset genderString = params.gender eq "M" ? "Male" : "Female">
				<cfset local.search.pagetitle = "#procedurename# Doctors - Find a #genderString# #doctorType#">
				<cfset local.search.metadescription = "Find a #LCase(procedurename)# doctor near you using the LocateADoc.com online directory for #LCase(genderString)# #LCase(specialtyname)# doctors.">
			<cfelseif val(params.language)>
				<cfset languagename = Model("Language").findAll(where="id=#val(params.language)#").name>
				<cfset local.search.pagetitle = "#procedurename# Doctors - Find a#(REFind('^[AEIO]',languagename) ? 'n' : '')# #languagename# speaking #doctorType#">
				<cfset local.search.metadescription = "Find a #LCase(procedurename)# doctor near you using the LocateADoc.com online directory for #languagename# speaking #LCase(specialtyname)# doctors.">
			<cfelseif (val(params.city) gt 0 and val(params.state) gt 0)>
				<cfset local.search.pagetitle = "Find a #procedurename# Doctor in #location.cityname#, #location.statename#">
				<cfset local.search.metadescription = "Doctors in #location.cityname#, #location.stateabbr# who specialize in #procedurename#.">
			<cfelseif val(params.state) gt 0>
				<cfset local.search.pagetitle = "Find a #procedurename# Doctor in #location.statename#">
				<cfset local.search.metadescription = "Doctors in #location.statename# who specialize in #procedurename#.">
			<cfelse>
				<cfset local.search.pagetitle = "#procedurename# Doctors - Find a #doctorType#">
				<cfset local.search.metadescription = "Find a #LCase(procedurename)# doctor near you using the LocateADoc.com online directory for #LCase(specialtyname)# doctors.">
			</cfif>
		<cfelseif val(params.specialty)>
			<cfif (val(params.city) gt 0 and val(params.state) gt 0)>
				<cfset local.search.pagetitle = "#specialtyname# Doctors in #location.cityname#, #location.statename# - Find a #doctorType# in #location.stateabbr#">
				<cfset local.search.metadescription = "Find a good #LCase(doctorType)# in #location.cityname#, #location.statename# using the LocateADoc.com online directory for #LCase(specialtyname)# doctors in #location.cityname#, #location.stateabbr#.">
			<cfelseif val(params.state) gt 0>
				<cfset local.search.pagetitle = "#specialtyname# Doctors in #location.statename# - Find a #doctorType# in #location.stateabbr#">
				<cfset local.search.metadescription = "Find a good #LCase(doctorType)# in #location.statename# using the LocateADoc.com online directory for #LCase(specialtyname)# doctors in #location.stateabbr#.">
			</cfif>
		<cfelseif val(params.bodypart)>
			<cfif (val(params.city) gt 0 and val(params.state) gt 0)>
				<cfset local.search.pagetitle = "#singularize(Model('BodyPart').findAll(select='name',where='id='&val(params.bodypart)).name)# Doctors in #location.cityname#, #location.statename#">
			<cfelse>
				<cfset local.search.pagetitle = "#singularize(Model('BodyPart').findAll(select='name',where='id='&val(params.bodypart)).name)# Doctors">
			</cfif>
		<cfelseif (val(params.city) gt 0 and val(params.state) gt 0) and not (params.name neq "" or val(params.language) or params.gender neq "")>
			<cfset local.search.pagetitle = "Find a Doctor in #location.cityname#, #location.statename#">
		</cfif>



		<cfif val(params.specialty) and not
		(params.zipCode neq "" or val(params.procedure) or val(params.bodypart)
		or params.name neq "" or val(params.language) or params.gender neq "")>
			<cfif val(params.state) AND NOT val(params.city)>
				<cfset landingInfo = Model('SpecialtyStates').findAll(
					where='specialtyId=#val(params.specialty)# AND stateId=#val(params.state)#'
				)>
				<cfset Local.search.landingHeader = landingInfo.directoryH1Tag neq "" ? landingInfo.directoryH1Tag : "#specialtyname# Doctors in #location.statename#">
				<cfset Local.search.landingContent = landingInfo.directoryTopContent>
				<cfset Local.search.landingSubHeader = "#specialtyname# Doctors in #location.statename#">
				<cfif landingInfo.directoryTitle neq ""><cfset local.search.pagetitle = landingInfo.directoryTitle></cfif>
				<cfif landingInfo.directoryMetaDescription neq ""><cfset local.search.metadescription = landingInfo.directoryMetaDescription></cfif>
				<cfif landingInfo.directoryMetaKeywords neq ""><cfset metaKeywordsContent = landingInfo.directoryMetaKeywords></cfif>

			<cfelseif val(params.state) AND val(params.city)>

				<cfset landingInfo = Model('SpecialtyStateCity').findAll(
					where='specialtyId=#val(params.specialty)# AND stateId=#val(params.state)# AND cityId=#val(params.city)#'
				)>

				<cfset Local.search.landingHeader = landingInfo.directoryH1Tag neq "" ? landingInfo.directoryH1Tag : "#specialtyname# Doctors in #location.cityname#, #location.statename#">
				<cfset Local.search.landingContent = landingInfo.directoryTopContent>
				<cfset Local.search.landingSubHeader = "#specialtyname# Doctors in #location.statename#">
				<cfif landingInfo.directoryTitle neq ""><cfset local.search.pagetitle = landingInfo.directoryTitle></cfif>
				<cfif landingInfo.directoryMetaDescription neq ""><cfset local.search.metadescription = landingInfo.directoryMetaDescription></cfif>
				<cfif landingInfo.directoryMetaKeywords neq ""><cfset metaKeywordsContent = landingInfo.directoryMetaKeywords></cfif>

			<cfelse>
				<cfset Local.search.landingHeader = specialtyInfo.directoryH1Tag neq "" ? specialtyInfo.directoryH1Tag : "#specialtyname# Doctors">
				<cfset Local.search.landingContent = specialtyInfo.directoryTopContent>
				<cfset Local.search.landingSubHeader = "#specialtyname# Doctors">
				<cfif countryID gt 0>
					<cfset countryInfo = model("Country").findAll(select="id,name",where="id = "&countryID)>
					<cfset Local.search.landingSubHeader &= ' in #(countryInfo.id eq 102 ? "the " : "") & countryInfo.name#'>
				</cfif>
				<cfif specialtyInfo.directoryTitle neq ""><cfset local.search.pagetitle = specialtyInfo.directoryTitle></cfif>
				<cfif specialtyInfo.directoryMetaDescription neq ""><cfset local.search.metadescription = specialtyInfo.directoryMetaDescription></cfif>
				<cfif specialtyInfo.directoryMetaKeywords neq ""><cfset metaKeywordsContent = specialtyInfo.directoryMetaKeywords></cfif>

			</cfif>
		<cfelseif val(params.procedure) and not
		(params.zipCode neq "" or val(params.specialty) or val(params.bodypart)
		or params.name neq "" or val(params.language) or params.gender neq "")>
			<cfif val(params.city) and val(params.state)>
				<cfset landingInfo = Model('ProcedureStateCities').findAll(
					where='procedureId=#val(params.procedure)# AND cityId=#val(params.city)# AND stateId=#val(params.state)#'
				)>
				<cfset Local.search.landingHeader = landingInfo.directoryH1Tag neq "" ? landingInfo.directoryH1Tag : "#procedurename# Doctors in #location.cityname#, #location.statename#">
				<cfset Local.search.landingContent = landingInfo.directoryTopContent>
				<cfset Local.search.landingSubHeader = "#procedurename# Doctors in #location.cityname#, #location.statename#">
				<cfif landingInfo.directoryTitle neq ""><cfset local.search.pagetitle = landingInfo.directoryTitle></cfif>
				<cfif landingInfo.directoryMetaDescription neq ""><cfset local.search.metadescription = landingInfo.directoryMetaDescription></cfif>
				<cfif landingInfo.directoryMetaKeywords neq ""><cfset metaKeywordsContent = landingInfo.directoryMetaKeywords></cfif>
			<cfelseif val(params.state)>
				<cfset landingInfo = Model('ProcedureStates').findAll(
					where='procedureId=#val(params.procedure)# AND stateId=#val(params.state)#'
				)>
				<cfset Local.search.landingHeader = landingInfo.directoryH1Tag neq "" ? landingInfo.directoryH1Tag : "#procedurename# Doctors in #location.statename#">
				<cfset Local.search.landingContent = landingInfo.directoryTopContent>
				<cfset Local.search.landingSubHeader = "#procedurename# Doctors in #location.statename#">
				<cfif landingInfo.directoryTitle neq ""><cfset local.search.pagetitle = landingInfo.directoryTitle></cfif>
				<cfif landingInfo.directoryMetaDescription neq ""><cfset local.search.metadescription = landingInfo.directoryMetaDescription></cfif>
				<cfif landingInfo.directoryMetaKeywords neq ""><cfset metaKeywordsContent = landingInfo.directoryMetaKeywords></cfif>
			<cfelse>
				<cfset Local.search.landingHeader = procedureInfo.directoryH1Tag neq "" ? procedureInfo.directoryH1Tag : "#procedurename# Doctors">
				<cfset Local.search.landingContent = procedureInfo.directoryTopContent>
				<cfset Local.search.landingSubHeader = "#procedurename# Doctors">
				<cfif countryID gt 0>
					<cfset countryInfo = model("Country").findAll(select="id,name",where="id = "&countryID)>
					<cfset Local.search.landingSubHeader &= ' in #(countryInfo.id eq 102 ? "the " : "") & countryInfo.name#'>
				</cfif>
				<cfif procedureInfo.directoryTitle neq ""><cfset local.search.pagetitle = procedureInfo.directoryTitle></cfif>
				<cfif procedureInfo.directoryMetaDescription neq ""><cfset local.search.metadescription = procedureInfo.directoryMetaDescription></cfif>
				<cfif procedureInfo.directoryMetaKeywords neq ""><cfset metaKeywordsContent = procedureInfo.directoryMetaKeywords></cfif>
			</cfif>
		<cfelse>
			<cfif params.zipCode neq "" or val(params.city) gt 0 or val(params.state) gt 0>
				<cfset Local.search.searchSummary = "Doctors within">
				<cfif val(params.distance) gt 0 and (params.zipCode neq "" or (val(params.city) gt 0 and val(params.state) gt 0))>
					<cfset Local.search.searchSummary &= " #val(params.distance)# miles of">
				</cfif>
				<cfif params.zipCode neq "">
					<cfset Local.search.searchSummary &= " #params.zipCode#">
				<cfelseif (val(params.city) gt 0 and val(params.state) gt 0)>
					<cfset Local.search.searchSummary &= " #location.cityname#, #location.stateabbr#">
				<cfelseif val(params.state) gt 0>
					<cfset Local.search.searchSummary &= " #location.statename#">
				<cfelse>
					<cfset Local.search.searchSummary &= " cities named #location.cityname#">
				</cfif>
			<cfelseif val(params.specialty) gt 0 or params.name neq "" or val(params.language) gt 0 or params.gender neq "">
				<!--- Prevent procedure-only or body part-only labels --->
			<cfelseif val(params.procedure) gt 0 and val(params.bodypart) eq 0>
				<cfset Local.search.searchSummary &= "Doctors who perform #Model('Procedure').findAll(select='name',where='id='&val(params.procedure)).name#">
			<cfelseif val(params.bodypart) gt 0 and val(params.procedure) eq 0>
				<cfset Local.search.searchSummary &= "#singularize(Model('BodyPart').findAll(select='name',where='id='&val(params.bodypart)).name)# Doctors">
			</cfif>
		</cfif>
		<cfif local.search.pagetitle neq "" and val(params.page) gt 1>
			<cfset local.search.pagetitle &= " - Page #val(params.page)#">
		</cfif>
		<cfif (val(params.city) gt 0 and val(params.state) gt 0)>
			<cfset local.search.stateBreadcrumb = LinkTo(controller="doctors",action=model("States").findAll(select="siloName",where="id = #params.state#").siloName,text=location.statename)>
		</cfif>

		<cfreturn Local.search>
	</cffunction>

	<cffunction name="GetCitiesAndStatesWithinDistance" access="private" returntype="struct">
		<cfargument name="latitude"				type="numeric"	required="false" default="0">
		<cfargument name="longitude"			type="numeric"	required="false" default="0">
		<cfargument name="shape"				type="struct"	required="false" default="#{coordinates = [],hull = "",lines=[]}#">
		<cfargument name="distance"				type="numeric"	required="false" default="0">
		<cfargument name="cityIds"				type="string"	required="false" default="">
		<cfargument name="stateIds"				type="string"	required="false" default="">
		<cfargument name="stateAndCityIds"		type="string"	required="false" default="">

		<cfset var local = {}>
		<cfset local.return = {}>
		<cfset local.return.cityIds = "">
		<cfset local.return.stateIds = "">
		<cfset local.return.stateAndCityIds = "">
		<cfset local.return.isOverrideCityIds = true>


		<cfif (arguments.latitude neq 0 and arguments.longitude neq 0) OR arguments.distance gt 0>
			<cfset local.qCities	= model("AccountDoctorLocation").GetCitiesWithinDistance(
									country		= arguments.country,
									distance	= val(arguments.distance),
									latitude	= val(arguments.latitude),
									longitude	= val(arguments.longitude),
									shape		= arguments.shape)>
			<cfif local.qCities.recordCount GT 0>
				<cfset local.return.cityIds = local.qCities.cityIds>
				<cfset local.return.stateIds = local.qCities.stateIds>
				<cfset local.return.stateAndCityIds = local.qCities.stateAndCityIds>
				<cfset local.return.isOverrideCityIds = false>
			</cfif>
		</cfif>

		<cfreturn local.return>
	</cffunction>

	<!--- Builds the search return structure --->
	<cffunction name="getDoctorSearch" access="private" returntype="struct">
		<cfargument name="procedureId"			type="numeric"	required="false" default="0">
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
		<cfargument name="sortBy"				type="string"	required="false" default="nameSort ASC">
		<cfargument name="page"					type="numeric"	required="false" default="1">
		<cfargument name="perpage"				type="numeric"	required="false" default="10">

		<cfset var local = {}>
		<cfset local.return = {}>
		<cfset local.return.page = arguments.page>
		<cfset local.return.perpage = arguments.perpage>
		<cfset local.processedDescription = "">
		<cfset local.filteredDescription = "">
		<cfset local.DistanceCityStates = {}>
		<cfset local.DistanceCityStates.cityIds = "">
		<cfset local.DistanceCityStates.stateIds = "">
		<cfset local.DistanceCityStates.stateAndCityIds = "">
		<cfset local.DistanceCityStates.isOverrideCityIds = true>
		<cfset offset = (arguments.page-1)*arguments.perpage>
		<cfset limit = arguments.perpage>


		<!--- Build search geometry if needed --->
		<cfif arguments.city neq 0 and arguments.state neq 0 and arguments.distance gt 0 and arguments.zipCode eq "">
			<cfset Local.return.plot = plotCity(val(arguments.city),val(arguments.state))>
			<cfset Local.return.plot = enlargeArea(Local.return.plot,val(arguments.distance))>
		<cfelse>
			<cfset Local.return.plot = {coordinates = [],hull = "",lines = [],
										zoneTop = -200,zoneLeft = 200,zoneBottom = 200,zoneRight = -200}>
		</cfif>

		<cfset local.DistanceCityStates = GetCitiesAndStatesWithinDistance(
										latitude	= arguments.latitude,
										longitude	= arguments.longitude,
										shape 		= Local.return.plot,
										country 	= arguments.country,
										distance 	= val(arguments.distance),
										latitude 	= val(arguments.latitude),
										longitude 	= val(arguments.longitude))>


		<!--- Perform the search query --->
		<cfset local.return.results = model("AccountDoctorLocation").doctorSearchMultiQuery(
			info =					"search",
			procedureId =			val(arguments.procedureId),
			specialtyId =			val(arguments.specialtyId),
			country =				arguments.country,
			distance =				val(arguments.distance),
			latitude =				val(arguments.latitude),
			longitude =				val(arguments.longitude),
			zipCode =				arguments.zipCode,
			city =					val(arguments.city),
			state =					val(arguments.state),
			doctorName =			arguments.doctorName,
			bodyPartId =			val(arguments.bodypartId),
			gender = 				arguments.gender,
			languageId = 			val(arguments.languageId),
			shape = 				Local.return.plot,
			sortBy =				arguments.sortby,
			offset =				val(offset),
			limit =					val(limit),
			isOverrideCityIds	=	local.DistanceCityStates.isOverrideCityIds,
			cityIds			=		local.DistanceCityStates.cityIds,
			stateIds		=		local.DistanceCityStates.stateIds,
			stateAndCityIds	=		local.DistanceCityStates.stateAndCityIds
		)>

		<!--- Get the number of records and pages from the full result set --->
		<cfquery datasource="#get('dataSourceName')#" name="local.count">
			Select Found_Rows() AS foundrows
		</cfquery>
		<cfset local.return.totalrecords = local.count.foundrows>
		<cfset local.return.pages = ceiling(local.return.totalrecords/local.return.perpage)>

		<!--- If user mischief results in a page value greater than the number of pages, send them back --->
		<cfif (local.return.pages gte 1) and (local.return.page gt local.return.pages)>
			<cfset redirectTo(back=true)>
		</cfif>

		<cfset startTick = getTickCount()>
		<cfset startTick2Total = 0>
		<cfset startTick3Total = 0>
		<cfset startTick4Total = 0>
		<cfset startTick5Total = 0>

		<cfset local.returnedIds = "">

		<cfif local.return.results.recordCount GT 0 AND isdefined("local.return.results.id")>
			<cfset local.returnedIds = valuelist(local.return.results.id)>
			<cfset local.returnedIds = MakeNumericSet(local.returnedIds)>
		</cfif>

		<cfif ListLen(local.returnedIds)>
			<cfset startDescriptionTick = getTickCount()>
			<cfquery datasource="#get('dataSourceName')#" name="qDescriptions">
				SELECT als.accountDoctorLocationId, ad.content
				FROM accountlocationspecialties als
				INNER JOIN accountdescriptions ad ON als.accountDescriptionId = ad.id
												AND (ad.content <> "" OR ad.content IS NOT NULL) AND ad.deletedAt IS NULL
				WHERE als.accountDoctorLocationId IN (#local.returnedIds#)
						<cfif isnumeric(arguments.specialtyId) AND arguments.specialtyId GT 0>
							AND als.specialtyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.specialtyId#">
						</cfif>
					 AND als.deletedAt IS NULL
				GROUP BY als.accountDoctorLocationId
			</cfquery>

			<cfloop query="local.return.results">
				<cfloop query="qDescriptions">
					<cfif qDescriptions.accountDoctorLocationId EQ local.return.results.ID>
						<cfset local.filteredDescription = selectiveHTMLFilter(qDescriptions.content)>
						<!--- truncate description --->
						<cfset breakLocation = REFind("</?br\s?/?>|</p>|</h2>",local.filteredDescription,100)>
						<cfif (breaklocation gt 0) and REFind("<li>",left(local.filteredDescription,breaklocation)) eq 0 and (Len(local.filteredDescription)-breaklocation) gt 200>
							<cfset breakLocation = REFind(">",local.filteredDescription,breakLocation)>
							<cfset local.processedDescription = Left(local.filteredDescription,breakLocation)>
							<cfif NOT Find("email-view",CGI.QUERY_STRING)>
								<cfset local.processedDescription &= '<p><a href="##description_#local.return.results.ID#" class="show-more-desc">More</a></p>'>
								<cfset local.processedDescription &= '<div id="description_#local.return.results.ID#" style="display:none; margin-bottom:15px;">#Mid(local.filteredDescription,breakLocation+1,Len(local.filteredDescription)-breakLocation)#</div>'>
							<cfelse>
								<cfset local.processedDescription = reReplaceNoCase(local.processedDescription, "</p>$", "...<a href='/#local.return.results.siloName#?l=#local.return.results.locationID#' style='text-decoration: none;'>more</a></p>")>
							</cfif>
						<cfelse>
							<cfset local.processedDescription = local.filteredDescription>
						</cfif>

						<cfif local.return.results.recordCount GTE local.return.results.currentrow>
							<cfset QuerySetCell(local.return.results,"description",local.processedDescription,local.return.results.currentrow)>
						</cfif>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>

		<cfset local.return.filters = {}>
		<cfset local.return.filters.index = "">

		<!---location--->
		<cfset startTick = getTickCount()>
		<cfset local.return.filters.index = ListAppend(local.return.filters.index,"location")>

		<cfif ListFind("12,102", arguments.country) AND (arguments.zipCode neq "" or (arguments.city neq 0 and arguments.state neq 0))>
			<cfset local.return.filters.index = ListAppend(local.return.filters.index,"distance")>
		</cfif>

		<!---procedures--->

		<cftry>
			<cfset var ProcedureCounts = model("AccountDoctorLocation").doctorSearchMultiQuery(
				info =					"procedures",
				procedureId =			val(arguments.procedureId),
				specialtyId =			val(arguments.specialtyId),
				country =				arguments.country,
				distance =				val(arguments.distance),
				latitude =				val(arguments.latitude),
				longitude =				val(arguments.longitude),
				zipCode =				arguments.zipCode,
				city =					val(arguments.city),
				state =					val(arguments.state),
				doctorName =			arguments.doctorName,
				bodyPartId =			val(arguments.bodypartId),
				gender = 				arguments.gender,
				languageId = 			val(arguments.languageId),
				shape = 				Local.return.plot,
				isOverrideCityIds = 	local.DistanceCityStates.isOverrideCityIds,
				cityIds			=		local.DistanceCityStates.cityIds,
				stateIds		=		local.DistanceCityStates.stateIds,
				stateAndCityIds	=		local.DistanceCityStates.stateAndCityIds
			)>
			<cfif ProcedureCounts.recordcount eq 0 and arguments.procedureId neq 0>
				<cfset ProcedureCounts = model("Procedure").findAll(
					select="name,0 as id,1 as doctorcount",
					where="id = #arguments.procedureId#"
				)>
			<cfelseif NOT isdefined("ProcedureCounts.name")>
				<cfset ProcedureCounts.recordCount = 0>
			</cfif>

			<cfset local.return.filters.index = ListAppend(local.return.filters.index,"procedure")>
			<cfset local.return.filters.procedure =		[]>
			<cfif ProcedureCounts.recordCount GT 0>
				<cfloop query="ProcedureCounts">
					<cfif isdefined("ProcedureCounts.name")>
						<cfset ArrayAppend(local.return.filters.procedure,"#ProcedureCounts.id#|#ProcedureCounts.name#|#ProcedureCounts.doctorcount#")>
					</cfif>
				</cfloop>
			</cfif>
			<cfcatch>
				<cfset dumpStruct = {local=local}>
				<cfif isDefined("ProcedureCounts")>
					<cfset dumpStruct.ProcedureCounts = ProcedureCounts>
				</cfif>
				<cfset fnCthulhuException(	scriptName="Doctors.cfc",
											message="Error in ProcedureCount",
											detail="Twilight Zone Error",
											dumpStruct=dumpStruct,
											errorCode=408
											)>
			</cfcatch>
		</cftry>
		<!---specialties--->
		<cftry>
			<cfset var SpecialtyCounts = model("AccountDoctorLocation").doctorSearchMultiQuery(
				info =					"specialties",
				procedureId =			val(arguments.procedureId),
				specialtyId =			val(arguments.specialtyId),
				country =				arguments.country,
				distance =				val(arguments.distance),
				latitude =				val(arguments.latitude),
				longitude =				val(arguments.longitude),
				zipCode =				arguments.zipCode,
				city =					val(arguments.city),
				state =					val(arguments.state),
				doctorName =			arguments.doctorName,
				bodyPartId =			val(arguments.bodypartId),
				gender = 				arguments.gender,
				languageId = 			val(arguments.languageId),
				shape = 				Local.return.plot,
				isOverrideCityIds = 	local.DistanceCityStates.isOverrideCityIds,
				cityIds			=		local.DistanceCityStates.cityIds,
				stateIds		=		local.DistanceCityStates.stateIds,
				stateAndCityIds	=		local.DistanceCityStates.stateAndCityIds
			)>


			<cfif SpecialtyCounts.recordcount eq 0 and arguments.specialtyId neq 0>
				<cfset SpecialtyCounts = model("Specialty").findAll(
					select="name,0 as id,1 as doctorcount",
					where="id = #arguments.specialtyId#"
				)>
			<cfelseif NOT isdefined("SpecialtyCounts.name")>
				<cfset SpecialtyCounts.recordCount = 0>
			</cfif>
			<cfset local.return.test = SpecialtyCounts>

			<cfset local.return.filters.index = ListAppend(local.return.filters.index,"specialty")>
			<cfset local.return.filters.specialty =	[]>
			<cfif SpecialtyCounts.recordCount GT 0>
				<cfloop query="SpecialtyCounts">
					<cfif isdefined("SpecialtyCounts.name")>
						<cfset ArrayAppend(local.return.filters.specialty,"#SpecialtyCounts.id#|#SpecialtyCounts.name#|#SpecialtyCounts.doctorcount#")>
					</cfif>
				</cfloop>
			</cfif>
			<cfcatch>
				<cfset dumpStruct = {local=local}>
				<cfif isDefined("SpecialtyCounts")>
					<cfset dumpStruct.SpecialtyCounts = SpecialtyCounts>
				</cfif>
				<cfset fnCthulhuException(	scriptName="Doctors.cfc",
											message="Error in SpecialtyCounts",
											detail="Twilight Zone Error",
											dumpStruct=dumpStruct,
											errorCode=408
											)>
			</cfcatch>
		</cftry>

		<!---genders--->
		<cftry>
			<cfset var GenderCounts = model("AccountDoctorLocation").doctorSearchMultiQuery(
				info =					"gender",
				procedureId =			val(arguments.procedureId),
				specialtyId =			val(arguments.specialtyId),
				country =				arguments.country,
				distance =				val(arguments.distance),
				latitude =				val(arguments.latitude),
				longitude =				val(arguments.longitude),
				zipCode =				arguments.zipCode,
				city =					val(arguments.city),
				state =					val(arguments.state),
				doctorName =			arguments.doctorName,
				bodyPartId =			val(arguments.bodypartId),
				gender = 				arguments.gender,
				languageId = 			val(arguments.languageId),
				shape = 				Local.return.plot,
				isOverrideCityIds = 	local.DistanceCityStates.isOverrideCityIds,
				cityIds			=		local.DistanceCityStates.cityIds,
				stateIds		=		local.DistanceCityStates.stateIds,
				stateAndCityIds	=		local.DistanceCityStates.stateAndCityIds
			)>


			<cfif GenderCounts.recordcount eq 0 and arguments.gender neq "">
				<cfset QueryAddRow(GenderCounts)>
				<cfset QuerySetCell(GenderCounts, "name","#arguments.gender#")>
				<cfset QuerySetCell(GenderCounts, "id",0)>
				<cfset QuerySetCell(GenderCounts, "doctorcount",1)>
			<cfelseif NOT isdefined("GenderCounts.name")>
				<cfset GenderCounts.recordCount = 0>
			</cfif>

			<cfset local.return.filters.index = ListAppend(local.return.filters.index,"gender")>
			<cfset local.return.filters.gender =			[]>
			<cfif GenderCounts.recordCount GT 0>
				<cfloop query="GenderCounts">
					<cfif isdefined("GenderCounts.name")>
						<cfswitch expression="#GenderCounts.name#">
							<cfcase value="F"><cfset genderName = "Female"></cfcase>
							<cfcase value="M"><cfset genderName = "Male"></cfcase>
							<cfdefaultcase><cfset genderName = ""></cfdefaultcase>
						</cfswitch>
						<cfif genderName neq "">
							<cfif isdefined("GenderCounts.name")>
								<cfset ArrayAppend(local.return.filters.gender,"#GenderCounts.id#|#genderName#|#GenderCounts.doctorcount#")>
							</cfif>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
			<cfcatch>
				<cfset dumpStruct = {local=local}>
				<cfif isDefined("GenderCounts")>
					<cfset dumpStruct.GenderCounts = GenderCounts>
				</cfif>
				<cfset fnCthulhuException(	scriptName="Doctors.cfc",
											message="Error in GenderCounts",
											detail="Twilight Zone Error",
											dumpStruct=dumpStruct,
											errorCode=408
											)>
			</cfcatch>
		</cftry>

		<!---body parts--->
		<cftry>
			<cfset var BodyPartCounts = model("AccountDoctorLocation").doctorSearchMultiQuery(
				info =					"bodyparts",
				procedureId =			val(arguments.procedureId),
				specialtyId =			val(arguments.specialtyId),
				country =				arguments.country,
				distance =				val(arguments.distance),
				latitude =				val(arguments.latitude),
				longitude =				val(arguments.longitude),
				zipCode =				arguments.zipCode,
				city =					val(arguments.city),
				state =					val(arguments.state),
				doctorName =			arguments.doctorName,
				bodyPartId =			val(arguments.bodypartId),
				gender = 				arguments.gender,
				languageId = 			val(arguments.languageId),
				shape = 				Local.return.plot,
				isOverrideCityIds = 	local.DistanceCityStates.isOverrideCityIds,
				cityIds			=		local.DistanceCityStates.cityIds,
				stateIds		=		local.DistanceCityStates.stateIds,
				stateAndCityIds	=		local.DistanceCityStates.stateAndCityIds
			)>

			<cfif NOT isdefined("BodyPartCounts.name")>
				<cfset BodyPartCounts.recordCount = 0>
			</cfif>

			<cfset local.return.filters.index = ListAppend(local.return.filters.index,"bodypart")>
			<cfset local.return.filters.bodypart = []>
			<cfif BodyPartCounts.recordCount GT 0>
				<cfloop query="BodyPartCounts">
					<cfif isdefined("BodyPartCounts.name")>
						<cfset ArrayAppend(local.return.filters.bodypart,"#BodyPartCounts.id#|#BodyPartCounts.name#|#BodyPartCounts.doctorcount#")>
					</cfif>
				</cfloop>
			</cfif>
			<cfcatch>
				<cfset dumpStruct = {local=local}>
				<cfif isDefined("BodyPartCounts")>
					<cfset dumpStruct.BodyPartCounts = BodyPartCounts>
				</cfif>
				<cfset fnCthulhuException(	scriptName="Doctors.cfc",
											message="Error in BodyPartCounts",
											detail="Twilight Zone Error",
											dumpStruct=dumpStruct,
											errorCode=408
											)>
			</cfcatch>
		</cftry>

		<!---languages--->
		<cftry>
			<cfset var LanguageCounts = model("AccountDoctorLocation").doctorSearchMultiQuery(
				info =					"languages",
				procedureId =			val(arguments.procedureId),
				specialtyId =			val(arguments.specialtyId),
				country =				arguments.country,
				distance =				val(arguments.distance),
				latitude =				val(arguments.latitude),
				longitude =				val(arguments.longitude),
				zipCode =				arguments.zipCode,
				city =					val(arguments.city),
				state =					val(arguments.state),
				doctorName =			arguments.doctorName,
				bodyPartId =			val(arguments.bodypartId),
				gender = 				arguments.gender,
				languageId = 			val(arguments.languageId),
				shape = 				Local.return.plot,
				isOverrideCityIds = 	local.DistanceCityStates.isOverrideCityIds,
				cityIds			=		local.DistanceCityStates.cityIds,
				stateIds		=		local.DistanceCityStates.stateIds,
				stateAndCityIds	=		local.DistanceCityStates.stateAndCityIds
			)>

			<cfif NOT isdefined("LanguageCounts.name")>
				<cfset LanguageCounts.recordCount = 0>
			</cfif>

			<cfset local.return.filters.index = ListAppend(local.return.filters.index,"language")>
			<cfset local.return.filters.language = []>
			<cfif LanguageCounts.recordCount GT 0>
				<cfloop query="LanguageCounts">
					<cfif isdefined("LanguageCounts.name")>
						<cfset ArrayAppend(local.return.filters.language,"#LanguageCounts.id#|#LanguageCounts.name#|#LanguageCounts.doctorcount#")>
					</cfif>
				</cfloop>
			</cfif>
			<cfcatch>
				<cfset dumpStruct = {local=local}>
				<cfif isDefined("LanguageCounts")>
					<cfset dumpStruct.LanguageCounts = LanguageCounts>
				</cfif>
				<cfset fnCthulhuException(	scriptName="Doctors.cfc",
											message="Error in LanguageCounts",
											detail="Twilight Zone Error",
											dumpStruct=dumpStruct,
											errorCode=408
											)>
			</cfcatch>
		</cftry>

		<!--- Get featured doctor list --->
		<cfset local.return.featured = model("AccountDoctorLocation").GetFeatured(
			procedureId =			val(arguments.procedureId),
			specialtyId =			val(arguments.specialtyId),
			country =				arguments.country,
			distance =				val(arguments.distance),
			latitude =				val(arguments.latitude),
			longitude =				val(arguments.longitude),
			zipCode =				arguments.zipCode,
			city =					val(arguments.city),
			state =					val(arguments.state),
			doctorName =			arguments.doctorName,
			bodyPartId =			val(arguments.bodypartId),
			gender = 				arguments.gender,
			limit =					18,
			isOverrideCityIds = 	local.DistanceCityStates.isOverrideCityIds,
			cityIds			=		local.DistanceCityStates.cityIds,
			stateIds		=		local.DistanceCityStates.stateIds,
			stateAndCityIds	=		local.DistanceCityStates.stateAndCityIds,
			usePowerPosition=		true,
			recordHit		=		true,
			thisAction		=		params.action,
			thisController	=		params.controller
		)>

		<!--- Get data for map view --->
		<cfset local.return.map = model("PostalCode").getMapInfo(
			country=arguments.country,
			zipCode=arguments.zipCode,
			city=arguments.city,
			state=arguments.state
		)>

		<!--- Determine zoom level --->
		<cfif arguments.zipCode neq ''>
			<cfif distance gte 25>
				<cfset local.return.zoom = 10>
			<cfelseif distance gte 10>
				<cfset local.return.zoom = 11>
			<cfelseif distance gte 5>
				<cfset local.return.zoom = 12>
			<cfelse>
				<cfset local.return.zoom = 13>
			</cfif>
		<cfelseif arguments.city neq 0 and arguments.state neq 0>
			<cfset local.return.zoom = 11>
		<cfelseif arguments.state neq 0>
			<cfset local.return.zoom = 6>
		<cfelse>
			<cfif arguments.country eq 12>
				<cfset local.return.zoom = 3>
			<cfelse>
				<cfset local.return.zoom = 4>
			</cfif>
		</cfif>
		<cfreturn local.return>
	</cffunction>


	<cffunction name="recordHit" access="private">
		<cfset var keylist = "">

		<cfparam name="params.country"				default="">
		<cfparam name="params.state"				default="">
		<cfparam name="params.city" 				default="">
		<cfparam name="params.zipCode" 				default="">
		<cfparam name="params.distance" 			default="">
		<cfparam name="params.name" 				default="">
		<cfparam name="params.bodypart" 			default="">
		<cfparam name="params.procedure"			default="">
		<cfparam name="params.specialty"			default="">

		<cfset params.country = val(params.country)>
		<cfset params.state = val(params.state)>
		<cfset params.city = val(params.city)>
		<cfset params.distance = val(params.distance)>
		<cfset params.bodypart = val(params.bodypart)>
		<cfset params.procedure = val(params.procedure)>
		<cfset params.specialty = val(params.specialty)>

		<cfif not Client.IsSpider>

			<cfset keylist = REReplace(LCase(CGI.PATH_INFO),'/?(#LCase(params.controller)#|#LCase(params.action)#)/?','','all')>

			<cfif params.country neq "" and val(params.country) eq 0>
				<cfset countryID = model("Country").findAll(select="id",where="abbreviation='#params.country#'")>
				<cfset params.country = countryID.id>
			</cfif>
			<cfif not isNumeric(params.country)>
				<cfset params.country = "">
			</cfif>

			<cfset model("HitsDoctor").RecordHit(
										thisAction		= params.action,
										thisController	= params.controller,
										keylist			= keylist,
										specialtyId		= params.specialty,
										procedureId		= params.procedure,
										postalCode		= params.zipCode,
										stateId			= params.state,
										cityId			= params.city,
										distance		= params.distance,
										bodyPartId		= params.bodypart,
										countryId		= params.country,
										lastName		= params.name)>

		</cfif>
	</cffunction>

</cfcomponent>
