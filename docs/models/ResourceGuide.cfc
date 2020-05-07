<cfcomponent extends="Model" output="false">

	<cffunction name="init">
<!---
		<cfset hasOne("resourceGuidePreview")>
		<cfset hasMany("resourceGuideProcedures")>
		<cfset hasMany("resourceGuideSpecialties")>
 --->
		<cfset hasMany("hitsResourceGuides")>
		<cfset hasOne(name="resourceGuideSpecialty", shortcut="specialty")>
		<cfset hasOne(name="resourceGuideProcedure", shortcut="procedure")>
		<cfset hasOne(name="resourceGuideSubProcedure")>
		<cfset hasOne(name="resourceGuidePreview")>
		<cfset hasMany(name="resourceGuideSiloNames", jointype="inner")>
	</cffunction>

	<cffunction name="searchGuides" returntype="query">
		<cfargument name="specialty" 	type="numeric" required="false" default="0">
		<cfargument name="procedure" 	type="numeric" required="false" default="0">
		<cfargument name="procedures"	type="string" required="false" default="">
		<cfargument name="tag" 		 	type="string" 	required="false" default="">
		<cfargument name="guide" 	 	type="numeric" required="false" default="0">
		<cfargument name="order" 	 	type="string" 	required="false" default="rg.createdAt desc">
		<cfargument name="noSubGuides" 	type="boolean"	required="false" default="false">
		<cfargument name="preview"	 	type="numeric"	required="false" default="0">
		<cfargument name="offset"	 	type="numeric"	required="false" default="0">
		<cfargument name="limit"	 	type="numeric"	required="false" default="10">

		<cfquery name="searchResults" datasource="#get('dataSourceName')#">
			SELECT SQL_CALC_FOUND_ROWS
			rg.id,rg.title,rg.name,rg.metaKeywords,rg.metaDescription,rg.header,rg.createdAt,
			<cfif arguments.preview eq 0>rg.content,<cfelse>rgprev.content,</cfif>
			rgs.specialtyID, rgp.procedureID, s.name as specialtyname, p.name as procedurename,
			rgsp.procedureID as subprocedureID, p2.name as subprocedurename,
			rgsn.siloName, s.siloName as specialtySiloName, p.siloName as procedureSiloName
			<cfif arguments.guide neq 0>
			,group_concat(DISTINCT cast(rgs.specialtyId as char(10)) ORDER BY s.name) as specialtyIDs,
			group_concat(DISTINCT s.name ORDER BY s.name) as specialties,
			group_concat(DISTINCT cast(rgp.procedureId as char(10)) ORDER BY p.name) as procedureIDs,
			group_concat(DISTINCT p.name ORDER BY p.name) as procedures
			</cfif>
			FROM resourceguides rg
			<cfif arguments.preview neq 0>
				JOIN resourceguidepreviews rgprev on rg.id = rgprev.resourceguideID
			</cfif>
				LEFT OUTER JOIN resourceguidespecialties rgs
					JOIN specialties s on rgs.specialtyId = s.id
				ON rg.id = rgs.resourceGuideId
				LEFT OUTER JOIN resourceguideprocedures rgp
					JOIN procedures p on rgp.procedureId = p.id
				ON rg.id = rgp.resourceGuideId
				LEFT OUTER JOIN resourceguidesubprocedures rgsp
					JOIN procedures p2 on rgsp.procedureId = p2.id
				ON rg.id = rgsp.resourceGuideId
				LEFT OUTER JOIN resourceguidesilonames rgsn	ON rg.id = rgsn.resourceGuideId
			WHERE rg.content is not null
			<cfif arguments.specialty gt 0>
				AND rgs.specialtyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.specialty#">
			</cfif>
			<cfif arguments.procedure gt 0>
				AND rgp.procedureId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.procedure#">
			</cfif>
			<cfif arguments.procedures neq "">
				AND rgp.procedureId IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.procedures#">)
			</cfif>
			<cfif arguments.tag neq "">
				AND FIND_IN_SET(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#">,REPLACE(rg.metaKeywords,', ',','))
			</cfif>
			<cfif arguments.guide gt 0>
				AND rg.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.guide#">
			</cfif>
				AND rg.deletedAt IS NULL
				AND rgs.deletedAt IS NULL
				AND rgp.deletedAt IS NULL
				<cfif noSubGuides>
					AND rgsp.createdAt IS NULL
				</cfif>
			GROUP BY rg.id<cfif arguments.preview neq 0>, rgprev.id</cfif>
			ORDER BY <cfif arguments.preview neq 0>rgprev.createdAt DESC, </cfif>#arguments.order#
			LIMIT #arguments.limit# OFFSET #arguments.offset#;
		</cfquery>

		<cfreturn searchResults>
	</cffunction>

	<cffunction name="featuredResources" returntype="query">
		<cfargument default="8" name="limit" required="false">

		<cfquery name="searchResults" datasource="#get('dataSourceName')#">
			SELECT rg.id, 'guide' as resource,
			CASE WHEN rg.updatedAt is not null THEN rg.updatedAt ELSE rg.createdAt END AS createdAt,
			rg.title, rg.content, rgs.specialtyID, rgp.procedureID, s.name as specialtyname,
			p.name as procedurename, rgsn.siloName, s.siloName as specialtySiloName,
			p.siloName as procedureSiloName
			FROM resourceguides rg
				LEFT OUTER JOIN resourceguidespecialties rgs
					JOIN specialties s on rgs.specialtyId = s.id
				ON rg.id = rgs.resourceGuideId
				LEFT OUTER JOIN resourceguideprocedures rgp
					JOIN procedures p on rgp.procedureId = p.id
				ON rg.id = rgp.resourceGuideId
				LEFT OUTER JOIN resourceguidesubprocedures rgsp
					JOIN procedures p2 on rgsp.procedureId = p2.id
				ON rg.id = rgsp.resourceGuideId
				LEFT OUTER JOIN resourceguidesilonames rgsn	ON rg.id = rgsn.resourceGuideId
			WHERE rg.content is not null
				AND rg.deletedAt IS NULL
				AND rgs.deletedAt IS NULL
				AND rgp.deletedAt IS NULL
				AND rgsp.createdAt IS NULL
			GROUP BY rg.id
			UNION ALL SELECT ra.id, 'article' as resource, ra.publishAt as createdAt, ra.title, ra.content,
			ras.specialtyId, rap.procedureId, s.name as specialtyname, p.name AS procedurename,
			rasn.siloName, null as specialtySiloName, null as procedureSiloName
			FROM resourcearticles ra
			JOIN resourcearticlesilonames rasn on ra.id = rasn.resourceArticleId
				LEFT OUTER JOIN resourcearticlespecialties ras
					JOIN specialties s on ras.specialtyId = s.id
				ON ra.id = ras.resourceArticleId
				LEFT OUTER JOIN resourcearticleprocedures rap
					JOIN procedures p on rap.procedureId = p.id
				ON ra.id = rap.resourceArticleId
			WHERE ra.resourceArticleCategoryId IN (1)
				AND rasn.deletedAt IS NULL
				AND ra.deletedAt IS NULL
				AND ras.deletedAt IS NULL
				AND rap.deletedAt IS NULL
				AND ra.publishAt <= now()
			GROUP BY ra.id
			ORDER BY createdAt desc
			LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limit#">;
		</cfquery>

		<cfreturn searchResults>
	</cffunction>

	<cffunction name="GetGuides" returntype="query">

		<cfset var qGuides = "">

		<cfquery datasource="#get('dataSourceName')#" name="qGuides">
			SELECT	s.name AS specialtyName,
					s.siloName AS specialtySiloName,
					guides.procedureName, guides.siloName,
					count(guides.guideCount) AS resourceGuideCount,
					guides.procedureId,
					cast(group_concat(DISTINCT guides.resourceGuideIds) AS char) AS resourceGuideIds,
					cast(group_concat(DISTINCT guides.specialtyIds) AS char) AS specialtyIds,
					s.id AS specialtyId
			FROM
			(
				(SELECT p.id AS procedureId, p.name AS procedureName, p.siloName, count(distinct(rg.id)) AS guideCount,
						cast(group_concat(DISTINCT rg.id) AS char) AS resourceGuideIds,
						cast(group_concat(DISTINCT rgs.specialtyId) AS char) AS specialtyIds
				FROM resourceguides rg
				INNER JOIN resourceguideprocedures rgp ON rgp.resourceGuideId = rg.id AND rgp.deletedAt IS NULL
				INNER JOIN procedures p ON p.id = rgp.procedureId AND p.deletedAt IS NULL
				LEFT JOIN resourceguidespecialties rgs ON rgs.resourceGuideId = rg.id AND rgs.deletedAt IS NULL
				WHERE rg.deletedAt IS NULL AND rg.content IS NOT NULL
				GROUP BY p.id)
			) guides
			INNER JOIN specialtyprocedures sp ON sp.procedureId = guides.procedureId AND sp.deletedAt IS NULL
			INNER JOIN specialties s ON s.id = sp.specialtyId AND s.deletedAt IS NULL
			GROUP BY specialtyName,	guides.procedureName
			ORDER BY specialtyName, guides.procedureName;
		</cfquery>

		<cfreturn qGuides>

	</cffunction>

</cfcomponent>