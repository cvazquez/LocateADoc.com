<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset hasMany(name="accountDoctorCreditCards", joinType="inner")>
	</cffunction>
</cfcomponent>