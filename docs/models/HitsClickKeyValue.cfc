<cfcomponent extends="Model" output="false">

	<cffunction name="RecordClick">
		<cfargument name="hitsClickId" required="true">
		<cfargument name="theKey" required="true">
		<cfargument name="theValue" required="true">

		<cfquery datasource="myLocateadocEdits">
			INSERT DELAYED INTO hitsclickkeyvaluesdaily
			SET	`hitsClickId`	= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.hitsClickId#">,
				`key` 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theKey#">,
				`value` = 	<cfif isnumeric(arguments.theValue) AND val(arguments.theValue) EQ arguments.theValue>
								<cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.theValue#">
							<cfelse>
								NULL
							</cfif>,
				`createdAt` = now()
		</cfquery>

	</cffunction>

</cfcomponent>