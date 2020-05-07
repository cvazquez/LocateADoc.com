<cfset styleSheetLinkTag(source="doctorsonly/addlisting", head=true)>
<cfoutput>
	<!-- main -->
	<div id="main">
		#includePartial("/shared/breadcrumbs")#
		<!--- #includePartial(partial	= "/shared/ad", size="generic728x90top")# --->
		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder pattern-top article-container">
				#includePartial("/shared/pagetools")#

				<!-- content -->
				<div class="print-area" id="article-content">
					<cfif params.action eq "articles" and search.pages gt 1>
						<div class="pagination">#includePartial("/shared/_pagination.cfm")#</div>
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
									<h3 class="preview">#LinkTo(action="article",key=articleInfo.id,text=articleInfo.title)#</h3>
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
										#LinkTo(action="article",key=articleInfo.id,text="read more")#
									</div>
								</cfif>
							</div>
							<cfif params.action eq "article">
								<!--- COMMENTS --->
								<div id="disqus_thread"></div>
								<script type="text/javascript">
								    var disqus_shortname = 'locateadoc';
								    var disqus_identifier = 'article_#articleInfo.ID#';
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
					</cfif>
					</form>
					<cfif params.action eq "articles" and search.pages gt 1>
						<div class="pagination">#includePartial("/shared/_pagination.cfm")#</div>
					</cfif>
				</div>

				<!-- aside2 -->
				<div class="aside3" id="article-widgets">
					#includePartial("/shared/sharesidebox")#
					#includePartial(partial="addlistingform")#
					<div class="ad">
						<div class="ad-heading">Advertisement</div>
						<a href="http://www.practicedock.com/index.cfm/PageID/7150/index.cfm?campaignId=70160000000MD6b" target="_blank">
							<img src="http://#Globals.domain#/images/doctors_only/PD banner ad.jpg">
						</a>
					</div>
					<!--- #includePartial("/shared/sharesidebox")#
					<!--- <!-- sidebox -->
					<div class="sidebox">
						<div class="frame">
							<h4>Blog <strong>Roll</strong></h4>
							<ul>
								<cfloop query="blogRoll">
									<li>#LinkTo(action="blog",key=blogRoll.ID,text=blogRoll.post_title)#</li>
								</cfloop>
							</ul>
						</div>
					</div>
					<!-- sidebox -->
					<div class="sidebox">
						<div class="frame">
							<h4>Helpful <strong>Links</strong></h4>
							<ul>
							<li><a href="##">Cosmetic Surgery Articles</a></li>
							<li><a href="##">Find a Cosmetic Surgeon</a></li>
							<li><a href="##">Find a Plastic Surgeon</a></li>
							</ul>
						</div>
					</div> --->
					#includePartial("/shared/beforeandaftersidebox")#
					#includePartial("/shared/featureddoctor")#
					#includePartial(partial	= "/shared/ad", size="generic300x250")#
					<!-- sidebox -->
					<div class="sidebox trending">
						<div class="frame">
							<h4>Trending <strong>Topics</strong></h4>
							<ul>
							<cfloop query="trendingTopics">
								<cfif specialtyId gt 0>
									<li><a href="#URLFor(action='specialty',key=trendingTopics.specialtyID)#">#specialtyname# Guide</a></li>
								<cfelse>
									<li><a href="#URLFor(action='procedure',key=trendingTopics.procedureID)#">#procedurename# Guide</a></li>
								</cfif>
							</cfloop>
							</ul>
						</div>
					</div>
					<!-- sidebox -->
					<div class="sidebox">
						<div class="frame">
							<h4 class="withsubtitle">Latest <strong>Articles</strong></h4>
							<h3 class="subtitle">from LocateADoc.com</h3>
							<ul class="latestArticles">
							<cfloop query="latestArticles">
								<li>#linkTo(action="article",key=latestArticles.id,text=latestArticles.title)#</li>
							</cfloop>
							</ul>
							#linkTo(action="articles",text="view all articles")#
						</div>
					</div> --->
				</div>

			</div>
		</div>
	</div>
</cfoutput>