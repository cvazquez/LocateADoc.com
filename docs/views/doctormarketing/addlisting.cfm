<cfif NOT isMobile>
	<cfset styleSheetLinkTag(source="doctormarketing/addlisting", head=true)>
</cfif>
<cfoutput>
	<!-- main -->
	<div id="main">
		<cfif NOT isMobile>
			#includePartial("/shared/breadcrumbs")#
		</cfif>
		<!--- #includePartial(partial	= "/shared/ad",	size = "generic728x90top")# --->
		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder article-container">
				<!--- #includePartial("/shared/pagetools")# --->
				<cfswitch expression="#params.page#">
					<cfcase value="2">
						<!--- <cfoutput>
							<p>isPremier = #isPremier#</p>
							<p>params.introductoryAccept = #params.introductoryAccept#</p>
							<p>params.specialtyID = #params.specialtyID#</p>
						</cfoutput> --->
						<cfif NOT isPremier AND params.introductoryAccept IS FALSE>
							#includePartial("addlisting_introductory_city")#
						<cfelse>
							#includePartial("addlisting-page2")#
						</cfif>
						<cfset analyticsPageTrack = "/funnel_G4/step2.html">
					</cfcase>
					<cfcase value="3">
						#includePartial("addlisting-page3")#
						<cfset analyticsPageTrack = "/funnel_G4/step3.html">
					</cfcase>
					<cfcase value="4">
						<cfif isPremier>
							#includePartial("addlisting-thankyou1")#
						<cfelse>
							<cfset javaScriptIncludeTag(source="doctormarketing/addlistingform", head=true)>
							#includePartial("billing-cc")#
							<!--- #includePartial("addlisting-thankyou2")# --->
						</cfif>
						<cfset analyticsPageTrack = "/funnel_G4/step4.html">
					</cfcase>
					<cfdefaultcase>
						#includePartial("addlisting-frontpage")#
						<cfset analyticsPageTrack = "/funnel_G4/step1.html">
					</cfdefaultcase>
				</cfswitch>
			</div>
		</div>
	</div>
</cfoutput>