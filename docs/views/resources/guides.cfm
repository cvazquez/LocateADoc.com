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
</cfoutput>
					<cfset splitAt = ((qGuides.recordCount/8)) >
					<cfset procedureCount = 0>
					<cfset hasSplit = FALSE>

					<table border="0">
					<tr valign="top">
						<td>
					<cfoutput query="qGuides" group="specialtyName">
						<cfif procedureCount GTE splitAt AND NOT hasSplit>
							</td><td>
							<cfset hasSplit = TRUE>
						</cfif>
						<cfset specialtyProcedureCount = 0>
						<cfset continueSpecialty = FALSE>

						<p>
						<h2><cfif listFind(specialtyIds, qGuides.specialtyId)>
								<a href="/ask-a-doctor/questions/#qGuides.specialtySiloName#" style="text-decoration: none;">
							</cfif>
							#qGuides.specialtyName#
							<cfif listFind(specialtyIds, qGuides.specialtyId)></a></cfif>
						</h2>

						<ul class="procedure-list">
						<cfoutput>
							<cfif specialtyProcedureCount LTE 5>
								<cfset thisClass = "">
								<cfset procedureCount = procedureCount + 1>
							<cfelse>
								<cfset thisClass = "hiddenCategory specialty#qGuides.specialtyId#">
								<cfset continueSpecialty = TRUE>
							</cfif>
								<!--- <cfset thisProcedureCount = listLen(MakeSet(sGuides[qGuides.procedureId].resourceGuideList))> --->
								<li class="#thisClass#"><a href="/#qGuides.siloName#">#qGuides.procedureName#</a> <!--- (#thisProcedureCount#) ---></li>

								<cfset specialtyProcedureCount = specialtyProcedureCount + 1>
						</cfoutput>
						<cfif continueSpecialty>
							<li style="list-style-type: none;" >
								<span onClick="ShowProcedures(#qGuides.specialtyId#);" class="SeeAll#qGuides.specialtyId# LikeALink">View More...</span>
								<span onClick="HideProcedures(#qGuides.specialtyId#);" class="hiddenCategory HideAll#qGuides.specialtyId# LikeALink">View Less...</span>
							</li>
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
					#includePartial("popularguides")#
					#includePartial("infographicscarousel")#
					<!--- #includePartial("latestquestions")#
					#includePartial("experts")# --->
				</div>

			</div>
		</div>
	</div>
</cfoutput>