<cfset Blog = articleInfo>

<cfsavecontent variable="additionalJS">
	<cfoutput>
		<script type="text/javascript">
			var images = new Array();
			$(function(){
				$(".article img").each(function(){
				    images[$(this).attr("src")] = $(this);
					// Create in memory copy of image and get size
					$("<img/>")
						.attr("src", $(this).attr("src"))
    					.load(function() {
    					    thisImg = images[this.src];
        					w = this.width;		// Note: $(this).width() will not
        					h = this.height;	// work for in memory images.
    					    //alert(w);
							// Resize wide images
							if(w > 266)
							{
								//alert("Resizing wide image: "+thisImg.attr("src"));
								console.log("Resizing image: "+this.src);
								thisImg.css("width", "266px");
								thisImg.css("height", " " + parseInt(266 * h / w) + "px");
								thisImg.css("margin","5px 0");
							}
							// If image wider than a certain size, make sure text doesn't float around it
							else if(w > 150)
							{
								console.log("Centering wide image: "+this.src);
								thisImg.css("float","none").css("display","block").css("margin","5px auto");
							}
							// Float it is it's not already
							else if(thisImg.css("float") == "")
							{
								thisImg.css("float","right");
								thisImg.css("margin","5px");
							}
							// Otherwise just add margin
							else
							{
								thisImg.css("margin","5px");
							}
    					});
				});
			});
		</script>
	</cfoutput>
</cfsavecontent>

<cfoutput>
	<div id="page1" class="centered resources_blog_post">
		<div id="bottom-content-wrapper">
			<div id="mobile-content">
				<cfif isDefined("Blog") and Blog.recordcount>
					<cfloop query="Blog">
						<div class="article">
							<cfif params.action eq "blog">
								<h1 class="blog-head">#Blog.title#</h1>
								<cfif IsDate(Blog.createdAt)>
									<p class="post-date">posted on #DateFormat(Blog.createdAt,"m/d/yyyy")#</p>
								</cfif>
								<cfset filteredContent = Blog.content>
								<cfif Find("<h2",filteredContent) eq 0>
									<cfset filteredContent = REReplace(filteredContent,"h3","h2","all")>
								</cfif>
								<cfset filteredContent = REReplace(articleInfo.content,"(\r|\n)+","</p><p>","all")>

								<!--- Check if the contect doesn't start with a paragraph tag and add one if it doesn't
								--->
								<cfif NOT reFindNoCase("^<p[^>]*>", filteredContent)>
									<cfset filteredContent = "<p>" & filteredContent>
								</cfif>

								#filteredContent#
							</cfif>

							</div>
							<div class="post-info">
								<cfif ListLen(Blog.tags)>
									<div class="metadata">
										tags:
										<cfloop list="#Blog.tags#" index="keyword">
											<a href="/resources/blog-list/#urlEncodedFormat(lcase(trim(keyword)))#">#trim(keyword)#</a><cfif keyword neq ListLast(Blog.tags)>,</cfif>
										</cfloop>
									</div>
								</cfif>
							</div>
					</cfloop>
				</cfif>
				<form name="resultsForm" action="##" method="post"></form>
				<div class="swm mobileWidget">
					<h2>Contact A Doctor</h2>
					#includePartial("/mobile/mini_form")#
				</div>
			</div>
		</div>
	</div>
</cfoutput>