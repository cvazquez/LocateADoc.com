<cfcomponent extends="Model" output="false">

	<cffunction name="init">
		<cfset belongsTo(name="accountInformation",joinType="outer")>
		<cfset belongsTo(name="accountDescription",joinType="outer")>
		<cfset belongsTo("specialty")>
		<cfset belongsTo(name="accountWebsite",joinType="outer")>
		<cfset belongsTo(name="AccountDoctorLocation")>
	</cffunction>

</cfcomponent>