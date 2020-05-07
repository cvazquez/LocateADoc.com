<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocLB3")>
		<cfset hasMany(name="accountDoctorAssociations", joinType="inner")>
	</cffunction>
</cfcomponent>