<cfcomponent extends="Model" output="false">

	<cffunction name="RecordClick">
		<cfargument name="accountDoctorId" required="true" type="numeric">



		<cfquery datasource="myLocateadocEdits">
			INSERT INTO hitsprofileclaims
			SET	accountDoctorId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.accountDoctorId#">,

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


	</cffunction>

</cfcomponent>