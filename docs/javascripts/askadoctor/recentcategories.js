$(function(){

	$("#ViewMoreCategoriesLink").click(function(event)
	{
		// This is in case the user has javascript off, the link surrounding the button will still take them to the page, but not work if JS is on
		event.preventDefault()
	});	
	
	
	$("#ViewMoreCategories").click(function()
	{
		event.preventDefault()
		
		if(!$("ul.latestCategories li").hasClass("hide"))
		{
			document.location = "/ask-a-doctor/categories";			
		}
				
		$("ul.latestCategories li.hide").removeClass("hide");
		$("#ViewMoreCategories").text("view all categories");
		
	});
});