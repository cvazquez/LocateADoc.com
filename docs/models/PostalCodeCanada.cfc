<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocLB3")>
		<cfset belongsTo("city")>
		<cfset belongsTo("state")>
	</cffunction>
</cfcomponent>