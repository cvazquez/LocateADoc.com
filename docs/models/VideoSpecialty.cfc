<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset belongsTo("video")>
		<cfset hasOne("specialty")>
	</cffunction>
</cfcomponent>