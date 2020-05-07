<cfoutput>
<cfparam default="" name="errorList">
<div id="addlisting-billing-information">
	<h1>Credit Card Information</h1>
	<h3>Your credit card will be billed at a monthly rate of #introListingAmount#. You can cancel at any time. All information is encrypted for maximum security of your credit card information.</h3>
	<p>Step 1 of 2: Billing Information: &dash;&gt; <strong>Step 2 of 2: Credit Card</strong></p>

	<form action="#client.doctorMarketingResponseStep1FormURL#" method="post" id="doctorMarketingBillingCCForm">
	<div id="addlisting-payment-form">

		<div id="validation-client"></div>

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

		<div class="addlisting-payment-form-row">
			<div class="addlisting-payment-form-cellL">Credit Card Number</div>
			<div class="addlisting-payment-form-cellR"><input type="text" name="billing-cc-number" id="billing-cc-number" maxlength="16" required="true" pattern="[0-9]{12,19}"></div>
		</div>

		<div class="addlisting-payment-form-row">
			<div class="addlisting-payment-form-cellL">Credit Card Expiration (MMDD)</div>
			<div class="addlisting-payment-form-cellR"><input type="text" name="billing-cc-exp" id="billing-cc-exp" maxlength="4" required="true" pattern="[0-9]{4}"></div>
		</div>

		<div class="addlisting-payment-form-row">
			<div class="addlisting-payment-form-cellL">Credit Card Security Code (cvv) </div>
			<div class="addlisting-payment-form-cellR"><input type="text" name="billing-cvv" id="billing-cvv" required="true" pattern="[0-9]{3,4}"></div>
		</div>

		<div class="addlisting-payment-form-row">
			<div class="addlisting-payment-form-cellL">Credit Card Holder's First Name</div>
			<div class="addlisting-payment-form-cellR"><input type="text" name="billing-first-name" id="billing-first-name" required="true"></div>
		</div>

		<div class="addlisting-payment-form-row">
			<div class="addlisting-payment-form-cellL">Credit Card Holder's Last Name</div>
			<div class="addlisting-payment-form-cellR"><input type="text" name="billing-last-name" id="billing-last-name" required="true"></div>
		</div>

		<div style="width: 100%; padding: 18px 230px 26px;">
			<input type="submit" name="submit" value="Submit Payment" onclick="return SubmitCCInformation();">
		</div>
	</div>

	</form>

</div>
</cfoutput>
