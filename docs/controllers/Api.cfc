<cfcomponent extends="Controller" output="false">

<!--- ACTIONS --->

	<cffunction name="init">
		<cfset provides("html,json")>
		<cfset filters(through="inputValidation", only="recommendbuttonShow,recommendbuttonClick")>
		<cfset filters(through="recordHit", type="after", only="recommendbuttonShow,recommendbuttonClick")>
	</cffunction>

	<cffunction name="recommendbuttonShow">
		<cfset buttonWidth = [79,95,95,95]>
		<cfset basePath = "http://#CGI.HTTP_HOST#">
		<cfset imagePath = "#basePath#/images/api/recommendbutton">
		<cfset website_url = CGI.HTTP_REFERER>
		<cfset var Local = {}>
		<cfset recommendationCount = "N/A">
		<cfset linkToComments = "">
		<cfset recordAction = "show">

		<cfif validationError eq "">
			<cfif params.doctor_id neq "">
				<cfquery datasource="myLocateadocLB3" name="qryDoctor" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
					SELECT sn.siloName, dl.id as info_id
					FROM accountdoctorsilonames sn
					INNER JOIN accountdoctorlocations dl ON dl.accountDoctorId = sn.accountDoctorId
															AND dl.accountDoctorId = <cfqueryparam cfsqltype="cf_sql_integer" value="#params.doctor_id#">
															AND dl.deletedAt IS NULL
					WHERE sn.deletedAt IS NULL
						AND sn.isActive = 1
				</cfquery>
				<cfif qryDoctor.recordCount>
					<cfset Local.info_id = qryDoctor.info_id>
				<cfelse>
					<cfset validationError = "Can't find silo name based on doctor id #params.doctor_id#.">
				</cfif>
			<cfelse>
				<cfquery datasource="myLocateadocLB3" name="qryDoctor" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
					SELECT sn.siloName
					FROM accountdoctorsilonames sn
					INNER JOIN accountdoctorlocations dl ON dl.accountDoctorId = sn.accountDoctorId
															AND dl.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#params.key#">
															AND dl.deletedAt IS NULL
					WHERE sn.deletedAt IS NULL
						AND sn.isActive = 1
				</cfquery>
				<cfif qryDoctor.recordCount>
					<cfset Local.info_id = params.key>
				<cfelse>
					<cfset validationError = "Can't find silo name based on info id #URL.info_id#.">
				</cfif>
			</cfif>

			<cfif validationError eq "">
				<cfset linkToComments = "#basePath#/#qryDoctor.siloName#/reviews">

				<cfquery datasource="myLocateadocLB3" name="qryRecommendations" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
					SELECT count(*) as count
					FROM accountdoctorlocationrecommendations
					WHERE accountDoctorLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#Local.info_id#">
						AND deletedAt IS NULL
				</cfquery>

				<cfset recommendationCount = qryRecommendations.count>
			</cfif>
		</cfif>
		<cfset renderPage(layout=false)>
	</cffunction>

	<cffunction name="recommendbuttonClick">
		<cfset recordAction = "click">
		<cfset website_url = params.referer>
		<cfset referer = CGI.HTTP_REFERER>
		<cfset renderNothing()>
	</cffunction>


<!--- AJAX Functions --->

	<cffunction name="coordinates2location" hint="Returns location information for passed in latitude and longitude coordinates">
		<!---
		To test functionality, enter your own LAT and LON values into this URL:
		http://www.locateadoc.com/api/index.cfm/location/coordinates2location?lat=28.5599193&lon=-81.3443843
		 --->
		<cfsetting showdebugoutput="no">
		<cfparam name="params.lat" default="">
		<cfparam name="params.lon" default="">
		<cfset var Local = {}>
		<cfset location = {}>
		<cfif isNumeric(params.lat) and isNumeric(params.lon)>
			<cfquery datasource="myLocateadocLB3" name="Local.qryLocation">
				SELECT
					pc.cityId, pc.stateId, pc.countyId,
					CAST(pc.postalCode AS UNSIGNED) AS postalCode,
					CAST(pc.areaCode AS UNSIGNED) AS areaCode,
					pc.latitude, pc.longitude,
					c.name AS cityName,
					s.name AS stateName,
					s.abbreviation AS stateCode,
					ct.name AS countyName,
					SQRT(POW(#params.lat# - pc.latitude, 2) + POW(#params.lon# - pc.longitude, 2)) AS dist
				FROM postalcodes pc
				LEFT JOIN cities c ON c.id = pc.cityId
				LEFT JOIN states s ON s.id = pc.stateId
				LEFT JOIN counties ct ON ct.id = pc.countyId
				WHERE pc.type IS NULL
					OR pc.type = ""
				ORDER BY dist
				LIMIT 1
			</cfquery>
			<!--- Apparently JavaScript can't handle query results so I have to turn it into a struct --->
			<cfloop list="#Local.qryLocation.ColumnList#" index="i">
				<cfset Location[i] = Local.qryLocation[i][1]>
			</cfloop>
		</cfif>
		<cfset renderWith(location)>
	</cffunction>

<!--- PRIVATE FUNCTIONS --->

	<cffunction name="inputValidation" access="private">
		<cfparam name="params.style" default="1">
		<cfparam name="params.clicked" default="N/A">
		<cfparam name="params.referer" default="">
		<cfparam name="params.doctor_id" default="">
		<cfparam name="params.key" default="">
		<cfset validationError = "">
		<cfset maxStyle = 4>
		<cfset website_url = "">
		<cfset referer = "">

		<cfif not Server.isInteger(params.key) and not Server.isInteger(params.doctor_id)>
			<cfset validationError = "Invalid ID">
		</cfif>
		<cfif not Server.isInteger(params.style) or params.style gt maxStyle>
			<cfset params.style = 1>
		</cfif>
		<cfif not ListFind("button,counter", LCase(params.clicked))>
			<cfset params.clicked = "N/A">
		</cfif>
	</cffunction>

	<cffunction name="recordHit" access="private">
		<cfif validationError neq "" or website_url contains "practicedock.com" or website_url contains "locateadoc.com">
			<cfreturn>
		</cfif>

		<cftry>
			<cfquery datasource="myLocateadoc">
				INSERT INTO hitsrecommendbuttons
				SET
					action		= "#recordAction#",
					websiteURL	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#website_url#">,
					clicked		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.clicked#">,
					style		= <cfqueryparam cfsqltype="cf_sql_integer" value="#params.style#">,
					infoID		= <cfqueryparam cfsqltype="cf_sql_integer" value="#params.key#">,
					ipAddress	= "#CGI.REMOTE_ADDR#",
					referer		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#referer#">,
					userAgent	= "#CGI.HTTP_USER_AGENT#",
					createdAt	= now()
			</cfquery>
			<cfcatch></cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>