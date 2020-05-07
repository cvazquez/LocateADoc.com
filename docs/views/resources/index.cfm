<cfhtmlhead text='<script type="text/javascript" src="/resources/procedureselect"></script>'>
<cfset javaScriptIncludeTag(source="resources/procedure-select", head=true)>
<cfset javaScriptIncludeTag(source="resources/index", head=true)>
<cfoutput>
	<!-- main -->
	<div id="main">
		#includePartial("/shared/breadcrumbs")#
		#includePartial(partial	= "/shared/ad", size="generic728x90top")#
		<!-- container inner-container -->
		<div class="container inner-container">
			<div class="inner-holder">
				<!--- <!-- options -->
				<div class="options">
					<ul>
						<li class="email-link"><a href="##">Email</a></li>
						<li class="print-link"><a href="##">Print</a></li>
						<li class="share-link"><a href="##">Share</a></li>
					</ul>
				</div> --->
				<!-- content-frame -->
				<div class="content-frame">
					<div id="content">
						<!-- resources-box -->
						<div class="resources-box">
							<div class="title">
								<h1 class="page-title">#specialContent.header#</h1>
								<span>#specialContent.description#</span>
							</div>
							<div class="box">
								<div class="descr resources-content">
									<div class="visual">
										<div class="t">&nbsp;</div>
										<div class="c">
											<a href="/resources/guides"><img src="/images/layout/img-resources-home.jpg" width="228" height="153" /></a>
										</div>
										<div class="b">&nbsp;</div>
									</div>
									#specialContent.content#
								</div>
							</div>
						</div>
						<!-- holder -->
						<div class="holder">
							<div class="aside1">
								<!---
								<!-- widget -->
								<div class="widget widget-gallery">
									<div class="title">
										<h2>Latest Videos <span>(#LinkTo(action="video",text="view all media")#)</span></h2>
										<ul class="switcher">
											<li class="active"><a href="##"><span>1</span></a></li>
											<li><a href="##"><span>2</span></a></li>
											<li><a href="##"><span>3</span></a></li>
											<li><a href="##"><span>4</span></a></li>
										</ul>
									</div>
									<div class="media-gallery">
										<ul>
											<cfloop query="videoCarousel">
												<li>
													<div class="visual">
														<div class="t">
															<div class="b">
																<a href='/#videoCarousel.siloName#?vid=#videoCarousel.id#'>
																	<img src="http://#Globals.domain & videoCarousel.imagePreview#" alt="#videoCarousel.headline#" width="114" height="86" />
																</a>
															</div>
														</div>
													</div>
													<h3>#videoCarousel.headline#</h3>
													<span>(#LinkTo(href="/#videoCarousel.siloName#?vid=#videoCarousel.id#",text="view details")#)</span>
												</li>
											</cfloop>
										</ul>
									</div>
								</div>
								--->
								<!-- widget -->
								<div class="widget">
									<div class="title">
										<h2>Recent Articles & Blogs <span>(#linkTo(action="articles",text="view all articles")#)</span></h2>
										<a class="rss" href="##">RSS</a>
									</div>
									<div class="cont-list">
										<ul>
											<cfloop query="latestArticlesAndBlogs">
												<li class="guide-preview" itemscope itemtype="http://schema.org/<cfif reFind("^/blog", latestArticlesAndBlogs.siloName)>Blog<cfelse>Article</cfif>">
													<div class="head">
														<cfset TopicList = ListAppend(latestArticlesAndBlogs.specialties,latestArticlesAndBlogs.procedures)>
														<cfif ListLen(topicList)>
															<strong>#ListGetAt(topicList,1)#</strong>
														</cfif>
														<div>
															<em class="date" itemprop="datePublished" content="#DateFormat(latestArticlesAndBlogs.publishAt,"yyyy-mm-dd")#">#DateFormat(latestArticlesAndBlogs.publishAt,"mm.dd.yy")#</em>
															<h3><a href="#latestArticlesAndBlogs.siloName#" itemprop="url"><span itemprop="name">#latestArticlesAndBlogs.title#</span></a></h3>
														</div>
													</div>
													<cfset filteredContent = latestArticlesAndBlogs.content>

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
																		<cfset newImageTag = replacenocase(newImageTag,"<img ",'<img itemprop="image" ')>
																		<cfset newImageTag = '<a href="#latestArticlesAndBlogs.siloName#">' & newImageTag & '</a>'>
																	<cfelseif ReFindNoCase("^Infographic:", latestArticlesAndBlogs.title) AND latestArticlesAndBlogs.OGIMAGE NEQ "">
																		<cfset newImageTag = '<a href="/article/#latestArticlesAndBlogs.siloName#" itemprop="url"><img itemprop="image" src="#latestArticlesAndBlogs.OGIMAGE#" style="float: left; height: 100px;"></a>'>
																	<cfelse>
																		<cfset newImageTag = "">
																	</cfif>
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
										</ul>
										<div class="view-more"><a href="/resources/articles" style="text-decoration: none;">View More Articles & Blogs &gt;&gt;</a></div>
									</div>
								</div>
								<!-- widget -->
								<div class="widget">
									<div class="title">
										<h2>Recently Updated Resource Guides <span>(&nbsp;#linkTo(action="surgery",text="view&nbsp;all&nbsp;guides")#&nbsp;)</span></h2>
									</div>
									<div class="cont-list cont-list2">
										<ul>
											<cfloop query="latestGuides">
												<li class="guide-preview">
													<div class="head">
														<cfset TopicList = ListAppend(latestGuides.specialtyname,latestGuides.procedurename)>
														<cfset TopicList = ListAppend(TopicList,latestGuides.subprocedurename)>
														<cfif ListLen(topicList)>
															<strong>#ListGetAt(topicList,1)#</strong>
														</cfif>
														<div>
															<em class="date">#DateFormat(latestGuides.createdAt,"mm.dd.yy")#</em>
															<cfif val(specialtyID)>
															<h3>#LinkTo(controller=latestGuides.specialtySiloName,text="#specialtyname# Guide")#</h3>
															<cfelseif val(subprocedureID)>
															<h3>#LinkTo(controller=latestGuides.procedureSiloName,action=latestGuides.siloName,text=latestGuides.title)#</h3>
															<cfelse>
															<h3>#LinkTo(controller=latestGuides.procedureSiloName,text=latestGuides.title)#</h3>
															</cfif>
														</div>
													</div>

														<cfset filteredContent = REReplace(latestGuides.content,"</?span[^>]*?>"," ","all")>
														<cfset filteredContent = Replace(filteredContent,"&nbsp;"," ","all")>
														<cfset filteredContent = REReplace(filteredContent,"<h[0-9][^>]*?>.+?</h[0-9]>","","all")>
														<!--- Resize images in blog preview --->
														<cfset guideImages = REFind("<img.+?>",filteredContent,0,true)>
														<cfset newImageTag = "">
														<cfif guideImages.len[1] gt 0>
															<cfset imageTag = Mid(filteredContent,guideImages.pos[1],guideImages.len[1])>
															<cfset newImageTag = imageTag>
															<cfset imageWidthLocation = REFind('width\s?(=|:)\s?"?[0-9]+("|px)?',imageTag,0,true)>
															<cfset imageHeightLocation = REFind('height\s?(=|:)\s?"?[0-9]+("|px)?',imageTag,0,true)>
															<cfif imageWidthLocation.pos[1] and imageHeightLocation.pos[1]>
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
																	<cfset newImageTag = Replace(Replace(newImageTag,'"#imageHeight#"','"#newImageHeight#"',"all"),'"#imageWidth#"','"#newImageWidth#"',"all")>
																	<cfset newImageTag = Replace(Replace(newImageTag,'#imageHeight#px','#newImageHeight#px',"all"),'#imageWidth#px','#newImageWidth#px',"all")>
																	<cfset newImageTag = '<a href="#latestGuides.procedureSiloName#">' & newImageTag & '</a>'>
																</cfif>
															</cfif>

															<!--- Solves an issue with ckeditor publishing div instead of <p> tags --->
															<cfset filteredContent = ReplaceNoCase(filteredContent, "<div>", "<p>", "all")>
															<cfset filteredContent = ReplaceNoCase(filteredContent, "</div>", "</p>", "all")>

															<!--- Prepend the new Image dimensions to the content, and remove all other image tags --->
															<cfset filteredContent = newImageTag & REReplace(filteredContent,"<img.+?>",'','all')>

															<!--- Remove all empty paragraph tags --->
															<cfset filteredContent = REReplace(filteredContent,"<p[^>]*?>\s*?</p>","","all")>
															<cfset filteredContent = REReplace(filteredContent,"<div[^>]*?>\s*?</div>","","all")>
														</cfif>

														<!--- Check if a div tag is at the beginning --->
														<cfif Left(filteredContent,5) eq "<div>">
															<p class="guide-description">#Left(filteredContent,Find("</div>",filteredContent,50+Len(newImageTag))+6)#</p>
														<cfelse>
															<cfif Find("</p>",filteredContent,50+Len(newImageTag))>
																<p class="guide-description">#Left(filteredContent,Find("</p>",filteredContent,50+Len(newImageTag))+4)#</p>
															<cfelseif Find("</div>",filteredContent,50+Len(newImageTag))>
																<p class="guide-description">#Left(filteredContent,Find("</div>",filteredContent,50+Len(newImageTag))+4)#</p>
															</cfif>
														</cfif>
												</li>
											</cfloop>
										</ul>
										<div class="view-more"><a href="/resources/surgery" style="text-decoration: none;">View More Resource Guides &gt;&gt;</a></div>
									</div>
								</div>
							</div>
							<!-- aside2 -->
							<div class="aside2">
								#includePartial("/askadoctor/latestquestions")#
								#includePartial("infographicscarousel")#
								<!--- #includePartial("trendingtopics")# --->
								#includePartial("/shared/featureddoctor")#
								<!--- #includePartial("/shared/sitewideminileadsidebox")# --->
								#includePartial("/shared/beforeandaftersidebox")#
								<!--- #includePartial("/shared/beautifulliving")# --->
								<br />#includePartial("/shared/sharesidebox")#

								<!--- #includePartial(partial	= "/shared/ad", size="generic300x250")# --->
								<!--- <!-- sidebox -->
								<div class="sidebox">
								#includePartial("blog")#
								</div> --->

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
										<h3>Research Procedures & Treatments</h3>
										<span class="text med resource-procedure-box">
											<input id="procedurename" type="text" value="" class="txt">
										</span>
										<p>Start typing a procedure or treatment name into the field above.</p>

										<h2>Popular Resource Guides</h2>
									</div>
									</cfoutput>

									<!--- <ul id="bodyParts" style="display: none;">
									<cfoutput query="popularResourceGuides">
										<li class="slide-block">#linkTo(	text		= popularResourceGuides.name,
																			controller	= popularResourceGuides.siloname,
																			class		= "open-close")#</li>
									</cfoutput>
									</ul> --->

									<ul id="RecentCategories">
									<cfoutput>
									<cfsavecontent variable="paramKeyValues">
										<cfloop collection="#params#" item="pC">
											<cfif isnumeric(params[pC])>
												#pC#:#val(params[pC])#;
											</cfif>
										</cfloop>
									</cfsavecontent>
									<cfset clickTrackKeyValues = trim(paramKeyValues)>
									</cfoutput>
									<cfoutput query="popularResourceGuides">
										<li class="RecentCategory">
											#linkTo(	text		= popularResourceGuides.name,
														controller	= popularResourceGuides.siloname,
														class		= "RecentCategoryLink",
														clickTrackSection	= "Resources",
														clickTrackLabel		= "PopularResourceGuides",
														clickTrackKeyValues	= "#clickTrackKeyValues#")#
										</li>
									</cfoutput>
									</ul>

									<a href="/resources/guides">View All Guides</a>

									<!--- This is needed for the search to work --->
									<!--- <ul id="bodyParts" style="display: none;">
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
									</ul> --->
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
	<noscript>
		<h2>Procedure Guides by Body Part</h2>
		<cfoutput query="bodyParts" group="bodyRegionName">
			<h3>#bodyRegionName#</h3>
			<ul>
				<cfoutput group="bodyPartName">
				<li>
					<h4>#bodyPartName#</h4>
					<ul>
						<cfoutput>
							<li><a href="#URLFor(controller=bodyParts.siloName)#">#procedureName#</a></li>
						</cfoutput>
					</ul>
				</li>
				</cfoutput>
			</ul>
		</cfoutput>
	</noscript>
