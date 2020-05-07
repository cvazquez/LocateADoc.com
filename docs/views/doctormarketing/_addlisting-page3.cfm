<cfset javaScriptIncludeTag(source="doctormarketing/addlistingform", head=true)>
<cfoutput>
	<div class="full-content confirm-listing-form">
		<form id="addListing" method="post">
			<input type="hidden" id="form-page" name="page" value="4">
			<input type="hidden" name="doctorfirstname" value="#params.doctorfirstname#">
			<input type="hidden" name="doctorlastname" value="#params.doctorlastname#">
			<input type="hidden" name="doctortitle" value="#params.doctortitle#">
			<input type="hidden" name="doctoremail" value="#params.doctoremail#">
			<input type="hidden" name="website" value="#params.website#">
			<input type="hidden" name="contactfirstname" value="#params.contactfirstname#">
			<input type="hidden" name="contactlastname" value="#params.contactlastname#">
			<input type="hidden" name="contactemail" value="#params.contactemail#">
			<input type="hidden" name="practicename" value="#params.practicename#">
			<input type="hidden" name="address" value="#params.address#">
			<input type="hidden" name="city" value="#params.city#">
			<input type="hidden" name="state" value="#params.state#">
			<input type="hidden" name="zip" value="#params.zip#">
			<input type="hidden" name="country" value="#params.country#">
			<input type="hidden" name="doctorphone" value="#params.doctorphone#">
			<input type="hidden" name="specialtyID" value="#params.specialtyID#">
			<input type="hidden" name="specialty2ID" value="#params.specialty2ID#">
			<input type="hidden" name="specialty3ID" value="#params.specialty3ID#">
			<input type="hidden" name="specialty4ID" value="#params.specialty4ID#">
			<input type="hidden" name="procedureID" value="#params.procedureID#">
			<input type="hidden" name="procedure2ID" value="#params.procedure2ID#">
			<input type="hidden" name="procedure3ID" value="#params.procedure3ID#">
			<input type="hidden" name="procedure4ID" value="#params.procedure4ID#">
			<input type="hidden" name="password" value="#params.password#">
			<input type="hidden" name="campaignID" value="#params.campaignID#">
			<!--- <input type="hidden" name="license" value="#params.license#"> --->
			<input type="hidden" name="physician" value="#params.physician#">
			<cfif client.introductoryListing>
				<input type="hidden" name="introductoryAccept" value="1">
			</cfif>
			<h2>Please Review:</h2>

			<cfif errorList NEQ "">
				<div class="ErrorBox">
					<p>You are missing required billing information below.</p>
					<ul>
					<cfloop list="#errorList#" index="eL">
						<li>#eL#</li>
					</cfloop>
					</ul>
				</div>
			</cfif>
			<table class="ps-review-table">
				<thead>
					<tr>
						<th>Contact Information</th>
						<td><a href="javascript:EditContactInformation();">Edit This</a></td>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>Doctor's First Name</td>
						<td>#params.doctorfirstname#</td>
					</tr>
					<tr>
						<td>Last Name</td>
						<td>#params.doctorlastname#</td>
					</tr>
					<tr>
						<td>Designation</td>
						<td>#params.doctortitle#</td>
					</tr>
					<tr>
						<td>Email Address</td>
						<td>#params.doctoremail#</td>
					</tr>
					<tr>
						<td>Website</td>
						<td>#params.website#</td>
					</tr>
					<tr>
						<td>Contact's First Name</td>
						<td>#params.contactfirstname#</td>
					</tr>
					<tr>
						<td>Last Name</td>
						<td>#params.contactlastname#</td>
					</tr>
					<tr>
						<td>Email</td>
						<td>#params.contactemail#</td>
					</tr>
					<tr>
						<td>Practice Name</td>
						<td>#params.practicename#</td>
					</tr>
					<tr>
						<td>Street Address</td>
						<td>#params.address#</td>
					</tr>
					<tr>
						<td>Country</td>
						<td>#countryInfo.name#</td>
					</tr>
					<tr>
						<td>City</td>
						<td>#params.city#</td>
					</tr>
					<tr>
						<td>State</td>
						<td>#stateInfo.name#</td>
					</tr>
					<tr>
						<td>Zip</td>
						<td>#params.zip#</td>
					</tr>
					<tr>
						<td>Phone</td>
						<td>#params.doctorphone#</td>
					</tr>
				</tbody>
			</table>

			<table class="ps-offer-table">
				<thead>
					<tr style="vertical-align: top;">
						<th>Procedures/Treatments You Offer</th>
						<td><a href="javascript:EditContactInformation();">Edit This</a></td>
						<th>Specialties You Offer</th>
						<td><a href="javascript:EditContactInformation();">Edit This</a></td>
					</tr>
				</thead>
				<tbody>
					<tr style="vertical-align: top;">
						<td colspan="2">
							<ul>
								<cfif SP_titles.procedure neq ""><li>#SP_titles.procedure#</li></cfif>
								<cfif SP_titles.procedure2 neq ""><li>#SP_titles.procedure2#</li></cfif>
								<cfif SP_titles.procedure3 neq ""><li>#SP_titles.procedure3#</li></cfif>
								<cfif SP_titles.procedure4 neq ""><li>#SP_titles.procedure4#</li></cfif>
							</ul>
						</td>
						<td colspan="2">
							<ul>
								<cfif SP_titles.specialty neq ""><li>#SP_titles.specialty#</li></cfif>
								<cfif SP_titles.specialty2 neq ""><li>#SP_titles.specialty2#</li></cfif>
								<cfif SP_titles.specialty3 neq ""><li>#SP_titles.specialty3#</li></cfif>
								<cfif SP_titles.specialty4 neq ""><li>#SP_titles.specialty4#</li></cfif>
							</ul>
						</td>
					</tr>
				</tbody>
			</table>


	<cfif NOT isPremier>
		#includePartial("billing-information")#
	<cfelse>
		<p style="font-weight: bold;">Thank you for choosing LocateADoc.com to help you connect with more prospective patients and clients. A representative will be contacting your practice to verify your listing information and discuss placement options.</p>
	</cfif>

			<div class="btn-center">
				<input type="image" src="/images/doctors_only/click2submit.png" <!--- onclick="SubmitInformation();"  --->/>
			</div>
			<p><strong>Questions? Give us a call <a href="tel:888-834-8593">1-888-834-8593</a> or email <a href="mailto:info@LocateADoc.com">info@LocateADoc.com</a></strong></p>
		</form>
	</div>
</cfoutput>