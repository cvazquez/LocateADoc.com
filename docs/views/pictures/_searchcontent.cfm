<cfoutput>
	<div id="content">
		<!-- resources-box search-term -->
		<div class="resources-box search-term">
			<!--- <div class="col"> --->
				<!-- title -->
				<div id="searchterm_content" class="title">
					#includePartial("searchterm")#
				</div>
			<!--- </div> --->
			<!--- SAVE YOUR SEARCH - DISABLED

			<cfif not params.intab>
				#includePartial("savesearch")#
			</cfif>

			--->

		</div>

		<!-- holder2 -->
		<div class="holder2">

			<!-- aside1 -->
			<div id="searchresults_content" class="aside1 print-area">
				#includePartial("searchresults")#
			</div>

			<cfif isMobile>
				<div class="mobileWidget">
					<h2>Contact A Doctor</h2>
					#includePartial("/mobile/mini_form")#
				</div>
			</cfif>
			<cfif not params.intab>
				<!-- aside2 -->
				<div class="aside2">
					<span id="featureddoctor_content">
						#includePartial("/shared/featureddoctor")#
					</span>

					<cfif NOT isMobile>
						#includePartial("/shared/sitewideminileadsidebox")#
					</cfif>

					#includePartial("/shared/relatedguide")#
					#includePartial("/shared/proceduresnapshot")#

					<cfif displayAd AND NOT isMobile>
						#includePartial(partial	= "/shared/ad",
										size	= "generic300x250#(explicitAd IS TRUE ? "Explicit" : "")#")#
					</cfif>
				</div>
			</cfif>
		</div>
	</div>

	<!-- sidebar -->
	<div id="sidebar">

		<div id="filters_content" class="search-box">
			#includePartial("filters")#
		</div>

		#includePartial("/shared/sponsoredlink")#

		<cfif displayAd>
			#includePartial(partial	= "/shared/ad",
							size	= "generic160x600#(explicitAd IS TRUE ? "Explicit" : "")#")#
		</cfif>
	</div>
	<!-- end sidebar -->
</cfoutput>