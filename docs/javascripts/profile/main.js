function profileChangeLocation(event,lid)
{
	event.preventDefault();
	$.post("/profile/setlocation/" + lid + "?format=json",{},function (response){
		if(response)
			location.replace(location.href.split("?")[0]);
	});
}

$(function(){
	/*	
		If the main gallery nav is clicked, while on a profile with a gallery tab, 
		then prompt the user if they meant to leave the profile and if they rather view the profile's gallery
	*/
	$("#MainGalleryNav").click(function(event){
		
		if($(".before").length)
		{
			event.preventDefault();
			$('.gallerynavprompt-box').dialog('open');
		}
		
	});
	
	$('.gallerynavprompt-box').dialog({
		autoOpen:false,
		draggable:false,
		resizable:false,
		modal:true,
		closeText:'',
		dialogClass:'compare-dialog',
		width:640,
		height:480,
		show:'fade',
		hide:'fade',
		my:'center center',
		at:'center center',
		of:'body'
	});	
});



function GalleryNavPromptClose(){
$('.gallerynavprompt-box').dialog('close');						
}