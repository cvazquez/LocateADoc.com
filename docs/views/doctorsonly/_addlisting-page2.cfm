<cfset javaScriptIncludeTag(source="doctorsonly/addlistingform", head=true)>
<cfoutput>
	<div class="full-content add-listing-form">
		<form id="addListing" method="post">
			<cfif errorList neq "">
				<p class="invalid-input">There are errors in your form input. Please resolve the issues in each highlighted field and submit the form again.</p>
			</cfif>
			<h2>Doctor's Contact Information</h2>
			<p>This information should be for the doctor of the practice. This is the information LocateADoc.com
				uses to list the doctor. This information can be updated at any time by signing into the
				PracticeDock patient management system.</p>
			<table>
				<tbody>
					<tr <cfif ListFind(errorList,"doctorfirstname")>class="invalid-input" </cfif>>
						<td>*First Name:</td>
						<td><div class="stretch-input"><span><input type="text" class="noPreText" name="doctorfirstname" value="#params.doctorfirstname#" maxlength="25" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"doctorlastname")>class="invalid-input" </cfif>>
						<td>*Last Name:</td>
						<td><div class="stretch-input"><span><input type="text" class="noPreText" name="doctorlastname" value="#params.doctorlastname#" maxlength="25" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"doctortitle")>class="invalid-input" </cfif>>
						<td>Designation (MD, DDO, etc.):</td>
						<td><div class="stretch-input"><span><input type="text" class="noPreText" name="doctortitle" value="#params.doctortitle#" maxlength="25" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"doctoremail")>class="invalid-input" </cfif>>
						<td>*Email Address</td>
						<td><div class="stretch-input"><span><input type="text" class="noPreText" name="doctoremail" value="#params.doctoremail#" maxlength="50" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"website")>class="invalid-input" </cfif>>
						<td>Website:</td>
						<td><div class="stretch-input"><span><input type="text" class="noPreText" name="website" value="#params.website#" maxlength="75" /></span></div></td>
					</tr>
				</tbody>
			</table>
			<h2>Office Contact Information</h2>
			<p>This information should be for the office of the practice. This is the person
				LocateADoc.com will contact with leads and other information.</p>
			<table>
				<tbody>
					<tr <cfif ListFind(errorList,"contactfirstname")>class="invalid-input" </cfif>>
						<td>*Contact's First Name:</td>
						<td><div class="stretch-input"><span><input type="text" class="noPreText" name="contactfirstname" value="#params.contactfirstname#" maxlength="25" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"contactlastname")>class="invalid-input" </cfif>>
						<td>*Last Name:</td>
						<td><div class="stretch-input"><span><input type="text" class="noPreText" name="contactlastname" value="#params.contactlastname#" maxlength="25" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"contactemail")>class="invalid-input" </cfif>>
						<td>*Email Address</td>
						<td><div class="stretch-input"><span><input type="text" class="noPreText" name="contactemail" value="#params.contactemail#" maxlength="50" /></span></div></td>
					</tr>
				</tbody>
			</table>
			<p>This information should be the mailing address for the office. This is the information
				LocateADoc.com uses to list the practice and what patients can search by.</p>
			<table>
				<tbody>
					<tr <cfif ListFind(errorList,"practicename")>class="invalid-input" </cfif>>
						<td>*Practice Name:</td>
						<td><div class="stretch-input"><span><input type="text" class="noPreText" name="practicename" value="#params.practicename#" maxlength="50" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"address")>class="invalid-input" </cfif>>
						<td>*Street Address:</td>
						<td><div class="stretch-input"><span><input type="text" class="noPreText" name="address" value="#params.address#" maxlength="50" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"city")>class="invalid-input" </cfif>>
						<td>*City:</td>
						<td><div class="stretch-input"><span><input type="text" class="noPreText" name="city" value="#params.city#" maxlength="30" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"state")>class="invalid-input" </cfif>>
						<td>*State:</td>
						<td>
							<div style="width: 195px;" class="selectArea temporary"><span class="left"></span><span class="center">Select State...</span><a href="##" class="selectButton"></a></div>
							<select name="state" class="short-box hidefirst">
								<option value="">Select State...</option>
								<cfset currentCountry = "">
								<cfloop query="states">
									<cfif states.country neq currentCountry>
									<cfif currentrow gt 1><option value="">&nbsp;</option></cfif>
									<cfset currentCountry = states.country>
									<option value="">--#states.country#--</option>
									</cfif>
									<option name="state_#states.id#" value="#states.id#" country="#states.country#" <cfif params.state eq states.id>selected </cfif>>#states.name#</option>
								</cfloop>
							</select>
							<!--- <div class="stretch-input state-field"><span><input type="text" class="noPreText" name="state" value="#params.state#" maxlength="4" /></span></div> --->
						</td>
					</tr>
					<tr <cfif ListFind(errorList,"zip")>class="invalid-input" </cfif>>
						<td>*Zip Code:</td>
						<td><div class="stretch-input"><span><input type="text" class="noPreText" name="zip" value="#params.zip#" maxlength="10" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"country")>class="invalid-input" </cfif>>
						<td>*Country</td>
						<td>
							<div style="width: 195px;" class="selectArea temporary"><span class="left"></span><span class="center">Select Country...</span><a href="##" class="selectButton"></a></div>
							<select name="country" class="hidefirst">
								<option value="">Select Country...</option>
								<cfloop query="countries">
									<option value="#countries.id#"<cfif countries.id eq params.country> selected</cfif>>#countries.name#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr <cfif ListFind(errorList,"doctorphone")>class="invalid-input" </cfif>>
						<td>*Phone:</td>
						<td><div class="stretch-input"><span><input type="text" class="noPreText" name="doctorphone" value="#params.doctorphone#" maxlength="20" /></span></div></td>
					</tr>
				</tbody>
			</table>
			<h2>Select Your Top 4 Specialties & Procedures</h2>
			<p>Select the specialties and procedures that you would like your listing to appear
				under so patients can find you in our doctor's directory with ease. This information
				will also appear on your profile page.</p>
			<table>
				<tbody>
					<tr>
						<td <cfif ListFind(errorList,"specialtyID")>class="invalid-input" </cfif>>*Primary Specialty:</td>
						<td <cfif ListFind(errorList,"specialtyID")>class="invalid-input" </cfif>><div class="stretch-input"><span><input type="text" class="specialty-input noPreText" name="specialty" value="#REReplace(SP_titles.specialty,'[ ][ ]+',' ','all')#" /></span></div></td>
						<td <cfif ListFind(errorList,"procedureID")>class="invalid-input" </cfif>>*Primary Procedure:</td>
						<td <cfif ListFind(errorList,"procedureID")>class="invalid-input" </cfif>><div class="stretch-input"><span><input type="text" class="procedure-input noPreText" name="procedure" value="#REReplace(SP_titles.procedure,'[ ][ ]+',' ','all')#" /></span></div></td>
					</tr>
					<tr>
						<td>Second Specialty:</td>
						<td><div class="stretch-input"><span><input type="text" class="specialty-input noPreText" name="specialty2" value="#REReplace(SP_titles.specialty2,'[ ][ ]+',' ','all')#" /></span></div></td>
						<td>Second Procedure:</td>
						<td><div class="stretch-input"><span><input type="text" class="procedure-input noPreText" name="procedure2" value="#REReplace(SP_titles.procedure2,'[ ][ ]+',' ','all')#" /></span></div></td>
					</tr>
					<tr>
						<td>Third Specialty:</td>
						<td><div class="stretch-input"><span><input type="text" class="specialty-input noPreText" name="specialty3" value="#REReplace(SP_titles.specialty3,'[ ][ ]+',' ','all')#" /></span></div></td>
						<td>Third Procedure:</td>
						<td><div class="stretch-input"><span><input type="text" class="procedure-input noPreText" name="procedure3" value="#REReplace(SP_titles.procedure3,'[ ][ ]+',' ','all')#" /></span></div></td>
					</tr>
					<tr>
						<td>Fourth Specialty:</td>
						<td><div class="stretch-input"><span><input type="text" class="specialty-input noPreText" name="specialty4" value="#REReplace(SP_titles.specialty4,'[ ][ ]+',' ','all')#" /></span></div></td>
						<td>Fourth Procedure:</td>
						<td><div class="stretch-input"><span><input type="text" class="procedure-input noPreText" name="procedure4" value="#REReplace(SP_titles.procedure4,'[ ][ ]+',' ','all')#" /></span></div></td>
					</tr>
				</tbody>
			</table>
			<input type="hidden" id="specialtyID" name="specialtyID" value="">
			<input type="hidden" id="specialty2ID" name="specialty2ID" value="">
			<input type="hidden" id="specialty3ID" name="specialty3ID" value="">
			<input type="hidden" id="specialty4ID" name="specialty4ID" value="">
			<input type="hidden" id="procedureID" name="procedureID" value="">
			<input type="hidden" id="procedure2ID" name="procedure2ID" value="">
			<input type="hidden" id="procedure3ID" name="procedure3ID" value="">
			<input type="hidden" id="procedure4ID" name="procedure4ID" value="">
			<h2>Select a Password</h2>
			<p>The password you enter below will allow the doctor and office contact to sign into the
				PracticeDock patient management referral page to edit account information.</p>
			<table <cfif ListFind(errorList,"password")>class="invalid-input" </cfif>>
				<tbody>
					<tr>
						<td>*Password:</td>
						<td><div class="stretch-input"><span><input type="password" class="noPreText" name="passwordA" value="" maxlength="25" /></span></div></td>
					</tr>
					<tr>
						<td>*Password Again:</td>
						<td><div class="stretch-input"><span><input type="password" class="noPreText" name="passwordB" value="" maxlength="25" /></span></div></td>
					</tr>
				</tbody>
			</table>
			<input type="hidden" id="form-page" name="page" value="3">
			<div class="btn-center">
				<input type="image" src="http://#Globals.domain#/images/doctors_only/click2submit.png" onclick="SubmitInformation();" />
			</div>
			<br>
			<p><strong>Questions? Give us a call 1-888-834-8593 or email info@locateadoc.com</strong></p>
		</form>
	</div>
</cfoutput>