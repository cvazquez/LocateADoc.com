<cfoutput>
<cfcontent type="application/json; charset=iso-8859-1">
[
<cfloop query="data">
{ "accountId": "#data.accountId#", "accountName": "#data.accountName#" }
<cfif data.currentRow NEQ data.recordCount>,</cfif>
</cfloop>
]
</cfoutput>
