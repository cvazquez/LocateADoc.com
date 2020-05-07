<cfset styleSheetLinkTag(source="doctorsonly/addlisting", head=true)>
<cfoutput>
	<!-- main -->
	<div id="main">
		#includePartial("/shared/breadcrumbs")#
		<!--- #includePartial(partial	= "/shared/ad",	size = "generic728x90top")# --->
		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder article-container">
				<!--- #includePartial("/shared/pagetools")# --->
				<cfswitch expression="#params.page#">
					<cfcase value="2">#includePartial("addlisting-page2")#</cfcase>
					<cfcase value="3">#includePartial("addlisting-page3")#</cfcase>
					<cfcase value="4">
						<cfif isPremier>
							#includePartial("addlisting-thankyou1")#
						<cfelse>
							#includePartial("addlisting-thankyou2")#
						</cfif>
					</cfcase>
					<cfdefaultcase>#includePartial("addlisting-frontpage")#</cfdefaultcase>
				</cfswitch>
			</div>
		</div>
	</div>
</cfoutput>