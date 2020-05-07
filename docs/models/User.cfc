<cfcomponent extends="Model" output="false">

	<cffunction name="init">
        <cfset dataSource("myLocateadocEdits")>
		<cfset validatesPresenceOf(properties="locale,location,photoLocation",condition=false)>
		<cfset hasOne("state")>
    </cffunction>

</cfcomponent>