<cfoutput query="qAskADoctorResults">
<p><strong><a href="#qAskADoctorResults.link#">#replace(qAskADoctorResults.title, "Q&A: ", "")#</a></strong><br />
#qAskADoctorResults.teaser#
</p>
</cfoutput>