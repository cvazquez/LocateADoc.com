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
				<a href="##specialtyGuides" data-role="button" data-icon="plus" data-theme="b" data-transition="flip" class="left-aligned">#specialtyInfo.name# Guides</a>
				<div class="title">
					<h1 class="page-title">#specialtyInfo.name# Guides</h1>
					<p>#mobileImageFormat(basicInfo.content)#</p>
				</div>
				<cfif isDefined("topArticles") and topArticles.recordcount>
					<h2>#specialtyInfo.name# Articles</h2>
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

				<h2>Popular Procedures <span>(#LinkTo(action="procedureList",text="view all procedures")#)</span></h2>
				<ul>
					<cfloop query="popularProcedures" endRow="10">
					<li class="#Iif(currentrow mod 2 eq 1,DE('left-side'),DE('right-side'))#">#LinkTo(controller=popularProcedures.siloName,text=popularProcedures.name)#</li>
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

<cfset ProcedureIds = "">
<cfsavecontent variable="additionalPages">
		<div id="specialtyGuides" data-role="page" data-url="specialtyGuides" data-transition="flip">
			<ul data-role="listview">
				<cfoutput><li data-role="list-divider">#specialtyInfo.name# Guides by Body Part</li></cfoutput>
				<cfoutput query="bodyParts" group="bodyRegionName">
				<li>
					<p>#bodyRegionName#</p>
					<ul>
						<cfoutput group="bodyPartName">
						<li class="sub-slide-block">
							<a class="sub-open-close" href="##">#bodyPartName#</a>
							<ul>
								<cfoutput>
								<li><a href="#URLFor(controller=bodyParts.siloName)#" <cfif ListFind(ProcedureIds,procedureId) eq 0>unique="1"</cfif>>#procedureName#</a></li>
								<cfset ProcedureIds = ListAppend(ProcedureIds,procedureId)>
								</cfoutput>
							</ul>
						</li>
						<!--- <li><a href="#URLFor(action='procedure',key='#procedureId#')#">#procedureName#</a> (0)</li> --->
						</cfoutput>
					</ul>
				</li>
				</cfoutput>
			</ul>
		</div>
</cfsavecontent>

<!--- <cfset javaScriptIncludeTag(source="resources/procedure-select", head=true)>
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
									<div class="cont-list cont-list2">
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
													<li>
														<h4>#linkTo(controller="article", action=topArticles.siloName, text="#topArticles.title#")#</h4>
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

								#includePartial("/shared/quicksearchmini")#
							</div>
							<!-- aside2 -->
							<div class="aside2">
								#includePartial("/shared/sharesidebox")#
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
</cfoutput> --->