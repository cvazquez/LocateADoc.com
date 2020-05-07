<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsto("resourceGuide")>
		<cfset belongsto("procedure")>
	</cffunction>

</cfcomponent>