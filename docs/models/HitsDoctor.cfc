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
		<cfargument name="distance" required="true">
		<cfargument name="bodyPartId" required="true">
		<cfargument name="countryId" required="true">
		<cfargument name="lastName" required="true">


		<cfquery datasource="myLocateadocEdits">
			INSERT DELAYED INTO hitsdoctorsdaily
			SET
				`controller` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.thisController#">,
				entryPage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.EntryPage#">,
				stateId =	<cfif isnumeric(arguments.stateId) AND arguments.stateId GT 0>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.stateId)#">
							<cfelse>
								NULL
							</cfif>,
				distance =	<cfif isnumeric(arguments.distance) AND arguments.distance GT 0>
								<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.distance#">
							<cfelse>
								NULL
							</cfif>,
				userAgent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_USER_AGENT#">,
				cityId =	<cfif isnumeric(arguments.cityId) AND arguments.cityId GT 0>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cityId#">
							<cfelse>
								NULL
							</cfif>,
				refererInternal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_REFERER#">,
				specialtyId =	<cfif isnumeric(arguments.specialtyId) AND arguments.specialtyId GT 0>
									<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.specialtyId#">
								<cfelse>
									NULL
								</cfif>,
				createdAt = now(),
				keyList = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keylist#">,
				keywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.KEYWORDS#">,
				bodyPartId =	<cfif isnumeric(arguments.bodyPartId) AND arguments.bodyPartId GT 0>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bodyPartId#">
								<cfelse>
									NULL
								</cfif>,
				countryId =	<cfif isnumeric(arguments.countryId) AND arguments.countryId GT 0>
								<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.countryId#">
							<cfelse>
								NULL
							</cfif>,
				postalCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postalCode#">,
				refererExternal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.ReferralFull#">,
				procedureId =	<cfif isnumeric(arguments.procedureId) AND arguments.procedureId GT 0>
									<cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.procedureId#">
								<cfelse>
									NULL
								</cfif>,
				`cfId` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFID)#">,
				`cfToken` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFTOKEN)#">,
				`action` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.thisAction#">,
				ipAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastName#">
		</cfquery>

	</cffunction>
</cfcomponent>