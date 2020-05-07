<cfcomponent extends="Model" output="false">

	<cffunction name="init">
	</cffunction>

	<cffunction name="RecordHitDelayed">
		<cfargument name="procedureId" default="" required="false">

		<cfquery datasource="myLocateadocEdits">
			INSERT DELAYED INTO hitsresourceguideproceduresdaily
			SET

			`procedureId` = <cfif val(arguments.procedureId) EQ 0>
								NULL
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.procedureId#">
							</cfif>,
			ipAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			refererExternal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.ReferralFull#">,
			refererInternal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_REFERER#">,
			entryPage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.EntryPage#">,
			keywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.KEYWORDS#">,
			`cfId` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFID)#">,
			`cfToken` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFTOKEN)#">,
			userAgent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_USER_AGENT#">,
			createdAt = now()
		</cfquery>

	</cffunction>
</cfcomponent>