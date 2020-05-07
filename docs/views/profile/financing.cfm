<cfoutput>
	<!-- content -->
	<div class="content print-area">
		<div class="welcome-box">
			<h1>Financing</h1>
			<cfif listLen(Missing)>
				<!--- <img src="/images/icons/warning.gif" width=34 height=34 alt="Error" border="0"> --->
				<span class="error"><b>You are missing the following information:</b></span>
				<ul>
					<li>#ListChangeDelims(Missing,"</li><li>")#</li>
				</ul>
			<cfelse>
				<cfif params.PatientFinanceId EQ 6>
					#includePartial("surgeryLoans")#
					<!--- <cfset params.source_id = 45> --->
				<cfelse>
					#includePartial("careCredit")#
					<!--- <cfset params.source_id = 37> --->
				</cfif>
			</cfif>

			#includePartial("financeForm")#

		</div>
		<!-- image-list -->
		<center>
		<ul class="image-list">
			<li id="tour_link">
				<div class="image">
					<a href="##" class="tour_link" onclick="tourOpen(); return false;">
						<img src="/images/layout/img1-image-list.jpg" width="175" height="90" alt="Take the Office Tour" />
						<strong class="caption">Take the Office Tour</strong>
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
			<cfif staffInfo.recordCount>
			<li>
				<div class="image">
					<a href="#URLFor(action='staff',controller='#doctor.siloname#')#">
						<img src="/images/layout/img3-image-list.jpg" width="175" height="90" alt="Meet Our Staff" />
						<strong class="caption">Meet Our Staff</strong>
					</a>
				</div>
			</li>
			</cfif>
		</ul>
		</center>
	</div>
	<!-- aside -->
	<div class="aside">
		#includePartial("/shared/minileadsidebox")#
		#includePartial(partial="/shared/sharesidebox",margins="10px 0")#
		<cfif displayAd IS TRUE>
			#includePartial(partial	= "/shared/ad",
							size	= "#adType#300x250")#
		</cfif>
		#includePartial("/shared/paymentoptionssidebox")#
		#includePartial("/shared/beforeandaftersidebox")#
	</div>
</cfoutput>