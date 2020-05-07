<cfparam name="fullCoupon" default="false">
<cfparam name="submittedLead" default="false">
<cfparam name="isEmailed" default="false">
<cfif isEmailed>
	<cfoutput>
		<table width="500" align="center" cellspacing="0" cellpadding="0" style="border:1px dashed ##000; text-align:left; width:500px;">
			<tr valign="top">
				<td colspan="2" style="border-bottom:1px solid black;">
					<img src="http://#CGI.SERVER_NAME#/images/coupon/header.gif">
				</td>
			</tr>
			<tr valign="top">
				<td colspan="2" style="padding:10px;">
					<p><b>#practice.name#</b></p>
					<h2>#title#</h2>
					<p>#details#</p>
					<p>
						<b>
							#currentLocation.address#<br>
							#currentLocation.cityName#, #currentLocation.stateAbbreviation# #currentLocation.postalCode#
							<cfif currentLocationDetails.phonePlus neq "">
								<br />#formatPhone(currentLocationDetails.phonePlus)#<br>
							<cfelseif isYext and (currentLocationDetails.phoneYext neq "")>
								<br />#formatPhone(currentLocationDetails.phoneYext)#<br>
							</cfif>
						</b>
					</p>
				</td>
			</tr>
			<tr>
				<td style="border-top:1px solid black; padding:5px 10px;">
					<p>Coupon No: #id#</p>
				</td>
				<td style="border-top:1px solid black; padding: 5px 10px;" align="right">
					<p>Offer Expires on #DateFormat(ExpirationDate,"mm/dd/yyyy")#</p>
				</td>
			</tr>
		</table>
	</cfoutput>
<cfelse>
	<cfoutput><!--- #id#<br /> --->
		<cfset thisCouponId = id>
		<cfset ecryptedCouponId = URLEncodedFormat(encrypt(thisCouponId, "print coupon", "CFMX_COMPAT", "Base64"))>
				<!--- #thisCouponId# = #ecryptedCouponId#<br />
				#coupons.title#<br /> --->

		<div align="center" class="profile-coupon" <!--- style="border:1px dashed ##000; text-align:left; width:500px; margin:10px auto;" ---> id="offer#thisCouponId#">
			<div class="profile-coupon-header" <!--- style="padding:4px; border-bottom:1px solid ##000; text-align:left; background:##eee url(/images/coupon/coupon_gradient.gif) repeat-x left top;" --->>
				<cfif fullCoupon>
					<img src="/images/coupon/header.png" align="right">
				<cfelse>
					<cfif NOT isMobile>
						#linkTo(
							text	= imageTag(source = "/coupon/print.png"),
							id		= "#URLfor(action="printcoupon", key=params.key)#?coupon=#ecryptedCouponId#",
							couponId = "#ecryptedCouponId#",
							class	= "coupon-link",
							style	= "float:right; border:0; margin:5px;"
						)#
					</cfif>
				</cfif>
				<img src="/images/coupon/logo.png">
			</div>
			<div class="profile-coupon-content" <!--- style="padding:12px;" --->>
				<p><b>#practice.name#</b></p>
				<h2>#title#</h2>
				<cfif fullCoupon>
					<p>#details#</p>
					<p>
						<b>
							#currentLocation.address#<br>
							#currentLocation.cityName#, #currentLocation.stateAbbreviation# #currentLocation.postalCode#
							<cfif currentLocationDetails.phonePlus neq "">
								<br />#formatPhone(currentLocationDetails.phonePlus)#<br>
							<cfelseif isYext and (currentLocationDetails.phoneYext neq "")>
								<br />#formatPhone(currentLocationDetails.phoneYext)#<br>
							</cfif>
						</b>
					</p>
					<div style="border:1px solid ##000; padding:4px;"><div style="float:right;"> Offer Expires on #DateFormat(ExpirationDate,"mm/dd/yyyy")#</div>Coupon No: #thisCouponId#</div>
				</cfif>
			</div>
		</div>
	</cfoutput>
</cfif>