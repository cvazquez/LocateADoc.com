<cfif not isMobile><cfset styleSheetLinkTag(source="resources/procedure", head=true)></cfif>
<cfset javaScriptIncludeTag(source="resources/procedure", head=true)>
<cfoutput>
	<!-- main -->
	<div id="main" class="#params.action#Page resourceProcedurePage">
		#includePartial("/shared/breadcrumbs")#
		#includePartial(partial	= "/shared/ad", size="generic728x90top" & (explicitAd IS TRUE ? "Explicit" : ""))#
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
								<h1 class="page-title shortened">#procedureInfo.name# Guides</h1>
								#includePartial(partial="/shared/sitewideminileadsidebox", isPopup=true)#
							</div>
							<cfif client.relatedSpecialty eq 0>
								<a class="back-link" href="#URLFor(action='surgery')#">BACK TO SURGERY GUIDES</a>
							<cfelseif isObject(specialtyInfo)>
								<a class="back-link" href="#URLFor(controller=specialtyInfo.siloname)#">BACK TO #UCase(specialtyInfo.name)# GUIDE</a>
							</cfif>
							<div <!--- style="float:right;" ---> id="compareProcedures">
								<a class="compare-link" href="#URLFor(action='compare', key=client.relatedSpecialty)#">COMPARE PROCEDURES</a>
								#includePartial("ups3d")#
								<!--- <a class="calculator-link" href="##">BMI CALCULATOR</a> --->
							</div>
						</div>
						<!-- holder -->
						<div class="holder">
							<div class="aside1">
								<!-- widget -->
								<div class="widget guide-body print-area">
									<!--- <a href="##" class="procedure-image"><img src="/images/resources/tummytuck.jpg" alt="image description" width="181" height="130" /></a> --->
									<cfif params.action eq "procedure">
										<cfif basicInfo.recordcount>
											#basicInfo.content#
										</cfif>
									<cfelseif params.action eq "guide">
										#articleInfo.content#
									</cfif>
								</div>

								<cfif params.action eq "reviews">
									<h2>#procedureInfo.name# Reviews</h2>
									<cfif search.pages gt 1>
										<div class="pagination">
											<div class="styled-select" <!--- style="width: 215px; float:left;" --->>
												<select <!--- style="width:235px;" ---> class="selectReviewOrder">
													<option value="http://#CGI.SERVER_NAME#/#procedureInfo.siloName#/reviews/" <cfif params.order eq "">selected</cfif>>Newest Reviews First</option>
													<option value="http://#CGI.SERVER_NAME#/#procedureInfo.siloName#/reviews/oldest" <cfif params.order eq "oldest">selected</cfif>>Oldest Reviews First</option>
													<option value="http://#CGI.SERVER_NAME#/#procedureInfo.siloName#/reviews/nearest" <cfif params.order eq "nearest">selected</cfif>>Doctors Closest to Me</option>
												</select>
											</div>
											#includePartial("/shared/_pagination#mobileSuffix#.cfm")#
										</div>
									</cfif>
									<div itemscope itemtype="http://schema.org/Product">
										<meta itemprop="name" content="#procedureInfo.name#" />
										<div itemprop="aggregateRating" itemscope itemtype="http://schema.org/AggregateRating">
										   <meta itemprop="reviewCount" content = "#search.totalrecords#"/>
										   <meta itemprop="worstRating" content = "0"/>
										   <meta itemprop="ratingValue" content = "#search.avgRating#"/>
										   <meta itemprop="bestRating" content = "10"/>
										</div>
									</div>
									<form name="resultsForm" action="##" method="post">
										<div class="reviews">
										<cfloop query="search.results">
											<div itemprop="review" itemscope itemtype="http://schema.org/Review">
												<table class="review">
													<tr>
														<td class="review-content" colspan="2">
															<cfset filteredContent = REReplace(search.results.content,"<[^>]>","","all")>
															<cfset filterThreshold = Find(" ",filteredContent,200)>
															<cfif filterThreshold gt 0 and Len(filteredContent) - filterThreshold gt 100>
																<div class="content-field">
																	<p>
																	<img src="/images/profile/miscellaneous/quote_left.gif" <!--- style="margin:0 5px 2px 0;" ---> class="quoteLeft">
																	#Left(filteredContent,filterThreshold)#... <a class="show-more-expand" href="##fullContent-#currentrow#">Show more</a>
																	<img src="/images/profile/miscellaneous/quote_right.gif" <!--- style="margin:2px 0 0 5px;" ---> class="quoteRight">
																	</p>
																</div>
																<div id="fullContent-#currentrow#" class="content-field content-field2" <!--- style="display:none; overflow:hidden;" --->>
																	<p>
																	<img src="/images/profile/miscellaneous/quote_left.gif" <!--- style="margin:0 5px 2px 0;" ---> class="quoteLeft">
																	<span itemprop="description">#filteredContent#</span>
																	<img src="/images/profile/miscellaneous/quote_right.gif" <!--- style="margin:2px 0 0 5px;" ---> class="quoteRight">
																	</p>
																</div>
															<cfelse>
																<p>
																<img src="/images/profile/miscellaneous/quote_left.gif" <!--- style="margin:0 5px 2px 0;" ---> class="quoteLeft">
																<span itemprop="description">#filteredContent#</span>
																<img src="/images/profile/miscellaneous/quote_right.gif" <!--- style="margin:2px 0 0 5px;" ---> class="quoteRight">
																</p>
															</cfif>
														</td>
													</tr>
													<tr>
														<td class="review-doctor" itemprop="itemReviewed" itemscope itemtype="http://schema.org/Person">
															<h3 itemprop="name">#search.results.fullNameWithTitle#</h3>
															<!--- <p class="review-practice-name">#search.results.practice#</p> --->
														<!--- </td>
														<td class="rating-cell"> --->
															<!--- <div class="star-rating">
																<div style="width:#8*search.results.rating#px;"></div>
															</div> --->
															<p>#LinkTo(controller=search.results.siloName,action="reviews",text="See all reviews")#</p>
														</td>
														<td class="review-details">
															<p itemprop="author" class="review-author">#search.results.firstName#</p>
															<p>#search.results.city#, #search.results.state#</p>
															<p itemprop="datePublished" >#DateFormat(search.results.createdAt,"long")#</p>
															<div itemprop="reviewRating" itemscope="" itemtype="http://schema.org/Rating" style="display:none;">
																<meta itemprop="worstRating" content = "0"/>
																<meta itemprop="ratingValue" content = "#search.results.rating#"/>
																<meta itemprop="bestRating" content = "10"/>
															</div>
														</td>
													</tr>
												</table>
											</div>
										</cfloop>
										</div>
									</form>
									<cfif search.pages gt 1>
										<div class="pagination">#includePartial("/shared/_pagination#mobileSuffix#.cfm")#</div>
									</cfif>
								</cfif>

								<cfif params.action neq "reviews" and topArticles.recordcount>
									<!-- widget -->
									<div class="widget resource-guide">
										<div class="title">
											<h2>#procedureInfo.name# Articles <span>(#LinkTo(action="articles",key="procedure-#procedureID#",text="view all")#)</span></h2>
										</div>
										<div class="cont-list cont-list2 articles">
											<ul>
											<cfloop query="topArticles">
												<li class="guide-preview">
													<h4>#linkTo(controller="article", action=topArticles.siloName, text="#title#")#</h4>
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
													<h4><a href="##">Costs of Tummy Tuck, Easy Ways to Pay</a></h4>
													<p>Lorem ipsum dolor sit amet, consectetur adipiscing facilisis... <a href="##">read more</a></p>
												</li>
												<li>
													<h4><a href="##">Tummy Tuck Costs $5,000-$10,000 Including Fees</a></h4>
													<p>Lorem ipsum dolor sit amet, consectetur adipiscing facilisis... <a href="##">read more</a></p>
												</li>
												<li>
													<h4><a href="##">Tummy Tuck Scar Revision, Prices & Photos</a></h4>
													<p>Lorem ipsum dolor sit amet, consectetur adipiscing facilisis... <a href="##">read more</a></p>
												</li>
												<li>
													<h4><a href="##">Tummy Tuck Recovery, What Happens After</a></h4>
													<p>Lorem ipsum dolor sit amet, consectetur adipiscing facilisis... <a href="##">read more</a></p>
												</li>
												<li>
													<h4><a href="##">Tummy Tuck Gastric Bypass, Prices & Photos</a></h4>
													<p>Lorem ipsum dolor sit amet, consectetur adipiscing facilisis... <a href="##">read more</a></p>
												</li> --->
											</ul>
										</div>
									</div>
								</cfif>

								<cfif not isMobile>
									<cfif ListFindNoCase("procedure,guide,reviews", params.action)>
										#includePartial("blogs")#
									</cfif>

									<cfif params.action neq "reviews">
										#includePartial("/shared/quicksearchmini")#
									</cfif>
								</cfif>
							</div>
							<!-- aside2 -->
							<div class="aside2">
								<cfif not isMobile>
									#includePartial("/shared/sharesidebox")#
									#includePartial("/shared/featureddoctor")#
									#includePartial("/askadoctor/latestquestions")#
									<!--- #includePartial(partial	= "/shared/ad", size="generic300x250" & (explicitAd IS TRUE ? "Explicit" : ""))# --->
									#includePartial("/shared/beforeandaftersidebox")#
									#includePartial("/shared/proceduresnapshot")#
									#includePartial(partial="/shared/sitewideminileadsidebox", isRedundant=true)#
										<cfif client.relatedSpecialty gt 0 and relatedProcedures.recordcount gte 2>
											<div class="sidebox popular">
												<div class="frame">
													<h4>Related <strong>Procedures</strong></h4>
													<ul>
														<cfloop query="relatedProcedures" endRow="6">
															<li>#LinkTo(controller=relatedProcedures.siloName,text=relatedProcedures.name)#</li>
														</cfloop>
													</ul>
													<cfif relatedProcedures.recordcount gt 6>
														#LinkTo(action="procedureList",key=client.relatedSpecialty,text="VIEW ALL PROCEDURES",class="view-link")#
													</cfif>
												</div>
											</div>
										</cfif>
								<cfelse>
									<div class="swm mobileWidget">
										<h2>Contact A Doctor</h2>
										#includePartial("/mobile/mini_form")#
									</div>
								</cfif>
							</div>
						</div>
					</div>
					<cfif not isMobile>
					<!-- sidebar -->
					<div id="sidebar">
						<div class="search-box resources-menu">
							<div class="t">&nbsp;</div>
							<div class="c">
								<div class="c-add">
									<div class="title">
										<h3>Resource Guides</h3>
									</div>
									<a href="#URLFor(action='surgery')#">Surgery Guide Home</a>
									<a class="guide-title">#UCase(procedureInfo.name)# INFO</a>
									<div class="guide-list">
										<ul>
											<li>#LinkTo(controller=procedureInfo.siloName,class=Iif(params.action eq "procedure",DE("current"),DE("")),text="Overview")#</li>
											<cfloop query="subSections">
											<li>#LinkTo(controller=procedureInfo.siloName,action=subSections.siloName,class=Iif(params.action eq "guide" AND articleID eq subSections.ID,DE("current"),DE("")),text=subSections.name)#</li>
											</cfloop>
											<cfif commentCount gt 0>
											<li>#LinkTo(controller=procedureInfo.siloName,action="reviews",class=Iif(params.action eq "reviews",DE("current"),DE("")),text="Doctor Reviews")#</li>
											</cfif>
										</ul>
									</div>
								</div>
							</div>
							<div class="b">&nbsp;</div>
						</div>
						#includePartial("/shared/sponsoredlink")#
						<!-- side-ad -->
						#includePartial(partial="/shared/ad", size="generic160x600" & (explicitAd IS TRUE ? "Explicit" : ""))#
					</div>
					</cfif>
				</div>
			</div>
		</div>
	</div>
</cfoutput>