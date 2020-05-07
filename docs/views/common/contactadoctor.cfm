<cfif params.processing>

	<h4>Thank you.</h4>
	<cfif listLen(params.doctors)>
		<p>We sent your information to the selected doctors.</p>
	</cfif>
	<cfif params.newsletter EQ 1>
		<p>You are subscribed to our Beautiful Living newsletter.
			<cfoutput>
			(<a href="#URLFor(controller="home",action="unsubscribe",params="email=#params.email#")#" target="_blank">Unsubscribe</a>)
			</cfoutput>
		</p>
	</cfif>

<cfelse>

	<cfif featuredListings.recordcount>

		<h4>Please select the doctors you would like to contact in your area</h4>
		<p>Please review the selections below, then continue by clicking on Request Information. You will also automatically subscribe to receive our free Beautiful Living publication for medical news. To opt out of this email, simply uncheck the selection.</p>
		<form action="">
			<center>
				<input type="button" class="btn-request" value="REQUEST INFORMATION">
				<input type="hidden" id="SWID" value="<cfoutput>#params.SWID#</cfoutput>">
			</center>
			<input type="checkbox" id="SWnewsletter" value="1" checked="checked" />
			<label>Free monthly newsletter of up-to-date elective surgery stories with unique perspectives directly from doctors and patients.</label>
			<br>
			<input id="selectAllOrNone" type="button" class="btn-compare" value="SELECT NONE">
			<div class="doctor-list-container">
				<ul>
					<cfoutput query="featuredListings">
						<!--- format full name --->
						<cfset fullName = "#featuredListings.firstname# #Iif(featuredListings.middlename neq '',DE(featuredListings.middlename&' '),DE('')) & featuredListings.lastname#">
						<cfif LCase(featuredListings.title) eq "dr" or LCase(featuredListings.title) eq "dr.">
							<cfset fullName = "Dr. #fullName#">
						<cfelseif featuredListings.title neq "">
							<cfset fullName &= ", #featuredListings.title#">
						</cfif>
						<!--- format phone number --->
						<cfset formattedPhone = formatPhone(featuredListings.phone)>
						<li<cfif currentrow mod 2 eq 0> class="rightside"</cfif>>
							<input type="checkbox" name="doctors" value="#featuredListings.id#" checked />
							<cfif featuredListings.photoFilename neq "">
								<img class="soft-border-image" height="114" width="100" alt="#fullName#" src="#Globals.doctorPhotoBaseURL & featuredListings.photoFilename#">
							<cfelse>
								<div style="width:118px; height:132px; display:inline-block; float:left;"></div>
							</cfif>
							<div class="doctor-info">
								<h5>#linkTo(text=fullName, href="/#featuredListings.siloName#?l=#featuredListings.locationID#")#</h5>
								<p>#featuredListings.practice#</p>
								<p>#featuredListings.address# #featuredListings.city#, #featuredListings.abbreviation# #featuredListings.postalCode#</p>
								<p><span>#formattedPhone#</span></p>
								<cfif featuredListings.distance gt 0>
									<cfset formattedDistance = REReplace(NumberFormat(featuredListings.distance,"9.9"),"\.?0+$","")>
									<p>#formattedDistance# mile<cfif formattedDistance neq 1>s</cfif> away</p>
								</cfif>
							</div>
						</li>
					</cfoutput>
				</ul>
			</div>
			<center>
				<input type="button" class="btn-request" value="REQUEST INFORMATION">
			</center>
		</form>

	<cfelse>

		<h4>No matching doctors were found in your area</h4>
		<p>Change your selected specialty or procedure, and try again.</p>

	</cfif>

</cfif>