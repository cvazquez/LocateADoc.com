<cfoutput>
<div class="blog-list">
	<div class="heading-blue">
		<a href="/resources/blog-list" style="text-decoration:none;"><h2>From Our<strong> Blog</strong></h2></a>
	</div>
	<div class="box">
		<!-- Blog -->
		<div class="blog">
			<div class="column-height">
				<div class="hold">
						<cfloop query="blogs">
								<cfset filteredContent = blogs.post_content>
								<cfset blogImage = "">
								<!--- Resize images in blog preview --->
								<cfset blogImages = REFind("<img.+?>",blogs.post_content,0,true)>
								<cfif blogImages.len[1] gt 0>
									<cfset imageTag = Mid(blogs.post_content,blogImages.pos[1],blogImages.len[1])>
									<cfset newImageTag = imageTag>
									<cfset imageWidthLocation = REFind('width\s?=\s?"[0-9]+"',imageTag,0,true)>
									<cfif imageWidthLocation.pos[1] GT 0>
										<cfset imageWidth = REReplace(Mid(imageTag,imageWidthLocation.pos[1],imageWidthLocation.len[1]),"[^0-9]","","all")>
									<cfelse>
										<cfset imageWidth = 0>
									</cfif>
									<cfset imageHeightLocation = REFind('height\s?=\s?"[0-9]+"',imageTag,0,true)>

									<cfif imageHeightLocation.pos[1] GT 0>
										<cfset imageHeight = REReplace(Mid(imageTag,imageHeightLocation.pos[1],imageHeightLocation.len[1]),"[^0-9]","","all")>
									<cfelse>
										<cfset imageHeight = 0>
									</cfif>
									<cfif imageWidth gt 100 and imageHeight gt 100>
										<cfif imageWidth lt imageHeight>
											<cfset newImageWidth = Ceiling(imageWidth/imageHeight * 100)>
											<cfset newImageHeight = 100>
										<cfelse>
											<cfset newImageHeight = Ceiling(imageHeight/imageWidth * 100)>
											<cfset newImageWidth = 100>
										</cfif>
										<cfset blogImage = Replace(Replace(newImageTag,'"#imageHeight#"','"#newImageHeight#"',"all"),'"#imageWidth#"','"#newImageWidth#"',"all")>
										<!--- Show only one image --->
										<cfset filteredContent = REReplace(filteredContent,"<img.+?>",'','all')>
									</cfif>
									<cfset truncatePoint = 200>
								<cfelse>
									<cfset truncatePoint = 400>
								</cfif>
								<!--- Show only first paragraph --->
								<cfset filteredContent = REReplace(filteredContent,"\[caption.+?/caption\](\r|\n)*","","all")>
								<cfset filteredContent = REReplace(filteredContent,"<img.+?>","","all")>
								<cfset filteredContent = ReReplace(filteredContent, "<[^>]*>", " ", "all")>
								<cfset filteredContent = REReplace(filteredContent,"<p[^>]+>\s*?</p>","","all")>
								<cfset filteredContent = REReplace(filteredContent,"<strong.+?>","","all")>
								<cfset filteredContent = trim(filteredContent)>
								<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
								<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
								<cfset filteredContent = REReplace(filteredContent,"<h[0-9]>.+</h[0-9]>((\r|\n)+)?","","all")>
								<cfif REFind("\r|\n",filteredContent)>
									<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
								</cfif>
								<cfif Len(filteredContent) gt truncatePoint>
									<cfset filteredContent = Left(filteredContent,(truncatePoint))&"...">
								</cfif>
								<cfset blogURL = "/blog/#DateFormat(blogs.createdAt,'yyyy/mm/dd')#/#blogs.siloName#">
								<em style="display: block; font-style: normal;color: ##6c6c6c; font: 12px BreeRegular, Arial, Helvetica, sans-serif;">#DateFormat(blogs.post_date,"mm.dd.yy")#</em>
								<h5><a href="#blogURL#" style="text-decoration: none;">#blogs.post_title#</a></h5>
								<cfif blogImage neq "">
									<div class="blog-photo"><a href="#blogURL#">#blogImage#</a></div>
								</cfif>
								<p class="blog-preview">#filteredContent#
									<strong class="more">#LinkTo(controller="blog",action="#DateFormat(blogs.createdAt,'yyyy/mm/dd')#/#blogs.siloName#",text="READ FULL STORY")#</strong>
								</p>
						</cfloop>
				</div>
			</div>
		</div>
	</div>
</div>
</cfoutput>