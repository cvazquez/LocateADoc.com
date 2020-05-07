<cfparam name="title" default="">
<cfparam name="ShareText" default="#title#">
<cfparam name="ShowEmail" default="false">
<cfparam name="ShareSummary" default="">

<cfoutput>
	<div class="sidebox" style="margin-top: -13px; margin-bottom: 20px; width:275px;">
		<div class="frame" style="width:315px;">
			<h4>Share <strong>This Page</strong></h4>
			<!--- <script>console.log("socialbuttons: #ShareText#")</script> --->
			<!-- ShareThis Buttons BEGIN -->
			<!--- <cfif ShowEmail><span class="st_email_hcount" displayText="Email" st_title="#ShareText#"></span></cfif> --->
			<span class="st_pinterest_hcount" st_title="#ShareText#"></span>
			<span class="st_twitter_hcount" st_title="#ShareText#"></span>
			<span class="st_plusone_hcount" st_title="#ShareText#"></span>
			<span class='st_linkedin_hcount' st_title="#ShareText#"></span>
			<span class="st_email_hcount" displayText="Email" st_title="#ShareText#"></span>
			<span class='st_facebook_hcount' displayText='#ShareText#'></span>
			<!-- ShareThis Buttons END -->
		</div>
	</div>
</cfoutput>