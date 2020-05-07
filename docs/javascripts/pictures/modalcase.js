$(function(){
	$('.case-modal').dialog({
			autoOpen:false,
			draggable:false,
			resizable:false,
			modal:true,
			closeText:'',
			dialogClass:'compare-dialog',
			width:977,
			height:700,
			show:'fade',
			hide:'fade'
	});		
	$("a.casedetails")
		.unbind("click")
		.click(function(event){
			event.preventDefault();
			var caseid = parseInt($(this).attr("caseid"));
			if (isNaN(caseid)) return;
			$("<div/>")
				.attr("id","pleasewait")
				.css("text-align","center")
				.html("<p>Getting case details...</p><img src='/images/layout/loading.gif' /></div>")
				.appendTo("body")
				.dialog({
					title			: "Please wait",
					modal			: true,
					resizable		: false,
					draggable		: false,
					closeOnEscape	: false
				});
			$.post("/profile/gallerycase/"+caseid+"?format=json",{},function(response){				
				$('.case-modal').dialog('open');
				$('.ui-widget-overlay').addClass('modal-shade');
				$("#gallery_case").html(response);
				$(".link-back")
					.unbind("click")
					.click(function(event){
						event.preventDefault();
						$('.case-modal').dialog('close');
					});
				$("#pleasewait").remove();
			});
		});
});