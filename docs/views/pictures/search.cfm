<cfoutput>
	<cfset startTick = getTickCOunt()>
	<cfif NOT isMobile>
		#styleSheetLinkTag(sources="
			pictures/search,
			thickbox")#
		#javascriptIncludeTag(sources="
			thickbox,
			pictures/search,
			filterresults,
			hashchange,
			utils",
			head=true)#
	<cfelse>
		#javascriptIncludeTag(sources="
			pictures/search,
			filterresults,
			slideshow",
			head=true)#
	</cfif>
	<script>
	var gallerybase = '#URLFor(controller="pictures")#'
	</script>
	<!-- main -->
	<div id="main" class="GallerySearchResults">

		#includePartial("/shared/breadcrumbs")#

		<cfif displayAd>
		#includePartial(partial	= "/shared/ad",
						size	= "generic728x90top#(explicitAd IS TRUE ? "Explicit" : "")#")#
		</cfif>

		<!-- container inner-container -->
		<div class="container inner-container">
			<div class="inner-holder">

				<cfif NOT isMobile>
				#includePartial("/shared/pagetools")#
				</cfif>

				<!-- content-frame -->
				<div class="content-frame">
					#includePartial("searchcontent")#
				</div>
				<!-- end content-frame -->

			</div>
		</div>
	</div>
</cfoutput>