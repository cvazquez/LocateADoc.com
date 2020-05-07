<html>
<head>
	<script type="text/javascript" src="/common/procedureselectdata"></script>
	<cfset styleSheetLinkTag(source="all", head=true)>
	<cfset javaScriptIncludeTag(source="#server.jquery.core#,#server.jquery.ui.core#,main", head=true)>
</head>
<body class="container" style="background:none;margin:0;padding:0;width:600px;height:491px;">
<cfoutput>
	<div class="feature-doctors">
		<div class="gallery">
			<div class="heading">
				<h3>Featured <strong>Doctors</strong></h3>
				<cfif featuredListings.recordcount gt 2>
				<a href="##" class="link-prev">Previous</a>
				<ul class="switcher">
					<li class="active"><a href="##"><span>1</span></a></li>
					<li><a href="##"><span>2</span></a></li>
					<li><a href="##"><span>3</span></a></li>
					<li><a href="##"><span>4</span></a></li>
				</ul>
				<a href="##" class="link-next">Next</a>
				</cfif>
			</div>
			<div class="holder">
				<ul><cfset clickTrackSection = "FeaturedDoctorsCarousel">
					<cfsavecontent variable="paramKeyValues">
						<cfloop collection="#params#" item="pC">
							<cfif isnumeric(params[pC])>
								#pC#:#val(params[pC])#;
							</cfif>
						</cfloop>
					</cfsavecontent>

					<cfloop query="featuredListings">
						<cfsavecontent variable="clickTrackKeyValues">
							accountDoctorLocationId:#featuredListings.id#;
							position:#featuredListings.currentRow#;
							practiceRank:#featuredListings.PracticeRank#;
							zoneId:#featuredListings.zoneId#;
							zoneStateId:#featuredListings.zoneStateId#;
							#paramKeyValues#
						</cfsavecontent>

						<!--- format full name --->
						<cfset fullName = "#featuredListings.firstname# #Iif(featuredListings.middlename neq '',DE(featuredListings.middlename&' '),DE('')) & featuredListings.lastname#">
						<cfif LCase(featuredListings.title) eq "dr" or LCase(featuredListings.title) eq "dr.">
							<cfset fullName = "Dr. #fullName#">
						<cfelseif featuredListings.title neq "">
							<cfset fullName &= ", #featuredListings.title#">
						</cfif>
						<!--- format phone number --->
						<cfset formattedPhone = formatPhone(featuredListings.phone)>
						<cfif currentrow mod 2 eq 1><li></cfif>
						<div class="profile-box">
							<div class="photo">
								<a	target				= "_top"
									clickTrackSection	= "#clickTrackSection#"
									clickTrackLabel		= "Photo"
									clickTrackKeyValues	= "#clickTrackKeyValues#"
									href="/#featuredListings.siloName#?l=#featuredListings.locationID#"><img src="#Globals.doctorPhotoBaseURL & featuredListings.photoFilename#" width="113" height="129" alt="#fullName#" /></a>
							</div>
							<div class="text-box">
								<h4><strong>#linkTo(	target				= "_top",
														clickTrackSection	= "#clickTrackSection#",
														clickTrackLabel		= "View",
														clickTrackKeyValues	= "#clickTrackKeyValues#",
														text=fullName,
														href="/#featuredListings.siloName#?l=#featuredListings.locationID#")#</strong>   |  #featuredListings.City#, #featuredListings.State# </h4>
								<strong class="name">#featuredListings.practice#</strong>
								<div class="row">
									<cfif formattedPhone neq "">
									<dl>
										<dt><img src="/images/layout/profile-icon-phone.png" style="margin:-3px -3px 0 0;"></dt>
										<dd style="font-size:16px;">#formattedPhone#</dd>
									</dl>
									</cfif>
									<!--- <dl>
										<dt><img class="png" src="/images/layout/ico-star.png" width="19" height="18" alt="image description" /></dt>
										<dd><cfif featuredListings.comments gt 0 and rating neq "">#Numberformat(featuredListings.rating,"9.0")#<cfelse>--</cfif></dd>
									</dl> --->
									<cfif val(featuredListings.comments) gt 0>
									<dl>
										<a	target				= "_top"
											clickTrackSection	= "#clickTrackSection#"
											clickTrackLabel		= "Comments"
											clickTrackKeyValues	= "#clickTrackKeyValues#"
											title="Patient Reviews" href="/#featuredListings.siloName#/reviews?l=#featuredListings.locationID#">
										<dt><img class="png" src="/images/layout/ico-comments.png" width="25" height="20" alt="image description" /></dt>
										<dd>#featuredListings.comments#</dd>
										</a>
									</dl>
									</cfif>
								</div>
								<strong class="specialty">#featuredListings.specialties#</strong>
							</div>
							#linkTo(text="VIEW PROFILE", target="_top", href="/#featuredListings.siloName#?l=#featuredListings.locationID#", class="view-link")#
						</div>
						<cfif (currentrow mod 2 eq 0) or (currentrow eq recordcount)></li></cfif>
					</cfloop>
				</ul>
			</div>
		</div>
	</div>
</cfoutput>
</body>
</html>