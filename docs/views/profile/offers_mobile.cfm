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
			#includePartial(partial=coupons)#
		</div>
	</div>
	<!-- aside -->
	<div class="aside">
		#includePartial("/shared/minileadsidebox_mobile")#
		<div class="mobileWidget">
			#includePartial("/shared/beforeandaftersidebox")#
		</div>
		#includePartial("/shared/paymentoptionssidebox")#
	</div>
</cfoutput>