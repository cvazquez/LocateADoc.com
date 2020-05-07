<cfset javaScriptIncludeTag(source="resources/procedure-select", head=true)>
<cfhtmlhead text='<script type="text/javascript" src="/resources/procedureselect"></script>'>
<cfoutput>
	<!-- main -->
	<div id="main">
		#includePartial("/shared/breadcrumbs")#
		#includePartial(partial	= "/shared/ad", size="generic728x90top")#
		<!-- container inner-container -->
		<div class="container inner-container">
			<div class="inner-holder">
				#includePartial("/shared/pagetools")#
				<!-- content-frame -->
				<div class="content-frame">
					<div id="content">
						<!-- resources-box -->
						<div class="resources-box">
							<div class="title">
								<h1 class="page-title shortened">#specialtyInfo.name# Guides</h1>
								#includePartial(partial="/shared/sitewideminileadsidebox", isPopup=true)#
							</div>
							<a class="back-link" href="#URLFor(action='surgery')#">BACK TO SURGERY GUIDES</a>
							<div style="float:right;">
								<a class="compare-link" href="#URLFor(action='compare', key=specialtyID)#">COMPARE PROCEDURES</a>
								#includePartial("ups3d")#
								<!--- <a class="calculator-link" href="##">BMI CALCULATOR</a> --->
							</div>
						</div>
						<!-- holder -->
						<div class="holder">
							<div class="aside1">
								<!-- widget -->
								<div class="widget resource-guide print-area">
									<div class="title">
										<h2>#specialtyInfo.name# Basics</h2>
										<a class="rss" href="##">RSS</a>
									</div>
									<div class="guide-body cont-list cont-list2">
										<ul>
											<li>
												#basicInfo.content#
											</li>
										</ul>
									</div>
								</div>

								<cfif topArticles.recordcount>
									<!-- widget -->
									<div class="widget resource-guide">
										<div class="title">
											<h2>#specialtyInfo.name# Articles <span>(#LinkTo(action="articles",key="specialty-#specialtyID#",text="view all")#)</span></h2>
										</div>
										<div class="cont-list cont-list2 articles">
											<ul>
												<cfloop query="topArticles">
													<li class="guide-preview">
														<h4>#linkTo(controller="article", action=topArticles.siloName, text="#topArticles.title#")#</h4>
														<cfset filteredContent = topArticles.content>
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
														<p>#newImageTag & filteredContent#</p>
													</li>
												</cfloop>
												<!--- <li>
													<h4><a href="##">More Male Baby Boomers are Getting Plastic Surgery</a></h4>
													<p>Lorem ipsum dolor sit amet, consectetur adipiscing facilisis... <a href="##">read more</a></p>
												</li>
												<li>
													<h4><a href="##">Tummy Tuck Recovery, What Happens After</a></h4>
													<p>Lorem ipsum dolor sit amet, consectetur adipiscing facilisis... <a href="##">read more</a></p>
												</li>
												<li>
													<h4><a href="##">Turn Back the Clock Before Summer with the Mini Facelift</a></h4>
													<p>Lorem ipsum dolor sit amet, consectetur adipiscing facilisis... <a href="##">read more</a></p>
												</li>
												<li>
													<h4><a href="##">Choosing Between Saline Implants and Silicone Breast Implants</a></h4>
													<p>Lorem ipsum dolor sit amet, consectetur adipiscing facilisis... <a href="##">read more</a></p>
												</li>
												<li>
													<h4><a href="##">Close Look at Breast Augmentation Prices</a></h4>
													<p>Lorem ipsum dolor sit amet, consectetur adipiscing facilisis... <a href="##">read more</a></p>
												</li> --->
											</ul>
										</div>
									</div>
								</cfif>

								<cfif ListFindNoCase("specialty,guide", params.action)>
									#includePartial("blogs")#
								</cfif>

								#includePartial("/shared/quicksearchmini")#
							</div>
							<!-- aside2 -->
							<div class="aside2">
								#includePartial("/shared/sharesidebox")#
								#includePartial("/askadoctor/latestquestions")#
								<cfif popularProcedures.recordcount>
								<!-- sidebox -->
								<div class="sidebox popular">
									<div class="frame">
										<h4>Popular <strong>Procedures</strong></h4>
										<ul>
										<cfloop query="popularProcedures" endRow="6">
										<li>#LinkTo(controller=popularProcedures.siloName,text=popularProcedures.name)#</li>
										</cfloop>
										</ul>
										<cfif popularProcedures.recordcount gt 6>
										#LinkTo(action="procedureList",key=specialtyID,text="VIEW ALL #UCase(specialtyInfo.name)# PROCEDURES",class="view-link")#
										</cfif>
									</div>
								</div>
								</cfif>
								#includePartial("/shared/featureddoctor")#
								#includePartial(partial="/shared/sitewideminileadsidebox", isRedundant=true)#
								#includePartial("/shared/beforeandaftersidebox")#
								<!--- #includePartial(partial	= "/shared/ad", size="generic300x250")# --->
							</div>
						</div>
					</div>
					<!-- sidebar -->
					<div id="sidebar">
						<div class="search-box resources-menu">
							<div class="t">&nbsp;</div>
							<div class="c">
								<div class="c-add">
									<div class="title">
										<h3>Resource Guides</h3>
									</div>
									<a href="#URLFor(action='index')#">Resources Home</a>
									<a class="guide-title">#UCase(specialtyInfo.name)# GUIDES</a>
</cfoutput>
									<p>Search by name</p>
									<span class="text med resource-procedure-box">
										<input id="procedurename" type="text" value="" class="txt">
									</span>
									<p>Search by body part</p>
									<ul id="bodyParts">
										<cfset ProcedureIds = "">
										<cfoutput query="bodyParts" group="bodyRegionName">
										<li class="slide-block">
											<a class="open-close" href="##">#bodyRegionName#</a>
											<div class="slide" style="display:none;">
												<ul>
													<cfoutput group="bodyPartName">
													<li class="sub-slide-block">
														<a class="sub-open-close" href="##">#bodyPartName#</a>
														<div class="sub-slide" style="display:none;">
															<ul>
																<cfoutput>
																<li><a href="#URLFor(controller=bodyParts.siloName)#" <cfif ListFind(ProcedureIds,procedureId) eq 0>unique="1"</cfif>>#procedureName#</a></li>
																<cfset ProcedureIds = ListAppend(ProcedureIds,procedureId)>
																</cfoutput>
															</ul>
														</div>
													</li>
													<!--- <li><a href="#URLFor(action='procedure',key='#procedureId#')#">#procedureName#</a> (0)</li> --->
													</cfoutput>
												</ul>
											</div>
										</li>
										</cfoutput>
									</ul>
<cfoutput>
								</div>
							</div>
							<div class="b">&nbsp;</div>
						</div>
						#includePartial("/shared/sponsoredlink")#
						<!-- side-ad -->
						#includePartial(partial="/shared/ad", size="generic160x600")#
					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>