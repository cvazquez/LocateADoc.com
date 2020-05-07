<p style="margin-top:0; font-weight:bold;">You're almost done! This is the last page.</p>
<form name="addcontact" method="post">
	<fieldset>

		<cfif contactResult.errorList neq "">
			<div class="row">
				<cfif ListFind(contactResult.errorList,"writeError")>
					<h3 class="invalid-input">There are errors in your form input. Please resolve the issues and submit the form again.</h3>
				<cfelse>
					<h3 class="invalid-input">There are errors in your form input. Please resolve the issues in each highlighted field and submit the form again.</h3>
				</cfif>
			</div>
		</cfif>

		<cfoutput query="specialtyQuestions" group="id">
			<div class="row not-required">
				<label class='full<cfif ListFind(flash("q_"&id),"height")> invalid-input</cfif>' for="q_#id#" style="margin-left:0;">#name#</label>
				<cfswitch expression="#fieldtype#">
					<cfcase value="text">
						<div class="styled-input" style="width: 215px; height:20px;"><input style="width:179px;" name="q_#id#" type="text" class="noPreText" value="#Evaluate('params.q_'&id)#" /></div>
					</cfcase>
					<cfcase value="select">
						<div class="styled-select" style="width: 215px;">
							<select name="q_#id#" class="hidefirst" style="width:235px;">
								<option value="">-- Select One --</option>
								<cfoutput>
									<option value="#value#"<cfif Evaluate('params.q_'&id) eq value> selected</cfif> >#display#</option>
								</cfoutput>
							</select>
						</div>
					</cfcase>
					<cfcase value="checkbox">
						<cfset checkboxCounter = 1>
						<div class="radio-list" style="float:none;">
						<cfoutput>
							<p>
								<input name="q_#id#" id="q_#id#_#checkboxCounter#" type="checkbox" value="#value#" <cfif ListFind(Evaluate('params.q_'&id),value) gt 0>checked</cfif>/>
								<label for="q_#id#_#checkboxCounter#" style="margin-left:0; font: 13px/16px BreeLight, Arial, Helvetica, sans-serif; width:550px; float:none;">#display#</label>
							</p>
							<cfset checkboxCounter += 1>
						</cfoutput>
						</div>
					</cfcase>
					<cfcase value="radio">
						<cfset radioCounter = 1>
						<div class="radio-list" style="float:none;">
						<cfoutput>
							<p>
								<input name="q_#id#" id="q_#id#_#radioCounter#" type="radio" value="#value#" <cfif Evaluate('params.q_'&id) eq value>checked</cfif>/>
								<label for="q_#id#_#radioCounter#" style="margin-left:0; font: 13px/16px BreeLight, Arial, Helvetica, sans-serif; width:550px; float:none;">#display#</label>
							</p>
							<cfset radioCounter += 1>
						</cfoutput>
						</div>
					</cfcase>
				</cfswitch>
			</div>
		</cfoutput>

		<cfoutput>
		<div class="row not-required">
			<label <cfif ListFind(contactResult.errorList,"height")>class="invalid-input" </cfif>for="height" style="clear:left;float:none;margin:10px 0 5px 0;">Patient's Height</label>
				<div class="styled-select" style="width: 215px;">
				<select name="height" id="height" class="comment-states hidefirst" style="width:235px;">
					<option value="">Select Height</option>
					<option value="4'-" <cfif params.contactday eq "4'-">selected </cfif>>4' or lower</option>
					<cfloop from="4" to="7" index="feet">
					  <cfloop from="#Iif(feet eq 4,1,0)#" to="11" index="inches">
						<option value="#feet#' #inches#''" <cfif params.height eq "#feet#' #inches#''">selected</cfif>>#feet#' #inches#''</option>
					  </cfloop>
					</cfloop>
					<option value="8'+" <cfif params.contactday eq "8'+">selected </cfif> =>8' or higher</option>
				</select>
			</div>
		</div>
		<div class="row not-required">
			<label <cfif ListFind(contactResult.errorList,"weight")>class="invalid-input" </cfif>for="weight" style="float:none;margin-left:0;">Patient's Weight</label>
			<div class="styled-input" style="width: 215px; height:20px;"><input style="width:179px;" name="weight" id="weight" type="text" class="noPreText" value="#params.weight#" /></div><p class="lbs">&nbsp;lbs.</p>
		</div>
		<div class="row not-required">
			<label <cfif ListFind(contactResult.errorList,"smoke")>class="invalid-input" </cfif>for="smoke" style="float:none;margin-left:0;">Does the patient smoke?</label>
			<div class="radio-list">
				<p><input name="smoke" id="smoke_1" type="radio" value="1"<cfif params.time eq 1> checked</cfif> /> <label for="smoke_1" style="float:none;margin-left:0;font: 13px/16px BreeLight, Arial, Helvetica, sans-serif;">Yes</label></p>
				<p><input name="smoke" id="smoke_2" type="radio" value="0"<cfif params.time eq 0> checked</cfif> /> <label for="smoke_2" style="float:none;margin-left:0;font: 13px/16px BreeLight, Arial, Helvetica, sans-serif;">No</label></p>
			</div>
		</div>
		<div class="row not-required">
			<label class="full" style="margin:10px 0 5px 0;">How would you like to be contacted by this doctor?</label>
			<div class="radio-list">
				<p>
					<input name="contactoption" id="contactoption1" type="checkbox" value="phone" <cfif ListFind(params.contactoption,"phone") gt 0>checked</cfif>/>
					<label for="contactoption1" style="margin-left:0; font: 13px/16px BreeLight, Arial, Helvetica, sans-serif; width:550px; float:none;">By Phone</label>
				</p>
				<p>
					<input name="contactoption" id="contactoption2" type="checkbox" value="mail" <cfif ListFind(params.contactoption,"mail") gt 0>checked</cfif>/>
					<label for="contactoption2" style="margin-left:0; font: 13px/16px BreeLight, Arial, Helvetica, sans-serif; width:550px; float:none;">By Mail</label>
				</p>
				<p>
					<input name="contactoption" id="contactoption3" type="checkbox" value="email" <cfif ListFind(params.contactoption,"email") gt 0>checked</cfif>/>
					<label for="contactoption3" style="margin-left:0; font: 13px/16px BreeLight, Arial, Helvetica, sans-serif; width:550px; float:none;">By Email</label>
				</p>
			</div>
		</div>
		<div class="row not-required">
			<label class="full<cfif ListFind(contactResult.errorList,"contacttime")> invalid-input</cfif>" style="margin:10px 0 5px 0;">When would be the best time for you to be contacted by phone?</label>
			<div class="styled-select" style="width: 215px; float:left; margin-right:10px;">
				<select name="contactday" id="contactday" class="hidefirst" style="width:235px;">
					<option value="">Select Day</option>
					<cfloop list="Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday" index="i">
						<option value="#i#"<cfif params.contactday eq i> selected</cfif> >#i#</option>
					</cfloop>
				</select>
			</div>
			<div class="styled-select" style="width: 215px;">
				<select name="contacttime" id="contacttime" class="hidefirst" style="width:235px;">
					<option value="">Select Time</option>
					<cfloop list="Morning,Afternoon,Evening" index="i">
						<option value="#i#"<cfif params.contacttime eq i> selected</cfif> >#i#</option>
					</cfloop>
				</select>
			</div>
		</div>
		<cfloop from="1" to="6" index="i">
			<cfif Evaluate("doctor.question#i#") neq "">
			<div class="row not-required">
				<label <cfif ListFind(contactResult.errorList,"question#i#")>class="invalid-input" </cfif>for="weight" style="float:none;margin-left:0;width: 99%;">#Evaluate("doctor.question" & i)#</label>
				<div class="styled-input" style="width: 215px; height:20px;"><input style="width:179px;" name="question#i#" id="question#i#" type="text" class="noPreText" value="#Evaluate('params.question'&i)#" /></div>
			</div>
			</cfif>
		</cfloop>
		<cfif currentLocationDetails.hasSeminar eq 1>
			<div class="row show-name required">
				<input id="seminar" name="seminar" type="checkbox" value="1" <cfif params.seminar eq 1>checked</cfif> />
				<label style="float:none;margin-left:0;width: 99%;" for="seminar">I am interested in attending an educational event to learn more about #topSpecialties.name#?</label>
			</div>
		</cfif>
		<cfif topSpecialties.isPremier eq 1>
			<div class="row show-name required">
				<input id="financing" name="financing" type="checkbox" value="1" <cfif params.financing eq 1>checked</cfif> />
				<label style="float:none;margin-left:0;width: 99%;" for="financing">I would like financing information to help pay for the patient's procedure.*</label>
				<p>* There are many finance options available.  Please check with the Doctor's Practice for information pertaining to the types of financing they accept.</p>
			</div>
		</cfif>
		<!--- <div class="row show-name required">
			<input id="newsletter" name="newsletter" type="checkbox" value="1" <cfif params.newsletter eq 1>checked</cfif> />
			<label style="float:none;margin-left:0;width: 99%;" for="newsletter"><strong>Yes!</strong> I'd like to receive the FREE monthly "Beautiful Living" e-newsletter with up to date elective surgery info and unique perspectives from doctors and patients.</label>
		</div> --->
		<!--- <cfif doctor.id neq 682474>
			<div class="row required">
				<label class="full">
					<input name="spa" type="checkbox" value="1" <cfif params.spa eq 1>checked</cfif> />
					I would like to enter the $50 Spa Contest.
				</label>
			</div>
		</cfif> --->

	</fieldset>
	<input type="hidden" name="contactIDLAD2" value="#URLEncodedFormat(Encrypt(params.contactIDLAD2, captcha_key, 'BLOWFISH'))#">
	<input type="hidden" name="process_contact" value="3">
	<input type="hidden" name="miniID" value="#params.miniID#">
	</cfoutput>
	<div class="btn" style="margin-left:500px;">
		<input type="submit" class="btn-search btn-large-text" value="Submit">
	</div>
</form>