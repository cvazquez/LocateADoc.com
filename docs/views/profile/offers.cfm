<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1>
	<cfset params = Request.oUser.appendUserInfo(params)>
</cfif>

<cfoutput>
	<!-- content -->
	<div class="content print-area">
		<div class="welcome-box">
			<h1>Special Offers</h1>
			<div style="margin-bottom:30px;">#includePartial("consultation")#</div>
			<h2>Printable Coupons</h2>
			#includePartial(partial=coupons)#
		</div>
	</div>
	<!-- aside -->
	<div class="aside">
		#includePartial("/shared/minileadsidebox")#
		#includePartial(partial="/shared/sharesidebox",margins="10px 0")#
		<cfif displayAd IS TRUE>
			#includePartial(partial	= "/shared/ad",
							size	= "#adType#300x250")#
		</cfif>
		#includePartial("/shared/beforeandaftersidebox")#
		#includePartial("/shared/paymentoptionssidebox")#
	</div>

	<div class="coupon-modal hidefirst">
		<center>
			<table class="modal-box coupon-box">
				<tr class="row-buttons">
					<td colspan="2"><div class="closebutton"></div></td>
				</tr>
				<tr class="row-t">
					<td class="l-t"></td>
					<td class="t"></td>
				</tr>
				<tr class="row-c">
					<td class="l"></td>
					<td class="c">
						<p>Please fill out the form below in order to print our coupon.</p>
						<form action="" class="FBpop" id="couponForm" name="myForm" method="post" style="margin:15px 0">
							<input type="hidden" name="process_mini" value="#Application.leadTypes.coupon.id#">
							<input type="hidden" name="couponId" id="couponId" value="">
							<cfset tabindex = 0>
							<table cellpadding="0" cellspacing="0" width="270">
								<tr valign="top">
									<td style="width:120px;">
										Name*:
									</td>
									<td style="width:150px;" align="right">
										<input noAutoClear="true" type="text" name="coupon[name]" id="coupon_name" value="#params.firstname# #params.lastname#" tabindex="#IncrementValue(tabindex)#" onkeydown="$('##errormessage').fadeOut(); $(this).css('background-color','white');">
									</td>
								</tr>
								<tr valign="top">
									<td>
										Email Address*:
									</td>
									<td align="right">
										<input noAutoClear="true" type="text" name="coupon[email]" id="coupon_email" value="#params.email#" tabindex="#IncrementValue(tabindex)#" onkeydown="$('##errormessage').fadeOut(); $(this).css('background-color','white');">
									</td>
								</tr>
								<tr valign="top">
									<td>
										Phone Number:
									</td>
									<td align="right">
										<input noAutoClear="true" type="text" name="coupon[phone]" id="coupon_phone" value="#params.phone#" tabindex="#IncrementValue(tabindex)#">
									</td>
								</tr>
								<tr>
									<td colspan="2" style="padding:10px 0;">
										<div id="errormessage" style="color:red; font-weight:bold; margin-bottom:10px; display:none;">ERROR: Please fix the highlighted fields above.</div>
										<div class="login-set">#Request.oUser.getCheckBox()#</div>
									</td>
								</tr>
								<tr>
									<td>
										#linkTo(
											text		= "Privacy Policy",
											controller	= "home",
											action		= "privacy",
											target		= "_blank"
										)#
									</td>
									<td align="right">
										<input type="button" class="btn-search" value="" onclick="if(couponSubmitForm('#URLfor(action="submitcouponlead", key="#params.key#")#')) openCouponWindow(couponURL); return false;">
									</td>
								</tr>
							</table>
						</form>
						<p style="font-size:10px;">NOTE: By submitting this form you agree to send your information to #practice.name#.</p>
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