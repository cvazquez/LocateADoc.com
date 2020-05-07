<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset hasOne("resourceArticlePreview")>
		<cfset hasMany("resourceArticleProcedures")>
		<cfset hasMany("resourceArticleSpecialties")>
		<cfset hasMany("hitsResourceArticles")>
		<cfset hasMany(name="hitsResourceArticlesInner",modelName="hitsResourceArticle",jointype="inner")>
		<cfset hasMany(name="resourceArticleSiloNames",joinType="inner")>
		<cfset hasMany("resourceArticleDoctors")>

		<cfset hasOne("resourceArticleSiloName")>
	</cffunction>

	<cffunction name="searchArticles" returntype="query">
		<cfargument name="category"  required="false" default="1,3">
		<cfargument name="specialty" type="numeric" required="false" default="0">
		<cfargument name="procedure" type="numeric" required="false" default="0">
		<cfargument name="tag" 		 type="string" 	required="false" default="">
		<cfargument name="article" 	 type="numeric" required="false" default="0">
		<cfargument name="order" 	 type="string" 	required="false" default="ra.publishAt desc">
		<cfargument name="preview"	 type="numeric"	required="false" default="0">
		<cfargument name="offset"	 type="numeric"	required="false" default="0">
		<cfargument name="limit"	 type="numeric"	required="false" default="10">


		<cfquery name="searchResults" datasource="#get('dataSourceName')#">
			SELECT SQL_CALC_FOUND_ROWS
			ra.id, ra.resourceArticleCategoryId, ra.publishAt,
			<cfif arguments.preview eq 0>
				rasn.siloName,ra.title,ra.metaKeywords,ra.metaDescription,ra.teaser,
				ra.header,ra.createdAt,ra.content,ra.ogImage,
			<cfelse>
				raprev.title,raprev.metaKeywords,raprev.metaDescription,raprev.teaser,
				raprev.header,raprev.createdAt,raprev.content,raprev.ogImage,
			</cfif>
			<cfif arguments.tag neq "">
				MATCH (ra.title,ra.content) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#">) AS score,
			</cfif>
			group_concat(DISTINCT cast(ras.specialtyId as char(10)) ORDER BY s.name) as specialtyIDs,
			group_concat(DISTINCT s.name ORDER BY s.name) as specialties,
			group_concat(DISTINCT cast(rap.procedureId as char(10)) ORDER BY p.name) as procedureIDs,
			group_concat(DISTINCT p.name ORDER BY p.name) as procedures

			<cfif ListFind(arguments.category, 3)>
			 , ad.firstName, ad.lastname, ad.title, ad.photoFilename, adsn.siloName AS doctorSiloName, cities.name AS city, states.name AS state
			</cfif>

			FROM resourcearticles ra
			<cfif arguments.preview neq 0>
				JOIN resourcearticlepreviews raprev on ra.id = raprev.resourcearticleID
			<cfelse>
				JOIN resourcearticlesilonames rasn on ra.id = rasn.resourceArticleId
			</cfif>
				LEFT OUTER JOIN resourcearticlespecialties ras
					JOIN specialties s on ras.specialtyId = s.id
				ON ra.id = ras.resourceArticleId
				LEFT OUTER JOIN resourcearticleprocedures rap
					JOIN procedures p on rap.procedureId = p.id
				ON ra.id = rap.resourceArticleId
			<cfif ListFind(arguments.category, 3)>
				LEFT JOIN resourcearticledoctors rad ON rad.resourceArticleId = ra.id AND rad.deletedAt IS NULL
				LEFT JOIN accountdoctors ad On ad.id = rad.accountDoctorId AND ad.deletedAt IS NULL
				LEFT JOIN accountdoctorsilonames adsn ON adsn.accountDoctorId = ad.id AND adsn.isActive = 1 AND adsn.deletedAt IS NULL
				LEFT JOIN accountdoctorlocations adl ON adl.accountDoctorId = ad.id AND adl.deletedAt IS NULL
				LEFT JOIN accountlocations al ON al.id = adl.accountLocationId AND al.deletedAt IS NULL
				LEFT JOIN cities ON cities.id = al.cityId AND cities.deletedAt IS NULL
				LEFT JOIN states ON states.id = cities.stateId AND states.deletedAt IS NULL
			</cfif>
			WHERE ra.resourceArticleCategoryId IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.category#">)
			<cfif arguments.specialty gt 0>
				AND ras.specialtyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.specialty#">
			</cfif>
			<cfif arguments.procedure gt 0>
				AND rap.procedureId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.procedure#">
			</cfif>
			<cfif arguments.tag neq "" AND arguments.preview eq 0>
				AND MATCH (ra.title,ra.content) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#"> IN BOOLEAN MODE)
				<!--- AND ra.content REGEXP <cfqueryparam cfsqltype="cf_sql_varchar" value="[[:<:]]#reEscapeMe(arguments.tag)#[[:>:]]"> --->
				<!--- AND FIND_IN_SET(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#">,REPLACE(ra.metaKeywords,', ',',')) --->
			</cfif>
			<cfif arguments.article gt 0>
				AND ra.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.article#">
			</cfif>
			<cfif arguments.preview eq 0>
				AND rasn.deletedAt IS NULL
			</cfif>
				AND ra.deletedAt IS NULL
				AND ras.deletedAt IS NULL
				AND rap.deletedAt IS NULL
			<cfif arguments.preview eq 0 or arguments.article eq 0>
				AND ra.publishAt <= now()
			</cfif>
			GROUP BY ra.id<cfif arguments.preview neq 0>, raprev.id</cfif>
			ORDER BY
			<cfif arguments.tag neq "" AND arguments.preview eq 0>score desc, </cfif>
			<cfif arguments.preview neq 0>raprev.createdAt DESC, </cfif>#arguments.order#
			LIMIT #arguments.limit# OFFSET #arguments.offset#;
		</cfquery>

		<cfreturn searchResults>
	</cffunction>

	<cffunction name="recentCategories" returntype="query">
		<cfargument name="category"  required="false" default="1,3">
		<cfargument name="limit"	 type="numeric"	required="false" default="10">

		<cfset var qRecentCategories = "">

		<cfquery datasource="#get('dataSourceName')#" name="qRecentCategories">
			SELECT p.name AS procedureName, p.siloName,
					max(ra.publishAt) AS maxPublishDate
			FROM resourcearticles ra
			LEFT JOIN resourcearticleprocedures rap ON rap.resourceArticleId = ra.id AND rap.deletedAt IS NULL
			LEFT JOIN procedures p ON p.id = rap.procedureId AND p.deletedAt IS NULL
			WHERE
			(
				ra.resourceArticleCategoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.category#">
			) AND
			(
				ra.deletedAt IS NULL
			)
			GROUP BY p.id
			ORDER BY maxPublishDate desc
			LIMIT #arguments.limit#;
		</cfquery>

		<cfreturn qRecentCategories>

	</cffunction>

	<cffunction name="GetLatestArticlesAndBlogs" returntype="query">
		<cfargument name="order" 	 type="string" 	required="false" default="ra.publishAt desc">
		<cfargument name="limit"	 type="numeric"	required="false" default="10">

		<cfset var qLatestArticlesAndBlogs = "">

		<cfquery name="qLatestArticlesAndBlogs" datasource="#get('dataSourceName')#">
			SELECT 	recent.siloName, recent.title, recent.publishAt, recent.content,
					recent.specialties,	recent.procedures, recent.ogimage
			FROM
			(
				(


					SELECT	concat("/article/", rasn.siloName) AS siloName, ra.title, ra.publishAt, ra.content,
							group_concat(DISTINCT s.name ORDER BY s.name) as specialties,
							group_concat(DISTINCT p.name ORDER BY p.name) as procedures,
							ra.ogimage
					FROM resourcearticles ra
					JOIN resourcearticlesilonames rasn force INDEX (resourceArticleId) on ra.id = rasn.resourceArticleId AND rasn.deletedAt IS NULL
					LEFT OUTER JOIN resourcearticlespecialties ras
						JOIN specialties s on ras.specialtyId = s.id
						ON ra.id = ras.resourceArticleId
					LEFT OUTER JOIN resourcearticleprocedures rap
						JOIN procedures p on rap.procedureId = p.id
						ON ra.id = rap.resourceArticleId
					WHERE	ra.resourceArticleCategoryId = 1
							AND	ra.deletedAt IS NULL
							AND ras.deletedAt IS NULL
							AND rap.deletedAt IS NULL
							AND ra.publishAt <= now()
					GROUP BY ra.id
					ORDER BY #arguments.order#
					LIMIT #arguments.limit#
				)

				UNION

				(
					/* /blog/2014/03/06/diet-pills-the-secret-to-weight-loss */
					SELECT concat("/blog/", date_format(p.post_date, '%Y/%m/%d/'), p.siloName) AS siloName, p.post_title, p.post_date, p.post_content, "" AS specialties, "" AS procedures, "" AS ogimage
					FROM wordpress.lad_posts p
					WHERE p.post_type = 'post' AND p.post_status = 'publish'
					AND p.post_date < now()
					ORDER BY p.post_date desc
					LIMIT #arguments.limit#
				)

			) recent
			ORDER BY recent.publishAt desc
			LIMIT #arguments.limit#;
		</cfquery>

		<cfreturn qLatestArticlesAndBlogs>
	</cffunction>
</cfcomponent>