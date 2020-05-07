<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset hasMany(name="AccountDoctors", joinType="inner")>
		<cfset belongsTo("video")>
	</cffunction>
</cfcomponent>