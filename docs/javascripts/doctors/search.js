$(function(){
	var latestTick = 0;
	$("#city").autocomplete({ 
		create: function(event, ui) {$(this).autocomplete("widget").addClass('square-autocomplete');},
		minLength: 1,
    	source: function(req, add){
			$.getJSON("/doctors/location?format=json&callback=?", req, function(data) {
				if (data.TICK > latestTick){
					latestTick = data.TICK;
	            	var suggestions = [];  
	                $.each(data.CONTENT, function(i, val){  
	                	suggestions.push(val);                  	
	            	});  
	        		add(suggestions);
        		}
     		});
     	}
	});
	
	$('.filter-modal').each(function(){
		var _filterBox = $(this);
		$(this).dialog({
			autoOpen:false,
			draggable:false,
			resizable:false,
			modal:true,
			closeText:'',
			dialogClass:'compare-dialog',
			width:777,
			show:'fade',
			hide:'fade'
		});	
		_filterBox.find('.closebutton').click(function(){
			_filterBox.dialog('close');
		 	return false;
		});
	});
	$('.filter-more-link').click(function(){
		$($(this).attr('href')+"-box").dialog('open');
		$('.ui-widget-overlay').addClass('modal-shade');
		return false;
	});
	
	DSprocedureArray = [];
	$("#procedure-box ul li a").each(function(){
		DSprocedureArray.push({label:$(this).html(),value:$(this).html(),filter:$(this).attr('filter'),filterID:$(this).attr('value')});
	});
	$("#procedurename").autocomplete({
		create: function(event, ui) {$(this).autocomplete("widget").addClass('square-autocomplete');},
		minLength	: 2,
		source		: DSprocedureArray,
		select		: function(e,ui) {
			AddFilter(ui.item.filter+'-'+ui.item.filterID);
		}
	})
});