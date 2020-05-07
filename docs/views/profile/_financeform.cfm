<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1 and (not structKeyExists(FORM, "process_contact") or FORM.process_contact neq 1)>
	<cfset params = Request.oUser.appendUserInfo(params)>
</cfif>

<cfoutput>
	<form action="##" class="FBpop" method="post" name="patientfinancing" target="patientfinancing" id="ProfileFinanceForm">
		<div style="padding:.2em; background-color:##DDD; color:##003300; font:bold 1.2em Arial,Helvetica,sans-serif;" align="center" class="carecredit_font">
			LocateADoc.com Patient Financing Questionnaire
		</div>

		<div style="border:1px dashed ##DDD; margin-bottom:5px; padding:5px;">
		<p style="color:##333;font-weight: bold" class="carecredit_font">
			Keep me in the loop!  Yes, I want to receive a list of LocateADoc.com doctors that accept CareCredit from my area.
		</p>

		<div class="ProfileCareCreditFormTable">
			<div class="ProfileCareCreditFormRow carecredit_font">
				<label>First Name<br></label>
				<span class="ContentSmall"><input type="text" name="firstname" value="#params.firstname#" class="noPreText"></span>

			</div>
			<div class="ProfileCareCreditFormRow carecredit_font">
				<label>Last Name<br /></label>
					<input type="text" name="lastname" value="#params.lastname#" class="noPreText"><br>
			</div>
			<div class="ProfileCareCreditFormRow carecredit_font">
				<label>My Email<br /></label>
				<input type="text" name="email" value="#params.email#" class="noPreText"><br>
			</div>
			<div class="ProfileCareCreditFormRow carecredit_font">
				<label>Zip Code<br /></label>
				<input type="text" name="zip" value="#params.zip#" class="noPreText"><br>
			</div>
		</div>

		<cfif params.PatientFinanceId EQ 6>
		<p align="left" style="color:##333; border-bottom: 3px solid silver; margin-bottom: 15px; padding-bottom: 15px;">
			Clicking the button below will forward you to #params.PatientFinanceType#.com to begin the financing application process.
			Please click the Apply Now button below to continue. Please turn off pop-up blockers to transfer to #params.PatientFinanceType#.
		</p>
		<cfelse>
			<p style="color:##333; border-bottom: 3px solid silver; margin-bottom: 15px; padding-bottom: 15px;" class="carecredit_font">Clicking the CareCredit Apply Now button below will forward you to CareCredit.com to begin the easy financing application.  Please click button below and turn off your pop-up blocker.</p>
		</cfif>

	  	<input type="hidden" name="submitted" value="1">
	  	<input type="hidden" name="source_id" value="2">
	  	<input type="hidden" name="sid" value="#params.sid#">
	  	<input type="hidden" name="info_id" value="#params.info_id#">

		<div class="ProfileCareCreditApplyNow">
		<cfif params.PatientFinanceId EQ 6>
		    <input type="submit" alt="Apply Online Now!" border="0" Value="Apply Now" onClick="document.getElementById('pfcopy').style.display='inline';document.getElementById('pfform').style.display='none';">
		<cfelse>
	    	<input type="image" src="/images/carecredit_button_applynow_v2.png" alt="Apply Online Now!" <!--- width="202"  --->height="80" border="0" onClick="document.getElementById('pfcopy').style.display='inline';document.getElementById('pfform').style.display='none';">
		</cfif>
		</div>
		</div>
	</form>
</cfoutput>