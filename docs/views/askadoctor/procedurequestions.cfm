<cfif qAskADoctorResults.recordCount GT 0>
<cfoutput>
<h2>Before sending your question to our Ask A Doctor panel, do any of these related questions answer your inquiry?</h2>
</cfoutput>
</cfif>

<cfoutput query="qAskADoctorResults">
<p><strong><a href="/ask-a-doctor/question/#qAskADoctorResults.siloName#" target="#qAskADoctorResults.siloName#">#replace(qAskADoctorResults.title, "Q&A: ", "")#</a></strong></p>
</cfoutput>

<cfif qAskADoctorResults.recordCount GT 0>
<cfoutput>
<p style="text-align: center;">
<a href="/ask-a-doctor/questions/#viewMore.siloName#" target="_blank" style="color: ##fff; margin-right: 50px;" class="btn-red-orange" clicktracklabel="ContinueAskingQuestion" clicktracksection="AskADoctorQuestionAnswerOverlay">See More Q/A's</a>
<a onClick="ALListClose();" style="color: ##fff;" class="btn-red-orange" clicktracklabel="ContinueAskingQuestion" clicktracksection="AskADoctorQuestionAnswerOverlay">Ask Your Question</a>
</p>
</cfoutput>
</cfif>