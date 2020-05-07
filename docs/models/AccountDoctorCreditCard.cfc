<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset belongsTo("creditCard")>
		<cfset belongsTo("accountDoctor")>
	</cffunction>
</cfcomponent>