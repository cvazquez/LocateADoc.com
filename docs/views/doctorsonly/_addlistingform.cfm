<cfparam name="arguments.alternateTitle" default="false">
<cfparam name="errorList" default="">

<cfset javaScriptIncludeTag(source="doctorsonly/addlistingform", head=true)>

<cfoutput>
<!-- sidebox -->
<div class="sidebox">
	<div class="frame">
		<cfif arguments.alternateTitle>
			<h4 class="large-title">Start Your <strong>FREE Doctor Listing Now</strong></h4>
			<cfif errorList neq "">
				<p class="invalid-input">There are errors in your form input. Please resolve the issues in each highlighted field and submit the form again.</p>
			</cfif>
		<cfelse>
			<h4>Add a <strong>Doctor Profile</strong></h4>
			<p>Start your free doctor profile listing on LocateADoc.com here:</p>
		</cfif>
		<div class="addadoc-box">
			<form id="addListing" name="addListing" action="#URLFor(action='addListing')#" method="post">
				<div <cfif ListFind(errorList,"doctorfirstname")>class="invalid-input" </cfif>>
					<h5>*First Name</h5>
					<div class="stretch-input"><span><input type="text" class="noPreText" name="doctorfirstname" value="#params.doctorfirstname#" maxlength="25" /></span></div>
				</div>
				<div <cfif ListFind(errorList,"doctorlastname")>class="invalid-input" </cfif>>
					<h5>*Last Name</h5>
					<div class="stretch-input"><span><input type="text" class="noPreText" name="doctorlastname" value="#params.doctorlastname#" maxlength="25" /></span></div>
				</div>
				<div <cfif ListFind(errorList,"practicename")>class="invalid-input" </cfif>>
					<h5>*Practice Name</h5>
					<div class="stretch-input"><span><input type="text" class="noPreText" name="practicename" value="#params.practicename#" maxlength="50" /></span></div>
				</div>
				<div <cfif ListFind(errorList,"specialtyID")>class="invalid-input" </cfif>>
					<h5>*Specialty</h5>
					<div class="stretch-input"><span><input type="text" class="specialty-input noPreText" name="specialty" value="#SP_titles.specialty#" /></span></div>
					<input type="hidden" id="specialtyID" name="specialtyID" value="">
				</div>
				<div>
					<h5>Other Specialty</h5>
					<div class="stretch-input"><span><input type="text" class="specialty-input noPreText" name="specialty2" value="#SP_titles.specialty2#" /></span></div>
					<input type="hidden" id="specialty2ID" name="specialty2ID" value="">
				</div>
				<div <cfif ListFind(errorList,"doctorphone")>class="invalid-input" </cfif>>
					<h5>*Phone Number</h5>
					<div class="stretch-input"><span><input type="text" class="noPreText" name="doctorphone" value="#params.doctorphone#" maxlength="20" /></span></div>
				</div>
				<div <cfif ListFind(errorList,"doctoremail")>class="invalid-input" </cfif>>
					<h5>*Email</h5>
					<div class="stretch-input"><span><input type="text" class="noPreText" name="doctoremail" value="#params.doctoremail#" maxlength="50" /></span></div>
				</div>
				<div <cfif ListFind(errorList,"zip")>class="invalid-input" </cfif>>
					<h5>*Zip</h5>
					<div class="stretch-input"><span><input type="text" class="noPreText" name="zip" value="#params.zip#" maxlength="10" /></span></div>
				</div>
				<div <cfif ListFind(errorList,"state")>class="invalid-input" </cfif>>
					<h5>*State</h5>
					<div style="width: 165px;" class="selectArea temporary"><span class="left"></span><span class="center">Select State...</span><a href="##" class="selectButton"></a></div>
					<select name="state" class="short-box hidefirst">
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
					<!--- <div class="stretch-input"><span><input type="text" class="noPreText" name="state" value="#params.state#" /></span></div> --->
				</div>
				<div <cfif ListFind(errorList,"country")>class="invalid-input" </cfif>>
					<h5>*Country</h5>
					<div style="width: 165px;" class="selectArea temporary"><span class="left"></span><span class="center">Select Country...</span><a href="##" class="selectButton"></a></div>
					<select name="country" class="hidefirst">
						<option value="">Select Country...</option>
						<cfloop query="formcontent.countries">
							<option value="#formcontent.countries.id#"<cfif formcontent.countries.id eq params.country> selected</cfif>>#formcontent.countries.name#</option>
						</cfloop>
					</select>
				</div>

				<div style="clear:both;"></div>
				<input type="hidden" id="form-page" name="page" value="2">
				<div class="btn">
					<input type="button" class="btn-search" value="SUBMIT" onclick="SubmitInformation();" />
				</div>
			</form>
		</div>
	</div>
</div>
</cfoutput>