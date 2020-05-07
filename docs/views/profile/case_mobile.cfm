<cfoutput>
	#javascriptIncludeTag(
		sources	= "pictures/case",
		head	= true)#
	#styleSheetLinkTag(source="thickbox")#
	#styleSheetLinkTag(source="profile/case")#
	<script>
		var angle_descriptions = {}
		<cfloop query="galleryCase">
			angle_descriptions[#galleryCase.galleryCaseAngleid#] = "#JSStringFormat(galleryCase.galleryCaseAngledescription)#"
		</cfloop>
	</script>
	<!-- main -->
	<div id="main" style="padding:0 !important;">

		<!-- container inner-container -->
		<div class="inner-container" style="margin:0 !important; background:none !important;">
			<!-- inner-holder -->
			<div class="inner-holder" style="width:934px; margin-left:-3px !important; border-top:2px solid ##C7D9D9">
				<!-- content-frame -->
				<div class="content-frame">
					<!-- content -->
					<div id="content">
						<!-- resources-box search-term -->
						<div class="resources-box search-term" style="margin-top:0px !important;">
							<!-- col2 -->
							<div class="col2">
								<div class="title" style="border:0px;">
									<div>
										<h2>#procedures.name#</h2>
										<cfif procedures.recordcount gt 1>
											<h3>Additional procedures:&nbsp;&nbsp;&nbsp;</h3>
											<cfloop query="procedures" startrow="2">
												#name#<cfif currentrow lt recordcount>, </cfif>
											</cfloop><br>
										</cfif>
										<cfset filteredDescription = REReplace(galleryCase.description,"<[^>]*[pP]>",Chr(13) & Chr(10),"all")>
										<cfset filteredDescription = REReplace(filteredDescription,"[\r\n]+\s*","</p><p>","all")>
										<cfset filterThreshold = Find("</p>",filteredDescription,200) + 3>
										<cfif filterThreshold gt 3 and Len(filteredDescription) - filterThreshold gt 100>
											<div class="description-field">
												<p>#Left(filteredDescription,filterThreshold)#
											</div>
											<div id="caseDescription" class="description-field" style="display:none;">
												#Right(filteredDescription,Len(filteredDescription) - filterThreshold)#</p>
											</div>
											<p class="case-show-more"><a class="show-more-desc" href="##caseDescription">Show more</a></p>
										<cfelse>
											<div class="description-field">
												<p>#filteredDescription#</p>
											</div>
										</cfif>
									</div>
								</div>
								<div class="row">
									<a href="/#doctor.siloName#/pictures">BACK TO GALLERY</a>
								</div>
							</div>
							<div class="save-search" style="background:none;">
								<h3>Patient Details</h3>
								<strong>Sex: </strong>
								<span>#galleryCase.galleryGenderName#</span><br>
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
								<cfif skinTone neq "">
									<strong>Skin Tone: </strong>
									<span>#skinTone#</span><br>
								</cfif>
								<cfif galleryCase.bodyPartList neq "">
									<strong>Procedure performed on: </strong>
									<span>#Replace(galleryCase.bodyPartList,",",", ","all")#</span><br>
								</cfif>
							</div>
						</div>
						<!-- holder -->
						<div class="holder">
							<!-- aside1 -->
							<div class="aside1">
								<!-- pictures-box -->
								<div class="pictures-box print-area">
									<h2 style="width:400px;padding-right:25px;float:left;">Before and After Pictures</h2>
									<span style="display:inline-block;margin-top:4px;" class="st_plusone_hcount" st_title="#ShareText#"></span>
									<div class="gallery">
										<div class="images">
											<ul class="fade-gal">

												<cfloop query="galleryCase">
													<cfset thisURL = "">
													<cfif server.thisServer EQ "dev">
														<cfif FileExists("/export/home/dev3.locateadoc.com/docs/images/gallery/regular/#params.caseid#-#gallerycase.galleryCaseAngleId#-before.jpg")>
															<cfset thisURL = "http://dev3.locateadoc.com">
														<cfelse>
															<cfset thisURL = "http://www.locateadoc.com">
														</cfif>
													</cfif>
													<li>
														<a href="#thisURL#/pictures/gallery/#procedures.siloName#-before-fullsize-#params.caseid#-#gallerycase.galleryCaseAngleId#.jpg" class="thickbox baagbox" baag="before">
															<cfset thisStyle = "">

															<cfif gallerycase.beforeTopPixel GT 0 OR gallerycase.beforeLeftCoords GT 0>
																<cfset thisStyle = "">
																<cfif gallerycase.beforeTopPixel GT 0>
																	<cfset thisStyle = "margin-top: #gallerycase.beforeTopPixel#px;">
																</cfif>
																<cfif gallerycase.beforeLeftCoords GT 0>
																	<cfset thisStyle = "#thisStyle# margin-left: #gallerycase.beforeLeftCoords#px;">
																</cfif>
															</cfif>
															<img class="img-l"
																alt="#procedures.name# Before Image - #doctors.fullNameWithTitle# - LocateADoc.com"
																src="#thisURL#/pictures/gallery/#procedures.siloName#-before-regular-#params.caseid#-#gallerycase.galleryCaseAngleId#.jpg"
																title="View fullsize original"
																style="#thisStyle#"/>
															#imageTag(source="magnify.png",class="beforeM",title="View fullsize original")#
														</a>
														<a href="#thisURL#/pictures/gallery/#procedures.siloName#-after-fullsize-#params.caseid#-#gallerycase.galleryCaseAngleId#.jpg" class="thickbox baagbox" baag="after">
															<cfset thisStyle = "">

															<cfif gallerycase.afterTopPixel GT 0 OR gallerycase.afterLeftCoords GT 0>
																<cfset thisStyle = "">
																<cfif gallerycase.afterTopPixel GT 0>
																	<cfset thisStyle = "margin-top: #gallerycase.afterTopPixel#px;">
																</cfif>
																<cfif gallerycase.afterLeftCoords GT 0>
																	<cfset thisStyle = "#thisStyle# margin-right: #gallerycase.afterLeftCoords#px;">
																</cfif>
															</cfif>
															<img class="img-r"
																alt="#procedures.name# After Image - #doctors.fullNameWithTitle# - LocateADoc.com"
																src="#thisURL#/pictures/gallery/#procedures.siloName#-after-regular-#params.caseid#-#gallerycase.galleryCaseAngleId#.jpg"
																title="View fullsize original"
																style="#thisStyle#"/>
															#imageTag(source="magnify.png",class="afterM",title="View fullsize original")#
														</a>
														<span class="before">before</span>
														<span class="after">after</span>
													</li>
												</cfloop>
											</ul>
										</div>
										<cfif galleryCase.recordCount GT 1>
											<div class="col">
												<div class="link"><a href="##">Other Angles</a></div>
												<div class="hold">
													<ul>
														<cfloop query="galleryCase">
															<li>
																<a angleid="#galleryCase.galleryCaseAngleId#" href="##">
																	<img src="#thisURL#/pictures/gallery/#procedures.siloName#-after-thumb-#params.caseid#-#gallerycase.galleryCaseAngleId#.jpg" alt="image description" />
																</a>
															</li>
														</cfloop>
													</ul>
												</div>
												<cfif galleryCase.recordcount gt 4>
													<div class="angle-scroll-box">
														<a class="link-prev" href="##">Previous</a>
														<a class="link-next" href="##">Next</a>
													</div>
												</cfif>
											</div>
										</cfif>
									</div>
									<!-- text-box -->
									<div id="angledescription" class="text-box">
										#galleryCase.galleryCaseAngleDescription#
									</div>
								</div>

								<div class="widget" style="margin-bottom:20px;">
									<div class="title" style="padding-left:0px;">
										<table style="width:491px;"><tr>
											<td style="text-align:left; width:160px;">
												<cfif previousCase gt 0>
													<a class="prev-case" href="/#doctor.siloName#/pictures/#ListFirst(otherCases.results.procedureSiloNames[previousCase])#-c#otherCases.results.galleryCaseId[previousCase]#">PREVIOUS CASE</a>
												</cfif>
											</td>
											<td style="text-align:center;">
												#LinkTo(href="/#doctor.siloName#/contact",class="btn-contact",text="CONTACT DOCTOR")#
											</td>
											<td style="text-align:right; width:160px;">
												<cfif nextCase gt 0>
													<a class="next-case" href="/#doctor.siloName#/pictures/#ListFirst(otherCases.results.procedureSiloNames[nextCase])#-c#otherCases.results.galleryCaseId[nextCase]#">NEXT CASE</a>
												</cfif>
											</td>
										</tr></table>
									</div>
								</div>

								<cfif topGalleryProcedures.recordcount>
									<!-- widget -->
									<div class="widget">
										<div class="title">
											<h2>Additional Before and After Photos</h2>
										</div>
										<ul class="additional-procedures">
											<cfloop query="topGalleryProcedures">
											<li>
												<a href="/#doctor.siloname#/pictures/#topGalleryProcedures.siloName#">#topGalleryProcedures.name#</a>
											</li>
											</cfloop>
										</ul>
									</div>
								</cfif>

							</div>
							<div class="sidebox-column">
							<cfoutput>
								#includePartial("/shared/minileadsidebox")#
								<div style="width:293px;">
									#includePartial("/shared/sharesidebox")#
								</div>
								#includePartial("/shared/practicesnapshotsidebox")#
								<!--- #includePartial("practiceTour")#
								#includePartial("/shared/paymentoptionssidebox")# --->
							</cfoutput>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>