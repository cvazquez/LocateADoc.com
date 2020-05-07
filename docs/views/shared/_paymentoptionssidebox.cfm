<cfif creditcards.recordcount gt 0 or financingoptions.recordcount gt 0 or insurance.recordcount gt 0 or val(doctor.consultationCost1) gt 0>
<cfoutput>
	<!-- sidebox -->
	<div class="sidebox PaymentOptions">
		<div class="frame">
			<h4>Payment <strong>Options</strong></h4>
			<div class="payment-box">
				<cfif creditcards.recordcount gt 0>
					<h5>Credit Cards Accepted</h5>
					<cfloop query="creditcards">
						<img class="cclogo" src="#logoPath#" />
					</cfloop>
				</cfif>
				<cfif financingoptions.recordcount gt 0>
					<h5>Financing Accepted</h5>
					<cfloop query="financingoptions">
						<p>#name#</p>
					</cfloop>
				</cfif>
				<cfif insurance.recordcount gt 0>
					<h5>Insurance Accepted</h5>
					<cfloop query="insurance">
						<p>#name#</p>
					</cfloop>
				</cfif>
				<cfif val(doctor.consultationCost1) gt 0>
					<h5>Cost of Consultation</h5>
					<cfswitch expression="#doctor.consultationCost1#">
						<cfcase value="1"><p>Free</p></cfcase>
						<cfcase value="2">
							<cfset price = REReplace(doctor.consultPrice,"$|\s","","all")>
							<cfif price eq "" or REFind(price,"[^0-9/.]") gt 0>
								<p>Fee applied toward surgery</p>
							<cfelse>
								<cfif doctor.consultationCost1 eq 1>
									<p>#price#% fee applied toward surgery</p>
								<cfelse>
									<p>$#price# fee applied toward surgery</p>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="3">
							<cfset price = REReplace(doctor.consultDiscount,"$|\s","","all")>
							<cfif price eq "" or REFind(price,"[^0-9/.]") gt 0>
								<p>Offers dicount for consultation fee</p>
							<cfelse>
								<cfif doctor.consultationCost1 eq 1>
									<p>Offers $#price# off of consultation fee</p>
								<cfelse>
									<p>Offers #price#% off of consultation fee</p>
								</cfif>
							</cfif>
						</cfcase>
					</cfswitch>
				</cfif>
			</div>
		</div>
	</div>
</cfoutput>
</cfif>