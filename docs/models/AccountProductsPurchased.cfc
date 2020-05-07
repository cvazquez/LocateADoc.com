<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocLB3")>
		<cfset table("accountproductspurchased")>
		<cfset hasMany("accountProductsPurchasedDoctorLocations")>
		<cfset belongsTo("account")>
	</cffunction>
</cfcomponent>