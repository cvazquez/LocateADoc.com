<cfsavecontent variable="additionalJS">
	<cfoutput>
		<script type="text/javascript">
			var images = new Array();
			$(function(){
				$(".article img").each(function(){
				    images[$(this).attr("src")] = $(this);
					// Create in memory copy of image and get size
					$("<img/>")
						.attr("src", $(this).attr("src"))
    					.load(function() {
    					    thisImg = images[this.src];
        					w = this.width;		// Note: $(this).width() will not
        					h = this.height;	// work for in memory images.
    					    //alert(w);
							// Resize wide images
							if(w > 266)
							{
								//alert("Resizing wide image: "+thisImg.attr("src"));
								console.log("Resizing image: "+this.src);
								thisImg.css("width", "266px");
								thisImg.css("height", " " + parseInt(266 * h / w) + "px");
								thisImg.css("margin","5px 0");
							}
							// If image wider than a certain size, make sure text doesn't float around it
							else if(w > 150)
							{
								console.log("Centering wide image: "+this.src);
								thisImg.css("float","none").css("display","block").css("margin","5px auto");
							}
							// Float it is it's not already
							else if(thisImg.css("float") == "")
							{
								thisImg.css("float","right");
								thisImg.css("margin","5px");
							}
							// Otherwise just add margin
							else
							{
								thisImg.css("margin","5px");
							}
    					});
				});
			});
		</script>
	</cfoutput>
</cfsavecontent>

<cfoutput>
	<div id="page1" class="centered">
		<div id="bottom-content-wrapper">
			<div id="mobile-content">
				<a href="##specialtyGuides" data-role="button" data-icon="plus" data-theme="b" data-transition="flip" class="left-aligned">#procedureInfo.name# Info</a>
				<div class="title">
					<h1 class="page-title">#procedureInfo.name# Guides</h1>
				</div>
				<cfif params.action eq "procedure">
					<cfset pageContent = basicInfo.recordcount ? basicInfo.content : ''>
				<cfelseif params.action eq "guide">
					<cfset pageContent = articleInfo.content>
				<cfelseif params.action eq "reviews">
					<cfset pageContent = "Reviews">
				</cfif>
				<p>#mobileImageFormat(pageContent)#</p>

				<cfif isDefined("topArticles") and topArticles.recordcount>
					<h2>#procedureInfo.name# Articles</h2>
					<div class="cont-list">
						<ul>
							<cfloop query="topArticles">
								<li>
									<div class="head">
										<div>
											<h3>#linkTo(controller="article", action=topArticles.siloName, text="#topArticles.title#")#</h3>
										</div>
									</div>
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
						</ul>
					</div>
				</cfif>

				<!--- From Our Blog --->
				<!--- <cfif params.action eq "procedure" and Blog.recordcount>
					<h2>From Our Blog <span>(#LinkTo(action="blogList",text="view blog", rel="external")#)</span></h2>
					<div class="cont-list">
						<ul>
							<cfloop query="Blog">
								<cfset filteredContent = Blog.post_content>
								<cfset blogImage = "">
								<!--- Resize images in blog preview --->
								<cfset blogImages = REFind("<img.+?>",Blog.post_content,0,true)>
								<cfif blogImages.len[1] gt 0>
									<cfset imageTag = Mid(Blog.post_content,blogImages.pos[1],blogImages.len[1])>
									<cfset newImageTag = imageTag>
									<cfset imageWidthLocation = REFind('width\s?=\s?"[0-9]+"',imageTag,0,true)>
									<cfset imageWidth = REReplace(Mid(imageTag,imageWidthLocation.pos[1],imageWidthLocation.len[1]),"[^0-9]","","all")>
									<cfset imageHeightLocation = REFind('height\s?=\s?"[0-9]+"',imageTag,0,true)>
									<cfset imageHeight = REReplace(Mid(imageTag,imageHeightLocation.pos[1],imageHeightLocation.len[1]),"[^0-9]","","all")>
									<cfif imageWidth gt 100 and imageHeight gt 100>
										<cfif imageWidth lt imageHeight>
											<cfset newImageWidth = Ceiling(imageWidth/imageHeight * 100)>
											<cfset newImageHeight = 100>
										<cfelse>
											<cfset newImageHeight = Ceiling(imageHeight/imageWidth * 100)>
											<cfset newImageWidth = 100>
										</cfif>
										<cfset blogImage = Replace(Replace(newImageTag,'"#imageHeight#"','"#newImageHeight#"',"all"),'"#imageWidth#"','"#newImageWidth#"',"all")>
										<!--- Show only one image --->
										<cfset filteredContent = REReplace(filteredContent,"<img[^>]*>",'','all')>
									</cfif>
								</cfif>
								<!--- Show only first paragraph --->
								<cfset filteredContent = REReplace(filteredContent,"\[caption.+?/caption\](\r|\n)*","","all")>
								<cfset filteredContent = REReplace(filteredContent,"<img[^>]*>","","all")>
								<cfset filteredContent = REReplace(filteredContent,"</?strong.+?>","","all")>
								<cfset filteredContent = REReplace(filteredContent,"<a[^>]+>\s*?</a>","","all")>
								<cfset filteredContent = REReplace(filteredContent,"<p[^>]+>\s*?</p>","","all")>
								<cfset filteredContent = trim(filteredContent)>
								<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
								<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
								<cfset filteredContent = REReplace(filteredContent,"<h[0-9]>.+</h[0-9]>((\r|\n)+)?","","all")>
								<cfif REFind("\r|\n",filteredContent)>
									<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
								</cfif>
								<cfset truncatePoint = 200 <!--- + Iif(blogImages.len[1] gt 0 and Find(newImageTag,filteredContent),Len(newImageTag),0) --->>
								<cfif Len(filteredContent) gt truncatePoint>
									<cfset filteredContent = Left(filteredContent,(truncatePoint))&"...">
								</cfif>

								<li>
									<div class="head">
										<div>
											<em class="date">#DateFormat(Blog.post_date,"mm.dd.yy")#</em>
											<h3>#LinkTo(controller="blog",action="#DateFormat(Blog.createdAt,'yyyy/mm/dd')#/#Blog.siloName#",text=Blog.post_title, style="font-size:14px; line-height:15px; letter-spacing:0;", rel="external")#</h3>
										</div>
									</div>
									<cfif blogImage neq "">
										<div class="blog-photo">#blogImage#</div>
									</cfif>
									<p class="blog-preview" style="font: 12px/15px Arial, Helvetica, sans-serif;">#filteredContent#</p>
									<strong class="more">#LinkTo(controller="blog",action="#DateFormat(Blog.createdAt,'yyyy/mm/dd')#/#Blog.siloName#",text="READ FULL STORY", rel="external")#</strong>
								</li>
							</cfloop>
						</ul>
					</div>
				</cfif> --->

				<div class="swm">
					<h2>Contact A Doctor</h2>
					#includePartial("/mobile/mini_form")#
				</div>
			</div>
		</div>
	</div>
</cfoutput>

<cfset ProcedureIds = "">
<cfsavecontent variable="additionalPages">
		<div id="specialtyGuides" data-role="page" data-url="specialtyGuides" data-transition="flip">
			<ul data-role="listview">
				<cfoutput>
					<li data-role="list-divider">#procedureInfo.name# Info</li>
					<li>#LinkTo(controller=procedureInfo.siloName,class=Iif(params.action eq "procedure",DE("current"),DE("")),text="Overview")#</li>
					<cfloop query="subSections">
					<li>#LinkTo(controller=procedureInfo.siloName,action=subSections.siloName,class=Iif(params.action eq "guide" AND articleID eq subSections.ID,DE("current"),DE("")),text=subSections.name)#</li>
					</cfloop>
					<cfif commentCount gt 0>
						<li>#LinkTo(	controller	= procedureInfo.siloName,
										action		= "reviews",
										class		= Iif(params.action eq "reviews",DE("current"),DE("")),
										text		= "Doctor Reviews")#</li>
					</cfif>
				</cfoutput>
			</ul>
		</div>
</cfsavecontent>

<!--- <cfset styleSheetLinkTag(source="resources/procedure", head=true)>
<cfset javaScriptIncludeTag(source="resources/procedure", head=true)>
<cfoutput>
	<!-- main -->
	<div id="main">
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
							<cfelse>
								<a class="back-link" href="#URLFor(controller=specialtyInfo.siloname)#">BACK TO #UCase(specialtyInfo.name)# GUIDE</a>
							</cfif>
							<div style="float:right;">
								<a class="compare-link" href="#URLFor(action='compare', key=client.relatedSpecialty)#">COMPARE PROCEDURES</a>
								#includePartial("ups3d")#
							</div>
						</div>
						<!-- holder -->
						<div class="holder">
							<div class="aside1">
								<!-- widget -->
								<div class="widget guide-body print-area">
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
											<div class="styled-select" style="width: 215px; float:left;">
												<select style="width:235px;" class="selectReviewOrder">
													<option value="http://#CGI.SERVER_NAME#/#procedureInfo.siloName#/reviews/" <cfif params.order eq "">selected</cfif>>Newest Reviews First</option>
													<option value="http://#CGI.SERVER_NAME#/#procedureInfo.siloName#/reviews/oldest" <cfif params.order eq "oldest">selected</cfif>>Oldest Reviews First</option>
													<option value="http://#CGI.SERVER_NAME#/#procedureInfo.siloName#/reviews/nearest" <cfif params.order eq "nearest">selected</cfif>>Doctors Closest to Me</option>
												</select>
											</div>
											#includePartial("/shared/_pagination.cfm")#
										</div>
									</cfif>
									<form name="resultsForm" action="##" method="post">
										<cfloop query="search.results">
											<div>
												<table class="review">
													<tr>
														<td class="review-content" colspan="2">
															<cfset filteredContent = REReplace(search.results.content,"<[^>]>","","all")>
															<cfset filterThreshold = Find(" ",filteredContent,200)>
															<cfif filterThreshold gt 0 and Len(filteredContent) - filterThreshold gt 100>
																<div class="content-field">
																	<p>
																	<img src="http://#Globals.domain#/images/profile/miscellaneous/quote_left.gif" style="margin:0 5px 2px 0;">
																	#Left(filteredContent,filterThreshold)#... <a class="show-more-expand" href="##fullContent-#currentrow#">Show more</a>
																	<img src="http://#Globals.domain#/images/profile/miscellaneous/quote_right.gif" style="margin:2px 0 0 5px;">
																	</p>
																</div>
																<div id="fullContent-#currentrow#" class="content-field" style="display:none; overflow:hidden;">
																	<p>
																	<img src="http://#Globals.domain#/images/profile/miscellaneous/quote_left.gif" style="margin:0 5px 2px 0;">
																	<span>#filteredContent#</span>
																	<img src="http://#Globals.domain#/images/profile/miscellaneous/quote_right.gif" style="margin:2px 0 0 5px;">
																	</p>
																</div>
															<cfelse>
																<p>
																<img src="http://#Globals.domain#/images/profile/miscellaneous/quote_left.gif" style="margin:0 5px 2px 0;">
																<span>#filteredContent#</span>
																<img src="http://#Globals.domain#/images/profile/miscellaneous/quote_right.gif" style="margin:2px 0 0 5px;">
																</p>
															</cfif>
														</td>
													</tr>
													<tr>
														<td class="review-doctor">
															<h3>#search.results.fullNameWithTitle#</h3>
															<p class="review-practice-name">#search.results.practice#</p>
															<p>#LinkTo(controller=search.results.siloName,action="comments",text="See all reviews")#</p>
														</td>
														<td class="review-details">
															<p>#search.results.firstName#</p>
															<p>#search.results.city#, #search.results.state#</p>
															<p>#DateFormat(search.results.createdAt,"long")#</p>
														</td>
													</tr>
												</table>
											</div>
										</cfloop>
									</form>
									<cfif search.pages gt 1>
										<div class="pagination">#includePartial("/shared/_pagination.cfm")#</div>
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
												<li>
													<h4>#linkTo(controller="article", action=topArticles.siloName, text="#title#")#</h4>
													<cfset filteredContent = REReplace(topArticles.content,"<[^<]+?>","","all")>
													<cfset filteredContent = Replace(filteredContent,"&nbsp;"," ","all")>
													<cfset filteredContent = trim(filteredContent)>
													<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
													<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
													<cfif REFind("\r|\n",filteredContent)>
														<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
													</cfif>
													<p>#filteredContent#</p>
												</li>
											</cfloop>
											</ul>
										</div>
									</div>
								</cfif>

								<cfif params.action eq "procedure">
									<cfif Blog.recordcount>
										<!-- widget -->
										<div class="widget">
											<div class="title">
												<h2>From Our Blog <span>(#LinkTo(action="blogList",key="procedure-#procedureID#",text="view blog")#)</span></h2>
												<a class="rss" href="##">RSS</a>
											</div>
											<div class="cont-list">
												<ul>
													<cfloop query="Blog">
													<cfset filteredContent = Blog.post_content>
													<cfset blogImages = REFind("<img.+?>",Blog.post_content,0,true)>
													<cfset blogImage = "">
													<cfif blogImages.len[1] gt 0>
														<cfset imageTag = Mid(Blog.post_content,blogImages.pos[1],blogImages.len[1])>
														<cfset imageWidthLocation = REFind('width\s?=\s?"[0-9]+"',imageTag,0,true)>
														<cfset imageWidth = REReplace(Mid(imageTag,imageWidthLocation.pos[1],imageWidthLocation.len[1]),"[^0-9]","","all")>
														<cfset imageHeightLocation = REFind('height\s?=\s?"[0-9]+"',imageTag,0,true)>
														<cfset imageHeight = REReplace(Mid(imageTag,imageHeightLocation.pos[1],imageHeightLocation.len[1]),"[^0-9]","","all")>
														<cfif imageWidth gt 100 and imageHeight gt 100>
															<cfif imageWidth lt imageHeight>
																<cfset newImageWidth = Ceiling(imageWidth/imageHeight * 100)>
																<cfset newImageHeight = 100>
															<cfelse>
																<cfset newImageHeight = Ceiling(imageHeight/imageWidth * 100)>
																<cfset newImageWidth = 100>
															</cfif>
														<cfelse>
															<cfset newImageHeight = imageHeight>
															<cfset newImageWidth = imageWidth>
														</cfif>
														<cfset blogImage = Replace(Replace(imageTag,'"#imageHeight#"','"#newImageHeight#"',"all"),'"#imageWidth#"','"#newImageWidth#"',"all")>
														<cfset filteredContent = REReplace(filteredContent,"<img.+?>",'','all')>
													</cfif>
													<cfset filteredContent = REReplace(filteredContent,"\[caption.+?/caption\](\r|\n)*","","all")>
													<cfset filteredContent = REReplace(filteredContent,"<img.+?>","","all")>
													<cfset filteredContent = REReplace(filteredContent,"</?strong.+?>","","all")>
													<cfset filteredContent = REReplace(filteredContent,"<a[^>]+>\s*?</a>","","all")>
													<cfset filteredContent = REReplace(filteredContent,"<p[^>]+>\s*?</p>","","all")>
													<cfset filteredContent = trim(filteredContent)>
													<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
													<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
													<cfset filteredContent = REReplace(filteredContent,"<h[0-9]>.+</h[0-9]>((\r|\n)+)?","","all")>
													<cfif REFind("\r|\n",filteredContent)>
														<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
													</cfif>
													<li class="blog-preview">
														<div class="head">
															<strong>#Blog.topic#</strong>
															<div>
																<em class="date">#DateFormat(Blog.post_date,"mm.dd.yy")#</em>
																<h3><a href="##">#LinkTo(controller="blog",action="#DateFormat(Blog.createdAt,'yyyy/mm/dd')#/#Blog.siloName#",text=Blog.post_title)#</a></h3>
															</div>
														</div>
														<cfif blogImage neq "">
															#blogImage#
														</cfif>
														<p>#filteredContent#</p>
													</li>
													</cfloop>
														<div class="head">
															<strong>Plastic Surgery</strong>
															<div>
																<em class="date">08.12.06</em>
																<h3><a href="##">Multiline header can go here</a></h3>
															</div>
														</div>
														<div class="visual">
															<div class="t">
																<div class="b">
																	<a href="##"><img src="/images/layout/img105.jpg" alt="image description" width="63" height="72" /></a>
																</div>
															</div>
														</div>
														<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam et libero augue, ut facilisis turpis. Phasellus venenatis odio vestibulum tortor imperdiet vulputate. Etiam eu est vel nulla porttitor mollis a a enim. Donec luctus . Quisque ac turpis diam, sed fermentum neque.</p>
													</li>
													<li>
														<div class="head">
															<strong>Surgery</strong>
															<div>
																<em class="date">08.12.06</em>
																<h3><a href="##">Multiline header can go here</a></h3>
															</div>
														</div>
														<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam et libero augue, ut facilisis turpis. Phasellus venenatis odio vestibulum tortor imperdiet vulputate. Etiam eu est vel mollis a a enim. Donec luctus fringilla </p>
													</li>
												</ul>
											</div>
										</div>
									</cfif>
								</cfif>

								<cfif params.action neq "reviews">
									#includePartial("/shared/quicksearchmini")#
								</cfif>
							</div>
							<!-- aside2 -->
							<div class="aside2">
								#includePartial("/shared/sharesidebox")#
								#includePartial("/shared/featureddoctor")#
								#includePartial(partial	= "/shared/ad", size="generic300x250" & (explicitAd IS TRUE ? "Explicit" : ""))#
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
									<a href="#URLFor(action='surgery')#">Surgery Guide Home</a>
									<a class="guide-title">#UCase(procedureInfo.name)# INFO</a>
									<div class="guide-list">
										<ul>
											<li>#LinkTo(controller=procedureInfo.siloName,class=Iif(params.action eq "procedure",DE("current"),DE("")),text="Overview")#</li>
											<cfloop query="subSections">
											<li>#LinkTo(controller=procedureInfo.siloName,action=subSections.siloName,class=Iif(params.action eq "guide" AND articleID eq subSections.ID,DE("current"),DE("")),text=subSections.name)#</li>
											</cfloop>
											<cfif commentCount gt 0>
											<li>#LinkTo(controller=procedureInfo.siloName,action="reviews",class=Iif(params.action eq "reviews",DE("current"),DE("")),text="Patient Reviews")#</li>
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
				</div>
			</div>
		</div>
	</div>
</cfoutput> --->