<cfcomponent extends="Model" output="false">

	<cffunction name="RecordImpression">
		<cfargument name="thisAction" required="true">
		<cfargument name="thisController" required="true">
		<cfargument name="keylist" required="true">
		<cfargument name="accountDoctorLocationId" required="true">
		<cfargument name="specialtyId" required="true">
		<cfargument name="procedureId" required="true">
		<cfargument name="postalCode" required="true">
		<cfargument name="argumentCityId" required="true">
		<cfargument name="argumentStateId" required="true">
		<cfargument name="zoneStateId" required="true">
		<cfargument name="zoneID" required="true">
		<cfargument name="bodypartId" required="true">

		<cfparam name="client.city" default="">
		<cfparam name="client.state" default="">

		<cfquery datasource="myLocateadocEdits">
			INSERT DELAYED INTO hitsdoctorsponsoredimpressionsdaily
			SET `action` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.thisAction#">,
				`controller` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.thisController#">,
				`keyList` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keylist#">,

				`accountDoctorLocationID` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorLocationId#">,
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
				`postalCode` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postalCode#">,
				`argumentStateId` = <cfif isnumeric(arguments.argumentStateId) AND arguments.argumentStateId GT 0>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.argumentStateId)#">
							<cfelse>
								NULL
							</cfif>,
				`argumentCityId` =	<cfif isnumeric(arguments.argumentCityId) AND arguments.argumentCityId GT 0>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.argumentCityId#">
							<cfelse>
								NULL
							</cfif>,
				`clientStateId` = <cfif isnumeric(client.state) AND client.state GT 0>
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