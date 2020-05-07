<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo(name="resourceGuide", joinType="left")>
	</cffunction>

</cfcomponent>