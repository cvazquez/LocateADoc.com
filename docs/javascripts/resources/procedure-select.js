$(function(){
	/*
	var BPprocedureArray = [];
	$('#bodyParts ul ul li a[unique="1"]').each(function(){
		BPprocedureArray.push({label:$(this).html(),value:$(this).html(),href:$(this).attr('href')});
	});
	*/
	$("#procedurename").verboseautocomplete({
		create: function(event, ui) {$(this).autocomplete("widget").addClass('square-autocomplete');},
		minLength	: 2,
		source		: BPprocedureArray,
		select		: function(e,ui) {
			location.href = ui.item.href;
		}
	}).bind("autocompletesearchcomplete", function(event, contents) {		
	    if(contents.length == 0){
	    	$(this).autocomplete("widget").html('<li><p class="ui-corner-all">No results found.</p></li>');
	    	if($(this).autocomplete("widget").offset().top == 0){
		    	var BPpos = $("#procedurename").offset();
		    	$(this).autocomplete("widget").css("top",(BPpos.top + 20)+"px");
		    	$(this).autocomplete("widget").css("left",(BPpos.left)+"px");
		    }
		    $(this).autocomplete("widget").show();
	    }    
	});
	$(".slide-block:only-child>a").click();
	$(".sub-slide-block:only-child>a").click();
});