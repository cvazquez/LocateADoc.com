<cfset locationNumber = 1>
<cfoutput>
	<!-- content -->
	<div class="content print-area">
		<div class="welcome-box">
			<h1>Our Staff</h1>
			#includePartial(partial=staffInfo)#
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
			<cfif latestPictures.recordCount>
			<li>
				<div class="image">
					<a href="#URLFor(action='pictures',controller='#doctor.siloname#')#">
						<img src="/images/profile/img7-image-list.jpg" width="175" height="90" alt="Before and After Gallery" />
						<strong class="caption">Before and After Gallery</strong>
					</a>
				</div>
			</li>
			</cfif>
		</ul>
		</center>
	</div>
	<!-- widgets -->
	<div class="aside">
		#includePartial("/shared/minileadsidebox")#
		#includePartial(partial="/shared/sharesidebox",margins="10px 0")#
		<cfif displayAd IS TRUE>
			#includePartial(partial	= "/shared/ad",
							size	= "#adType#300x250")#
		</cfif>
		#includePartial("/shared/practicesnapshotsidebox")#
		#includePartial("/shared/specialofferssidebox")#
	</div>
</cfoutput>