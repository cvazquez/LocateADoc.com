<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("accountDoctor")>
		<cfset belongsTo("insiderQuestion")>
	</cffunction>

</cfcomponent>