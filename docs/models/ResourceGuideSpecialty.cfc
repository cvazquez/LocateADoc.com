<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsto("resourceGuide")>
		<cfset belongsto("specialty")>
	</cffunction>

</cfcomponent>