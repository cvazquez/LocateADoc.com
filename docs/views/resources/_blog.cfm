<cfoutput>
<div class="frame">
	<h4>From Our <strong>Blog</strong> <span>(#LinkTo(action="blogList",text="view blog")#)</span></h4>
	<cfif Blog.recordcount>
		<cfset filteredContent = Blog.post_content>
		<cfset blogImage = "">
		<!--- Resize images in blog preview --->
		<cfset blogImages = REFind("<img.+?>",Blog.post_content,0,true)>
		<cfif blogImages.len[1] gt 0>
			<cfset imageTag = Mid(Blog.post_content,blogImages.pos[1],blogImages.len[1])>
			<cfset newImageTag = imageTag>
			<cfset imageWidthLocation = REFind('width\s?=\s?"[0-9]+"',imageTag,0,true)>
			<cfset imageWidth = REReplace(Mid(imageTag,imageWidthLocation.pos[1],imageWidthLocation.len[1]),"[^0-9]","","all")>
			<cfset imageHeightLocation = REFind('height\s?=\s?"[0-9]+"',imageTag,0,true)>
			<cfset imageHeight = REReplace(Mid(imageTag,imageHeightLocation.pos[1],imageHeightLocation.len[1]),"[^0-9]","","all")>
			<cfif imageWidth gt 100 and imageHeight gt 100>
				<cfif imageWidth lt imageHeight>
					<cfset newImageWidth = Ceiling(imageWidth/imageHeight * 100)>
					<cfset newImageHeight = 100>
				<cfelse>
					<cfset newImageHeight = Ceiling(imageHeight/imageWidth * 100)>
					<cfset newImageWidth = 100>
				</cfif>
				<cfset blogImage = Replace(Replace(newImageTag,'"#imageHeight#"','"#newImageHeight#"',"all"),'"#imageWidth#"','"#newImageWidth#"',"all")>
				<!--- <cfset filteredContent = Replace(filteredContent,imageTag,"[!!temp!!]")> --->
				<!--- Show only one image --->
				<cfset filteredContent = REReplace(filteredContent,"<img.+?>",'','all')>
				<!--- <cfset filteredContent = Replace(filteredContent,"[!!temp!!]",newImageTag)> --->

			</cfif>
		</cfif>
		<!--- Show only first paragraph --->
		<cfset filteredContent = REReplace(filteredContent,"\[caption.+?/caption\](\r|\n)*","","all")>
		<cfset filteredContent = REReplace(filteredContent,"<img.+?>","","all")>
		<cfset filteredContent = REReplace(filteredContent,"</?strong.+?>","","all")>
		<cfset filteredContent = REReplace(filteredContent,"<a[^>]+>\s*?</a>","","all")>
		<cfset filteredContent = REReplace(filteredContent,"<p[^>]+>\s*?</p>","","all")>
		<cfset filteredContent = trim(filteredContent)>
		<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
		<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
		<cfset filteredContent = REReplace(filteredContent,"<h[0-9]>.+</h[0-9]>((\r|\n)+)?","","all")>
		<cfset filteredContent = REReplace(filteredContent,"<[^<]+?>","","all")>
		<cfif REFind("\r|\n",filteredContent)>
			<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
		</cfif>
		<cfset truncatePoint = 200 <!--- + Iif(blogImages.len[1] gt 0 and Find(newImageTag,filteredContent),Len(newImageTag),0) --->>
		<cfif Len(filteredContent) gt truncatePoint>
			<cfset filteredContent = Left(filteredContent,(truncatePoint))&"...">
		</cfif>
		<em class="date">#DateFormat(Blog.post_date,"mm.dd.yy")#</em>
		<h5 style="height:initial;">#LinkTo(controller="blog",action="#DateFormat(Blog.createdAt,'yyyy/mm/dd')#/#Blog.siloName#",text=Blog.post_title, style="font-size:14px; line-height:15px; letter-spacing:0;")#</h5>
		<!--- <div class="visual">
			<div class="t">
				<div class="b">
					<a href="##"><img src="/images/layout/img105.jpg" alt="image description" width="63" height="72" /></a>
				</div>
			</div>
		</div> --->
		<cfif blogImage neq "">
			<div class="blog-photo">#blogImage#</div>
		</cfif>
		<p class="blog-preview" style="font: 12px/15px Arial, Helvetica, sans-serif;">#filteredContent#</p>
		<strong class="more">#LinkTo(controller="blog",action="#DateFormat(Blog.createdAt,'yyyy/mm/dd')#/#Blog.siloName#",text="READ FULL STORY")#</strong>
	</cfif>
</div>
</cfoutput>