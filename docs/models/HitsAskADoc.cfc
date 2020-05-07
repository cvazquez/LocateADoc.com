<cfcomponent extends="Model" output="false">

	<cffunction name="init">
	</cffunction>

	<cffunction name="RecordHitDelayed">
		<cfargument default="" name="action">
		<cfargument default="" name="specialty">
		<cfargument default="" name="procedure">
		<cfargument default="" name="AskADocQuestionId">
		<cfargument default="" name="page">

		<CFQUERY datasource="myLocateadocEdits">
			INSERT DELAYED INTO hitsaskadocsdaily
			SET askADocQuestionId = <cfif val(arguments.AskADocQuestionId) GT 0>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.AskADocQuestionId)#">
									<cfelse>
										NULL
									</cfif>,
				action	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action#">,

				specialtyId	= 	<cfif val(arguments.specialty) GT 0>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.specialty)#">
								<cfelse>
									NULL
								</cfif>,

				procedureId	= 	<cfif val(arguments.procedure) GT 0>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.procedure)#">
								<cfelse>
									NULL
								</cfif>,


				page	= 	<cfif val(arguments.page) GT 0>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.page)#">
							<cfelse>
								NULL
							</cfif>,

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