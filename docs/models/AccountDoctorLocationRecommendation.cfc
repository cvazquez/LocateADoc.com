<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset dataSource("myLocateadocEdits")>
		<cfset belongsTo("accountDoctorLocation")>
		<cfset belongsTo("state")>
		<cfset belongsTo(name="user",jointype="outer")>
		<cfset hasMany(name="accountDoctorLocationRecommendationProcedures", shortcut="procedures", joinType="outer")>
	</cffunction>

	<cffunction name="getCommentCount">
		<cfargument name="procedureID" required="true">

		<cfquery datasource="#get('dataSourceName')#" name="commentCount">
			SELECT count(1) as result
			FROM accountdoctorlocationrecommendations a
			JOIN accountdoctorlocationrecommendationprocedures b
				ON a.id = b.accountdoctorlocationrecommendationID
			WHERE b.procedureID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.procedureID#">
			AND a.approvedAt is not null
			AND a.deletedAt is null AND b.deletedAt is null
		</cfquery>

		<cfreturn commentCount.result>
	</cffunction>

	<cffunction name="getComments">
		<cfargument name="procedureID" required="true">
		<cfargument name="page" required="true">
		<cfargument name="perpage" required="true">
		<cfargument name="descending" required="true">
		<cfargument name="byLocation" required="false" default="false">

		<cfset offset = (arguments.page-1)*arguments.perpage>
		<cfset Local.return = {}>

		<cfset origin = {valid = false, latitude = 0, longitude = 0}>

		<cfif byLocation>
			<cfif ((not isDefined("client.city")) or (not isDefined("client.state")))>
				<cfset setUserLocation()>
			</cfif>
			<cfif val(client.city) and val(client.state)>
				<cfset findCountry = Model("State").findAll(select="countryId",where="id=#val(client.state)#")>
				<cfif findCountry.recordcount>
					<cfquery datasource="#get('dataSourceName')#" name="getCoordinates">
						SELECT avgLatitude, avgLongitude
						<cfif findCountry.countryId eq 102>
							FROM postalcodecoordinateaverages WHERE
						<cfelseif findCountry.countryId eq 12>
							FROM postalcodecanadacoordinateaverages WHERE
						<cfelse>
							FROM postalcodecoordinateaverages WHERE 1=0 AND
						</cfif>
							cityId =  <cfqueryparam cfsqltype="cf_sql_integer" value="#val(client.city)#">
						AND stateId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(client.state)#">
					</cfquery>
					<cfif getCoordinates.recordcount>
						<cfset origin.valid = true>
						<cfset origin.latitude = getCoordinates.avgLatitude>
						<cfset origin.longitude = getCoordinates.avgLongitude>
					</cfif>
				</cfif>
			</cfif>
		</cfif>

		<cfquery datasource="#get('dataSourceName')#" name="Local.return.results">
			SELECT SQL_CALC_FOUND_ROWS
			CASE WHEN a.showName = 1 THEN a.firstname ELSE 'Anonymous' END as firstname,
			s.city, s.stateAbbreviation as state, a.content, a.rating, s.practice, a.createdAt, s.siloName,
			(CONCAT(s.firstName, IF(s.middleName<>'',CONCAT(' ',s.middleName),''), ' ', s.lastName, IF(s.title<>'',CONCAT(', ',s.title),''))) AS fullNameWithTitle
			<cfif origin.valid>
				,CASE WHEN (s.latitude IS NOT NULL AND s.longitude IS NOT NULL)
				THEN sqrt(POW((69.1*(s.latitude-(#origin.latitude#))),2)
				+POW(69.1*(s.longitude-(#origin.longitude#))
				*cos((#origin.latitude#)/57.3),2))
				ELSE 10000 END as distance
			</cfif>
			FROM accountdoctorlocationrecommendations a
			JOIN accountdoctorlocationrecommendationprocedures b
				ON a.id = b.accountdoctorlocationrecommendationID
			JOIN accountdoctorsearchsummary s ON a.accountDoctorLocationId = s.doctorLocationId
			WHERE b.procedureID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.procedureID#">
			AND a.approvedAt is not null
			AND a.deletedAt is null AND b.deletedAt is null
			<cfif origin.valid>
				ORDER BY distance ASC, a.createdAt <cfif arguments.descending>DESC<cfelse>ASC</cfif>
			<cfelse>
				ORDER BY a.createdAt <cfif arguments.descending>DESC<cfelse>ASC</cfif>
			</cfif>
			LIMIT #val(arguments.perpage)# OFFSET #offset#
		</cfquery>

		<!--- Get the number of records and pages from the full result set --->
		<cfquery datasource="#get('dataSourceName')#" name="local.count">
			Select Found_Rows() AS foundrows
		</cfquery>

		<cfquery datasource="#get('dataSourceName')#" name="getAverage">
			SELECT avg(a.rating) as avgRating
			FROM accountdoctorlocationrecommendations a
			JOIN accountdoctorlocationrecommendationprocedures b
				ON a.id = b.accountdoctorlocationrecommendationID
			WHERE b.procedureID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.procedureID#">
			AND a.approvedAt is not null
			AND a.deletedAt is null AND b.deletedAt is null
		</cfquery>

		<cfset Local.return.avgRating = getAverage.avgRating>
		<cfset local.return.page = arguments.page>
		<cfset local.return.perpage = arguments.perpage>
		<cfset local.return.totalrecords = local.count.foundrows>
		<cfset local.return.pages = ceiling(local.return.totalrecords/local.return.perpage)>

		<cfreturn Local.return>
	</cffunction>

	<cffunction name="getProceduresWithComments">

		<cfquery datasource="#get('dataSourceName')#" name="proceduresWithReviews">
			SELECT procedures.id, procedures.name, procedures.siloName, count(distinct accountdoctorlocationrecommendations.id) as reviewCount
			FROM accountdoctorlocationrecommendations
			 JOIN accountdoctorlocationrecommendationprocedures ON accountdoctorlocationrecommendations.id = accountdoctorlocationrecommendationprocedures.accountDoctorLocationRecommendationId
			 JOIN procedures ON accountdoctorlocationrecommendationprocedures.procedureID = procedures.id
			 JOIN resourceguideprocedures ON procedures.id = resourceguideprocedures.procedureId AND resourceguideprocedures.deletedAt IS NULL
			 JOIN resourceguides ON resourceguideprocedures.resourceGuideId = resourceguides.id AND resourceguides.deletedAt IS NULL AND resourceguides.content IS NOT NULL
			 LEFT OUTER JOIN procedureredirects ON procedures.id = procedureredirects.procedureIdFrom AND procedureredirects.deletedAt IS NULL
			WHERE accountdoctorlocationrecommendations.deletedAt IS NULL
			 AND accountdoctorlocationrecommendationprocedures.deletedAt IS NULL
			 AND procedures.deletedAt IS NULL
			 AND procedures.isPrimary = 1
			 AND procedureredirects.id IS NULL
			GROUP BY procedures.id, procedures.name, procedures.siloName
			 HAVING reviewCount >= 10
			ORDER BY procedures.name ASC;
		</cfquery>

		<cfreturn proceduresWithReviews>
	</cffunction>

	<cffunction name="dupeCheck">
		<cfargument name="accountDoctorLocationId" required="true">
		<cfargument name="email" required="true">
		<cfargument name="content" required="true">

		<cfquery datasource="#get('dataSourceName')#" name="commentCount">
			SELECT count(1) as result
			FROM accountdoctorlocationrecommendations
			WHERE accountDoctorLocationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorLocationId#">
			AND email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
			AND content = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content#">
		</cfquery>

		<cfreturn commentCount.result>
	</cffunction>

</cfcomponent>