<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("city")>
		<cfset belongsTo("state")>
		<cfset belongsTo("country")>
	</cffunction>

</cfcomponent>