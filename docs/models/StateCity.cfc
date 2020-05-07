<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocLB3")>
		<cfset belongsTo(name="city", joinType="inner")>
		<cfset belongsTo(name="state", joinType="inner")>
	</cffunction>
</cfcomponent>