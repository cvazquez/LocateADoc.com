<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("accountDoctorLocation")>
		<cfset belongsTo("officeTourPracticeLocation")>
	</cffunction>

</cfcomponent>