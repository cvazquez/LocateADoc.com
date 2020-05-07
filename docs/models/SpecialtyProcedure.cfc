<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("specialty")>
		<cfset belongsTo("procedure")>
	</cffunction>

</cfcomponent>