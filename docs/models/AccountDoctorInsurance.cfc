<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocLB3")>
		<cfset table("accountdoctorinsurance")>
		<cfset belongsTo("insurance")>
		<cfset belongsTo("accountDoctor")>
	</cffunction>
</cfcomponent>