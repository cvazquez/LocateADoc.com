<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo(name="resourceArticle", joinType="left")>
	</cffunction>


	<cffunction name="GetArticle" returntype="query">
		<cfargument default="" name="siloname">

		<cfset var qArticle = "">

		<cfquery datasource="#get('dataSourceName')#" name="qArticle">
			SELECT resourcearticles.id, resourcearticles.title, resourcearticles.header, resourcearticles.content, resourcearticles.metaKeywords, resourcearticles.metaDescription, resourcearticles.publishAt, resourcearticles.createdAt,
					cast(group_concat(DISTINCT resourcearticlespecialties.specialtyId) AS char) AS specialtyIds,
					cast(group_concat(DISTINCT resourcearticleprocedures.procedureId) AS char) AS procedureIds,
					cast(group_concat(DISTINCT specialties.name SEPARATOR ":") AS char) AS specialties,
					cast(group_concat(DISTINCT specialties.siloName) AS char) AS specialtySiloNames,
					cast(group_concat(DISTINCT procedures.name SEPARATOR ":") AS char) AS procedures,
					cast(group_concat(DISTINCT procedures.siloName) AS char) AS procedureSilonames,
					cast(group_concat(DISTINCT rad.accountDoctorId) AS char) AS accountDoctorIds
			FROM resourcearticlesilonames
			INNER JOIN resourcearticles ON resourcearticlesilonames.resourceArticleId = resourcearticles.id AND resourcearticles.deletedAt IS NULL
			LEFT OUTER JOIN resourcearticlespecialties ON resourcearticles.id = resourcearticlespecialties.resourceArticleId AND resourcearticlespecialties.deletedAt IS NULL
			LEFT JOIN specialties ON resourcearticlespecialties.specialtyId = specialties.id AND specialties.deletedAt IS NULL
			LEFT OUTER JOIN resourcearticleprocedures ON resourcearticles.id = resourcearticleprocedures.resourceArticleId AND resourcearticleprocedures.deletedAt IS NULL
			LEFT JOIN procedures ON resourcearticleprocedures.procedureId = procedures.id AND procedures.deletedAt IS NULL
			LEFT JOIN resourcearticledoctors rad ON rad.resourceArticleId = resourcearticles.id AND rad.deletedAt IS NULL
			WHERE
				(
					resourcearticlesilonames.siloName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siloname#">
				) AND
				(
					resourcearticlesilonames.deletedAt IS NULL
				)
			GROUP BY resourcearticles.id
			ORDER BY resourcearticlesilonames.id ASC
		</cfquery>

		<cfreturn qArticle>

	</cffunction>
</cfcomponent>