<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset dataSource("myLocateadocEdits")>
		<cfset belongsTo("specialty")>

		<cfset validatesPresenceOf(properties="firstName,lastName,city,state,zip",condition=false)>
	</cffunction>

	<cffunction name="LAD2Subscribe">
		<cfargument name = "specialtyId" default="">
		<cfargument name = "firstname" default="">
		<cfargument name = "lastname" default="">
		<cfargument name = "country" default="0">
		<cfargument name = "email" default="">
		<cfargument name = "postalCode" default="">
		<cfargument name = "wantsNewsletter" default="">
		<cfargument name = "leadSourceId" default="">

		<!--- Beatuiful Living --->
		<cfif Arguments.wantsNewsletter eq 1>
			<cfif arguments.country eq 12>
				<cfset postalInfo = model("postalCodeCanada").findAll(
					select="cities.name as cityname, states.name as statename",
					include="city,state",
					where="postalCode = '#arguments.postalCode#'"
				)>
			<cfelse>
				<cfset postalInfo = model("postalCode").findAll(
					select="cities.name as cityname, states.name as statename",
					include="city,state",
					where="postalCode = '#arguments.postalCode#'"
				)>
			</cfif>
			<cfquery datasource="myLocateadoc" name="Local.qNewsletter">
				SELECT id
				FROM newsletter_subscribers
				WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
			</cfquery>
			<cfif not Local.qNewsletter.recordCount>
				<cfquery datasource="myLocateadoc">
					INSERT INTO newsletter_subscribers
					SET sid				= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.specialtyId#">,
						firstname		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstname#">,
						lastname		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastname#">,
						email			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">,
						city			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#postalInfo.cityname#">,
						state			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#postalInfo.statename#">,
						zip				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postalCode#">,
						source_id		= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.leadSourceId#">,
						date_entered	= now()
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="LAD2Unsubscribe">
		<cfargument name = "email" default="">

		<cfquery datasource="myLocateadoc">
			UPDATE				newsletter_subscribers
			SET					date_unsubscribed = now(),
								is_active = 0
			WHERE				email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
		</cfquery>
	</cffunction>

</cfcomponent>