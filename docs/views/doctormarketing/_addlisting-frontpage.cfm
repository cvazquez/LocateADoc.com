<cfoutput>
	<!-- content -->
	<div class="add-listing-content print-area">
		<h1 class="title-shadow">Want more patient leads?</h1>
		<h2>List your health, medical, or wellness practice on LocateADoc.com</h2>
		<p>Since 1998, LocateADoc.com has been the top patient lead generation network used by doctors marketing procedures/treatments and services.</p>
		<p><b>LocateADoc.com allows you to:</b></p>
		<ul>
			<li>Receive unlimited patient leads</li>
			<li>Customize your mobile and desktop profile 24/7</li>
			<li>Manage all patient leads in one spot</li>
			<li>Send automated email messages to all new leads on customizable templates</li>
			<li>Track all opened and unopened leads</li>
			<li>Share gallery updates and positive reviews in social media</li>
			<li>Receive patient questions as an Ask A Doctor expert for your profile page</li>
			<li>Micro-target prospective new business by procedure, treatment and specialty</li>
			<li>Measure your return on investment (ROI)</li>
			<li>Secure credit card or check processing, on our secure servers, plus a secure platform to manage your account. (SSL and PCI compliant)</li>
		</ul>

		<p>Learn more about advertising opportunities on this <a href="/doctor-marketing/advertising">interactive advertising guide</a>.</p>

		<p>Questions? Call us at <a href="tel:888-834-8593">1-888-834-8593</a> or email <a href="mailto:info@LocateADoc.com">info@LocateADoc.com</a></p>
	</div>

	<!-- aside2 -->
	<div class="aside2 mobileWidget">
		#includePartial(partial="addlistingform",alternateTitle=true)#
	</div>



	<div class="add-listing-bottom" <!--- style="display: inline-block; width: 450px; padding: 30px 25px 25px; float: left;" --->>
		<!-- widget -->
		<div class="add-listing-marketingsolutions mobileWidget" <!--- style="width: 435px; overflow: hidden; padding-left: 15px;" --->>
			#includePartial("onlinemarketingsolutionsfordoctors")#
		</div>

		<cfloop query="testimonialInfo">
			<div class="add-listing-testimonial testimonial">
				<div class="photo">
					<img src="#testimonialInfo.url#">
				</div>
				#testimonialInfo.content#
			</div>
		</cfloop>
	</div>

	<!-- aside2 -->
	<div class="add-listing-aside2"<!---  style="margin: 10px 0 0; float: right;" --->>
		<div class="widget mobileWidget" <!--- style="padding-top:20px;" --->>
			#includePartial("bundlebox")#
		</div>
	</div>
</cfoutput>