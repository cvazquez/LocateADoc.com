<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("account")>
	</cffunction>

</cfcomponent>