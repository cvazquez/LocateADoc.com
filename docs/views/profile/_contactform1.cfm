<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1 and (not structKeyExists(FORM, "process_contact") or FORM.process_contact neq 1)>
	<cfset params = Request.oUser.appendUserInfo(params)>
</cfif>

<cfset skipPrompt = (val(params.miniID) gt 0) or (contactResult.errorList neq "") or (structKeyExists(Request.oUser, "saveMyInfo") and Request.oUser.saveMyInfo eq 1)>

<cfset FacebookContactFormCombo = 1>

<cfoutput>
  <div id="form-prompt"<cfif skipPrompt AND FacebookContactFormCombo EQ 0> style="display:none;"</cfif>>
	<cfif FacebookContactFormCombo EQ 0>
		<p>To consult with our doctor about a certain procedure or treatment, please continue below
		so we can contact you<cfif currentLocationDetails.phonePlus neq "">, or contact our office
		at <span style="color:##577B77;"><b>#formatPhone(currentLocationDetails.phonePlus)#</b></span></cfif>.</p>
	<cfelse>
		<cfif val(params.miniID)>
			<p class="full" style="color:##A64942; margin-top:0;"><strong>Thank you. Your contact information has been submitted to this doctor. We have also emailed you the information requested.</strong></p>
			<p class="full" style="color:##A64942; margin-top:0;"><strong>To better evaluate your needs, this doctor has requested more information about you and the procedures you are interested in. Please fill out the missing information below and select Submit.</strong></p>
		<cfelseif currentLocationDetails.phonePlus neq "">
			<p class="full" style="font-size:17px; margin-top:0;">To consult with our doctor about a certain procedure or treatment, please fill out your contact information below so we can contact you, or contact our office at <span style="color:##577B77;"><b>#formatPhone(currentLocationDetails.phonePlus)#</b></span>.</p>
		<cfelse>
			<p style="margin-top:0;">To consult with our doctor about a certain procedure or treatment, please fill out your contact information below so we can contact you.</p>
		</cfif>
	</cfif>
	<center>
		<cfif FacebookContactFormCombo EQ 1>
			<span style="margin: 0 0 5px; font: 18px/22px BreeBold, Arial, Helvetica, sans-serif; color: ##577b77; padding-right: 20px;">Tell Us About Yourself Below</span>
			<span style="padding-right: 20px;">OR</span>
		</cfif>
		<div class="facebook-sign-in fb-login"></div>
		<p class="login-sub">Information provided remains private and will not be used without your permission.</p>
		<cfif FacebookContactFormCombo EQ 0><p><a onclick="ResolvePrompt(); return false;" href="##">Continue without logging in</a></p></cfif>
	</center>
  </div>
  <div id="form-proper"<cfif not skipPrompt AND FacebookContactFormCombo EQ 0> style="display:none;"</cfif>>
	<cfif FacebookContactFormCombo EQ 0>
		<cfif val(params.miniID)>
			<p class="full" style="color:##A64942; margin-top:0;"><strong>Thank you. Your contact information has been submitted to this doctor. We have also emailed you the information requested.</strong></p>
			<p class="full" style="color:##A64942; margin-top:0;"><strong>To better evaluate your needs, this doctor has requested more information about you and the procedures you are interested in. Please fill out the missing information below and select Submit.</strong></p>
		<cfelseif currentLocationDetails.phonePlus neq "">
			<p class="full" style="font-size:17px; margin-top:0;">To consult with our doctor about a certain procedure or treatment, please fill out your contact information below so we can contact you, or contact our office at <span style="color:##577B77;"><b>#formatPhone(currentLocationDetails.phonePlus)#</b></span>.</p>
		<cfelse>
			<p style="margin-top:0;">To consult with our doctor about a certain procedure or treatment, please fill out your contact information below so we can contact you.</p>
		</cfif>
	</cfif>
	<cfif contactResult.errorList neq "">
		<cfif ListFind(contactResult.errorList,"writeError")>
			<h3 class="invalid-input">There are errors in your form input. Please resolve the issues and submit the form again.</h3>
		<cfelse>
			<h3 class="invalid-input">There are errors in your form input. Please resolve the issues in each highlighted field and submit the form again.</h3>
		</cfif>
	</cfif>
	<cfif FacebookContactFormCombo EQ 0><h2 style="margin-bottom:15px;">Tell Us About Yourself</h2></cfif>
	<form name="addcontact" class="FBpop" method="post">
		<fieldset>
			<div class="row">
				<label class="full login-set">
					<!--- <a class="fb_button fb_button_large fb-hidefirst fb-login login-set"><span class="fb_button_text">Complete with Facebook</span></a> --->
					<!--- <div class="facebook-sign-in fb-login"></div>
					<p style="margin:0px;">Or complete the following fields:</p> --->
					<i style="font-size:14px;">Fields with an asterisk are required.</i>
				</label>
				<label class="full fb-only" style="display:none;">
					<p style="width:400px;margin:0px;">We've gathered your available information from Facebook. Please complete the items below:</p>
				</label>
			</div>
			<div class="row required">
				<label <cfif ListFind(contactResult.errorList,"firstname")>class="invalid-input" </cfif>for="firstname">Patient's First Name*</label>
					<div class="styled-input" style="width: 215px; height:20px;"><input style="width:179px;" name="firstname" id="firstname" type="text" class="noPreText" value="#params.firstname#" /></div>
			</div>
			<div class="row required">
				<label <cfif ListFind(contactResult.errorList,"lastname")>class="invalid-input" </cfif>for="lastname">Patient's Last Name*</label>
				<div class="styled-input" style="width: 215px; height:20px;"><input style="width:179px;" name="lastname" id="lastname" type="text" class="noPreText" value="#params.lastname#" /></div>
			</div>
			<div class="row <cfif NOT addressRequired>not-</cfif>required">
				<label <cfif ListFind(contactResult.errorList,"address")>class="invalid-input" </cfif>for="address">Address<cfif addressRequired>*</cfif></label>
				<div class="styled-input" style="width: 215px; height:20px;"><input style="width:179px;" name="address" id="address" type="text" class="noPreText" value="#params.address#" /></div>
			</div>
			<div class="row required">
				<label <cfif ListFind(contactResult.errorList,"city")>class="invalid-input" </cfif>for="city">City*</label>
				<div class="styled-input" style="width: 215px; height:20px;"><input style="width:179px;" name="city" id="city" type="text" class="noPreText" value="#params.city#" /></div>
			</div>
			<div class="row required">
				<label <cfif ListFind(contactResult.errorList,"state")>class="invalid-input" </cfif>for="state">State/Province/Region*</label>
				<!--- <div style="width: 217px;" class="selectArea temporary"><span class="left"></span><span class="center">Select State</span><a href="##" class="selectButton"></a></div> --->
					<div class="styled-select" style="width: 215px;">
					<select name="state" id="state" class="comment-states hidefirst populatesCountry" style="width:235px;">
						<option value="">Select State</option>
						<cfset currentCountry = "">
						<cfloop query="states">
							<cfif states.country neq currentCountry>
								<cfif currentrow gt 1><option value="">&nbsp;</option></cfif>
								<cfset currentCountry = states.country>
								<option value="">--#states.country#--</option>
							</cfif>
							<option name="state_#id#" value="#id#" country="#states.country#" <cfif params.state eq id>selected </cfif>>#name#</option>
						</cfloop>
					</select>
				</div>
			</div>
			<div class="row required">
				<label <cfif ListFind(contactResult.errorList,"postalCode")>class="invalid-input" </cfif>for="postalCode">Zip/Postal Code*</label>
				<div class="styled-input" style="width: 215px; height:20px;"><input style="width:179px;" name="postalCode" id="postalCode" type="text" class="noPreText" value="#params.postalCode#" /></div>
			</div>
			<div class="row required">
				<label <cfif ListFind(contactResult.errorList,"phone")>class="invalid-input" </cfif>for="Phone">Daytime Phone*</label>
				<div class="styled-input" style="width: 215px; height:20px;"><input style="width:179px;" name="Phone" id="Phone" type="text" class="noPreText" value="#params.Phone#" /></div>
			</div>
			<div class="row required">
				<label <cfif ListFind(contactResult.errorList,"email")>class="invalid-input" </cfif>for="email">Email*</label>
				<div class="styled-input" style="width: 215px; height:20px;"><input style="width:179px;" name="email" id="email" type="text" class="noPreText" value="#params.email#" /></div>
			</div>
			<div class="row required">
				<label <cfif ListFind(contactResult.errorList,"age")>class="invalid-input" </cfif>for="age">Patient's Age*</label>
				<!--- <div style="width: 217px;" class="selectArea temporary"><span class="left"></span><span class="center">Select Age</span><a href="##" class="selectButton"></a></div> --->
					<div class="styled-select" style="width: 215px;">
					<select name="age" id="age" class="hidefirst" style="width:235px;">
						<option value="">Select Age</option>
							<cfloop list="13 and under,14-17,18-24,25-34,35-44,45-54,55+" index="i">
							<option value="#i#" <cfif params.age eq i>selected</cfif>>#i#</option>
							</cfloop>
					</select>
				</div>
			</div>
			<div class="row required">
				<label <cfif ListFind(contactResult.errorList,"patientGender")>class="invalid-input" </cfif>for="patientGender">Patient's Gender*</label>
				<div class="radio-list">
					<p>
						<input id="patientGenderM" name="patientGender" type="radio" value="m"<cfif params.patientGender eq "m"> checked</cfif> />
						<label for="patientGenderM" style="margin-left:0; font: 13px/20px BreeLight, Arial, Helvetica, sans-serif;">Male</label>
					</p>
					<p>
						<input id="patientGenderF" name="patientGender" type="radio" value="f"<cfif params.patientGender eq "f"> checked</cfif> />
						<label for="patientGenderF" style="margin-left:0; font: 13px/20px BreeLight, Arial, Helvetica, sans-serif;">Female</label>
					</p>
				</div>
			</div>
			<div class="row show-name required">
				<input id="newsletter" name="newsletter" type="checkbox" value="1" checked />
				<label style="float:none;margin-left:0;width: 99%;" for="newsletter"><strong>Yes!</strong> I'd like to receive the FREE monthly "Beautiful Living" e-newsletter with up to date elective surgery info and unique perspectives from doctors and patients.</label>
			</div>
			<cfif Request.oUser.saveMyInfo neq 1>
				<div class="row login-set">
					#Request.oUser.getCheckBox(labelStyle="width:300px;margin-left:10px;")#
				</div>
			<cfelse>
				#Request.oUser.getCheckBox(labelStyle="width:300px;margin-left:10px;")#
			</cfif>
		</fieldset>
		<input type="hidden" name="process_contact" value="1">
		<input type="hidden" name="miniID" value="#params.miniID#">
		<div class="btn" style="margin-left:405px;">
			<br />
			<input type="submit" class="btn-search btn-large-text" value="Submit">
		</div>
		<div class="row required" style="font: 13px/16px BreeLight, Arial, Helvetica, sans-serif;">
			<br /><br /><br /><br /><!--- Spacing for the age drop down. Don't remove unless something else is added here. --->
		</div>
	</form>
  </div>
</cfoutput>