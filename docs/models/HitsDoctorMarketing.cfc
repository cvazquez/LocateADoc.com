<cfcomponent extends="Model" output="false">

	<cffunction name="RecordHit">
		<cfargument name="thisAction" required="true">
		<cfargument name="thisController" required="true">
		<cfargument name="keylist" required="true">
		<cfargument name="specialtyId" required="true">
		<cfargument name="procedureId" required="true">
		<cfargument name="postalCode" required="true">
		<cfargument name="stateId" required="true">
		<cfargument name="cityId" required="true">
		<cfargument name="countryId" required="true">
		<cfargument name="pageId" required="true">
		<cfargument name="doctorsOnlyId" required="true">
		<cfargument name="articlesilo" required="true">


		<cfquery datasource="myLocateadocEdits">
			INSERT DELAYED INTO hitsdoctormarketings
			SET
				`controller` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.thisController#">,
				`action` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.thisAction#">,
				keyList = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keylist#">,
				doctorsOnlyId =	<cfif isnumeric(arguments.doctorsOnlyId) AND arguments.doctorsOnlyId GT 0>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doctorsOnlyId#">
							<cfelse>
								NULL
							</cfif>,
				pageId =	<cfif isnumeric(arguments.pageId) AND arguments.pageId GT 0>
								<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.pageId#">
							<cfelse>
								NULL
							</cfif>,
				specialtyId =	<cfif isnumeric(arguments.specialtyId) AND arguments.specialtyId GT 0>
									<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.specialtyId#">
								<cfelse>
									NULL
								</cfif>,
				procedureId =	<cfif isnumeric(arguments.procedureId) AND arguments.procedureId GT 0>
									<cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.procedureId#">
								<cfelse>
									NULL
								</cfif>,
				countryId =	<cfif isnumeric(arguments.countryId) AND arguments.countryId GT 0>
								<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.countryId#">
							<cfelse>
								NULL
							</cfif>,
				stateId =	<cfif isnumeric(arguments.stateId) AND arguments.stateId GT 0>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.stateId)#">
							<cfelse>
								NULL
							</cfif>,
				cityId =	<cfif isnumeric(arguments.cityId) AND arguments.cityId GT 0>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cityId#">
							<cfelse>
								NULL
							</cfif>,
				postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postalCode#">,
				ipAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				refererExternal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.ReferralFull#">,
				refererInternal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_REFERER#">,
				entryPage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.EntryPage#">,
				keywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.KEYWORDS#">,
				articleSilo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.articlesilo#">,
				`cfId` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFID)#">,
				`cfToken` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFTOKEN)#">,
				userAgent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_USER_AGENT#">,
				createdAt = now()
		</cfquery>

	</cffunction>
</cfcomponent>