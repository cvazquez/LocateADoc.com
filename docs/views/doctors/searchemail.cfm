<cfset layoutWidth = "320">

<cfoutput>
	<div style="background: none!important; width: #layoutWidth#px!important; padding: 0; height: auto; min-height: 0; overflow: hidden;">
		<div style="background: none!important; width: #layoutWidth#px!important; padding: 0; height: auto;min-height: 0;">
			<div style="position: relative; width: 100% !important;">
				<div style="width: 100%;">
					<div style="margin: 0px 0 0; overflow: hidden; padding: 0 5px 0 5px;">
						<div style="width: 100%; overflow: hidden;">
							<div style="width: 100%; overflow: hidden;">
								<cfif search.results.recordcount and search.landingHeader neq "">
									<cfif search.page eq 1>
										<h1 style="font: 22px/28px Arial, Helvetica, sans-serif; color: ##a64942; margin-top: 0px; float: left; font-weight: bolder; ">#search.landingHeader#</h1>
										<cfif search.landingContent neq "">
											<div style="font-family: Arial,Helvetica,sans-serif;clear: left;margin-bottom: 15px;">
												<cfset newLandingContent = replace(search.landingContent, "<h2 ", '<h2 style="margin: 0px 0px 0px; font: 18px/22px Arial, Helvetica, sans-serif; color: ##577b77; font-weight: bold;" ', "all")>
												#newLandingContent#
											</div>
											<h2 style="margin: 0 0 5px; font: 18px/22px Arial, Helvetica, sans-serif; color: ##577b77; font-weight: bold;">#search.landingSubHeader#:</h2>
										</cfif>
									<cfelseif search.landingSubHeader neq "">
										<h2 style="margin: 0 0 5px; font: 18px/22px Arial, Helvetica, sans-serif; color: ##577b77; font-weight: bold;">#search.landingSubHeader#:</h2>
									</cfif>
								<cfelseif search.results.recordcount and search.searchSummary neq "">
									<h1 style="font-weight: bolder; margin-top: 0px; margin-bottom: 0px; margin: 0px 5px -5px 0; float: left; font: 20px/28px Arial, Helvetica, sans-serif; color: ##a64942;">#search.searchSummary#</h1>
								<cfelse>
									<h1 style="font-weight: bolder; margin: 0px 5px -5px 0; float: left; font: 20px/28px Arial, Helvetica, sans-serif; color: ##a64942;">Search Results</h1>
									<cfif search.results.recordcount eq 0>
										<br style="clear:both;">
										<p>No doctors were found<cfif search.searchSummary neq ""> for #trim(LCase(search.searchSummary))#</cfif>.</p>
										<cfif (val(params.city) gt 0 and val(params.state) gt 0) or val(params.zipCode) gt 0>
											<p>There may be doctors in nearby areas. Try <cfif val(params.distance)>increasing the distance of<cfelse>adding a distance to</cfif> your search with the distance filter on the left side.</p>
											<p>#linkTo(text="You can also return to the search form and modify your search by clicking here.", controller="doctors", action="index", key="modify")#</p>
										<cfelse>
											<p>#linkTo(text="Return to the search form to modify your search", controller="doctors", action="index", key="modify")#</p>
										</cfif>
									</cfif>
								</cfif>
								<cfif search.results.recordcount>
									<div style="width: 100%; overflow: hidden; padding: 0 0 14px;">
										<span style="float: left; margin: 0px 0 0; color: ##6c6c6c; font: 12px Arial, Helvetica, sans-serif; background: ##fff; font-weight: bold;">(#search.totalrecords# results)</span>
									</div>
								</cfif>
							</div>
							<div class="print-area">
							<div  style="width: 100%; overflow: hidden; font: 12px/15px Arial, Helvetica, sans-serif;">
<ul style="margin: 0; padding: 0 0 28px; list-style: none; width: 100%; overflow: hidden;">
<cfif isdefined("search.results.firstname")>
<cfloop query="search.results">
	<!--- format full name --->
	<cfset fullName = "#search.results.firstname# #Iif(search.results.middlename neq '',DE(search.results.middlename&' '),DE('')) & search.results.lastname#">
	<cfif LCase(search.results.title) eq "dr" or LCase(search.results.title) eq "dr.">
		<cfset fullName = "Dr. #fullName#">
	<cfelseif search.results.title neq "">
		<cfset fullName &= ", #search.results.title#">
	</cfif>
	<!--- format phone number --->
	<cfset formattedPhone = formatPhone(search.results.phone)>

	<!--- Type 1 --->
	<cfif search.results.inforank eq 2 or search.results.isFeatured>
		<li style="min-height: 150px; float: none; overflow: auto; width: auto; padding: 10px 0 0; background: url(http://www.locateadoc.com/images/layout/bg-hor-blue01.jpg) no-repeat 50% 100%; margin-bottom: 9px; border-bottom: 1px solid ##d2d2d6;">

			<cfif search.results.photoFilename neq "" and search.results.isFeatured eq 1>
				<div style="float:left;">

					<div class="AskADocExpertsThumbnailBorder1" style="width: 71px; background: url('http://www.locateadoc.com/images/layout/bg-cl-visual.gif') repeat-y scroll 0% 0% transparent;">
					<div class="AskADocExpertsThumbnailBorder2" style="background: url('http://www.locateadoc.com/images/layout/bg-cl-visual.gif') no-repeat scroll -71px 0px transparent;">
					<div class="AskADocExpertsThumbnailBorder3" style="background: url('http://www.locateadoc.com/images/layout/bg-cl-visual.gif') no-repeat scroll -142px 100% transparent; padding: 0px;">
					<a href="/#search.results.siloName#?l=#search.results.locationID#" style="color: ##0e7496; display: block;">
						<img width="63" height="72" alt="#fullName#" title="#fullName#" src="#Globals.doctorPhotoBaseURL & search.results.photoFilename#" style="border-style: none; display: block; padding: 4px; border-style: none;" />
					</a>
					</div>
					</div>
					</div>

					<cfif search.results.showTopDocSeal>
						<br />
						<span id="top-doc-search" class="tooltip" title="TOP DOCTOR" style=" display: inline-block;  clear: none!important;">
							<img src="http://#Globals.domain#/images/layout/badges/topdoctor_current_small.png" alt="Top Doctor" title="Top Doctor" style="border-style: none;">
						</span>
					</cfif>
					<cfif search.results.isAdvisoryBoard>
						<br />
						<span class="tooltip" title="ADVISORY BOARD MEMBER">
							<img src="http://#Globals.domain#/images/layout/badges/advisory.png" alt="Advisory Board Member" title="Advisory Board Member" width="65" height="65">
						</span>
					</cfif>
				</div>
				<!--- START: name, address, phone --->
				<div style=" width: 217px; margin: 0px 0px 0px 76px;">
			<cfelse>
				<div class="text-box full-text" style="width: 236px;  margin: 3px 0 0;">
			</cfif>
					<div style="padding: 0; width: 100%; overflow: hidden;">
						<div style="float: left; width: 236px;">

							<ul class="doc-list noseperator" style="width:236px; padding: 0 0 4px !important; overflow: hidden; list-style: none; line-height: 16px;">
								<li style="overflow: auto; background: none; padding-left: 0 !important; padding-right: 9px; padding-bottom: 0px; line-height: 16px; margin: 0px; border-bottom: 1px solid ##d2d2d6; border: none !important; width: auto !important; float: none !important;">
									<h3 style="margin: 0; color: ##577b77; font: 14px/18px Arial, Helvetica, sans-serif; font-weight: bold;">
										#linkTo(text=fullName, href="/#search.results.siloName#?l=#search.results.locationID#", style="text-decoration: none; color: ##577b77")#</h3></li>
								<li style="overflow: auto; background: none; padding-left: 0 !important; padding-right: 9px; padding-bottom: 0px; line-height: 16px; margin: 0px; border-bottom: 1px solid ##d2d2d6; border: none !important; width: auto !important; float: none !important;"><strong class="practice-name">#search.results.practice#</strong></li>
								<li style="line-height: 16px; margin-top: 2px; overflow: auto; background: none; padding-left: 0 !important; padding-right: 9px; padding-bottom: 0px; line-height: 16px; margin: 0px; border-bottom: 1px solid ##d2d2d6; border: none !important; width: auto !important; float: none !important;">#FormalCapitalize(search.results.address)#</li>
								<li  style="line-height: 16px; margin-bottom: 2px; overflow: auto; background: none; padding-left: 0 !important; padding-right: 9px; padding-bottom: 0px; line-height: 16px; margin: 0px; border-bottom: 1px solid ##d2d2d6; border: none !important; width: auto !important; float: none !important;">#search.results.city#, #search.results.state# #search.results.postalCode#</li>
							</ul>

							<div style="width: 100%; margin-bottom: 5px; overflow: hidden;">
								<cfif formattedPhone neq "">
								<dl style="margin: 0; padding: 2px 17px 4px 0px;  line-height: 20px;  float: left;">
									<dt style="padding-left: 0;  background: none; margin: 0 5px 0 0;  float: left;">P:</dt>
									<dd style="margin: 0; float: left;">#formattedPhone#</dd>
								</dl>
								</cfif>
								<cfif val(comments) gt 0>
								<dl style="margin: 0; padding: 2px 17px 4px 12px; <cfif formattedPhone neq "">background: url(http://www.locateadoc.com/images/layout/separator08.gif) no-repeat;</cfif> line-height: 20px; float: left;">
									<a title="Patient Reviews" href="/#search.results.siloName#/reviews?l=#search.results.locationID#" style="text-decoration: none; color: ##0e7496;">
									<dt style="margin: 0 5px 0 0; float: left;"><img width="25" height="20" alt="Reviews" title="Reviews" src="/images/layout/ico-comments.png" class="png" style="margin-right: 4px; float: left;" /></dt>
									<dd>#comments#</dd>
									</a>
								</dl>
								</cfif>
							</div>
						</div>
					</div>
				</div>
				<!--- END: name, address, phone --->

				<p style="clear:both; margin: 0px 0px 0px 0px;">
				<strong  style="width:209px;  color: ##925069; font: 13px Arial, Helvetica, sans-serif; font-weight: bold;">#search.results.specialtylist#</strong>
				</p>

			<cfif trim(StripHTML(search.results.description)) NEQ "" OR search.results.topprocedures neq "">
				<cfif trim(StripHTML(search.results.description)) NEQ "">
					<div style="display:inline-block; font: 12px Arial, Helvetica, sans-serif; margin-top: 0px;"><p>#search.results.description#</p></div>
				</cfif>
				<cfif search.results.topprocedures neq "">
					<p style="margin: 0 0 15px;"><strong>Most Popular Procedures:</strong> #search.results.topprocedures#</p>
				</cfif>
			<cfelse>
				<p>&nbsp;</p>
			</cfif>
		</li>
	<!--- Type 2 --->
	<cfelseif search.results.inforank eq 1 or search.results.isBasicPlus>
		<li class="profile-box" style="min-height: 120px; float: none; overflow: auto; width: auto; padding: 10px 0 0; background: url(http://www.locateadoc.com/images/layout/bg-hor-blue01.jpg) no-repeat 50% 100%; margin-bottom: 9px; border-bottom: 1px solid ##d2d2d6;">

			<div class="text-box full-text" style="width: 100%; float: right; margin: 3px 0 0;">
				<div class="tb-hold" style="padding: 0; width: 100%; overflow: hidden;">
					<div class="tb-add" style="float: left; width: 100%">
						<ul class="doc-list noseperator" style="line-height: 20px; margin: 0; list-style: none; width: 100%; overflow: hidden; padding: 0 0 4px !important;">
							<li class="noseperator" style="overflow: auto; background-image: none; padding-left: 0px; padding-right: 9px; padding-bottom: 0px; line-height: 20px; margin: 0px;">
							<h3 style="margin: 0; color: ##577b77; font: 14px/18px Arial, Helvetica, sans-serif; font-weight: bold;">
							<cfif search.results.isYext AND trim(fullName) eq "">
								#linkTo(text=search.results.practice, href="/#search.results.siloName#?l=#search.results.locationID#",  style="text-decoration: none; color: ##577b77")#
							<cfelse>
								#linkTo(text=fullName, href="/#search.results.siloName#?l=#search.results.locationID#",  style="text-decoration: none; color: ##577b77")#
							</cfif>
							</h3></li>
							<cfif not (search.results.isYext AND trim(fullName) eq "")>
								<li class="noseperator practice-name" style="overflow: auto; background-image: none; padding-left: 0px; padding-right: 9px; padding-bottom: 0px; line-height: 20px; margin: 0px;"><strong>#search.results.practice#</strong></li>
							</cfif>
							<li class="address1" style="overflow: auto; line-height: 16px; margin-top: 2px; margin-left: 0px;">#FormalCapitalize(search.results.address)#</li>
							<li class="address2" style="overflow: auto; line-height: 16px; margin-bottom: 2px;; margin-left: 0px;">#search.results.city#, #search.results.state# #search.results.postalCode#</li>
							<cfif search.results.isYext AND formattedPhone neq "">
								<li  style="margin-left: 0px;">P: #formattedPhone#</li>
							</cfif>
						</ul>
					</div>
				</div>
				<p class="specialty" style="width:100%; margin: 0px 0px 0px 0px;   color: ##925069; font: 14px Arial, Helvetica, sans-serif; font-weight: bold;">#search.results.specialtylist#</p>

			</div>
			<cfif search.results.topprocedures neq "" or search.results.description neq "">
				<div class="details" style="color: ##6c6c6c; font: 12px/15px Arial, Helvetica, sans-serif; overflow: hidden; padding: 10px 0px 2px 1px; margin: 10 0 -12px; position: relative; background: url(http://www.locateadoc.com/images/layout/bg-details02.gif) no-repeat 50% 100%;">
					<cfif search.results.description neq ""><div class="listing-description" style="font: 12px Arial, Helvetica, sans-serif;"><p style="margin: 0 0 15px;">#search.results.description#</p></div></cfif>
					<cfif search.results.topprocedures neq ""><p style="margin: 0 0 15px;"><strong>Most Popular Procedures:</strong> #search.results.topprocedures#</p></cfif>
				</div>
			<cfelse>
				<p>&nbsp;</p>
			</cfif>
		</li>
	<!--- Type 3 --->
	<cfelse>
		<li class="profile-box" style="min-height: 120px; float: none; overflow: auto; width: auto; padding: 10px 0 0; background: url(http://www.locateadoc.com/images/layout/bg-hor-blue01.jpg) no-repeat 50% 100%; margin-bottom: 9px; border-bottom: 1px solid ##d2d2d6;">

			<div class="text-box full-text" style="width: 100%; float: right; margin: 3px 0 0;">
				<div class="tb-hold" style="padding: 0; width: 100%; overflow: hidden;">
					<div class="tb-add" style="float: left; width: 100%">
						<ul class="doc-list noseperator" style="line-height: 20px; margin: 0; list-style: none; width: 100%; overflow: hidden; padding: 0 0 4px !important;">
							<li class="noseperator" style="overflow: auto; background-image: none; padding-left: 0px; padding-right: 9px; padding-bottom: 0px; line-height: 20px; margin: 0px;">
							<h3 style="margin: 0; color: ##577b77; font: 14px/18px Arial, Helvetica, sans-serif; font-weight: bold;">
							<cfif search.results.isYext AND trim(fullName) eq "">
								#linkTo(text=search.results.practice, href="/#search.results.siloName#?l=#search.results.locationID#",  style="text-decoration: none; color: ##577b77")#
							<cfelse>
								#linkTo(text=fullName, href="/#search.results.siloName#?l=#search.results.locationID#",  style="text-decoration: none; color: ##577b77")#
							</cfif>
							</h3></li>
							<cfif not (search.results.isYext AND trim(fullName) eq "")>
								<li class="noseperator practice-name" style="overflow: auto; background-image: none; padding-left: 0px; padding-right: 9px; padding-bottom: 0px; line-height: 20px; margin: 0px;"><strong>#search.results.practice#</strong></li>
							</cfif>
							<li class="address1" style="overflow: auto; line-height: 16px; margin-top: 2px; margin-left: 0px;">#FormalCapitalize(search.results.address)#</li>
							<li class="address2" style="overflow: auto; line-height: 16px; margin-bottom: 2px;; margin-left: 0px;">#search.results.city#, #search.results.state# #search.results.postalCode#</li>
							<cfif search.results.isYext AND formattedPhone neq "">
								<li class="noseperator listing-phone" style="margin-left: 0px;">P: #formattedPhone#</li>
							</cfif>
						</ul>
					</div>
				</div>
				<p class="specialty" style="width:100%; margin: 0px 0px 0px 0px;   color: ##925069; font: 13px Arial, Helvetica, sans-serif; font-weight: bold;">#search.results.specialtylist#</p>

			</div>
			<cfif search.results.topprocedures neq "" or search.results.description neq "">
				<div class="details" style="color: ##6c6c6c; font: 12px/15px Arial, Helvetica, sans-serif; overflow: hidden; padding: 10px 0px 2px 1px; margin: 10 0 -12px; position: relative; background: url(http://www.locateadoc.com/images/layout/bg-details02.gif) no-repeat 50% 100%;">
					<cfif search.results.description neq ""><div class="listing-description" style="font: 12px Arial, Helvetica, sans-serif;"><p style="margin: 0 0 15px;">#search.results.description#</p></div></cfif>
					<cfif search.results.topprocedures neq ""><p style="margin: 0 0 15px;"><strong>Most Popular Procedures:</strong> #search.results.topprocedures#</p></cfif>
				</div>
			<cfelse>
				<p>&nbsp;</p>
			</cfif>
		</li>
	</cfif>
</cfloop>

	<cfif search.totalrecords GT search.results.recordcount>
		<a href="http://#cgi.server_name#/doctors/#params.siloName#/location-#params.zipCode#" target="#params.siloName##params.zipCode#">View More Doctors In Your Area.</a>
	</cfif>
</cfif>
										</ul>
							</div>
							</div>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
</cfoutput>