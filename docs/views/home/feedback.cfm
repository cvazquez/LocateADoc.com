<cfoutput>
<div class="home_feedback_form"><h1>Feedback Form</h1>


<!--- Do not display the form if the user just submitted it successfully. --->
<cfif successMsg NEQ "">
	<div class="successMsg">#successMsg#</div>



<!--- START: FORM DISPLAY --->
<cfelse>

	<cfif errorMsg NEQ "">
		<div class="errorMsg">
			There were some problems with your feedback:#errorMsg#
		</div>
	</cfif>


	<p>
		Need to get in touch with us about something? Contact us below.
	</p>


	<p>
		While the volume of emails prevents us from responding to every feedback submission, the information
		you provide will be reviewed by the LocateADoc.com staff. This information will not be shared with
		the doctors on our site or any other third party (see our
		#linkTo(controller="home", action="privacy", text="Privacy Notice")# for further details). Any
		submission marked as "Questions" or "Corrections" in the form below will be responded to directly
		within 2 business days.
	</p>


	<p>
		Thank you for helping to improve LocateADoc.com.
	</p>


	<form name="feedback" method="post" action="/home/feedback">
		<input name="processing" type="hidden" value="1" />
		<input name="search_request" type="hidden" value="#form.query#" />
		<input name="url_addr" type="hidden" value="#form.url_addr#" />
		<input name="url_section" type="hidden" value="#form.url_section#" />
		<input name="remote" type="hidden" value="#CGI.REMOTE_ADDR#" />



	<cfif formPrompt NEQ "">
		<div class="prompt">#formPrompt#</div>
	</cfif>
		<p align="center">* Required</p>


		<div class="halfWidth">
			* Your Name:<br />
			<input name="name" type="text" id="name" size="40" value="#form.name#" maxlength="150" />
		</div>


		<div class="halfWidth">
			* Your Phone Number:<br />
			<input name="phone" type="text" id="phone" size="40" value="#form.phone#" maxlength="150" />
		</div>


		<div class="halfWidth">
			* Your Email:<br />
			<input name="email" type="text" id="email" size="40" value="#form.email#" maxlength="150" />
		</div>


		<div class="halfWidth">
			* Please select which kind of feedback you're giving us: <br />
	 		<select name="contactType" id="contactType">
				<option value="None">--Select One--</option>
				<option value="Correction">Correction</option>
				<option value="Suggestion">Suggestion</option>
				<option value="Compliment">Compliment</option>
				<option value="Question from Doctor">Question from Doctor</option>
				<option value="Question from Patient">Question from Patient</option>
				<option value="Technical Issue">Technical Issue</option>
			</select>
			<br clear="all" />
		</div>


		<div class="fullWidth">
			#textAreaLeadIn#
			<br />

			<textarea name="feedback" id="feedback" rows="10">#form.feedback#</textarea>
			<script type="text/javascript" language="javascript"><!--
				document.write("<small><br \/>" +
				"This writing area can be resized by clicking on the dots in its bottom right " +
				"corner and dragging them in the direction you want it to stretch.  Resizing " +
				"the writing area will not affect your feedback.<br \/>" +
				"<\/small>");
			--></script>
		</div>


		<div class="clear15"><br clear="all" /></div>


		<div class="fullWidth">
			*<cfinclude template="/LocateADocModules/_captcha.cfm">
			#c_label#: #c_field#
		</div>


		<div class="fullWidth">
				If you were looking for a specific doctor who wasn't listed in the search results, please
				enter the doctor's name or practice name here:
				<input	name="doctor_sought"
						id="doctor_sought"
						type="text"
						maxlength="150"
						size="40"
				/>
		</div>
		<br clear="all" />


		<div class="controls" align="center">
			<input name="button" type="submit" value="Submit Your Feedback/Question" />
		</div>


		<p align="left">
			We respect your privacy. We do not share your information with any third party (see our
			<a target="_blank" href="/site_tools/privacy_notice.cfm">Privacy Notice</a> for further
			details).
		</p>
	</form>

	<hr align="center" width="100%" size="1" />

	<p>
		Advertisers looking to purchase advertising on LocateADoc.com to better reach our site visitors
		should contact one of our Account Executives by sending email to
		<a href="mailto:sales@locateadoc.com">sales@locateadoc.com</a>.
	</p>
</cfif>
<!--- END: FORM DISPLAY --->
</div>
</cfoutput>
