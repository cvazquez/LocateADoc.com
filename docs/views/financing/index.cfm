<style>
p.carecredit_font, tr.carecredit_font th, tr.carecredit_font td, div.applyheader.carecredit_font{
	font-family: myriad-pro, sans-serif!important;
}
</style>

<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1 and (not structKeyExists(FORM, "process_contact") or FORM.process_contact neq 1)>
	<cfset params = Request.oUser.appendUserInfo(params)>
</cfif>
<cfoutput>
	<!-- main -->
	<div id="main">
		<cfif NOT isMobile>
			#includePartial("/shared/breadcrumbs")#
			#includePartial(partial	= "/shared/ad",
							size	= "generic728x90top")#
		</cfif>
		<!-- container inner-container -->
		<div class="container inner-container">
			<div class="inner-holder">
				<cfif NOT isMobile>
					<!-- options -->
					#includePartial("/shared/pagetools")#
				</cfif>
				<!-- content-frame -->
				<div class="content-frame">
					<div id="content">
						<div class="financing">

						<img src="/images/carecredit_tag_cmyk.r.png" alt="CareCredit.com Patient Financing" border="0" style="width: 321px;">

						<p class="carecredit_font">CareCredit health, wellness and beauty credit card</p>
						<p class="carecredit_font">For cosmetic, dental, dermatologic, hair restoration and optical procedure financing.</p>

						<p class="carecredit_font">Think of CareCredit as your own health, wellness and beauty credit card.  Whether its plastic surgery, facial rejuvenation or a skin care visit, CareCredit can help you finance the procedures you want.  That's why we're pleased that many of the healthcare offices associated with LocateADoc.com accept the CareCredit credit card.  Popular promotional financing options* help you say "yes" to the products and treatments you want, and pay for them with convenient monthly payments.</p>
						<p class="carecredit_font">With promotional financing options, you can use your CareCredit card again and again for your cosmetic needs, as well as at 195,000 other merchant locations, including dentists, optometrists, veterinarians, Lasik surgeons and hearing specialists.</p>

						<p class="carecredit_font">It's free and easy to apply.  Credit decisions are provided immediately.  If you are approved, you can schedule your procedure even before you receive your card.  With more than 21 million accounts opened since CareCredit began nearly 30 years ago, we are the trusted source for healthcare credit cards.</p>

						<p class="carecredit_font" style="font-size: .5rem;">*Subject to credit approval.  Minimum Monthly payments required.  See CareCredit.com for details.</p>


						<!--- <p style="font: 16px/19px BreeLight,Arial,Helvetica,sans-serif;"><strong>CareCredit health, wellness and beauty credit card</strong><br />For cosmetic and dermatologic procedure financing</p>
						<p style="font: 16px/19px BreeLight,Arial,Helvetica,sans-serif;">Think of CareCredit as your own <strong>health, wellness and beauty credit card</strong>.  Whether it's plastic surgery, facial rejuvenation or a skin care visit, you shouldn't have to worry about how to get the procedures you want. That's why we're pleased to accept the CareCredit health, wellness and beauty credit card.  CareCredit lets you say "Yes" to recommended surgical and non-surgical cosmetic procedures, and pay for them in convenient monthly payments that fit your financial situation.</p>
						<p style="font: 16px/19px BreeLight,Arial,Helvetica,sans-serif;">With special financing options*,  you can use your CareCredit card again and again for your cosmetic needs, as well as at 186,000 other healthcare providers, including dentists, optometrists, veterinarians, ophthalmologists and hearing specialists.</p>
						<p style="font: 16px/19px BreeLight,Arial,Helvetica,sans-serif;">It's free and easy to apply and you'll receive a decision immediately.  If you're approved, you can schedule your procedures even before you receive your card.  With more than 21 million accounts opened since CareCredit began nearly 30 years ago, they are the trusted source for healthcare credit cards.</p>
						<p style="font-size: .5rem;">*Subject to credit approval. Minimum monthly payments required. Ask us for details.</p> --->

						<div id="carecredit">
							<center>
					           	<form action="#URLFor(controller='financing')#" class="FBpop" method="post" target="carecredit" onsubmit="HideFinancingForm();">
									<div class="applyheader carecredit_font">
										LocateADoc.com Patient Financing Questionnaire
									</div>
					           		<div class="applyform">
										<p class="carecredit_font">
											<!--- Please complete all fields and enter the name of the person who will fill out the financing application. --->
											Keep me in the loop!  Yes, I want to receive a list of LocateADoc.com doctors that accept CareCredit from my area.
										</p>
										<cfif errorList neq "">
											<p class="instruction invalid">
												There is information missing from your submission. Please correct the highlighted fields.
											</p>
										</cfif>
										<table border="0">
					            			<tr class="carecredit_font">
					            				<th<cfif ListContains(errorList,"First Name")> class="invalid"</cfif>>First Name</td>
					            				<td class="ContentSmall">
													<div class="styled-input"><span><input type="text" name="firstname" value="#params.firstname#" class="noPreText"></span></div>
													<!--- <p>(as it will appear on the application)</p> --->
												</td>
					            			</tr>
					            			<tr class="carecredit_font">
					            				<th<cfif ListContains(errorList,"Last Name")> class="invalid"</cfif>>Last Name</td>
					            				<td>
													<div class="styled-input"><span><input type="text" name="lastname" value="#params.lastname#" class="noPreText"></span></div>
												</td>
					            			</tr>

					            			<tr class="carecredit_font">
					            				<th<cfif ListContains(errorList,"Email")> class="invalid"</cfif>>My Email</td>
					            				<td>
													<div class="styled-input"><span><input type="text" name="email" value="#params.email#" class="noPreText"></span></div>
												</td>
					            			</tr>
					            			<tr class="carecredit_font">
					            				<th<cfif ListContains(errorList,"Zip")> class="invalid"</cfif>>Zip Code</td>
					            				<td>
													<div class="styled-input"><span><input type="text" name="zip" value="#params.zip#" class="noPreText"></span></div>
												</td>
					            			</tr>
					            		</table>
										<p align="left" style="color:##333; border-bottom: 4px solid silver; margin-bottom: 15px; padding-bottom: 15px;" class="carecredit_font">Clicking the CareCredit Apply Now button below will forward you to CareCredit.com to begin the easy financing application.  Please click button below and turn off your pop-up blocker.</p>
						            	<input type="hidden" name="submitted" value="1">
					            		<input type="image" src="/images/carecredit_button_applynow_v2.png" alt="Apply Online Now!" width="202" height="80" border="0">
									</div>
					            </form>

								</center>
							</div>

							<span id="carecopy" style="display:none;">
								<table border="0" width="85%" align="center">
			            			<tr>
			            				<td>
				            				<p>&nbsp;</p>
				            				<p class="thankyou-header">
					            				Thank you for applying for financing through CareCredit
											</p>
											<p class="thankyou">
												You have selected <span>CareCredit</span> as your financing provider, and you will be taken out of <span>LocateADoc.com</span> and redirected to the <span>CareCredit</span> website in a separate window.
											</p>
											<p>&nbsp;</p>
										</td>
			            			</tr>
								</table>
							</span>

						</div>
					</div>
					<!-- sidebar -->
					<div id="sidebar">
						<div class="search-box">
							<div class="t">&nbsp;</div>
							<div class="c">
								<div class="c-add">
									<div class="title">
										<h3>Payment Calculator</h3>
									</div>
									<ul>
										<li>
											<form method='get' action='http://www.carecredit.com/payment_calculator/template.html?ASPS=2' target="calc" onsubmit="window.open('##?ASPS=2', 'calc', 'width=600,height=800,status=yes,resizable=yes,scrollbars=yes')">
												<p>Estimate your monthly payment by entering your procedure cost:</p>
												<div class="stretch-input"><span>
													<input size="15" type="text" class="noPreText" name='amount' value='$' style="width:135px;">
												</span></div>
												<input type="submit" value="Calculate" class="btn-compare">
											</form>
										</li>
									</ul>
								</div>
							</div>
							<div class="b">&nbsp;</div>
						</div>
						#includePartial("/shared/sponsoredlink")#
					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>