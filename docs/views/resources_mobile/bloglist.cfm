<cfoutput>
	<cfset Blogs = articleInfo>
	<div id="page1" class="centered">
		<div id="bottom-content-wrapper">
			<div id="mobile-content">
				<div class="title">
					<h1 class="page-title">LocateADoc Blog</h1>

					<cfif tagName neq "">
						<p><strong>Showing results tagged:</strong><br />
						 "#tagName#"</p>
					<cfelse>
						<span>#description#</span>
					</cfif>

					<cfif params.action neq "article" and params.action neq "guide" and params.action neq "blog" and search.pages gt 1>
						<div class="pagination" style="padding: 10px 0!Important;">#includePartial("/shared/_pagination_mobile.cfm")#</div>
					</cfif>
				</div>

				<!--- Recent Blogs --->
				<div class="cont-list">
					<ul style="padding: 0 0 15px!important;">
						<cfloop query="Blogs">
							<li class="guide-preview">
								<div class="head">
									<cfset TopicList = Blogs.specialtyName>
									<cfif ListLen(topicList)>
										<strong>#topicList#</strong>
									</cfif>
									<div>
										<em class="date">#DateFormat(Blogs.createdAt,"mm.dd.yy")#</em>
										<h3><a href="/blog/#DateFormat(Blogs.createdAt,'yyyy/mm/dd')#/#Blogs.siloName#">#Blogs.title#</a></h3>
									</div>
								</div>
								<cfset filteredContent = Blogs.post_content>
								<cfset newImageTag = "">
								<cfset blogImages = REFind("<img.+?>",filteredContent,0,true)>
									<cfif blogImages.len[1] gt 0>
									<cfset imageTag = Mid(filteredContent,blogImages.pos[1],blogImages.len[1])>
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
												<cfset newImageTag = '<a href="/blog/#DateFormat(Blogs.createdAt,'yyyy/mm/dd')#/#Blogs.siloName#">' & newImageTag & '</a>'>
											<cfelse>
												<cfset newImageTag = "">
											</cfif>
										</cfif>
									</cfif>
								</cfif>
								<cfset filteredContent = REReplace(filteredContent,"<[^<]+?>","","all")>
								<cfset filteredContent = Replace(filteredContent,"&nbsp;"," ","all")>
								<cfset filteredContent = trim(filteredContent)>

								<cfset filteredContent = REReplace(filteredContent,"^.{0,200}(\r|\n)","","all")>
								<cfset filteredContent = REReplace(filteredContent,"^.{0,200}(\r|\n)","","all")>

								<!--- Split the content at the first paragraph --->
								<cfif REFind("\r|\n",filteredContent)>
									<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
								</cfif>
								<p>#newImageTag & filteredContent#<br />
								<a href="/blog/#DateFormat(Blogs.createdAt,'yyyy/mm/dd')#/#Blogs.siloName#">Read full blog post &gt;&gt;</a>
								</p>
							</li>
						</cfloop>
					</ul>
					<cfif params.action neq "article" and params.action neq "guide" and params.action neq "blog" and search.pages gt 1>
						<div class="pagination">#includePartial("/shared/_pagination_mobile.cfm")#</div>
						<hr style="margin: 25px 0px 0px 0px;">
					</cfif>
					<form name="resultsForm" action="##" method="post"></form>
					<div class="swm">
						<h2>Contact A Doctor</h2>
						#includePartial("/mobile/mini_form")#
					</div>

					<hr style="margin: 25px 0px 15px 0px;">
				</div>

				<div style="text-align:center; margin: 10px 0px 10px; 0px"><a href="?desktop=1" rel="external">DESKTOP VERSION</a></div>
			</div>
		</div>
	</div>
</cfoutput>