<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset hasMany(name="VideoSpecialties", joinType="inner", dependent="deleteAll")>
		<cfset hasMany(name="VideoAccountDoctors", joinType="inner", dependent="deleteAll")>
		<cfset belongsTo("account")>
	</cffunction>

	<cffunction name="getVideoCarousel" returntype="query">
		<cfquery datasource="#get('dataSourceName')#" name="videoCarousel">
			SELECT videos.id,videos.headline,videos.imagePreview,
				CASE WHEN videoaccountdoctors.accountDoctorId IS NOT NULL
					THEN videoaccountdoctors.accountDoctorId
				ELSE (SELECT d.accountDoctorId
					  FROM accountproductspurchased a
					  JOIN accountproductspurchaseddoctorlocations b ON a.id = b.accountproductspurchasedid
					  JOIN accountdoctorlocationspecialtyproductzones c ON b.accountdoctorlocationid = c.accountdoctorlocationid
					  JOIN accountdoctorlocations d ON b.accountdoctorlocationid = d.id
					  WHERE a.accountid = videos.accountid
					  AND a.deletedAt is null
					  AND b.deletedAt is null
					  AND c.deletedAt is null
					  AND d.deletedAt is null
					  <!--- AND c.zoneId is not null --->
					  LIMIT 1)
				END AS DoctorId
			FROM videos
			LEFT OUTER JOIN videoaccountdoctors
				ON videos.id = videoaccountdoctors.videoId
				AND videoaccountdoctors.deletedAt IS NULL
			WHERE videos.deletedAt IS NULL
			GROUP BY videos.accountId
			HAVING DoctorId IS NOT NULL
			ORDER BY videos.createdAt DESC
			LIMIT 12;
		</cfquery>
		<cfreturn videoCarousel>
	</cffunction>

	<cffunction name="getVideoSearch" returntype="query">
		<cfargument name="specialty" type="numeric"	required="false" default="0">
		<cfargument name="offset"	 type="numeric"	required="false" default="0">
		<cfargument name="limit"	 type="numeric"	required="false" default="10">

		<cfquery datasource="#get('dataSourceName')#" name="videoSearch">
			SELECT SQL_CALC_FOUND_ROWS videos.id, videos.headline, videos.imagePreview,
				videos.description,	accountdoctors.id as doctorid, accountdoctors.firstName,
				accountdoctors.middleName, accountdoctors.lastName, accountdoctors.title,
				accountdoctorsilonames.siloName
			FROM videos
			LEFT OUTER JOIN videoaccountdoctors
				ON videos.id = videoaccountdoctors.videoId
				AND videoaccountdoctors.deletedAt IS NULL
			JOIN accountproductspurchased ON videos.accountId = accountproductspurchased.accountId
			JOIN accountpractices ON videos.accountId = accountpractices.accountId
			JOIN accountdoctorlocations ON accountpractices.id = accountdoctorlocations.accountpracticeid
			JOIN accountdoctorlocationspecialtyproductzones ON accountdoctorlocations.id = accountdoctorlocationspecialtyproductzones.accountdoctorlocationid
			JOIN accountdoctors on accountdoctorlocations.accountDoctorId = accountdoctors.id
			JOIN accountdoctorsilonames on accountdoctorlocations.accountDoctorId = accountdoctorsilonames.accountDoctorId AND accountdoctorsilonames.isActive = 1 AND accountdoctorsilonames.deletedAt IS NULL
			<cfif arguments.specialty gt 0>
				<!--- JOIN accountlocationspecialties
					ON accountlocationspecialties.accountDoctorLocationId = accountdoctorlocations.id
					AND accountlocationspecialties.specialtyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.specialty)#">
					AND accountlocationspecialties.deletedAt is null --->
				JOIN videospecialties ON videos.id = videospecialties.videoId
									  AND videospecialties.specialtyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.specialty)#">
									  AND videospecialties.deletedAt is null
			</cfif>
			WHERE videos.deletedAt IS NULL
			AND accountpractices.deletedAt is null
			AND accountproductspurchased.deletedAt is null
			AND accountproductspurchased.accountProductId = 1
			AND accountproductspurchased.dateEnd >= now()
			AND accountdoctorlocations.deletedAt is null
			AND accountdoctorlocationspecialtyproductzones.deletedAt is null
			<!--- AND accountdoctorlocationspecialtyproductzones.zoneId is not null --->
			AND accountdoctors.deletedAt is null
			AND (videoaccountdoctors.accountdoctorId is null OR videoaccountdoctors.accountdoctorId = accountdoctors.id)
			GROUP BY videos.id
			ORDER BY videos.createdAt DESC
			LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.limit)#">
			OFFSET <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.offset)#">;
		</cfquery>
		<cfreturn videoSearch>
	</cffunction>

	<cffunction name="getVideoSpecialties" returntype="query">
		<cfquery datasource="#get('dataSourceName')#" name="videoSpecialties">
			SELECT b.id, b.name, count(1) as count
			FROM videos v
			LEFT OUTER JOIN videoaccountdoctors
				ON v.id = videoaccountdoctors.videoId
				AND videoaccountdoctors.deletedAt IS NULL
			JOIN accountpractices ON v.accountId = accountpractices.accountId
			JOIN accountdoctorlocations ON accountpractices.id = accountdoctorlocations.accountpracticeid
			JOIN accountdoctorlocationspecialtyproductzones ON accountdoctorlocations.id = accountdoctorlocationspecialtyproductzones.accountdoctorlocationid
			JOIN accountdoctors on accountdoctorlocations.accountDoctorId = accountdoctors.id
			JOIN videospecialties a on v.id = a.videoId
			JOIN specialties b on a.specialtyId = b.id
			WHERE v.deletedAt is null AND a.deletedAt is null
			AND accountpractices.deletedAt is null
			AND accountdoctorlocations.deletedAt is null
			AND accountdoctorlocationspecialtyproductzones.deletedAt is null
			<!--- AND accountdoctorlocationspecialtyproductzones.zoneId is not null --->
			AND accountdoctors.deletedAt is null
			AND (videoaccountdoctors.accountdoctorId is null OR videoaccountdoctors.accountdoctorId = accountdoctors.id)
			GROUP BY b.name
			ORDER BY b.name ASC;
		</cfquery>
		<!--- <cfquery datasource="#get('dataSourceName')#" name="videoSpecialties">
			SELECT specialties.id, specialties.name
			FROM videos
			JOIN accountpractices ON videos.accountId = accountpractices.accountId
			JOIN accountdoctorlocations ON accountpractices.id = accountdoctorlocations.accountpracticeid
			JOIN accountdoctorlocationspecialtyproductzones ON accountdoctorlocations.id = accountdoctorlocationspecialtyproductzones.accountdoctorlocationid
			JOIN accountlocationspecialties ON accountlocationspecialties.accountDoctorLocationId = accountdoctorlocations.id
			JOIN specialties on specialties.id = accountlocationspecialties.specialtyId
			WHERE videos.deletedAt is null
			AND accountpractices.deletedAt is null
			AND accountdoctorlocations.deletedAt is null
			AND accountdoctorlocationspecialtyproductzones.deletedAt is null
			AND accountlocationspecialties.deletedAt is null
			AND specialties.deletedAt is null
			AND specialties.isPremier = 1
			GROUP BY specialties.name
			ORDER BY specialties.name ASC;
		</cfquery> --->
		<cfreturn videoSpecialties>
	</cffunction>

	<cffunction name="GetDoctorsVideos" returntype="query">
		<cfargument name="accountDoctorId" required="true" type="numeric">

		<cfset var qDoctorsVideos = "">

		<cfquery name="qDoctorsVideos" datasource="#get('dataSourceName')#">
			SELECT DISTINCT		v.id, v.headline, v.description, v.embedCode, v.embedCodeDailyMotion, v.videoSource, v.autoPlay, v.videoSourceOgg,
								v.imageThumbnail, v.imagePreview, v.orderNumber,
								vad.accountDoctorId

			FROM accountdoctorlocations
			INNER JOIN accountpractices ON accountdoctorlocations.accountPracticeId = accountpractices.id
			INNER JOIN videos v ON v.accountId = accountpractices.accountId	AND	v.deletedAt IS NULL
			LEFT OUTER JOIN		videoaccountdoctors vad
			ON					vad.videoId = v.id
			AND					vad.deletedAt IS NULL

			WHERE accountdoctorlocations.accountDoctorId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorId#"> AND accountdoctorlocations.deletedAt IS NULL
			AND
			(
								vad.accountDoctorId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorId#">
								OR
								vad.accountDoctorId IS NULL
			)

			ORDER BY			vad.accountDoctorId DESC, orderNumber ASC, videoId DESC
		</cfquery>

		<cfreturn qDoctorsVideos>
	</cffunction>

</cfcomponent>