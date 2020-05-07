<cfparam name="params.name" default="">
<cfparam name="params.firstname" default="">
<cfparam name="params.lastname" default="">
<cfparam name="params.email" default="">
<cfparam name="params.phone" default="">
<cfparam name="hasContactForm" default="">

<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1>
	<cfset params = Request.oUser.appendUserInfo(params)>
</cfif>

<cfsavecontent variable="js">
	<cfoutput>
		<script type="text/javascript">
			var miniFormHidden = true;
			var firstOpen = true;
			function profileMiniOpen(typeId)
				{
				// Hide sitewide mini if exists
				if($('.SW-popup-box'))
					hideSWbox();
				if(firstOpen)
					{
					positionMiniForm();
					firstOpen = false;
					}
				$("##leadTypeId").val(typeId);
				setIntroMsg(typeId);
				if(miniFormHidden)
					{
					$('.mini-popup-box').slideDown();
					miniFormHidden = false;
					}
				}
			function positionMiniForm()
				{
				var pos = $("##contact-icons").offset();
				$('.mini-popup-box').position({
					top: pos.top+76,
					left: pos.left-50
					});
				}
			function setIntroMsg(typeId)
				{
				switch(typeId)
					{
					// Website
					case 2:
						$("##introMsg").html("Please complete this form to have the Doctor's website emailed to you.");
						break;
					// Phone
					case 3:
						$("##introMsg").html("Please complete this form to have the Doctor's phone number emailed to you.");
						break;
					// Email
					case 4:
						$("##introMsg").html("Please complete this form to have the Doctor's email address sent to you in an email.");
						break;
					}
				}
			function profileMiniHide()
				{
				$('.mini-popup-box').slideUp();
				miniFormHidden = true;
				}
			function profileMiniSubmit()
				{
					var error = false;
		    		var emailRE = new RegExp("^[a-z0-9]+([_+!\.-][a-z0-9]+)*@[a-z0-9]+([\.-][a-z0-9]+)*\.[a-z0-9]{2,6}$", "i");
		    		var tempPhone = "";
					$('##miniInvalid').fadeOut();
					$('##miniForm').children('div').each(function(){
						$(this).removeClass('invalidData');
						});
		    		$('##miniForm').children('div').each(function(){
		    			if($(this).attr('id'))
		    				{
		    				fieldName = "##" + $(this).attr('id').replace(/.*_/,'');
			    			if(fieldName != "##" && $(fieldName).attr('req')== "true" && $(fieldName).val() == "")
			    				{
			    				error = true;
			    				$(this).addClass('invalidData');
			    				}
		    				}
		    			});
		    		if ($("##miniForm ##phone").val() != '' && $("##miniForm ##phone").val().replace(/[^0-9]+/,"").length < 10)
		    			{
		    			error = true;
		    			$("##miniForm ##SWfield_phone").addClass('invalidData');
		    			}
		    		if(!emailRE.test($("##miniForm ##email").val()) && !$("##SWfield_email").hasClass("invalidData"))
		    			{
		    			error = true;
		    			$("##SWfield_email").addClass('invalidData');
		    			}
		    		if(error)
		    			{
			    		$('##miniInvalid').fadeIn();
		    			}
		    		else
		    			{
		    			$('##miniForm').submit();
		    			}
				}
			$(function(){
				$(".mini-popup-box").removeClass("hidden");
				$('.mini-popup-box').slideUp();
				$(".mini-popup-box").addClass("hidden");
				var myTimer = setTimeout('$(".mini-popup-box").removeClass("hidden");',1000);
			})
		</script>
	</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#fnCompress(js)#">

<cfif Server.ThisServer eq "dev">
	<cfset formAction = "/#params.siloname#/contact">
<cfelse>
	<cfset formAction = "https://www.locateadoc.com/#params.siloname#/contact">
</cfif>

<cfoutput>
	<div class="mini-popup-box hidden">
		<table class="modal-box">
			<tr class="row-buttons">
				<td colspan="2"><div class="closebutton" onclick="profileMiniHide(); return false;"></div></td>
			</tr>
			<tr class="row-t">
				<td class="l-t"></td>
				<td class="t"></td>
			</tr>
			<tr class="row-c">
				<td class="l"></td>
				<td class="c">
					<p id="introMsg">Message here</p>
					<p class="invalid-message" id="miniInvalid" style="display:none;">Your submission contains invalid information. Please correct the highlighted fields.</p>
					<form id="miniForm" class="FBpop" name="miniForm" action="#formAction#" method="post">
						<input type="hidden" name="process_mini" value="1">
						<input type="hidden" name="leadTypeId" id="leadTypeId">
						<div id="SWfield_firstname">
							<h5>First Name</h5>
							<div class="stretch-input"><span><input type="text" class="noPreText" name="firstname" id="firstname" value="#params.firstname#" req="true" /></span></div>
						</div>
						<div id="SWfield_lastname">
							<h5>Last Name</h5>
							<div class="stretch-input"><span><input type="text" class="noPreText" name="lastname" id="lastname" value="#params.lastname#" req="true" /></span></div>
						</div>
						<div id="SWfield_email">
							<h5>Email Address</h5>
							<div class="stretch-input"><span><input type="email" class="noPreText" name="email" id="email" value="#params.email#" req="true" /></span></div>
						</div>
						<div id="SWfield_phone">
							<h5>Daytime Phone</h5>
							<div class="stretch-input"><span><input type="text" class="noPreText" name="phone" id="phone" value="#params.phone#" req="true" /></span></div>
						</div>
						<cfif not Request.oUser.saveMyInfo>
							<div class="login-set" style="margin:10px 0; float:right; padding-right:5px;">
								#Request.oUser.getCheckBox(label="Save my information")#
							</div>
						</cfif>
						<div style="clear:both;"></div>
						<div class="btn">
							<input type="button" class="btn-contactdoc" value="" onclick="profileMiniSubmit(); return false;" />
						</div>
					</form>
				</td>
			</tr>
			<tr class="row-b">
				<td class="l-b"></td>
				<td class="b"></td>
			</tr>
		</table>
	</div>
</cfoutput>