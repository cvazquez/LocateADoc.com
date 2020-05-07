<cfcomponent extends="Model" output="false">

	<cffunction name="RecordClick" returntype="numeric">
		<cfargument name="clickStats" required="true" type="struct">

		<cfset var qHitsClick = "">

		<cfparam default="" name="client.state">
		<cfparam default="" name="client.city">
		<cfparam default="" name="client.ReferralFull">
		<cfparam default="" name="client.EntryPage">
		<cfparam default="" name="client.KEYWORDS">
		<cfparam default="" name="client.CFID">
		<cfparam default="" name="client.CFTOKEN">

		<cfquery datasource="myLocateadocEdits">
			INSERT INTO hitsclicksdaily
			SET	paramsHref			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clickStats.paramsHref#">,
				paramsLabel			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clickStats.paramsLabel#">,
				paramsSection		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clickStats.paramsSection#">,

				targetController	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clickStats.targetController#">,
				targetAction		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clickStats.targetAction#">,
				targetKeyList		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clickStats.targetKeyList#">,
				targetQueryString	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clickStats.targetQueryString#">,

				refererPathInfo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clickStats.refererPathInfo#">,
				refererController	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clickStats.refererController#">,
				refererAction		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clickStats.refererAction#">,
				refererKeyList		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clickStats.refererKeyList#">,
				refererQueryString	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clickStats.refererQueryString#">,

				`clientStateId` = 	<cfif isnumeric(client.state) AND client.state GT 0>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#val(client.state)#">
									<cfelse>
										NULL
									</cfif>,
				`clientCityId` =	<cfif isnumeric(client.city) AND client.city GT 0>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#client.city#">
									<cfelse>
										NULL
									</cfif>,

				`ipAddress` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				`refererExternal` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#urlDecode(client.ReferralFull)#">,
				`refererInternal` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#urlDecode(CGI.HTTP_REFERER)#">,
				`entryPage` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#urlDecode(client.EntryPage)#">,
				`keywords` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.KEYWORDS#">,
				`cfId` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFID)#">,
				`cfToken` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFTOKEN)#">,
				`userAgent` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_USER_AGENT#">,
				`createdAt` = now()
		</cfquery>

		<cfquery datasource="myLocateadocEdits" name="qHitsClick">
			SELECT last_insert_id() AS id
		</cfquery>

		<cfreturn qHitsClick.id>

	</cffunction>

</cfcomponent>