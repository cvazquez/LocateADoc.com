<cfoutput>
<div class="sidebox">
	<div class="frame">
		<h4>Featured <strong>Doctors</strong></h4>
		<!-- side-gallery -->
		<div class="side-gallery">
			<div class="gallery">
				<ul class="carousel">
					<cfset clickTrackSection = "FeaturedDoctorsCarousel">
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
						<cfif currentrow mod 2 eq 1><li></cfif>
						<cfset formattedPhone = formatPhone(featuredListings.phone)>
						<cfset tooltip = "#fullName# | #featuredListings.practice# | <i>Specialty: #featuredListings.specialty#</i> | #featuredListings.City#, #featuredListings.State# #featuredListings.postalCode#">
						<cfif formattedPhone neq "">
							<cfset tooltip &= " | <b>#formattedPhone#</b>">
						</cfif>
						<div class="box">
							<h5 class="tooltip" title="#tooltip#"><a	clickTrackSection	= "#clickTrackSection#"
																		clickTrackLabel		= "Fullname"
																		clickTrackKeyValues	= "#clickTrackKeyValues#"
																		href="/#featuredListings.siloName#?l=#featuredListings.locationID#">#fullName#</a></h5>
							<div class="visual">
								<div class="t">
									<div class="b">
										<a	clickTrackSection	= "#clickTrackSection#"
											clickTrackLabel		= "Photo"
											clickTrackKeyValues	= "#clickTrackKeyValues#"
											href="/#featuredListings.siloName#?l=#featuredListings.locationID#"><img src="#Globals.doctorPhotoBaseURL & featuredListings.photoFilename#" alt="#fullname#" width="63" height="72" /></a>
									</div>
								</div>
							</div>
							<div class="descr">
								<div class="tooltip" title="#tooltip#">
									<p>
										<span class="name">#featuredListings.practice#</span><br />
										<span class="specialty"><i>#featuredListings.specialty#</i></span><br />
										#featuredListings.city#, #featuredListings.State# #featuredListings.postalCode#
										<span class="phone"><b>#formattedPhone#</b></span>
									</p>
								</div>
								<div class="details">
									<ul>
										<!--- <li><span class="rating"><cfif featuredListings.comments gt 0 and rating neq "">#Numberformat(featuredListings.rating,"9.0")#<cfelse>--</cfif></span></li> --->
										<cfif val(featuredListings.comments) gt 0>
										<li><a	clickTrackSection	= "#clickTrackSection#"
												clickTrackLabel		= "Comments"
												clickTrackKeyValues	= "#clickTrackKeyValues#"
												title="Patient Reviews" href="/#featuredListings.siloName#/reviews?l=#featuredListings.locationID#"><span class="comment">#featuredListings.comments#</span></a></li>
										</cfif>
									</ul>
									<strong class="more">
										#linkTo(	clickTrackSection	= "#clickTrackSection#",
													clickTrackLabel		= "View,
													clickTrackKeyValues	= "#clickTrackKeyValues#",
													href="/#featuredListings.siloName#?l=#featuredListings.locationID#")#
									</strong>
								</div>
							</div>
						</div>
						<cfif (currentrow mod 2 eq 0) or (currentrow eq recordcount)></li></cfif>
					</cfloop>
				</ul>
			</div>
			<!-- sw-box -->
			<div class="sw-box">
				<div>
					<a class="link-prev" href="##">Previous</a>
					<ul class="switcher">
						<li class="active"><a href="##"><span>1</span></a></li>
						<li><a href="##"><span>2</span></a></li>
						<li><a href="##"><span>3</span></a></li>
						<li><a href="##"><span>4</span></a></li>
					</ul>
					<a class="link-next" href="##">Next</a>
				</div>
			</div>
		</div>
	</div>
</div>
	<script type="text/javascript">
		$(function(){
			SmartTruncate('.fullName',17,268,true);
			SmartTruncate('.name',12,176,true);
			SmartTruncate('.specialty',12,176,true);
			<!--- $(".tooltip").tooltip({
				delay: 0,
				track: true,
				showBody: " | "
			}); --->
		});
	</script>
</cfoutput>
<!--- <cfsavecontent variable="tooltipJSandCSS">
	<cfoutput>
		<link rel="stylesheet" type="text/css" href="/stylesheets/jquery.tooltip.css" />
		<script type="text/javascript" src="/javascripts/jquery.tooltip.min.js"></script>
	</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#tooltipJSandCSS#"> --->