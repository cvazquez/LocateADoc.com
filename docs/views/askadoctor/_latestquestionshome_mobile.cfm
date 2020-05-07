<cfoutput>
#styleSheetLinkTag(	source	= "/askadoctor/questionshome", head	 = true)#
	<div class="askadoc-questions">
		<div class="heading-blue">
			<a href="/ask-a-doctor/questions" style="text-decoration:none;"><h2>Ask A Doctor <strong>Questions</strong></h2></a>
		</div>
		<div class="box">
			<div class="column-height">
				<div class="hold">
					<cfloop query="latestQuestions" endrow="5">
					<div class="askadoc-questions-widget-items">
						<div class="askadoc-questions-image-widget">
							<cfsavecontent variable="altTitleText">#latestQuestions.firstName# #latestQuestions.lastName#<cfif latestQuestions.title NEQ ""> , #latestQuestions.title#</cfif> - #latestQuestions.city#, #latestQuestions.state#</cfsavecontent>
							<a href="/ask-a-doctor/question/#latestQuestions.siloName#"><img src="/images/profile/doctors/thumb/#latestQuestions.photoFilename#" width="63" alt="#altTitleText#" title="#altTitleText#"></a>
						</div>

						<div class="askadoc-questions-widget">
							<cfset resourceLink = URLFor(controller="ask-a-doctor",action="question",key=latestQuestions.siloName)>
							<cfset resourceLinkText = trim(replace(latestQuestions.title, "Q&A:", ""))>

							#LinkTo(href=resourceLink,text=resourceLinkText)#
							#LinkTo(href=resourceLink,text="read more",class="read-more")#
						</div>
					</div>
					<div class="askadoc-questions-widget-separator"></div>
					</cfloop>
				</div>
			</div>
		</div>
	</div>
</cfoutput>