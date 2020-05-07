<cfset javaScriptIncludeTag(source="resources/video", head=true)>
<cfoutput>
	<!-- main -->
	<div id="main" class="resource_videos">
		<cfif NOT isMobile>
			#includePartial("/shared/breadcrumbs")#
			#includePartial(partial	= "/shared/ad", size="generic728x90top")#
		</cfif>
		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder pattern-top article-container">
				<cfif NOT isMobile>
					#includePartial("/shared/pagetools")#
				</cfif>

				<!-- content -->
				<div class="print-area" id="article-content">
					<div class="blog-header">
						<h1 class="blog-head"><cfif params.specialty gt 0>#specialtyInfo.name# </cfif>Video Gallery</h1>
						<cfif params.page eq 1>
							<p>Watch videos about physicians in a certain specialty, office overviews, specific procedures, and other developments.</p>
						</cfif>
							<div class="styled-select" style="width: 265px; float:left;">
							<select class="video-specialty" style="width:285px;">
								<cfif params.specialty gt 0>
									<option value="#URLFor(action="video")#">All Videos</option>
								<cfelse>
									<option value="#URLFor(action="video")#">Select Specialty...</option>
								</cfif>
								<cfloop query="videoSpecialties">
									<option value="#URLFor(action="video",key="specialty-"&videoSpecialties.id)#"<cfif params.specialty eq videoSpecialties.id> selected </cfif>>#videoSpecialties.name#</option>
								</cfloop>
							</select>
						</div>
					</div>
					<cfif search.pages gt 1>
						<div class="pagination">#includePartial("/shared/_pagination#mobileSuffix#.cfm")#</div>
					</cfif>
					<form name="resultsForm" action="##" method="post" class="resource_video_results">
					<cfif isDefined("videoInfo") and videoInfo.recordcount>
						<cfloop query="videoInfo">
							<!--- format full name --->
							<cfset fullName = "#videoInfo.firstname# #Iif(videoInfo.middlename neq '',DE(videoInfo.middlename&' '),DE('')) & videoInfo.lastname#">
							<cfif LCase(videoInfo.title) eq "dr" or LCase(videoInfo.title) eq "dr.">
								<cfset fullName = "Dr. #fullName#">
							<cfelseif videoInfo.title neq "">
								<cfset fullName &= ", #videoInfo.title#">
							</cfif>
							<div class="video-listing">
								<div class="photo">
									<a href="/#videoInfo.siloName#?vid=#videoInfo.id#">
										<img src="http://#Globals.domain & videoInfo.imagePreview#" />
									</a>
								</div>
								<h3 class="preview">#LinkTo(href="/#videoInfo.siloName#?vid=#videoInfo.id#",text=videoInfo.headline)#</h3>
								<h3>#fullName#</h3>
								#videoInfo.description#
							</div>
						</cfloop>
					</cfif>
					</form>
					<cfif search.pages gt 1>
						<div class="pagination">#includePartial("/shared/_pagination#mobileSuffix#.cfm")#</div>
					</cfif>
				</div>

				<!-- aside2 -->
				<div class="aside3" id="article-widgets">
					<cfif NOT isMobile>
						#includePartial("/shared/sharesidebox")#
					</cfif>
					<div class="mobileWidget">
						#includePartial("/shared/beforeandaftersidebox")#
					</div>

					<div class="mobileWidget">
						#includePartial("/shared/featureddoctor")#
					</div>

					<cfif NOT isMobile>
						#includePartial(partial	= "/shared/ad", size="generic300x250")#
					</cfif>

					<cfif NOT isMobile>
						#includePartial("latestarticles")#
					</cfif>

					<cfif isMobile>
						<div class="swm mobileWidget">
							<h2>Contact A Doctor</h2>
							#includePartial("/mobile/mini_form")#
						</div>
					</cfif>
				</div>

			</div>
		</div>
	</div>
</cfoutput>