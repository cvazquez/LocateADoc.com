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
	<div id="page1" class="centered">
		<div id="bottom-content-wrapper">
			<div id="mobile-content">
				<cfif params.action eq "articles" and listTitle neq "">
					<div class="blog-header">
						<h1>#listTitle#</h1>
					</div>
				</cfif>
				<cfif params.action neq "article" and params.action neq "guide" and params.action neq "blog" and search.pages gt 1>
					<div class="pagination">#includePartial("/shared/_pagination_mobile.cfm")#</div>
				</cfif>
				<cfif isDefined("articleInfo") and articleInfo.recordcount>
					<cfif params.action eq "articles">
						<div class="cont-list"><ul>
					</cfif>
					<cfloop query="articleInfo">
						<cfif params.action eq "articles"><li><cfelse><div class="article"></cfif>
							<cfset articleDate = (params.action eq "article" or params.action eq "articles") ? articleInfo.publishAt : articleInfo.createdAt>
							<cfif params.action neq "guide" and params.action neq "articles" and IsDate(articleDate)>
								<cfif DateDiff("yyyy",articleDate,now()) eq 0>
									<div class="dateflag">#Replace(DateFormat(articleDate,"mmm d")," ","<br>")#</div>
								<cfelse>
									<div class="dateflag">#Replace(DateFormat(articleDate,"mmm yyyy")," ","<br>")#</div>
								</cfif>
							</cfif>
							<cfif params.action eq "article" or params.action eq "guide">
								<!--- <div class="photo"><img src="/images/layout/img2-photo.jpg" /></div> --->
								<h1 class="blog-head">#articleInfo.header#</h1>
								<cfif IsDate(articleDate)>
									<p class="post-date">posted on #DateFormat(articleDate,"m/d/yyyy")#</p>
								</cfif>
								<cfset filteredContent = articleInfo.content>
								<cfif Find("<h2",filteredContent) eq 0>
									<cfset filteredContent = REReplace(filteredContent,"h3","h2","all")>
								</cfif>
								#filteredContent#
							<cfelse>
								<!--- <div class="photo"><img src="/images/layout/img2-photo.jpg" /></div> --->
								<!--- <h3 class="preview">#LinkTo(controller="article", action=articleInfo.siloName,text=articleInfo.title)#</h3> --->
								<div class="head">
									<em class="date">#DateFormat(articleDate,"mm.dd.yy")#</em>
									<h3>#linkTo(text=articleInfo.title, controller="article", action=articleInfo.siloName)#</h3>
								</div>
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
						<cfif params.action eq "articles">
							</li>
						<cfelse>
							</div>
							<div class="post-info">
								<cfif params.action eq "article">
									<!--- #includePartial(partial="/shared/sitewideminileadsidebox", isPopup=true)# --->
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
										#LinkTo(controller="article", action=articleInfo.siloName,text="read more")#
									</div>
								</cfif>
							</div>
							<cfif params.action eq "article">
								<!--- SWM form --->
							</cfif>
						</cfif>
					</cfloop>
					<cfif params.action eq "articles">
						</ul></div>
					</cfif>
				</cfif>
				<form name="resultsForm" action="##" method="post"></form>
				<cfif params.action neq "article" and params.action neq "guide" and params.action neq "blog" and search.pages gt 1>
					<div class="pagination">#includePartial("/shared/_pagination_mobile.cfm")#</div>
				</cfif>
				<div class="swm">
					<h2>Contact A Doctor</h2>
					#includePartial("/mobile/mini_form")#
				</div>
			</div>
		</div>
	</div>
</cfoutput>