<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("accountPractice")>
		<cfset belongsTo("accountDoctor")>
	</cffunction>

</cfcomponent>