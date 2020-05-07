<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("DoctorsOnlyProduct")>
	</cffunction>

</cfcomponent>