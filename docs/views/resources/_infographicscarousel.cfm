<cfif infoGraphics.recordCount>
	<cfoutput>
		<cfset clickTrackSection = "InfoGraphicCarousel">
		<cfsavecontent variable="paramKeyValues">
			<cfloop collection="#params#" item="pC">
				<cfif isnumeric(params[pC])>
					#pC#:#val(params[pC])#;
				</cfif>
			</cfloop>
		</cfsavecontent>
		<cfsavecontent variable="clickTrackKeyValues">
			#paramKeyValues#
		</cfsavecontent>

		<!-- sidebox -->
		<div class="sidebox">
			<div class="frame baap">
				#linkTo(	clickTrackSection	= "#clickTrackSection#",
							clickTrackLabel		= "Header",
							clickTrackKeyValues	= "#clickTrackKeyValues#",
				 			controller="article", action="locateadoccom-s-top-infographics",
				 			text="<h4>Popular <strong>InfoGraphics</strong></h4>",
				 			style="text-decoration: none;")#
				<div class="gallery">
					<div class="holder">
						<ul style="height: 274px!important;">
							<cfloop query="infoGraphics">
								<li>
									<div class="before-after">
										<div class="images" style="height: 100%!important; background: none!important;">
											<a	clickTrackSection	= "#clickTrackSection#"
												clickTrackLabel		= "Image"
												clickTrackKeyValues	= "#clickTrackKeyValues#"
												href="/article/#infoGraphics.siloName#">
											<cfset altText = "#infoGraphics.header# - LocateADoc.com">
											<img style="max-width: 200px" src="#infoGraphics.carouselImage#" <!--- width="188" ---> height="188" alt="#altText#" title="#altText#" />
											</a>
										</div>
										<div class="description">
											<h4>#infoGraphics.header#</h4>
											 #linkTo(	clickTrackSection	= "#clickTrackSection#",
														clickTrackLabel		= "View",
														clickTrackKeyValues	= "#clickTrackKeyValues#",
											 			href="/article/#infoGraphics.siloName#",
											 			text="view details")#
										</div>
									</div>
								</li>
							</cfloop>
						</ul>
					</div>
					<div class="foot">
						<cfif infoGraphics.recordcount gt 1>
							<a class="link-next" href="##">Next</a>
							<ul class="switcher">
								<li class="active"><a href="##"><span>1</span></a></li>
								<li><a href="##"><span>2</span></a></li>
								<li><a href="##"><span>3</span></a></li>
								<li><a href="##"><span>4</span></a></li>
							</ul>
							<a class="link-prev" href="##">Previous</a>
						</cfif>
						 #linkTo(controller="article", action="locateadoccom-s-top-infographics", text="view all infographics", class="link")#
					</div>
				</div>
			</div>
		</div>
	</cfoutput>
</cfif>