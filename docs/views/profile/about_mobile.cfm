<cfoutput>
	<!-- content -->
	<div class="content print-area">
		<div class="welcome-box">
			<h1 style="margin-bottom:10px;">#doctor.fullNameWithTitle#</h1>
			<!--- Certifications --->
			<cfif certifications.recordCount or (topDoc.recordCount and topDoc.showTopDocSeal and isAdvisoryBoard)>
				<div class="certifications">
					<cfif topDoc.recordCount and topDoc.showTopDocSeal and isAdvisoryBoard>
					<img src="/images/layout/badges/advisory_2013_small.jpg">
					<cfelse>
					<img src="/images/profile/miscellaneous/icon_check.gif">
					</cfif>
					<ul>
						<cfif topDoc.recordCount and topDoc.showTopDocSeal and isAdvisoryBoard>
							<li>LocateADoc.com Advisory Board Member</li>
						</cfif>
						<cfloop query="certifications">
							<li>#certifications.name#</li>
						</cfloop>
					</ul>
				</div>
			</cfif>
<!---
			<cfif practiceDoctors.recordCount gt 1>
				<p>
					Other doctors in our practice:<br />
					#selectTag(	name		= "doctorId",
								options		= practiceDoctors,
								valueField	= "accountDoctorId",
								selected	= params.key,
								textField	= "fullName",
								onchange	= "window.location='#URLfor(action="doctor")#/'+this.options[this.selectedIndex].value;"
								)#
				</p>
				<div style="clear:left; height:15px;"></div>
			</cfif>
 --->
			<!--- Insider --->
			<cfif isQuery(insider) and insider.recordcount>
				<h2>LocateADoc Q&A</h2>
				<cfloop query="insider">
					<p><strong>#replaceNoCase(insider.name,"$$city$$",currentLocation.cityName)#</strong></p>
					<p>#selectiveHTMLFilter(insider.answer)#</p>
				</cfloop>
			</cfif>
			<cfif len(trim(practice.uniqueValueProposition))>
				<h2>What Sets Us Apart</h2>
				<p>#selectiveHTMLFilter(practice.uniqueValueProposition)#</p>
			</cfif>
			<!--- Education --->
			<cfif len(trim(doctor.education))>
				<h2>Education</h2>
				<p>#selectiveHTMLFilter(doctor.education)#</p>
			</cfif>
			<!--- Additional affiliations --->
			<cfif len(trim(doctor.affiliation))>
				<h2>Other Affiliations</h2>
				<p>#selectiveHTMLFilter(doctor.affiliation)#</p>
			</cfif>
		</div>
		<!-- image-list -->
		<center>
		<ul class="image-list">
			<li>
				<div class="image">
					<a href="#URLFor(action='reviews',controller='#doctor.siloname#')#">
						<img src="/images/profile/img6-image-list.jpg" width="175" height="90" alt="Patient Reviews" />
						<strong class="caption">Patient Reviews</strong>
					</a>
				</div>
			</li>
			<cfif hasContactForm>
			<li>
				<div class="image">
					<a href="#URLFor(	action		= 'contact',
										controller	= '#doctor.siloname#',
										protocol	= "#(Server.ThisServer neq "dev" ? 'https' : '')#",
										onlyPath	= "#(Server.ThisServer neq "dev" ? 'false' : 'true')#")#">
						<img src="/images/profile/img4-image-list.jpg" width="175" height="90" alt="Contact Us" />
						<strong class="caption">Contact Us</strong>
					</a>
				</div>
			</li>
			</cfif>
			<cfif financingoptions.recordCount>
			<li>
				<div class="image">
					<a href="#URLFor(action='financing',controller='#doctor.siloname#')#">
						<img src="/images/profile/img5-image-list.jpg" width="175" height="90" alt="Financing" />
						<strong class="caption">Financing</strong>
					</a>
				</div>
			</li>
			</cfif>
		</ul>
		</center>
	</div>

	<!-- aside -->
	<div class="aside">
		#includePartial("/shared/minileadsidebox_mobile")#
		<!--- #includePartial(partial="/shared/sharesidebox",margins="10px 0")# --->
		<cfif displayAd IS TRUE>
			#includePartial(partial	= "/shared/ad",
							size	= "#adType#300x250")#
		</cfif>
		<div class="mobileWidget">
			#includePartial("/shared/beforeandaftersidebox")#
		</div>
		#includePartial("/shared/paymentoptionssidebox")#
	</div>
</cfoutput>