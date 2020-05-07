<cfoutput>
<div id="addlisting-billing-information">
	<h2>Billing Information</h2>
	<h4>Your credit card will be billed at a monthly rate. You can cancel at any time. All information is encrypted for maximum security of your credit card information.</h4>

	<p><b>Step 1 of 2: Billing Information:</b> &dash;&gt; Step 2 of 2: Credit Card</p>

	<div id="addlisting-payment-form">
		<div class="addlisting-payment-form-row<cfif ListFind(errorList,'billingAddressCompany')> invalid-input</cfif>">
			<div class="addlisting-payment-form-cellL">*Billing Company</div>
			<div class="addlisting-payment-form-cellR"><input class="noPreText" type="text" name="billingAddressCompany" value="#params.billingAddressCompany#" required></div>
		</div>

		<div class="addlisting-payment-form-row<cfif ListFind(errorList,'billingAddressfirstName')> invalid-input</cfif>">
			<div class="addlisting-payment-form-cellL">*Billing First name</div>
			<div class="addlisting-payment-form-cellR"><input class="noPreText" type="text" name="billingAddressfirstName" value="#params.billingAddressfirstName#" required></div>
		</div>

		<div class="addlisting-payment-form-row<cfif ListFind(errorList,'billingAddressLastName')> invalid-input</cfif>">
			<div class="addlisting-payment-form-cellL">*Billing Last name</div>
			<div class="addlisting-payment-form-cellR"><input class="noPreText" type="text" name="billingAddressLastName" value="#params.billingAddressLastName#" required></div>
		</div>

		<div class="addlisting-payment-form-row<cfif ListFind(errorList,'billingAddressAddress1')> invalid-input</cfif>">
			<div class="addlisting-payment-form-cellL">*Billing Address</div>
			<div class="addlisting-payment-form-cellR"><input class="noPreText" type="text" name="billingAddressAddress1" value="#params.billingAddressAddress1#" required="true"></div>
		</div>

		<div class="addlisting-payment-form-row">
			<div class="addlisting-payment-form-cellL">Billing Address 2</div>
			<div class="addlisting-payment-form-cellR"><input class="noPreText" type="text" name="billingAddressAddress2" value="#params.billingAddressAddress2#"></div>
		</div>

		<div class="addlisting-payment-form-row<cfif ListFind(errorList,'billingAddressCity')> invalid-input</cfif>">
			<div class="addlisting-payment-form-cellL">*Billing City</div>
			<div class="addlisting-payment-form-cellR"><input class="noPreText" type="text" name="billingAddressCity" value="#params.billingAddressCity#" required="true"></div>
		</div>

		<div class="addlisting-payment-form-row<cfif ListFind(errorList,'billingAddressStateId')> invalid-input</cfif>">
			<div class="addlisting-payment-form-cellL">*Billing State/Province</div>
			<div class="addlisting-payment-form-cellR styled-select">
				<select name="billingAddressStateId" required="true">
					<option value="">Select</option>
				<cfloop query="states">
					<option value="#states.id#"<cfif params.billingAddressStateId EQ states.id> selected</cfif>>#states.name#</option>
				</cfloop>
				</select>
			</div>
		</div>

		<div class="addlisting-payment-form-row<cfif ListFind(errorList,'billingAddressZip')> invalid-input</cfif>">
			<div class="addlisting-payment-form-cellL">*Billing Zip/Postal</div>
			<div class="addlisting-payment-form-cellR"><input class="noPreText" type="text" name="billingAddressZip" value="#params.billingAddressZip#" required="true" pattern="[0-9a-zA-Z]{5,7}"></div>
		</div>

		<div class="addlisting-payment-form-row<cfif ListFind(errorList,'billingAddressCountryId')> invalid-input</cfif>">
			<div class="addlisting-payment-form-cellL">*Billing Country</div>
			<div class="addlisting-payment-form-cellR styled-select">
				<select name="billingAddressCountryId" required="true">
					<option value="">Select</option>
				<cfloop query="countries">
					<option value="#countries.id#"<cfif params.billingAddressCountryId EQ countries.id> selected</cfif>>#countries.name#</option>
				</cfloop>
				</select>
			</div>
		</div>

		<div class="addlisting-payment-form-row<cfif ListFind(errorList,'billingAddressPhone')> invalid-input</cfif>">
			<div class="addlisting-payment-form-cellL">*Billing Phone Number</div>
			<div class="addlisting-payment-form-cellR"><input class="noPreText" type="tel" name="billingAddressPhone" value="#params.billingAddressPhone#" required="true"></div>
		</div>

		<div class="addlisting-payment-form-row">
			<div class="addlisting-payment-form-cellL">Billing Fax Number</div>
			<div class="addlisting-payment-form-cellR"><input class="noPreText" type="tel" name="billingAddressFax" value="#params.billingAddressFax#"></div>
		</div>

		<div class="addlisting-payment-form-row<cfif ListFind(errorList,'billingAddressEmail')> invalid-input</cfif>">
			<div class="addlisting-payment-form-cellL">*Billing Email Address</div>
			<div class="addlisting-payment-form-cellR"><input class="noPreText" type="email" name="billingAddressEmail" value="#params.billingAddressEmail#" required="true"></div>
		</div>

		<div class="addlisting-payment-form-row"<cfif ListFind(errorList,'termsAndConditions')> invalid-input</cfif>">
			<div style="    float: left;
    height: 40px;
    margin-right: 10px;
    margin-left: -8px;"><input type="checkbox" name="termsAndConditions" id="termsAndConditions" required="true" value="1"></div>
			<div><label for="termsAndConditions">I agree to the <span id="ccTermsAndConditions">LocateADoc.com Advertising Agreement and Terms & Conditions</span>. I know I can cancel at any time after the first month of service.</label></div>
		</div>

	</div>

</div>

	<input type="hidden" name="doctorsOnlyId" value="#params.doctorsOnlyId#">
	<input type="hidden" name="billingAddressAmount" value="1">


	<div id="termsAndConditionsDialog" style="    background-color: white;
    border-radius: 10px;
    border: 1px solid azure;">
		<h2 style="color: maroon;">Terms and Conditions</h2>
<p>THIS INTERNET ADVERTISING AGREEMENT (the "Agreement") is made and entered into by and between PRACTICEDOCK, a Florida Corporation whose mailing address is 2582 Maguire Rd, Ste 277, Ocoee, FL 34761 ("LocateADoc.com"), and the Practice/Physician indicated on the LocateADoc.com Order Form. (the "Advertiser").</p>

<p>WHEREAS, LocateADoc.com provides on its Internet Web Site located at <a href="http://www.locateadoc.com" target="_blank">http://www.locateadoc.com</a> a section which provides a listing of doctors on a city and state basis (the "Web Site").</p>

<p>WHEREAS, Advertiser desires to advertise and lease space on the Web Site to advertise its practice, services, and areas of expertise, and LocateADoc.com is willing to publish and display this advertisement upon the terms and conditions provided in this Agreement.</p>

<p>NOW, THEREFORE, in consideration of the mutual covenants and conditions contained herein, the parties hereby agree as follows:</p>

<p>1. <u>Advertisement</u>.</p>

	<p class="subLineIndent">(a) Advertiser agrees to lease space on the Web Site for Advertisements.  Advertiser is entitled to publish and display an advertisement regarding its practice, services, or areas of expertise. The exact location and position of the advertisement is solely within the discretion of LocateADoc.com.</p>

	<p class="subLineIndent">(b) All advertising materials, information, artwork, design, and layout to be published on the Web Site shall be subject to the approval of LocateADoc.</p>

<p>2. <u>Contract Administrator</u>. The Contract Administrator, for the advertiser, shall be responsible for receiving all notices under this Agreement, as well as responsible for transmitting and receiving all of the advertising materials, including making any changes to the advertisement.</p>

<p>3. <u>Contract Procedures.</u>	 The following procedure shall apply in the execution and fulfillment of this Agreement:  Payment of the fee set forth on the LocateADoc.com Order Form online for the lease of space on the Web Site shall be paid according to the schedule upon execution of this Agreement.  In the event of any renewal of this Agreement, payment for such renewal period shall also be paid according to the renewal Order Form.</p>

<p>4. <u>Advertising Materials; Grant of License.</u> Advertiser hereby grants to LocateADoc.com a royalty-free, worldwide, non-exclusive and non-transferable right and license to use, transmit, and display any advertising materials provided by Advertiser to LocateADoc, including, without limitation, any copyrighted material, trademarks, service marks, logos, or other depictions for the purposes expressly provided herein.</p>

<p>5. <u>Relationship of Parties.</u>  The parties acknowledge and agree that nothing contained herein is intended to create an agency, partnership, joint venture, or franchisor/franchisee relationship among LocateADoc.com and the Advertiser, and all services rendered by LocateADoc.com hereunder are performed solely as an independent contractor.</p>

<p>6. <u>Term of Agreement; Termination.</u></p>

	<p class="subLineIndent">(a) This Agreement shall commence on the date that the last party has executed this Agreement, and shall continue in full force and effect for a period specified on the order form beginning with the Date of Acceptance as that term is defined in paragraph 3 above (the "Initial Term").  If the Advertiser elects to cancel this Agreement for any reason during the Initial Term or if LocateADoc.com elects to terminate this Agreement as a result of a default by Advertiser, Advertiser shall be responsible for the full payment of the fee set forth on the Locateadoc.com Order Form</p>

	<p class="subLineIndent">(b) The Advertiser shall have the option to renew this Agreement  on such terms, price and payment conditions as agreed to by the Advertiser and LocateADoc.com after the expiration of the Initial Term, provided that the Advertiser is not and has not been in default.  The Advertiser shall be deemed to have automatically elected to renew this Agreement after the Initial Term unless the Advertiser cancels their product via the online portal.</p>

	<p class="subLineIndent">(c) The Advertiser or LocateADoc.com may cancel this Agreement at any time after the Initial Term by cancelling their product via the online portal.</p>

<p>7. <u>Representations and Warranties of Advertiser.</u>  The Advertiser represents and warrants to LocateADoc.com the following:  (i) the Advertiser is the owner or is licensed to use any material provided by it to LocateADoc.com hereunder, including, without limitation, any copyrighted material, trademarks, service marks, logos, and/or depictions of trademarked or service marked goods or services; (ii) with respect to any materials provided to LocateADoc, the Advertiser has authorization for the unrestricted use of such materials in connection with the advertising, promotion, and exploitation on the Internet as provided herein and the Advertiser will provide contractual releases to LocateADoc.com from all patients whose photos/personal information are used, and the use by LocateADoc.com of any materials will not violate the rights of any third party and will not give rise to any claim of such violation; (iii) Advertiser has the right to publish the contents of the advertisement, and the advertisement does not violate any intellectual property rights or proprietary rights; and (iv) any material provided by the Advertiser to LocateADoc.com hereunder, including, without limitation, any copyrighted material, trademarks, service marks, logos, and/or depictions of trademarked or service marked goods or services, does not violate any law or regulation of a governmental body having jurisdiction thereon, or any right of any third party including, but not limited to, any property or privacy right.</p>

<p>8. <u>Representations and Warranties of LocateADoc.com</u>  LocateADoc.com represents and warrants to the Advertiser that the Web Site will be free from material programming errors and from defects in workmanship and material.  If material programming errors are discovered, LocateADoc.com shall promptly remedy them.  In the event that LocateADoc.com fails to publish or display an advertisement in accordance with this Agreement (or in the event of any failure, technical, or otherwise), the sole liability of LocateADoc.com to the Advertiser shall be limited to either a refund of any pre-paid advertising fee or placement of the advertisement at a later time in a comparable position.</p>

<p>9.  <u>Disclaimer/Limitation of Warranties.</u>  The warranties contained in this agreement are exclusive.  They are in lieu of all other warranties, expressed or implied, including without limitation, any implied warranty of merchantability or fitness for a particular purpose, title or non-infringement, or arising by statute, or otherwise in law or from a course of dealing or usage of trade.</p>

<p>10. <u>Limitations of Liability.</u>  In no event shall LocateADoc.com be liable under any legal theory for (i) any indirect, special, incidental, or consequential damages, including, but not limited to, loss of profits, even if LocateADoc.com has notice of the possibility of such damages arising out of this Agreement (including any failure to timely publish any advertisement); (ii) any reasonable errors or omissions in any advertising published by LocateADoc.com pursuant to materials provided by Advertiser; or (iii) any delays or non-performance in the event of an act of nature, action by any government entity, strike, network difficulties, electronic malfunction, network feasibility, disruption, downtime, or other delay related to the Web Site.</p>

<p>11.  <u>Exclusive Remedy.</u>  The parties agree that the remedies set forth in this agreement shall constitute the sole and exclusive remedies available for any breach of this agreement, including any breach of warranty, expressed or implied.</p>

<p>12. <u>Notices.</u>  All notices, requests, demands, and other communications permitted or required to be given under this Agreement shall be given in writing and delivered in person or sent by certified mail, postage prepaid, return receipt requested.  Such notice shall be effective on the date of delivery or three (3) days after the date of mailing.  Any notices given pursuant to this Agreement shall be addressed to the other party at the address listed above or at such other addresses as the parties may designate by written notice.</p>

<p>13. <u>Indemnification.</u>  The Advertiser shall indemnify and hold LocateADoc, its employees, agents, officers, and directors harmless from any and all claims, actions, suits, proceedings, costs, expenses, damages and liabilities, including attorneys' fees, claimed by any person, organization, association, or otherwise arising out of, or relating to, Advertiser's advertisement on the Web Site, including, without limitation, any claim of trademark or copyright infringement, libel, defamation, breach of confidentiality, false or deceptive advertising or sales practices, or any material of Advertiser to which users can link through the advertisements.  The provisions of this paragraph shall survive the termination of this Agreement.</p>

<p>14. <u>Enforcement of Agreement.</u></p>

	<p class="subLineIndent">(a) In the event that enforcement of this Agreement becomes necessary (whether suit be brought or not), the prevailing party shall be entitled to recover from the other party, in addition to all other remedies available at law, an amount equal to all costs and expenses incurred in connection with such enforcement, including reasonable attorney fees at the trial level and in connection with all appellate proceedings.</p>

	<p class="subLineIndent">(b) This Agreement and all instruments or documents related thereto shall be construed in accordance with the laws of the State of Florida.  In the event of any legal or equitable action arising under this Agreement, the parties agree that jurisdiction and venue of such action shall lie exclusively within the state courts of Florida located in Orange County, Florida, or the United States District Court for the Middle District of Florida, Orlando Division, and the parties specifically waive any other jurisdiction and venue.</p>

<p>15. <u>Assignment.</u>  This Agreement may be assigned by LocateADoc.com  The Advertiser may not assign or transfer any of its rights hereunder, and any attempted assignment or transfer of such rights shall result in the immediate termination of this Agreement.</p>

<p>16. <u>Miscellaneous.</u>  In addition to the terms and conditions set forth above, the following provisions shall apply:  (i) this Agreement constitutes the entire agreement and understanding between the parties as to the subject matter hereof, and shall not be amended or modified in any manner except by an instrument in writing executed by the parties or their respective successors in interest; (ii) any number of counterparts of this Agreement may be signed and delivered, each of which shall be considered an original and all of which, together, shall constitute one and the same instrument; (iii) whenever possible, each part of this Agreement shall be interpreted in such a manner as to be valid under applicable law, and the invalidity or unenforceability of a particular provision of this Agreement shall not affect the other provisions hereof, and this Agreement shall be construed in all respects as if such invalid or unenforceable provisions were omitted; (iv) the waiver by either party of a breach of any provision of this Agreement shall not operate or be construed as a waiver of any other provision of this Agreement or of any future breach of the provision so waived; and (v) all warranties, representations, and covenants contained herein shall survive the termination of this Agreement.</p>

		<div style="text-align: center;">
			<button id="termsAndConditionsAgreed" name="termsAndConditionsAgreed" value="1" style="margin-right: 25PX;"> I Agree</button>
			<button id="termsAndConditionsDisAgreed" name="termsAndConditionsDisAgreed" value="1"> I Disagree</button>
		</div>

	</div>

</cfoutput>