<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("bodyPart")>
		<cfset belongsTo("procedure")>
	</cffunction>

</cfcomponent>