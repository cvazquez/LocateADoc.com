<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("officeTourPractice")>
		<cfset hasMany(name="officeTourStops",joinType="inner")>
		<cfset hasOne("officeTourAccountDoctorLocation")>
	</cffunction>

</cfcomponent>