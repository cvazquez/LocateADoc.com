<cfparam name="params.showMap" default="false">
<!---
<cfoutput>
	#includePartial("map")#
</cfoutput>
 --->

<cfif ListFirst(params.showMap) IS TRUE>
	<cfsavecontent variable="js">
		<cfoutput>
			<script type="text/javascript">
				$(function(){
					// Code from Thickbox's init
					tb_init('a.thickbox, area.thickbox, input.thickbox');//pass where to apply thickbox
					imgLoader = new Image();// preload image
					imgLoader.src = tb_pathToImage;
					loadMap();
					tb_show("","##TB_inline?width=700&height=480&inlineId=mapModal","");
				})
			</script>
		</cfoutput>
	</cfsavecontent>
	<cfhtmlhead text="#fnCompress(js)#">
</cfif>
<!--- <cfsavecontent variable="js">
	<cfoutput>
		<link rel="stylesheet" type="text/css" href="/stylesheets/jquery.tooltip.css" />
		<script type="text/javascript" src="/javascripts/jquery.tooltip.min.js"></script>
		<script type="text/javascript">
			$(function(){
				$(".tooltip").tooltip({
					delay: 0,
					track: true,
					showBody: " | "
				});
			});
		</script>
	</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#fnCompress(js)#"> --->


<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1>
	<cfset params = Request.oUser.appendUserInfo(params)>
</cfif>

<cfoutput>
	#styleSheetLinkTag(source="thickbox", head=true)#
	#javaScriptIncludeTag(source="thickbox", head=true)#
	#javaScriptIncludeTag(source="profile/main", head=true)#
</cfoutput>

<cfif doctorLocations.recordCount gt 1>
	<cfsavecontent variable="locationsModal">
		<cfoutput>
			<div class="hidden" id="locationSelect">
				<!--- <h1>Select Location</h1> --->
				<p>Please choose any of our offices from the list below.</p>
				<cfloop query="doctorLocations">
					<p class="video-holder">
						<a href="##" onclick="profileChangeLocation(event,#doctorLocations.id#);">
						#doctorLocations.address#<br />
						#doctorLocations.name#, #doctorLocations.abbreviation# #doctorLocations.postalCode#
						<cfif not isPastAdvertiser and not isBasicPlusOver2Leads and doctorLocations.phonePlus neq ""><br />#formatPhone(doctorLocations.phonePlus)#</cfif>
						</a>
					</p>
				</cfloop>
			</div>
		</cfoutput>
	</cfsavecontent>
	<cfset contentFor(modalWindows=locationsModal)>
</cfif>

<cfif practiceDoctors.recordCount gt 1>
	<cfsavecontent variable="doctorsModal">
		<cfoutput>
			<div class="hidden" id="doctorSelect">
				<!--- <h1>Select Doctor</h1> --->
				<cfloop query="practiceDoctors">
					<p class="video-holder">
						<a href="/#practiceDoctors.siloName#?l=#practiceDoctors.accountLocationID#">#practiceDoctors.fullNameWithTitle#</a>
					</p>
				</cfloop>
			</div>
		</cfoutput>
	</cfsavecontent>
	<cfset contentFor(modalWindows=doctorsModal)>
</cfif>

<cfoutput>
	<div class="topsections">
		<div class="vcard">
			<div class="holder">
				<div class="frame">
					<cfif topDoc.recordCount and topDoc.showTopDocSeal>
						<div class="tooltip" title="TOP DOCTOR | <div style='width:200px;'>To qualify as a Top Doctor, a practice must have met a high engagement level with contributions to LocateADoc.com, have a majority of positive comments and reviews, and have a medical license and/or training in the specialty listed.</div>">
							<img <cfif isAdvisoryBoard>style="margin-left: 20px;"</cfif> src="/images/layout/badges/topdoctor_current_large.png" id="top_doc_logo">
						</div>
					</cfif>
					<cfif isAdvisoryBoard>
						<div class="tooltip" title="ADVISORY BOARD MEMBER | <div style='width:200px;'>The LocateADoc Advisory Board is compiled of a small group of elite medical industry professionals involved in performing various treatments and procedures patients search for on LocateADoc.com. The Board provides beneficial industry insights to the LocateADoc team, honest feedback and constructive criticism on current and new patient needs and overall business direction as it relates to industry trends. The Board and Executive Management continuously explore ways to build trust and ensure potential patients have the best user experience, every time, when searching for a doctor on LocateADoc.com.</div>">
							<img src="/images/layout/badges/advisory.png" id="advisory_logo">
						</div>
					</cfif>
					<cfif practice.logoFileName neq "">
						<cfset fullImageBase = (server.thisServer EQ "dev" ? protocol & domain : '') & practiceImageBase>
						<cftry>
							<!--- Load image with coldfusion so it can be manipulated --->
							<cfimage name="practiceLogo" source="#protocol & domain & practiceImageBase#/#practice.logoFileName#" action="read">
							<cfif IsImage(practiceLogo)>
								<cfif (ImageGetHeight(practiceLogo) gt 62) or (ImageGetWidth(practiceLogo) gt 360)>
									<cfset ImageScaleToFit(practiceLogo, 360, 62)>
								</cfif>
								<strong class="logo">
									<!--- <cfimage source="#practiceLogo#" action="writeToBrowser" alt="#practice.name#"> --->
									<img src="#fullImageBase#/#practice.logoFileName#" style="width:#ImageGetWidth(practiceLogo)#px; height:#ImageGetHeight(practiceLogo)#px;" alt="#practice.name#" itemprop="image" />
								</strong>
							</cfif>
							<!--- If coldfusion doesn't support the image format, the browser will manipulate the image --->
							<cfcatch>
								<strong class="logo">
									<img src="#fullImageBase#/#practice.logoFileName#" height="62" style="max-width:360px;" alt="#practice.name#" itemprop="image" />
								</strong>
							</cfcatch>
						</cftry>
					</cfif>
					<strong class="fn name" itemprop="name">#doctor.fullNameWithTitle#</strong>
					<p class="org practice">#practice.name#</p>
					<strong class="specialty">#listChangeDelims(valueList(topSpecialties.name),", ")#</strong>
					<cfif practiceDoctors.recordCount gt 1>
						<a href="##TB_inline?width=350&inlineId=doctorSelect" title="Select Doctor" class="thickbox">Other Doctors in this Practice</a>
					</cfif>
				</div>
			</div>
		</div>

		<script type="text/javascript">
			$(function(){
				SmartTruncate('.vcard .practice',15);
				SmartTruncate('.vcard .specialty',30);
			});
		</script>

		<!--- TODO: Adjust for no image option --->
		<div class="photo">
			<img src="#doctorPhoto#" width="214" height="195" alt="#doctor.firstName# #doctor.middleName# #doctor.lastName#<cfif doctor.title neq "">, #doctor.title#</cfif>" />
		</div>

		<cfparam name="params.firstname" default="">
		<cfparam name="params.lastname" default="">
		<cfparam name="params.email" default="">
		<cfparam name="params.phone" default="">

		<cfif Len(Variables.miniErrorList) gt 0 and ListGetAt(Variables.miniErrorList,1) eq 1>
			<cfset topLeadFormOn = true>
			<cfif Len(Variables.miniFormData) gt 0>
				<cfset params.firstname = Replace(ListGetAt(Variables.miniFormData,1),"fn=","")>
				<cfset params.lastname = Replace(ListGetAt(Variables.miniFormData,2),"ln=","")>
				<cfset params.email = Replace(ListGetAt(Variables.miniFormData,3),"em=","")>
				<cfset params.phone = Replace(ListGetAt(Variables.miniFormData,4),"ph=","")>
			</cfif>
		<cfelse>
			<cfset topLeadFormOn = false>
		</cfif>

		<div class="contact-box">
			<div id="contact-content" <!--- <cfif topLeadFormOn>class="hidden"</cfif> --->>
				<div class="contact-top">
					<cfif doctorLocations.recordCount gt 1>
						<div style="position:absolute; right:0; top:-2px;"><a href="##TB_inline?width=350&inlineId=locationSelect" title="Select Location" class="thickbox link-locations">Change Location</a></div>
					</cfif>
					<div style="float:left;">
						<h3>Contact Information</h3>
						<address<cfif params.action eq "reviews"> itemprop="address" itemscope itemtype="http://schema.org/PostalAddress"</cfif>>
							<div><span itemprop="streetAddress">#currentLocation.address#</span></div>
							<div>
								<span itemprop="addressLocality">#currentLocation.cityName#, #currentLocation.stateAbbreviation#</span>
								<span itemprop="postalCode"> #currentLocation.postalCode#</span>
							</div>
							<cfif currentLocation.countryId neq 102>
								<div>#currentLocation.countryName#</div>
							</cfif>
						</address>

						<cfif isBasic>
							<!--- This opens up in the claimprofilepopup div below --->
							<div style="padding-top: 5px; font-size: 1em;">Is this your practice? <a href="##" class="CPbutton" onclick="showClaimProfile(#doctor.id#); return false;" style="font-weight: bold;">Claim your Profile</a> by clicking here for instructions.</div>
						<cfelse>
							<div style="height:54px;"></div>
						</cfif>
					</div>

					<cfif ((not isPastAdvertiser and not isBasicPlusOver2Leads and not isBasic)
							OR (isYext AND currentLocationDetails.phoneYext neq "" AND not isPastAdvertiser))
							AND (	currentLocationDetails.phonePlus neq "" OR
									(isYext and (currentLocationDetails.phoneYext neq "")) OR
									currentLocation.phone NEQ "" OR
									hasContactForm
								)>
						<ul id="contact-icons">
							<cfif currentLocationDetails.phonePlus neq "">
								<li><img src="/images/layout/profile-icon-phone.png" alt="phone" border="0"><span class="contact-phone-number" itemprop="telephone">#formatPhone(currentLocationDetails.phonePlus)#</span></li>
							<cfelseif isYext and (currentLocationDetails.phoneYext neq "")>
								<li><img src="/images/layout/profile-icon-phone.png" alt="phone" border="0"><span class="contact-phone-number" itemprop="telephone">#formatPhone(currentLocationDetails.phoneYext)#</span></li>
							<cfelseif currentLocation.phone NEQ "">
								<li><a href="##" onclick="profileMiniOpen(3); return false;"><img src="/images/layout/profile-icon-phone.png" alt="phone" border="0">Get Phone Number</a></li>
							</cfif>

							<cfif hasContactForm>
								<!--- Has to be on one line otherwise formatting breaks --->
								<cfif coupons.recordCount><li><a href="#URLfor(controller=doctor.siloName,action="offers")#"><img src="/images/layout/profile-icon-special-offers.png" alt="offers" border="0">Special Offers</a></li></cfif>
								<li>
									<a href="##" onclick="profileMiniOpen(4); return false;"><img src="/images/layout/profile-icon-email.png" alt="email" border="0">Doctor's Email</a>
								</li>
								<!--- Remove empty urls and retrieve first non-empty one --->
								<cfset validURL = ListFirst(ListSort(valueList(accountInfo.url),"text","asc",",","false"))>
								<cfif trim(validURL) NEQ "">
									<cfif reFindNoCase("^https?://", validURL)>
										<cfset websiteURL = validURL>
									<cfelse>
										<cfset websiteURL = "http://#validURL#">
									</cfif>

									<li>
									<cfif isAdvertiser>
										<a	href="#websiteURL#"
										 	clicktrackkeyvalues="accountDoctorId:#doctor.id#;accountDoctorLocationId:#doctorLocations.id#;profileTab:#params.action#"
											clicktracklabel="DoctorProfileWebsiteLink"
											clicktracksection="ContactInformation" target="#validURL#"><img src="/images/layout/profile-icon-website.png" alt="website" border="0" rel="nofollow">Doctor's Website</a>
									<cfelse>
										<a href="##" onclick="profileMiniOpen(2); return false;"><img src="/images/layout/profile-icon-website.png" alt="website" border="0">Doctor's Website</a>
									</cfif>
									</li>
								</cfif>
							</cfif>
						</ul>
					</cfif>
				</div>
				<cfif isBasic>
					#includePartial("/doctormarketing/claimprofilepopup")#
				</cfif>
				<cfif not isPastAdvertiser and not isBasicPlusOver2Leads>
					#includePartial("minileadpopup")#
				</cfif>
				<cfif hasContactForm>
					<a href="#Server.ThisServer neq "dev" ? "https://#CGI.SERVER_NAME#" : ""#/#doctor.siloName#/contact" class="btn-red-orange" clicktrackkeyvalues="accountDoctorId:#params.key#;accountDoctorLocationId:#locationId#" clicktracklabel="ConsultDoctorButtonOrangeWhite" clicktracksection="ProfileContact">Get a Consultation</a>
				<cfelse>
					#includePartial(partial="/shared/sitewideminileadsidebox", isPopup=true)#
				</cfif>
				<div class="link-box">
					<a href="#URLFor(controller=doctor.siloName,anchor="TB_inline")#?width=700&height=480&inlineId=mapModal" id="map_link" onclick="loadMap()" title="Office Locations" class="thickbox link-map <cfif doctorLocations.recordCount eq 1>alone-link-map</cfif>"><span class="link-span">View on Map</span></a>
				</div>
			</div>
		</div>
	</div>
#includePartial("gallerynavprompt")#
</cfoutput>
