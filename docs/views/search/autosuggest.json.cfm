<cfoutput>
<cfcontent type="application/json; charset=iso-8859-1">
[
<cfloop query="qSearchResults">
{ "id": "#qSearchResults.id#", "label": "#trim(deAccent(qSearchResults.label))#", "value": "#trim(deAccent(qSearchResults.value))#" }
<cfif qSearchResults.currentRow NEQ qSearchResults.recordCount>,</cfif>
</cfloop>
]
</cfoutput>

