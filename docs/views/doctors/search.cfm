<cfset javaScriptIncludeTag(source="doctors/search", head=true)>
<cfif not isMobile><cfset styleSheetLinkTag(source="doctors/search", head=true)></cfif>
<cfoutput>
	<div id="main">
	<cfif NOT isMobile>
		#includePartial("/shared/breadcrumbs")#
		#includePartial(partial	= "/shared/ad",
						size	= "generic728x90top")#
	</cfif>
		<div class="container inner-container">
			<div class="inner-holder">
				<cfif NOT isMobile>#includePartial("/shared/pagetools")#</cfif>
				<div id="content">
					#includePartial(partial="/shared/featureddoctors2", doctors=search.featured)#
					<div class="content">
						<div class="widget">
							<div class="search-ttl">
								<cfif search.results.recordcount and search.landingHeader neq "">
									<cfif search.page eq 1>
										<h1>#search.landingHeader#</h1>
										<cfif search.landingContent neq "">
											<div class="landing-content">


												<!--- Calculate the word count of the content --->
												<cfset landingContent = {}>
												<cfset landingContent.wordCutOff = 200>
												<cfset landingContent.hasDivs = FALSE>

												<!--- Strip all HTML tags so we don't include them in the word count --->
												<cfset landingContent.htmlStripped = reReplaceNoCase(search.landingContent, "<[^>]+>", "", "all")>

												<!--- Use \S to get a count of the number of spaces between each work and count them as a work boundary, and reMatch will turn each word into an array element --->
												<cfset landingContent.words = reMatch("[\S]+",landingContent.htmlStripped)>

												<!--- The word count is the number of array elements, 1 element per word --->
												<cfset landingContent.wordCount = arrayLen(landingContent.words)>

												<!--- Check if the content was already hidden when entered And if the number of words is greater than 200 --->
												<cfif NOT FindNoCASE("ContentIntroShowMore", search.landingContent) AND landingContent.wordCount GT landingContent.wordCutOff>

													<!--- Create an array of paragraphs and save the number of paragraphs --->
													<cfset landingContent.paragraphs = reMatch("<p[^>]*>(.*?)</p>", search.landingContent)>

													<cfif arrayLen(landingContent.paragraphs) EQ 0>
														<!--- check for div's --->
														<cfset landingContent.paragraphs = reMatch("<div[^>]*>(.*?)</div>", search.landingContent)>
														<cfset landingContent.hasDivs = TRUE>
													</cfif>

													<cfset landingContent.paragraphCount = arrayLen(landingContent.paragraphs)>

													<!--- Initial the number of words appended for each paragraph --->
													<cfset landingContent.paragraphStrippedWordCountTotal = 0>

													<!--- Flag weather the show more link was displayed yet --->
													<cfset landingContent.showMore = false>

													<!--- Loop through each paragraph --->
													<cfif landingContent.paragraphCount GT 0>
														<cfloop array="#landingContent.paragraphs#" index="thisP">

															<!--- Strip HTML tags in each paragraph to obtain a valid word count of the paragraph --->
															<cfset landingContent.paragraphStripped = reReplaceNoCase(thisP, "<[^>]*>", "", "all")>
															<cfset landingContent.paragraphStrippedWordCount = arrayLen(reMatch("[\S]+",landingContent.paragraphStripped))>

															<!--- Append this paragraphs word count to the total word count of previous paragraphs, so we know when to start hiding paragraphs --->
															<cfset landingContent.paragraphStrippedWordCountTotal = landingContent.paragraphStrippedWordCountTotal + landingContent.paragraphStrippedWordCount>

															<!--- When the word count reaches 200, we start hidding paragraphs --->
															<cfif landingContent.paragraphStrippedWordCountTotal GTE landingContent.wordCutOff>

																<!--- If this is the first paragraph to hide, then display the Show More link to reveal the hidden paragraphs --->
																<cfif landingContent.showMore IS FALSE>

																	<script language="javascript">
																		$('<span id="ContentIntroShowMore" style="margin-left: 3px; margin-top: 0px!important;">Read more</span>').appendTo($("<cfif landingContent.hasDivs>div<cfelse>p</cfif>:last"));
																	</script>
																	<!--- <span id="ContentIntroShowMore" style="margin-top: 0px!important;">Show More</span> --->
																	<cfset landingContent.showMore = TRUE>
																</cfif>

																<!--- Add the ContentIntro class to the paragraph, which will hide the paragraph --->
																<cfif landingContent.hasDivs>
																	<cfset thisP = replaceNoCase(thisP, "<div", '<div class="ContentIntro" ')>
																<cfelse>
																	<cfset thisP = replaceNoCase(thisP, "<p", '<p class="ContentIntro" ')>
																</cfif>
															</cfif>

															<!--- Ouput the paragraph, with or without the hidden class --->
															#thisP#
														</cfloop>
													<cfelse>
														#search.landingContent#
													</cfif>

													<div style="clear: both; padding-top:10px;"></div>
												<cfelse>
													#search.landingContent#
												</cfif>

												<!--- <p>numberOfWords = #landingContent.wordCount#<br />
												paragraph break positions  --->
												<!--- <cfdump var="#landingContent.paragraphEndPos#"><br />
												<cfdump var="#landingContent.words#"></p> --->

												<!--- <cfdump var="#landingContent#"> --->

												<!--- <cfif landingContent.wordCount LTE 1000>
													#search.landingContent#
												<cfelse>
													<cfif landingContent.paragraphEndPos.pos[1] LT 1000 AND landingContent.htmlStrippedLength GT 1000<!---  AND landingContent.paragraphEndPos.pos[1] LTE 1000 --->>
														#mid(search.landingContent, 1, landingContent.paragraphEndPos.pos[1] + 4)#
														<span id="ContentIntroShowMore">Show More</span>

														<cfset landingContent.hiddenContent = mid(search.landingContent, landingContent.paragraphEndPos.pos[1] + 4, len(search.landingContent))>
														<div class="ContentIntro">#landingContent.hiddenContent#</div>
														<div style="clear: both; padding-top:20px;">
													</cfif>
												</cfif> --->
											</div>
											<h2>#search.landingSubHeader#:</h2>
										</cfif>
									<cfelseif search.landingSubHeader neq "">
										<h2>#search.landingSubHeader#:</h2>
									</cfif>
								<cfelseif search.results.recordcount and search.searchSummary neq "">
									<h1>#search.searchSummary#</h1>
								<cfelse>
									<h1>Search Results</h1>
									<cfif search.results.recordcount eq 0>
										<br style="clear:both;">
										<p>No doctors were found<cfif search.searchSummary neq ""> for #trim(LCase(search.searchSummary))#</cfif>.</p>
										<cfif (val(params.city) gt 0 and val(params.state) gt 0) or val(params.zipCode) gt 0>
											<p>There may be doctors in nearby areas. Try <cfif val(params.distance)>increasing the distance of<cfelse>adding a distance to</cfif> your search with the distance filter on the left side.</p>
											<p>#linkTo(text="You can also return to the search form and modify your search by clicking here.", controller="doctors", action="index", key="modify")#</p>
										<cfelse>
											<p>#linkTo(text="Return to the search form to modify your search", controller="doctors", action="index", key="modify")#</p>
										</cfif>
									</cfif>
								</cfif>
								<cfif search.results.recordcount>
									<div class="add">
										<span>(#search.totalrecords# results)</span>
										<ul>
											<li id="list-on" class="hidden"><a href="javascript:toggleMap();" class="view-link">view as a list</a></li>
											<li id="map-on"><a href="javascript:toggleMap();" class="map-link">view on a map</a></li>
										</ul>
										#includePartial("/shared/_pagination#mobileSuffix#.cfm")#
									</div>
								</cfif>
							</div>
							<cfif search.results.recordcount AND isdefined("search.results.firstName")>
								<div class="map-view" id="map-view" style="display:none;">
									#includePartial("_map.cfm")#
								</div>
								<div class="compare-box">
									<a href="##" class="btn-compare" onclick="compareDoctors(); return false;">COMPARE</a>
									<span>Check the boxes to compare.</span>
								</div>
							</cfif>
							<div class="print-area">
							<div class="cont-list cont-list3">
								<form name="resultsForm" action="##" method="post">
									<input type="hidden" name="originalFilter" value="#params.originalFilter#">
								</form>
										<ul>
											<cfif isdefined("search.results.firstname")>
											<cfloop query="search.results">
												<!--- format full name --->
												<cfset fullName = "#search.results.firstname# #Iif(search.results.middlename neq '',DE(search.results.middlename&' '),DE('')) & search.results.lastname#">
												<cfif LCase(search.results.title) eq "dr" or LCase(search.results.title) eq "dr.">
													<cfset fullName = "Dr. #fullName#">
												<cfelseif search.results.title neq "">
													<cfset fullName &= ", #search.results.title#">
												</cfif>
												<!--- format phone number --->
												<cfset formattedPhone = formatPhone(search.results.phone)>

												<!--- Type 1 --->
												<cfif search.results.inforank eq 2 or search.results.isFeatured>
													<li class="profile-box profile-featured-box">
														<span class="check"><input class="chk" type="checkbox" value="#currentrow#" /></span>
														<cfif search.results.photoFilename neq "" and search.results.isFeatured eq 1>
															<div style="float:left;">
																<div class="photo">
																	<a href="/#search.results.siloName#?l=#search.results.locationID#">
																		<img width="113" height="129" alt="#fullName#" src="#Globals.doctorPhotoBaseURL & search.results.photoFilename#" />
																	</a>
																</div>
																<!--- <cfif search.results.showTopDocSeal>
																	<div id="top-doc-search" class="tooltip" title="TOP DOCTOR | To qualify as a Top Doctor, a practice must have met a high<br />engagement level with contributions to LocateADoc.com, have<br />a majority of positive comments and reviews, and have a<br />medical license and/or training in the specialty listed.">
																		<img src="/images/layout/top_doctor_2012.png">
																	</div>
																</cfif> --->
															</div>
															<div class="text-box">
														<cfelse>
															<div class="text-box full-text">
														</cfif>
															<div class="tb-hold">
																<div class="tb-add">
																	<div class="pincontainer hidden" id="pin_#id#"></div>
																	<ul class="doc-list noseperator w270"<!---  style="width:270px;" --->>
																		<li><h3>#linkTo(text=fullName, href="/#search.results.siloName#?l=#search.results.locationID#")#</h3></li>
																		<li><strong class="practice-name">#search.results.practice#</strong></li>
																		<li class="address1">#FormalCapitalize(search.results.address)#</li>
																		<li class="address2">#search.results.city#, #search.results.state# #search.results.postalCode#</li>
																	</ul>

																	<div class="row">
																		<cfif formattedPhone neq "">
																		<dl>
																			<dt>P:</dt>
																			<dd>#formattedPhone#</dd>
																		</dl>
																		</cfif>
																		<cfif val(comments) gt 0>
																		<dl>
																			<a title="Patient Reviews" href="/#search.results.siloName#/reviews?l=#search.results.locationID#">
																			<dt><img width="25" height="20" alt="image description" src="/images/layout/ico-comments.png" class="png" /></dt>
																			<dd>#comments# <cfif isMobile>Reviews</cfif></dd>
																			</a>
																		</dl>
																		</cfif>
																	</div>
																</div>
																<strong class="specialty" <!--- style="width:250px; text-align:right;" --->>#search.results.specialtylist#</strong>
																<div class="badge-list">
																	<cfif search.results.showTopDocSeal>
																		<div id="top-doc-search" class="tooltip badgeTopDoctor" title="TOP DOCTOR | <div style='width:200px;'>To qualify as a Top Doctor, a practice must have met a high engagement level with contributions to LocateADoc.com, have a majority of positive comments and reviews, and have a medical license and/or training in the specialty listed.</div>">
																			<a href="/#search.results.siloName#?l=#search.results.locationID#"><img src="http://#Globals.domain#/images/layout/badges/topdoctor_current_small.png"></a>
																			<span><a href="/#search.results.siloName#?l=#search.results.locationID#">Top Doctor</a></span>
																		</div>
																	</cfif>
																	<cfif search.results.isAdvisoryBoard>
																		<div class="tooltip badgeAdvisoryBoard" title="ADVISORY BOARD MEMBER | <div style='width:200px;'>The LocateADoc Advisory Board is compiled of a small group of elite medical industry professionals involved in performing various treatments and procedures patients search for on LocateADoc.com. The Board provides beneficial industry insights to the LocateADoc team, honest feedback and constructive criticism on current and new patient needs and overall business direction as it relates to industry trends. The Board and Executive Management continuously explore ways to build trust and ensure potential patients have the best user experience, every time, when searching for a doctor on LocateADoc.com.</div>">
																			<img src="/images/layout/badges/advisory_2013_small.jpg">
																			<span><a href="/#search.results.siloName#?l=#search.results.locationID#">Advisory Board</a></span>
																		</div>
																	</cfif>
																</div>
															</div>
															<div class="details">
															<cfif search.results.topprocedures neq "" or search.results.description neq "">
																	<cfif search.results.description neq ""><div class="listing-description" style="display:inline-block;"><p>#search.results.description#</p></div></cfif>
																	<cfif search.results.topprocedures neq ""><p><strong>Most Popular Procedures:</strong> #search.results.topprocedures#</p></cfif>
															</cfif>
															</div>
														</div>
													</li>
												<!--- Type 2 --->
												<cfelseif search.results.inforank eq 1 or search.results.isBasicPlus>
													<li class="profile-box profile-basicplus-box">
														<span class="check"><input class="chk" type="checkbox" value="#currentrow#" /></span>
														<div class="text-box full-text">
															<div class="tb-hold">
																<div class="tb-add">
																	<ul class="doc-list noseperator">
																		<li class="pincontainer hidden" id="pin_#id#"></li>
																		<li class="noseperator"><h3>
																		<cfif search.results.isYext AND trim(fullName) eq "">
																			#linkTo(text=search.results.practice, href="/#search.results.siloName#?l=#search.results.locationID#")#
																		<cfelse>
																			#linkTo(text=fullName, href="/#search.results.siloName#?l=#search.results.locationID#")#
																		</cfif>
																		</h3></li>
																		<cfif not (search.results.isYext AND trim(fullName) eq "")>
																			<li class="noseperator practice-name"><strong>#search.results.practice#</strong></li>
																		</cfif>
																		<li class="address1">#FormalCapitalize(search.results.address)#</li>
																		<li class="address2">#search.results.city#, #search.results.state# #search.results.postalCode#</li>
																		<cfif search.results.isYext AND formattedPhone neq "">
																			<li class="noseperator listing-phone">P: #formattedPhone#</li>
																		</cfif>
																	</ul>
																</div>
																<strong class="specialty"<!---  style="width:250px; text-align:right;" --->>#search.results.specialtylist#</strong>
															</div>
															<div class="listing-description" style="display: inline-block;"><p></p></div>
														</div>
														<div class="details">
														<cfif search.results.topprocedures neq "" or search.results.description neq "">
																<cfif search.results.description neq ""><div class="listing-description"><p>#search.results.description#</p></div></cfif>
																<cfif search.results.topprocedures neq ""><p><strong>Most Popular Procedures:</strong> #search.results.topprocedures#</p></cfif>
														</cfif>
														</div>
													</li>
												<!--- Type 3 --->
												<cfelse>
													<li class="profile-box profile-basic-box">
														<span class="check"><input class="chk" type="checkbox" value="#currentrow#" /></span>
														<div class="text-box full-text">
															<div class="tb-hold">
																<div class="tb-add">
																	<ul class="doc-list noseperator w430"<!---  style="width:430px;" --->>
																		<li class="pincontainer hidden" id="pin_#id#"></li>
																		<li class="noseperator"><h3>
																		<cfif search.results.isYext AND trim(fullName) eq "">
																			#linkTo(text=search.results.practice, href="/#search.results.siloName#?l=#search.results.locationID#")#
																		<cfelse>
																			#linkTo(text=fullName, href="/#search.results.siloName#?l=#search.results.locationID#")#
																		</cfif>
																		</h3></li>
																		<cfif not (search.results.isYext AND trim(fullName) eq "")>
																			<li class="noseperator practice-name"><strong>#search.results.practice#</strong></li>
																		</cfif>
																		<li class="address1">#FormalCapitalize(search.results.address)#</li>
																		<li class="address2">#search.results.city#, #search.results.state# #search.results.postalCode#</li>
																		<cfif search.results.isYext AND formattedPhone neq "">
																			<li class="noseperator listing-phone">P: #formattedPhone#</li>
																		</cfif>
																	</ul>
																</div>
																<strong class="specialty"<!---  style="width:250px; text-align:right;" --->>#search.results.specialtylist#</strong>
															</div>
															<div class="listing-description" style="display: inline-block;"><p></p></div>
														</div>
														<div class="details">
														<cfif search.results.topprocedures neq "" or search.results.description neq "">
																<cfif search.results.description neq ""><div class="listing-description"><p>#search.results.description#</p></div></cfif>
																<cfif search.results.topprocedures neq ""><p><strong>Most Popular Procedures:</strong> #search.results.topprocedures#</p></cfif>
														</cfif>
														</div>
													</li>
												</cfif>
												<!--- Content for compare tool --->
												<li class="hidden" id="compare_#currentrow#">
													<ul>
														<li contentfor="name">
															<cfif search.results.photoFilename neq "" and search.results.isFeatured eq 1>
															<img class="soft-border-image" width="63" height="72" alt="#fullName#" src="#Globals.doctorPhotoBaseURL & search.results.photoFilename#" />
															</cfif>
															#linkTo(text=(trim(fullName) eq "" ? search.results.practice : fullName), href="/#search.results.siloName#?l=#search.results.locationID#")#
															<cfif trim(fullName) neq "">
																<br><strong>#search.results.practice#</strong>
															</cfif>
														</li>
														<li contentfor="location"><span>Location:</span> #REReplace(ReplaceNoCase(Address,'##','Ste. '),'(\&\w+;([bB][rR])?)|(</?[bB][rR]>?)',' ','all')# #City#, #abbreviation# #postalCode#</li>
														<li contentfor="phone">
															<cfif trim(formattedPhone) neq "">
																<span>Phone:</span> #formattedPhone#
															<cfelse>
																#linkTo(text="Click here for phone number", href="/#search.results.siloName#/contact?l=#search.results.locationID#")#
															</cfif>
														</li>
														<li contentfor="distance"><cfif distance gt 0><span>Distance:</span> #REReplace(NumberFormat(distance,"9.9"),"\.?0+$","")# mile<cfif REReplace(NumberFormat(distance,"9.9"),"\.?0+$","") neq "1">s</cfif></cfif></li>
														<li contentfor="procedure">
															<cfif ListLen(search.results.topprocedures) gt 0>
																<span>Top Procedures:</span>
																<ul>
																<cfloop list="#search.results.topprocedures#" index="topprocedure">
																	<li>#trim(topprocedure)#</li>
																</cfloop>
																</ul>
															</cfif>
														</li>
														<li contentfor="languages">
															<cfif trim(languagesSpoken) neq "">
																<span>Languages Spoken:</span>
																<ul>
																	<cfloop list="#languagesSpoken#" index="i"><li>#i#</li></cfloop>
																</ul>
															</cfif>
														</li>
														<li contentfor="experience">
															<cfif val(yearStartedPracticing) neq 0>
																<span>Experience:</span> #yearStartedPracticing#
															<cfelseif val(yearsInPractice) gt 0>
																<span>Experience:</span> #yearsInPractice# years
															</cfif>
														</li>
														<li contentfor="financing">
															<cfif ListLen(financingoptions) gt 0>
																<span>Financing:</span>
																<ul>
																	<cfloop list="#financingoptions#" index="i"><li>#i#</li></cfloop>
																</ul>
															</cfif>
														</li>
														<li contentfor="comments">
															<cfif val(comments) gt 0>
															<dl>
																<a title="Patient Reviews" href="/#search.results.siloName#/reviews?l=#search.results.locationID#">
																<dt><img width="25" height="20" alt="image description" src="/images/layout/ico-comments.png" class="png" /></dt>
																<dd>#comments# <cfif isMobile>Reviews</cfif></dd>
																</a>
															</dl>
															</cfif>
														</li>
														<li contentfor="button">
															#linkTo(text="CONTACT DOCTOR", href="/#search.results.siloName#/contact?l=#search.results.locationID#", class="btn-compare-contact")#
														</li>
													</ul>
												</li>
											</cfloop>
											</cfif>
										</ul>
							</div>
							</div>
						</div>
						<cfif search.results.recordcount>
							<div class="pager-hold">
								<a href="##" class="btn-compare" onclick="compareDoctors(); return false;">COMPARE</a>
								#includePartial("/shared/_pagination#mobileSuffix#.cfm")#
							</div>
						</cfif>
					</div>
					#includePartial(partial	= "/shared/ad",
									size	= "generic728x90bottom")#
				</div>
				<div id="sidebar">
					<div class="search-box doctorSearchBoxFilters">
						#includePartial("_filters.cfm")#
					</div>
					#includePartial("/shared/sponsoredlink")#
					#includePartial(partial	= "/shared/ad",
									size	= "generic160x600")#
				</div>
			</div>
		</div>
	</div>
</cfoutput>

<div class="compare-modal hidefirst">
	<center>
		<table class="modal-box">
			<tr class="row-buttons">
				<td colspan="2"><div class="closebutton" onclick="compareClose(); return false;"></div></td>
			</tr>
			<tr class="row-t">
				<td class="l-t"></td>
				<td class="t"></td>
			</tr>
			<tr class="row-c">
				<td class="l"></td>
				<td class="c">
					<h2>Compare Doctors</h2>
					<div class="comparison-scroll">
					<table class="comparisons">
						<tr id="compare_name"></tr>
						<tr id="compare_location"></tr>
						<tr id="compare_phone"></tr>
						<tr id="compare_distance"></tr>
						<tr id="compare_procedure" class="comments-divider"></tr>
						<tr id="compare_languages" class="comments-divider"></tr>
						<tr id="compare_experience"></tr>
						<tr id="compare_financing"></tr>
						<tr id="compare_comments" class="comments-summary comments-divider"></tr>
						<tr id="compare_button"></tr>
					</table>
					</div>
				</td>
			</tr>
			<tr class="row-b">
				<td class="l-b"></td>
				<td class="b"></td>
			</tr>
		</table>
	</center>
</div>