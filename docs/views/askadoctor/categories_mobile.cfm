<cfoutput>
	<div id="page1" class="centered askADocCategories">
		<div id="bottom-content-wrapper">
			<div id="mobile-content">
				<div class="title">
					<h1 class="page-title">#header#</h1>
				</div>

					<div class="article">
						<cfif content NEQ ""><p>#content#</p></cfif>
						<p style="text-align: center; font-family: BreeRegular, Arial, Helvetica, sans-serif; font-size: 23px;">#linkto(controller="ask-a-doctor", text="Ask Your Question")#</p>
</cfoutput>

<cfset procedureCount = 0>
<cfoutput query="qCategories" group="specialtyName">
	<cfset specialtyProcedureCount = 0>
	<cfset continueSpecialty = FALSE>

	<p>
	<h2><cfif listFind(specialtyIds, qCategories.specialtyId)>
			<a href="/ask-a-doctor/questions/#qCategories.specialtySiloName#" style="text-decoration: none;">
		</cfif>
		#qCategories.specialtyName#
		<cfif listFind(specialtyIds, qCategories.specialtyId)></a></cfif>
	</h2>

	<ul class="procedure-list">
	<cfoutput>
		<cfif specialtyProcedureCount LTE 5>
			<cfset thisClass = "">
			<cfset procedureCount = procedureCount + 1>
		<cfelse>
			<cfset thisClass = "hiddenCategory specialty#qCategories.specialtyId#">
			<cfset continueSpecialty = TRUE>
		</cfif>
			<cfset thisProcedureCount = listLen(MakeSet(sCategories[qCategories.procedureId].questionList))>
			<li class="#thisClass#"><a href="/ask-a-doctor/questions/#qCategories.siloName#">#qCategories.procedureName#</a> (#thisProcedureCount#)</li>

			<cfset specialtyProcedureCount = specialtyProcedureCount + 1>
	</cfoutput>
	<cfif continueSpecialty>
		<li style="list-style-type: none;" >
			<span onClick="ShowProcedures(#qCategories.specialtyId#);" class="SeeAll#qCategories.specialtyId# LikeALink">View More...</span>
			<span onClick="HideProcedures(#qCategories.specialtyId#);" class="hiddenCategory HideAll#qCategories.specialtyId# LikeALink">View Less...</span>
		</li>
	</cfif>
	</ul>

	</p>
</cfoutput>
<cfoutput>
					</div>
				</div>


				<!-- aside2 -->
				<div class="aside3" id="article-widgets">
					<div class="swm mobileWidget">
						<h2>Contact A Doctor</h2>
						#includePartial("/mobile/mini_form")#
					</div>
					<div class="mobileWidget lastestQuestions">
						#includePartial("latestquestions")#
					</div>
					<div class="mobileWidget experts">
						#includePartial("experts")#
					</div>
				</div>

			</div>
		</div>
</cfoutput>