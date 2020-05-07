<cfif hasContactForm AND action neq "contact">
	<script type="text/javascript">
		$(function(){
			var showTopBar = false;
			$(window).scroll(function(){
				var scrolledUnder = $(window).scrollTop() > ($(".topsections").offset().top + $(".topsections").height());
				if (!showTopBar && scrolledUnder){
					$("#topBar").fadeIn("fast");
					$("#topBarContent").fadeIn("fast");
				}else if (showTopBar && !scrolledUnder){
					$("#topBar").fadeOut("fast");
					$("#topBarContent").fadeOut("fast");
				}
				showTopBar = scrolledUnder;
			});
		})
	</script>
	<cfoutput>
		<div id="topBar"></div>
		<div id="topBarContent">
			<center>
			<table>
				<tr>
					<td class="shaded">#doctor.FullNameWithTitle#
						<cfif currentLocationDetails.phonePlus neq "">
							<br />#formatPhone(currentLocationDetails.phonePlus)#
						<cfelseif isYext and (currentLocationDetails.phoneYext neq "")>
							<br />#formatPhone(currentLocationDetails.phoneYext)#
						</cfif>
					</td>
					<td class="button-cell">
						<a href="#Server.ThisServer neq "dev" ? "https://#CGI.SERVER_NAME#" : ""#/#doctor.siloName#/contact" class="btn-contact" clicktrackkeyvalues="accountDoctorId:#params.key#;accountDoctorLocationId:#locationId#" clicktracklabel="ContactDoctorButton" clicktracksection="ProfileContact">CONTACT DOCTOR</a>
					</td>
				</tr>
			</table>
			</center>
		</div>
	</cfoutput>
</cfif>