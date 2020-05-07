<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsto("resourceArticle")>
		<cfset property(name="hitcount", sql="COUNT(hitsresourcearticles.id)")>
	</cffunction>

	<cffunction name="getPopularArticles">
		<cfquery name="popularArticles" datasource="#get('dataSourceName')#">
			SELECT resourcearticleshitssummary.id, title, hitCount AS hits, siloName
			FROM resourcearticleshitssummary
			JOIN resourcearticlesilonames ON resourcearticleshitssummary.id = resourcearticlesilonames.resourcearticleid
			ORDER BY hitCount desc
			LIMIT 6;
		</cfquery>
		<cfreturn popularArticles>
	</cffunction>


	<cffunction name="RecordHitDelayed">
		<cfargument name="articleID" default="" type="numeric" required="true">

		<CFQUERY datasource="myLocateadocEdits">
			INSERT DELAYED INTO hitsresourcearticlesdaily
			SET resourceArticleId = <cfqueryparam value="#arguments.articleID#" cfsqltype="cf_sql_integer">,
				ipAddress = <cfqueryparam value="#cgi.remote_addr#">,
				refererExternal = <cfqueryparam value="#Client.ReferralFull#">,
				refererInternal = <cfqueryparam value="#cgi.http_referer#">,
				entryPage = <cfqueryparam value="#Client.EntryPage#">,
				keywords = <cfqueryparam value="#Client.keywords#">,
				userAgent = <cfqueryparam value="#cgi.http_user_agent#">,
				`cfId` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFID)#">,
				`cfToken` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFTOKEN)#">,
				createdAt = now()
		</CFQUERY>
	</cffunction>

</cfcomponent>