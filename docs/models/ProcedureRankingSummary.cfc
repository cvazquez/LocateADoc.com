<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset table("procedurerankingsummary")>
		<cfset belongsTo("procedure")>
	</cffunction>

</cfcomponent>