<cfoutput>
	<!-- main -->
	<div id="main">
		#includePartial("/shared/breadcrumbs")#
		#includePartial(partial	= "/shared/ad",	size = "generic728x90top")#
		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder pattern-top article-container">
				#includePartial("/shared/pagetools")#

				<!-- content -->
				<div class="print-area" id="article-content">
					<form name="resultsForm" action="##" method="post">
					<cfif isDefined("articleInfo") and articleInfo.recordcount>
						<cfloop query="articleInfo">
							<div class="article" itemscope itemtype="http://schema.org/Blog">
								<article>
								<h1 class="blog-head" itemprop="name">#articleInfo.title#</h1>
								<p class="post-date">
									posted on <time datetime="#DateFormat(articleInfo.createdAt,"yyyy/mm/dd")#" itemprop="datePublished">#DateFormat(articleInfo.createdAt,"m/d/yyyy")#</time> by
									<cfif articleInfo.authorShipHandle NEQ ''>
										<a href="/resources/authors-list/#articleInfo.authorShipHandle#">
									</cfif>
									<span itemprop="author">#articleInfo.author#</span>
									<cfif articleInfo.authorShipHandle NEQ ''></a></cfif>
								</p>
								<!--- <p class="post-date">posted on #DateFormat(articleInfo.createdAt,"m/d/yyyy")# by
									<cfif trim(articleInfo.googlePlusLink) NEQ "">
										<a rel="author" href="#articleInfo.googlePlusLink#/about?rel=author" target="GooglePlus#replace(articleInfo.author, ' ', '', 'all')#">
									</cfif>
									#articleInfo.author#
									<cfif trim(articleInfo.googlePlusLink) NEQ ""></a></cfif>
								</p> --->
								<cfset filteredContent = REReplace(articleInfo.content,"(\r|\n)+","</p><p>","all")>

								<!--- Check if the contect doesn't start with a paragraph tag and add one if it doesn't
								--->
								<cfif NOT reFindNoCase("^<p[^>]*>", filteredContent)>
									<cfset filteredContent = "<p>" & filteredContent>
								</cfif>

								<cfset filteredContent = replacenocase(filteredContent, "<img ", '<img itemprop="image" ', "all")>
								<!--- <cfset filteredContent = REReplace(filteredContent,"h3","h2","all")> --->
								<!--- <cfset filteredContent = REReplace(filteredContent,"\[/?caption.*?\]","","all")> --->
								<div class="blog-entry" itemprop="blogPost">#filteredContent#</div>
								</article>
							</div>
							<cfif <!--- ListLen(articleInfo.categories) or ---> ListLen(articleInfo.tags)>
								<div class="post-info">
									<!--- <cfif ListLen(articleInfo.categories)>
										<div class="metadata">
											categories:
											<cfloop list="#articleInfo.categories#" index="keyword">
												#linkTo(action="blogList",key="#trim(keyword)#",text=keyword)#<cfif keyword neq ListLast(articleInfo.categories)>,</cfif>
											</cfloop>
										</div>
									</cfif> --->
									<cfif ListLen(articleInfo.tags)>
										<div class="metadata">
											tags:
											<cfloop list="#articleInfo.tags#" index="keyword">
												#linkTo(action="blogList",key="#reReplaceNoCase(lcase(trim(keyword)), "/+", " ", "all")#",text=keyword)#<cfif keyword neq ListLast(articleInfo.tags)>,</cfif>
											</cfloop>
										</div>
									</cfif>
								</div>
							</cfif>
							<!--- <cfif params.action eq "blog">
								<div class="comments">
									<a class="comments-link">COMMENTS</a>
									<cfloop query="comments">
										<div class="comment">#comments.comment_content#</div>
									</cfloop>
								</div>
							</cfif> --->
						</cfloop>
					</cfif>

					<!--- COMMENTS --->
					<div id="disqus_thread"></div>
					<script type="text/javascript">
					    var disqus_shortname = 'locateadoccomblog';
					    var disqus_identifier = '#articleInfo.ID# http://www.locateadoc.com/blog/?p=#articleInfo.ID#';
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
					<!--- <a href="http://disqus.com" class="dsq-brlink">blog comments powered by <span class="logo-disqus">Disqus</span></a> --->

					<cfif furtherReading.recordcount>
						<div class="article widget full-widget">
							<div class="title">
								<h2>Further Reading</h2>
							</div>
							<div class="cont-list cont-list2 articles">
								<ul>
									<cfloop query="furtherReading">
										<li>
											<div class="head">
												<em class="date">#DateFormat(furtherReading.createdAt,"mm.dd.yy")#</em>
												<h3>#LinkTo(controller="blog",action="#DateFormat(furtherReading.createdAt,'yyyy/mm/dd')#/#furtherReading.siloName#",text=furtherReading.post_title)#</h3>
											</div>
											<cfset filteredContent = REReplace(furtherReading.content,"\[caption.+?/caption\](\r|\n)*","","all")>
											<cfset filteredContent = REReplace(filteredContent,"<img.+?>","","all")>
											<cfset filteredContent = REReplace(filteredContent,"<a[^>]+>\s*?</a>","","all")>
											<cfset filteredContent = REReplace(filteredContent,"<p[^>]+>\s*?</p>","","all")>
											<cfset filteredContent = trim(filteredContent)>
											<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
											<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
											<cfset filteredContent = REReplace(filteredContent,"<h[0-9]>.+</h[0-9]>((\r|\n)+)?","","all")>
											<cfif REFind("\r|\n",filteredContent)>
												<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
												<cfset filteredContent = REReplace(filteredContent,"(\r|\n)+","","all")>
											</cfif>
											<p>#filteredContent#</p>
										</li>
									</cfloop>
								</ul>
							</div>
						</div>
					</cfif>
					</form>

				</div>

				<!-- aside2 -->
				<div class="aside3" id="article-widgets">
					<cfif Find("resources/blog-list",CGI.HTTP_REFERER)>
						#LinkTo(href=CGI.HTTP_REFERER,text="RETURN TO BLOG HOME",class="link-back")#
					<cfelse>
						#LinkTo(action="blog-list",text="RETURN TO BLOG HOME",class="link-back")#
					</cfif>
					#includePartial("/shared/sharesidebox")#
					#includePartial(partial="/shared/sitewideminileadsidebox",lockFields=false)#
					#includePartial("/shared/beforeandaftersidebox")#
					#includePartial("/shared/featureddoctor")#
					#includePartial(partial	= "/shared/ad", size="generic300x250")#
					<!-- sidebox -->
					#includePartial("/shared/beautifulliving")#
				</div>

				#includePartial(partial	= "/shared/ad",	size = "generic728x90bottom")#

			</div>
		</div>
	</div>
</cfoutput>
<!--- <cfdump var="#dominantSpecialty#">
<cfdump var="#dominantProcedure#"> --->