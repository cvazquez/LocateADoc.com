$(function(){

	$("#ViewMoreQuestionsLink").click(function(event)
	{
		// This is in case the user has javascript off, the link surrounding the button will still take them to the page, but not work if JS is on
		event.preventDefault()
	});	
	
	
	$("#ViewMoreQuestions").click(function()
	{
		event.preventDefault()
		
		if(!$("ul.latestQuestions li").hasClass("hide"))
		{
			document.location = "/ask-a-doctor/questions/page-2";			
		}
				
		$("ul.latestQuestions li.hide").removeClass("hide");
		$("#ViewMoreQuestions").text("view all questions");
		
	});
});