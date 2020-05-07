<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset belongsTo("procedure")>
		<cfset belongsTo(name="galleryCase")>
	</cffunction>
</cfcomponent>