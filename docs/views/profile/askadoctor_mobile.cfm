<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1>
	<cfset params = Request.oUser.appendUserInfo(params)>
</cfif>

<cfset javaScriptIncludeTag(source="profile/askadoctor", head=true)>
<cfset styleSheetLinkTag(source="profile/askadoctor_mobile", head=true)>
<!-- content -->
<div class="content print-area ask-a-doctor">
	<div class="welcome-box">
		<cfoutput>
		<h1>Ask A Doctor: Questions Answered by #doctor.fullNameWithTitle#</h1>

		<p><strong>These are the answers to questions posted to our Ask A Doctor panel that #doctor.fullNameWithTitle# replied with his opinion.</strong></p>

		<!--- <div<cfif hasContactForm> onclick="PromptOpen();"</cfif> class="AskYourQuestion">
			<cfif NOT hasContactForm><a href="/ask-a-doctor"></cfif>
			Ask Your Question
			<cfif NOT hasContactForm></a></cfif>
		</div> --->
		<div onclick="PromptOpen();" class="AskYourQuestion">Ask Your Question</a></div>

 		<cfif QA.recordcount gt 0>
			<cfif search.pages GT 1><div class="pagination">#includePartial("/shared/_pagination_mobile.cfm")#</div></cfif>
			<form name="resultsForm" action="##" method="post">
			<cfloop query="QA">
				<div class="qa-holder comment">
					<cfif IsDate(QA.approvedAt)>
						<cfif DateDiff("yyyy",QA.approvedAt,now()) eq 0>
							<div class="dateflag">#Replace(DateFormat(QA.approvedAt,"mmm d")," ","<br>")#</div>
						<cfelse>
							<div class="dateflag">#Replace(DateFormat(QA.approvedAt,"mmm yyyy")," ","<br>")#</div>
						</cfif>
					</cfif>
					<!--- <h2>Question:</h2> --->
					<h3 class="preview"><a href="/ask-a-doctor/question/#QA.siloName#">#QA.title#</a></h3>
					<p>
						<cfset filteredContent = REReplace(QA.question,"\r\n","|","all")>
						<!--- <cfset filteredContent = REReplace(filteredContent,"(\r|\n|\|)(\r|\n|\s\|)+","<br><br>","all")> --->
						<cfset filteredContent = REReplace(filteredContent,"\|","","all")>
						<cfset filteredContent = REReplace(filteredContent,"<p>|</p>","","all")>
						<cfset filteredContent = CutText(filteredContent, 200)>
						#filteredContent#
						<a href="/ask-a-doctor/question/#QA.siloName#" class="read-more">Read More</a>
					</p>

					<!--- <h2>Answer:</h2>
					<p id="answer-content">
						<!--- <cfif doctor.photoFilename NEQ "">
							<cfif hasContactForm><a href="/#params.siloname#/contact"></cfif>
							<img alt="#doctor.fullNameWithTitle# - LocateADoc.com" alt="#doctor.fullNameWithTitle# - LocateADoc.com" src="/images/profile/doctors/#doctor.photoFilename#" style="width: 100px; float: left;">
							<cfif hasContactForm></a></cfif>
						</cfif> --->
						#trim(QA.answer)#
					</p>
					<p style="text-align: right;">
						--<cfif hasContactForm><a href="/#params.siloname#/contact"></cfif>#doctor.fullNameWithTitle#<cfif hasContactForm></a></cfif><br />
						#DateFormat(QA.approvedAt,"medium")#
					</p> --->
				</div>
			</cfloop>
			</form>
			<cfif search.pages GT 1><div class="pagination">#includePartial("/shared/_pagination_mobile.cfm")#</div></cfif>
		</cfif>

		<!--- <div class="button-prompt">
			<a onclick="PromptOpen();" class="btn-askadoctor SWbutton"></a>
		</div> --->
		</cfoutput>
	</div>
</div>


<!-- aside -->
<div class="aside">
	<cfoutput>
		#includePartial("/shared/minileadsidebox_mobile")#
		<!--- #includePartial(partial="/shared/sharesidebox",margins="10px 0")# --->
		<cfif displayAd IS TRUE>
			#includePartial(partial	= "/shared/ad",
							size	= "#adType#300x250")#
		</cfif>
		#includePartial("/shared/proceduresofferedsidebox")#
	</cfoutput>
</div>

<div class="prompt-box hidefirst">
	<center>
		<table class="modal-box">
			<tr class="row-buttons">
				<td colspan="2"><div class="closebutton" onclick="ALListClose(); return false;"></div></td>
			</tr>
			<tr class="row-t">
				<td class="l-t"></td>
				<td class="t"></td>
			</tr>
			<tr class="row-c">
				<td class="l"></td>
				<td class="c">
					<cfoutput>
					<cfif NOT hasContactForm>
						This doctor is not eligible to receive your question. If you would like to submit a question to our Ask A Doctor panel, visit <a href="/ask-a-doctor">this page</a>.
					<cfelse>
						Ask <a href="/#params.siloname#/contact">#doctor.fullNameWithTitle#</a> your question
						or Ask our <a href="/ask-a-doctor">Ask A Doctor Panel</a> your question.
					</cfif>
					</cfoutput>
				</td>
			</tr>
			<tr class="row-b">
				<td class="l-b"></td>
				<td class="b"></td>
			</tr>
		</table>
	</center>
</div>