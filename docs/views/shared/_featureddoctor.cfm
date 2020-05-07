<cfparam name="arguments.widgetContent" default="">
<cfparam name="arguments.defaultAction" default="">

<cfif featuredListings.recordcount>
	<div class="sidebox">
		<div class="frame">
			<!-- side-gallery -->
			<div class="side-gallery">
				<div class="gallery">
					<h4>Featured <strong>Doctor<cfif featuredListings.recordcount gt 1>s</cfif></strong></h4>
					<cfif arguments.widgetContent neq ""><cfoutput><p>#arguments.widgetContent#</p></cfoutput></cfif>
					<ul class="gallery-carousel">
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
						<cfset tooltip = "#fullName# | #featuredListings.practice# | <i>Specialty: #featuredListings.specialty#</i> | #featuredListings.City#, #featuredListings.State# #featuredListings.postalCode#">
						<cfif formattedPhone neq "">
							<cfset tooltip &= " | <b>#formattedPhone#</b>">
						</cfif>
						<li>
							<h5 class="fullName tooltip" title="#tooltip#"><a href="/#featuredListings.siloName & arguments.defaultAction#?l=#featuredListings.locationID#">#fullName#</a></h5>
							<div class="box">
								<div class="visual tooltip" title="#tooltip#">
									<div class="t">
										<div class="b">
											<a href="/#featuredListings.siloName & arguments.defaultAction#?l=#featuredListings.locationID#"><img src="#Globals.doctorPhotoBaseURL & featuredListings.photoFilename#" alt="#fullname#" width="63" height="72" /></a>
										</div>
									</div>
								</div>
							</div>
							<div class="descr">
								<div class="desc-text tooltip" title="#tooltip#">
									<div class="name" style="height:12px; overflow:hidden;">#featuredListings.practice#</div>
									<div class="specialty" style="height:12px; overflow:hidden;"><i>#featuredListings.specialty#</i></div>
									<div>#featuredListings.city#, #featuredListings.State# #featuredListings.postalCode#</div>
									<div style="height:12px;">
										<cfif formattedPhone neq "">
											<b>#formattedPhone#</b>
										</cfif>
									</div>
								</div>
								<div class="details">
									<ul>
										<!--- <li><span class="rating"><cfif featuredListings.comments gt 0 and rating neq "">#Numberformat(featuredListings.rating,"9.0")#<cfelse>--</cfif></span></li> --->
										<cfif val(featuredListings.comments) gt 0>
										<cfset reviewNumberLabel = "#featuredListings.comments# Review#(featuredListings.comments GT 1 ? "s" : "")#">
										<li><a title="#reviewNumberLabel#" href="/#featuredListings.siloName#/reviews?l=#featuredListings.locationID#">
												<img src="/images/layout/ico105.gif" alt="#reviewNumberLabel#" style="vertical-align: middle;" >
												#reviewNumberLabel#
										</a></li>
										</cfif>
									</ul>
									<strong class="more">#linkTo(text="#(arguments.defaultAction eq '/pictures' ? 'VIEW PICTURES' : 'VIEW')#", href="/#featuredListings.siloName & arguments.defaultAction#?l=#featuredListings.locationID#")#</strong>
								</div>
							</div>
						</li>
					</cfoutput>
					</ul>
				</div>
				<cfif featuredListings.recordcount gt 1>
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
				</cfif>
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
	<!--- <cfsavecontent variable="tooltipJSandCSS">
		<cfoutput>
			<link rel="stylesheet" type="text/css" href="/stylesheets/jquery.tooltip.css" />
			<script type="text/javascript" src="/javascripts/jquery.tooltip.min.js"></script>
		</cfoutput>
	</cfsavecontent>
	<cfhtmlhead text="#tooltipJSandCSS#"> --->
</cfif>
