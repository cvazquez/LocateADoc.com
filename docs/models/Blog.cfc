<cfcomponent extends="Model" output="false">

	<cffunction name="init">

		<cfset table("lad_posts")>

	</cffunction>

	<cffunction name="GetProcedureOrSpecialtyPosts" returntype="query">
		<cfargument default="" name="specialtyName">
		<cfargument default="" name="procedureName">
		<cfargument default="2" name="limit">


		<cfquery name="Blog" datasource="wordpressLB">
			SELECT p.ID, p.post_date, p.post_content, p.post_title, t.name as topic,
					p.post_date as createdAt, p.siloName
			FROM lad_posts p
			JOIN lad_term_relationships tr on p.ID = tr.object_id
			JOIN lad_term_taxonomy tt on tr.term_taxonomy_id = tt.term_taxonomy_id
			JOIN lad_terms t on tt.term_id = t.term_id
			WHERE p.post_type = 'post' AND p.post_status = 'publish'
			<cfif arguments.procedureName NEQ "">
				AND (t.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.procedureName#%">
				OR <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.procedureName#"> LIKE concat('%',t.name,'%'))
			</cfif>
			AND p.post_date < now()
			GROUP BY p.ID
			ORDER BY p.post_date desc
			LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limit#">
		</cfquery>
		<cfif Blog.recordcount eq 0>
			<cfif client.relatedSpecialty gt 0 AND arguments.specialtyName NEQ "">
				<cfquery name="Blog" datasource="wordpressLB">
					SELECT p.ID, p.post_date, p.post_content, p.post_title, t.name as topic,
		  			p.post_date as createdAt, p.siloName
					FROM lad_posts p
					JOIN lad_term_relationships tr on p.ID = tr.object_id
					JOIN lad_term_taxonomy tt on tr.term_taxonomy_id = tt.term_taxonomy_id
					JOIN lad_terms t on tt.term_id = t.term_id
					WHERE p.post_type = 'post' AND p.post_status = 'publish'
					AND (t.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.specialtyName#%">
					OR <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.specialtyName#"> LIKE concat('%',t.name,'%'))
					AND p.post_date < now()
					GROUP BY p.ID
					ORDER BY p.post_date desc
					LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limit#">
				</cfquery>
			</cfif>
			<cfif Blog.recordcount eq 0>
				<cfquery name="Blog" datasource="wordpressLB">
					SELECT p.ID, p.post_date, p.post_content, p.post_title, t.name as topic,
		  			p.post_date as createdAt, p.siloName
					FROM lad_posts p
					JOIN lad_term_relationships tr on p.ID = tr.object_id
					JOIN lad_term_taxonomy tt on tr.term_taxonomy_id = tt.term_taxonomy_id
					JOIN lad_terms t on tt.term_id = t.term_id
					WHERE p.post_type = 'post' AND p.post_status = 'publish'
					AND p.post_date < now()
					GROUP BY p.ID
					ORDER BY p.post_date desc
					LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limit#">
				</cfquery>
			</cfif>
		</cfif>

		<cfreturn Blog>

	</cffunction>

	<cffunction name="GetLatestPosts" returntype="query">
		<cfargument default="1" name="limit">

		<cfset var qLatestPosts = "">

		<cfquery datasource="wordpressLB" name="qLatestPosts">
			SELECT p.ID, p.post_date, p.post_content, p.post_title, p.post_date as createdAt,
			p.siloName
			FROM lad_posts p
			WHERE p.post_type = 'post' AND p.post_status = 'publish'
			AND p.post_date < now()
			ORDER BY p.post_date desc
			LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limit#">
		</cfquery>

		<cfreturn qLatestPosts>

	</cffunction>

</cfcomponent>