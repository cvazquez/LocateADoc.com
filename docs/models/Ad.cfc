<cfcomponent extends="Model" output="false">
	<cffunction name="init">
	</cffunction>

	<cffunction name="GetGenericAd" returntype="query">
		<cfargument name="section">

		<cfset var qAd = "">

		<cfquery datasource="myLocateadocLB3" name="qAd">
			SELECT a.`content`
			FROM ads a
			LEFT JOIN adprocedures ap On ap.adId = a.id AND ap.deletedAt IS NULL
			LEFT JOIN adspecialties asp ON asp.adId = a.id AND asp.deletedAt IS NULL
			WHERE a.`section` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.section#">
				AND ap.adId IS NULL AND asp.adId IS NULL
				AND (
					(now() BETWEEN a.dateStart AND a.dateEnd)
						OR
					(a.dateEnd IS NULL AND a.dateStart IS NULL)
					)
				AND a.deletedAt IS NULL
		</cfquery>

		<cfreturn qAd>
	</cffunction>


	<cffunction name="GetSpecialtyAd" returntype="query">
		<cfargument name="specialtyId">
		<cfargument name="dimension">

		<cfset var qAd = "">

		<cfquery datasource="#get("datasourceName")#" name="qAd">
			SELECT a.section, a.`content`
			FROM ads a
			INNER JOIN adspecialties asp On asp.adId = a.id AND asp.specialtyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.specialtyId#"> AND asp.deletedAt IS NULL
			WHERE a.`dimension` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.dimension#"> AND a.deletedAt IS NULL
				AND (
						(now() BETWEEN a.dateStart AND a.dateEnd)
						OR
						(a.dateEnd IS NULL AND a.dateStart IS NULL)
					)
		</cfquery>

		<cfreturn qAd>
	</cffunction>


	<cffunction name="GetProcedureAd" returntype="query">
		<cfargument name="procedureIds">
		<cfargument name="dimension">

		<cfset var qAd = "">

		<cfquery datasource="myLocateadocLB3" name="qAd">
			SELECT a.section, a.`content`
			FROM ads a
			INNER JOIN adprocedures ap On ap.adId = a.id AND
					ap.procedureId IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#arguments.procedureIds#">)
					AND ap.deletedAt IS NULL
			WHERE a.`dimension` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.dimension#"> AND a.deletedAt IS NULL
				AND (
						(now() BETWEEN a.dateStart AND a.dateEnd)
						OR
						(a.dateEnd IS NULL AND a.dateStart IS NULL)
					)
		</cfquery>

		<cfreturn qAd>
	</cffunction>

</cfcomponent>