<cfset javaScriptIncludeTag(source="doctorsonly/addlistingform", head=true)>
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
			<h2>Please Review:</h2>
			<table>
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
						<td>Contact's first name</td>
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
					<tr>
						<th>Procedures You Offer</th>
						<td><a href="javascript:EditContactInformation();">Edit This</a></td>
						<th>Specialties You Offer</th>
						<td><a href="javascript:EditContactInformation();">Edit This</a></td>
					</tr>
				</thead>
				<tbody>
					<tr>
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

			<h2>LocateADoc.com is powered by PracticeDock Online Marketing Suite</h2>
			<p>PracticeDock offers an array of online marketing and merchant solutions for doctors.
				If you would like to know more about one or more of these products, please check the boxes below:</p>
			<table class="check-table">
				<tr>
					<td><input name="websitecontrol" type="checkbox" value="1" /></td>
					<td>
						<h2>Website Control:</h2>
						<p>Web design, hosting, Search Engine Optimization (SEO) tuner and you control all your
							changes on the backend. Or take your current site and migrate it into a management
							system you can control.</p>
					</td>
				</tr>
				<tr>
					<td><input name="seomarketing" type="checkbox" value="1" /></td>
					<td>
						<h2>SEO Marketing:</h2>
						<p>Be found where your customers are searching online. Let PracticeDock SEO Marketing
							services help rank your website at the top of local search engine results.</p>
					</td>
				</tr>
				<tr>
					<td><input name="calltracking" type="checkbox" value="1" /></td>
					<td>
						<h2>Call Tracking:</h2>
						<p>Track and record all your phone calls. Use multiple numbers to test which ad
							campaigns work and those that don't. Use to train your staff on proper phone
							etiquette and sales.</p>
					</td>
				</tr>
				<tr>
					<td><input name="merchantservices" type="checkbox" value="1" /></td>
					<td>
						<h2>Merchant Services:</h2>
						<p>Save money on your credit card processing services. Click the box for a free
							merchant services analysis.</p>
					</td>
				</tr>
				<tr>
					<td><input name="videoservices" type="checkbox" value="1" /></td>
					<td>
						<h2>Video Services:</h2>
						<p>Affordable video production to use on your website, in your office, LocateADoc.com
						   listing and post in social media like YouTube.</p>
					</td>
				</tr>
				<tr>
					<td><input name="patienteducation" type="checkbox" value="1" /></td>
					<td>
						<h2>Patient Education:</h2>
						<p>3D animations used to educate patients on various procedures. Use on your website,
						   in your office and in social media.</p>
					</td>
				</tr>
				<tr>
					<td><input name="keywordmarketing" type="checkbox" value="1" /></td>
					<td>
						<h2>Keyword Marketing:</h2>
						<p>We will select and manage all your pay per click (PPC) campaigns to help drive
						   more patient leads from paid search.</p>
					</td>
				</tr>
			</table>
			<div class="btn-center">
				<input type="image" src="http://#Globals.domain#/images/doctors_only/click2submit.png" onclick="SubmitInformation();" />
			</div>
			<p><strong>Questions? Give us a call 1-888-834-8593 or email info@locateadoc.com</strong></p>
		</form>
	</div>
</cfoutput>