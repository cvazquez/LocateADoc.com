<cfcomponent extends="Model" output="false">

<cffunction name="init">
		<cfset dataSource("myLocateadocEdits")>
		<cfset belongsTo("profileLead")>
		<cfset belongsTo("profileSpecialtyQuestion")>
</cffunction>

</cfcomponent>