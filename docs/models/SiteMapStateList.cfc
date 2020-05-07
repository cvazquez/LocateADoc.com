<cfcomponent output="false" extends="Model">

<cffunction name="init" access="public">
	<cfset dataSource("myLocateadocLB")>
	<cfset table("util_states")>
</cffunction>

</cfcomponent>