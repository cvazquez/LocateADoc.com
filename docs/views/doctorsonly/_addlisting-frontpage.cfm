<cfoutput>
	<!-- content -->
	<div class="add-listing-content print-area">
		<h1 class="title-shadow">Want more patient leads?</h1>
		<h2>List your medical practice on LocateADoc</h2>
		<p>Since 1999, LocateADoc.com has been the top patient lead generation network used by doctors marketing non-insured procedures and services.</p>
		<p><b>LocateADoc.com allows you to:</b></p>
		<ul>
			<li>Receive unlimited patient leads</li>
			<li>Customize your profile 24/7</li>
			<li>Manage all patient leads in one spot</li>
			<li>Send automated email messages to all new leads on customizable templates</li>
			<li>Track all opened and unopened leads</li>
			<li>Share gallery updates and positive recommendations in social media</li>
			<li>Measure your return on investment (ROI)</li>
		</ul>
		<p>Questions? Call us at 1-888-834-8593 or email <a href="mailto:info@LocateADoc.com">info@LocateADoc.com</a></p>
		<!--- <cfloop query="testimonialInfo">
			<div class="testimonial">
				<div class="photo">
					<img src="#testimonialInfo.url#">
				</div>
				#testimonialInfo.content#
			</div>
		</cfloop> --->
	</div>

	<!-- aside2 -->
	<div class="aside2">
		#includePartial(partial="addlistingform",alternateTitle=true)#
	</div>

	<div class="full-content">
		<cfloop query="testimonialInfo">
			<div class="add-listing-testimonial testimonial">
				<div class="photo">
					<img src="#testimonialInfo.url#">
				</div>
				#testimonialInfo.content#
			</div>
		</cfloop>
	</div>
</cfoutput>