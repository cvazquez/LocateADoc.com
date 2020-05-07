<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsto("resourceGuide")>
		<cfset property(name="hitcount", sql="COUNT(hitsresourceguides.id)")>
	</cffunction>

</cfcomponent>