<!---
<cfset javaScriptIncludeTag(source="resources/procedure-select", head=true)>
<cfset javaScriptIncludeTag(source="resources/index", head=true)>
 --->
<cfoutput>
	<div id="page1" class="centered">
		<div id="bottom-content-wrapper">
			<div id="mobile-content">
				<div class="title">
					<h1 class="page-title">#specialContent.title#</h1>
					<span>#specialContent.description#</span>
				</div>

				<!--- Research by Body Part --->
				<a href="##bodypart" data-role="button" data-icon="plus" data-theme="b" data-transition="flip" class="left-aligned">Research by Body Part</a>

				<!--- Recent Articles --->
				<h2>Recent Articles & Blogs <span>(#linkTo(action="articles",text="view&nbsp;all&nbsp;articles", rel="external")#)</span></h2>
				<div class="cont-list">
					<ul>
						<cfloop query="latestArticlesAndBlogs">
							<li class="guide-preview">
								<div class="head">
									<cfset TopicList = ListAppend(latestArticlesAndBlogs.specialties,latestArticlesAndBlogs.procedures)>
									<cfif ListLen(topicList)>
										<strong>#ListGetAt(topicList,1)#</strong>
									</cfif>
									<div>
										<em class="date">#DateFormat(latestArticlesAndBlogs.publishAt,"mm.dd.yy")#</em>
										<h3><a href="#latestArticlesAndBlogs.siloName#">#latestArticlesAndBlogs.title#</a></h3>
									</div>
								</div>
								<cfset filteredContent = latestArticlesAndBlogs.content>
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
												<cfset newImageTag = '<a href="#latestArticlesAndBlogs.siloName#">' & newImageTag & '</a>'>
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
								<a href="#latestArticlesAndBlogs.siloName#">Read full article &gt;&gt;</a>
								</p>
							</li>
						</cfloop>
						<li style="text-align: center;">
							#linkTo(action="articles",text="View All Articles", rel="external")#
						</li>
					</ul>
				</div>

				<!--- Related Guides --->
				<h2>Recently Updated Resource Guides <span>(#linkTo(action="surgery",text="view&nbsp;all&nbsp;guides", rel="external")#)</span></h2>
				<div class="cont-list cont-list2">
					<ul>
						<cfloop query="latestGuides">
							<li class="guide-preview">
								<div class="head">
									<cfset TopicList = ListAppend(latestGuides.specialtyname,latestGuides.procedurename)>
									<cfset TopicList = ListAppend(TopicList,latestGuides.subprocedurename)>
									<cfif ListLen(topicList)>
										<strong>#ListGetAt(topicList,1)#</strong>
									</cfif>
									<div>
										<em class="date">#DateFormat(latestGuides.createdAt,"mm.dd.yy")#</em>
										<cfif val(specialtyID)>
										<h3>#LinkTo(controller=latestGuides.specialtySiloName,text="#specialtyname# Guide")#</h3>
										<cfelseif val(subprocedureID)>
										<h3>#LinkTo(controller=latestGuides.procedureSiloName,action=latestGuides.siloName,text=latestGuides.title)#</h3>
										<cfelse>
										<h3>#LinkTo(controller=latestGuides.procedureSiloName,text=latestGuides.title)#</h3>
										</cfif>
									</div>
								</div>
								<cfset filteredContent = REReplace(latestGuides.content,"</?span[^>]*?>"," ","all")>
								<cfset filteredContent = Replace(filteredContent,"&nbsp;"," ","all")>
								<cfset filteredContent = REReplace(filteredContent,"<h[0-9][^>]*?>.+?</h[0-9]>","","all")>
								<!--- Resize images in blog preview --->
								<cfset guideImages = REFind("<img.+?>",filteredContent,0,true)>
								<cfset newImageTag = "">
								<cfif guideImages.len[1] gt 0>
									<cfset imageTag = Mid(filteredContent,guideImages.pos[1],guideImages.len[1])>
									<cfset newImageTag = imageTag>
									<cfset imageWidthLocation = REFind('width\s?(=|:)\s?"?[0-9]+("|px)?',imageTag,0,true)>
									<cfset imageHeightLocation = REFind('height\s?(=|:)\s?"?[0-9]+("|px)?',imageTag,0,true)>
									<cfif imageWidthLocation.pos[1] and imageHeightLocation.pos[1]>
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
											<cfset newImageTag = Replace(Replace(newImageTag,'"#imageHeight#"','"#newImageHeight#"',"all"),'"#imageWidth#"','"#newImageWidth#"',"all")>
											<cfset newImageTag = Replace(Replace(newImageTag,'#imageHeight#px','#newImageHeight#px',"all"),'#imageWidth#px','#newImageWidth#px',"all")>
											<cfset newImageTag = '<a href="#latestGuides.procedureSiloName#">' & newImageTag & '</a>'>
										</cfif>
									</cfif>

									<!--- Solves an issue with ckeditor publishing div instead of <p> tags --->
									<cfset filteredContent = ReplaceNoCase(filteredContent, "<div>", "<p>", "all")>
									<cfset filteredContent = ReplaceNoCase(filteredContent, "</div>", "</p>", "all")>

									<!--- Prepend the new Image dimensions to the content, and remove all other image tags --->
									<cfset filteredContent = newImageTag & REReplace(filteredContent,"<img.+?>",'','all')>

									<!--- Remove all empty paragraph tags --->
									<cfset filteredContent = REReplace(filteredContent,"<p[^>]*?>\s*?</p>","","all")>
									<cfset filteredContent = REReplace(filteredContent,"<div[^>]*?>\s*?</div>","","all")>
								</cfif>

								<!--- Check if a div tag is at the beginning --->
								<cfif Left(filteredContent,5) eq "<div>">
									<p class="guide-description">#Left(filteredContent,Find("</div>",filteredContent,50+Len(newImageTag))+6)#</p>
								<cfelse>
									<cfif Find("</p>",filteredContent,50+Len(newImageTag))>
										<p class="guide-description">#Left(filteredContent,Find("</p>",filteredContent,50+Len(newImageTag))+4)#</p>
									<cfelseif Find("</div>",filteredContent,50+Len(newImageTag))>
										<p class="guide-description">#Left(filteredContent,Find("</div>",filteredContent,50+Len(newImageTag))+4)#</p><br />
									</cfif>
								</cfif>
								<cfif val(specialtyID)>
									#LinkTo(controller=latestGuides.specialtySiloName,text="Read full guide")#
								<cfelseif val(subprocedureID)>
									#LinkTo(controller=latestGuides.procedureSiloName,action=latestGuides.siloName,text="Read full guide")#
								<cfelse>
									#LinkTo(controller=latestGuides.procedureSiloName,text="Read full guide")#
								</cfif> &gt;&gt;
							</li>
						</cfloop>
							<li style="text-align: center;">
								#linkTo(action="surgery",text="View All Guides", rel="external")#
							</li>
					</ul>
				</div>

				<div class="swm">
					<h2>Contact A Doctor</h2>
					#includePartial("/mobile/mini_form")#
				</div>

				<div style="text-align:center; margin: 10px 0px 10px; 0px"><a href="?desktop=1" rel="external">DESKTOP VERSION</a></div>
			</div>
		</div>
	</div>
</cfoutput>
<cfsavecontent variable="additionalPages">
	<cfoutput>
		<div id="bodypart" data-role="page" data-url="bodypart" data-transition="flip">
			<ul data-role="listview">
				<li data-role="list-divider">Research by Body Part</li>
				</cfoutput>
				<cfoutput query="bodyParts" group="bodyRegionName">
					<li>
						<p>#bodyRegionName#</p>
						<ul>
							<cfoutput group="bodyPartName">
							<li>
								<p>#bodyPartName#</p>
								<ul>
									<cfoutput>
										<li>
											<a href="#URLFor(controller=bodyParts.siloName)#" rel="external">#procedureName#</a>
										</li>
									</cfoutput>
								</ul>
							</li>
							</cfoutput>
						</ul>
					</li>
				</cfoutput>
				<cfoutput>
			</ul>
		</div>
	</cfoutput>
</cfsavecontent>