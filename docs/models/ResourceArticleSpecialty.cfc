<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsto("resourceArticle")>
		<cfset belongsto("specialty")>
	</cffunction>

</cfcomponent>