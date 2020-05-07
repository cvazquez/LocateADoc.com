$(function(){
	$('.specialty-input').each(function(){
		var _APspecialty = $(this);
		_APspecialty.autocomplete({
			source: specialtyArray,
			open: function(event, ui){ 
				$(this).autocomplete("widget").removeClass("mini-autocomplete-scrolling");
				$(this).autocomplete("widget").addClass('mini-autocomplete');
				if($(this).autocomplete("widget").height() >= 300){
					$(this).autocomplete("widget").addClass("mini-autocomplete-scrolling");						
				}					
			},
			select: function(event, ui){			
				_APspecialty.val(ui.item.label);			
				return false;
			},
			focus: function(event, ui){
				_APspecialty.val(ui.item.label);
				return false;
			},
			change: function(event, ui){
				currentSelection = _APspecialty.val().toUpperCase();
				if (currentSelection == 'ACUPUNCTURE')currentSelection = 'ACUPUNCTURE ';
				var _selection = specialtyProcedureSelections[currentSelection];
				if(typeof(_selection) != "object" || _selection.value.charAt(0) != 's'){
					_APspecialty.val("");
					_APspecialty.blur();				
				}else{				
					_APspecialty.val(_selection.label.replace('&amp;','&'));
				}
			}
		});
	});
	$('.procedure-input').each(function(){
		var _APspecialty = $(this); 
		_APspecialty.autocomplete({
			source: procedureArray,
			open: function(event, ui){ 
				$(this).autocomplete("widget").removeClass("mini-autocomplete-scrolling");
				$(this).autocomplete("widget").addClass('mini-autocomplete');
				if($(this).autocomplete("widget").height() >= 300){
					$(this).autocomplete("widget").addClass("mini-autocomplete-scrolling");						
				}					
			},
			select: function(event, ui){			
				_APspecialty.val(ui.item.label);			
				return false;
			},
			focus: function(event, ui){
				_APspecialty.val(ui.item.label);
				return false;
			},
			change: function(event, ui){
				var _selection = specialtyProcedureSelections[_APspecialty.val().toUpperCase()];
				if(typeof(_selection) != "object" || _selection.value.charAt(0) != 'p'){
					if(_APspecialty.val() != ""){
						_APspecialty.val("");
						_APspecialty.blur();
					}		
				}else{				
					_APspecialty.val(_selection.label.replace('&amp;','&'));
				}
			}
		});
	});
	$('.ALList-box').dialog({
			autoOpen:false,
			draggable:false,
			resizable:false,
			modal:true,
			closeText:'',
			dialogClass:'compare-dialog',
			width:977,
			height:755,
			show:'fade',
			hide:'fade'
	});	
});

function EditContactInformation(){
	$("#form-page").val(2);
	$("#addListing").submit();
}

function EvaluateSpecialtiesAndProcedures(){
	var _selection = '';
	$('.specialty-input').each(function(){
		if ($(this).val() != ""){
			currentSelection = $(this).val().toUpperCase();
			if (currentSelection == 'ACUPUNCTURE')currentSelection = 'ACUPUNCTURE ';				
			_selection = specialtyProcedureSelections[currentSelection];
			if(typeof(_selection) == "object"){
				$("#"+$(this).attr("name")+"ID").val(_selection.value.replace("specialty-",""));
			}
		}
	});
	$('.procedure-input').each(function(){
		if ($(this).val() != ""){
			var _selection = specialtyProcedureSelections[$(this).val().toUpperCase()];
			if(typeof(_selection) == "object"){
				if(_selection.value.charAt(0) == 'p'){
					$("#"+$(this).attr("name")+"ID").val(_selection.value.replace("procedure-",""));
				}
			}
		}
	});
}

function SubmitInformation(){
	EvaluateSpecialtiesAndProcedures();
	$("#addListing").submit();
}

function ALListOpen(fieldTarget,forProcedure){
	$('.ALList-box').dialog('open');
	$('#AL-association-list').empty();
	$('#AL-association-list').append("<ul></ul>");
	var procCount = 0;
	if(forProcedure){
		var listInterval = Math.ceil(SWprocedureArray.length/3);
		for(i in procedureArray){
			$('#AL-association-list ul:last').append("<li><a href='#'>"+SWprocedureArray[i].label+"</a></li>");
			procCount++;
			if((procCount % listInterval == 0) && (procCount != SWprocedureArray.length))$('#AL-association-list').append("<ul></ul>");
		}
		$('#AL-association-list a').click(function(){
			$('#'+fieldTarget).val($(this).html());
			ALListClose();
			return false;
		});
	}else{
		var listInterval = Math.ceil(specialtyArray.length/3);
		for(i in SWspecialtyArray){
			$('#AL-association-list ul:last').append("<li><a href='#'>"+SWspecialtyArray[i].label+"</a></li>");
			procCount++;
			if((procCount % listInterval == 0) && (procCount != SWspecialtyArray.length))$('#AL-association-list').append("<ul></ul>");
		}
		$('#AL-association-list a').click(function(){
			$('#'+fieldTarget).val($(this).html());
			ALListClose();
			return false;
		});
	}
}
function ALListClose(){
	$('.ALList-box').dialog('close');						
}