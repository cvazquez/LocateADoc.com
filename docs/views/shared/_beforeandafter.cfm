<cfoutput>
	<div class="before-after">
		<div class="heading-blue">
			<cfif locationSilo neq "">
				<a href="/pictures#locationSilo#" style="text-decoration:none;"><h2>Before <span>&amp;</span> After <strong>Pictures</strong></h2></a>
			<cfelse>
				<a href="/pictures" style="text-decoration:none;"><h2>Before <span>&amp;</span> After <strong>Pictures</strong></h2></a>
			</cfif>
		</div>
		<div class="box">
			<!-- gallery -->
			<div class="gallery">
				<div class="column-height">
					<div class="hold">
						<ul><cfset clickTrackSection = "GalleryCarousel">
							<cfsavecontent variable="paramKeyValues">
								<cfloop collection="#params#" item="pC">
									<cfif isnumeric(params[pC])>
										#pC#:#val(params[pC])#;
									</cfif>
								</cfloop>
							</cfsavecontent>

							<cfloop query="topPictures">
								<cfsavecontent variable="clickTrackKeyValues">
									accountDoctorId:#topPictures.accountdoctorid#;
									position:#topPictures.currentRow#;
									practiceRank:#topPictures.PracticeRank#;
									zoneId:#topPictures.zoneId#;
									zoneStateId:#topPictures.zoneStateId#;
									galleryCaseAngleId:#galleryCaseAngleId#;
									#paramKeyValues#
								</cfsavecontent>

								<cfset fullName = "#topPictures.firstname# #Iif(topPictures.middlename neq '',DE(topPictures.middlename&' '),DE('')) & topPictures.lastname#">
								<cfif LCase(topPictures.title) eq "dr" or LCase(topPictures.title) eq "dr.">
									<cfset fullName = "Dr. #fullName#">
								<cfelseif topPictures.title neq "">
									<cfset fullName &= ", #topPictures.title#">
								</cfif>
								<li>
									<div class="images">
										<a	clickTrackSection	= "#clickTrackSection#"
											clickTrackLabel		= "Image"
											clickTrackKeyValues	= "#clickTrackKeyValues#"
											href="/pictures/#topPictures.siloName#-c#topPictures.galleryCaseId#"><img src="/pictures/gallery/#topPictures.siloName#-before-thumb-#galleryCaseId#-#galleryCaseAngleId#.jpg" width="133" height="107" alt="#topPictures.name# Before Picture" />
										<img src="/pictures/gallery/#topPictures.siloName#-after-thumb-#galleryCaseId#-#galleryCaseAngleId#.jpg" width="122" height="107" alt="#topPictures.name# After Picture" /></a>
										<span class="before">before</span>
										<span class="after">after</span>
									</div>
									<div class="description">
										<h4><a	clickTrackSection	= "#clickTrackSection#"
												clickTrackLabel		= "Description"
												clickTrackKeyValues	= "#clickTrackKeyValues#"
												href="/#topPictures.doctorSiloName#">#topPictures.name#</a></h4>
										<p>performed by <a	clickTrackSection	= "#clickTrackSection#"
															clickTrackLabel		= "PerformedBy"
															clickTrackKeyValues	= "#clickTrackKeyValues#"
															href="/#topPictures.doctorSiloName#">#fullName#</a></p>
										<strong class="more">#linkTo(	clickTrackSection	= "#clickTrackSection#",
																		clickTrackLabel		= "ReadMore",
																		clickTrackKeyValues	= "#clickTrackKeyValues#",
																		href="/pictures/#topPictures.siloName#-c#topPictures.galleryCaseId#",
																		text="READ MORE")#</strong>
									</div>
								</li>
							</cfloop>
						</ul>
					</div>
				</div>
				<div class="foot">
					<ul class="switcher">
						<li class="active"><a href="##"><span>1</span></a></li>
						<li><a href="##"><span>2</span></a></li>
						<li><a href="##"><span>3</span></a></li>
						<li><a href="##"><span>4</span></a></li>
					</ul>
					<cfif locationSilo neq "">
						<a href="/pictures#locationSilo#">view all galleries</a>
					</cfif>
				</div>
			</div>
		</div>
	</div>
</cfoutput>