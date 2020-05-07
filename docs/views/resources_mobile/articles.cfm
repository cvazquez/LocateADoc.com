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
				<div class="title">
					<h1 class="page-title">#headerContent.title#</h1>
					<p>#headerContent.content#</p>
				</div>
				<a href="##specialtyArticles" data-role="button" data-icon="plus" data-theme="b" data-transition="flip" class="left-aligned">Articles by Specialty</a>
				<cfif isDefined("latestArticles") and latestArticles.recordcount>
					<h2>Latest Articles <span>(#linkTo(text="view all articles", action="articles", key="show-all", rel="external")#)</span></h2>
					<div class="cont-list">
						<ul>
							<cfloop query="latestArticles">
								<li>
									<div class="head">
										<em class="date">#DateFormat(latestArticles.createdAt,"mm.dd.yy")#</em>
										<h3>#linkTo(text=latestArticles.title, controller="article", action=latestArticles.siloName)#</h3>
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
									#filteredContent#
								</li>
							</cfloop>
						</ul>
					</div>
				</cfif>

				<h2>Popular Procedures <span>(#LinkTo(action="procedureList",text="view all procedures")#)</span></h2>
				<ul>
					<cfloop query="popularProcedures" endRow="10">
					<li class="#Iif(currentrow mod 2 eq 1,DE('left-side'),DE('right-side'))#">#LinkTo(action='articles',key='procedure-'&popularProcedures.id,text=popularProcedures.name)#</li>
					</cfloop>
				</ul>

				<div class="swm">
					<h2>Contact A Doctor</h2>
					#includePartial("/mobile/mini_form")#
				</div>
			</div>
		</div>
	</div>
</cfoutput>

<cfsavecontent variable="additionalPages">
	<cfoutput>
		<div id="specialtyArticles" data-role="page" data-url="specialtyArticles" data-transition="flip">
			<ul data-role="listview">
				<li data-role="list-divider">Articles by Specialty</li>
				<cfloop query="specialtyArticles">
					<li>#LinkTo(action='articles',key='specialty-'&specialtyArticles.id,text=specialtyArticles.name)#</li>
				</cfloop>
			</ul>
		</div>
	</cfoutput>
</cfsavecontent>

<!--- <cfoutput>
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
												<li>
													<div class="head">
														<div>
															<h3>#linkTo(text=latestArticles.title, controller="article", action=latestArticles.siloName)#</h3>
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
													<p class="guide-description">#filteredContent#</p>
													#linkTo(text="VIEW ARTICLE", controller="article", action=latestArticles.siloName, class="view-link")#
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
													<li>#LinkTo(action='articles',key='specialty-'&specialtyArticles.id,text=specialtyArticles.name)#</li>
												</cfloop>
											</ul>
										</div>
								</div>
							</div>
							<div class="b">&nbsp;</div>
						</div>
						#includePartial("/shared/sponsoredlink")#
						#includePartial("/mobile/mini_form")#
						<!-- side-ad -->
						#includePartial(partial="/shared/ad", size="generic160x600")#
					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput> --->