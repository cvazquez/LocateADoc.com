$(function(){
	$('.selectReviewOrder').change(function(){
		window.location = $('.selectReviewOrder option:selected').val();
	});
});