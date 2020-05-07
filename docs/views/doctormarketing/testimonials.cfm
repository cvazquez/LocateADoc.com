<cfoutput>
	<!-- main -->
	<div id="main">
		<cfif NOT isMobile>
			#includePartial("/shared/breadcrumbs")#
		</cfif>
		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder">
				<cfif NOT isMobile>#includePartial("/shared/pagetools")#</cfif>
				<div class="full-content">
					<h1 class="title-shadow">LocateADoc.com client testimonials:</h1>
					<cfloop query="testimonialInfo">
						<div class="testimonial"<cfif testimonialInfo.currentrow eq 1> style="border-top:none;"</cfif>>
							<div class="photo<cfif testimonialInfo.currentrow mod 2 eq 0> right</cfif>">
								<img src="#testimonialInfo.url#">
							</div>
							#testimonialInfo.content#
						</div>
					</cfloop>
					#LinkTo(action="advertising",text="Advertising Options")#
				</div>
			</div>
		</div>
	</div>
</cfoutput>