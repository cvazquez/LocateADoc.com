<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocLB3")>
		<cfset table("insurance")>
		<cfset hasMany(name="accountDoctorInsurance", joinType="inner")>

		<cfset property(name="callOffice", sql="id=18")>
		<cfset property(name="mostPlansAccepted", sql="id=31")>
	</cffunction>
</cfcomponent>