<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset dataSource("myLocateadocEdits")>
		<cfset belongsTo("procedure")>
		<cfset belongsto("accountDoctorLocationRecommendation")>
	</cffunction>

</cfcomponent>