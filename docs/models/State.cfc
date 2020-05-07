<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset hasMany(name="cities", shortcut="city,accountLocation", joinType="inner")>
		<cfset hasMany(name="AccountLocations", joinType="inner")>
		<cfset belongsTo("country")>
		<cfset hasMany(name="AccountDoctorLocationRecommendations", joinType="inner")>
	</cffunction>
</cfcomponent>