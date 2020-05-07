<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocLB3")>		
		<cfset belongsTo("accountDoctorLocation")>
		<cfset belongsTo("accountProductsPurchased")>
	</cffunction>
</cfcomponent>