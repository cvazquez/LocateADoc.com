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
						<h1>#specialContent.header#</h1>
					</div>
					<div class="pagination">#includePartial("/shared/_pagination.cfm")#</div>

					<cfif isDefined("Experts") and Experts.recordcount>
						<cfloop query="Experts">
							<div class="article" style="clear: both;">
								<cfset expertDate = Experts.maxPublishDate>
								<cfif IsDate(expertDate)>
									<cfif DateDiff("yyyy",expertDate,now()) eq 0>
										<div class="dateflag">#Replace(DateFormat(expertDate,"mmm d")," ","<br>")#</div>
									<cfelse>
										<div class="dateflag">#Replace(DateFormat(expertDate,"mmm yyyy")," ","<br>")#</div>
									</cfif>
								</cfif>


								<cfsavecontent variable="altTitleText">#Experts.firstName# #Experts.lastName#<cfif Experts.title NEQ ""> , #Experts.title#</cfif> - #experts.city#, #experts.state#</cfsavecontent>
								<div>
								<div style="float: left;"><a href="/#experts.siloName#"><img src="/images/profile/doctors/thumb/#experts.photoFilename#" alt="#altTitleText#" title="#altTitleText#"></a></div>
								<div style="">
									<h3 class="preview"><a href="/#Experts.siloName#">#Experts.firstName# #Experts.lastName#<cfif Experts.title NEQ ""> , #Experts.title#</cfif></a></h3>
									<strong>#experts.practiceName#</strong><br />
									#experts.city#, #experts.state#
									<cfif experts.isAdvertiser EQ 1>
										<cfif experts.phoneNumber NEQ "">
											<p>
											<img src="/images/layout/profile-icon-phone.png" alt="phone" border="0" style="margin: -7px 3px 0px 0px!Important;border: 0;">#formatPhone(experts.phoneNumber)#
											</p>
										<cfelse>
											<br /><br />
										</cfif>
										<a href="/#Experts.siloName#/contact" class="btn-red-orange" clicktrackkeyvalues="accountDoctorId:#experts.accountDoctorId#;accountDoctorLocationId:#experts.accountDoctorLocationId#" clicktracklabel="ConsultDoctorButtonOrangeWhite" clicktracksection="AskADocExperts">Get a Consultation</a>
									</cfif>
								</div>
								</div>
							</div>

							<div class="bottomline"></div>
						</cfloop>
					</cfif>
					<form name="resultsForm" action="##" method="post"></form>
					<cfif search.pages gt 1>
						<div class="pagination">#includePartial("/shared/_pagination.cfm")#</div>
					</cfif>
				</div>

				<!-- aside2 -->
				<div class="aside3" id="article-widgets">
					#includePartial("/shared/sharesidebox")#
					#includePartial("latestquestions")#
				</div>

			</div>
		</div>
	</div>
</cfoutput>