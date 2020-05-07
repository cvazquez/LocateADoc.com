<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocLB3")>
		<cfset belongsTo("association")>
		<cfset belongsTo("accountDoctor")>
	</cffunction>
</cfcomponent>