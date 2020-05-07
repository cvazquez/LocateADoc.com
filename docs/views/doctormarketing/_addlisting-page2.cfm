<cfset javaScriptIncludeTag(source="doctormarketing/addlistingform", head=true)>
<cffunction name="AddFieldTooltip">
	<cfargument name="fieldID" required="true">
	<cfargument name="isProcedure" required="true">
	<cfoutput>
		<div class="procedure-instructions" class="tooltip" title=" | <div style='width:200px;'>
		<cfif isProcedure>
			To select a procedure/treatment, start typing into the field. A list of matching procedure/treatment names will appear. Select the procedure/treatment you want from this list.<br><br>If you are uncertain of the name of your desired procedure/treatment, you can select from a comprehensive procedure/treatment list by clicking this icon.
		<cfelse>
			To select a specialty, start typing into the field. A list of matching specialty names will appear. Select the specialty you want from this list.<br><br>If you are uncertain of the name of your desired specialty, you can select from a comprehensive specialty list by clicking this icon.
		</cfif>
		</div>">
			<img src="/images/layout/ico-about.gif" onclick="ALListOpen('#fieldID#',#isProcedure#);">
		</div>
	</cfoutput>
</cffunction>
<cffunction name="iAddFieldTooltip">
	<cfargument name="fieldID" required="true">
	<cfargument name="isProcedure" required="true">
	<cfoutput>
		<div class="procedure-instructions" class="tooltip" title=" | <div style='width:200px;'>
		<cfif isProcedure>
			To select a procedure/treatment, start typing into the field. A list of matching procedure/treatment names will appear. Select the procedure/treatment you want from this list.<br><br>If you are uncertain of the name of your desired procedure/treatment, you can select from a comprehensive procedure/treatment list by clicking this icon.
		<cfelse>
			To select a specialty, start typing into the field. A list of matching specialty names will appear. Select the specialty you want from this list.<br><br>If you are uncertain of the name of your desired specialty, you can select from a comprehensive specialty list by clicking this icon.
		</cfif>
		</div>">
			<img src="/images/layout/ico-about.gif" onclick="iALListOpen('#fieldID#',#isProcedure#);">
		</div>
	</cfoutput>
</cffunction>
<cfoutput>
	<div class="full-content add-listing-form">
		<form id="addListing" method="post">
			<cfif errorList neq "">
				<p class="invalid-input">There are errors in your form input. Please resolve the issues in each highlighted field and submit the form again.</p>
			</cfif>
			<h2>Doctor's Contact Information</h2>
			<p class="description">This information should be for the doctor of the practice. This is the information LocateADoc.com
				uses to list the doctor. This information can be updated at any time by signing into the
				PracticeDock patient management system.</p>
			<table>
				<tbody>
					<tr <cfif ListFind(errorList,"doctorfirstname")>class="invalid-input" </cfif>>
						<td>*First Name:</td>
						<td><div class="styled-input">
								<span><input type="text" class="noPreText" name="doctorfirstname" value="#params.doctorfirstname#" maxlength="25" /></span>
							</div>
						</td>
					</tr>
					<tr <cfif ListFind(errorList,"doctorlastname")>class="invalid-input" </cfif>>
						<td>*Last Name:</td>
						<td><div class="styled-input">
								<span><input type="text" class="noPreText" name="doctorlastname" value="#params.doctorlastname#" maxlength="25" /></span>
							</div>
						</td>
					</tr>
					<tr <cfif ListFind(errorList,"doctortitle")>class="invalid-input" </cfif>>
						<td>Designation (MD, DDO, etc.):</td>
						<td><div class="styled-input"><span><input type="text" class="noPreText" name="doctortitle" value="#params.doctortitle#" maxlength="25" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"doctoremail")>class="invalid-input" </cfif>>
						<td>*Email Address</td>
						<td><div class="styled-input"><span><input type="text" class="noPreText" name="doctoremail" value="#params.doctoremail#" maxlength="50" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"website")>class="invalid-input" </cfif>>
						<td>Website:</td>
						<td><div class="styled-input"><span><input type="text" class="noPreText" name="website" value="#params.website#" maxlength="75" /></span></div></td>
					</tr>
				</tbody>
			</table>
			<h2>Office Contact Information</h2>
			<p class="description">This information should be for the office of the practice. This is the person
				LocateADoc.com will contact with leads and other information.</p>
			<table>
				<tbody>
					<tr <cfif ListFind(errorList,"contactfirstname")>class="invalid-input" </cfif>>
						<td>*Contact's First Name:</td>
						<td><div class="styled-input"><span><input type="text" class="noPreText" name="contactfirstname" value="#params.contactfirstname#" maxlength="25" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"contactlastname")>class="invalid-input" </cfif>>
						<td>*Last Name:</td>
						<td><div class="styled-input"><span><input type="text" class="noPreText" name="contactlastname" value="#params.contactlastname#" maxlength="25" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"contactemail")>class="invalid-input" </cfif>>
						<td>*Email Address</td>
						<td><div class="styled-input"><span><input type="text" class="noPreText" name="contactemail" value="#params.contactemail#" maxlength="50" /></span></div></td>
					</tr>
				</tbody>
			</table>
			<p class="description">This information should be the mailing address for the office. This is the information
				LocateADoc.com uses to list the practice and what patients can search by.</p>
			<table>
				<tbody>
					<tr <cfif ListFind(errorList,"practicename")>class="invalid-input" </cfif>>
						<td>*Practice Name:</td>
						<td><div class="styled-input"><span><input type="text" class="noPreText" name="practicename" value="#params.practicename#" maxlength="50" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"address")>class="invalid-input" </cfif>>
						<td>*Street Address:</td>
						<td><div class="styled-input"><span><input type="text" class="noPreText" name="address" value="#params.address#" maxlength="50" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"city")>class="invalid-input" </cfif>>
						<td>*City:</td>
						<td><div class="styled-input"><span><input type="text" class="noPreText" name="city" value="#params.city#" maxlength="30" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"state")>class="invalid-input" </cfif>>
						<td>*State:</td>
						<td>
							<div class="styled-select">
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
							</div>
						</td>
					</tr>
					<tr <cfif ListFind(errorList,"zip")>class="invalid-input" </cfif>>
						<td>*Zip Code:</td>
						<td><div class="styled-input"><span><input type="text" class="noPreText" name="zip" value="#params.zip#" maxlength="10" /></span></div></td>
					</tr>
					<tr <cfif ListFind(errorList,"country")>class="invalid-input" </cfif>>
						<td>*Country</td>
						<td>
							<div class="styled-select">
								<select name="country" class="hidefirst">
									<option value="">Select Country...</option>
									<cfloop query="countries">
										<option value="#countries.id#"<cfif countries.id eq params.country> selected</cfif>>#countries.name#</option>
									</cfloop>
								</select>
							</div>
						</td>
					</tr>
					<tr <cfif ListFind(errorList,"doctorphone")>class="invalid-input" </cfif>>
						<td>*Phone:</td>
						<td><div class="styled-input"><span><input type="text" class="noPreText" name="doctorphone" value="#params.doctorphone#" maxlength="20" /></span></div></td>
					</tr>
				</tbody>
			</table>



		<cfif NOT isMobile>
			<cfif NOT client.introductoryListing>
				<h2>Select Your Top <cfif NOT client.introductoryListing>4 Procedures / Treatments<cfelse>Procedure / Treatment</cfif></h2>
				<p class="description">Select the <cfif NOT client.introductoryListing>procedures and treatments</cfif> procedure and treatment that you would like your listing to appear
				under, so patients can find you in our doctor's directory with ease. This information
				will also appear on your profile page.</p>

				<table id="specialtyProcedures">
					<tbody>

							<tr>
								<td <cfif ListFind(errorList,"specialtyID")>class="invalid-input" </cfif>>*Primary Specialty:#AddFieldTooltip("specialty-1",false)#</td>
								<td <cfif ListFind(errorList,"specialtyID")>class="invalid-input" </cfif>>
									<div class="styled-input">
										<span>
											<input type="text" class="specialty-input noPreText" name="specialty" id="specialty-1" value="#REReplace(SP_titles.specialty,'[ ][ ]+',' ','all')#" />
										</span>
									</div>
								</td>
									<td <cfif ListFind(errorList,"procedureID")>class="invalid-input" </cfif>>*Primary Procedure/Treatment:#AddFieldTooltip("procedure-1",true)#</td>
									<td <cfif ListFind(errorList,"procedureID")>class="invalid-input" </cfif>><div class="styled-input"><span><input type="text" class="procedure-input noPreText" name="procedure" id="procedure-1" value="#REReplace(SP_titles.procedure,'[ ][ ]+',' ','all')#" /></span></div></td>
							</tr>
							<tr>
								<td>Second Specialty:#AddFieldTooltip("specialty-2",false)#</td>
								<td><div class="styled-input">
									<span>
										<input type="text" class="specialty-input noPreText" name="specialty2" id="specialty-2" value="#REReplace(SP_titles.specialty2,'[ ][ ]+',' ','all')#" />
									</span>
								</div>
								</td>
								<td>Second Procedure/Treatment:#AddFieldTooltip("procedure-2",true)#</td>
								<td><div class="styled-input">
									<span>
										<input type="text" class="procedure-input noPreText" name="procedure2" id="procedure-2" value="#REReplace(SP_titles.procedure2,'[ ][ ]+',' ','all')#" />
									</span>
								</div>
								</td>
							</tr>
							<tr>
								<td>Third Specialty:#AddFieldTooltip("specialty-3",false)#</td>
								<td><div class="styled-input">
										<span>
											<input type="text" class="specialty-input noPreText" name="specialty3" id="specialty-3" value="#REReplace(SP_titles.specialty3,'[ ][ ]+',' ','all')#" />
										</span>
									</div>
								</td>
								<td>Third Procedure/Treatment:#AddFieldTooltip("procedure-3",true)#</td>
								<td><div class="styled-input">
										<span>
											<input type="text" class="procedure-input noPreText" name="procedure3" id="procedure-3" value="#REReplace(SP_titles.procedure3,'[ ][ ]+',' ','all')#" />
										</span>
									</div>
								</td>
							</tr>
							<tr>
								<td>Fourth Specialty:#AddFieldTooltip("specialty-4",false)#</td>
								<td><div class="styled-input">
										<span>
											<input type="text" class="specialty-input noPreText" name="specialty4" id="specialty-4" value="#REReplace(SP_titles.specialty4,'[ ][ ]+',' ','all')#" />
										</span>
									</div>
								</td>
								<td>Fourth Procedure/Treatment:#AddFieldTooltip("procedure-4",true)#</td>
								<td><div class="styled-input">
										<span>
											<input type="text" class="procedure-input noPreText" name="procedure4" id="procedure-4" value="#REReplace(SP_titles.procedure4,'[ ][ ]+',' ','all')#" />
										</span>
									</div>
								</td>
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
			<cfelse>
				<!--- Introductory --->

				<h2>Select Your Top 4 Procedures / Treatments</h2>
				<p class="description">Select the procedure and treatment that you would like your listing to appear
					under, so patients can find you in our doctor's directory with ease. This information
					will also appear on your profile page.</p>

					<h3>Specialty Chosen: <span style="font-weight: normal;">#SP_titles.specialty#</span></h3>
					<input type="hidden" class="specialty-input noPreText" name="specialty" id="ispecialty" value="#REReplace(SP_titles.specialty,'[ ][ ]+',' ','all')#" />

				<table>
				<tbody>
					<tr>
						<td <cfif ListFind(errorList,"procedureID")>class="invalid-input" </cfif> style="width: 200px;">First Procedure/Treatment:#iAddFieldTooltip("procedure-1",true)#</td>
						<td>
							<div class="styled-input">
							<span>
								 <input type="text" class="iprocedure-input noPreText" name="procedure" id="procedure-1" value="#REReplace(SP_titles.procedure,'[ ][ ]+',' ','all')#"/>
							</span>
							</div>
						</td>
					</tr>
					<tr>
						<td style="width: 200px;">Second Procedure/Treatment::#iAddFieldTooltip("procedure-2",true)#</td>
						<td><div class="styled-input">
							<span>
								<input type="text" class="iprocedure-input noPreText" name="procedure2" id="procedure-2" value="#REReplace(SP_titles.procedure2,'[ ][ ]+',' ','all')#" />
							</span>
						</div>
						</td>
					</tr>
					<tr>
						<td style="width: 200px;">Third Procedure/Treatment::#iAddFieldTooltip("procedure-3",true)#</td>
						<td><div class="styled-input">
							<span>
								<input type="text" class="iprocedure-input noPreText" name="procedure3" id="procedure-3" value="#REReplace(SP_titles.procedure3,'[ ][ ]+',' ','all')#"/>
							</span>
							</div>
						</td>
					</tr>
					<tr>
						<td style="width: 200px;">Fourth Procedure/Treatment:#iAddFieldTooltip("procedure-4",true)#</td>
						<td><div class="styled-input">
							<span>
								<input type="text" class="iprocedure-input noPreText" name="procedure4" id="procedure-4" value="#REReplace(SP_titles.procedure4,'[ ][ ]+',' ','all')#"/>
							</span>
							</div>
						</td>
					</tr>
				</tbody>
				</table>
				<input type="hidden" id="specialtyID" name="specialtyID" value="">
				<input type="hidden" id="procedureID" name="procedureID" value="">
				<input type="hidden" id="procedure2ID" name="procedure2ID" value="">
				<input type="hidden" id="procedure3ID" name="procedure3ID" value="">
				<input type="hidden" id="procedure4ID" name="procedure4ID" value="">
			</cfif><!--- Introductory --->


		<cfelse>
			<div <cfif ListFind(errorList,"specialtyID")>class="invalid-input" </cfif>>* Primary Specialty<br /></div>
			<div class="styled-input">
				<span>
				<select name="specialtyId">
					<option value="">Select A Specialty</option>
					<cfloop query="specialties">
						<option value="#specialties.id#"<cfif specialties.id EQ params.specialtyID> selected</cfif>>#specialties.name#</option>
					</cfloop>
				</select>
				</span>
			</div>

			<div <cfif ListFind(errorList,"procedureID")>class="invalid-input" </cfif>>* Primary Procedure/Treatment<br /></div>
			<div class="styled-input">
				<span>
				<select name="procedureID">
					<option value="">Select A Procedure/Treatment</option>
					<cfloop query="procedures">
						<option value="#procedures.id#"<cfif procedures.id EQ params.procedureID> selected</cfif>>#procedures.name#</option>
					</cfloop>
				</select>
				</span>
			</div>
		</cfif>

			<h2>Select a Password</h2>
			<p class="description">The password you enter below will allow the doctor and office contact to sign into the
				PracticeDock patient management referral page to edit account information.</p>

				<p class="description" style="font-weight: bold;">To ensure proper security of your account, passwords have the following requirements:</p>
				<ul>
					<li>8 or more characters long</li>
					<li>At least 1 number</li>
					<li>At least 1 letter</li>
					<li>At least 1 punctuation mark</li>
					<li>Case matters</li>
				</ul>
				<p class="description">For best results, think of a meaningless sentence that means something to only you, and use the first letter of each word.</p>

				<p class="description">For example:<br />
					 "I walk my dog Spot, at 6am and 5pm everyday."<br />
					 becomes<br />
					 !wmdS,a6aa5pe.</p>

			<table <cfif ListFind(errorList,"password")>class="invalid-input" </cfif>>
				<tbody>
					<tr>
						<td>*Password:</td>
						<td><div class="styled-input">
							<span><input type="password" class="noPreText" id="passwordA" name="passwordA" value="" maxlength="25" /></span>
							</div>
						</td>
					</tr>
					<tr>
						<td>*Password Again:</td>
						<td><div class="styled-input"><span><input type="password" class="noPreText" id="passwordB" name="passwordB" value="" maxlength="25" /></span></div></td>
					</tr>
				</tbody>
			</table>
			<input type="hidden" id="form-page" name="page" value="3">
			<input type="hidden" name="campaignID" value="#params.campaignID#">
			<input type="hidden" name="physician" value="#params.physician#">

			<cfif client.introductoryListing>
				<input type="hidden" name="introductoryAccept" value="1">
			</cfif>

			<div class="btn-center">
				<input type="image" src="/images/doctors_only/click2submit.png" onclick="SubmitInformation2();" id="submitInformation" />
			</div>
			<br>
			<p><strong>Questions? Give us a call <a href="tel:888-834-8593">1-888-834-8593</a> or email <a href="mailto:info@LocateADoc.com">info@LocateADoc.com</a></strong></p>
		</form>
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
</cfoutput>