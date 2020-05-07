<cfif NOT isMobile>
	<cfset styleSheetLinkTag(source="doctormarketing/addlisting", head=true)>
</cfif>
<cfoutput>
	<!-- main -->
	<div id="main" class="doctor-marketing-articles">
		<cfif NOT isMobile>
			#includePartial("/shared/breadcrumbs")#
		</cfif>
		<!--- #includePartial(partial	= "/shared/ad", size="generic728x90top")# --->
		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder pattern-top article-container">
				<cfif NOT isMobile>
					#includePartial("/shared/pagetools")#
				</cfif>

				<!-- content -->
				<div class="print-area" id="article-content">
					<cfif params.action eq "articles">
						<h1 class="blog-head"<cfif params.tag NEQ ""> <!--- style="margin: 0 0 15px;" ---></cfif>>Doctor Marketing Articles
							<cfif params.tag NEQ "">Search</cfif>
						</h1>
						<cfif search.pages gt 1>
							<div class="pagination">#includePartial("/shared/_pagination#mobileSuffix#.cfm")#</div>
						</cfif>
						<cfif params.tag NEQ "">
							<p <!--- style="margin-bottom: 20px;" --->>
							<span <!--- style="font: 18px/22px BreeBold, Arial, Helvetica, sans-serif; color: ##577b77;" --->>Results for: </span>#params.tag#
							</p>
						</cfif>
					</cfif>

					<form name="resultsForm" action="##" method="post">
					<cfif isDefined("articleInfo") and articleInfo.recordcount>
						<cfloop query="articleInfo">
							<div class="article">
								<cfset articleDate = articleInfo.publishAt>
								<cfif params.action eq "article">
									<!--- <div class="photo"><img src="/images/layout/img2-photo.jpg" /></div> --->
									<h1 class="blog-head">#articleInfo.title#</h1>
									<cfif IsDate(articleDate)>
										<p class="post-date">posted on #DateFormat(articleDate,"m/d/yyyy")#</p>
									</cfif>
									<cfset filteredContent = articleInfo.content>
									<cfif Find("<h2",filteredContent) eq 0>
										<cfset filteredContent = REReplace(filteredContent,"h3","h2","all")>
									</cfif>
									#filteredContent#
								<cfelse>
									<cfif DateDiff("yyyy",articleDate,now()) eq 0>
										<div class="dateflag">#Replace(DateFormat(articleDate,"mmm d")," ","<br>")#</div>
									<cfelse>
										<div class="dateflag">#Replace(DateFormat(articleDate,"mmm yyyy")," ","<br>")#</div>
									</cfif>
									<!--- <div class="photo"><img src="/images/layout/img2-photo.jpg" /></div> --->
									<h3 class="preview">#LinkTo(controller="doctorMarketing", action=articleInfo.siloName ,text=articleInfo.title)#</h3>
									<cfset filteredContent = REReplace(articleInfo.content,"<[^<]+?>","","all")>
									<cfset filteredContent = Replace(filteredContent,"&nbsp;"," ","all")>
									<cfset filteredContent = trim(filteredContent)>
									<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
									<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
									<!--- #articleInfo.teaser# --->
									<cfif REFind("\r|\n",filteredContent)>
										<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
									</cfif>
									#filteredContent#
								</cfif>
							</div>
							<div class="post-info">
								<cfif params.action eq "article">
									<cfif ListLen(articleInfo.specialtyIDs) + ListLen(articleInfo.procedureIDs)>
										<div class="metadata">
											posted in
											<cfset postList = "">
											<cfloop from="1" to="#ListLen(articleInfo.specialtyIDs)#" index="i">
												<cfset postList = ListAppend(postList,LinkTo(action="articles",key="specialty-#ListGetAt(articleInfo.specialtyIDs,i)#",text=ListGetAt(articleInfo.specialties,i)))>
											</cfloop>
											<cfloop from="1" to="#ListLen(articleInfo.procedureIDs)#" index="i">
												<cfset postList = ListAppend(postList,LinkTo(action="articles",key="procedure-#ListGetAt(articleInfo.procedureIDs,i)#",text=ListGetAt(articleInfo.procedures,i)))>
											</cfloop>
											#postList#
										</div>
									</cfif>
									<cfif ListLen(articleInfo.metaKeywords)>
										<div class="metadata">
											tags:
											<cfloop list="#articleInfo.metaKeywords#" index="keyword">
												#linkTo(action="articles",key="tag-#trim(keyword)#",text=keyword)#<cfif keyword neq ListLast(articleInfo.metaKeywords)>,</cfif>
											</cfloop>
										</div>
									</cfif>
								<cfelse>
									<div class="readmore">
										#LinkTo(controller="doctorMarketing", action=articleInfo.siloName ,text="read more")#
									</div>
								</cfif>
							</div>
							<cfif params.action eq "article" and params.preview neq 1>
								<!--- COMMENTS --->
								<div id="disqus_thread"></div>
								<script type="text/javascript">
								    var disqus_shortname = 'locateadoc';
								    var disqus_identifier = 'article_#articleInfo.ID#';
								    var disqus_url = 'http://www.locateadoc.com/doctor-marketing/#articleSiloName#';
								    <cfif Globals.domain eq "dev3.locateadoc.com">
								    	var disqus_developer = 1;
								    </cfif>

								    <!--- (function() { --->
								    $(function(){
								        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
								        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
								        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
								    <!--- })(); --->
								    });
								</script>
								<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
							</cfif>
						</cfloop>
					<cfelseif isDefined("articleInfo") and articleInfo.recordcount EQ 0>
						<p>There are no results for your search. Please <a href="/doctor-marketing/articles">browse our other articles.</p>
						<cfset donotindex = 1>
					</cfif>
					</form>
					<cfif params.action eq "articles" and search.pages gt 1>
						<div class="pagination">#includePartial("/shared/_pagination#mobileSuffix#.cfm")#</div>
					</cfif>
				</div>

				<!-- aside2 -->
				<div class="aside3" id="article-widgets">
					<cfif NOT isMobile>
						#includePartial("/shared/sharesidebox")#
					</cfif>
					<div class="mobileWidget">
						#includePartial(partial="addlistingform")#
					</div>
					<cfif NOT isMobile>
						<div class="ad">
							<div class="ad-heading">Advertisement</div>
							<a href="http://www.practicedock.com/index.cfm/PageID/7150/index.cfm?campaignId=70160000000MD6b" target="_blank">
								<img src="http://#Globals.domain#/images/doctors_only/PD banner ad.jpg">
							</a>
						</div>
					</cfif>
				</div>
			</div>
		</div>
	</div>
</cfoutput>