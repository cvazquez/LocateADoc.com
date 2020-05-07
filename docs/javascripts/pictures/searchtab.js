var FR
$(function(){
	// Results filtering
	FR = new filterResults({
		url:gallerybase+"/filterresults",
		action:doctorId,
		permfilters:{doctor:doctorId},
		returns:"json&intab=true",
		div:"#filters_content, #searchterm_content, #searchresults_content",
		opacity:"0",
		click:"a[filter]",
		change:"input[name=page]",
		callback:searchInit
	})
	
	// On load, check the URL for hash values and reform the URL
	//FR.reformURL()
	
	searchInit()
})

function searchInit() {
	$('.setup-complete').remove();
	
	initOpenClose();
	
	/*$("input[name=procedure]")
		.change(function(){
			$("a[filter=procedure]").attr("value",$(this).val())
		});*/
	
	$("#procedurename").autocomplete({
		create: function(event, ui) {$(this).autocomplete("widget").addClass('square-autocomplete');},
		minLength	: 2,
		source		: allProcedures,
		select		: function(e,ui) {
			var filterURL = location.href.split("?")[0].replace("#","");
			if(typeof siloedFilters != "undefined" && filterURL.search(siloedFilters) == -1)
				filterURL = filterURL.replace(siloedNames,"") + siloedFilters;
			filterURL = filterURL + "/procedure-"+ui.item.procedureId;
			location.href = filterURL;
			//location.hash += "/procedure-"+ui.item.procedureId
		}
	});
	
	// Forces user to only enter numeric values for form fields like DISTANCE, ZIPCODE and PAGE (pagination)
	$(".pager-form .txt")
		.numbersOnly();
		
	$("#removeallfilters")
		.click(function(event){
			event.preventDefault()
			location.hash = ""
			FR.refreshSearch()
		});
		
	$("input[name=page]")
		.keyup(function(event) {
			var input = $(this)
			formListener(event,function(){
				input.change()
			})
		});
		
	$('.filter-modal').each(function(){
		var _filterBox = $(this);
		_filterBox.removeClass('hidefirst');		
		_filterBox.dialog({
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
		_filterBox.find('a').click(function(){
			_filterBox.dialog('close');
		});
		_filterBox.addClass('setup-complete');
	});
	$('.filter-more-link').click(function(){
		$($(this).attr('href')+"-box").dialog('open');
		$('.ui-widget-overlay').addClass('modal-shade');
		return false;
	});
}