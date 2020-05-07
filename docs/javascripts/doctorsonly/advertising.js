var activeTargetImage = "";
function changeOptionImage(targetImage){

	switch(activeTargetImage){
		case "#topdoctor":
			$("#LAD_options_1").fadeOut('fast');
			break;
		case "#featuredlisting":
			$("#LAD_options_2").fadeOut('fast');
			$("#LAD_options_3").fadeOut('fast');
			break;
		case "#citylisting":
			$("#LAD_options_4").fadeOut('fast');
			break;
		case "#basiclisting":
			$("#LAD_options_5").fadeOut('fast');
			break;
		case "#bannerads":
			$("#LAD_options_6").fadeOut('fast');
			$("#LAD_options_7").fadeOut('fast');
			break;
		default:
			$(".lad-options-blackout").fadeTo(100,0.5);
	}
	switch(targetImage){
		case "#topdoctor":
			$("#LAD_options_1").fadeIn('fast');
			break;
		case "#featuredlisting":
			$("#LAD_options_2").fadeIn('fast');
			$("#LAD_options_3").fadeIn('fast');
			break;
		case "#citylisting":
			$("#LAD_options_4").fadeIn('fast');
			break;
		case "#basiclisting":
			$("#LAD_options_5").fadeIn('fast');
			break;
		case "#bannerads":
			$("#LAD_options_6").fadeIn('fast');
			$("#LAD_options_7").fadeIn('fast');
			break;
	}
	activeTargetImage = targetImage;
}
$(function(){
	var optimgPos = $(".lad-options-image>img").offset();
	$(".lad-options-blackout").show();
	$(".lad-options-overlay").show();
	$(".lad-options-blackout").offset(optimgPos);
	$("#LAD_options_1").offset({top:optimgPos.top + 356, left:optimgPos.left + 27});
	$("#LAD_options_2").offset({top:optimgPos.top + 303, left:optimgPos.left + 122});
	$("#LAD_options_3").offset({top:optimgPos.top + 134, left:optimgPos.left + 118});
	$("#LAD_options_4").offset({top:optimgPos.top + 541, left:optimgPos.left + 120});
	$("#LAD_options_5").offset({top:optimgPos.top + 820, left:optimgPos.left + 123});
	$("#LAD_options_6").offset({top:optimgPos.top + 75, left:optimgPos.left + 26});
	$("#LAD_options_7").offset({top:optimgPos.top + 485, left:optimgPos.left + 32});
	$(".lad-options-blackout").hide();
	$(".lad-options-overlay").hide();

	$(".advertising-options a").click(function(){
		changeOptionImage($(this).attr('href'));
		return false;
	});
});