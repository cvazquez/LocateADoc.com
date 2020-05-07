function blogSearch(){
	var searchStr = $("#blogSearchTerm").val();
	searchStr = searchStr.replace(/-/g,"_");
	window.location = "/resources/blog-list/" + searchStr;
}


function authorGooglePlusAPIPhoto(googlePlusId)
{
	$.ajax({
			type: "GET",
			url: "https://www.googleapis.com/plus/v1/people/" + googlePlusId + "?fields=image&key=AIzaSyAW0P6vhJbR2PWfJy9GhUcFBUmTbjN9toc"
	}).done(function( data ) {
		$("#GooglePlusThumbNailImage").html('<img src="' + data.image.url + '&sz=100" border="0">');
	});
	
}