<cfparam name="linkOffer" default="false">
<cfoutput>
	<!--- Consultation fee --->
	<cfif doctor.consultationCost1 gt 0>
		<img src="/images/profile/miscellaneous/icon_gift.gif" style=" float:left; margin:0 15px;">
		<ul style="color:##73756A; margin-left:55px; padding:0; font:bold 11pt Arial,sans serif, sans;">
			<li style="list-style-type:none;">
				<cfif linkOffer><a href="#URLfor(controller=doctor.siloName,action="offers")#"></cfif>
				#doctor.fullNameWithTitle#&nbsp;-&nbsp;
				<cfswitch expression="#doctor.consultationCost1#">
					<cfcase value="1">
						Gives FREE Consultations!
					</cfcase>
					<cfcase value="2">
						Applies Consultation Fee Toward Surgery!
					</cfcase>
					<cfcase value="3">
						<cfif doctor.consultationCost2 eq 0>
							Offers $#doctor.consultdiscount# Off Your Consultation Fee!
						<cfelseif doctor.consultationCost2 eq 1>
							Offers #doctor.consultdiscount#% Off Your Consultation Fee!
						</cfif>
					</cfcase>
				</cfswitch>
				<cfif linkOffer></a></cfif>
			</li>
		</ul>
	</cfif>
</cfoutput>