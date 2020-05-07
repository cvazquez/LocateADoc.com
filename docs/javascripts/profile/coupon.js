$(function(){
	$('.coupon-modal').each(function(){
		var _lightBox = $(this);
		$(this).dialog({
			autoOpen:false,
			draggable:false,
			resizable:false,
			modal:true,
			closeText:'',
			dialogClass:'coupon-dialog',
			width:400,
			height:350,
			show:'fade',
			hide:'fade'
		});	
		_lightBox.find('.closebutton').click(function(){
			_lightBox.dialog('close');
		 	return false;
		});
	});
	$('.coupon-link').click(function(){
		$('#couponId').val($(this).attr('couponId'));
		$('.coupon-modal').dialog('open');
		$('.ui-widget-overlay').addClass('modal-shade');
		couponURL = $(this).attr('id');
		return false;
	});
})

function CouponError(thisUrl)
{
	if(window.name != 'couponWindow')
					window.location = thisUrl;
}


function openCouponWindow(couponURL)
	{
	if(newWindow == null)
		var newWindow;
	else
		newWindow.close();
	var IE = /*@cc_on!@*/false;
	window.open(couponURL, 'couponWindow', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=550,height=450');
	if(IE)
		event.returnValue = false;
	else
		return false;
	}
function couponSubmitForm(thisURL)
	{
	var returnBoolean = true;
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	var needRefresh = false; //#(submittedLead)?"false":"true"#

	if($.trim($("#couponForm #coupon_email").val()) == "" || !emailReg.test($("#couponForm #coupon_email").val()))
		{
		$("#couponForm #coupon_email").focus().css("background","#FFD6DE");
		returnBoolean = false;
		}
	if($.trim($("#couponForm #coupon_name").val()) == "")
		{
		$("#couponForm #coupon_name").focus().css("background","#FFD6DE");
		returnBoolean = false;
		}
	if(returnBoolean)
		{
		// Submit form
		$.post(thisURL + "?format=json", $('#couponForm').serialize(), function(response) {
				$('.coupon-modal .closebutton').click();
				if(needRefresh)
					window.location.reload();
			} );
		}
	else
		$('#errormessage').fadeIn();
	return returnBoolean;
	}