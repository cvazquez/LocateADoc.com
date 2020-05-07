String.prototype.trim = function() { return this.replace(/^\s+|\s+$/g, ''); };

function SelectSpecialty(){
	var _ProcedureInput = $(".search-bar .procedure-input");
	var _ProcedureOutput = $(".search-bar .procedure-output");
	var _selection = specialtyProcedureSelections[_ProcedureInput.val().toUpperCase()];
	if(typeof(_selection) != "object"){
		_ProcedureInput.val("");
		_ProcedureOutput.val("");			
	}else{
		_ProcedureOutput.val(_selection.value);
		_ProcedureInput.val(_selection.label.replace('&amp;','&'));
	}
}

function DelaySubmit(){
	$(".search-bar .procedure-input").blur();
	var t = setTimeout ( "SubmitSearch()", 50 ); 
}

function SubmitSearch(explicitFilter){
	var strURL = "";
	var strValue = "";
	var frmSearch = document.doctorsearch.elements;
	//If the user clicked on a procedure or specialty link, add its filter to the URL string
	if(explicitFilter)strURL = "/" + explicitFilter;
	//Inspect all form elements for complete data, and add the filters to the URL string
	for(var i = 0; i < frmSearch.length; i++){		
		if (frmSearch[i].name&&frmSearch[i].value){
			switch(frmSearch[i].name){
				//City, State, or Zip
				case "location":
					strValue = frmSearch[i].value.trim().replace(/\s/g,'_');
					if ((strValue != "City,_State_or_Zip")&&(strValue != "City,_Province_or_Postal_Code")&&(strValue != ""))
						strURL += "/location-" + escape(strValue);
					break;
				//Doctor Name
				case "name":
					strValue = frmSearch[i].value.trim().replace(/\s/g,'_');
					if ((strValue != "Enter_Name_Here")&&(strValue != ""))
						strURL += "/name-" + escape(strValue);
					break;
				//Hybrid procedure or specialty selection
				case "procedureorspecialty":								
					strValue = frmSearch[i].value.trim();
					if (strValue != "")	strURL += "/" + strValue;
					break;
				case "country": 
					strValue = frmSearch[i].value.trim();
					if (strValue != "")	strURL += "/country-" + strValue;	
					break;
				//Others
				default:
					strValue = frmSearch[i].value.trim();
					if (strValue != "")	strURL += "/" + frmSearch[i].name + "-" + strValue;				
			}		
		}
	}
	//Perform search
	if(strURL != ""){
		locationStr = location.href.split("/")[0]+'//'+location.href.split("/")[2]+'/doctors/search' + strURL + '/';
		window.location = locationStr.toLowerCase();
	}else
		alert("At least one complete field is required to perform a search.");
}

function AdvancedSearch(){
	document.doctorsearch.action = "/doctors";
	document.doctorsearch.submit();
}

function ProceduresLink(){
	$('#tab1').hide();
	$('#tab1link').removeClass('active');
	$('#tab2').show();
	$('#tab2link').addClass('active');
}

function SpecialtiesLink(){
	$('#tab1').hide();
	$('#tab1link').removeClass('active');
	$('#tab3').show();
	$('#tab3link').addClass('active');
}

var allProcedures = [];
$(function(){
	var latestTick = 0;
	$("#city").autocomplete({ 
		create: function(event, ui) {
			if($("#city").hasClass('big-autocomplete')){
				$(this).autocomplete("widget").addClass('big-autocomplete');
			}
		},
		minLength: 1, 
    	source: function(req, add){
			$.getJSON("/doctors/location?format=json&country="+$('#country').val()+"&callback=?", req, function(data) {
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
	$("#name").autocomplete({ 
		minLength: 2, 
    	source: function(req, add){
			$.getJSON("/doctors/names?format=json&callback=?", req, function(data) {
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
	
	$("#country").change(function(){
		if(this.value == 'CA'){			
			//if($("#city").val() == "City, State or Zip"){
			//	$("#city").val("City, Province or Postal Code");
			//}
			$("#city").parent().children(".preText").html("City, Province, Postal Code");
			$("#citylabel").html("City, Province, Postal Code");
		}else{			
			//if($("#city").val() == "City, Province or Postal Code"){
			//	$("#city").val("City, State or Zip");
			//}
			$("#city").parent().children(".preText").html("City, State, Zip");
			$("#citylabel").html("City, State, Zip");
		}
	});
	
	$(".procedures .scrollable .list li a").each(function(){
		allProcedures.push({
			value		: $(this).html().replace('&amp;','&'),
			label		: $(this).html().replace('&amp;','&'),
			procedureId	: $(this).attr("class")
		});
	});
	var _ProcedureEntry = $("#typeProcedure");
	_ProcedureEntry.autocomplete({
		minLength	: 2,
		source		: allProcedures,
		open: function(event, ui) { 			
			$(this).autocomplete("widget").addClass('small-autocomplete-scrolling');
		},
		select		: function(e,ui) {
			window.location = $("."+ui.item.procedureId).attr('href');
			//$("."+ui.item.procedureId).click();
		}
	});
});
function ProcedureMatch(){
	var _matches = $('.procedures .list li a[label="'+$('#typeProcedure').val().toUpperCase()+'"]');
	if(_matches.length)window.location = _matches.attr('href');
}