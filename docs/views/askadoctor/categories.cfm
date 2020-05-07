<cfoutput>
	<!-- main -->
	<div id="main">
		#includePartial("/shared/breadcrumbs")#
		#includePartial(partial	= "/shared/ad", size="generic728x90top")#
		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder pattern-top article-container">
				#includePartial("/shared/pagetools")#

				<!-- content -->
				<div class="print-area" id="article-content">
					<div class="blog-header">
						<h1>#header#</h1>
					</div>

					<div class="article">
						<cfif content NEQ ""><p>#content#</p></cfif>
						<p style="text-align: center; font-family: BreeRegular, Arial, Helvetica, sans-serif; font-size: 23px;">#linkto(controller="ask-a-doctor", text="Ask Your Question")#</p>
</cfoutput>

					<cfset splitAt = ((qCategories.recordCount/8)) >
					<cfset procedureCount = 0>
					<cfset hasSplit = FALSE>

					<table border="0">
					<tr valign="top">
						<td>
					<cfoutput query="qCategories" group="specialtyName">
						<cfif procedureCount GTE splitAt AND NOT hasSplit>
							</td><td>
							<cfset hasSplit = TRUE>
						</cfif>
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
							<!--- <li style="list-style-type: none;"><a href="/ask-a-doctor/category/#qCategories.specialtySiloName#">See All Procedures and Treatments</a></li> --->
						</cfif>
						</ul>

						</p>
					</cfoutput>
						</td>
					</tr>
					</table>
<cfoutput>
					</div>
				</div>

				<!-- aside2 -->
				<div class="aside3" id="article-widgets">
					#includePartial("/shared/sharesidebox")#
					#includePartial("latestquestions")#
					#includePartial("experts")#
				</div>

			</div>
		</div>
	</div>
</cfoutput>