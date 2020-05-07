<cfoutput>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
	<head>
		<title>Print Coupon</title>
		<script type="text/javascript">
			CouponError('#URLfor(controller=doctor.siloName,action="couponerror")#');
		</script>
		#styleSheetLinkTag(sources="all")#
		#javaScriptIncludeTag(sources="
			https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js,
			http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js
		")#
	</head>
	<body>
		<div align="center" style="text-align:left; width:500px; margin:10px auto;"><input type="button" onclick="$(this).hide();$('body').css('color','black');window.print();" value="Print Coupon"></div>
		#includePartial(partial=coupons)#
		<div align="center" style="text-align:left; width:500px; margin:10px auto; font-size:10px;">
			<strong>DISCLAIMER:</strong> LocateADoc.com is not affiliated with this medical organization or any of its affiliates or subsidiaries.  The patient agrees that LocateADoc.com is not responsible for this offer.
		</div>
	</body>
	</html>
</cfoutput>