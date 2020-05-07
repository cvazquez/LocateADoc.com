<cfcomponent extends="Model" output="false">

	<cffunction name="init">
        <cfset dataSource("myLocateadocEdits")>
	</cffunction>

	<cffunction name="VerifyFB" returntype="query">
		<cfparam default="0" name="Client.FacebookID">
		<cfparam default="0" name="Request.oUser.id">

		<cfquery datasource="myLocateadocLB3" name="verifyFB">
			SELECT uid
			FROM facebookusers
			WHERE uid = <cfqueryparam cfsqltype="cf_sql_bigint" value="#Client.FacebookID#">
				 AND userID	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.oUser.id#">
		</cfquery>

		<cfreturn verifyFB>
	</cffunction>

</cfcomponent>