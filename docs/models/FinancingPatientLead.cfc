<cfcomponent extends="Model" output="false">

<cffunction name="init">
	<cfset dataSource("myLocateadocEdits")>
	<cfset belongsTo("specialty")>
	<cfset belongsTo("accountDoctor")>
	<cfset belongsTo("association")>
	
	<cfset validatesPresenceOf(properties="firstNameCosigner,lastNameCosigner,budget",condition=false)>
</cffunction>

</cfcomponent>