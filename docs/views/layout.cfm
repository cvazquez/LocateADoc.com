<cfparam name="isError" default="false">

<cfset pageHistory()>

<cfsavecontent variable="contentHTML">
<cfoutput>
	#includePartial("/header")#
	<cfif not isError>
		<!--- START: CONTROLLER-SPECIFIC CONTENT ENCAPSULATION/STYLING --->
		<cfswitch expression="#params.controller#">
			<cfcase value="profile">
				<!-- main -->
				<div id="main">
					#includePartial("/shared/breadcrumbs")#
					<cfif displayAd>
						#includePartial(partial	= "/shared/ad",
										size	= "#adType#728x90top#explicitAd ? "Explicit" : ""#")#
					</cfif>
					<!-- container inner-container2 -->
					<div class="container inner-container2"<cfif params.action eq "reviews"> itemscope itemtype="http://schema.org/Organization"</cfif>>
						#includePartial("/shared/pagetools")#
						<!-- topsections -->
						#includePartial("/profile/topsection")#
						<!-- tabnav -->
						#includePartial("profileTabs")#
						<!-- twocolumns -->
						<div class="twocolumns">
							#includePartial("/shared/noscript")#
							#includeContent()#
						</div>
					</div>
				</div>
				#includePartial("/profile/topbar")#
			</cfcase>

			<!--- START: HOME CONTROLLER ACTION-SPECIFIC CONTENT ENCAPSULATION/STYLING --->
			<cfcase value="home">
				<cfswitch expression="#params.action#">
					<cfcase delimiters="," value="index,advanced">
						#includePartial("/shared/noscript")#
						#includeContent()#
					</cfcase>

					<cfdefaultcase>
						<!-- START: MAIN -->
						<div id="main">
							<div id="nonAdVerticleSpacer"><br clear="all" /></div>
							<!-- START: CONTAINER INNER-CONTAINER -->
							<div class="container inner-container">
								<!-- START: INNER-HOLDER -->
								<div class="inner-holder">
									<!-- options -->
									#includePartial("/shared/pagetools")#
									<!-- START: CONTENT-FRAME -->
									<!--- <div class="content-frame"> --->
										<div id="full-content">
											<!-- START: PAGE-SPECIFIC CONTENT -->
											<div id="home">
												#includePartial("/shared/noscript")#
												#includeContent()#
											<!-- END: PAGE-SPECIFIC CONTENT -->
											</div>
										</div>
									<!--- </div> --->
									<!-- END: CONTENT-FRAME -->
								</div>
								<!-- END: INNER-HOLDER -->
							</div>
							<!-- END: CONTAINER INNER-CONTAINER -->
						</div>
						<!-- END: MAIN -->
					</cfdefaultcase>
				</cfswitch>
			</cfcase>
			<!--- END: HOME CONTROLLER ACTION-SPECIFIC CONTENT ENCAPSULATION/STYLING --->

			<cfdefaultcase>
				#includePartial("/shared/noscript")#
				#includeContent()#
			</cfdefaultcase>
		</cfswitch>
		<!--- END: CONTROLLER-SPECIFIC CONTENT ENCAPSULATION/STYLING --->
	<cfelse>
		#includeContent()#
	</cfif>
	#includePartial("/footer")#
</cfoutput>
</cfsavecontent>

<cfoutput>
	#fnCompress(contentHTML)#
</cfoutput>