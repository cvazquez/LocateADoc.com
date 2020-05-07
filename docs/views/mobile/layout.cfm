<cfsavecontent variable="pageContent">
	<cfoutput>
		<cfinclude template="_header.cfm">
		#includeContent()#
		<cfinclude template="_footer.cfm">
	</cfoutput>
</cfsavecontent>
<cfoutput>#fnCompress(pageContent)#</cfoutput>