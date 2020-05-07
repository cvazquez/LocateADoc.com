<!-- sideblock -->
<div class="sideblock">
	<div class="heading-blue">
		<cfoutput>
		<h3><a href="#featuredDoctorsLink#" style="text-decoration: none;">Featured <strong>Doctors</strong></a></h3>
		</cfoutput>
	</div>
	<div class="gallery">
		<div class="holder">
			<ul>
				<cfset clickTrackSection = "FeaturedDoctorsCarousel">
				<cfsavecontent variable="paramKeyValues">
					<cfloop collection="#params#" item="pC">
						<cfif isnumeric(params[pC])>
							#pC#:#val(params[pC])#;
						</cfif>
					</cfloop>
				</cfsavecontent>

				<cfoutput query="featuredListings">
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
					<cfset tooltip = "#fullName# | #featuredListings.practice# | <i>Specialty: #featuredListings.specialty#</i> | #featuredListings.City#, #featuredListings.State# #featuredListings.postalCode#">
					<cfif formattedPhone neq "">
						<cfset tooltip &= " | <b>#formattedPhone#</b>">
					</cfif>
					<li>
						<div class="profile-box">
							<div class="photo tooltip" title="#tooltip#">
								<a	clickTrackSection	= "#clickTrackSection#"
									clickTrackLabel		= "Photo"
									clickTrackKeyValues	= "#clickTrackKeyValues#"
									href="/#featuredListings.siloName#?l=#featuredListings.locationID#"><img src="#Globals.doctorPhotoBaseURL & featuredListings.photoFilename#" width="94" height="108" alt="#fullName#" /></a>
							</div>
							<div class="text-box">
								<div class="tooltip" title="#tooltip#">
									<h4><strong><a	class="fullName"
													clickTrackSection	= "#clickTrackSection#"
													clickTrackLabel		= "Fullname"
													clickTrackKeyValues	= "#clickTrackKeyValues#"
													href="/#featuredListings.siloName#?l=#featuredListings.locationID#">#fullName#</a></strong></h4>
									<div class="name" style="height:12px; overflow:hidden;">#featuredListings.practice#</div>
									<div class="specialty" style="height:12px; overflow:hidden;"><i>#featuredListings.specialty#</i></div>
									<address>#featuredListings.City#, #featuredListings.State# #featuredListings.postalCode#</address>
									<div style="height:12px; overflow:hidden;">
										<cfif formattedPhone neq "">
											<span class="phone"><b>#formattedPhone#</b></span>
										</cfif>
									</div>
								</div>
								<div class="row">
									<!--- <dl>
										<dt><img class="png" src="/images/layout/ico-star.png" width="19" height="18" alt="image description" /></dt>
										<dd><cfif featuredListings.comments gt 0 and rating neq "">#Numberformat(featuredListings.rating,"9.0")#<cfelse>--</cfif></dd>
									</dl> --->
									<cfif val(featuredListings.comments) gt 0>
									<dl>
										<a	clickTrackSection	= "#clickTrackSection#"
											clickTrackLabel		= "Comments"
											clickTrackKeyValues	= "#clickTrackKeyValues#"
											title="Patient Reviews" href="/#featuredListings.siloName#/reviews?l=#featuredListings.locationID#">
										<dt><img class="png" src="/images/layout/ico-comments.png" width="25" height="20" alt="image description" /></dt>
										<dd>#featuredListings.comments#</dd>
										</a>
									</dl>
									</cfif>
									#linkTo(	clickTrackSection	= "#clickTrackSection#",
												clickTrackLabel		= "View",
												clickTrackKeyValues	= "#clickTrackKeyValues#",
												text="VIEW",
												href="/#featuredListings.siloName#?l=#featuredListings.locationID#",
												class="view-link")#
								</div>
							</div>
						</div>
					</li>
				</cfoutput>
			</ul>
		</div>
		<cfif featuredListings.recordcount gt 1>
		<!-- foot -->
		<div class="foot">
			<a href="##" class="link-next">Next</a>
			<ul class="switcher">
				<li class="active"><a href="##"><span>1</span></a></li>
				<li><a href="##"><span>2</span></a></li>
				<li><a href="##"><span>3</span></a></li>
				<li><a href="##"><span>4</span></a></li>
			</ul>
			<a href="##" class="link-prev">Previous</a>
		</div>
		</cfif>
	</div>
</div>
<script type="text/javascript">
	$(function(){
		SmartTruncate('.fullName',17,176,true);
		SmartTruncate('.name',12,176,true);
		SmartTruncate('.specialty',12,176,true);
		<!--- $(".tooltip").tooltip({
			delay: 0,
			track: true,
			showBody: " | "
		}); --->
	});
</script>
<!--- <cfsavecontent variable="tooltipJSandCSS">
	<cfoutput>
		<link rel="stylesheet" type="text/css" href="/stylesheets/jquery.tooltip.css" />
		<script type="text/javascript" src="/javascripts/jquery.tooltip.min.js"></script>
	</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#tooltipJSandCSS#"> --->
