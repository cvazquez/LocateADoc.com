<style>
	.docOnlyPaymentMessages{
		border: 1px solid black;
		border-radius: 10px;
	    width: 89%;
		padding: 10px 10px;
		background-color: aliceblue;
		margin: 30px 0px;
	}
</style>

<cfoutput>

<strong>Congratulations #createNewAccount.doctor.firstname# #createNewAccount.doctor.lastName# #createNewAccount.doctor.title#,</strong>

<p>You have successfully setup a new LocateADoc.com listing. Your new listing can be found at <a href="http://#cgi.server_name#/#createNewAccount.doctor.siloName#">http://#cgi.server_name#/#createNewAccount.doctor.siloName#</a>.</p>

<p>To make edits to your new listing, please log into <a href="https://www.practicedock.com/index.cfm/PageID/7151">https://www.practicedock.com/index.cfm/PageID/7151</a>.</p>


<div style="border: 1px solid black;
		border-radius: 10px;
	    width: 89%;
		padding: 10px 10px;
		background-color: aliceblue;
		margin: 30px 0px;">
	<h2>Login Information</h2>

	<p>Your user name is the doctor's email address you provided us.</p>

	<p><strong>User name: #createNewAccount.doctor.userName#</strong></p>

	<p><strong>Password:</strong> For security purposes, we will never display your password. If you forgot your password, use the password reset tool on <a href="https://www.practicedock.com/index.cfm/PageID/7151">https://www.practicedock.com/index.cfm/PageID/7151</a>.</p>
</div>


#includePartial("paymentreceipt")#

</cfoutput>