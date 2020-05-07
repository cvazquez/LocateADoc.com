<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset hasMany(name="accountDoctorLocations", shortcut="accountDoctors")>
		<cfset hasMany("accountPracticeTopBenefits")>
		<cfset hasMany("accountPracticeFeederMarkets")>
	</cffunction>

</cfcomponent>