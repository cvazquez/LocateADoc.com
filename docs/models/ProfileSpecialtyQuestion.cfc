<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo("specialty")>	
		<cfset hasMany(name="profileQuestionAnswers", joinType="outer")>	
	</cffunction>

</cfcomponent>