<cfsavecontent variable="js">
	<cfoutput>
		<script type="text/javascript">
			var claimProfileHidden = true;
			var firstOpen = true;

			function showClaimProfile(doctorId){
				var pos = $('.CPbutton').offset();
				// Hide mini form if exists

				if($('.claimprofile-popup-box').css("display") == "block" && typeof ClaimProfileHide == "function")
				{
					ClaimProfileHide();
					return;
				}

				if($('.claimprofile-popup-box').hasClass('hidden'))
				{
					$('.claimprofile-popup-box').removeClass('hidden');
					$('.claimprofile-popup-box').offset({
						top: pos.top-50,
						left: pos.left-50
					});
					$('.claimprofile-popup-box').addClass('hidden');
				}

				$('.claimprofile-popup-box').slideDown();

				$.ajax({
				    type: "POST",
				    url: "/common/claim",
				    data:  {
				    		key: doctorId
				    },
				    dataType: "html",
				    success: function(response) {
				    	$(".claimprofiletext").html(response);
				    }
			    });
			}

			function ClaimProfileHide()
			{
				$('.claimprofile-popup-box').slideUp();
				claimProfileHidden = true;
			}

			$(function(){
				$(".claimprofile-popup-box").removeClass("hidden");
				$('.claimprofile-popup-box').slideUp();
				$(".claimprofile-popup-box").addClass("hidden");
				var myTimer = setTimeout('$(".claimprofile-popup-box").removeClass("hidden");',1000);
			})

			<!--- function hideClaimProfile(){
				$('.claimprofile-popup-box').removeClass('hidden');
				$('.claimprofile-popup-box').slideUp();
			} --->


			<!--- function ClaimProfileOpen(typeId)
				{
				// Hide claimProfile if exists
				if($('.claimprofile-popup-box'))
					hideCPbox();
				if(firstOpen)
					{
					PositionClaimProfile();
					firstOpen = false;
					}
				$("##leadTypeId").val(typeId);
				setIntroMsg(typeId);
				if(claimProfileHidden)
					{
					$('.claimprofile-popup-box').slideDown();
					claimProfileHidden = false;
					}
				} --->
			<!--- function PositionClaimProfile()
				{
				var pos = $("##contact-icons").offset();
				$('.claimprofile-popup-box').position({
					top: pos.top+76,
					left: pos.left-50
					});
				} --->
		</script>
	</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#fnCompress(js)#">

<cfoutput>
<div class="claimprofile-popup-box hidden">
	<!---

	--->
	<table class="modal-box">
		<tr class="row-buttons">
			<td colspan="2"><div class="closebutton" onclick="ClaimProfileHide(); return false;"></div></td>
		</tr>
		<tr class="row-t">
			<td class="l-t"></td>
			<td class="t"></td>
		</tr>
		<tr class="row-c">
			<td class="l"></td>
			<td class="c">
				<div class="claimprofiletext"></div>
			</td>
		</tr>
		<tr class="row-b">
			<td class="l-b"></td>
			<td class="b"></td>
		</tr>
	</table>
</div>
</cfoutput>