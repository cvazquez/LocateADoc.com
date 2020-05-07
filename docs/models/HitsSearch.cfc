<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset dataSource("myLocateadocEdits")>

		<cfset validatesPresenceOf(properties="terms,refererExternal,refererInternal",condition=false)>
	</cffunction>

	<cffunction name="RecordHit">
		<cfargument name="terms" required="true">

		<cfquery datasource="myLocateadocEdits">
			INSERT DELAYED INTO hitssearchesdaily
			SET	terms	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.terms#">,
				entryPage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.EntryPage#">,
				userAgent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_USER_AGENT#">,
				refererInternal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_REFERER#">,
				keywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.KEYWORDS#">,
				refererExternal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.ReferralFull#">,
				`cfId` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFID)#">,
				`cfToken` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFTOKEN)#">,
				ipAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				createdAt = now()
		</cfquery>

	</cffunction>
</cfcomponent>