<cfparam name="isError" default="false">
<cfsavecontent variable="contentHTML">
	<cfoutput>
			#includePartial("/header_mobile")#
			<cfswitch expression="#params.controller#">
				<cfcase value="profile">
					<!--- Mobile wrapper --->
					<div id="page1" class="centered">
						<div id="bottom-content-wrapper">
							<div id="mobile-content">

							<!-- main -->
							<div id="main">
								<!--- #includePartial("/shared/breadcrumbs_mobile")# --->
								<!-- container inner-container2 -->
								<div class="container inner-container2"<cfif params.action eq "reviews"> itemscope itemtype="http://schema.org/Organization"</cfif>>
									<!--- #includePartial("/shared/pagetools_mobile")# --->
									<!-- topsections -->
									#includePartial("/profile/topsection_mobile")#
									<!-- tabnav -->
									#includePartial("profileTabs_mobile")#
									<!-- twocolumns -->
									<div class="twocolumns">
										#includePartial("/shared/noscript_mobile")#
										#includeContent()#
									</div>
								</div>
							</div>
							#includePartial("/profile/topbar_mobile")#
							</div>
						</div>
					</div>
				</cfcase>
				<cfcase value="home,resources">
					<cfif params.action EQ "doctorReviews" OR params.action EQ "feedback" OR params.action EQ "privacy" OR params.action EQ "terms" OR params.action EQ "unsubscribe" OR params.action EQ "reviews" OR params.action EQ "video" OR params.action EQ "procedureList" OR params.action EQ "authorsList" OR params.action EQ "about">
						<div id="page1" class="centered">
							<div id="bottom-content-wrapper">
								<div id="mobile-content">
									#includeContent()#
								</div>
							</div>
						</div>
					<cfelse>
						#includeContent()#
					</cfif>
				</cfcase>
				<cfcase value="doctors,pictures,doctormarketing,financing">
					<div id="page1" class="centered">
						<div id="bottom-content-wrapper">
							<div id="mobile-content">
								#includeContent()#
							</div>
						</div>
					</div>
				</cfcase>
				<cfdefaultcase>
					#includeContent()#
				</cfdefaultcase>
			</cfswitch>
		#includePartial("/footer_mobile")#
	</cfoutput>
</cfsavecontent>

<cfoutput>#fnCompress(contentHTML)#</cfoutput>

