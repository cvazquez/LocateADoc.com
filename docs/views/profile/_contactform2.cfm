<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1 and (not structKeyExists(FORM, "process_contact") or FORM.process_contact neq 1)>
	<cfset params = Request.oUser.appendUserInfo(params)>
</cfif>

<cfoutput>
	<p style="margin-top:0;">To better evaluate your needs, please submit information about the procedure(s) you are interested in. Once the information is filled out please click Submit.</p>
	<cfif contactResult.errorList neq "">
		<cfif ListFind(contactResult.errorList,"writeError")>
			<h3 class="invalid-input">There are errors in your form input. Please resolve the issues and submit the form again.</h3>
		<cfelse>
			<h3 class="invalid-input">There are errors in your form input. Please resolve the issues in each highlighted field and submit the form again.</h3>
		</cfif>
	</cfif>
	<h2 style="margin-bottom:10px;">Tell Us What You are Interested In</h2>
	<form name="addcontact" method="post">
		<fieldset>
			<div class="row">
				<label class="full" style="margin-left:0;"><i>Fields with an asterisk are required.</i></label>
			</div>
			<cfif variables.procedures.recordcount>
				<div class="row required">
					<label class="full<cfif ListFind(contactResult.errorList,"procedures")> invalid-input</cfif>" style="margin-left:0;">Which procedure(s) is the patient interested in?*</label>
					<div class="procedures-checklist">
						<cfloop query="variables.procedures">
							<div class="procedure">
								<input id="procedureId#variables.procedures.id#" type="checkbox" name="procedures" value="#variables.procedures.id#" <cfif ListFind(params.procedures,procedures.id) gt 0>checked </cfif>>
								<p><label class="procedure-list-labels tooltip" for="procedureId#variables.procedures.id#" style="margin-left:0;font: 13px/20px BreeLight, Arial, Helvetica, sans-serif; letter-spacing:-1px;" title="#variables.procedures.name#">#variables.procedures.name#</label></p>
							</div>
						</cfloop>
					</div>
				</div>
			</cfif>
			<div class="row required">
				<label class="full<cfif ListFind(contactResult.errorList,"time")> invalid-input</cfif>" style="margin:10px 0 5px 0;">How soon would the patient like to have the procedure?*</label>
				<div class="radio-list">
					<cfset timeFieldIndex = 1>
					<cfloop list="within 1 month,within 2-3 months,within 4-6 months,after 6 months" index="i">
						<p><input name="time" type="radio" id="time#timeFieldIndex#" value="#i#"<cfif params.time eq i> checked</cfif> /> <label for="time#timeFieldIndex#" style="font: 14px/20px BreeLight, Arial, Helvetica, sans-serif;margin-left:0;">#i#</label></p>
						<cfset timeFieldIndex += 1>
					</cfloop>
				</div>
			</div>
			<div class="row not-required">
				<label class="full<cfif ListFind(contactResult.errorList,"information")>invalid-input</cfif>" style="margin:10px 0 5px 0;" for="information">What should the doctor know about the patient?</label>
				<textarea cols="75" name="information" rows="8" wrap="physical" style="width:585px;">#params.information#</textarea>
			</div>
			<!--- <cfif Request.oUser.saveMyInfo neq 1>
				<div class="row login-set">
					#Request.oUser.getCheckBox(labelStyle="width:300px;margin-left:10px;")#
				</div>
			<cfelse>
				#Request.oUser.getCheckBox(labelStyle="width:300px;margin-left:10px;")#
			</cfif> --->
		</fieldset>
		<input type="hidden" name="contactIDLAD2" value="#URLEncodedFormat(Encrypt(params.contactIDLAD2, captcha_key, 'BLOWFISH'))#">
		<input type="hidden" name="process_contact" value="2">
		<input type="hidden" name="miniID" value="#params.miniID#">
		<div class="btn" style="margin-left:500px;">
			<input type="submit" class="btn-search btn-large-text" value="Submit">
		</div>
	</form>
	<script type="text/javascript">
		$(function(){
			SmartTruncate('.procedure-list-labels',20,195,true);
			<!--- $(".tooltip").tooltip({
				delay: 0,
				track: true
			}); --->
		});
	</script>
</cfoutput>
<!--- <cfsavecontent variable="tooltipJSandCSS">
	<cfoutput>
		<link rel="stylesheet" type="text/css" href="/stylesheets/jquery.tooltip.css" />
		<script type="text/javascript" src="/javascripts/jquery.tooltip.min.js"></script>
	</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#tooltipJSandCSS#"> --->