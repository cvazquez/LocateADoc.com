<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset hasMany(name="accountDoctorInsiderQuestionAnswers", shortcut="accountDoctors")>
	</cffunction>
</cfcomponent>