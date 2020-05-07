<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset dataSource("myLocateadocLB3")>
		<cfset belongsTo("bodyPart")>
		<cfset belongsTo("galleryCase")>
	</cffunction>
</cfcomponent>