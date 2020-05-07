<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo(name="procedure", foreignKey="procedureIdTo")>
	</cffunction>

</cfcomponent>