$(function(){

	$("#ViewMoreExpertsLink").click(function(event)
	{
		// This is in case the user has javascript off, the link surrounding the button will still take them to the page, but not work if JS is on
		event.preventDefault();
	});	
	
		
	$("#ViewMoreExperts").click(function()
	{
		event.preventDefault();
		
		if(!$("div#AskADocExpertsHidden p").hasClass("hide"))
		{
			document.location = "/ask-a-doctor/experts/page-2";			
		}
				
		$("div#AskADocExpertsHidden p").removeClass("hide");
		
		$(".AskADocExpertsHidden").show();
		$("#ViewMoreExperts").text("view all experts");
		
	});
});