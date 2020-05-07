<cfoutput>

<cfsavecontent variable="js_contactform_anchor">
	<script type="text/javascript">
		$(document).ready(function(){
				setTimeout(function(){ window.location.hash = 'ContactForm';}, 3000);
			});
	</script>
</cfsavecontent>

<cfhtmlhead text="#js_contactform_anchor#">

	<!-- content -->
	<div class="content print-area">
		<div class="welcome-box">
			<a name="ContactForm" id="ContactForm" class="native-anchor"><h1>Contact the Doctor</h1></a>
		</div>
		<div class="contact-us">
			<cfswitch expression="#currentPage#">
				<cfdefaultcase>
					#includePartial("contactform1_mobile")#
					<cfset analyticsPageTrack = "/funnel_G2/step1.html">
				</cfdefaultcase>
				<cfcase value="2">
					#includePartial("contactform2_mobile")#
					<cfset analyticsPageTrack = "/funnel_G2/step2.html">
				</cfcase>
				<cfcase value="3">
					#includePartial("contactform3_mobile")#
					<cfset analyticsPageTrack = "/funnel_G2/step3.html">
				</cfcase>
				<cfcase value="4">
					#includePartial("contactform4_mobile")#
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