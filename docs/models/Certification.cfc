<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset hasMany(name="accountDoctorCertifications", shortcut="accountDoctors")>
	</cffunction>

</cfcomponent>