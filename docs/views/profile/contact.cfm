<cfoutput>
	<!-- content -->
	<div class="content print-area">
		<div class="welcome-box">
			<h1>Contact the Doctor</h1>
		</div>
		<div class="contact-us">
			<cfswitch expression="#currentPage#">
				<cfdefaultcase>
					#includePartial("contactform1")#
					<cfset analyticsPageTrack = "/funnel_G2/step1.html">
				</cfdefaultcase>
				<cfcase value="2">
					#includePartial("contactform2")#
					<cfset analyticsPageTrack = "/funnel_G2/step2.html">
				</cfcase>
				<cfcase value="3">
					#includePartial("contactform3")#
					<cfset analyticsPageTrack = "/funnel_G2/step3.html">
				</cfcase>
				<cfcase value="4">
					#includePartial("contactform4")#
					<cfset analyticsPageTrack = "/funnel_G2/step4.html">
				</cfcase>
			</cfswitch>
		</div>
	</div>
	<!-- aside -->
	<div class="aside">
		#includePartial("/shared/practicesnapshotsidebox")#
		<cfif displayAd IS TRUE>
			#includePartial(partial	= "/shared/ad",
							size	= "#adType#300x250")#
		</cfif>
		#includePartial("/shared/specialofferssidebox")#
	</div>
</cfoutput>