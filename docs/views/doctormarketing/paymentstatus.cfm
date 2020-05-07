<cfoutput>
	<!-- main -->
	<div id="main">
		<cfif NOT isMobile>
			#includePartial("/shared/breadcrumbs")#
		</cfif>
		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder">
				<cfif NOT isMobile>#includePartial("/shared/pagetools")#</cfif>
				<div class="full-content">
					<h1 class="title-shadow">LocateADoc.com Order Status</h1>

					<cfif missingGateway>
						<p>There was a problem processing your transaction. This type of error usually occurs if you accessed this page indirectly.</p>
					<cfelse>


						<cfif userMessages.responseCode EQ 100>
							<style>
								.receiptHeader{
									font-size: 1.15rem;
								}

								##transactionTable{
									margin-bottom: 15px;
								}

								.docOnlyPaymentMessages{
									border: 1px solid black;
									border-radius: 10px;
									width: 69%;
									padding: 10px 10px;
									background-color: aliceblue;
									margin: 15px 0px;
								}
							</style>



							<div class="docOnlyPaymentMessages">
								<h2>Congratulations!</h2>

								<h3>You are now signed up to the top patient lead generation network, LocateADoc.com. You can now manage your listing, by utilizing tools proven to increase your exposure and deliver you leads including adding your photo, answering our Q&A, and responding to Ask A Doctor questions.</h3>

								<h4>Please check your email for the status of your order, a link to your profile and login information.</h4>

								<p>To begin managing your listing, log into <a href="https://www.practicedock.com/index.cfm/PageID/7151" target="PracticeDock">https://www.practicedock.com</a>, with the email address and password you provided.</p>

								<p>Your card has been charged $#introListingAmount# and will be charged monthly until you cancel. Print this page as a copy of your receipt:</p>
							</div>

							#includePartial("paymentreceipt")#

							<p>To see all doctor listing options, #LinkTo(action="advertising",text="click here")#.</p>

						<cfelse>
							<!--- Some error occurred. Display problem to user --->
							<h2>#userMessages.responseText# (#userMessages.responseCode#)</h2>

							<cfif userMessages.responseText NEQ "Transaction previously completed">
								<p>Please check your Credit Card information and try again.</p>
							</cfif>
						</cfif>

						<cfswitch expression="#userMessages.responseText#">
							<cfcase value="Referenced transaction expired">
								<p>Referenced transaction expired (#userMessages.responseCode#)</p>

								<p>Your connection to our payment gateway has expired. Please try your submission again. Sorry for the inconvenience.</p>
							</cfcase>
						</cfswitch>
					</cfif>

				</div>
			</div>
		</div>
	</div>
</cfoutput>
