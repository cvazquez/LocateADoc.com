<cfparam name="arguments.alternateTitle" default="false">
<cfparam name="errorList" default="">

<cfset javaScriptIncludeTag(source="doctormarketing/addlistingform", head=true)>

<cfset formURL = (Server.ThisServer neq "dev" AND listFirst(cgi.server_name, ".") neq "alpha1") ? "https://#CGI.SERVER_NAME#" : "">

<cfoutput>
<!-- sidebox -->
<div class="sidebox addListingForm">
	<div class="frame">
		<p id="alreadyAnAdvertiser">Already an Advertiser? <a href="https://www.practicedock.com/index.cfm/PageID/7151" target="PracticeDock">Click here</a></p>
		<!--- <cfif arguments.alternateTitle> --->
			<h4 class="large-title">Or Start Your <strong>Doctor Listing Now</strong></h4>
			<cfif errorList neq "">
				<p class="invalid-input">There are errors in your form input. Please resolve the issues in each highlighted field and submit the form again.</p>
			</cfif>
		<!--- <cfelse>
			<h4>Add a <strong>Doctor Profile</strong></h4>
			<p>Start your free doctor profile listing on LocateADoc.com here:</p>
		</cfif> --->

		<div class="addadoc-box">
			<form id="addListing" name="addListing" action="#formURL#/doctor-marketing/add-listing" method="post">
				<div <cfif ListFind(errorList,"doctorfirstname")>class="invalid-input" </cfif>>
					<h5 class="addListing-label">*First Name</h5>
					<div class="styled-input">
						<span><input placeholder="First Name" type="text" class="noPreText" name="doctorfirstname" value="#params.doctorfirstname#" maxlength="25" required="true" /></span>
					</div>
				</div>
				<div <cfif ListFind(errorList,"doctorlastname")>class="invalid-input" </cfif>>
					<h5 class="addListing-label">*Last Name</h5>
					<div class="styled-input">
						<span><input placeholder="Last Name" type="text" class="noPreText" name="doctorlastname" value="#params.doctorlastname#" maxlength="25" required="true" /></span>
					</div>
				</div>
				<div <cfif ListFind(errorList,"practicename")>class="invalid-input" </cfif>>
					<h5 class="addListing-label">*Practice Name</h5>
					<div class="styled-input">
						<span><input placeholder="Practice Name" type="text" class="noPreText" name="practicename" value="#params.practicename#" maxlength="50" required="true" /></span>
					</div>
				</div>
				<div <cfif ListFind(errorList,"specialtyID")>class="invalid-input" </cfif>>
					<cfif not isMobile>
						<h5 class="addListing-label">*Specialty
							<div class="tooltip" title=" | <div style='width:200px;'>To select a specialty, start typing into the field. A list of matching specialty names will appear. Select the specialty you want from this list.<br><br>If you are uncertain of the name of your desired specialty, you can select from a comprehensive specialty list by clicking this icon.</div>">
								<img src="/images/layout/ico-about.gif" onclick="ALListOpen('ALspecialty',false);">
							</div>
						</h5>
					</cfif>
					<div class="styled-input">
						<cfif isMobile>
							  <select name="specialtyId" required="true">
									<option value="">Select A Specialty</option>
								  <cfloop query="specialties">
									  <option value="#specialties.id#">#specialties.name#</option>
								  </cfloop>
							  </select>
						<cfelse>

							<span><input  onclick="ALListOpen('ALspecialty',false);" id="ALspecialty" placeholder="Specialty" type="text" class="specialty-input noPreText" name="specialty" value="#SP_titles.specialty#" required="true" /></span>
							<input type="hidden" id="specialtyID" name="specialtyID" value="">
						</cfif>
					</div>

				</div>
				<div <cfif ListFind(errorList,"doctorphone")>class="invalid-input" </cfif>>
					<h5 class="addListing-label">*Phone Number</h5>
					<div class="styled-input">
						<span><input placeholder="Phone Number" type="tel" class="noPreText" name="doctorphone" value="#params.doctorphone#" maxlength="20" required="true" /></span>
					</div>
				</div>
				<div <cfif ListFind(errorList,"doctoremail")>class="invalid-input" </cfif>>
					<h5 class="addListing-label">*Email</h5>
					<div class="styled-input">
						<span><input placeholder="Email" type="email" class="noPreText" name="doctoremail" id="doctorEmail" value="#params.doctoremail#" maxlength="50" required="true" /></span>
					</div>
				</div>
				<div <cfif ListFind(errorList,"zip")>class="invalid-input" </cfif>>
					<h5 class="addListing-label">*Zip</h5>
					<div class="styled-input">
						<span><input placeholder="PostalCode" type="text" class="noPreText" name="zip" value="#params.zip#" maxlength="10" required="true" pattern="[0-9a-zA-Z]{5,7}" /></span>
					</div>
				</div>
				<div <cfif ListFind(errorList,"state")>class="invalid-input" </cfif>>
					<h5 class="addListing-label">*State</h5>
					<div class="styled-select">
						<select name="state" class="short-box hidefirst" required="true">
							<option value="">Select State...</option>
							<cfset currentCountry = "">
							<cfloop query="formcontent.states">
								<cfif formcontent.states.country neq currentCountry>
								<cfif currentrow gt 1><option value="">&nbsp;</option></cfif>
								<cfset currentCountry = formcontent.states.country>
								<option value="">--#formcontent.states.country#--</option>
								</cfif>
								<option name="state_#formcontent.states.id#" value="#formcontent.states.id#" country="#formcontent.states.country#" <cfif params.state eq formcontent.states.id>selected </cfif>>#formcontent.states.name#</option>
							</cfloop>
						</select>
					</div>
					<!--- <div class="stretch-input"><span><input type="text" class="noPreText" name="state" value="#params.state#" /></span></div> --->
				</div>
				<div <cfif ListFind(errorList,"country")>class="invalid-input" </cfif>>
					<h5 class="addListing-label">*Country</h5>
					<div class="styled-select">
						<select name="country" class="hidefirst addlisting-country" required="true">
							<option value="">Select Country...</option>
							<cfloop query="formcontent.countries">
								<option value="#formcontent.countries.id#"<cfif formcontent.countries.id eq params.country> selected</cfif>>#formcontent.countries.name#</option>
							</cfloop>
						</select>
					</div>
				</div>
				<!--- <div <cfif ListFind(errorList,"license")>class="invalid-input" </cfif>>
					<h5 class="addListing-label">*Medical License ##</h5>
					<div class="styled-input">
						<span><input placeholder="Medical License ##" type="text" class="noPreText" name="license" value="#params.license#" maxlength="10" required="true" /></span>
					</div>
				</div> --->
				<div style="clear: both;" <cfif ListFind(errorList,"physician")>class="invalid-input"</cfif>>
					<input name="physician" id="physician" type="checkbox" value="1" required="true"> <label for="physician" style="margin-left: 14px;">* I am a physician or legally represent the physician's office</label>
				</div>

				<div style="clear:both;"></div>
				<input type="hidden" id="form-page" name="page" value="2">
				<input type="hidden" name="campaignID" value="#params.campaignID#">
				<div class="btn">
					<input type="button" class="btn-search" value="SUBMIT"  onclick="event.preventDefault(); return SubmitInformation();" />
				</div>
			</form>
		</div>
	</div>
</div>

<div class="ALList-box hidefirst">
	<center>
		<table class="modal-box">
			<tr class="row-buttons">
				<td colspan="2"><div class="closebutton" onclick="ALListClose(); return false;"></div></td>
			</tr>
			<tr class="row-t">
				<td class="l-t"></td>
				<td class="t"></td>
			</tr>
			<tr class="row-c">
				<td class="l"></td>
				<td class="c">
					<div id="AL-association-list"></div>
				</td>
			</tr>
			<tr class="row-b">
				<td class="l-b"></td>
				<td class="b"></td>
			</tr>
		</table>
	</center>
</div>

<!--- <div class="duplicateAccountCheck hidefirst">
	<center>
		<table class="modal-box">
			<tr class="row-buttons">
				<td colspan="2"><div class="closebutton" onclick="ALListClose(); return false;"></div></td>
			</tr>
			<tr class="row-t">
				<td class="l-t"></td>
				<td class="t"></td>
			</tr>
			<tr class="row-c">
				<td class="l"></td>
				<td class="c">
					<div id="AL-association-list"></div>
				</td>
			</tr>
			<tr class="row-b">
				<td class="l-b"></td>
				<td class="b"></td>
			</tr>
		</table>
	</center>
</div> --->
</cfoutput>