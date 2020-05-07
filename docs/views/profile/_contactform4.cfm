<cfoutput>
	<h3>Thank You</h3>
	<p>We have provided the additional information to #doctor.fullName#. They should respond shortly.</p>
	<cfif financingoptions.recordCount>
		<p>Go to #LinkTo(controller=doctor.siloName,action="financing",text="Financing Information")#</p>
	<cfelseif HasFinancingSpeciaties>
		<p>Go to #LinkTo(controller="financing",text="Financing Information")#</p>
	</cfif>
	<cfset websiteLink = FindNoCase("http://",accountInfo.url) ? "" : "http://" & accountInfo.url>
	<cfif accountInfo.url NEQ "" AND isValid("URL",websiteLink)>
		<p>Go to #LinkTo(	href="#websiteLink#",
							text="#doctor.fullName#'s Web Site",
							onlyPath=false,
							target="_blank",
							clicktrackkeyvalues="accountDoctorId:#doctor.id#;accountDoctorLocationId:#doctorLocations.id#;profileTab:#params.action#",
							clicktracklabel="ProfileConfirmationWebsiteLink",
							clicktracksection="ContactFormConfirmation"
							)#</p>
	</cfif>
	<p><strong>Want to contact more doctors?</strong> No problem. During your visit with us each doctor's contact form that you visit will be filled with your information so you don't have to type it all over again. Just visit another doctor's contact form and click Send.</p>
	<p>Contact more #topSpecialties.name# doctors in #linkTo(text="#currentLocation.cityName#, #currentLocation.stateAbbreviation#", controller="doctors", action=topSpecialties.siloName, key=LCase(Replace("#currentLocation.cityName#-#currentLocation.stateAbbreviation#"," ","_","all")))#</p>
</cfoutput>