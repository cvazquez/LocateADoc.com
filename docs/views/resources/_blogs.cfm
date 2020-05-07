<cfif Blog.recordcount>
<cfparam default="" name="procedureId">
<cfparam default="" name="specialtyId">
<cfoutput>
	<!-- widget -->
	<div class="widget">
		<div class="title">
			<h2>From Our Blog
				<span>
					<cfif val(procedureId) GT 0>
						(#LinkTo(action="blogList",key="procedure-#procedureID#",text="view blog")#)
					<cfelseif val(specialtyId) GT 0>
						(#LinkTo(action="blogList",key="specialty-#specialtyID#",text="view blog")#)
					<cfelse>
						(#LinkTo(action="blogList",text="view blog")#)
					</cfif>
				</span>
			</h2>
			<a class="rss" href="##">RSS</a>
		</div>
		<div class="cont-list">
			<ul>
				<cfloop query="Blog">
				<cfset filteredContent = Blog.post_content>
				<!--- Resize images in blog preview --->
				<cfset blogImages = REFind("<img.+?>",Blog.post_content,0,true)>
				<cfset blogImage = "">
				<cfif blogImages.len[1] gt 0>
					<cfset imageTag = Mid(Blog.post_content,blogImages.pos[1],blogImages.len[1])>
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
					<cfelse>
						<cfset newImageHeight = imageHeight>
						<cfset newImageWidth = imageWidth>
					</cfif>
					<cfset blogImage = Replace(Replace(imageTag,'"#imageHeight#"','"#newImageHeight#"',"all"),'"#imageWidth#"','"#newImageWidth#"',"all")>
					<!--- <cfset filteredContent = Replace(filteredContent,imageTag,"[!!temp!!]")> --->
					<!--- Show only one image --->
					<cfset filteredContent = REReplace(filteredContent,"<img.+?>",'','all')>
					<!--- <cfset filteredContent = Replace(filteredContent,"[!!temp!!]",newImageTag)> --->
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
				<cfif REFind("\r|\n",filteredContent)>
					<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
				</cfif>
				<li class="blog-preview">
					<div class="head">
						<strong>#Blog.topic#</strong>
						<div>
							<em class="date">#DateFormat(Blog.post_date,"mm.dd.yy")#</em>
							<h3><a href="##">#LinkTo(controller="blog",action="#DateFormat(Blog.createdAt,'yyyy/mm/dd')#/#Blog.siloName#",text=Blog.post_title)#</a></h3>
						</div>
					</div>
					<!--- <div class="visual">
						<div class="t">
							<div class="b">
								<a href="##"><img src="/images/layout/img105.jpg" alt="image description" width="63" height="72" /></a>
							</div>
						</div>
					</div> --->
					<cfif blogImage neq "">
						#blogImage#
					</cfif>
					<p>#filteredContent#</p>
				</li>
				</cfloop>
				<!--- <li>
					<div class="head">
						<strong>Plastic Surgery</strong>
						<div>
							<em class="date">08.12.06</em>
							<h3><a href="##">Multiline header can go here</a></h3>
						</div>
					</div>
					<div class="visual">
						<div class="t">
							<div class="b">
								<a href="##"><img src="/images/layout/img105.jpg" alt="image description" width="63" height="72" /></a>
							</div>
						</div>
					</div>
					<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam et libero augue, ut facilisis turpis. Phasellus venenatis odio vestibulum tortor imperdiet vulputate. Etiam eu est vel nulla porttitor mollis a a enim. Donec luctus . Quisque ac turpis diam, sed fermentum neque.</p>
				</li>
				<li>
					<div class="head">
						<strong>Surgery</strong>
						<div>
							<em class="date">08.12.06</em>
							<h3><a href="##">Multiline header can go here</a></h3>
						</div>
					</div>
					<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam et libero augue, ut facilisis turpis. Phasellus venenatis odio vestibulum tortor imperdiet vulputate. Etiam eu est vel mollis a a enim. Donec luctus fringilla </p>
				</li> --->
			</ul>
		</div>
	</div>
</cfoutput>
</cfif>