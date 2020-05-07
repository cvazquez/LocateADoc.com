<cfoutput>
<!-- content -->
<div class="content">
  <div id="tab-welcome" class="print-area">
	<!-- welcome-box -->
	<div class="welcome-box">
		<h1>#doctor.fullNameWithTitle#</h1>
		<cfif trim(doctor.headline) neq "">
			<h4>#doctor.headline#</h4>
		</cfif>

		<!-- text-block -->
		<div class="text-block">
			<cfif doctor.consultationCost1 gt 0>
				<div style="margin-bottom:30px;">#includePartial(partial="consultation", linkOffer=(coupons.recordCount gt 0))#</div>
			</cfif>
			<cfif len(trim(doctor.pledge))>
				<div class="video-holder">
					<p>#doctor.pledge#</p>
				</div>
			</cfif>
			<cfif len(trim(accountInfo.content))>
				<div class="video-holder">
					<h2>#practice.name#</h2>
					<p>#accountInfo.content#</p>
				</div>
			</cfif>
			<!--- Testimonial --->
			<cfif len(trim(doctor.patientTestimonial))>
				<div class="video-holder">
					<h3>#LinkTo(controller=doctor.siloName,action="reviews",text="Patient Testimonials")#</h3>
					<div itemprop="review" itemscope itemtype="http://schema.org/Review">
						<cfif len(trim(doctor.patientPhoto))>
							<cfset thisURL = "">
							<cfif server.thisServer EQ "dev">
								<cfif NOT FileExists("#Globals.serverImagePath#/images/profile/testimonials/#doctor.patientPhoto#")>
									<cfset thisURL = "http://www.locateadoc.com">
								</cfif>
							</cfif>
							<div class="profile-testimonial-image">
							<img src="#thisURL#/images/profile/testimonials/#doctor.patientPhoto#" itemprop="image">
							</div>
						</cfif>
						<p itemprop="reviewBody">
							<img src="/images/profile/miscellaneous/quote_left.gif" style="margin:0 5px 2px 0;">
							#doctor.patientTestimonial#
							<img src="/images/profile/miscellaneous/quote_right.gif" style="margin:2px 0 0 5px;">
						</p>
						<span style="text-align:right;" itemprop="author">-#doctor.patientName#, #doctor.patientOccupation#</span>
						<meta itemprop="worstRating" content = "0"/>
						<meta itemprop="ratingValue" content = "10"/>
						<meta itemprop="bestRating" content = "10"/>
					</div>
				</div>
			</cfif>
			<!--- Top 5 benefits --->
			<cfif top5Benefits.recordCount>
				<h3>Top Benefits</h3>
				<ul>
					<cfloop query="top5Benefits">
						<li>#top5Benefits.name#</li>
					</cfloop>
				</ul>
			</cfif>
			<!--- Top procedures --->
			<cfif topProcedures.recordCount>
				<p><strong>Some of our most asked about procedures:</strong> #topProcedureNames#</p>
			</cfif>
			<!--- Areas Served --->
			<cfif feederMarkets.recordCount>
				<p><strong>Areas Served:</strong> #valueList(feederMarkets.name, ", ")#
			</cfif>
		</div>
		<!-- image-list -->
		<cfif isAdvertiser or hasContactForm or staffInfo.recordCount>
			<center>
			<ul class="image-list">
				<cfif isAdvertiser>
					<li id="tour_link">
						<div class="image">
							<a href="##" class="tour_link" onclick="tourOpen(); return false;">
								<img src="/images/layout/img1-image-list.jpg" width="175" height="90" alt="Take the Office Tour" />
								<strong class="caption">Take the Office Tour</strong>
							</a>
						</div>
					</li>
				</cfif>
				<cfif hasContactForm>
					<li>
						<div class="image">
							<a href="#URLFor(	action='contact',
												controller='#doctor.siloname#',
												protocol	= "#(Server.ThisServer neq "dev" ? 'https' : '')#",
												onlyPath	= "#(Server.ThisServer neq "dev" ? 'false' : 'true')#"
												)#">
								<img src="/images/profile/img4-image-list.jpg" height="90" alt="Contact Us" />
								<strong class="caption">Contact Us</strong>
							</a>
						</div>
					</li>
				</cfif>
				<cfif staffInfo.recordCount>
					<li>
						<div class="image">
							<a href="#URLFor(action='staff',controller='#doctor.siloname#')#">
								<img src="/images/layout/img3-image-list.jpg" height="90" alt="Meet Our Staff" />
								<strong class="caption">Meet Our Staff</strong>
							</a>
						</div>
					</li>
				</cfif>
			</ul>
			</center>
		</cfif>
	</div>
  </div>
</div>

<!-- aside -->
<div class="aside">
	<div class="mobileWidget">
		#includePartial("/shared/beforeandaftersidebox")#
	</div>
	#includePartial("/shared/proceduresofferedsidebox")#
	<!--- #includePartial("practicetour_mobile")# --->
	#includePartial("ups3d")#
	<!--- #includePartial(partial="/shared/sharesidebox",margins="10px 0")# --->
	<cfif displayAd IS TRUE>
		#includePartial(partial	= "/shared/ad",
						size	= "#adType#300x250")#
	</cfif>
	#includePartial("/shared/minileadsidebox_mobile")#
</div>
</cfoutput>