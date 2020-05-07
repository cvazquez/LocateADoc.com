<cfset styleSheetLinkTag(source="doctorsonly/addlisting", head=true)>
<cfoutput>
	<!-- main -->
	<div id="main">
		#includePartial("/shared/breadcrumbs")#
		<!--- #includePartial(partial	= "/shared/ad", size="generic728x90top")# --->
		<!-- container inner-container -->
		<div class="container inner-container">
			<div class="inner-holder doctors-only">
				<!-- content-frame -->
				<div class="content-frame">
					<div id="content">
						<!-- resources-box -->
						<div class="resources-box">
							<div class="title">
								<h2>#headerContent.title#</h2>
							</div>
							<div class="box">
								<div class="visual">
									<div class="t">&nbsp;</div>
									<div class="c">
										<a href="##"><img src="http://#Globals.domain#/images/doctors_only/Marketing Strategy.jpg" alt="" width="229" height="161" /></a>
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
										<h2>Medical Marketing Articles <span>(#linkTo(action="articles",text="view all articles")#)</span></h2>
										<a class="rss" href="##">RSS</a>
									</div>
									<div class="cont-list cont-list2">
										<ul>
											<cfloop query="latestArticles">
												<li>
													<div class="head">
														<!--- <cfset TopicList = ListAppend(latestArticles.specialties,latestArticles.procedures)>
														<cfif ListLen(topicList)>
															<strong>#ListGetAt(topicList,1)#</strong>
														</cfif> --->
														<div>
															<!--- <em class="date">#DateFormat(latestArticles.createdAt,"mm.dd.yy")#</em> --->
															<h3>#LinkTo(action="article",key=latestArticles.ID,text=latestArticles.title)#<a href="##"></a></h3>
														</div>
													</div>
													<cfset filteredContent = REReplace(latestArticles.content,"<[^<]+?>","","all")>
													<cfset filteredContent = Replace(filteredContent,"&nbsp;"," ","all")>
													<cfset filteredContent = trim(filteredContent)>
													<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
													<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
													<cfif REFind("\r|\n",filteredContent)>
														<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
													</cfif>
													<p>#filteredContent#</p>
													#linkTo(text="VIEW ARTICLE", action="article", key=latestArticles.ID, class="view-link")#
												</li>
											</cfloop>
											<!--- <li>
												<div class="head">
													<div>
														<h3>Doctor Marketing Article Title Here</h3>
													</div>
												</div>
												<p>Filler text secures the rear within the away medium. How will a pleasant pun outweigh doctor? Filler text fights doctor opposite the systematic principal. Can the spiral beef filler text?</p>
												#linkTo(text="VIEW ARTICLE", action="article", class="view-link")#
											</li>
											<li>
												<div class="head">
													<div>
														<h3>Doctor Marketing Article Title Here</h3>
													</div>
												</div>
												<p>Filler text deranges doctor into my brown ploy. Should an overpriced arena nose in filler text? Filler text standardizes the clipped analyst above the ambiguous writer. Why does doctor tap the demonstrated cube? Why does a feminist junk experiment against a constitutional? Doctor rules within filler text.</p>
												#linkTo(text="VIEW ARTICLE", action="article", class="view-link")#
											</li>
											<li>
												<div class="head">
													<div>
														<h3>Doctor Marketing Article Title Here</h3>
													</div>
												</div>
												<p>Doctor works with the punch. Doctor lurks with a north. Doctor camps filler text opposite the expanding pocket. A line starves the scared screen. Does the rotating reward mob the propaganda?</p>
												#linkTo(text="VIEW ARTICLE", action="article", class="view-link")#
											</li> --->
										</ul>
									</div>
								</div>
								<!-- widget -->
								<div class="widget">
									<div class="title">
										<h2>Online Marketing Solutions for Doctors by <img src="http://#Globals.domain#/images/doctors_only/PracticeDock.jpg" alt="PracticeDock"></h2>
									</div>
									<div>
										<ul class="arrow-list">
											<li><a href="http://www.practicedock.com/index.cfm/PageID/7577" target="_blank">Patient Lead Network</a></li>
											<li><a href="http://www.practicedock.com/index.cfm/PageID/7584" target="_blank">Website Design & Content Manager</a></li>
											<li><a href="http://www.practicedock.com/index.cfm/PageID/17038" target="_blank">Mobile Website Interface Design</a></li>
											<li><a href="http://www.practicedock.com/index.cfm/PageID/8539" target="_blank">Video Services & Production</a></li>
											<li><a href="http://www.practicedock.com/index.cfm/PageID/17336" target="_blank">Advanced SEO Medical Marketing</a></li>
											<li><a href="http://www.practicedock.com/index.cfm/PageID/7585" target="_blank">Call Tracking, Recording & Staff Training</a></li>
											<li><a href="http://www.practicedock.com/index.cfm/PageID/7583" target="_blank">Keyword Marketing - Pay-Per-click (PPC) Advertising</a></li>
											<li><a href="http://www.practicedock.com/index.cfm/PageID/7586" target="_blank">Patient Education 3D Animations</a></li>
										</ul>
									</div>
								</div>
							</div>
							<!-- aside2 -->
							<div class="aside2">
								<!--- #includePartial("/shared/sharesidebox")# --->
								#includePartial(partial="addlistingform")#
								<!--- #includePartial(partial	= "/shared/ad", size="generic300x250")# --->
								<div class="ad">
									<div class="ad-heading">Advertisement</div>
									<a href="https://www.practicedock.com/admin/webinars.cfm?WebinarID=&CampaignID=70160000000KdfC" target="_blank">
										<img src="http://#Globals.domain#/images/doctors_only/PD webinar banner ad.jpg">
									</a>
								</div>
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
										<h3>Advertising Options</h3>
									</div>
									<p>Since 1998, LocateADoc.com has been the top patient lead generation network used by doctors marketing non-insured procedures and services.</p>
									<p>LocateADoc offers multiple advertising opportunities on both a local level and nationally.</p>
									<p>Advertising options include:</p>
										<div class="bold-list">
											<ul>
												<li>#LinkTo(action="advertising",text="Featured Listing")#<span>(Best performance)</span></li>
												<li>#LinkTo(action="advertising",text="Top Doctor Sponsored Section")#</li>
												<li>#LinkTo(action="advertising",text="City Only Listing")#</li>
												<li>#LinkTo(action="advertising",text="Free Basic Listing")#</li>
												<li>#LinkTo(action="advertising",text="National Banner Advertising")#</li>
												<li>#LinkTo(action="advertising",text="Advertorial")#</li>
											</ul>
										</div>
									#LinkTo(action="testimonials",class="advertising-link",text="See what other doctors have to say about our services")#
								</div>
							</div>
							<div class="b">&nbsp;</div>
						</div>
						<!-- side-ad -->
						<div class="side-ad">
							<div class="ad-heading">Advertisement</div>
							<a href="http://www.practicedock.com/index.cfm/PageID/7150/index.cfm?campaignId=70160000000MD6b" target="_blank">
								<img src="http://#Globals.domain#/images/doctors_only/PD banner ad tall.jpg">
							</a>
						</div>
						<!--- #includePartial(partial="/shared/ad", size="generic160x600")# --->
					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>