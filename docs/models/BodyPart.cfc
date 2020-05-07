<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocLB3")>
		<cfset hasMany(name="galleryCaseBodyParts",jointype="inner")>
		<cfset hasMany(name="procedureBodyParts",jointype="inner")>
		<cfset belongsTo("bodyRegion")>
	</cffunction>
</cfcomponent>