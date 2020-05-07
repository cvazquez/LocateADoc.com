<cfset javaScriptIncludeTag(source="doctormarketing/advertising", head=true)>
<cfif NOT isMobile>
	<cfset styleSheetLinkTag(source="doctormarketing/advertising", head=true)>
</cfif>
<cfoutput>
	<!-- main -->
	<div id="main">
		<cfif NOT isMobile>
			#includePartial("/shared/breadcrumbs")#
		</cfif>
		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder">
				<cfif NOT isMobile>
					#includePartial("/shared/pagetools")#
				</cfif>
				<div class="content-frame">

					<div class="resources-box advertising">
						<div class="title">
							<h1 class="page-title">#headerContent.title#</h1>
						</div>
						<div class="box">
							<div class="visual">
								<div class="t">&nbsp;</div>
								<div class="c">
									<a href="##"><img src="/images/doctors_only/patientleads.jpg" alt="" width="229" height="161" /></a>
								</div>
								<div class="b">&nbsp;</div>
							</div>
							<div class="descr">
								#headerContent.content#
							</div>
						</div>
					</div>
					<div class="full-content advertising">
						<div class="advertiser-placements">
							<h3>Click on each of the following ad placements to view on the right:</h3>
							<ul class="advertising-options">
								<li>
									<a href="##topdoctor">Regional "Top Doctor" Sponsored Ad</a>
									<img src="http://#Globals.domain#/images/layout/badges/topdoctor_current_large.png" class="top-doctor-badge">
									<p>Own the "Top Doctor" position in your specialty and region site wide with this sponsored ad section. Not only will you be featured in the directory but also on all related resource guides, articles, blog posts and galleries for any region and specialty you choose. This also includes the opportunity to contribute as an expert columnist on LocateADoc.com. <a href="http://www.practicedock.com/documents/2013 LocateADoc_com Top Doctor program.pdf">See details.</a></p>
								</li>
								<li>
									<a href="##featuredlisting">Featured Listings (unlimited leads)</a>
									<p>Want to pull patients from all around your city, or even a few cities?  A LocateADoc  Featured Listing will guarantee you are listed in the directory first or in a featured position for any city, region, or state you choose, for any specialty. This also includes the opportunity to contribute as an expert columnist on LocateADoc.com.</p>
								</li>
								<li>
									<a href="##citylisting">City Only Listing (unlimited leads)</a>
									<p>If your target patient is less than 10 miles from you then this is the perfect listing. The enhanced city only listing highlights your practice for all patients that search your specific city and specialty.</p>
								</li>
								<li>
									<a href="##bannerads">Vertical & Horizontal Banner Ads by Region and/or Specialty</a>
									<p>Whether you are a national or regional advertiser, we can target your customer by region and search options for each display ad.</p>
								</li>
							</ul>
							<h3>All patient leads are managed on the PracticeDock lead manager dashboard.</h3>
							<ul>
								<li>Update your profile</li>
								<li>Track all leads</li>
								<li>Send automated emails to new leads</li>
								<li>Track ROI</li>
								<li>Download all leads</li>
								<li>#LinkTo(anchor="more-features",text="More Features")#</li>
							</ul>
							<p></p>
						</div>

						<div class="lad-options-image">
							<img src="http://#Globals.domain#/images/doctors_only/lad_options_test.jpg" />
							<div class="lad-options-blackout"></div>
							<div id="LAD_options_1" class="lad-options-overlay"><img src="http://#Globals.domain#/images/doctors_only/lad_options_1.jpg" /></div>
							<div id="LAD_options_2" class="lad-options-overlay"><img src="http://#Globals.domain#/images/doctors_only/lad_options_2.jpg" /></div>
							<div id="LAD_options_3" class="lad-options-overlay"><img src="http://#Globals.domain#/images/doctors_only/lad_options_3.jpg" /></div>
							<div id="LAD_options_4" class="lad-options-overlay"><img src="http://#Globals.domain#/images/doctors_only/lad_options_4.jpg" /></div>
							<div id="LAD_options_5" class="lad-options-overlay"><img src="http://#Globals.domain#/images/doctors_only/lad_options_5.jpg" /></div>
							<div id="LAD_options_6" class="lad-options-overlay"><img src="http://#Globals.domain#/images/doctors_only/lad_options_6.jpg" /></div>
							<div id="LAD_options_7" class="lad-options-overlay"><img src="http://#Globals.domain#/images/doctors_only/lad_options_7.jpg" /></div>
						</div>
					</div>

					<cfif NOT isMobile>
						#IncludePartial("morefeatures")#
					</cfif>

				</div>
			</div>
		</div>
	</div>
</cfoutput>