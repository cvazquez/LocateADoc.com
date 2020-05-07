<cfcomponent extends="Controller" output="false">

	<cfset doNotIndex = true>

 	<cffunction name="init">
		<cfset filters(through="recordHit",only="results")>
		<cfset provides("html,json")>
	</cffunction>

	<cffunction name="results">
		<cfset var local = {}>

		<cfparam default="false" name="client.debug" type="boolean">

		<cfset local.strctResultsSpecialties = {}>
		<cfset local.specialtyCount = 0>

		<cfset local.strctResultsProcedures = {}>
		<cfset local.procedureCount = 0>

		<cfset local.strctResultsStates = {}>
		<cfset local.stateCount = 0>

		<cfset local.strctResultsCities = {}>
		<cfset local.cityCount = 0>

		<cfset local.strctResultsPostalCodes = {}>
		<cfset local.postalCodeCount = 0>

		<cfset local.comboSpecialtyStateCityCount = 0>
		<cfset local.comboSpecialtyCityCount = 0>
		<cfset local.comboSpecialtyStateCount = 0>

		<cfset local.comboProcedureStateCityCount = 0>
		<cfset local.comboProcedureCityCount = 0>
		<cfset local.comboProcedureStateCount = 0>

		<cfset local.comboStateCityCount = 0>

		<cfset local.articleCount = 0>
		<cfset local.strctResultsArticles = {}>

		<cfset local.blogCount = 0>
		<cfset local.strctResultsBlogs = {}>

		<cfset local.procedureIdList = "">

		<cfset local.strctResultsPostalCanadaCodes = {}>
		<cfset local.postalCodeCanadaCount = 0>

		<cfset local.procedureAverageScore = 0>
		<cfset local.procedureTotalScore = 0>
		<cfset local.procedureMaxScore = 0>
		<cfset local.procedurePriority = FALSE>
		<cfset local.procedureHasResults = FALSE>

		<cfset local.specialtyAverageScore = 0>
		<cfset local.specialtyTotalScore = 0>
		<cfset local.specialtyMaxScore = 0>

		<cfset local.qDoctorsTemp = QueryNew("")>

		<cfset local.doctorNameCount = 0>
		<cfset local.strctResultsDoctorNames = {}>
		<cfset local.doctorNameAverageScore = 0>
		<cfset local.doctorNameTotalScore = 0>
		<cfset local.doctorNameMaxScore = 0>

		<cfset local.returnLimit = 4>


		<cfset explicitAd = FALSE>
		<cfset displayAd = TRUE>
		<cfset adType = "generic">
		<cfset debugText = "">

		<cfset resultCount = 0>
		<cfset guideCount = 0>
		<cfset featuresAndArticlesCount = 0>
		<cfset galleryCount = 0>
		<cfset askADoctorCount = 0>
		<cfset AskADoctorLimit = 0>
		<cfset galleryURLPrefix = "/pictures/search/">
		<cfset viewAllGalleriesURL = "">

		<cfset variables.strctGallery = {}>
		<cfset variables.strctGallery.specialtyId = "">
		<cfset variables.strctGallery.procedureIds = "">
		<cfset variables.strctGallery.Location = {
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
		<cfset qGalleries = QueryNew("")>


		<cfset local.distance = 100>

		<cfset thisURLPrefix = "/doctors/search/">

		<cfset qDoctors = QueryNew("")>
		<cfset viewAllDoctorsURL = "">

		<cfset strctURLDoctorSearchLocation = {}>

		<cfset urlDoctorSearchLocationCount = 0>
		<cfset doctorCount = 0>

		<cfset params.key = trim(ListChangeDelims(params.key, " "))>

		<cfif params.key EQ "">
			 <cfset renderPage()>
			 <cfreturn />
		</cfif>

		<cfset title = "Search Results For: #params.key#">

		<cfset local.qSearchResults = model("SearchIndex").GetSiteSearch(terms = params.key)>


		<cfset local.qDoctorAndPracticeNames = model("SearchIndex").
											GetDoctorAndPracticeNames(	terms 		= params.key,
																		limitCount	= local.returnLimit)>
		<cfset local.doctorNameCount = local.qDoctorAndPracticeNames.recordCount>

		<cfloop query="local.qDoctorAndPracticeNames">
			<cfset local.doctorNameTotalScore = local.doctorNameTotalScore + local.qDoctorAndPracticeNames.score>
			<cfset local.doctorNameMaxScore =
					(local.qDoctorAndPracticeNames.score GT local.doctorNameMaxScore ?
					local.qDoctorAndPracticeNames.score : local.doctorNameMaxScore)>
		</cfloop>


		<cfset qGuideResults = model("SearchIndex").GetGuides(	terms 		= params.key,
																limitCount = local.returnLimit)>
		<cfset guideCount = model("SearchIndex").GetFoundRows()>
		<cfset guideLimit = (guideCount GT 2 ? 2 : guideCount)>


		<cfset qFeaturesAndArticlesResults = model("SearchIndex").GetFeaturesAndArticles(	terms 		= params.key,
																							limitCount	= local.returnLimit)>
		<cfset featuresAndArticlesCount = model("SearchIndex").GetFoundRows()>
		<cfset featuresAndArticlesLimit = (featuresAndArticlesCount GT 2 ? 2 : featuresAndArticlesCount)>

		<cfset qAskADoctorResults = model("SearchIndex").GetAskADoctor(	terms 		= params.key,
																		limitCount	= local.returnLimit)>
		<cfset AskADoctorCount = model("SearchIndex").GetFoundRows()>
		<cfset AskADoctorLimit = (AskADoctorCount GT 2 ? 2 : AskADoctorCount)>


		<cfset startTick = getTickcount()>
		<cfloop query="local.qSearchResults">

			<!--- Catalogue the type of search terms --->
			<cfswitch expression="#local.qSearchResults.recordType#">
				<cfcase value="cities">
					<cfset local.cityCount = local.cityCount + 1>
					<cfset local.strctResultsCities[local.cityCount] = {}>
					<cfset local.strctResultsCities[local.cityCount].id = local.qSearchResults.id>
					<cfset local.strctResultsCities[local.cityCount].name = local.qSearchResults.name>
					<cfset local.strctResultsCities[local.cityCount].countryId = local.qSearchResults.extra1>
				</cfcase>

				<cfcase value="states">
					<cfset local.stateCount = local.stateCount + 1>
					<cfset local.strctResultsStates[local.stateCount] = {}>
					<cfset local.strctResultsStates[local.stateCount].id = local.qSearchResults.id>
					<cfset local.strctResultsStates[local.stateCount].name = local.qSearchResults.name>
					<cfset local.strctResultsStates[local.stateCount].countryId = local.qSearchResults.extra1>
				</cfcase>

				<cfcase value="specialties">
					<!--- An exact match is found, probably because the user used auto-suggesstion --->
					<cfif specialtyCount EQ 1 AND local.strctResultsSpecialties[1].score EQ 100>
						<cfcontinue>
					</cfif>

					<cfset specialtyCount = specialtyCount + 1>
					<cfset local.strctResultsSpecialties[specialtyCount] = {}>
					<cfset local.strctResultsSpecialties[specialtyCount].id = local.qSearchResults.id>
					<cfset local.strctResultsSpecialties[specialtyCount].name = local.qSearchResults.name>
					<cfset local.strctResultsSpecialties[specialtyCount].hasGallery = local.qSearchResults.extra2>
					<cfset local.strctResultsSpecialties[specialtyCount].score = local.qSearchResults.score>


					<cfset local.specialtyTotalScore = local.specialtyTotalScore + local.qSearchResults.score>
					<cfset local.specialtyMaxScore =
							(local.qSearchResults.score GT local.specialtyMaxScore ?
							local.qSearchResults.score : local.specialtyMaxScore)>
				</cfcase>

				<cfcase value="procedures">
					<!--- An exact match is found, probably because the user used auto-suggesstion --->
					<cfif procedureCount EQ 1 AND local.strctResultsProcedures[1].score EQ 100>
						<cfcontinue>
					</cfif>

					<cfset procedureCount = procedureCount + 1>
					<cfset local.strctResultsProcedures[procedureCount] = {}>
					<cfset local.strctResultsProcedures[procedureCount].id = local.qSearchResults.id>
					<cfset local.strctResultsProcedures[procedureCount].name = local.qSearchResults.name>
					<cfset local.strctResultsProcedures[procedureCount].hasGallery = local.qSearchResults.extra2>
					<cfset local.strctResultsProcedures[procedureCount].score = local.qSearchResults.score>

					<cfset local.procedureIdList = ListAppend(local.procedureIdList, local.qSearchResults.id)>

					<cfif local.qSearchResults.extra1 EQ 1>
						<cfset explicitAd = TRUE>
					</cfif>

					<cfset local.procedureTotalScore = local.procedureTotalScore + local.qSearchResults.score>
					<cfset local.procedureMaxScore =
							(local.qSearchResults.score GT local.procedureMaxScore ?
							local.qSearchResults.score : local.procedureMaxScore)>
				</cfcase>

				<cfcase value="postalCodesUS">
					<cfset local.postalCodeCount = local.postalCodeCount + 1>
					<cfset local.strctResultsPostalCodes[local.postalCodeCount] = {}>
					<cfset local.strctResultsPostalCodes[local.postalCodeCount].id = local.qSearchResults.id>
					<cfset local.strctResultsPostalCodes[local.postalCodeCount].name = local.qSearchResults.name>
					<cfset local.strctResultsPostalCodes[local.postalCodeCount].latitude = local.qSearchResults.extra1>
					<cfset local.strctResultsPostalCodes[local.postalCodeCount].longitude = local.qSearchResults.extra2>
				</cfcase>

				<cfcase value="postalCodesCanada">
					<cfset local.postalCodeCanadaCount = local.postalCodeCanadaCount + 1>
					<cfset local.strctResultsPostalCanadaCodes[local.postalCodeCanadaCount] = {}>
					<cfset local.strctResultsPostalCanadaCodes[local.postalCodeCanadaCount].id = local.qSearchResults.id>
					<cfset local.strctResultsPostalCanadaCodes[local.postalCodeCanadaCount].name = local.qSearchResults.name>
					<cfset local.strctResultsPostalCanadaCodes[local.postalCodeCanadaCount].latitude = local.qSearchResults.extra1>
					<cfset local.strctResultsPostalCanadaCodes[local.postalCodeCanadaCount].longitude = local.qSearchResults.extra2>
					<cfset local.strctResultsPostalCanadaCodes[local.postalCodeCanadaCount].stateId = local.qSearchResults.extra3>
				</cfcase>
			</cfswitch>
		</cfloop>

		<!--- Determine if the specialty or procedure should be searched on --->
		<cfif specialtyCount GT 0>
			<cfset local.specialtyAverageScore = local.specialtyTotalScore / specialtyCount>
		</cfif>
		<cfif procedureCount GT 0>
			<cfset local.procedureAverageScore = local.procedureTotalScore / procedureCount>
		</cfif>

		<cfif local.doctorNameCount GT 0>
			<cfset local.doctorNameAverageScore = local.doctorNameTotalScore / local.doctorNameCount>
		</cfif>

		<cfif local.procedureMaxScore GT local.specialtyMaxScore OR local.procedureAverageScore GT local.specialtyAverageScore>
			<cfset local.procedurePriority = TRUE>
		</cfif>


		<!--- If no city, state or postal code is entered, then see if we cookied the city and state and attempt a location search on them --->
		<!--- If the doctor name count is high, but procedure or specialty count is high, then it's probably a specialty or procedure --->
		<cfif local.stateCount EQ 0 AND local.cityCount EQ 0 AND
				local.postalCodeCount EQ 0 AND local.postalCodeCanadaCount EQ 0 AND
				isnumeric(client.city) AND isnumeric(client.state) AND
				(specialtyCount GT 0 OR procedureCount GT 0)
				AND local.doctorNameMaxScore NEQ 100>

			<cfset qCity = model("city").findByKey(	key			= client.city,
													select		= "name",
													returnAs	= "query")>

			<cfset qState = model("state").findByKey(	key			= client.state,
														select		= "name, countryId",
														returnAs	= "query")>

			<cfset local.cityCount = 1>
			<cfset local.strctResultsCities[local.cityCount] = {}>
			<cfset local.strctResultsCities[local.cityCount].id = client.city>
			<cfset local.strctResultsCities[local.cityCount].name = qCity.name>
			<cfset local.strctResultsCities[local.cityCount].countryId = qState.countryId>

			<cfset local.stateCount = 1>
			<cfset local.strctResultsStates[local.stateCount] = {}>
			<cfset local.strctResultsStates[local.stateCount].id = client.state>
			<cfset local.strctResultsStates[local.stateCount].name = qState.name>
			<cfset local.strctResultsStates[local.stateCount].countryId = qState.countryId>
		</cfif>

		<cfset local.comboSpecialtyStateCityCount = specialtyCount * local.stateCount * local.cityCount>
		<cfset local.comboSpecialtyCityCount = specialtyCount * local.cityCount>
		<cfset local.comboSpecialtyStateCount = specialtyCount * local.stateCount>
		<cfset local.comboSpecialtypostalCodeCount = specialtyCount * local.postalCodeCount>
		<cfset local.comboSpecialtypostalCodeCanadaCount = specialtyCount * local.postalCodeCanadaCount>

		<cfset local.comboProcedureStateCityCount = procedureCount * local.stateCount * local.cityCount>
		<cfset local.comboProcedureCityCount = procedureCount * local.cityCount>
		<cfset local.comboProcedureStateCount = procedureCount * local.stateCount>
		<cfset local.comboProcedurepostalCodeCount = procedureCount * local.postalCodeCount>
		<cfset local.comboProcedurepostalCodeCanadaCount = procedureCount * local.postalCodeCanadaCount>

		<cfset local.comboStateCityCount = local.stateCount * local.cityCount>

		<cfset urlDoctorSearchLocationCount = 0>


		<cfif procedurePriority IS TRUE>
			<cfif procedureCount GT 0>
				<cfset ProcedureResults(local)>
			</cfif>

			<cfif qDoctors.recordCount EQ 0 AND specialtyCount GT 0>
				<cfset SpecialtyResults(local)>
			</cfif>
		<cfelse>
			<cfif specialtyCount GT 0>
				<cfset SpecialtyResults(local)>
			</cfif>

			<cfif qDoctors.recordCount EQ 0 AND procedureCount GT 0>
				<cfset ProcedureResults(local)>
			</cfif>
		</cfif>


		<cfif local.comboStateCityCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-orlando_fl/ --->
			<cfloop from="1" to="#local.cityCount#" index="iCities">
				<cfloop from="1" to="#local.stateCount#" index="iStates">
					<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
						"location-" & local.strctResultsCities[iCities].name &
						"_" & local.strctResultsStates[iStates].name &
						"/">

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title =
						local.strctResultsCities[iCities].name & ", " & local.strctResultsStates[iStates].name>

					<!--- Redirect to Doctor Search if City, State or Zip only is searched for --->
					<cfif local.specialtyCount EQ 0 AND procedureCount EQ 0>
						<cfset thisURL = "/doctors/search/#lcase(strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink)#">
						<cflocation url="#thisURL#" addtoken="no">
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>


		<cfif local.stateCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-fl/ --->
			<cfloop from="1" to="#stateCount#" index="iStates">
				<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
				<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

				<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
					"location-" & local.strctResultsStates[iStates].name &
					"/">

				<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title = local.strctResultsStates[iStates].name>

				<!--- Redirect to Doctor Search if City, State or Zip only is searched for --->
				<cfif local.specialtyCount EQ 0 AND local.procedureCount EQ 0 AND local.strctResultsStates[iStates].name EQ params.key>
					<cfset thisURL = "/doctors/search/#lcase(strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink)#">
					<cflocation url="#thisURL#" addtoken="no">
				</cfif>
			</cfloop>
		</cfif>

		<cfif cityCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-orlando_fl/ --->
			<cfloop from="1" to="#local.cityCount#" index="iCities">
				<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
				<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

				<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
					"location-" & local.strctResultsCities[iCities].name &
					"/">

				<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title = local.strctResultsCities[iCities].name>

				<!--- Redirect to Doctor Search if City, State or Zip only is searched for --->
				<cfif local.specialtyCount EQ 0 AND local.procedureCount EQ 0 AND local.strctResultsCities[iCities].name EQ params.key>
					<cfset thisURL = "/doctors/search/#lcase(strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink)#">
					<cflocation url="#thisURL#" addtoken="no">
				</cfif>
			</cfloop>
		</cfif>

		<cfif local.postalCodeCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-32814 --->
			<cfloop from="1" to="#local.postalCodeCount#" index="iPostalCodes">
				<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
				<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

				<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
					"location-" & local.strctResultsPostalCodes[iPostalCodes].name & "/">

				<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title = local.strctResultsPostalCodes[iPostalCodes].name>

				<!--- Redirect to Doctor Search if City, State or Zip only is searched for --->
				<cfif local.specialtyCount EQ 0 AND local.procedureCount EQ 0>
					<cfset thisURL = "/doctors/search/#lcase(strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink)#">
					<cflocation url="#thisURL#" addtoken="no">
				</cfif>
			</cfloop>
		</cfif>

		<cfif local.postalCodeCanadaCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-V5Z 1C6 --->
			<cfloop from="1" to="#local.postalCodeCanadaCount#" index="iPostalCodes">
				<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
				<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

				<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
					"location-" & local.strctResultsPostalCanadaCodes[iPostalCodes].name & "/country-CA">

				<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title = local.strctResultsPostalCanadaCodes[iPostalCodes].name>

				<!--- Redirect to Doctor Search if City, State or Zip only is searched for --->
				<cfif local.specialtyCount EQ 0 AND local.procedureCount EQ 0>
					<cfset thisURL = "/doctors/search/#lcase(strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink)#">
					<cflocation url="#thisURL#" addtoken="no">
				</cfif>
			</cfloop>
		</cfif>

		<cfif qDoctors.recordCount EQ 0 AND local.qDoctorAndPracticeNames.recordCount GT 0>
			<cfset qDoctors = local.qDoctorAndPracticeNames>
		</cfif>


		<cfif qDoctors.recordCount GT 0>
			<cfquery datasource="#get('dataSourceName')#" name="local.count">
				Select Found_Rows() AS foundrows
			</cfquery>

			<cfset doctorCount = local.count.foundrows>

			<cfif isnumeric(variables.strctGallery.specialtyId) OR listLen(variables.strctGallery.procedureIds)>

				<cfif isnumeric(variables.strctGallery.specialtyId) AND NOT listLen(variables.strctGallery.procedureIds)>
					<cfset variables.strctGallery.procedureIds  = model("SearchIndex").GetSpecialtyProcedureIds(specialtyId = variables.strctGallery.specialtyId)>
				</cfif>

				<cfset variables.strctGalleryResults 	= model("GalleryCase").gallerySearch(
								distance				= val(local.distance),
								location				= variables.strctGallery.Location,
								doctorLastname			= "",
								doctorSpecialty			= val(variables.strctGallery.specialtyId),
								procedureId				= variables.strctGallery.procedureIds,
								sortBy					= "g.galleryCaseId desc",
								filtersOn				= FALSE,
								perpage					= 3,
								PracticeRanked			= TRUE
							)>

				<cfif variables.strctGalleryResults.totalRecords EQ 0
						AND isnumeric(variables.strctGallery.Location.city)
						AND isnumeric(variables.strctGallery.Location.state)>
					<!--- If a city search was done and no results, then try just a state --->

					<cfset variables.strctGallery.Location.city = "">
					<cfset variables.strctGallery.Location.cityFound = false>

					<cfset variables.strctGalleryResults 	= model("GalleryCase").gallerySearch(
									distance				= val(local.distance),
									location				= variables.strctGallery.Location,
									doctorLastname			= "",
									doctorSpecialty			= val(variables.strctGallery.specialtyId),
									procedureId				= variables.strctGallery.procedureIds,
									sortBy					= "g.galleryCaseId desc",
									filtersOn				= FALSE,
									perpage					= 3,
									PracticeRanked			= TRUE
								)>
				</cfif>



				<cfset galleryCount	= variables.strctGalleryResults.totalRecords>
				<cfset qGalleries	= variables.strctGalleryResults.results>

				<cfif galleryCount GT 0 AND ListLen(qGalleries.procedureIds)>
					<!--- A hack to replace the procedure in the View All URL with one that has cases --->
					<cfset viewAllGalleriesURL = ReReplaceNoCase(viewAllGalleriesURL, "procedure-[0-9]+", "procedure-" & listFirst(qGalleries.procedureIds))>
				</cfif>

				<cfif val(local.distance) GT 0>
					<!--- Another hack to add the distance to the URL --->
					<cfset viewAllGalleriesURL = viewAllGalleriesURL & "distance-" & local.distance>
				</cfif>
			</cfif>
		</cfif>

		<cfset viewAllDoctorsURL = lCase(viewAllDoctorsURL)>
		<cfset resultCount = doctorCount + galleryCount + guideCount + featuresAndArticlesCount + askADoctorCount>

		<cfif client.debug IS TRUE>
		<cfsavecontent variable="debugText">
		<cfoutput>
		<div style="padding-left: 150px;">
			<p>Structure Creation: #getTickCount() - startTick#</p>
			<p>explicitAd = #explicitAd#</p>
			<cfif local.cityCount GT 0>
				<p>local.strctResultsCities[1].name = #local.strctResultsCities[1].name#</p>
			</cfif>
			<cfif local.stateCount GT 0>
				<p>local.strctResultsStates[1].name = #local.strctResultsStates[1].name#</p>
			</cfif>
			<cfif local.specialtyCount GT 0>
				<p>local.strctResultsSpecialties = <cfdump var="#local.strctResultsSpecialties#"></p>
			</cfif>
			<cfif local.procedureCount GT 0>
				<p>local.strctResultsProcedures = <cfdump var="#local.strctResultsProcedures#"></p>
			</cfif>
			<p>comboSpecialtyPostalCodeCanadaCount = #local.comboSpecialtyPostalCodeCanadaCount#</p>
			<p>local.comboProcedurePostalCodeCanadaCount = #local.comboProcedurePostalCodeCanadaCount#</p>

			<p>local.specialtyTotalScore = #local.specialtyTotalScore#</p>
			<p>local.procedureTotalScore = #local.procedureTotalScore#</p>
			<p>local.specialtyAverageScore = #local.specialtyAverageScore#</p>
			<p>local.procedureAverageScore = #local.procedureAverageScore#</p>
			<p>local.procedurePriority = #local.procedurePriority#</p>

			<p><cfdump var="#local.qSearchResults#"></p>
			<p><cfdump var="#local.qDoctorAndPracticeNames#"></p>
			<p><cfdump var="#variables.strctGallery.Location#"></p>
			<p><cfdump var="#qGuideResults#"></p>
			<p><cfdump var="#qFeaturesAndArticlesResults#"></p>


			<cfif urlDoctorSearchLocationCount GT 0>
				<p>
				<cfloop from="1" to="#urlDoctorSearchLocationCount#" index="iURL">
					<cfset thisURL = "#thisURLPrefix##lcase(strctURLDoctorSearchLocation[iURL].urlLink)#">
					<a href="#thisURL#" target="_blank">#strctURLDoctorSearchLocation[iURL].title#</a> - #thisURL#<br />
				</cfloop>
				</p>
			</cfif>
		</div>
		</cfoutput>
		</cfsavecontent>
		</cfif>

	</cffunction>

	<cffunction name="AutoSuggest" hint="For AJAX requests">
		<cfparam default="" name="params.term">
		<!---
		http://carlos3.locateadoc.com/search/AutoSuggest?format=json&debug=0&term=Breast%20Re&reload=true
		http://carlos3.locateadoc.com/?controller=search&action=AutoSuggest&format=json&debug=0&term=Breast
		--->
		<cfset qSearchResults = model("SearchIndex").GetAutoSuggest(terms = params.term)>

		<cfset renderWith(	data					= qSearchResults,
							hideDebugInformation	= true,
							layout					= false)>
	</cffunction>


	<cffunction name="SpecialtyResults" access="private">
		<cfargument name="local" required="true" type="struct">


		<cfif local.comboSpecialtyStateCityCount GT 0>
			<!--- location-orlando_fl/specialty-25/ --->
			<cfloop from="1" to="#local.cityCount#" index="iCities">
				<cfloop from="1" to="#local.stateCount#" index="iStates">
					<cfloop from="1" to="#local.specialtyCount#" index="iSpecialties">
						<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
						<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

						<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
							"location-" & local.strctResultsCities[iCities].name &
							"_" & local.strctResultsStates[iStates].name &
							"/specialty-" & local.strctResultsSpecialties[iSpecialties].id & "/">

						<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title =
							local.strctResultsSpecialties[iSpecialties].name & " " &
							local.strctResultsCities[iCities].name & ", " & local.strctResultsStates[iStates].name>

						<!--- Only do a city/state search if the city or state appears only once in list ---->
						<cfif qDoctors.recordCount EQ 0>

							<cfif local.strctResultsStates[iStates].name EQ local.strctResultsCities[iCities].name AND ArrayLen(REMatchNocase(local.strctResultsStates[iStates].name, params.key)) GT 1>
								<!--- For a search like location-florida_fl/specialty-25/ where florida is a city and state --->
							<cfelseif local.strctResultsStates[iStates].name EQ local.strctResultsCities[iCities].name AND ArrayLen(REMatchNocase(local.strctResultsStates[iStates].name, params.key)) EQ 1>
								<!--- For a search like location-new york/specialty-25/ where new york can be the city and state --->
							</cfif>

							<cfset qDoctors = model("AccountDoctorLocation").GetFeatured(
										info =			"featured",
										city =			val(local.strctResultsCities[iCities].id),
										state =			val(local.strctResultsStates[iStates].id),
										specialtyId =	val(local.strctResultsSpecialties[iSpecialties].id),
										limit		=	local.returnLimit,
										overrideClient	= TRUE)>

							<cfif qDoctors.recordCount EQ 0>
								<cfset qDoctors = model("AccountDoctorLocation").doctorSearchMultiQuery(
											info =			"search",
											city =			val(local.strctResultsCities[iCities].id),
											state =			val(local.strctResultsStates[iStates].id),
											specialtyId =	val(local.strctResultsSpecialties[iSpecialties].id),
											limit		=   local.returnLimit,
											overrideClient	= TRUE)>
							</cfif>

							<cfif viewAllDoctorsURL EQ "">
								<cfset viewAllDoctorsURL = thisURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
							</cfif>

							<cfif qDoctors.recordCount GT 0 AND local.strctResultsSpecialties[iSpecialties].hasGallery EQ 1>
								<cfset variables.strctGallery.Location = {
										country		= local.strctResultsStates[iStates].countryId,
										state		= val(local.strctResultsStates[iStates].id),
										statename	= local.strctResultsStates[iStates].name,
										city		= val(local.strctResultsCities[iCities].id),
										cityname	= local.strctResultsCities[iCities].name,
										zipcode		= "",
										zipfound	= false,
										longitude	= "",
										latitude	= "",
										cityFound	= true,
										stateFound	= true
									}>

								<cfset variables.strctGallery.specialtyId = val(local.strctResultsSpecialties[iSpecialties].id)>
								<cfset viewAllGalleriesURL = galleryURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
							</cfif>
						</cfif>
					</cfloop>
				</cfloop>
			</cfloop>
		</cfif>

		<cfif local.comboSpecialtyStateCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-fl/specialty-25/ --->
			<cfloop from="1" to="#local.stateCount#" index="iStates">
				<cfloop from="1" to="#local.specialtyCount#" index="iSpecialties">
					<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
						"location-" & local.strctResultsStates[iStates].name &
						"/specialty-" & local.strctResultsSpecialties[iSpecialties].id & "/">

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title =
							local.strctResultsSpecialties[iSpecialties].name & " " &
							local.strctResultsStates[iStates].name>

					<cfif qDoctors.recordCount EQ 0>
						<cfset qDoctors = model("AccountDoctorLocation").GetFeatured(
									info =			"featured",
									state =			val(local.strctResultsStates[iStates].id),
									specialtyId =	val(local.strctResultsSpecialties[iSpecialties].id),
									limit		=	local.returnLimit,
									overrideClient	= TRUE)>

						<cfif qDoctors.recordCount EQ 0>
							<cfset qDoctors = model("AccountDoctorLocation").doctorSearchMultiQuery(
										info =			"search",
										state =			val(local.strctResultsStates[iStates].id),
										specialtyId =	val(local.strctResultsSpecialties[iSpecialties].id),
										limit		=   local.returnLimit,
										overrideClient	= TRUE)>
						</cfif>

						<cfif viewAllDoctorsURL EQ "">
							<cfset viewAllDoctorsURL = thisURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
						</cfif>

						<cfif local.strctResultsSpecialties[iSpecialties].hasGallery EQ 1>
							<cfset variables.strctGallery.Location = {
									country		= local.strctResultsStates[iStates].countryId,
									state		= val(local.strctResultsStates[iStates].id),
									statename	= local.strctResultsStates[iStates].name,
									city		= "",
									cityname	= "",
									zipcode		= "",
									zipfound	= false,
									longitude	= "",
									latitude	= "",
									cityFound	= false,
									stateFound	= true
								}>

							<cfset variables.strctGallery.specialtyId = val(local.strctResultsSpecialties[iSpecialties].id)>
							<cfset viewAllGalleriesURL = galleryURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
						</cfif>
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>



		<cfif local.comboSpecialtyCityCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-orlando/specialty-25/ --->
			<cfloop from="1" to="#local.cityCount#" index="iCities">
				<cfloop from="1" to="#local.specialtyCount#" index="iSpecialties">
					<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
						"location-" & local.strctResultsCities[iCities].name &
						"/specialty-" & local.strctResultsSpecialties[iSpecialties].id & "/">

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title =
							local.strctResultsSpecialties[iSpecialties].name & " " &
							local.strctResultsCities[iCities].name>

						<cfif qDoctors.recordCount EQ 0>
							<cfset qDoctors = model("AccountDoctorLocation").GetFeatured(
										info =			"featured",
										city =			val(local.strctResultsCities[iCities].id),
										specialtyId =	val(local.strctResultsSpecialties[iSpecialties].id),
										limit		=	local.returnLimit,
										overrideClient	= TRUE,
										overrideZoneLimit	= TRUE)>

							<cfif qDoctors.recordCount EQ 0>
								<cfset qDoctors = model("AccountDoctorLocation").doctorSearchMultiQuery(
											info =			"search",
											city =			val(local.strctResultsCities[iCities].id),
											specialtyId =	val(local.strctResultsSpecialties[iSpecialties].id),
											limit		=   local.returnLimit,
											overrideClient	= TRUE)>
							</cfif>

							<cfif viewAllDoctorsURL EQ "">
								<cfset viewAllDoctorsURL = thisURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
							</cfif>

							<cfif local.strctResultsSpecialties[iSpecialties].hasGallery EQ 1>
								<cfset variables.strctGallery.Location = {
										country		= local.strctResultsCities[iCities].countryId,
										state		= "",
										statename	= "",
										city		= val(local.strctResultsCities[iCities].id),
										cityname	= local.strctResultsCities[iCities].name,
										zipcode		= "",
										zipfound	= false,
										longitude	= "",
										latitude	= "",
										cityFound	= true,
										stateFound	= false
									}>

								<cfset variables.strctGallery.specialtyId = val(local.strctResultsSpecialties[iSpecialties].id)>
								<cfset viewAllGalleriesURL = galleryURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
							</cfif>
						</cfif>
				</cfloop>
			</cfloop>
		</cfif>



		<cfif local.comboSpecialtyPostalCodeCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-32814/specialty-25/ --->
			<cfloop from="1" to="#local.postalCodeCount#" index="iPostalCodes">
				<cfloop from="1" to="#local.specialtyCount#" index="iSpecialties">
					<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
						"location-" & local.strctResultsPostalCodes[iPostalCodes].name &
						"/specialty-" & local.strctResultsSpecialties[iSpecialties].id & "/">

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title =
							local.strctResultsSpecialties[iSpecialties].name & " " &
							local.strctResultsPostalCodes[iPostalCodes].name>

					<cfif qDoctors.recordCount EQ 0>

						<cfset qDoctors = model("AccountDoctorLocation").GetFeatured(
									zipCode 	= local.strctResultsPostalCodes[iPostalCodes].name,
									specialtyId	= val(local.strctResultsSpecialties[iSpecialties].id),
									distance 	= local.distance,
									longitude	= val(local.strctResultsPostalCodes[iPostalCodes].longitude),
									latitude	= val(local.strctResultsPostalCodes[iPostalCodes].latitude),
									limit		= local.returnLimit,
									overrideClient	= TRUE)>

						<cfif qDoctors.recordCount EQ 0>
							<cfset qDoctors = model("AccountDoctorLocation").doctorSearchMultiQuery(
										info 		= "search",
										zipCode 	= local.strctResultsPostalCodes[iPostalCodes].name,
										specialtyId = val(local.strctResultsSpecialties[iSpecialties].id),
										distance 	= local.distance,
										longitude	= val(local.strctResultsPostalCodes[iPostalCodes].longitude),
										latitude	= val(local.strctResultsPostalCodes[iPostalCodes].latitude),
										limit		= local.returnLimit,
										overrideClient	= TRUE)>
						</cfif>

						<cfif viewAllDoctorsURL EQ "">
							<cfset viewAllDoctorsURL = thisURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
						</cfif>

						<cfif local.strctResultsSpecialties[iSpecialties].hasGallery EQ 1>
							<cfset variables.strctGallery.Location = {
									country		= 102,
									state		= "",
									statename	= "",
									city		= "",
									cityname	= "",
									zipcode		= local.strctResultsPostalCodes[iPostalCodes].name,
									zipfound	= true,
									longitude	= val(local.strctResultsPostalCodes[iPostalCodes].longitude),
									latitude	= val(local.strctResultsPostalCodes[iPostalCodes].latitude),
									cityFound	= false,
									stateFound	= false
								}>

							<cfset variables.strctGallery.specialtyId = val(local.strctResultsSpecialties[iSpecialties].id)>
							<cfset viewAllGalleriesURL = galleryURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
						</cfif>
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>

		<cfif local.comboSpecialtyPostalCodeCanadaCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-32814/specialty-25/ --->
			<cfloop from="1" to="#local.postalCodeCanadaCount#" index="iPostalCodes">
				<cfloop from="1" to="#local.specialtyCount#" index="iSpecialties">
					<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
						"location-" & local.strctResultsPostalCanadaCodes[iPostalCodes].name &
						"/specialty-" & local.strctResultsSpecialties[iSpecialties].id & "/">

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title =
							local.strctResultsSpecialties[iSpecialties].name & " " &
							local.strctResultsPostalCanadaCodes[iPostalCodes].name>

					<cfif qDoctors.recordCount EQ 0>

						<cfset qDoctors = model("AccountDoctorLocation").GetFeatured(
									zipCode 	= local.strctResultsPostalCanadaCodes[iPostalCodes].name,
									country		= 12,
									specialtyId	= val(local.strctResultsSpecialties[iSpecialties].id),
									distance 	= local.distance,
									longitude	= val(local.strctResultsPostalCanadaCodes[iPostalCodes].longitude),
									latitude	= val(local.strctResultsPostalCanadaCodes[iPostalCodes].latitude),
									limit		= local.returnLimit,
									overrideClient	= TRUE)>

						<cfif qDoctors.recordCount EQ 0>
							<cfset qDoctors = model("AccountDoctorLocation").doctorSearchMultiQuery(
										info 		= "search",
										zipCode 	= local.strctResultsPostalCanadaCodes[iPostalCodes].name,
										country		= 12,
										specialtyId = val(local.strctResultsSpecialties[iSpecialties].id),
										distance 	= local.distance,
										longitude	= val(local.strctResultsPostalCanadaCodes[iPostalCodes].longitude),
										latitude	= val(local.strctResultsPostalCanadaCodes[iPostalCodes].latitude),
										limit		= local.returnLimit,
										overrideClient	= TRUE)>
						</cfif>

						<cfif viewAllDoctorsURL EQ "">
							<cfset viewAllDoctorsURL = thisURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink & "country-CA/">
						</cfif>

						<cfif local.strctResultsSpecialties[iSpecialties].hasGallery EQ 1>
							<cfset variables.strctGallery.Location = {
									country		= 12,
									state		= val(local.strctResultsPostalCanadaCodes[iPostalCodes].stateId),
									statename	= "",
									city		= "",
									cityname	= "",
	 								zipcode		= "",
									zipfound	= false,
									longitude	= "",
									latitude	= "",
									cityFound	= false,
									stateFound	= true
								}>

							<cfset variables.strctGallery.specialtyId = val(local.strctResultsSpecialties[iSpecialties].id)>
							<cfset viewAllGalleriesURL = galleryURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
						</cfif>
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>
	</cffunction>


	<cffunction name="ProcedureResults" access="private">
		<cfargument name="local" required="true" type="struct">

		<cfif arguments.local.comboProcedureStateCityCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-orlando_fl/procedure-25/ --->
			<cfloop from="1" to="#local.cityCount#" index="iCities">
				<cfloop from="1" to="#local.stateCount#" index="iStates">
					<cfloop from="1" to="#local.procedureCount#" index="iProcedures">
						<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
						<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

						<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
							"location-" & local.strctResultsCities[iCities].name &
							"_" & local.strctResultsStates[iStates].name &
							"/procedure-" & local.strctResultsProcedures[iProcedures].id & "/">

						<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title =
							local.strctResultsProcedures[iProcedures].name & " " & local.strctResultsCities[iCities].name &
							", " & local.strctResultsStates[iStates].name>


						<cfif qDoctors.recordCount EQ 0>
							<cfset qDoctors = model("AccountDoctorLocation").GetFeatured(
										city =			val(local.strctResultsCities[iCities].id),
										state =			val(local.strctResultsStates[iStates].id),
										procedureIdList =	local.procedureIdList,
										limit		=	local.returnLimit,
										overrideClient	= TRUE)>

							<cfif qDoctors.recordCount EQ 0>
								<cfset qDoctors = model("AccountDoctorLocation").doctorSearchMultiQuery(
											info =			"search",
											city =			val(local.strctResultsCities[iCities].id),
											state =			val(local.strctResultsStates[iStates].id),
											procedureIdList =	local.procedureIdList,
											limit		=   local.returnLimit,
											overrideClient	= TRUE)>
							</cfif>

							<cfif viewAllDoctorsURL EQ "">
								<cfset viewAllDoctorsURL = thisURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
							</cfif>

							<cfif local.strctResultsProcedures[iProcedures].hasGallery EQ 1>
								<cfset variables.strctGallery.Location = {
										country		= local.strctResultsStates[iStates].countryId,
										state		= val(local.strctResultsStates[iStates].id),
										statename	= local.strctResultsStates[iStates].name,
										city		= val(local.strctResultsCities[iCities].id),
										cityname	= local.strctResultsCities[iCities].name,
										zipcode		= "",
										zipfound	= false,
										longitude	= "",
										latitude	= "",
										cityFound	= true,
										stateFound	= true
									}>

								<cfset variables.strctGallery.procedureIds = local.procedureIdList>
								<cfset viewAllGalleriesURL = galleryURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
							</cfif>
						</cfif>
					</cfloop>
				</cfloop>
			</cfloop>
		</cfif>


		<cfif local.comboProcedureStateCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-fl/procedure-25/ --->
			<cfloop from="1" to="#local.stateCount#" index="iStates">
				<cfloop from="1" to="#local.procedureCount#" index="iProcedures">
					<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
						"location-" & local.strctResultsStates[iStates].name &
						"/procedure-" & local.strctResultsProcedures[iProcedures].id & "/">

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title =
						local.strctResultsProcedures[iProcedures].name &
						" " & local.strctResultsStates[iStates].name>

					<cfif qDoctors.recordCount EQ 0>
						<cfset qDoctors = model("AccountDoctorLocation").GetFeatured(
									state =			val(local.strctResultsStates[iStates].id),
									procedureIdList =	local.procedureIdList,
									limit		=	local.returnLimit,
									overrideClient	= TRUE)>

						<cfif qDoctors.recordCount EQ 0>
							<cfset qDoctors = model("AccountDoctorLocation").doctorSearchMultiQuery(
										info =			"search",
										state =			val(local.strctResultsStates[iStates].id),
										procedureIdList =	local.procedureIdList,
										limit		=   local.returnLimit,
										overrideClient	= TRUE)>
						</cfif>

						<cfset viewAllDoctorsURL = thisURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>

						<cfif local.strctResultsProcedures[iProcedures].hasGallery EQ 1>
							<cfset variables.strctGallery.Location = {
										country		= local.strctResultsStates[iStates].countryId,
										state		= val(local.strctResultsStates[iStates].id),
										statename	= local.strctResultsStates[iStates].name,
										city		= "",
										cityname	= "",
										zipcode		= "",
										zipfound	= false,
										longitude	= "",
										latitude	= "",
										cityFound	= false,
										stateFound	= true
									}>

							<cfset variables.strctGallery.procedureIds = local.procedureIdList>
							<cfset viewAllGalleriesURL = galleryURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
						</cfif>
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>

		<cfif local.comboProcedureCityCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-orlando/procedure-25/ --->
			<cfloop from="1" to="#local.cityCount#" index="iCities">
				<cfloop from="1" to="#local.procedureCount#" index="iProcedures">
					<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
						"location-" & local.strctResultsCities[iCities].name &
						"/procedure-" & local.strctResultsProcedures[iProcedures].id & "/">

						<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title =
							local.strctResultsProcedures[iProcedures].name & " " &local.strctResultsCities[iCities].name>

					<cfif qDoctors.recordCount EQ 0>
						<cfset qDoctors = model("AccountDoctorLocation").GetFeatured(
									city =			val(local.strctResultsCities[iCities].id),
									procedureIdList =	listFirst(local.procedureIdList),
									limit		=	local.returnLimit,
									overrideClient	= TRUE,
									overrideZoneLimit	= TRUE)>

						<cfif qDoctors.recordCount EQ 0>
							<cfset qDoctors = model("AccountDoctorLocation").doctorSearchMultiQuery(
										info =			"search",
										city =			val(local.strctResultsCities[iCities].id),
										procedureIdList =	local.procedureIdList,
										limit		=   local.returnLimit,
										overrideClient	= TRUE)>
						</cfif>

						<cfset viewAllDoctorsURL = thisURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>

						<cfif local.strctResultsProcedures[iProcedures].hasGallery EQ 1>
							<cfset variables.strctGallery.Location = {
										country		= local.strctResultsCities[iCities].countryId,
										state		= "",
										statename	= "",
										city		= val(local.strctResultsCities[iCities].id),
										cityname	= local.strctResultsCities[iCities].name,
										zipcode		= "",
										zipfound	= false,
										longitude	= "",
										latitude	= "",
										cityFound	= true,
										stateFound	= false
									}>

							<cfset variables.strctGallery.procedureIds = local.procedureIdList>
							<cfset viewAllGalleriesURL = galleryURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
						</cfif>
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>


		<cfif local.comboProcedurePostalCodeCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-32814/procedure-25/ --->
			<cfloop from="1" to="#local.postalCodeCount#" index="iPostalCodes">
				<cfloop from="1" to="#local.procedureCount#" index="iProcedures">
					<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
						"location-" & local.strctResultsPostalCodes[iPostalCodes].name &
						"/procedure-" & local.strctResultsProcedures[iProcedures].id & "/">

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title =
						local.strctResultsProcedures[iProcedures].name & " " & local.strctResultsPostalCodes[iPostalCodes].name>


					<cfif qDoctors.recordCount EQ 0>
						<cfset qDoctors = model("AccountDoctorLocation").GetFeatured(
									zipCode 	= local.strctResultsPostalCodes[iPostalCodes].name,
									procedureIdList =	local.procedureIdList,
									distance 	= local.distance,
									longitude	= val(local.strctResultsPostalCodes[iPostalCodes].longitude),
									latitude	= val(local.strctResultsPostalCodes[iPostalCodes].latitude),
									limit		= local.returnLimit,
									overrideClient	= TRUE)>

						<cfif qDoctors.recordCount EQ 0>
							<cfset qDoctors = model("AccountDoctorLocation").doctorSearchMultiQuery(
										info 		= "search",
										zipCode 	= local.strctResultsPostalCodes[iPostalCodes].name,
										procedureIdList =	local.procedureIdList,
										distance 	= local.distance,
										longitude	= val(local.strctResultsPostalCodes[iPostalCodes].longitude),
										latitude	= val(local.strctResultsPostalCodes[iPostalCodes].latitude),
										limit		= local.returnLimit,
										overrideClient	= TRUE)>
						</cfif>

						<cfset viewAllDoctorsURL = thisURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>

						<cfset variables.strctGallery.Location = {
									country		= 102,
									state		= "",
									statename	= "",
									city		= "",
									cityname	= "",
									zipcode		= local.strctResultsPostalCodes[iPostalCodes].name,
									zipfound	= true,
									longitude	= val(local.strctResultsPostalCodes[iPostalCodes].longitude),
									latitude	= val(local.strctResultsPostalCodes[iPostalCodes].latitude),
									cityFound	= false,
									stateFound	= false
								}>

						<cfset variables.strctGallery.procedureIds = local.procedureIdList>
						<cfset viewAllGalleriesURL = galleryURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>

		<cfif local.comboProcedurePostalCodeCanadaCount GT 0 AND qDoctors.recordCount EQ 0>
			<!--- location-32814/procedure-25/ --->
			<cfloop from="1" to="#local.postalCodeCanadaCount#" index="iPostalCodes">
				<cfloop from="1" to="#local.procedureCount#" index="iProcedures">
					<cfset urlDoctorSearchLocationCount = urlDoctorSearchLocationCount + 1>
					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount] = {}>

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink =
						"location-" & local.strctResultsPostalCanadaCodes[iPostalCodes].name &
						"/procedure-" & local.strctResultsProcedures[iProcedures].id & "/">

					<cfset strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].title =
						local.strctResultsProcedures[iProcedures].name & " " & local.strctResultsPostalCanadaCodes[iPostalCodes].name>


					<cfif qDoctors.recordCount EQ 0>
						<cfset qDoctors = model("AccountDoctorLocation").GetFeatured(
									zipCode 	= local.strctResultsPostalCanadaCodes[iPostalCodes].name,
									country		= 12,
									procedureIdList =	local.procedureIdList,
									distance 	= local.distance,
									longitude	= val(local.strctResultsPostalCanadaCodes[iPostalCodes].longitude),
									latitude	= val(local.strctResultsPostalCanadaCodes[iPostalCodes].latitude),
									limit		= local.returnLimit,
									overrideClient	= TRUE)>

						<cfif qDoctors.recordCount EQ 0>
							<cfset qDoctors = model("AccountDoctorLocation").doctorSearchMultiQuery(
										info 		= "search",
										zipCode 	= local.strctResultsPostalCanadaCodes[iPostalCodes].name,
										country		= 12,
										procedureIdList =	local.procedureIdList,
										distance 	= local.distance,
										longitude	= val(local.strctResultsPostalCanadaCodes[iPostalCodes].longitude),
										latitude	= val(local.strctResultsPostalCanadaCodes[iPostalCodes].latitude),
										limit		= local.returnLimit,
										overrideClient	= TRUE)>
						</cfif>

						<cfset viewAllDoctorsURL = thisURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink & "country-CA/">

						<cfset variables.strctGallery.Location = {
									country		= 12,
									countryname	= "Canada",
									state		= "",
									statename	= "",
									city		= "",
									cityname	= "",
									zipcode		= local.strctResultsPostalCanadaCodes[iPostalCodes].name,
									zipfound	= true,
									longitude	= val(local.strctResultsPostalCanadaCodes[iPostalCodes].longitude),
									latitude	= val(local.strctResultsPostalCanadaCodes[iPostalCodes].latitude),
									cityFound	= false,
									stateFound	= false
								}>

						<cfset variables.strctGallery.procedureIds = local.procedureIdList>
						<cfset viewAllGalleriesURL = galleryURLPrefix & strctURLDoctorSearchLocation[urlDoctorSearchLocationCount].urlLink>
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>

	</cffunction>


	<cffunction name="FeaturesGuidesInit" access="private">
		<cfset guideCount = 0>
		<cfset featuresAndArticlesCount = 0>
		<cfset galleryCount = 0>
		<cfset doctorCount = 0>
		<cfset askADoctorCount = 0>

		<cfset explicitAd = FALSE>
		<cfset displayAd = TRUE>
		<cfset adType = "generic">
		<cfset debugText = "">

		<cfparam name="params.page" default="1">
		<cfparam name="params.key" default="">

		<cfset params.page = val(params.page)>

		<cfif not isnumeric(params.page)>
			<cfset params.page = 1>
		</cfif>

		<cfset prevPage = params.page - 1>
		<cfset nextPage = params.page + 1>
	</cffunction>

	<cffunction name="askadoctor">
		<cfset var local = {}>

		<cfset FeaturesGuidesInit()>
		<cfset qAskADoctorResults = model("SearchIndex").GetAskADoctor(	terms 		= params.key,
																	limitCount	= 10,
																	page		= params.page)>
		<cfset askADoctorCount = model("SearchIndex").GetFoundRows()>
		<cfset askADoctorLimit = (askADoctorCount GT 2 ? 2 : askADoctorCount)>
		<cfset resultCount = askADoctorLimit = askADoctorCount>
		<cfset numberOfPages = (int(resultCount/10)) + 1>


		<cfsavecontent variable="debugText">
		<cfoutput>
		<div style="padding-left: 50px;">
			<p>explicitAd = #explicitAd#</p>
		<p><cfdump var="#qAskADoctorResults#"></p>
		</div>
		</cfoutput>
		</cfsavecontent>

		<cfset renderPage(	action	= "results")>
	</cffunction>

	<cffunction name="guides">
		<cfset var local = {}>

		<cfset FeaturesGuidesInit()>
		<cfset qGuideResults = model("SearchIndex").GetGuides(	terms 		= params.key,
																limitCount	= 10,
																page		= params.page)>
		<cfset guideCount = model("SearchIndex").GetFoundRows()>
		<cfset guideLimit = (guideCount GT 2 ? 2 : guideCount)>
		<cfset resultCount = guideLimit = guideCount>
		<cfset numberOfPages = (int(resultCount/10)) + 1>


		<cfsavecontent variable="debugText">
		<cfoutput>
		<div style="padding-left: 50px;">
			<p>explicitAd = #explicitAd#</p>
		<p><cfdump var="#qGuideResults#"></p>
		</div>
		</cfoutput>
		</cfsavecontent>

		<cfset renderPage(	action	= "results")>
	</cffunction>


	<cffunction name="features">
		<cfset var local = {}>

		<cfset FeaturesGuidesInit()>
		<cfset qFeaturesAndArticlesResults = model("SearchIndex").GetFeaturesAndArticles(	terms		= params.key,
																							limitCount	= 10,
																							page		= params.page)>
		<cfset featuresAndArticlesCount = model("SearchIndex").GetFoundRows()>
		<cfset featuresAndArticlesLimit = (featuresAndArticlesCount GT 2 ? 2 : featuresAndArticlesCount)>
		<cfset resultCount = featuresAndArticlesLimit = featuresAndArticlesCount>
		<cfset numberOfPages = (int(resultCount/10)) + 1>

		<cfsavecontent variable="debugText">
		<cfoutput>
		<div style="padding-left: 50px;">
		<p><cfdump var="#qFeaturesAndArticlesResults#"></p>
		</div>
		</cfoutput>
		</cfsavecontent>

		<cfset renderPage(	action	= "results")>
	</cffunction>

	<cffunction name="recordHit" access="private">
		<cfparam name="params.key"				default="">

		<cfif not Client.IsSpider>
			<!--- <cfset keylist = REReplace(LCase(CGI.PATH_INFO),'/?(#LCase(params.controller)#|#LCase(params.action)#)/?','','all')> --->

			<cfset newHit = model("HitsSearch").RecordHit(terms	= params.key)>
		</cfif>
	</cffunction>

	<cffunction name="sponsoredlink" returntype="struct" access="private">
		<cfparam name="params.specialty" default="">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">

		<cfset sponsoredLink = getSponsoredLink(	specialty			="#val(params.specialty)#",
													paramsAction		= "#params.action#",
													paramsController	= "#params.controller#")>
		<cfreturn sponsoredLink>
	</cffunction>

</cfcomponent>