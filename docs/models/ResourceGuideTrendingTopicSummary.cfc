<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset table("resourceguidetrendingtopicsummary")>
		<cfset belongsto("resourceGuide")>
		<cfset belongsto(name="specialty",jointype="outer")>
		<cfset belongsto(name="procedure",jointype="outer")>
	</cffunction>

</cfcomponent>