<cfoutput>
	<cfif NOT isMobile>
		#styleSheetLinkTag(sources="pictures/case,thickbox")#
			#javascriptIncludeTag(
				sources="
					pictures/case,
					thickbox",
				head=true)#
		<script>
			var angle_descriptions = {}
			<cfloop query="galleryCase">
				angle_descriptions[#galleryCase.galleryCaseAngleid#] = "#JSStringFormat(galleryCase.galleryCaseAngledescription)#"
			</cfloop>
		</script>
	</cfif>

	<!-- main -->
	<div id="main" class="GalleryCase">

		<cfif NOT isMobile>
			#includePartial("/shared/breadcrumbs")#
		</cfif>

		<cfif displayAd>
			#includePartial(partial	= "/shared/ad",
							size	= "generic728x90top#(explicitAd IS TRUE ? "Explicit" : "")#")#
		</cfif>

		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder">
				#includePartial("/shared/pagetools")#
				<!-- content-frame -->
				<div class="content-frame">
					<!-- content -->
					<div id="content">
						<!-- resources-box search-term -->
						<div class="resources-box search-term">
							<!--- <table><tbody><tr>
							<!-- col2 -->
							<td class="col2">
								<div class="title">
									<div>
										<h1 class="page-title">#pageH1#</h1>
										<cfif procedures.recordcount gt 1>
											<h3>Additional procedures:&nbsp;&nbsp;&nbsp;</h3>
											<cfloop query="procedures" startrow="2">
												#name#<cfif currentrow lt recordcount>, </cfif>
											</cfloop><br>
										</cfif>
										<cfif val(len(galleryCase.description))>
											<cfset filteredDescription = REReplace(galleryCase.description,"<[^>]*[pP]>",Chr(13) & Chr(10),"all")>
											<cfset filteredDescription = REReplace(filteredDescription,"[\r\n]+\s*","</p><p>","all")>
											<cfset filterThreshold = Find("</p>",filteredDescription,200) + 3>
											<cfif filterThreshold gt 3 and Len(filteredDescription) - filterThreshold gt 100>
												<div class="description-field">
													<p>#Left(filteredDescription,filterThreshold)#
												</div>
												<div id="caseDescription" class="description-field"<!---  style="display:none;" --->>
													#Right(filteredDescription,Len(filteredDescription) - filterThreshold)#</p>
												</div>
												<p class="case-show-more"><a class="show-more-desc" href="##caseDescription">Show more</a></p>
											<cfelse>
												<div class="description-field">
													<p>#filteredDescription#</p>
												</div>
											</cfif>
											<!--- <p>
												<br>
												#galleryCase.description#
											</p> --->
										</cfif>
									</div>
									<div class="row">
										<cfif Client.lastGallerySearch neq "" AND isdefined("params.returnURL")>
											<a href="#params.returnURL#" class="link-back">BACK TO RESULTS</a>
										<cfelse>
											<a href="##" class="link-back">BACK TO RESULTS</a>
										</cfif>
									</div>
								</div>
								<div class="row">
									<!--- <table style="width:400px; margin: 6px 0 0; display:inline-block; float:left;"><tr>
											<td style="text-align:left; width:200px; padding:0;">
												<cfif previousCase gt 0>
													<a class="prev-case" href="/pictures/#ListFirst(otherCases.results.procedureSiloNames[previousCase])#-c#otherCases.results.galleryCaseId[previousCase]#">PREVIOUS CASE</a>
												</cfif>
											</td>
											<td style="text-align:right; width:200px; padding:0;">
												<cfif nextCase gt 0>
													<a class="next-case" href="/pictures/#ListFirst(otherCases.results.procedureSiloNames[nextCase])#-c#otherCases.results.galleryCaseId[nextCase]#">NEXT CASE</a>
												</cfif>
											</td>
									</tr></table> --->
									<div class="prevnextcase">
										<div class="PreviousCase">
											<cfif previousCase gt 0>
												<a class="prev-case" href="/#doctor.siloName#/pictures/#ListFirst(otherCases.results.procedureSiloNames[previousCase])#-c#otherCases.results.galleryCaseId[previousCase]#">PREVIOUS CASE</a>
											</cfif>
										</div>
										<!--- <div class="ContactDoctor">
											#LinkTo(href="/#doctor.siloName#/contact",class="btn-contact",text="CONTACT DOCTOR")#
										</div> --->
										<div class="NextCase">
											<cfif nextCase gt 0>
												<a class="next-case" href="/#doctor.siloName#/pictures/#ListFirst(otherCases.results.procedureSiloNames[nextCase])#-c#otherCases.results.galleryCaseId[nextCase]#">NEXT CASE</a>
											</cfif>
										</div>
									</div>

									<cfif isExpiredAd>
										#includePartial(partial="/shared/sitewideminileadsidebox", isPopup=true)#
									<cfelse>
										#LinkTo(href="/#doctors.doctorSiloName#/contact",class="btn-contact",text="CONTACT DOCTOR")#
									</cfif>
								</div>
							</td>
							<td class="save-search">
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
							</td>
							</tr></tbody></table> --->

							<div id="GalleryCaseHeader">

								<div class="col2">
									<div class="title">
										<div>
											<h1 class="page-title">#pageH1#</h1>
											<cfif procedures.recordcount gt 1>
												<h3>Additional procedures:&nbsp;&nbsp;&nbsp;</h3>
												<cfloop query="procedures" startrow="2">
													#name#<cfif currentrow lt recordcount>, </cfif>
												</cfloop><br>
											</cfif>
											<cfif val(len(galleryCase.description))>
												<cfset filteredDescription = REReplace(galleryCase.description,"<[^>]*[pP]>",Chr(13) & Chr(10),"all")>
												<cfset filteredDescription = REReplace(filteredDescription,"[\r\n]+\s*","</p><p>","all")>
												<cfset filterThreshold = Find("</p>",filteredDescription,200) + 3>
												<cfif filterThreshold gt 3 and Len(filteredDescription) - filterThreshold gt 100>
													<div class="description-field">
														<p>#Left(filteredDescription,filterThreshold)#
													</div>
													<div id="caseDescription" class="description-field"<!---  style="display:none;" --->>
														#Right(filteredDescription,Len(filteredDescription) - filterThreshold)#</p>
													</div>
													<p class="case-show-more"><a class="show-more-desc" href="##caseDescription">Show more</a></p>
												<cfelse>
													<div class="description-field">
														<p>#filteredDescription#</p>
													</div>
												</cfif>
												<!--- <p>
													<br>
													#galleryCase.description#
												</p> --->
											</cfif>
										</div>
										<div class="row backtoresults">
											<cfif Client.lastGallerySearch neq "" AND isdefined("params.returnURL")>
												<a href="#params.returnURL#" class="link-back">BACK TO RESULTS</a>
											<cfelse>
												<a href="##" class="link-back">BACK TO RESULTS</a>
											</cfif>
										</div>
									</div>
									<div class="row">
										<!--- <table style="width:400px; margin: 6px 0 0; display:inline-block; float:left;"><tr>
												<td style="text-align:left; width:200px; padding:0;">
													<cfif previousCase gt 0>
														<a class="prev-case" href="/pictures/#ListFirst(otherCases.results.procedureSiloNames[previousCase])#-c#otherCases.results.galleryCaseId[previousCase]#">PREVIOUS CASE</a>
													</cfif>
												</td>
												<td style="text-align:right; width:200px; padding:0;">
													<cfif nextCase gt 0>
														<a class="next-case" href="/pictures/#ListFirst(otherCases.results.procedureSiloNames[nextCase])#-c#otherCases.results.galleryCaseId[nextCase]#">NEXT CASE</a>
													</cfif>
												</td>
										</tr></table> --->
										<div class="prevnextcase">
											<div class="PreviousCase">
												<cfif previousCase gt 0>
													<a class="prev-case" href="/pictures/#ListFirst(otherCases.results.procedureSiloNames[previousCase])#-c#otherCases.results.galleryCaseId[previousCase]#">PREVIOUS CASE</a>
												</cfif>
											</div>
											<!--- <div class="ContactDoctor">
												#LinkTo(href="/#doctor.siloName#/contact",class="btn-contact",text="CONTACT DOCTOR")#
											</div> --->
											<div class="NextCase">
												<cfif nextCase gt 0>
													<a class="next-case" href="/pictures/#ListFirst(otherCases.results.procedureSiloNames[nextCase])#-c#otherCases.results.galleryCaseId[nextCase]#">NEXT CASE</a>
												</cfif>
											</div>
										</div>

										<cfif isExpiredAd>
											#includePartial(partial="/shared/sitewideminileadsidebox", isPopup=true)#
										<cfelse>
											#LinkTo(href="/#doctors.doctorSiloName#/contact",class="btn-contact",text="CONTACT DOCTOR")#
										</cfif>
									</div>
								</div> <!--- col2 --->
								<div class="save-search">
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
								</div> <!--- save-search --->
							</div> <!--- GalleryCaseHeader --->

						</div>
						<!-- holder -->
						<div class="holder">
							<!-- aside1 -->
							<div class="aside1">
								<!-- pictures-box -->
								<div class="pictures-box print-area">
									<h2 <!--- style="width:400px;padding-right:25px;float:left;" --->>Before and After Pictures</h2>
									<span <!--- style="display:inline-block;margin-top:4px;"  --->class="st_plusone_hcount" st_title="#ShareText#"></span>
									<cfif client.debug><a href="/pictures/BAAGimages/#params.key#" target="_new" style="display:inline-block;">fix baag images</a></cfif>
									<div class="gallery">
										<div class="images">
											<ul class="fade-gal">

												<cfloop query="galleryCase">
													<cfset thisURL = "">
													<cfif server.thisServer EQ "dev">
														<cfif FileExists("/export/home/dev3.locateadoc.com/docs/images/gallery/regular/#params.key#-#gallerycase.galleryCaseAngleId#-before.jpg")>
															<cfset thisURL = "http://dev3.locateadoc.com">
														<cfelse>
															<cfset thisURL = "http://www.locateadoc.com">
														</cfif>
													</cfif>
													<li><a href="#thisURL#/pictures/gallery/#procedures.siloName#-before-fullsize-#params.key#-#gallerycase.galleryCaseAngleId#.jpg" class="thickbox baagbox" baag="before">


															<!--- <cfset thisStyle = "width:238px; height:273px;"> --->
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

															<!--- [Procedure Name] [Before|After] Image - DoctorFirstname [MiddleInitial] DoctorLastName, Designation(s) - LocateADoc.com --->
															<cfset altBeforeText = "#procedures.name# Before Image - #doctor.fullNameWithTitle# - LocateADoc.com">
															<img <!--- onload="positionImage('img.img-l')" --->
																class="img-l"
																alt="#altBeforeText#"
																src="#thisURL#/pictures/gallery/#procedures.siloName#-before-regular-#params.key#-#gallerycase.galleryCaseAngleId#.jpg"
																title="#altBeforeText#"
																style="#thisStyle#"
																/>
															#imageTag(source="magnify.png",class="beforeM",title="View fullsize original")#
														</a>
														<a href="#thisURL#/pictures/gallery/#procedures.siloName#-after-fullsize-#params.key#-#gallerycase.galleryCaseAngleId#.jpg" class="thickbox baagbox" baag="after">
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

															<cfset altAfterText = "#procedures.name# After Image - #doctor.fullNameWithTitle# - LocateADoc.com">
															<img <!--- onload="positionImage('img.img-r')" --->
																class="img-r"
																alt="#altAfterText#"
																src="#thisURL#/pictures/gallery/#procedures.siloName#-after-regular-#params.key#-#gallerycase.galleryCaseAngleId#.jpg"
																title="#altAfterText#"
																style="#thisStyle#"
																 />
															#imageTag(source="magnify.png",class="afterM",title="View fullsize original")#
														</a>
														<span class="before">before</span>
														<span class="after">after</span>
													</li>
												</cfloop>
											</ul>
										</div>
										<div class="col">
											<cfif galleryCase.recordCount GT 1>
												<div class="link"><a href="##">Other Angles</a></div>
												<div class="hold">
													<ul>
														<cfloop query="galleryCase">
															<li>
																<a angleid="#galleryCase.galleryCaseAngleId#" href="##">
																	<img src="#thisURL#/pictures/gallery/#procedures.siloName#-after-thumb-#params.key#-#gallerycase.galleryCaseAngleId#.jpg" alt="image description" />
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
											</cfif>
										</div>
										<h3 class="fullsizeimagetext">Click on an Image to View Full Size</h3>
										<cfif isExpiredAd>
											<p class="doctor-credit">Performed by #LinkTo(controller=doctor.doctorSiloName,text=doctor.fullNameWithTitle)#, #doctor.name#, #doctor.statename#</p>
										</cfif>
									</div>
									<!-- text-box -->
									<div id="angledescription" class="text-box">
										#galleryCase.galleryCaseAngleDescription#
									</div>
								</div>
								<div class="widget"<!---  style="margin-bottom:20px;" --->>
									<div class="title"<!---  style="padding-left:0px;" --->>
										<!--- <table style="width:491px;"><tr>
											<td style="text-align:left; width:160px;">
												<cfif previousCase gt 0>
													<a class="prev-case" href="/pictures/#ListFirst(otherCases.results.procedureSiloNames[previousCase])#-c#otherCases.results.galleryCaseId[previousCase]#">PREVIOUS CASE</a>
												</cfif>
											</td>
											<td style="text-align:center;">
												<cfif not isExpiredAd>
												#LinkTo(href="/#doctors.doctorSiloName#/contact",class="btn-contact",text="CONTACT DOCTOR")#
												</cfif>
											</td>
											<td style="text-align:right; width:160px;">
												<cfif nextCase gt 0>
													<a class="next-case" href="/pictures/#ListFirst(otherCases.results.procedureSiloNames[nextCase])#-c#otherCases.results.galleryCaseId[nextCase]#">NEXT CASE</a>
												</cfif>
											</td>
										</tr></table> --->
										<div class="prevnextcase">
											<div class="PreviousCase">
												<cfif previousCase gt 0>
													<a class="prev-case" href="/pictures/#ListFirst(otherCases.results.procedureSiloNames[previousCase])#-c#otherCases.results.galleryCaseId[previousCase]#">PREVIOUS CASE</a>
												</cfif>
											</div>
											<div class="ContactDoctor">
												<cfif not isExpiredAd>
												#LinkTo(href="/#doctors.doctorSiloName#/contact",class="btn-contact",text="CONTACT DOCTOR")#
												</cfif>
											</div>
											<div class="NextCase">
												<cfif nextCase gt 0>
													<a class="next-case" href="/pictures/#ListFirst(otherCases.results.procedureSiloNames[nextCase])#-c#otherCases.results.galleryCaseId[nextCase]#">NEXT CASE</a>
												</cfif>
											</div>
										</div>
									</div>
								</div>
								<cfif NOT isMobile AND (relatedGuides.recordcount or relatedArticles.recordcount)>
								<div class="case-related">
									<cfif relatedGuides.recordcount>
										<!-- widget -->
										<div class="widget">
											<div class="title">
												<h2>#procedures.name# Procedure Guide<cfif relatedGuides.recordcount gt 1>s</cfif> <span>(#linkTo(controller="resources",action="surgery",text="view&nbsp;all&nbsp;guides")#)</span></h2>
											</div>
											<div class="cont-list">
												<ul>
													<cfloop query="relatedGuides">
													<li>
														<div class="head">
															<!--- <cfset TopicList = ListAppend(relatedGuides.specialtyname,relatedGuides.procedurename)>
															<cfset TopicList = ListAppend(TopicList,relatedGuides.subprocedurename)>
															<cfif ListLen(topicList)>
																<strong>#ListGetAt(topicList,1)#</strong>
															</cfif> --->
															<div>
																<em class="date">#DateFormat(relatedGuides.createdAt,"mm.dd.yy")#</em>
																<h3>#LinkTo(controller=relatedGuides.procedureSiloName,text=relatedGuides.title)#</h3>
															</div>
														</div>
														<cfset filteredContent = REReplace(relatedGuides.content,"</?span[^>]*?>"," ","all")>
														<cfset filteredContent = Replace(filteredContent,"&nbsp;"," ","all")>
														<cfset filteredContent = REReplace(filteredContent,"<h[0-9][^>]*?>.+?</h[0-9]>","","all")>
														<cfset filteredContent = REReplace(filteredContent,"<img.+?>","","all")>
														<cfset filteredContent = REReplace(filteredContent,"<p[^>]*?>\s*?</p>","","all")>
														<p>
															<cfif Left(filteredContent,5) eq "<div>">
																#Left(filteredContent,Find("</div>",filteredContent,100)+6)#
															<cfelse>
																#Left(filteredContent,Find("</p>",filteredContent,100)+4)#
															</cfif>
															#LinkTo(controller=relatedGuides.procedureSiloName,text="read more")#
														</p>
													</li>
													</cfloop>
												</ul>
											</div>
										</div>
									</cfif>
									<cfif NOT isMobile AND relatedArticles.recordcount>
										<!-- widget -->
										<div class="widget">
											<div class="title">
												<h2>#procedures.name# Article<cfif relatedArticles.recordcount gt 1>s</cfif> <span>(#linkTo(controller="articles",action=procedures.siloName,text="view all articles")#)</span></h2>
											</div>
											<div class="cont-list">
												<ul>
													<cfloop query="relatedArticles">
													<li class="guide-preview">
														<div class="head">
															<!--- <cfset TopicList = ListAppend(relatedGuides.specialtyname,relatedGuides.procedurename)>
															<cfset TopicList = ListAppend(TopicList,relatedGuides.subprocedurename)>
															<cfif ListLen(topicList)>
																<strong>#ListGetAt(topicList,1)#</strong>
															</cfif> --->
															<div>
																<em class="date">#DateFormat(relatedArticles.createdAt,"mm.dd.yy")#</em>
																<h3>#LinkTo(controller="article", action=relatedArticles.siloName, text=relatedArticles.title)#</h3>
															</div>
														</div>
														<cfset filteredContent = relatedArticles.content>
														<cfset newImageTag = "">
														<cfset articleImages = REFind("<img.+?>",filteredContent,0,true)>
															<cfif articleImages.len[1] gt 0>
															<cfset imageTag = Mid(filteredContent,articleImages.pos[1],articleImages.len[1])>
															<cfset imageWidthLocation = REFind('width\s?(=|:)\s?"?[0-9]+("|px)?',imageTag,0,true)>
															<cfset imageHeightLocation = REFind('height\s?(=|:)\s?"?[0-9]+("|px)?',imageTag,0,true)>
															<cfif imageWidthLocation.pos[1] and imageHeightLocation.pos[1]>
																<cfset newImageTag = imageTag>
																<cfset imageWidth = val(REReplace(Mid(imageTag,imageWidthLocation.pos[1],imageWidthLocation.len[1]),"[^0-9]","","all"))>
																<cfset imageHeight = val(REReplace(Mid(imageTag,imageHeightLocation.pos[1],imageHeightLocation.len[1]),"[^0-9]","","all"))>
																<cfif imageWidth gt 100 and imageHeight gt 100>
																	<cfif imageWidth lt imageHeight>
																		<cfset newImageWidth = Ceiling(imageWidth/imageHeight * 100)>
																		<cfset newImageHeight = 100>
																	<cfelse>
																		<cfset newImageHeight = Ceiling(imageHeight/imageWidth * 100)>
																		<cfset newImageWidth = 100>
																	</cfif>
																	<cfif newImageWidth gt 20 and newImageHeight gt 20>
																		<cfset newImageTag = Replace(Replace(newImageTag,'"#imageHeight#"','"#newImageHeight#"',"all"),'"#imageWidth#"','"#newImageWidth#"',"all")>
																		<cfset newImageTag = Replace(Replace(newImageTag,'#imageHeight#px','#newImageHeight#px',"all"),'#imageWidth#px','#newImageWidth#px',"all")>
																		<cfset newImageTag = REReplace(newImageTag,"float:\s?right","float: left","all")>
																		<cfset newImageTag = REReplace(newImageTag,"border-?[^:]+:[^;]+;","","all")>
																	<cfelse>
																		<cfset newImageTag = "">
																	</cfif>
																	<!--- <cfset filteredContent = Replace(filteredContent,imageTag,"[!!temp!!]")> --->
																	<!--- Show only one image --->
																	<!--- <cfset filteredContent = Replace(filteredContent,"[!!temp!!]",newImageTag)> --->
																</cfif>
															</cfif>
														</cfif>
														<cfset filteredContent = REReplace(filteredContent,"<[^<]+?>","","all")>
														<cfset filteredContent = Replace(filteredContent,"&nbsp;"," ","all")>
														<cfset filteredContent = trim(filteredContent)>
														<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
														<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
														<cfif REFind("\r|\n",filteredContent)>
															<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
														</cfif>
														<p>
															#newImageTag & filteredContent#
															<!--- <cfif Left(filteredContent,5) eq "<div>">
																#Left(filteredContent,Find("</div>",filteredContent,100)+6)#
															<cfelse>
																#Left(filteredContent,Find("</p>",filteredContent,100)+4)#
															</cfif> --->
														</p>
														#LinkTo(controller="article", action=relatedArticles.siloName, text="read more")#
													</li>
													</cfloop>
												</ul>
											</div>
										</div>
									</cfif>
								</div>
								</cfif>
							</div>
							<!-- aside2 -->
							<div class="aside2">
								<cfif isExpiredAd>
									<cfif isMobile>
										<div class="swm mobileWidget">
											<h2>Contact A Doctor</h2>
											#includePartial("/mobile/mini_form")#
										</div>
									<cfelse>
										#includePartial(partial="/shared/sitewideminileadsidebox", isRedundant=true, widgetContent="Looking for doctors who perform <b>#procedures.name#</b>? Fill out the form below to find one in your area now.")#
									</cfif>
									<div class="featured-doctor mobileWidget">
										#includePartial(partial="/shared/featureddoctor", widgetContent="The following doctors perform <b>#procedures.name#</b> in your area.  Click on their name to see before and after galleries and contact information.", defaultAction="/pictures")#
									</div>
								<cfelse>
									<!-- sidebox -->
									<div class="sidebox">
										#includePartial("performedBy")#
									</div>

									<cfif isMobile>
										#includePartial("/shared/minileadsidebox_mobile")#
									<cfelse>
										#includePartial("/shared/minileadsidebox")#
									</cfif>
								</cfif>

								<cfif NOT isMobile>
									<cfif displayAd>
										#includePartial(partial	= "/shared/ad",
														size	= "generic300x250#(explicitAd IS TRUE ? "Explicit" : "")#")#
									</cfif>


									#includePartial("/shared/sharesidebox")#
								</cfif>

								<!-- sidebox sidebox2 -->
								<cfif NOT isMobile>
								<div class="sidebox sidebox2">
									#includePartial("relatedgalleries")#
								</div>
								</cfif>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>