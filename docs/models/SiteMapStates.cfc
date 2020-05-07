<cfcomponent output="false" extends="Model">


<cffunction name="init" access="public">
	<cfset dataSource("myLocateadocLB")>
	<cfset table("util_states")>
</cffunction>

<cffunction name="GetStates" access="public" returntype="query" output="false" hint="Return the states for doctors in this specialty">
    <cfargument name="specialty_id" default="0" required="false">
    <cfargument name="country_id" default="0" required="false">

    <cfset var qStates = QueryNew("")>

	<cfif not isnumeric(arguments.country_id)>
	    <cfset arguments.country_id = 0>
	</cfif>

	<cfquery datasource="myLocateadocLB" name="qStates">
		SELECT concat("", us.state_code_tx) AS state, us.state_tx, us.state_id, us.silo_name AS state_silo_name
		FROM doc_info AS i
		INNER JOIN doc_specialty_mapped AS m ON m.sid = #arguments.specialty_id# AND m.info_id = i.info_id AND m.is_active > 0
		INNER JOIN specialty s ON s.id = m.sid AND s.id = #arguments.specialty_id#
		INNER JOIN util_states AS us ON i.state_id = us.state_id
		WHERE (i.is_active > 0) AND i.country_id = #arguments.country_id#
		GROUP BY us.state_id
		ORDER BY us.state_tx
     </cfquery>

    <cfreturn qStates>
</cffunction>
</cfcomponent>