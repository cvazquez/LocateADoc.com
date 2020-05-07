<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("accountDoctor")>
		<cfset belongsTo("procedure")>
	</cffunction>

</cfcomponent>