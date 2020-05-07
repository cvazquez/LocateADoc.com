<cfoutput>
	<div id="page1" class="centered askADocExperts">
		<div id="bottom-content-wrapper">
			<div id="mobile-content">
				<div class="title">
					<h1 class="page-title">#specialContent.header#</h1>

					<cfif search.pages gt 1>
						<div class="pagination-wrapper">#includePartial("/shared/_pagination_mobile.cfm")#</div>
					</cfif>
				</div>
				<!-- content -->
				<div class="print-area" id="article-content">
					<cfif isDefined("Experts") and Experts.recordcount>
						<cfloop query="Experts">
							<div class="article askadoc-expert">
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
								<div style="float: left;" class="doctor-photo-thumb"><a href="/#experts.siloName#"><img src="/images/profile/doctors/thumb/#experts.photoFilename#" alt="#altTitleText#" title="#altTitleText#"></a></div>
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
						</cfloop>
					</cfif>
					<form name="resultsForm" action="##" method="post"></form>
					<cfif search.pages gt 1>
						<div class="pagination-wrapper">#includePartial("/shared/_pagination_mobile.cfm")#</div>
					</cfif>
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
					<div class="mobileWidget recentCategories">
						#includePartial("recentcategories")#
					</div>
					<div class="mobileWidget experts">
						#includePartial("experts")#
					</div>
				</div>

			</div>
		</div>
	</div>
</cfoutput>
