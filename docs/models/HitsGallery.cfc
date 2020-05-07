<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset dataSource("myLocateadocEdits")>

		<cfset validatesPresenceOf(properties="keyList,refererExternal,refererInternal",condition=false)>
	</cffunction>

	<cffunction name="RecordHitDelayed">
		<cfargument name="params" default="" type="struct" required="true">

		<cfset var keylist = REReplace(LCase(CGI.PATH_INFO),'/?(#LCase(arguments.params.controller)#|#LCase(arguments.params.action)#)/?','','all')>

		<!--- <cfoutput>#arguments.params.stateId#</cfoutput>
		<cfabort> --->

		<CFQUERY datasource="myLocateadocEdits">
			INSERT DELAYED INTO hitsgalleriesdaily
			SET entryPage = <cfqueryparam value="#Client.EntryPage#">,
				stateId = 	<cfif NOT ISNUMERIC(arguments.params.stateId)>
								NULL,
							<cfelse>
								<cfqueryparam value="#val(arguments.params.stateId)#">,
							</cfif>
				userAgent = <cfqueryparam value="#cgi.http_user_agent#">,
				cityId =	<cfif NOT ISNUMERIC(arguments.params.cityId)>
								NULL,
							<cfelse>
								<cfqueryparam value="#val(arguments.params.cityId)#">,
							</cfif>
				specialtyId = <cfif NOT ISNUMERIC(arguments.params.specialty)>
								NULL,
							<cfelse>
								<cfqueryparam value="#val(arguments.params.specialty)#">,
							</cfif>
				refererInternal = <cfqueryparam value="#cgi.http_referer#">,
				createdAt = now(),
				keyList = <cfqueryparam value="#keylist#">,
				keywords = <cfqueryparam value="#Client.keywords#">,
				bodyPartId = <cfif NOT ISNUMERIC(arguments.params.bodypart)>
								NULL,
							<cfelse>
								<cfqueryparam value="#val(arguments.params.bodypart)#">,
							</cfif>
				galleryCaseId = <cfif NOT ISNUMERIC(arguments.params.galleryCaseId)>
									NULL,
								<cfelse>
									<cfqueryparam value="#val(arguments.params.galleryCaseId)#">,
								</cfif>
				refererExternal = <cfqueryparam value="#Client.ReferralFull#">,
				procedureId = 	<cfif NOT ISNUMERIC(arguments.params.procedure)>
									NULL,
								<cfelse>
									<cfqueryparam value="#val(arguments.params.procedure)#">,
								</cfif>
				`cfId` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFID)#">,
				`cfToken` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(client.CFTOKEN)#">,
				accountDoctorId = <cfif NOT ISNUMERIC(arguments.params.doctor)>
									NULL,
								<cfelse>
									<cfqueryparam value="#val(arguments.params.doctor)#">,
								</cfif>
				action = <cfqueryparam value="#arguments.params.action#">,
				ipAddress = <cfqueryparam value="#cgi.remote_addr#">
		</CFQUERY>
	</cffunction>

</cfcomponent>