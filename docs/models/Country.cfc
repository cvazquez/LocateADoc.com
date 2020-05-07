<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset hasMany(name="States", joinType="inner")>
	</cffunction>

</cfcomponent>