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
								<h1 class="page-title">#headerContent.title#</h1>
								<span>#headerContent.header#</span>
							</div>
							<div class="box">
								<div class="visual">
									<div class="t">&nbsp;</div>
									<div class="c">
										<a href="##"><img src="/images/resources/surgery_guides.jpg" alt="image description" width="229" height="161" /></a>
									</div>
									<div class="b">&nbsp;</div>
								</div>
								<div class="descr">
									<p>#headerContent.content#</p>
								</div>
							</div>
						</div>
						<!-- holder -->
						<div class="holder">
							<div class="aside1">
								<!-- widget -->
								<div class="widget resource-guide">
									<div class="title">
										<h2>Latest Articles <span>(#linkTo(text="view all articles", action="articles", key="show-all")#)</span></h2>
										<a class="rss" href="##">RSS</a>
									</div>
									<div class="cont-list cont-list2">
										<ul>
											<cfloop query="latestArticles">
												<li itemscope itemtype="http://schema.org/Article">
													<div class="head">
														<div>
															<h3>#linkTo(text='<span itemprop="name">#latestArticles.title#</span>',
																		controller="article",
																		action=latestArticles.siloName,
																		itemprop="url")#</h3>
														</div>
													</div>
													<cfset filteredContent = latestArticles.content>
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
																	<cfset newImageTag = '<a href="/article/#latestArticles.siloName#" itemprop="url">' & newImageTag & '</a>'>
																<cfelseif ReFindNoCase("^Infographic:", latestArticles.title) AND latestArticles.OGIMAGE NEQ "">
																	<cfset newImageTag = '<a href="/article/#latestArticles.siloName#" itemprop="url"><img itemprop="image" src="#latestArticles.OGIMAGE#" style="float: left; height: 100px;"></a>'>
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
													<p class="guide-description">#newImageTag & filteredContent#</p>
													#linkTo(text="VIEW ARTICLE",
															controller="article",
															action=latestArticles.siloName,
															class="view-link",
															itemprop="url")#
												</li>
											</cfloop>
										</ul>
									</div>
								</div>
								<!-- widget -->
								<div class="widget">
									<div class="title">
										<h2>Popular Procedures <span>(#LinkTo(action="procedureList",text="view all procedures")#)</span></h2>
									</div>
									<div class="procedures-list">
										<ul>
											<cfloop query="popularProcedures" endRow="10">
											<li class="#Iif(currentrow mod 2 eq 1,DE('left-side'),DE('right-side'))#">#LinkTo(action='articles',key='procedure-'&popularProcedures.id,text=popularProcedures.name)#</li>
											</cfloop>
										</ul>
									</div>
								</div>
							</div>
							<!-- aside2 -->
							<div class="aside2">
								<!-- sidebox -->
								#includePartial("/shared/sharesidebox")#
								#includePartial("/shared/sitewideminileadsidebox")#
								<div class="sidebox trending">
									<div class="frame">
										<h4>Trending <strong>Topics</strong></h4>
										<ul>
										<cfloop query="trendingTopics">
											<li><a href="#URLFor(controller="article", action=trendingTopics.siloName)#">#trendingTopics.title#</a></li>
										</cfloop>
										</ul>
									</div>
								</div>
								#includePartial("/shared/featureddoctor")#
								#includePartial("/shared/beforeandaftersidebox")#
								#includePartial(partial	= "/shared/ad", size="generic300x250")#
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
										<h3>Articles</h3>
									</div>
									<a href="#URLFor(action='index')#">Resources Home</a>
										<a class="guide-title">ARTICLES BY SPECIALTY</a>
										<div class="guide-list">
											<ul>
												<cfloop query="specialtyArticles">
													<li><a href="/articles/#specialtyArticles.siloName#">#specialtyArticles.name#</a></li>
												</cfloop>
											</ul>
										</div>
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