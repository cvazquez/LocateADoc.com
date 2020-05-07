<cfif latestPictures.recordCount>
	<cfparam default="FALSE" name="displayCasesDoctorName" type="boolean">
	<cfoutput>
		<cfset clickTrackSection = "GalleryCarousel">
		<cfsavecontent variable="paramKeyValues">
			<cfloop collection="#params#" item="pC">
				<cfif isnumeric(params[pC])>
					#pC#:#val(params[pC])#;
				</cfif>
			</cfloop>
		</cfsavecontent>
		<!-- sidebox -->
		<div class="sidebox beforeAndAfterSideBox">
			<div class="frame baap">
				#linkTo(	clickTrackSection	= "#clickTrackSection#",
							clickTrackLabel		= "Header",
				 			controller="pictures",
				 			text="<h4>Before and After <strong>Pictures</strong></h4>",
				 			style="text-decoration: none;")#
				<cfif params.controller eq "profile">
					<p>Performed by #doctor.fullNameWithTitle#</p>
				</cfif>
				<div class="gallery">
					<div class="holder">
						<ul>
							<cfloop query="latestPictures">
								<cfset thisURL = "">
								<cfif server.thisServer EQ "dev">
									<cfif NOT FileExists("/export/home/dev3.locateadoc.com/docs/images/gallery/thumb/#latestPictures.galleryCaseId#-#latestPictures.galleryCaseAngleId#-before.jpg")>
										<cfset thisURL = "http://www.locateadoc.com">
									</cfif>
								</cfif>

								<cfsavecontent variable="clickTrackKeyValues">
									position:#latestPictures.currentRow#;
									galleryCaseAngleId:#galleryCaseAngleId#;
									#paramKeyValues#
								</cfsavecontent>

								<li>
									<div class="before-after">
										<div class="images">
											<cfif params.controller eq "profile">
												<a	clickTrackSection	= "#clickTrackSection#"
													clickTrackLabel		= "Image"
													clickTrackKeyValues	= "#clickTrackKeyValues#"
													href="/#doctor.siloName#/pictures/#latestPictures.siloName#-c#latestPictures.galleryCaseId#" class="casedetails" caseid="#latestPictures.galleryCaseId#">
											<cfelse>
												<a	clickTrackSection	= "#clickTrackSection#"
													clickTrackLabel		= "Image"
													clickTrackKeyValues	= "#clickTrackKeyValues#"
													href="/pictures/#latestPictures.siloName#-c#latestPictures.galleryCaseId#">
											</cfif>
											<!--- #latestPictures.name# Before Picture --->
											<cfset altBeforeText = "#latestPictures.name# Before Picture - #latestPictures.firstname# #latestPictures.middlename# #latestPictures.lastname# - LocateADoc.com">
											<img src="#thisURL#/pictures/gallery/#latestPictures.siloName#-before-thumb-#latestPictures.galleryCaseId#-#latestPictures.galleryCaseAngleId#.jpg" width="98" height="79" alt="#altBeforeText#" title="#altBeforeText#" />
											<cfset altAfterText = "#latestPictures.name# After Picture - #latestPictures.firstname# #latestPictures.middlename# #latestPictures.lastname# - LocateADoc.com">
											<img src="#thisURL#/pictures/gallery/#latestPictures.siloName#-after-thumb-#latestPictures.galleryCaseId#-#latestPictures.galleryCaseAngleId#.jpg" width="90" height="79" alt="#altAfterText#" title="#altAfterText#" />
											</a>
											<span class="before">before</span>
											<span class="after">after</span>
										</div>
										<div class="description">
											<h3>#latestPictures.name#</h3>
											<cfif displayCasesDoctorName>
												#latestPictures.firstName# #latestPictures.lastName#<cfif latestPictures.title NEQ "">, #latestPictures.title#</cfif><br />
												<cfif isDefined("latestPictures.city") AND isDefined("latestPictures.state")>#latestPictures.city#, #latestPictures.state#<br /></cfif>
											</cfif>

											<cfif params.controller eq "profile">
											 <a	clickTrackSection	= "#clickTrackSection#"
												clickTrackLabel		= "View"
												clickTrackKeyValues	= "#clickTrackKeyValues#"
											 	href="/#doctor.siloName#/pictures/#latestPictures.siloName#-c#latestPictures.galleryCaseId#">view details</a>
											<cfelse>
											 #linkTo(	clickTrackSection	= "#clickTrackSection#",
														clickTrackLabel		= "View",
														clickTrackKeyValues	= "#clickTrackKeyValues#",
											 			href="/pictures/#latestPictures.siloName#-c#latestPictures.galleryCaseId#",
											 			class="view_details",
											 			text="view details")#
											</cfif>
										</div>
									</div>
								</li>
							</cfloop>
						</ul>
					</div>
					<div class="foot">
						<cfif latestPictures.recordcount gt 1>
							<a class="link-next" href="##">Next</a>
							<ul class="switcher">
								<li class="active"><a href="##"><span>1</span></a></li>
								<li><a href="##"><span>2</span></a></li>
								<li><a href="##"><span>3</span></a></li>
								<li><a href="##"><span>4</span></a></li>
							</ul>
							<a class="link-prev" href="##">Previous</a>
						</cfif>
						<cfif params.controller eq "profile">
							 #linkTo(href="/#doctor.siloName#/pictures", text="view all galleries", class="link")#
						<cfelseif IsDefined("ProcedureInfo.name") AND IsDefined("ProcedureInfo.siloName")>
							#linkTo(controller="pictures", action=ProcedureInfo.siloName, text="View All #ProcedureInfo.name# Galleries", class="link")#
						<cfelse>
							 #linkTo(controller="pictures", action="search", text="view all galleries", class="link")#
						</cfif>
					</div>
				</div>
			</div>
		</div>
		<!--- <cfif params.controller eq "profile">#includePartial("gallerycasebox")#</cfif> --->
	</cfoutput>
</cfif>