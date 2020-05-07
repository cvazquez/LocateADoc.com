<cfparam default="FALSE" name="isInfoGraphic" type="boolean">
<cfoutput>
	<!-- main -->
	<div id="main">
		#includePartial("/shared/breadcrumbs")#
		#includePartial(partial	= "/shared/ad", size="generic728x90top")#
		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder pattern-top article-container">
				#includePartial("/shared/pagetools")#

				<!-- content -->
				<div class="print-area" id="article-content" itemscope itemtype="http://schema.org/Article">
					<cfif params.action eq "articles" and listTitle neq "">
						<div class="blog-header">
							<h1 itemprop="name">#listTitle#</h1>
						</div>
					</cfif>
					<cfif params.action neq "article" and params.action neq "guide" and params.action neq "blog" and search.pages gt 1>
						<div class="pagination">#includePartial("/shared/_pagination.cfm")#</div>
					</cfif>
					<cfif isDefined("articleInfo") and articleInfo.recordcount>
						<cfloop query="articleInfo">
							<div class="article" itemscope itemtype="http://schema.org/Article">
								<cfset articleDate = (params.action eq "article" or params.action eq "articles") ? articleInfo.publishAt : articleInfo.createdAt>
								<cfif params.action neq "guide" and IsDate(articleDate)>
									<cfif DateDiff("yyyy",articleDate,now()) eq 0>
										<div class="dateflag"><time datetime="#DateFormat(articleDate,"yyyy/mm/dd")#" itemprop="datePublished">#Replace(DateFormat(articleDate,"mmm d")," ","<br>")#</time></div>
									<cfelse>
										<div class="dateflag"><time datetime="#DateFormat(articleDate,"yyyy/mm/dd")#" itemprop="datePublished">#Replace(DateFormat(articleDate,"mmm yyyy")," ","<br>")#</time></div>
									</cfif>
								</cfif>
								<cfif params.action eq "article" or params.action eq "guide">
									<article>
									<h1 class="blog-head" itemprop="name">#articleInfo.header#</h1>
									<cfif IsDate(articleDate)>
										<p class="post-date">posted on <time datetime="#DateFormat(articleDate,"yyyy/mm/dd")#" itemprop="datePublished">#DateFormat(articleDate,"m/d/yyyy")#</time></p>
									</cfif>
									<cfset filteredContent = articleInfo.content>
									<cfif Find("<h2",filteredContent) eq 0>
										<cfset filteredContent = REReplace(filteredContent,"h3","h2","all")>
									</cfif>
									<cfif articleInfo.id eq 3013>
										<cfset filteredContent = Replace(filteredContent,"&lceil;",'<a class="ftu_frame" id="ftu_link" style="display:inline-block;" href="http://www.facetouchup.com/virtual-plastic-surgery/l.php?id=lad">')>
										<cfset filteredContent = Replace(filteredContent,"&rfloor;",'</a>')>
									</cfif>
									<cfset filteredContent = replacenocase(filteredContent,"<img ",'<img itemprop="image" ', "all")>
									<span itemprop="articleBody">#filteredContent#</span>
									</article>
								<cfelse>
									<!--- <div class="photo"><img src="/images/layout/img2-photo.jpg" /></div> --->
									<h3 class="preview">#LinkTo(controller="article",
																action=articleInfo.siloName,
																text='<span itemprop="name">#articleInfo.title#</span>',
																itemprop="url")#</h3>
									<cfset filteredContent = articleInfo.content>
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
													<cfset newImageTag = REReplace(newImageTag,"<img ",'<img itemprop="image" ')>
													<cfset newImageTag = '<a href="/article/#articleInfo.siloName#" itemprop="url">' & newImageTag & '</a>'>
												<cfelseif ReFindNoCase("^Infographic:", articleInfo.title) AND articleInfo.OGIMAGE NEQ "">
													<cfset newImageTag = '<a href="/article/#articleInfo.siloName#" itemprop="url"><img itemprop="image" src="#articleInfo.OGIMAGE#" style="float: left; height: 100px;"></a>'>
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
									<!--- #articleInfo.teaser# --->
									<cfif REFind("\r|\n",filteredContent)>
										<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
									</cfif>
									#newImageTag & filteredContent#
								</cfif>
							</div>
							<div class="post-info">
								<cfif params.action eq "article">
									#includePartial(partial="/shared/sitewideminileadsidebox", isPopup=true)#
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
								<cfelse>
									<div class="readmore">
										#LinkTo(controller="article", action=articleInfo.siloName,text="read more")#
									</div>
								</cfif>
							</div>
							<cfif params.action eq "article" and params.preview neq 1>
								<!--- COMMENTS --->
								<div id="disqus_thread"></div>
								<script type="text/javascript">
								    var disqus_shortname = 'locateadoc';
								    var disqus_identifier = 'article_#articleInfo.ID#';
								    var disqus_url = 'http://www.locateadoc.com/article/#articleSiloName#';
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
					<form name="resultsForm" action="##" method="post"></form>
					<cfif params.action neq "article" and params.action neq "guide" and params.action neq "blog" and search.pages gt 1>
						<div class="pagination">#includePartial("/shared/_pagination.cfm")#</div>
					</cfif>
				</div>

				<!-- aside2 -->
				<div class="aside3" id="article-widgets">
					#includePartial(partial="/shared/sitewideminileadsidebox", isRedundant=(params.action eq "article"))#
					#includePartial(partial="/shared/sharesidebox",margins="10px 0")#
					<cfif isInfoGraphic>
						#includePartial("/askadoctor/latestquestions")#
						#includePartial("/shared/beautifulliving")#
					</cfif>
					#includePartial("/shared/beforeandaftersidebox")#
					#includePartial("/shared/featureddoctor")#
					<cfif NOT isInfoGraphic>
						#includePartial(partial	= "/shared/ad", size="generic300x250")#
						<!-- sidebox -->
						#includePartial("trendingtopics")#
						<!-- sidebox -->
						#includePartial("latestarticles")#
					<cfelse>
					</cfif>
				</div>

			</div>
		</div>
	</div>
</cfoutput>