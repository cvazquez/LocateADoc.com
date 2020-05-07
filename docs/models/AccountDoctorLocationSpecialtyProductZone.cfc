<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("accountDoctorLocation")>
		<cfset belongsTo("specialty")>
		<cfset belongsTo("state")>
	</cffunction>

</cfcomponent>