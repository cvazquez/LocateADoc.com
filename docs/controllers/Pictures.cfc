<cfcomponent extends="Controller" output="false">

	<cfif server.thisServer EQ "dev">
		<cfset galleryImageBase	= "http://dev3.locateadoc.com/images/gallery">
		<cfset galleryImagePath	= "/export/home/dev3.locateadoc.com/docs/images/gallery">
		<cfset prodImgBase		= "http://dev3.locateadoc.com/images/gallery/thumb">
		<!--- doctor photos --->
		<cfset doctorImageBase	= "http://dev3.locateadoc.com/images/profile/doctors">
		<cfset doctorImagePath	= "/export/home/dev3.locateadoc.com/docs/images/profile/doctors">
		<cfset doctorImagePathOld= "/export/home/locateadoc.com/docs/images/doctor/photos">
		<cfset doctorImageThumbBase	= "http://dev3.locateadoc.com/images/profile/doctors/thumb">
	<cfelse>
		<cfset galleryImageBase	= "/images/gallery">
		<cfset galleryImagePath	= "/export/home/locateadoc.com/docs/images/gallery">
		<cfset prodImgBase		= "/images/gallery/thumb">
		<!--- doctor photos --->
		<cfset doctorImageBase	= "/images/profile/doctors">
		<cfset doctorImagePath	= "/export/home/locateadoc.com/docs/images/profile/doctors">
		<cfset doctorImagePathOld= "/export/home/locateadoc.com/docs/images/doctor/photos">
		<cfset doctorImageThumbBase	= "/images/profile/doctors/thumb">
	</cfif>

	<cfset LAD2galleryImagePath	= "/export/home/locateadoc.com/docs/pictures">
	<cfset LAD2uploadImagePath	= "/export/home/locateadoc.com/docs/images/gallery/uploaded">
	<cfset LAD3galleryImagePath	= galleryImagePath>

	<cfif server.thisServer EQ "dev">
		<cfset LAD2galleryImageBase	= "http://dev3.locateadoc.com/pictures">
	<cfelse>
		<cfset LAD2galleryImageBase	= prodImgBase>
	</cfif>

	<cfset breadCrumbs			= []>
	<cfset arrayAppend(breadCrumbs,linkTo(href="/",text="Home"))>
	<cfset arrayAppend(breadCrumbs,linkTo(controller="pictures",text="Before and After Gallery"))>

	<cfset displayAd = TRUE>
	<cfset explicitAd = FALSE>

	<cfparam name="client.locationstring" default="">

	<cffunction name="init">
		<cfset usesLayout(template="/nolayout",only="filterresults")>
		<cfset usesLayout("checkPrint")>
		<cfset provides("html,json")>
		<cfset filters(through="recordHit",type="after")>
	</cffunction>

	<cffunction name="checkPrint">
		<cfif structKeyExists(params, "print-view")>
			<cfreturn "/print">
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>

	<!---Actions--->
	<cffunction name="index">
		<cfset isMobile = FALSE>
		<cfset mobileSuffix = "">

		<cfset title = "Before And After Photos">
		<cfset metaDescriptionContent = "See before and after photos for over 100 different procedures, and filter the photos by body part, gender, age, weight, doctor, and location!">

		<cfset procedures		= getProcedures()>
		<cfset femaleBodyParts		= getBodyParts(2)>
		<cfset maleBodyParts		= getBodyParts(1)>
		<cfset regionDots		= getRegionDots()>
		<cfset countries		= model("Country").findAll(	select	= "name",
															order	= "name asc")>
		<cfset genders			= model("GalleryGender").findAll(select	= "id,name")>
		<cfset selectValues()>
		<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=15, paramsAction = params.action, paramsController = params.controller)>
		<cfif isDefined("client.city") and isDefined("client.state") and client.city gt 0 and client.state gt 0>
			<cfset cityInfo			= model("Cities").findAll(select="name",where="id=#client.city#")>
			<cfset stateInfo		= model("State").findAll(select="abbreviation",where="id=#client.state#")>
			<cfset featuredDoctorsLink 	= "/doctors/#LCase(Replace(CityInfo.name," ","_","all")&'-'&StateInfo.abbreviation)#">
		<cfelse>
			<cfset featuredDoctorsLink 	= "/doctors">
		</cfif>

		<cfset activeTab = 3>
		<cftry>
			<cfif IsDefined("Client.lastgallerysearch") and REFind("/pictures/[^/]+$",CGI.HTTP_REFERER) GT 0>
				<cfset lastGallerySearch = DeserializeJSON(Client.lastGallerySearch)>
				<cfif IsDefined("lastGallerySearch.procedure") and val(lastGallerySearch.procedure) gt 0>
					<cfset lastSilo = model("Procedure").findAll(select="siloName",where="id = #val(lastGallerySearch.procedure)#").siloName>
					<cfif lastSilo neq "" and REFind("/pictures/#lastSilo#$",CGI.HTTP_REFERER) GT 0>
						<cfset activeTab = 1>
					</cfif>
				</cfif>
			</cfif>
			<cfcatch><cfset activeTab = 3></cfcatch>
		</cftry>

		<cfset Request.mobileLayout = true>
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>

			<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=8,censored=true)>
			<cfif isDefined("client.city") and isDefined("client.state") and client.city gt 0 and client.state gt 0>
				<cfset cityInfo			= model("Cities").findAll(select="name",where="id=#client.city#")>
				<cfset stateInfo		= model("State").findAll(select="abbreviation",where="id=#client.state#")>
				<cfset locationSilo 	= "/location-#LCase(Replace(CityInfo.name," ","_","all")&'-'&StateInfo.abbreviation)#">
			<cfelse>
				<cfset locationSilo 	= "">
			</cfif>
			<cfset displayCasesDoctorName = TRUE>

			<cfset bodyParts = model("BodyRegion").findAll(
			select  = "DISTINCT bodyregions.name AS bodyRegionName,bodyparts.name AS bodyPartName,
						procedures.name AS procedureName,procedures.id AS procedureId,procedures.siloName",
			include	= "bodyParts(procedureBodyParts(procedure(resourceGuideProcedures(resourceGuide))))",
			where = "procedures.isPrimary = 1 AND resourceguides.content is not null",
			order	= "bodyregions.name asc, bodyparts.name asc, procedures.name asc"
		)>

			<cfset isMobile = TRUE>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="recentlyadded">
		<cfset Request.overrideDebug = "false">
		<cfset topPictures = model("GalleryCase").getPracticeRankedGallery(limit=8,censored=true)>
		<cfif isDefined("client.city") and isDefined("client.state") and client.city gt 0 and client.state gt 0>
			<cfset cityInfo			= model("Cities").findAll(select="name",where="id=#client.city#")>
			<cfset stateInfo		= model("State").findAll(select="abbreviation",where="id=#client.state#")>
			<cfset locationSilo 	= "/location-#LCase(Replace(CityInfo.name," ","_","all")&'-'&StateInfo.abbreviation)#">
		<cfelse>
			<cfset locationSilo 	= "">
		</cfif>
		<cfset renderPartial("/pictures/newlyadded")>
	</cffunction>

	<cffunction name="search">
		<cfparam name="params.rewrite" default="0">
		<cfparam name="params.silogender" default="">
		<cfparam name="params.silobodypart" default="">
		<cfparam name="params.siloprocedurename" default="">
		<cfparam name="params.silolocation" default="">
		<cfset var Local = {}>
		<cfset isMobile = false>
		<cfset mobileSuffix = "">

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

			<!--- Exception for malformed URLs --->
			<cfif ListFind("male,female",params.siloprocedurename)>
				<cfset Local.filtersilo &= "/gender-#params.siloprocedurename eq "male" ? 1 : 2#">
				<cflocation url="http://#CGI.SERVER_NAME#/pictures#Local.filterSilo#" addtoken="no" statuscode="301">
			</cfif>

			<!--- Silo / un-silo URLs --->
			<cfif params.siloprocedurename neq "">
				<!--- Procedure siloed --->
				<cfset Local.siloProcedure = model("Procedure").findOneBySiloName(value=params.siloprocedurename, select="id")>
				<cfif isObject(Local.siloProcedure)>
					<cfset siloedFilters = "/procedure-#Local.siloProcedure.id#">
					<cfset siloedNames = "/#params.siloprocedurename#">
					<cfset params["filter#Local.newFilterId#"] = "procedure-#Local.siloProcedure.id#">
					<!--- Check location --->
					<cfif params.silolocation neq "">
						<!--- Location siloed --->
						<cfset Local.location = ReReplace(LCase(params.silolocation), "[^a-z]+", "-")>
						<cfif not fnIsSiloLocation(Local.location)>
							<!--- Not valid silo name -> un-silo it --->
							<cfset Local.filtersilo &= "/location-#Local.location#">
							<cflocation url="http://#CGI.SERVER_NAME#/pictures/#params.siloprocedurename##Local.filterSilo#" addtoken="no" statuscode="301">
						<cfelseif params.silolocation neq Local.location>
							<!--- Silo location is not correctly formatted -> redirect to cerrect silo name --->
							<cflocation url="http://#CGI.SERVER_NAME#/pictures/#params.siloprocedurename#/#Local.location##Local.filterSilo#" addtoken="no" statuscode="301">
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
						<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/location-[^/]+", "", "all")>
						<cflocation url="http://#CGI.SERVER_NAME#/pictures/#params.siloprocedurename#/#Local.filterStruct["location"]##Local.filterSilo#" addtoken="no" statuscode="301">
					</cfif>
				<cfelse>
					<cfset Local.siloProcedure = model("Procedure").findOneBySiloName(value=params.siloprocedurename, select="id", includeSoftDeletes="true")>
					<cfif isObject(Local.siloProcedure)>
						<cfset Local.procedureRedirect = model("procedureRedirect").findOneByProcedureIdFrom(value=Local.siloProcedure.id, select="procedureIdTo", order="id DESC")>
						<cfif isObject(Local.procedureRedirect)>
							<cfset Local.siloProcedure = model("Procedure").findByKey(key=Local.procedureRedirect.procedureIdTo, select="siloName")>
							<cflocation url="#ReplaceNoCase(params.silourl, params.siloprocedurename, Local.siloProcedure.siloName)#" addtoken="no" statuscode="301">
						</cfif>
					</cfif>
					<cfset dumpStruct = {params=params, siloProcedure=Local.siloProcedure}>
					<cfset fnCthulhuException(	scriptName="Pictures.cfc",
												message="Can't find procedure (silo name: #params.siloprocedurename#)",
												detail="LADY GAGA, Y U NO JUST TURN TELEPHONE OFF?",
												dumpStruct=dumpStruct,
												redirectURL="/pictures"
												)>
				</cfif>
			<cfelseif structKeyExists(Local.filterStruct, "procedure")>
				<!--- Procedure filter, need to redirect to siloed --->
				<cfset Local.siloProcedure = model("Procedure").findByKey(key=Local.filterStruct["procedure"], select="siloName")>
				<cfif isObject(Local.siloProcedure)>
					<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/procedure-[^/]+", "", "all")>
					<cfif structKeyExists(Local.filterStruct, "location") and fnIsSiloLocation(Local.filterStruct["location"])>
						<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/location-[^/]+", "", "all")>
						<cflocation url="http://#CGI.SERVER_NAME#/pictures/#Local.siloProcedure.siloName#/#fnGetSiloName(Local.filterStruct["location"])##Local.filterSilo#" addtoken="no" statuscode="301">
					<cfelse>
						<cflocation url="http://#CGI.SERVER_NAME#/pictures/#Local.siloProcedure.siloName##Local.filterSilo#" addtoken="no" statuscode="301">
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
					<cfset dumpStruct = {params=params, local=Local, filterStruct=Local.filterStruct}>
					<cfset fnCthulhuException(	scriptName="Pictures.cfc",
												message="Can't find procedure (id: #Local.filterStruct["procedure"]#)",
												detail="APPLE STORE, Y U NO SELL FRUIT?",
												dumpStruct=dumpStruct,
												redirectURL="/pictures"
												)>
				</cfif>
			<cfelseif params.silogender neq "" and params.silobodypart neq "">
				<!--- Body part / gender siloed --->
				<cfset Local.siloBodyPart = model("bodyPart").findOneBySiloName(value=params.silobodypart, select="id")>
				<cfset Local.siloGender = model("galleryGender").findOneByName(value=params.silogender, select="id")>
				<cfif isObject(Local.siloGender) and isObject(Local.siloBodyPart)>
					<cfset siloedFilters = "/gender-#Local.siloGender.id#/bodypart-#Local.siloBodyPart.id#">
					<cfset siloedNames = "/#params.silogender#/#params.silobodypart#">
					<cfset params["filter#Local.newFilterId#"] = "gender-#Local.siloGender.id#">
					<cfset Local.newFilterId += 1>
					<cfset params["filter#Local.newFilterId#"] = "bodypart-#Local.siloBodyPart.id#">
				<cfelse>
					<cfset Local.redirectURL = "/pictures">
					<cfif isObject(Local.siloGender)>
						<cfset Local.redirectURL &= "/gender-#Local.siloGender.id#">
					<cfelseif isObject(Local.siloBodyPart)>
						<cfset Local.redirectURL &= "/bodypart-#Local.siloBodyPart.id#">
					</cfif>
					<cfset dumpStruct = {params=params, local=Local, siloBodyPart=Local.siloBodyPart}>
					<cfset fnCthulhuException(	scriptName="Pictures.cfc",
												message="Can't find gender or body part (gender: #params.silogender#, body part: #params.silobodypart#)",
												detail="TEXTBOOKS, Y U NO HAVE CTRL-F?",
												dumpStruct=dumpStruct,
												redirectURL=Local.redirectURL
												)>
				</cfif>
			<cfelseif structKeyExists(Local.filterStruct, "gender") and structKeyExists(Local.filterStruct, "bodypart")>
				<!--- Have gender filter and body part filter or silo -> silo it --->
				<cfset Local.siloGender = model("galleryGender").findByKey(key=Local.filterStruct["gender"], select="name")>
				<cfset Local.siloBodyPart = model("bodyPart").findByKey(key=Local.filterStruct["bodypart"], select="siloName")>
				<cfif isObject(Local.siloGender) and isObject(Local.siloBodyPart)>
					<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/gender-[^/]+", "", "all")>
					<cfset Local.filterSilo = ReReplaceNoCase(Local.filterSilo, "/bodypart-[^/]+", "", "all")>
					<cflocation url="http://#CGI.SERVER_NAME#/pictures/#LCase(Local.siloGender.name)#/#Local.siloBodyPart.siloName##Local.filterSilo#" addtoken="no" statuscode="301">
				<cfelse>
					<cfset Local.redirectURL = "/pictures">
					<cfif isObject(Local.siloGender)>
						<cfset Local.redirectURL &= "/gender-#Local.filterStruct["gender"]#">
					<cfelseif isObject(Local.siloBodyPart)>
						<cfset Local.redirectURL &= "/bodypart-#Local.filterStruct["bodypart"]#">
					</cfif>
					<cfset dumpStruct = {params=params, filterStruct=Local.filterStruct, siloBodyPart=Local.siloBodyPart}>
					<cfset fnCthulhuException(	scriptName="Pictures.cfc",
												message="Can't find gender or body part (gender id: #Local.filterStruct["gender"]#, body part id: #Local.filterStruct["bodypart"]#)",
												detail="DRYER, Y U NO GIVE BACK ALL MY SOCKS?",
												dumpStruct=dumpStruct,
												redirectURL=Local.redirectURL
												)>
				</cfif>
			</cfif>

			<cfif structKeyExists(Local.filterStruct, "location")>
				<cfset params["filter#Local.locationFilterId#"] = "location-#ReReplace(Local.filterStruct["location"], "[^a-z0-9]+", " ", "all")#">
			</cfif>

			<!--- Generate JS for filters --->
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

		<cfset search		= getSearchResults()>

		<!--- <cfif not search.results.recordcount>
			<cflocation url="/pictures" addtoken="no" statuscode="301">
		</cfif> --->

		<cfset arrayAppend(breadCrumbs,search.searchHeader)>
		<cfif search.pagetitle neq "">
			<cfset title = search.pagetitle>
		</cfif>
		<cfif search.metadescription neq "">
			<cfset metaDescriptionContent = search.metadescription>
		</cfif>

		<!--- set location in client scope --->
		<cfif val(params.location.city)>
			<cfset client.city = params.location.city>
		</cfif>
		<cfif val(params.location.state)>
			<cfset client.state = params.location.state>
		</cfif>
		<cfset selectValues()>
		<cfset params.intab	= false>

		<cfset storeCriteria()>

		<cfset featuredListings = createObject("component","Doctors")
									.featuredCarousel(
										procedureId	= Val(params.procedure),
										bodyPartID	= Val(params.bodypart),
										limit		= 12,
										paramsAction = params.action,
										paramsController = params.controller)>

		<cfif val(params.procedure) gt 0>
			<cfset procedureInfo = model("Procedure").findByKey(key=val(params.procedure),include="resourceGuideProcedures",returnAs="query")>
			<cfset relatedGuideTick = getTickCount()>
			<cfset relatedGuide = model("ResourceGuide").searchGuides(limit=1,procedure=val(params.procedure),noSubGuides=true)>
		<cfelseif val(params.specialty) gt 0>
			<cfset relatedGuide = model("ResourceGuide").searchGuides(limit=1,specialty=val(params.specialty),noSubGuides=true)>
		</cfif>

		<cfif ListFind(valueList(search.results.isExplicit), 1)>
			<cfset explicitAd = TRUE>
		</cfif>

		<cfset findPage = ListFindNoCase(search.filterList,"page")>
		<cfif findPage gt 0><cfset search.filterList = ListDeleteAt(search.filterList,findPage)></cfif>
		<cfif ListLen(search.filterList) eq 1>
			<cfif val(params.procedure) eq 0>
				<cfset doNotIndex = true>
			</cfif>
		<cfelseif ListLen(search.filterList) eq 2>
			<cfif not ((val(params.bodypart) and val(params.gender))
					  or (val(params.procedure) and (params.location.querystring neq "") and fnIsSiloLocation(params.location.querystring)))>
				<cfset doNotIndex = true>
			</cfif>
		<cfelse>
			<cfset doNotIndex = true>
		</cfif>

		<cfset relNext = getNextPage(search.page,search.pages)>
		<cfset relPrev = getPrevPage(search.page)>


		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(layout="/layout_mobile")>
		</cfif>


	</cffunction>

	<cffunction name="searchData">
		<cfargument name="params" required="true">
		<cfset variables.params	= arguments.params>
		<cfset search			= getSearchResults()>
		<cfset selectValues()>
		<cfset params.intab		= true>
		<cfset storeCriteria(forProfile=true)>
		<cfset relNext = getNextPage(search.page,search.pages)>
		<cfset relPrev = getPrevPage(search.page)>
		<cfreturn variables>
	</cffunction>

	<cffunction name="beforeAfterData">
		<cfargument name="params" required="true">
		<cfset variables.params	= arguments.params>
		<cfset search			= getSearchResults(SpecificCase = val(params.caseID))>
		<cfreturn search>
	</cffunction>

	<cffunction name="filterResults">
		<cfsetting showdebugoutput=false requesttimeout="600">
		<cfparam name="params.intab" default=false>
		<cfparam name="params.doctor" default="0">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">

		<cfif params.intab>
			<cfset params.key = params.doctor>
		</cfif>
		<cfset search	= getSearchResults()>
		<!--- set location in client scope --->
		<cfif val(params.location.city)>
			<cfset client.city = params.location.city>
		</cfif>
		<cfif val(params.location.state)>
			<cfset client.state = params.location.state>
		</cfif>
		<cfset content	= []>
		<cfset selectValues()>
		<cfset arrayAppend(content,renderPartial(partial="filters",returnAs="string"))>
		<cfset arrayAppend(content,renderPartial(partial="searchterm",returnAs="string"))>
		<cfset arrayAppend(content,renderPartial(partial="searchresults",returnAs="string"))>
		<cfset featuredListings = createObject("component","Doctors")
									.featuredCarousel(
										procedureId	= Val(params.procedure),
										bodyPartID	= Val(params.bodypart),
										limit		= 12,
										paramsAction = params.action,
										paramsController = params.controller)>
		<cfset arrayAppend(content,renderPartial(partial="../shared/_featureddoctor",returnAs="string"))>

		<cfset renderWith(content)>
	</cffunction>

	<cffunction name="case">
		<cfparam name="params.rewrite" default="0">
		<cfparam name="params.proceduresiloname" default="">
		<cfparam name="Client.lastGallerySearch" default="">
		<cfset var Local = {}>

		<cfset isMobile = false>

		<cfif not isDefined("params.key") or not Server.isInteger(params.key)>
			<cflocation url="/pictures" addtoken="no" statuscode="301">
		</cfif>
		<cfset params.key = val(params.key)>

		<cfparam default="#params.key#" name="params.galleryCaseId">

		<cfif params.rewrite>
			<cfset Local.procedure = model("galleryCaseProcedure").findAll(
					include="procedure",
					select="siloName",
					where="gallerycaseprocedures.galleryCaseId = #params.key# AND gallerycaseprocedures.isPrimary = 1",
					includeSoftDeletes = true)>


			<cfif Local.procedure.recordCount>
				<cfif params.proceduresiloname neq Local.procedure.siloName>
					<cflocation url="/pictures/#procedure.siloName#-c#params.key#" addtoken="no" statuscode="301">
				</cfif>
			<cfelse>
				<cflocation url="/pictures" addtoken="no" statuscode="301">
			</cfif>
		</cfif>

		<cfset wrapperClass	= ' class="page9"'>

		<cfset galleryCase = model("GalleryCase").GetGalleryCaseAngles( galleryCaseId	= params.key)>
		<cfif galleryCase.recordCount AND galleryCase.showLAD EQ 1>
			<cfset procedures = model("GalleryCase").GetGalleryCaseProcedures( galleryCaseId	= params.key)>
			<cfset specialties = model("GalleryCase").GetGalleryCaseSpecialties( galleryCaseId	= params.key)>

			<cfif ListFind(valueList(procedures.isExplicit), 1)>
				<cfset explicitAd = TRUE>
			</cfif>

			<cfset arrayAppend(breadcrumbs,linkTo(href="/pictures/#procedures.siloname#",text="#procedures.name#"))>

			<cfset doctors = model("GalleryCase").GetGalleryCaseDoctorLocations( galleryCaseId	= params.key)>

			<!--- Used for mini lead widget --->
			<cfif doctors.recordcount>
				<cfset doctor = model("AccountDoctor").GetProfile(accountDoctorId = doctors.id)>

				<cfparam default="" name="params.doctor">
				<cfif val(params.doctor) EQ 0>
					<cfset params.doctor = doctors.id>
				</cfif>

				<cfset Local.advertiser = model("AccountDoctorLocation")
								.findOne(	select	= "accountproductspurchased.id",
											include	= "AccountProductsPurchasedDoctorLocations(AccountProductsPurchased)",
											where	= "accountdoctorlocations.accountDoctorId = #doctors.id# AND accountproductspurchased.dateEnd >= now() AND accountProductId = 1",
											returnAs= "query")>
				<cfset isAdvertiser = (Local.advertiser.recordcount GT 0 ? TRUE : FALSE)>
				<cfset isBasicPlus = model("AccountDoctor").BasicPlus(doctors.id)>
				<cfif isBasicPlus>
					<cfset isBasicPlusOver2Leads = model("AccountDoctor").BasicPlusOver2Leads(doctors.id)>
				<cfelse>
					<cfset isBasicPlusOver2Leads = false>
				</cfif>
				<cfset hasContactForm = isAdvertiser OR (isBasicPlus and not isBasicPlusOver2Leads)>
				<cfset isExpiredAd = false>
				<cfset doctorTitleInfo = "#doctors.fullNameWithTitle#, #doctors.name#, #doctors.stateabbr#">
				<cfset arrayAppend(breadcrumbs,doctors.fullNameWithTitle)>
			<cfelse>
				<cfset doctor = model("GalleryCase").GetGalleryCaseDoctorLocations(
										galleryCaseId = params.key,
										expired = true)>
				<cfset featuredListings = createObject("component","Doctors").featuredCarousel(
										procedureId	= Val(procedures.id),
										limit		= 10,
										paramsAction = params.action,
										paramsController = params.controller)>
				<cfset hasContactForm = false>
				<cfset isExpiredAd = true>
				<cfset doctorTitleInfo = "#doctor.fullNameWithTitle#, #doctor.name#, #doctor.stateabbr#">
				<cfset arrayAppend(breadcrumbs,doctor.fullNameWithTitle)>
			</cfif>

			<!--- <cfset doctorSpecs	= {}>
			<cfloop query="doctors">
				<cfif not structKeyExists(doctorSpecs,accountDoctorId)>
					<cfset doctorSpecs[accountDoctorId] =	model("AccountLocationSpecialty")
																.findAllByAccountDoctorLocationId(
																	value	= accountDoctorLocationId,
																	include	= "specialty",
																	page	= 1,
																	perpage	= 1)>
				</cfif>
			</cfloop> --->

			<cfset ProcedureInfo = procedures>

			<cfif val(len(trim(client.locationstring)))>
				<!--- <cfset params["filter1"]= "location-#client.locationstring#">
				<cfset params["filter2"]= "procedure-#procedures.id#"> --->
				<cfset params.location = client.locationstring>
				<cfset params.procedure = procedures.id>
			<cfelse>
				<!--- <cfset params["filter1"]= "procedure-#procedures.id#"> --->
				<cfset params.procedure = procedures.id>
			</cfif>
			<cfset params["perpage"]= 5>
			<cfset params["exclude"]= params.key>
			<cfset relatedGals		= getSearchResults().results>

			<cfset relatedGuides = model("ResourceGuide").searchGuides(
									limit		= 2,
									procedures	= ValueList(procedures.id),
									noSubGuides	= true)>
			<cfset relatedArticles = model("ResourceArticle").searchArticles(procedure=procedures.id,limit=2)>

			<cfset descriptionList = "">
			<cfif val(galleryCase.age)>
				<cfset descriptionList = ListAppend(descriptionList," #galleryCase.age# year old")>
			</cfif>
			<cfif galleryCase.galleryGenderName neq "">
				<cfset descriptionList = ListAppend(descriptionList," "&galleryCase.galleryGenderName)>
			</cfif>
			<cfif val(galleryCase.weight)>
				<cfset descriptionList = ListAppend(descriptionList," #galleryCase.weight# lb")>
			</cfif>
			<cfif val(galleryCase.gallerySkinToneId)>
				<cfset skinTone = model("gallerySkinTone").findAll(select="name",where="id=#val(galleryCase.gallerySkinToneId)#").name>
				<cfset descriptionList = ListAppend(descriptionList," "&skinTone)>
			<cfelse>
				<cfset skinTone = "">
			</cfif>

			<cfif gallerycase.pageTitle NEQ "">
				<cfset title = gallerycase.pageTitle>
			<cfelse>
				<cfset title = "#procedures.name# Pictures of a#descriptionList# patient by #doctorTitleInfo#. ###galleryCase.id#">
			</cfif>

			<cfif gallerycase.pageMetaDescription NEQ "">
				<cfset metaDescriptionContent = gallerycase.pageMetaDescription>
			<cfelse>
				<cfset metaDescriptionContent = "#procedures.name# Pictures, Before & After gallery pictures, photos for #procedures.name# performed by #doctorTitleInfo#">
			</cfif>

			<cfif gallerycase.pageMetaKeywords NEQ "">
				<cfset metaKeywordsContent = gallerycase.pageMetaKeywords>
			</cfif>

			<cfset og_image = "http#CGI.SERVER_PORT_SECURE?"s":""#://#CGI.SERVER_NAME#/pictures/gallery/#procedures.siloName#-after-fullsize-#params.key#-#gallerycase.galleryCaseAngleId#.jpg">

			<!--- Get next/previous cases from last search criteria --->
			<cfset previousCase = 0>
			<cfset nextCase = 0>
			<cfif Client.lastGallerySearch neq "">
				<cfset lastGallerySearch = DeserializeJSON(Client.lastGallerySearch)>
				<cfloop collection="#lastGallerySearch#" item="criteria">
					<cfif ListFind("page,perpage,silourl,rewrite,controller,action,cfid,cftoken",criteria) eq 0>
						<cfset StructInsert(params,criteria,StructFind(lastGallerySearch, criteria),true)>
					</cfif>
				</cfloop>
				<cfset otherCases = getSearchResults(SpecificCase = params.key)>
				<!--- <cfdump var="#otherCases#"><cfabort> --->
				<cfif otherCases.results.recordcount eq 3>
					<cfset previousCase = 1>
					<cfset nextCase = 3>
				<cfelseif otherCases.results.recordcount eq 2>
					<cfif otherCases.aroundrow gt 1>
						<cfset previousCase = 1>
					<cfelse>
						<cfset nextCase = 2>
					</cfif>
				<cfelse>
					<!--- If none found, reset search structure --->
					<cfset Client.lastGallerySearch = "">
				</cfif>
			</cfif>
		<cfelse>
			<cfif galleryCase.recordCount GT 0 AND galleryCase.showLAD EQ 0>
				<!--- Try performing redirects to another procedure gallery case for the same doctor the same procedure
						http://carlos3.locateadoc.com/pictures/breast-reconstruction-surgery-c24090
						then to the procedure page in the main gallery. --->
				<cfset qGalleryCase = model("GalleryCase").GetDoctorsImagesWithSameProcedures(params.key)>

				<cfif qGalleryCase.recordCount GT 0>
					<!--- redirects to another procedure gallery case for the same doctor the same procedure --->
					<cfset redirectURL = "/pictures/#qGalleryCase.procedureSiloName#-c#qGalleryCase.caseId#">
					<cflocation addtoken="false" statuscode="301" url="#redirectURL#">
				<cfelse>
					<!--- redirects procedure page in the main gallery --->
					<cfset qGalleryCase = model("GalleryCase").GetImagesProcedure(params.key)>
					<cfset redirectURL = "/pictures/#qGalleryCase.siloName#">
					<cflocation addtoken="false" statuscode="301" url="#redirectURL#">
				</cfif>


				<cfheader statuscode="404" statustext="Not Found">
				<cfset doNotIndex = true>
				<cfset errormsg	= "Invalid Gallery Case ID">
				<cfset errordesc= "We are unable to locate the gallery case for ID: #params.key#">
				<cfset backLink = "/pictures/#params.proceduresiloname#">
				<cfset renderPage(template="/shared/error")>

			<cfelse>
				<!--- Check if this is a deactivated case and try to redirect to it's procedure --->
				<cfset procedureSiloName = model("GalleryCase").GetInactiveGalleryCaseProcedure(params.key)>
				<cfif procedureSiloName NEQ "">
					<cfheader statuscode="301" statustext="Moved permanently">
					<cfheader name="Location" value="/pictures/#procedureSiloName#">
					<cfabort>
				</cfif>

				<cfheader statuscode="301" statustext="Moved permanently">
				<cfheader name="Location" value="/pictures">
				<cfabort>

			</cfif>
		</cfif>

		<!--- The following is for mini lead form feedback.
			  Flash variables seem to be unable to survive https -> http
			  transitions, so client variables are used to preserve them. --->
		<cfparam name="Client.miniErrorList" default="">
		<cfparam name="Client.miniFormData" default="">
		<cfset Variables.miniErrorList = "">
		<cfset Variables.miniFormData = "">
		<cfif Client.miniErrorList neq "">
			<cfset Variables.miniErrorList = Client.miniErrorList>
			<cfset Variables.miniFormData = Client.miniFormData>
		</cfif>
		<cfset Client.miniErrorList = "">
		<cfset Client.miniFormData = "">

		<cfif gallerycase.pageH1 NEQ "">
			<cfset pageH1 = gallerycase.pageH1>
		<cfelse>
			<cfset pageH1 = "#procedures.name# Before and After Pictures by #(isExpiredAd ? doctor.fullNameWithTitle : doctors.fullNameWithTitle)#">
		</cfif>

		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = true>
			<cfset renderPage(layout="/layout_mobile")>
		</cfif>

	</cffunction>

	<cffunction name="gallery">
		<cfsetting requesttimeout="600">
		<cfset var Local= {}>

		<cfif not structKeyExists(params,"key") or listLen(params.key,"-") lt 4>
			<cflocation url="#galleryImageBase#/0-0-before.jpg" addtoken="no">
		</cfif>

		<cfset parts			= listToArray(params.key,"-")>
		<cfset Local.angleId	= parts[arrayLen(parts)]>
		<cfset Local.angleId	= listFirst(Local.angleid,".")>
		<cfset Local.caseId		= parts[arrayLen(parts)-1]>
		<cfset Local.size		= parts[arrayLen(parts)-2]>
		<cfset Local.originalSize = Local.size>
		<cfset Local.which		= parts[arrayLen(parts)-3]>
		<cfset Local.originalWhich = Local.which>

		<cfif NOT ListFindNoCase("before,after", local.which)>
			<!---
				http://carlos3.locateadoc.com/pictures/gallery/fat-injections-blah-blah-3402-4262.jpg
				http://carlos3.locateadoc.com/pictures/gallery/fat-injections-after-blah-3402-4262.jpg
			--->
			<cfset local.which = "before">
		</cfif>

		<cfif Local.size neq "original" and Local.size neq "fullsize" and Local.size neq "regular" and Local.size neq "thumb">
			<!--- 0-0-after.jpg  0-0-before.jpg --->

			<cfif Local.caseId GT 0 AND Local.angleId GT 0>
				<!--- Just create a default image size to show
						http://carlos3.locateadoc.com/pictures/gallery/fat-injections-before-blahsize-3402-4262.jpg
				--->
				<cfset local.size = "regular">
			<cfelse>
				<cfimage action="read" source="#galleryImagePath#/regular/0-0-#Local.which#.jpg" name="img">
				<cfcontent type="image/jpg" variable="#imageGetBlob(img)#">
			</cfif>
		</cfif>

		<cfif not val(caseId) or not val(angleId)>
			<cfimage action="read" source="#galleryImagePath#/#Local.size#/0-0-#Local.which#.jpg" name="img">
			<cfcontent type="image/jpg" variable="#imageGetBlob(img)#">
		</cfif>

		<cfif fileExists("#galleryImagePath#/#Local.size#/#Local.caseId#-#Local.angleId#-#Local.which#.jpg")>

			<cfif NOT ListFindNoCase("before,after", local.originalWhich) OR local.size NEQ local.originalSize>
				<!--- The original "which" was not before or after. Redirect to the before image
						http://carlos3.locateadoc.com/pictures/gallery/fat-injections-blah-regular-3402-4262.jpg
						http://carlos3.locateadoc.com/pictures/gallery/fat-injections-before-blahsize-3402-4262.jpg
				--->
				<cfset local.arrayNewSize = ArrayLen(parts) - 4>
				<cfset local.procedure = "">
				<cfset local.loopCount = 0>
				<cfloop array="#parts#" index="local.x" >
					<cfset local.loopCount++>
					<cfset local.procedure = ListAppend(local.procedure, local.x, "-")>
					<cfif loopCount EQ local.arrayNewSize><cfbreak></cfif>
				</cfloop>

				<cflocation addtoken="false" url="/pictures/gallery/#local.procedure#-before-#Local.size#-#Local.caseId#-#Local.angleId#.jpg">
			</cfif>

			<cfimage action="read" source="#galleryImagePath#/#Local.size#/#Local.caseId#-#Local.angleId#-#Local.which#.jpg" name="img">
			<cfcontent type="image/jpg" variable="#imageGetBlob(img)#">
		<cfelse>
			<!---	check if the same doctor had an image from a same procedure and redirect to it,
					then choose another doctor with the same procedure,
					then I guess the last option would be the main BAAG search page.
			--->
			<cfif local.caseId GT 0>
				<cfset qDoctorsImagesWithSameProcedures = model("GalleryCase").GetDoctorsImagesWithSameProcedures(caseId	= Local.caseId)>

				<cfloop query="qDoctorsImagesWithSameProcedures">
					<cfset Local.caseId = qDoctorsImagesWithSameProcedures.caseId>
					<cfset Local.angleId = qDoctorsImagesWithSameProcedures.angleId>

					<cfif fileExists("#galleryImagePath#/#Local.size#/#Local.caseId#-#Local.angleId#-#Local.which#.jpg")>
						<!--- <cfoutput>#galleryImagePath#/#Local.size#/#Local.caseId#-#Local.angleId#-#Local.which#.jpg</cfoutput>
						<cfabort> --->
						<cflocation addtoken="false" url="/pictures/gallery/#qDoctorsImagesWithSameProcedures.procedureSiloName#-before-regular-#Local.caseId#-#Local.angleId#.jpg" statuscode="301">

						<!--- <cfimage action="read" source="#galleryImagePath#/#Local.size#/#Local.caseId#-#Local.angleId#-#Local.which#.jpg" name="img">
						<cfcontent type="image/jpg" variable="#imageGetBlob(img)#"> --->
					</cfif>
				</cfloop>

				<!--- then choose another doctor with the same procedure, --->
				<cfset qOtherDoctorsImagesWithSameProcedures = model("GalleryCase").GetOtherDoctorsImagesWithSameProcedures(caseId	= Local.caseId)>

				<cfloop query="qOtherDoctorsImagesWithSameProcedures">
					<cfset Local.caseId = qOtherDoctorsImagesWithSameProcedures.caseId>
					<cfset Local.angleId = qOtherDoctorsImagesWithSameProcedures.angleId>

					<cfif fileExists("#galleryImagePath#/#Local.size#/#Local.caseId#-#Local.angleId#-#Local.which#.jpg")>
						<!--- <cfoutput>#galleryImagePath#/#Local.size#/#Local.caseId#-#Local.angleId#-#Local.which#.jpg</cfoutput>
						<cfabort> --->
						<cflocation addtoken="false" url="/pictures/gallery/#qOtherDoctorsImagesWithSameProcedures.procedureSiloName#-before-regular-#Local.caseId#-#Local.angleId#.jpg" statuscode="301">
					</cfif>
				</cfloop>

				<!--- redirect to the main BAAG search page --->
				<cfset qImagesProcedure = model("GalleryCase").GetImagesProcedure(caseId	= Local.caseId)>

				<cfif qImagesProcedure.recordCount GT 0>
					<cflocation addtoken="false" url="/pictures/#qImagesProcedure.siloName#" statuscode="301">
				</cfif>
			</cfif>

			<cfimage action="read" source="#galleryImagePath#/#Local.size#/0-0-#Local.which#.jpg" name="img">
			<cfcontent type="image/jpg" variable="#imageGetBlob(img)#">
		</cfif>
	</cffunction>

	<cffunction name="oldimages" hint="301 redirects for old 2.0 image URLs">
		<cfparam name="param.caseid" default="">
		<cfparam name="param.beforeafter" default="">
		<cfparam name="param.ordernumber" default="">
		<cfparam name="param.imgsize" default="">
		<cfset var Local = {}>
		<cfset Local.imgFile = "/images/gallery/regular/0-0-before.jpg">

		<cftry>
			<!--- Example: http://www.locateadoc.com/pictures/breast-augmentation-breast-implants-51399before1thumb.jpg --->
			<!--- Example: http://www.locateadoc.com/pictures/breast-augmentation-breast-implants-51399before1.jpg --->
			<!--- Example: http://www.locateadoc.com/pictures/fullsize/case_46674_before1.jpg --->
			<!---
				http://carlos3.locateadoc.com/images/gallery/img9958before1.jpg
				http://carlos3.locateadoc.com/images/gallery/img8814before1_thumb.jpg

				http://www.locateadoc.com/pictures/gallery/chin-augmentation-implants-after-thumb-8814-14605.jpg
				http://www.locateadoc.com/pictures/gallery/chin-augmentation-implants-before-regular-1124-204.jpg
				http://www.locateadoc.com/pictures/gallery/dysport-before-thumb-44486-87986.jpg
			 --->

			<cfif params.imgsize eq "_thumb" OR params.imgsize eq "thumb">
				<cfset params.imgsize = "thumb">
			<cfelse>
				<cfset params.imgsize = "regular">
			</cfif>
			<cfset Local.angle = model("galleryCaseAngle").findOneByGalleryCaseIdAndOrderNumber(values="#params.caseid#,#params.ordernumber#", select="id")>
			<cfif isObject(Local.angle)>
				<cfset Local.procedure = model("galleryCaseProcedure").findOneByGalleryCaseIdAndIsPrimary(values="#params.caseid#,1", include="procedure", select="siloName")>
				<cfif isObject(Local.procedure)>
					<cfset Local.imgFile = "/pictures/gallery/#Local.procedure.procedure.siloName#-#params.beforeafter#-#params.imgsize#-#params.caseid#-#Local.angle.id#.jpg">
				</cfif>
			</cfif>

			<cfcatch></cfcatch>
		</cftry>

		<cflocation url="#Local.imgFile#" addtoken="no" statuscode="301">

	</cffunction>

	<cffunction name="doctorphoto">
		<cfsetting requesttimeout="600">
		<cfparam name="params.filename" default="">
		<cfif val(len(params.filename))>
			<cfif fileExists("#doctorImagePathOld#/uploaded/#params.filename#")>
				<cfset imgsrc = "#doctorImagePathOld#/uploaded/#params.filename#">
			<cfelse>
				<cfset imgsrc = "#doctorImagePathOld#/#params.filename#">
			</cfif>
			<cftry>
				<cfset img	= imageRead(imgsrc)>
				<cfcatch>
					<cfscript>
						imageFile	= createObject("java","java.io.File").init(imgsrc);
						ImageIO		= createObject("java","javax.imageio.ImageIO");
						bi			= ImageIO.read(imageFile);
						img			= ImageNew(bi);
					</cfscript>
				</cfcatch>
			</cftry>
			<cfif isImage(img)>
				<cftry>
					<cfset imageWrite(img,"#doctorImagePath#/uploaded/#lcase(params.filename)#")>
					<cfset fileSetAccessMode("#doctorImagePath#/uploaded/#lcase(params.filename)#","664")>
					<cfcatch><cfdump var="#cfcatch#"><cfabort></cfcatch>
				</cftry>
				<cfset resizedimg = resizeFromCenter(img,214,195)>
				<cfset imageWrite(resizedimg,"#doctorImagePath#/#lcase(params.filename)#")>
				<cfset fileSetAccessMode("#doctorImagePath#/#lcase(params.filename)#","664")>
				<cfset thumbimg = resizeFromCenter(img,113,129)>
				<cfset imageWrite(thumbimg,"#doctorImagePath#/thumb/#lcase(params.filename)#")>
				<cfset fileSetAccessMode("#doctorImagePath#/thumb/#lcase(params.filename)#","664")>
			</cfif>
			<cfset renderNothing()>
		<cfelse>
			<cfdirectory action="list" directory="#doctorImagePathOld#" filter="*.jpg" name="old">
			<cfset oldcount = old.recordcount>
			<cfdirectory action="list" directory="#doctorImagePath#" filter="*.jpg" name="new">
			<cfset newcount = new.recordcount>
			<cfset new = lcase(valuelist(new.name,"|"))>
			<cfset missing = []>
			<cfloop query="old">
				<cfif not listFindNoCase(new,name,"|")>
					<cfset arrayAppend(missing,lcase(name))>
				</cfif>
			</cfloop>
			<cfset renderPage(layout=false)>
		</cfif>
	</cffunction>

	<cffunction name="convertThumbs">
		<meta name="robots" content="noindex">
		<cfabort>
		<cfsetting requesttimeout="600">
		<cfparam name="params.filename" default="">
		<cfif val(len(params.filename))>
			<cfset imgsrc = "#doctorImagePath#/#params.filename#">
			<cftry>
				<cfset img	= imageRead(imgsrc)>
				<cfcatch>
					<cfscript>
						imageFile	= createObject("java","java.io.File").init(imgsrc);
						ImageIO		= createObject("java","javax.imageio.ImageIO");
						bi			= ImageIO.read(imageFile);
						img			= ImageNew(bi);
					</cfscript>
				</cfcatch>
			</cftry>
			<cfif isImage(img)>
				<cfset thumbimg = resizeFromCenter(img,113,129)>
				<cfset imageWrite(thumbimg,"#doctorImagePath#/thumb/#lcase(params.filename)#")>
				<cfset fileSetAccessMode("#doctorImagePath#/thumb/#lcase(params.filename)#","664")>
			</cfif>
			<cfset renderNothing()>
		<cfelse>
			<cfdirectory action="list" directory="#doctorImagePath#" filter="*.jpg" name="old">
			<cfset oldcount = old.recordcount>
			<cfdirectory action="list" directory="#doctorImagePath#/thumb" filter="*.jpg" name="new">
			<cfset newcount = new.recordcount>
			<cfset new = lcase(valuelist(new.name,"|"))>
			<cfset missing = []>
			<cfloop query="old">
				<cfif not listFindNoCase(new,name,"|")>
					<cfset arrayAppend(missing,lcase(name))>
				</cfif>
			</cfloop>
			<cfset renderPage(layout=false)>
		</cfif>
	</cffunction>

	<cffunction name="BAAGimages">
		<cfsetting showdebugoutput=false>
		<cfparam name="params.baagauto" default="0">
		<cfparam name="params.baagforce" default="0">
		<cfparam name="params.key" default="">
		<cfparam name="params.split" default="">
		<cfparam name="params.disable" default="">
		<cfparam name="del" default="">

		<meta name="robots" content="noindex">

		<cfif server.thisServer EQ "dev" OR cgi.REMOTE_ADDR EQ "71.43.249.210">
		<cfif val(params.disable)>
			<cfquery datasource="myLocateadocEdits">
			UPDATE gallerycases
			SET deletedAt = now()
			WHERE id = #params.disable#
			</cfquery>
			<cfset logit("case #params.disable# was disabled")>
			<cfdump var="CASE WAS DELETED"><cfabort>
		<cfelseif val(len(del))>
			<cfif fileExists("#LAD2uploadImagePath#/#del#")>
				<cffile action="delete" file="#LAD2uploadImagePath#/#del#">
				<cfset logit("image file was deleted #LAD2uploadImagePath#/#del#")>
				<cfdump var="DELETED"><cfabort>
			</cfif>
		<cfelseif val(len(params.split))>
			<cftry>
				<cfif fileExists("#LAD2uploadImagePath#/img#listFirst(params.split)#before#listLast(params.split)#.jpg")>
					<cfset beforesrc	= "#LAD2uploadImagePath#/img#listFirst(params.split)#before#listLast(params.split)#.jpg">
				<cfelseif fileExists("#LAD2galleryImagePath#/#listGetAt(params.split,2)#")>
					<cfset beforesrc	= "#LAD2galleryImagePath#/#listGetAt(params.split,2)#">
				</cfif>
				<cftry>
					<cfset orig	= imageRead(beforesrc)>
					<cfcatch>
						<cfscript>
							imageFile	= createObject("java","java.io.File").init(beforesrc);
							ImageIO		= createObject("java", "javax.imageio.ImageIO");
							bi			= ImageIO.read(imageFile);
							orig	= ImageNew(bi);
						</cfscript>
					</cfcatch>
				</cftry>
				<cfif isImage(orig)>
					<!--- REMOVE THIS EVENTUALLY --->
					<cfset imageWrite(orig,"#LAD2uploadImagePath#/img#listFirst(params.split)#before#listLast(params.split)#BAK.jpg")>
					<!--- REMOVE THIS EVENTUALLY --->

					<cfset newimages = splitInTwo(orig,listGetAt(params.split,3))>
					<cfif isImage(newimages[1]) and isImage(newimages[2])>
						<!--- originals --->
						<cfset imageWrite(newimages[1],"#LAD2uploadImagePath#/img#listFirst(params.split)#before#listLast(params.split)#.jpg")>
						<cfset imageWrite(newimages[2],"#LAD2uploadImagePath#/img#listFirst(params.split)#after#listLast(params.split)#.jpg")>
						<!--- regulars --->
						<cfset before	= waterMark(resizeFromCenter(newimages[1],238,273),"LocateADoc.com")>
						<cfset after	= waterMark(resizeFromCenter(newimages[2],238,273),"LocateADoc.com")>
						<cfset imageWrite(before,"#LAD2galleryImagePath#/#listGetAt(params.split,2)#")>
						<cfset imageWrite(after,replaceNoCase("#LAD2galleryImagePath#/#listGetAt(params.split,2)#","before","after","ALL"))>
					</cfif>
				</cfif>
				<cfif params.baagauto>
					<cfset renderText("auto")>
				<cfelse>
					<cfset renderText("success")>
				</cfif>
				<cfcatch><cfdump var="#cfcatch#"><cfabort></cfcatch>
			</cftry>
		<cfelseif val(params.key)>
			<cfset case	= model("galleryCase")
								.findByKey(
									key		= params.key,
									include	= "galleryCaseAngles")>
			<cfloop condition="not isObject(case)">
				<cfset params.key	= params.key+1>
				<cfset case	= model("galleryCase")
								.findByKey(
									key		= params.key,
									include	= "galleryCaseAngles")>
			</cfloop>
			<cfif isObject(case)>
				<cfdirectory action="list" directory="#LAD2galleryImagePath#" filter="*-#params.key#before?.jpg" name="before" sort="name asc">
				<cfdirectory action="list" directory="#LAD2galleryImagePath#" filter="*-#params.key#after?.jpg" name="after" sort="name asc">
				<cfdirectory action="list" directory="#LAD2uploadImagePath#" filter="img#params.key#before?.jpg" name="before_orig" sort="name asc">
				<cfdirectory action="list" directory="#LAD2uploadImagePath#" filter="img#params.key#after?.jpg" name="after_orig" sort="name asc">
				<cfif not val(before.recordcount) and not val(after.recordcount) and not val(before_orig.recordcount) and not val(after_orig.recordcount)>
					<cfquery datasource="myLocateadocEdits">
					UPDATE gallerycases
					SET deletedAt = now()
					WHERE id = #params.key#
					</cfquery>
					<cflocation url="/pictures/BAAGimages/#(params.key+1)#?baagauto=#params.baagauto#&baagforce=#params.baagforce#" addtoken="no">
				</cfif>
				<cfquery datasource="#get("datasourcename")#" name="max">
				SELECT max(id) AS id FROM gallerycases
				</cfquery>
				<cfset renderPage(layout=false)>
			</cfif>
		<cfelseif structKeyExists(params,"caseid")>
			<cfif params.baagauto>
				<cfset response	= "auto">
			<cfelse>
				<cfset response	= "success">
			</cfif>
			<cfdirectory action="list" directory="#LAD2uploadImagePath#" filter="img#params.caseid#before#params.lad2#.jpg" name="origBefore">
			<cfdirectory action="list" directory="#LAD2uploadImagePath#" filter="img#params.caseid#after#params.lad2#.jpg" name="origAfter">
			<!--- before --->
			<cfset beforesrc	= "">
			<cfif val(origBefore.recordcount)>
				<cfset beforesrc	= "#LAD2uploadImagePath#/#origBefore.name#">
			<cfelse>
				<cfdirectory action="list" directory="#LAD2galleryImagePath#" filter="*-#params.caseid#before#params.lad2#.jpg" name="origBefore">
				<cfif val(origBefore.recordcount)>
					<cfset beforesrc	= "#LAD2galleryImagePath#/#origBefore.name#">
				</cfif>
			</cfif>
			<cfif val(len(beforesrc))>
				<cftry>
					<cfset beforeOrig	= imageRead(beforesrc)>
					<cfcatch>
						<cfscript>
							imageFile	= createObject("java","java.io.File").init(beforesrc);
							ImageIO		= createObject("java", "javax.imageio.ImageIO");
							bi			= ImageIO.read(imageFile);
							beforeOrig	= ImageNew(bi);
						</cfscript>
					</cfcatch>
				</cftry>
				<cfif isImage(beforeOrig)>
					<cfset imageWrite(beforeOrig,"#LAD3galleryImagePath#/original/#params.caseid#-#params.lad3#-before.jpg")>
					<cfset beforeFull	= waterMark(beforeOrig,"LocateADoc.com")>
					<cfset imageWrite(beforeFull,"#LAD3galleryImagePath#/fullsize/#params.caseid#-#params.lad3#-before.jpg")>
					<cfset beforeReg	= waterMark(resizeFromCenter(beforeOrig,238,273),"LocateADoc.com")>
					<cfset imageWrite(beforeReg,"#LAD3galleryImagePath#/regular/#params.caseid#-#params.lad3#-before.jpg")>
					<cfset beforeThumb	= waterMark(resizeFromCenter(beforeOrig,90,79),"LocateADoc.com")>
					<cfset imageWrite(beforeThumb,"#LAD3galleryImagePath#/thumb/#params.caseid#-#params.lad3#-before.jpg")>
				<cfelse>
					<cfset response	= "Failed to read an original (before)">
				</cfif>
			<cfelse>
				<cfset response	= "Could not find an original (before)">
			</cfif>
			<!--- after --->
			<cfset aftersrc	= "">
			<cfif val(origAfter.recordcount)>
				<cfset aftersrc	= "#LAD2uploadImagePath#/#origAfter.name#">
			<cfelse>
				<cfdirectory action="list" directory="#LAD2galleryImagePath#" filter="*-#params.caseid#after#params.lad2#.jpg" name="origAfter">
				<cfif val(origAfter.recordcount)>
					<cfset aftersrc	= "#LAD2galleryImagePath#/#origAfter.name#">
				</cfif>
			</cfif>
			<cfif val(len(aftersrc))>
				<cftry>
					<cfset afterOrig	= imageRead(aftersrc)>
					<cfcatch>
						<cfscript>
							imageFile	= createObject("java","java.io.File").init(aftersrc);
							ImageIO		= createObject("java", "javax.imageio.ImageIO");
							bi			= ImageIO.read(imageFile);
							afterOrig	= ImageNew(bi);
						</cfscript>
					</cfcatch>
				</cftry>
				<cfif isImage(afterOrig)>
					<cfset imageWrite(afterOrig,"#LAD3galleryImagePath#/original/#params.caseid#-#params.lad3#-after.jpg")>
					<cfset afterFull	= waterMark(afterOrig,"LocateADoc.com")>
					<cfset imageWrite(afterFull,"#LAD3galleryImagePath#/fullsize/#params.caseid#-#params.lad3#-after.jpg")>
					<cfset afterReg	= waterMark(resizeFromCenter(afterOrig,238,273),"LocateADoc.com")>
					<cfset imageWrite(afterReg,"#LAD3galleryImagePath#/regular/#params.caseid#-#params.lad3#-after.jpg")>
					<cfset afterThumb	= waterMark(resizeFromCenter(afterOrig,90,79),"LocateADoc.com")>
					<cfset imageWrite(afterThumb,"#LAD3galleryImagePath#/thumb/#params.caseid#-#params.lad3#-after.jpg")>
				<cfelse>
					<cfset response	= "Failed to read an original (after)">
				</cfif>
			<cfelse>
				<cfset response	= "Could not find an original (after)">
			</cfif>
			<cfoutput>#response#</cfoutput><cfabort>
		<cfelse>
			<b>Case Id:</b><br>
			<form name="frm" action="/pictures/BAAGimages" method="post">
			<input type="text" size="8" name="key"><br>
			<button>Get BAAG Images</button>
			</form>
			<script>document.frm.key.focus()</script>
			<cfabort>
		</cfif>

		</cfif>

		<cfabort>
	</cffunction>

<!---Private functions--->

	<cffunction name="sponsoredlink" returntype="struct" access="private">
		<cfparam name="params.specialty" default="">
		<cfparam name="params.procedure" default="">
		<cfparam name="params.bodypart" default="">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">

		<cfset sponsoredLink = getSponsoredLink(specialty			= "#val(params.specialty)#",
												procedure			= "#val(params.procedure)#",
												bodyPartId			= "#val(params.bodyPart)#",
												paramsAction		= "#params.action#",
												paramsController	= "#params.controller#")>
		<cfreturn sponsoredLink>
	</cffunction>

	<cffunction name="getProcedures" access="private">
		<cfargument name="firstLetter" type="string" default="">
		<cfset var Local = {}>
		<cfif len(trim(firstLetter))>
			<cfset Local.procedures = model("Procedure").findAll(
															select	= "procedures.id AS procedureId, procedures.name AS procedureName",
															distinct= "true",
															where	= "procedures.name like '#firstletter#%'",
															include	= "galleryCaseProcedures(galleryCase)",
															order	= "name asc")>
		<cfelse>
			<cfset Local.procedures = model("GallerySummaryActiveProcedure").findAll(
																select	= "procedureId, procedureName, procedureSiloName")>
		</cfif>
		<cfreturn Local.procedures>
	</cffunction>

	<cffunction name="getBodyParts" access="private">
		<cfargument name="genderId" required="true" type="numeric">

		<cfset var Local		= {}>
		<cfset Local.bodyParts	= model("GallerySummaryActiveBodyPart")
									.findAll(
										select	= "bodyRegionId, bodyRegionName, bodyPartId, bodyPartName, bodyPartSiloName",
										where	= "galleryGenderId = #arguments.genderId#")>
		<cfreturn Local.bodyParts>
	</cffunction>

	<cffunction name="getRegionDots" access="private">
		<cfset var StartTick = getTickCount()>
		<cfset regions = model("BodyRegions").findAll()>

		<cfset var Local = {}>
		<cfloop query="regions">
			<cfset Local[name]	= {x=xCoordinate,y=yCoordinate}>
		</cfloop>
		<cfreturn Local>
	</cffunction>

	<cffunction name="selectValues" access="private">

		<!---This function will create values for the various select boxes for the search and filters--->
		<!---DISTANCE--->
		<cfset distances		= {}>
		<cfset distances["005"]	= "5 miles">
		<cfset distances["010"] = "10 miles">
		<cfset distances["025"] = "25 miles">
		<cfset distances["100"] = "100 miles">
		<!---AGE--->
		<cfset ageRanges			= {}>
		<cfset ageRanges["01_09"]	= "under 10">
		<cfset ageRanges["10_16"]	= "10 to 16">
		<cfset ageRanges["17_24"]	= "17 to 24">
		<cfset ageRanges["25_35"]	= "25 to 35">
		<cfset ageRanges["36_99"]	= "over 35">
		<!---HEIGHT--->
		<cfset heightRanges				= {}>
		<cfset heightRanges["01_35"]	= "under 3 feet">
		<cfset heightRanges["36_48"]	= "3 to 4 feet">
		<cfset heightRanges["49_60"]	= "4 to 5 feet">
		<cfset heightRanges["61_72"]	= "5 to 6 feet">
		<cfset heightRanges["73_84"]	= "6 to 7 feet">
		<cfset heightRanges["85_99"]	= "over 7 feet">
		<!---WEIGHT--->
		<cfset weightRanges				= {}>
		<cfset weightRanges["001_100"]	= "under 100 lbs">
		<cfset weightRanges["100_130"]	= "100 to 130 lbs">
		<cfset weightRanges["131_160"]	= "131 to 160 lbs">
		<cfset weightRanges["161_190"]	= "161 to 190 lbs">
		<cfset weightRanges["191_220"]	= "191 to 220 lbs">
		<cfset weightRanges["221_250"]	= "221 to 250 lbs">
		<cfset weightRanges["251_999"]	= "over 250 lbs">
		<!--- SPECIALIZATIONS --->
		<cfset specializations = []>
	</cffunction>

	<cffunction name="getSearchResults" access="public">
		<cfargument name="SpecificCase"	required="false" default="0">
		<cfset var Local = {}>

		<!---PARAM all the search options to make sure we have them all regardless--->
		<cfparam name="params.distance"				default="">
		<cfparam name="params.location"				default="">
		<cfparam name="params.state"				default="">
		<cfparam name="params.city" 				default="">
		<cfparam name="params.country"				default="">
		<cfparam name="params.doctorlastname"		default="">
		<cfparam name="params.specialty"			default="">
		<cfparam name="params.doctor"				default="">
		<cfparam name="params.bodypart"				default="">
		<cfparam name="params.procedure"			default="">
		<cfparam name="params.gender"				default="">
		<cfparam name="params.skintone"				default="">
		<cfparam name="params.afterphotos_taken"	default="">
		<cfparam name="params.breast_size_start"	default="">
		<cfparam name="params.breast_size_end"		default="">
		<cfparam name="params.implant_type"			default="">
		<cfparam name="params.implant_placement"	default="">
		<cfparam name="params.point_of_entry"		default="">
		<cfparam name="params.age"					default="">
		<cfparam name="params.age_start"			default="">
		<cfparam name="params.age_end"				default="">
		<cfparam name="params.height"				default="">
		<cfparam name="params.height_start"			default="">
		<cfparam name="params.height_end"			default="">
		<cfparam name="params.weight"				default="">
		<cfparam name="params.weight_start"			default="">
		<cfparam name="params.weight_end"			default="">
		<cfparam name="params.sortby"				default="updatedAt desc, galleryCaseId desc">
		<cfparam name="params.page"					default="1">
		<cfparam name="params.perpage"				default="10">
		<cfparam name="params.exclude"				default="">

		<cfset params.onePerDoctor = true>
		<!--- The presence of one of these variables will prevent the search from showing only one result per doctor --->
		<cfset Local.singleExemptParams = "doctorlastname,specialty,doctor,skintone,afterphotos_taken,breast_size_start,"
										& "breast_size_end,implant_type,implant_placement,point_of_entry,age,age_start,age_end,"
										& "height,height_start,height_end,weight,weight_start,weight_end">

		<!---Search the URL for filter params and reformat them for the search--->
		<cfset Local.filterList = "">
		<cfloop collection="#params#" item="i">
			<cfif left(i,6) is "filter">
				<cfset Local.filterName				= listFirst(params[i],"-")>
				<cfset Local.filterValue			= listLast(params[i],"-")>
				<cfset params[Local.filterName]		= Local.filtervalue>
				<cfset Local.filterList = ListAppend(filterList,Local.filterName)>
				<cfif Local.filterName is "age">
					<cfset params.age				= Local.filterValue>
				<cfelseif Local.filterName is "height">
					<cfset params.height			= Local.filterValue>
				<cfelseif Local.filterName is "weight">
					<cfset params.weight			= Local.filterValue>
				<cfelseif Local.filterName is "location">
					<cfset params[Local.filterName]	= replace(Local.filtervalue,"_"," ","ALL")>
				</cfif>
				<cfif ListFind(Local.singleExemptParams,LCase(Local.filterName)) and (Local.filterValue neq "" and Local.filterValue neq 0)>
					<cfset params.onePerDoctor = false>
				</cfif>
			<cfelseif ListFind(Local.singleExemptParams,LCase(i)) and (params[i] neq "" and params[i] neq 0)>
				<cfset params.onePerDoctor = false>
			</cfif>
		</cfloop>
		<cfif val(params.procedure) gt 0 and params.location neq "">
			<cfset params.onePerDoctor = false>
		</cfif>
		<cfif (val(params.bodypart) gt 0 and val(params.gender) gt 0 and params.location neq "")
			OR (val(params.bodypart) gt 0 and val(params.gender) eq 0)
			OR (val(params.bodypart) eq 0 and val(params.gender) gt 0)>
			<cfset params.onePerDoctor = false>
		</cfif>

		<cfif val(len(params.age))>
			<cfset params.age_start			= val(listFirst(params.age,"_"))>
			<cfset params.age_end			= val(listLast(params.age,"_"))>
		</cfif>
		<cfif val(len(params.height))>
			<cfset params.height_start		= val(listFirst(params.height,"_"))>
			<cfset params.height_end		= val(listLast(params.height,"_"))>
		</cfif>
		<cfif val(len(params.weight))>
			<cfset params.weight_start		= val(listFirst(params.weight,"_"))>
			<cfset params.weight_end		= val(listLast(params.weight,"_"))>
		</cfif>

		<cfif val(params.page) lt 1>
			<cfset params.page = 1>
		</cfif>

		<cfif val(len(params.location)) and params.location neq 0>
			<cfset params.location = parseLocation(URLDecode(params.location),val(params.country),false)>
			<cfif not params.location.zipFound><cfset params.location.zipCode = ""></cfif>

			<cfif params.location.cityFound>
				<cfset params.city = params.location.city>
			</cfif>
			<cfif params.location.stateFound>
				<cfset params.state = params.location.state>
			</cfif>
			<cfif val(params.location.country) GT 0 AND val(params.country) EQ 0>
				<cfset params.country = params.location.country>
			</cfif>

			<cfif val(params.distance) eq 0 and (params.location.zipCode neq "" or (val(params.city) gt 0 and val(params.state) gt 0))>
				<cfset searchCheck = model("GalleryCase").testLocation(
					country =		val(params.country),
					zipCode =		params.location.zipCode,
					city =			val(params.city),
					state =			val(params.state),
					doctor =		val(params.doctor),
					procedureId =	val(params.procedure),
					specialtyId =	val(params.specialty),
					genderId	= 	val(params.gender),
					ageStart	= 	val(params.age_start),
					ageEnd		= 	val(params.age_end),
					heightStart	= 	val(params.height_start),
					heightEnd	= 	val(params.height_end),
					weightStart	= 	val(params.weight_start),
					weightEnd	= 	val(params.weight_end)
				)>
				<cfif searchCheck gt 0 and searchCheck lte 100>
					<cfset params.distance = searchCheck>
				</cfif>
			</cfif>
		<cfelse>
			<cfset params.location = parseLocation('')>
		</cfif>

		<cfset client.locationstring = params.location.querystring>

		<cfset aroundRow = 0>
		<cfif val(arguments.SpecificCase) gt 0>
			<!---Perform the search--->
			<cfset getPlacement = model("GalleryCase").gallerySearch(
				specificCase			= val(specificCase),
				distance				= val(params.distance),
				location				= params.location,
				doctorLastname			= params.doctorlastname,
				doctorSpecialty			= val(params.specialty),
				accountDoctorId			= val(params.doctor),
				bodyPartId				= val(params.bodypart),
				procedureId				= val(params.procedure),
				genderId				= val(params.gender),
				skinToneId				= val(params.skintone),
				afterPhotosTakenId		= val(params.afterphotos_taken),
				breastStartingSizeId	= val(params.breast_size_start),
				breastEndingSizeId		= val(params.breast_size_end),
				typeOfImplantId			= val(params.implant_type),
				implantPlacementId		= val(params.implant_placement),
				pointOfEntryId			= val(params.point_of_entry),
				ageStart				= val(params.age_start),
				ageEnd					= val(params.age_end),
				heightStart				= val(params.height_start),
				heightEnd				= val(params.height_end),
				weightStart				= val(params.weight_start),
				weightEnd				= val(params.weight_end),
				sortBy					= params.sortby,
				page					= val(params.page),
				perpage					= val(params.perpage),
				exclude					= val(params.exclude),
				onePerDoctor			= params.onePerDoctor
			)>
			<cfset aroundRow = val(getPlacement.rowNumber)>
		</cfif>

		<!---Perform the search--->
		<!--- <cfdump var="#params#"><cfabort> --->
		<cfset Local.search = model("GalleryCase").gallerySearch(
			distance				= val(params.distance),
			location				= params.location,
			doctorLastname			= params.doctorlastname,
			doctorSpecialty			= val(params.specialty),
			accountDoctorId			= val(params.doctor),
			bodyPartId				= val(params.bodypart),
			procedureId				= val(params.procedure),
			genderId				= val(params.gender),
			skinToneId				= val(params.skintone),
			afterPhotosTakenId		= val(params.afterphotos_taken),
			breastStartingSizeId	= val(params.breast_size_start),
			breastEndingSizeId		= val(params.breast_size_end),
			typeOfImplantId			= val(params.implant_type),
			implantPlacementId		= val(params.implant_placement),
			pointOfEntryId			= val(params.point_of_entry),
			ageStart				= val(params.age_start),
			ageEnd					= val(params.age_end),
			heightStart				= val(params.height_start),
			heightEnd				= val(params.height_end),
			weightStart				= val(params.weight_start),
			weightEnd				= val(params.weight_end),
			sortBy					= params.sortby,
			page					= val(params.page),
			perpage					= val(params.perpage),
			exclude					= val(params.exclude),
			onePerDoctor			= params.onePerDoctor,
			aroundRow				= aroundRow
		)>

		<cfset Local.search.filterList = Local.filterList>
		<cfset Local.search.aroundRow = aroundRow>

		<!--- Catch page number in URL greater than total pages --->
		<cfif IsDefined("params.action") and (params.action eq "filterResults")
			and (Local.search.totalrecords gt 0)
			and (Local.search.results.recordcount eq 0)
			and (val(params.page) gt 1)
			and REFind("page-[0-9]+",CGI.HTTP_REFERER)>
			<cfoutput>PAGE_ERROR</cfoutput><cfabort>
		</cfif>


		<cfif search.results.recordcount EQ 0 AND params.action EQ "search">
			<cfset doNotIndex = true>

			<cfif val(params.page) GT 1 AND Local.search.totalrecords gt 0 AND reFindNoCase("/page-[0-9]+$", params.silourl)>
				<!--- http://www.locateadoc.com/pictures/breast-augmentation-breast-implants/kokomo-in/page-8
					This paginated page has 0 results, but other pages have results, so redirect to the first page
				 --->
				<cflocation addtoken="false" statuscode="301" url="#ReplaceNoCase(params.silourl,"/page-#params.page#", "")#">
			<cfelseif val(params.page) GT 1 AND Local.search.totalrecords EQ 0 AND reFindNoCase("/page-[0-9]+$", params.silourl)>
				<!--- This paginated page has 0 results, and the search in general has 0 results. Not sure if I should do anything here --->
			</cfif>

			<!--- Following these instructions https://support.google.com/webmasters/answer/2409443?hl=en&ref_topic=4610835 --->
			<cfheader statuscode="410" statustext="Not Found">
		<cfelse>
			<cfset doNotIndex = false>
		</cfif>

		<cfset Local.search.searchHeader = "Gallery Search Results">
		<cfset Local.search.searchSummary = "">
		<cfset Local.search.landingContent = "">
		<cfset Local.search.headerLink = "">
		<cfif params.location.zipCode neq "" or val(params.location.city) gt 0 or val(params.location.state) gt 0>
			<cfset Local.search.searchSummary &= " within">
			<cfif val(params.distance) gt 0 and (params.location.zipCode neq "")>
				<cfset Local.search.searchSummary &= " #val(params.distance)# miles of">
			</cfif>
			<cfif params.location.zipCode neq "">
				<cfset Local.search.searchSummary &= " #params.location.zipCode#">
			<cfelseif (val(params.city) gt 0 and val(params.state) gt 0)>
				<cfset Local.search.searchSummary &= " #params.location.cityname#, #params.location.stateabbr#">
			<cfelseif val(params.state) gt 0>
				<cfset Local.search.searchSummary &= " #params.location.statename#">
			<cfelse>
				<cfset Local.search.searchSummary &= " cities named #params.location.cityname#">
			</cfif>
		<cfelseif val(params.specialty) gt 0 or val(params.doctor) gt 0 or params.doctorlastname neq "">
				<!--- Prevent procedure-only or body part-only labels --->
		<cfelseif val(params.procedure) gt 0 and val(params.bodypart) eq 0>
			<cfset Local.search.searchHeader = "#Model('Procedure').findAll(select='name',where='id='&val(params.procedure)).name# Before and After Photos">
		<cfelseif val(params.bodypart) gt 0 and val(params.procedure) eq 0>
			<cfif val(params.gender)>
				<cfset Local.search.searchSummary &= " Displaying Pictures of the #(Model('GalleryGender').findAll(select='name',where='id='&val(params.gender)).name)# #LCase(Model('BodyPart').findAll(select='name',where='id='&val(params.bodypart)).name)#">
			<cfelse>
				<cfset Local.search.searchSummary &= " Displaying Pictures of the #(Model('BodyPart').findAll(select='name',where='id='&val(params.bodypart)).name)#">
			</cfif>
		</cfif>

		<cfif val(params.procedure) gt 0 and not (val(params.specialty) or val(params.doctor) or params.doctorlastname neq "" or val(params.bodypart) or val(params.gender) or val(params.skintone) or val(params.afterphotos_taken) or val(params.breast_size_start) or val(params.breast_size_end) or val(params.implant_type) or val(params.implant_placement) or val(params.point_of_entry) or val(params.age_start) or val(params.age_end) or val(params.height_start) or val(params.height_end) or val(params.weight_start) or val(params.weight_end))>
			<cfset Local.search.landingContent = Model('Procedure').findAll(select='galleryTopContent',where='id='&val(params.procedure)).galleryTopContent>
			<cfset Local.search.searchHeader = "#Model('Procedure').findAll(select='name',where='id='&val(params.procedure)).name# Before and After Photos">
			<cfif (val(params.location.city) gt 0 and val(params.location.state) gt 0)>
				<cfset Local.search.searchHeader &= " #params.location.cityname#, #params.location.statename#">
				<cfset Local.search.searchSummary = "">
				<cfset Local.search.landingContent = "">
			<cfelseif val(params.location.state) gt 0>
				<cfset Local.search.searchHeader &= " in #params.location.statename#">
				<cfset Local.search.searchSummary = "">
				<cfset Local.search.landingContent = "">
			<cfelseif doNotIndex EQ false>
				<cfset Local.search.headerLink = LinkTo(href=Request.CurrentURL,text=Local.search.searchHeader)>
			</cfif>
		</cfif>

		<cfif val(params.procedure)>
			<cfset procedurename = Model('Procedure').findAll(select="name",where='id=#val(params.procedure)#').name>
		</cfif>
		<cfif val(params.specialty)>
			<cfset specialtyname = Model('Specialty').findAll(select="name",where='id=#val(params.specialty)#').name>
		</cfif>
		<cfif val(params.bodypart)>
			<cfset bodypartname = Model('BodyPart').findAll(select="name",where='id=#val(params.bodypart)#').name>
		</cfif>
		<cfif val(params.doctor)>
			<cfset doctorInfo = Model('AccountDoctor').findAll(where='id=#val(params.doctor)#')>
			<cfset fullName = "#doctorInfo.firstname# #Iif(doctorInfo.middlename neq '',DE(doctorInfo.middlename&' '),DE('')) & doctorInfo.lastname#">
			<cfif LCase(doctorInfo.title) eq "dr" or LCase(doctorInfo.title) eq "dr.">
				<cfset fullName = "Dr. #fullName#">
			<cfelseif doctorInfo.title neq "">
				<cfset fullName &= ", #doctorInfo.title#">
			</cfif>
		</cfif>
		<cfif val(params.gender)>
			<cfset gendername = Model('GalleryGender').findAll(select="name",where='id=#val(params.gender)#').name>
		</cfif>

		<cfset local.search.pagetitle = "">
		<cfset local.search.metadescription = "">
		<cfif val(params.bodypart)>
			<!--- <cfif val(params.procedure)>
				<cfif val(params.gender)>
					<cfif val(params.doctor)>
						<cfset local.search.pagetitle = "">
						<cfset local.search.metadescription = "">
					<cfelse>
						<cfset local.search.pagetitle = "#gendername# #procedurename# Pictures of the #LCase(bodypartname)#">
						<cfset local.search.metadescription = "#procedurename# Pictures, Before & After gallery pictures for #LCase(gendername)# #LCase(bodypartname)#, photos for #procedurename# of #LCase(gendername)#s">
					</cfif>
				<cfelse>
					<cfset local.search.pagetitle = "">
					<cfset local.search.metadescription = "">
				</cfif>
			<cfelse> --->
			<cfif val(params.gender)>
				<cfset local.search.pagetitle = "Before and After Pictures of the #LCase(gendername)# #LCase(bodypartname)#">
				<cfset local.search.metadescription = "Before & After gallery pictures of the #LCase(gendername)# #LCase(bodypartname)#">
			<cfelse>
				<cfset local.search.pagetitle = "Before and After Pictures of the #LCase(bodypartname)#">
				<cfset local.search.metadescription = "Before & After gallery pictures of the #LCase(bodypartname)#">
			</cfif>
			<!--- </cfif> --->
		<cfelseif val(params.procedure)>
			<!--- <cfif val(params.doctor)>
				<cfif val(params.gender)>
					<cfset local.search.pagetitle = "">
					<cfset local.search.metadescription = "">
				<cfelse>
					<cfset local.search.pagetitle = "">
					<cfset local.search.metadescription = "">
				</cfif> --->
			<cfif val(params.location.city) and val(params.location.state)>
				<cfset local.search.pagetitle = "#procedurename# Pictures in #params.location.cityname#, #params.location.stateabbr# - Before & After Photos">
				<cfset local.search.metadescription = "View #procedurename# Before and After Photos in #params.location.cityname#, #params.location.stateabbr# on LocateADoc.com and find a doctor in your area.">
			<cfelseif val(params.location.state)>
				<cfset local.search.pagetitle = "#procedurename# Pictures in #params.location.statename# - Before & After Photos">
				<cfset local.search.metadescription = "View #procedurename# Before and After Photos in #params.location.statename# on LocateADoc.com and find a doctor in your area.">
			<cfelse>
				<cfset local.search.pagetitle = "#procedurename# Pictures - Before & After Photos">
				<cfset local.search.metadescription = "View #procedurename# Before and After Photos on LocateADoc.com and find a doctor in your area.">
			</cfif>
		<!--- <cfelseif val(params.specialty)>
			<cfif val(params.location.city) and val(params.location.state)>
				<cfset local.search.pagetitle = "#specialtyname# Pictures in #params.location.cityname#, #params.location.stateabbr# - Before & After Photos">
				<cfset local.search.metadescription = "View #specialtyname# Before and After Photos in #params.location.cityname#, #params.location.stateabbr# on LocateADoc.com and find a doctor in your area.">
			<cfelseif val(params.location.state)>
				<cfset local.search.pagetitle = "#specialtyname# Pictures in #params.location.statename# - Before & After Photos">
				<cfset local.search.metadescription = "View #specialtyname# Before and After Photos in #params.location.statename# on LocateADoc.com and find a doctor in your area.">
			<cfelse>
				<cfset local.search.pagetitle = "#specialtyname# Pictures - Before & After Photos">
				<cfset local.search.metadescription = "View #specialtyname# Before and After Photos on LocateADoc.com and find a doctor in your area.">
			</cfif> --->
		<!--- <cfelseif val(params.gender)>
			<cfset local.search.pagetitle = "#gendername# Before and After Pictures of Surgery - Photos of Medical, Health and Dental Procedures">
			<cfset local.search.metadescription = "#gendername# before and after pictures of cosmetic and plastic surgery, dental, medical and health images after surgical procedures."> --->
		</cfif>

		<cfreturn Local.search>
	</cffunction>

	<cffunction name="storeCriteria" access="private">
		<cfargument name="forProfile" required="false" default="false">
		<!--- Save search criteria for case view --->
		<cfset searchCriteria ={distance = params.distance,
								location = params.location.querystring,
								state = params.state,
								city = params.city,
								country = params.country,
								doctorlastname = params.doctorlastname,
								specialty = params.specialty,
								doctor = params.doctor,
								bodypart = params.bodypart,
								procedure = params.procedure,
								gender = params.gender,
								skintone = params.skintone,
								afterphotos_taken = params.afterphotos_taken,
								breast_size_start = params.breast_size_start,
								breast_size_end = params.breast_size_end,
								implant_type = params.implant_type,
								implant_placement = params.implant_placement,
								point_of_entry = params.point_of_entry,
								age = params.age,
								age_start = params.age_start,
								age_end = params.age_end,
								height = params.height,
								height_start = params.height_start,
								height_end = params.height_end,
								weight = params.weight,
								weight_start = params.weight_start,
								weight_end = params.weight_end,
								sortby = params.sortby,
								exclude = params.exclude,
								returnURL = request.currentURL
		}>
		<cfif arguments.forProfile>
			<cfset Client.lastProfileGallerySearch = SerializeJSON(searchCriteria)>
		<cfelse>
			<cfset Client.lastGallerySearch = SerializeJSON(searchCriteria)>
		</cfif>
	</cffunction>

	<cffunction name="recordHit" access="private">
		<cfparam name="params.specialty"		default="">
		<cfparam name="params.procedure"		default="">
		<cfparam name="params.bodypart" 		default="">
		<cfparam name="params.stateId" 			default="">
		<cfparam name="params.cityId" 			default="">
		<cfparam name="params.doctor"			default="">
		<cfparam name="params.galleryCaseId"	default="">

		<cfif not Client.IsSpider>
			<cfset model("HitsGallery").RecordHitDelayed(params	= params)>
		</cfif>
	</cffunction>

	<cffunction name="logit" access="private">
		<cfargument name="text" type="string" default="">
		<cfargument name="new" type="boolean" default="false">
		<cfif val(len(arguments.text))>
			<cfif arguments.new>
				<cffile action="write" file="#LAD3galleryImagePath#/BAAG_Images_Conversion_Log.txt" output="#arguments.text##chr(13)#">
			<cfelse>
				<cffile action="append" file="#LAD3galleryImagePath#/BAAG_Images_Conversion_Log.txt" output="#arguments.text##chr(13)#">
			</cfif>
		</cfif>
	</cffunction>

</cfcomponent>