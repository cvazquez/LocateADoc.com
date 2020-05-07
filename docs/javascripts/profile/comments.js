var thisPage = 1;
$(function(){
	$('.rating-slider').slider({
		animate: true,
		min: 0,
		max: 10,
		value: $('#rating').attr('value'),
		slide: function(event, ui){
			$('.rating-display').html(ui.value);
			$('#rating').attr("value",ui.value);
		}
	});
	if($('.comment').length > 5){
		$('.comment-selector').removeClass('hidden');
		changeCommentPage(1,true);
	}
	/*$('.comment-modal').each(function(){
		var _lightBox = $(this);
		$(this).dialog({
			autoOpen:false,
			draggable:false,
			resizable:false,
			modal:true,
			closeText:'',
			dialogClass:'comment-dialog',
			width:777,
			height:700,
			show:'fade',
			hide:'fade',
			open: function(event,ui){$('.add-comment input[name="firstname"]').focus();}
		});	
		_lightBox.find('.closebutton').click(function(){
			_lightBox.dialog('close');
		 	return false;
		});
	});*/
	$('#comment-open').click(function(){
		/*$('.comment-modal').dialog('open');
		$('.ui-widget-overlay').addClass('modal-shade');*/
		$("#addcomment").slideDown(400);
		$('#comment-open').hide();
		updateFBPhotoPreview();
		return false;
	});
	$('#comment-close').click(function(){
		$("#addcomment").slideUp(400,function(){$('#comment-open').show();});
		return false;
	});
	if($('.invalid-input').length > 0){
		$('div.welcome-box>h2>a.comment-link').click();
	}
});
function validatePageForm(changedForm){
	if (changedForm.page.value.search(/[^0-9]/) > -1){
		$('.comment-page').attr('value',thisPage);	
	}else{
		var newPage = parseInt(changedForm.page.value);
		if ((newPage >= 1)&&(newPage <= Math.ceil($('.comment').length/5))){
			changeCommentPage(newPage,false);
		}else{
			$('.comment-page').attr('value',thisPage);	
		}
	}
	return false;
}
function changeCommentPage(pagenum,onLoad){
	$('.comment').addClass('hidden');
	$('.page_'+pagenum).removeClass('hidden');
	if (pagenum > 1){
		$('.prev-page').removeClass('hidden');
		$('.prev-page a').click(function(){
			changeCommentPage(pagenum-1,false);
			return false;
		});
	}else{
		$('.prev-page').addClass('hidden');
	}
	if($('.page_'+(pagenum+1)).length > 0){
		$('.next-page').removeClass('hidden');
		$('.next-page a').click(function(){
			changeCommentPage(pagenum+1,false);
			return false;
		});
	}else{
		$('.next-page').addClass('hidden');
	}
	if(!onLoad)window.scrollTo(0,$('#commenttop').offset().top);
	thisPage = pagenum;
	$('.comment-page').attr('value',thisPage);	
}
function updateFBPhotoPreview(){
	if($("#showphoto").attr("checked") == "checked")
		$("#facebookPhotoPreview>img").fadeTo('fast',1);
	else
		$("#facebookPhotoPreview>img").fadeTo('fast',0.2);
}
