<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset belongsTo(name="accountDoctorLocation")>
	</cffunction>
</cfcomponent>