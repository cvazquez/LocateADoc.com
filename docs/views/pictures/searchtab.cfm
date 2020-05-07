<cfoutput>
	<!--- #javascriptIncludeTag(sources="pictures/searchtab,filterresults,hashchange,utils",head=true)# --->
	<script>
	var gallerybase = '#URLFor(controller="pictures")#'
	var doctorId = #params.key#
	</script>
	<!-- main -->
	<div id="main" class="baagtab">

		<!-- container inner-container -->
		<div class="">
			<div class="inner-holder">

				<!-- options -->
				<div class="options">
					<ul>
						<li class="email-link"><a href="##">Email</a></li>
						<li class="print-link"><a href="##">Print</a></li>
						<li class="share-link"><a href="##">Share</a></li>
					</ul>
				</div>
				<!-- end options -->


				<!-- content-frame -->
				<div class="content-frame">
					#includePartial("searchcontent")#
				</div>
				<!-- end content-frame -->

			</div>
		</div>
	</div>
</cfoutput>