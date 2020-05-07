<cfcomponent extends="Model" output="false">

	<cffunction name="RecordImpression">
		<cfargument name="thisAction" required="true">
		<cfargument name="thisController" required="true">
		<cfargument name="keylist" required="true">
		<cfargument name="searchRecordCount" required="true">
		<cfargument name="accountDoctorLocationIDs" required="true">
		<cfargument name="specialtyId" required="true">
		<cfargument name="procedureId" required="true">
		<cfargument name="procedureIdList" required="true">
		<cfargument name="latitude" required="true">
		<cfargument name="longitude" required="true">
		<cfargument name="postalCode" required="true">
		<cfargument name="stateId" required="true">
		<cfargument name="cityId" required="true">
		<cfargument name="zoneStateId" required="true">
		<cfargument name="zoneID" required="true">
		<cfargument name="bodypartId" required="true">
		<cfargument name="languageId" required="true">
		<cfargument name="overrideClient" required="true">


		<cfquery datasource="myLocateadocEdits">
			INSERT DELAYED INTO hitsdoctorcarouselimpressionsdaily
			SET `action` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.thisAction#">,
				`controller` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.thisController#">,
				`keyList` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keylist#">,
				`recordCount` = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.searchRecordCount#">,
				`accountDoctorLocationIDs` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountDoctorLocationIDs#">,
				`specialtyId` =	<cfif isnumeric(arguments.specialtyId) AND arguments.specialtyId GT 0>
									<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.specialtyId#">
								<cfelse>
									NULL
								</cfif>,
				`procedureId` = <cfif isnumeric(arguments.procedureId) AND arguments.procedureId GT 0>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.procedureId)#">
							<cfelse>
								NULL
							</cfif>,
				`procedureIdList` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.procedureIdList#">,
				`latitude` = <cfif isnumeric(arguments.latitude) AND arguments.latitude GT 0>
								<cfqueryparam cfsqltype="cf_sql_double" value="#val(arguments.latitude)#">
							<cfelse>
								NULL
							</cfif>,
				`longitude` = <cfif isnumeric(arguments.longitude) AND arguments.longitude GT 0>
								<cfqueryparam cfsqltype="cf_sql_double" value="#val(arguments.longitude)#">
							<cfelse>
								NULL
							</cfif>,
				`postalCode` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postalCode#">,
				`stateId` = <cfif isnumeric(arguments.stateId) AND arguments.stateId GT 0>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.stateId)#">
							<cfelse>
								NULL
							</cfif>,
				`cityId` =	<cfif isnumeric(arguments.cityId) AND arguments.cityId GT 0>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cityId#">
							<cfelse>
								NULL
							</cfif>,
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
				`zoneStateId` = <cfif isnumeric(arguments.zoneStateId) AND arguments.zoneStateId GT 0>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.zoneStateId)#">
								<cfelse>
									NULL
								</cfif>,
				`zoneID` = <cfif isnumeric(zoneID) AND zoneID GT 0>
								<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.zoneID#">
							<cfelse>
								NULL
							</cfif>,
				`bodyPartId` =	<cfif isnumeric(arguments.bodypartId) AND arguments.bodypartId GT 0>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bodypartId#">
								<cfelse>
									NULL
								</cfif>,
				`languageId` = <cfif isnumeric(arguments.languageId) AND arguments.languageId GT 0>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.languageId#">
								<cfelse>
									NULL
								</cfif>,
				`overrideClient` = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.overrideClient#">,
				`ipAddress` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				`refererExternal` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.ReferralFull#">,
				`refererInternal` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_REFERER#">,
				`entryPage` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.EntryPage#">,
				`keywords` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.KEYWORDS#">,
				`cfId` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFID)#">,
				`cfToken` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFTOKEN)#">,
				`userAgent` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_USER_AGENT#">,
				`createdAt` = now()
		</cfquery>

	</cffunction>

</cfcomponent>