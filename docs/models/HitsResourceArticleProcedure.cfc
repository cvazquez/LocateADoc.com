<cfcomponent extends="Model" output="false">

	<cffunction name="init">
	</cffunction>


	<cffunction name="RecordHitDelayed">
		<cfargument name="procedureId" default="" type="numeric" required="true">
		<cfargument name="pageNum" default="" type="numeric" required="true">

		<CFQUERY datasource="myLocateadocEdits">
			INSERT DELAYED INTO hitsresourcearticleproceduresdaily
			SET procedureId = <cfqueryparam value="#arguments.procedureId#" cfsqltype="cf_sql_smallint">,
				pageNumber = <cfqueryparam value="#arguments.pageNum#" cfsqltype="cf_sql_smallint">,
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