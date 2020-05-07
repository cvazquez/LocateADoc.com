<cfoutput>
<div  style="border: 1px solid black;
		border-radius: 10px;
	    width: 89%;
		padding: 10px 10px;
		background-color: aliceblue;
		margin: 30px 0px;">
	<table style="margin-bottom: 15px;">
		<tr colspan="2">
			<th class="receiptHeader" style="font-size: 1.15rem;">Transaction Information</th>
		</tr>
		<tr>
			<td>Order Date</td>
			<td>#dateFormat(receipt.orderDate, "mm/dd/yyyy")# #timeFormat(receipt.orderDate, "hh:mm tt")# EST</td>
		</tr>
		<tr>
			<td>Transaction Id</td>
			<td>#receipt.transactionId#</td>
		</tr>
		<tr>
			<td>Subscription Id</td>
			<td>#receipt.subscriptionId#</td>
		</tr>
		<tr>
			<td>Amount</td>
			<td>#receipt.amount#</td>
		</tr>
		<tr>
			<td>IP Address</td>
			<td>#receipt.ipAddress#</td>
		</tr>
		<tr>
			<td>Currency</td>
			<td>#receipt.currency#</td>
		</tr>
		<tr>
			<td>Authorization Code</td>
			<td>#receipt.authorizationCode#</td>
		</tr>
		<tr>
			<td>Customer Id</td>
			<td>#receipt.customerId#</td>
		</tr>
		<tr>
			<td>Reccurring Charge Day</td>
			<td>#receipt.plan.dayOfMonth# of every month</td>
		</tr>
	</table>
</div>

<div  style="border: 1px solid black;
		border-radius: 10px;
	    width: 89%;
		padding: 10px 10px;
		background-color: aliceblue;
		margin: 30px 0px;">
	<table id="billingTable">
		<tr colspan="2">
			<th class="receiptHeader" style="font-size: 1.15rem;">Billing Information</th>
		</tr>
		<tr>
			<td>First Name</td>
			<td>#receipt.billing.firstName#</td>
		</tr>
		<tr>
			<td>Last Name</td>
			<td>#receipt.billing.lastName#</td>
		</tr>
		<tr>
			<td>Address</td>
			<td>#receipt.billing.address1#</td>
		</tr>
		<tr>
			<td>City</td>
			<td>#receipt.billing.city#</td>
		</tr>
		<tr>
			<td>State</td>
			<td>#receipt.billing.state#</td>
		</tr>
		<tr>
			<td>Postal Code</td>
			<td>#receipt.billing.postal#</td>
		</tr>
		<tr>
			<td>Country</td>
			<td>#receipt.billing.country#</td>
		</tr>
		<tr>
			<td>Phone</td>
			<td>#receipt.billing.phone#</td>
		</tr>
		<tr>
			<td>Email</td>
			<td>#receipt.billing.email#</td>
		</tr>
		<tr>
			<td>Company</td>
			<td>#receipt.billing.company#</td>
		</tr>
		<tr>
			<td>Credit Card Number</td>
			<td>#receipt.billing.ccNumber#</td>
		</tr>
		<tr>
			<td>Credit Card Expiration</td>
			<td>#receipt.billing.ccExp#</td>
		</tr>
	</table>
</div>
</cfoutput>