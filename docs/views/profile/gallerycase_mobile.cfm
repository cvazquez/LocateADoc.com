<cfoutput>
	#javascriptIncludeTag(sources="pictures/case",head=true)#
	<script>
		var angle_descriptions = {}
		<cfloop from="1" to="#arrayLen(galleryCase.galleryCaseAngles)#" index="i">
			angle_descriptions[#galleryCase.galleryCaseAngles[i].id#] = "#JSStringFormat(galleryCase.galleryCaseAngles[i].description)#"
		</cfloop>
		initSlideShow()
	</script>
	<!--- <!-- container inner-container -->
	<div class="container inner-container">
		<!-- inner-holder -->
		<div class="inner-holder">
			<!-- options -->
			<div class="options">
				<ul>
					<li class="email-link"><a href="##">Email</a></li>
					<li class="print-link"><a href="##">Print</a></li>
					<li class="share-link"><a href="##">Share</a></li>
				</ul>
			</div> --->
			<!-- content-frame -->
			<div class="content-frame">
				<!-- content -->
				<div id="content tab">
					<!-- resources-box search-term -->
					<div class="resources-box search-term">
						<!-- col2 -->
						<div class="col2">
							<div class="title">
								<div>
									<h2>#procedures.name#</h2>
									<p>#galleryCase.description#</p>
								</div>
							</div>
							<div class="row">
								<a href="go-back" class="link-back">BACK TO RESULTS</a>
								<a href="contact-doctor" class="btn-contact">CONTACT DOCTOR</a>
							</div>
						</div>
						<div class="save-search">
							<h3>Patient Details</h3>
							<strong>Sex: </strong>
							<span>#galleryCase.galleryGender.name#</span><br>
							<cfif val(galleryCase.age)>
								<strong>Age: </strong>
								<span>#galleryCase.age# years old</span><br>
							</cfif>
							<cfif val(galleryCase.height)>
								<strong>Height: </strong>
								<span>#fix(galleryCase.height/12)#' #(galleryCase.height mod 12)#"</span><br>
							</cfif>
							<cfif val(galleryCase.weight)>
								<strong>Weight: </strong>
								<span>#galleryCase.weight# lbs</span><br>
							</cfif>
						</div>
					</div>
					<!-- holder -->
					<div class="holder">
						<!-- aside1 -->
						<div class="aside1">
							<!-- pictures-box -->
							<div class="pictures-box">
								<h2>Before and After Pictures</h2>
								<div class="gallery">
									<div class="images">
										<ul class="fade-gal">
											<cfloop from="1" to="#arrayLen(gallerycase.galleryCaseAngles)#" index="i">
												<li>
													<img class="img-l" alt="Before and After #procedures.name#" src="/pictures/gallery/#procedures.siloname#-before-regular-#galleryCase.Id#-#gallerycase.galleryCaseAngles[i].id#.jpg" />
													<img class="img-r" alt="Before and After #procedures.name#" src="/pictures/gallery/#procedures.siloname#-after-regular-#galleryCase.Id#-#gallerycase.galleryCaseAngles[i].id#.jpg" />
													<span class="before">before</span>
													<span class="after">after</span>
												</li>
											</cfloop>
										</ul>
									</div>
									<div class="col">
										<div class="link"><a href="##">Other Angles</a></div>
										<div class="hold">
											<ul>
												<cfloop from="1" to="#arrayLen(galleryCase.galleryCaseAngles)#" index="i">
													<li>
														<a angleid="#galleryCase.galleryCaseAngles[i].id#" href="##">
															<img src="/pictures/gallery/#procedures.siloname#-after-thumb-#galleryCase.Id#-#gallerycase.galleryCaseAngles[i].id#.jpg" alt="image description" />
														</a>
													</li>
												</cfloop>
											</ul>
										</div>
									</div>
								</div>
								<!-- text-box -->
								<div id="angledescription" class="text-box">
									#galleryCase.galleryCaseAngles[1].description#
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		<!--- </div>
	</div> --->
</cfoutput>