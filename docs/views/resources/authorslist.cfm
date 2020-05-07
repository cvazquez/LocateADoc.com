<cfset javaScriptIncludeTag(source="resources/bloglist", head=true)>

<cfoutput>
	<!-- main -->
	<div id="main" class="resources-authors-list">
		<cfif NOT isMobile>
			#includePartial("/shared/breadcrumbs")#
			#includePartial(partial	= "/shared/ad", size="generic728x90top")#
		</cfif>
		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder pattern-top article-container">
				<cfif NOT isMobile>
					#includePartial("/shared/pagetools")#
				</cfif>

				<!-- content -->
				<div class="print-area" id="article-content">
					<div class="blog-header">
						<h1 class="blog-head">#title#</h1>
						<cfif tagName neq "">
							<p>Showing results tagged "#tagName#"</p>
						<cfelseif params.title neq "">
							<p>Showing results for "#params.title#"</p>
						<cfelseif params.page eq 1>
							<cfif isnumeric(authorInfo.googlePlusId)>
								<cfhtmlhead text='
								<script type="text/javascript">
								  authorGooglePlusAPIPhoto("#authorInfo.googlePlusId#");
								</script>
								'>
							</cfif>

							<div id="BioContainer">
								<div id="BioThumbnailContainer">
									<p>
									<span id="GooglePlusThumbNailImage"></span>
									</p>
								</div>
								<div id="BioDescriptionContainer">
									<p>#authorInfo.bio#</p>
								</div>
							</div>
							<div style="clear: both;"></div>
						</cfif>
						<cfif params.action neq "article" and params.action neq "guide" and params.action neq "blog" and search.pages gt 1>
							<div class="pagination">#includePartial("/shared/_pagination#mobileSuffix#.cfm")#</div>
						</cfif>
					</div>
					<form name="resultsForm" action="##" method="post">
					<cfif isDefined("articleInfo") and articleInfo.recordcount>

						<script type="text/javascript">
						    var disqus_shortname = 'locateadoccomblog';

						    (function () {
						        var s = document.createElement('script'); s.async = true;
						        s.type = 'text/javascript';
						        s.src = 'http://' + disqus_shortname + '.disqus.com/count.js';
						        (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s);
						    }());
						</script>

						<cfloop query="articleInfo">
							<div class="article">
								<cfset articleDate = articleInfo.createdAt>
								<cfset blogImage = "">
								<cfif DateDiff("yyyy",articleDate,now()) eq 0>
									<div class="dateflag">#Replace(DateFormat(articleDate,"mmm d")," ","<br>")#</div>
								<cfelse>
									<div class="dateflag">#Replace(DateFormat(articleDate,"mmm yyyy")," ","<br>")#</div>
								</cfif>
								<cfset filteredContent = articleInfo.post_content>
								<!--- Resize images in blog preview --->
								<cfset blogImages = REFind("<img.+?>",articleInfo.post_content,0,true)>
								<cfif blogImages.len[1] gt 0>
									<cfset imageTag = Mid(articleInfo.post_content,blogImages.pos[1],blogImages.len[1])>
									<cfset imageWidthLocation = REFind('width\s?=\s?"[0-9]+"',imageTag,0,true)>
									<cfset imageHeightLocation = REFind('height\s?=\s?"[0-9]+"',imageTag,0,true)>
									<cfif imageWidthLocation.len[1] and imageHeightLocation.len[1]>
										<cfset imageWidth = REReplace(Mid(imageTag,imageWidthLocation.pos[1],imageWidthLocation.len[1]),"[^0-9]","","all")>
										<cfset imageHeight = REReplace(Mid(imageTag,imageHeightLocation.pos[1],imageHeightLocation.len[1]),"[^0-9]","","all")>
										<cfif imageWidth gt 120 and imageHeight gt 120>
											<cfif imageWidth lt imageHeight>
												<cfset newImageWidth = Ceiling(imageWidth/imageHeight * 120)>
												<cfset newImageHeight = 120>
											<cfelse>
												<cfset newImageHeight = Ceiling(imageHeight/imageWidth * 120)>
												<cfset newImageWidth = 120>
											</cfif>
										<cfelse>
											<cfset newImageHeight = imageHeight>
											<cfset newImageWidth = imageWidth>
										</cfif>
										<cfset newImageTag = Replace(Replace(imageTag,'"#imageHeight#"','"#newImageHeight#"',"all"),'"#imageWidth#"','"#newImageWidth#"',"all")>
										<cfset filteredContent = Replace(filteredContent,imageTag,"")>
										<cfif (newImageHeight gt 0) AND (newImageWidth gt 0)>
											<cfset blogImage='<!--- <div class="photo"> --->#newImageTag#<!--- </div> --->'>
										</cfif>
									</cfif>
								</cfif>
								<!--- Show only first paragraph --->
								<cfset filteredContent = REReplace(filteredContent,"\[caption.+?/caption\](\r|\n)*","","all")>
								<cfset filteredContent = REReplace(filteredContent,"<img.+?>","","all")>
								<cfset filteredContent = REReplace(filteredContent,"<a[^>]+>\s*?</a>","","all")>
								<cfset filteredContent = REReplace(filteredContent,"<p[^>]+>\s*?</p>","","all")>
								<cfset filteredContent = trim(filteredContent)>
								<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
								<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
								<cfset filteredContent = REReplace(filteredContent,"<h[0-9]>.+</h[0-9]>((\r|\n)+)?","","all")>
								<cfif REFind("\r|\n",filteredContent)>
									<cfif Find("<!--more-->",filteredContent)>
										<cfset filteredContent = Left(filteredContent,Find("<!--more-->",filteredContent)-1)>
									<cfelse>
										<cfset filteredContent = Left(filteredContent,Max(REFind("\r|\n",filteredContent),REFind("\r|\n",filteredContent,REFind("\r|\n",filteredContent)+5)))>
									</cfif>
									<cfset filteredContent = REReplace(filteredContent,"(\r|\n)+","<br><br>","all")>
									<cfset filteredContent = REReplace(filteredContent,"</p><br><br><p","</p><p","all")>
								</cfif>
								<h2 class="preview">#LinkTo(controller="blog",action="#DateFormat(articleInfo.createdAt,'yyyy/mm/dd')#/#articleInfo.siloName#",text=articleInfo.title)#</h2>
								#blogImage#
								#filteredContent#
							</div>
							<div class="post-info">
								<a class="comments-link" href="#URLFor(controller="blog",action="#DateFormat(articleInfo.createdAt,'yyyy/mm/dd')#/#articleInfo.siloName#",anchor="disqus_thread")#" data-disqus-identifier="#articleInfo.ID# http://www.locateadoc.com/blog/?p=#articleInfo.ID#"><!--- #ArticleInfo.comments# COMMENT<cfif ArticleInfo.comments neq 1>S</cfif> ---></a>
								<div class="readmore">
									#LinkTo(controller="blog",action="#DateFormat(articleInfo.createdAt,'yyyy/mm/dd')#/#articleInfo.siloName#",text="read more")#
								</div>
							</div>
						</cfloop>
					<cfelse>
						<p>No matching blog posts were found.</p>
					</cfif>
					</form>
					<cfif search.pages gt 1>
						<div class="pagination">#includePartial("/shared/_pagination#mobileSuffix#.cfm")#</div>
					</cfif>
				</div>

				<!-- aside2 -->
				<div class="aside3" id="article-widgets">
					<cfif NOT isMobile>
						#includePartial("/shared/sharesidebox")#
						#includePartial("/shared/sitewideminileadsidebox")#
					<cfelse>
						<div class="swm mobileWidget">
							<h2>Contact A Doctor</h2>
							#includePartial("/mobile/mini_form")#
						</div>
					</cfif>

					<div class="sidebox mobileWidget">
						<div class="frame">
							<h4<!---  class="withsubtitle" --->>Blog <strong>Search</strong></h4>
							<p>Search for your favorite celebrity amongst our blog posts.</p>
							<form id="blogSearch" onsubmit="blogSearch();return false;">
								<div class="stretch-input"><span><input type="text" class="noPreText" id="blogSearchTerm" /></span></div>
								<input type="button" class="btn-search" value="SEARCH" onclick="blogSearch();">
							</form>
						</div>
					</div>
					<div class="sidebox mobileWidget">
						#includePartial("/shared/resourceguides")#
					</div>

					<div class="mobileWidget">
						#includePartial("/shared/beforeandaftersidebox")#
					</div>

					<cfif NOT isMobile>
						<div class="mobileWidget">
							#includePartial("/shared/featureddoctor")#
						</div>
					</cfif>

					<cfif NOT isMobile>
						#includePartial(partial	= "/shared/ad", size="generic300x250")#
					</cfif>
					<div class="sidebox mobileWidget">
						<div class="frame">
							<h4 class="withsubtitle">Facebook <strong>Followers</strong></h4>
							<!--- <div class="fb-like-box" data-href="http://www.facebook.com/locateadoc" data-width="268" data-show-faces="true" data-border-color="##FFFFFF" data-stream="false" data-header="false"></div> --->
							<div style="width:266px; height:256px; display:block; overflow:hidden;">
							<iframe src="//www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Flocateadoc&amp;width=268&amp;height=258&amp;colorscheme=light&amp;show_faces=true&amp;border_color=transparent&amp;stream=false&amp;header=false" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:268px; height:258px; margin: -1px 0 0 -1px;" allowTransparency="true"></iframe>
							</div>
						</div>
					</div>
				</div>

				<cfif NOT isMobile>
					#includePartial(partial	= "/shared/ad",	size = "generic728x90bottom")#
				</cfif>
			</div>
		</div>
	</div>
</cfoutput>