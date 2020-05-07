<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset dataSource("myLocateadocEdits")>

		<cfset validatesPresenceOf(properties="keyList,refererExternal,refererInternal",condition=false)>
	</cffunction>

	<cffunction name="RecordHit">
		<cfargument name="action" default="">
		<cfargument name="keylist" default="">
		<cfargument name="specialty" default="">
		<cfargument name="procedure" default="">
		<cfargument name="state" default="">
		<cfargument name="city" default="">
		<cfargument name="accountDoctorId" default="">

		<cfquery datasource="myLocateadocEdits">
			INSERT DELAYED INTO hitsprofilesdaily
			SET action = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action#">,
				keyList = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keylist#">,
				specialtyId = 	<cfif val(arguments.specialty) EQ 0>
									NULL
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.specialty)#">
								</cfif>,
				procedureId = <cfif val(arguments.procedure) EQ 0>
									NULL
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.procedure)#">
								</cfif>,
				stateId = <cfif val(arguments.state) EQ 0>
									NULL
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.state)#">
								</cfif>,
				cityId = <cfif val(arguments.city) EQ 0>
									NULL
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.city)#">
								</cfif>,
				accountDoctorId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.accountDoctorId)#">,
				ipAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				refererExternal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Client.ReferralFull#">,
				refererInternal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_REFERER#">,
				entryPage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Client.EntryPage#">,
				keywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Client.KEYWORDS#">,
				`cfId` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFID)#">,
				`cfToken` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFTOKEN)#">,
				userAgent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_USER_AGENT#">,
				createdAt = now()
		</cfquery>

	</cffunction>

</cfcomponent>