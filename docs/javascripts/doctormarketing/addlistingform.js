$(function(){

	if (!Array.prototype.indexOf) {
		Array.prototype.indexOf = function(obj, start) {
		     for (var i = (start || 0), j = this.length; i < j; i++) {
		         if (this[i] === obj) { return i; }
		     }
		     return -1;
		}
	}
	
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
				//if (currentSelection == 'ACUPUNCTURE')currentSelection = 'ACUPUNCTURE ';
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
			source: //procedureArray,
				function( request, response ) 
				{
					//If a specialty is selected, only return matches for the specialty's procedures. 
					//A new array with the specialties procedures will be created
					//console.dir(request.term);
					
					// Pull the number of the field's id this procedure is in (not the procedure's id). Ex. procedure-1 return 1
					var procedureFieldId = $(this)[0].element[0].id;
					var procedureFieldIdNum = procedureFieldId.split("-")[1];
					var specialtyName = document.getElementById("specialty-" + procedureFieldIdNum).value;
					var mySpecialtyIds;
					var specialtyId;
					var specialtyProcedureArry = [];
					
					// Find the specialty id of the selected specialty
					for(i in SWspecialtyArray)
					{
						if(SWspecialtyArray[i].label == specialtyName)
						{
							specialtyId = SWspecialtyArray[i].value.split("-")[1];							
							break;
						}				
					}
					
					//Create a new array with only the procedures for this specialty id					
					 for(i in procedureArray)
		        	 {	
		        		// This procedures specialty ids 
			  			mySpecialtyIds = SWprocedureArray[i].specialtyIds;
			  			if(mySpecialtyIds)
			  			{
			  				if(mySpecialtyIds.indexOf(specialtyId) >= 0)
			  				{
			  					specialtyProcedureArry[i] = procedureArray[i].replace('&amp;','&');
			  				}
			  			}
			  			
		        	 }					
				
		          var matcher = new RegExp( $.ui.autocomplete.escapeRegex( request.term ), "i" );
		          
		          if(specialtyProcedureArry)
		          {
		        	  theResponse = $.grep( specialtyProcedureArry, function( item ){return matcher.test( item );}) 
		        	  
		        	  //console.dir(theResponse);
		        	  
		        	  
		        	  if(theResponse[0]) response( theResponse	);
		          }
				},
				
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
	$('.iprocedure-input').each(function(){
		var _APspecialty = $(this); 
		_APspecialty.autocomplete({
			source: //procedureArray,
				function( request, response ) 
				{
					//If a specialty is selected, only return matches for the specialty's procedures. 
					//A new array with the specialties procedures will be created
					//console.dir(request.term);
					
					// Pull the number of the field's id this procedure is in (not the procedure's id). Ex. procedure-1 return 1
					var procedureFieldId = $(this)[0].element[0].id;
					var procedureFieldIdNum = procedureFieldId.split("-")[1];
					var specialtyName = document.getElementById("ispecialty").value;
					var mySpecialtyIds;
					var specialtyId;
					var specialtyProcedureArry = [];
					
					// Find the specialty id of the selected specialty
					for(i in SWspecialtyArray)
					{
						if(SWspecialtyArray[i].label == specialtyName)
						{
							specialtyId = SWspecialtyArray[i].value.split("-")[1];							
							break;
						}				
					}
					
					//Create a new array with only the procedures for this specialty id					
					 for(i in procedureArray)
		        	 {	
		        		// This procedures specialty ids 
			  			mySpecialtyIds = SWprocedureArray[i].specialtyIds;
			  			if(mySpecialtyIds)
			  			{
			  				if(mySpecialtyIds.indexOf(specialtyId) >= 0)
			  				{
			  					specialtyProcedureArry[i] = procedureArray[i].replace('&amp;','&');
			  				}
			  			}
			  			
		        	 }					
				
		          var matcher = new RegExp( $.ui.autocomplete.escapeRegex( request.term ), "i" );
		          
		          if(specialtyProcedureArry)
		          {
		        	  theResponse = $.grep( specialtyProcedureArry, function( item ){return matcher.test( item );}) 
		        	  
		        	  //console.dir(theResponse);
		        	  
		        	  
		        	  if(theResponse[0]) response( theResponse	);
		          }
				},
				
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
			height:1755,
			show:'fade',
			hide:'fade'
	});
	
	
	// Check if the password passes my requirements.
	/*var passwordElem = document.getElementById("passwordA");
	passwordElem.addEventListener("blur", CheckPassword, true);

	function CheckPassword(){
		
		var password = document.getElementById('passwordA').value;
		
		if ((password.length) >= 8 && (/[a-zA-Z]+/).test(password) && (/[0-9]+/).test(password) && (/\W/).test(password) ) {
			alert("Correct");
			return true;
		}
		else
		{
			alert("Wrong");
			return false;
		}	
		
	};*/
	
	// Check if the password passes my requirements.
	
	
	if (document.getElementById('passwordA')){
		
		document.getElementById('passwordA').onblur = function(){
			
			var password = document.getElementById('passwordA').value;
			
			if ((password.length) >= 8 && (/[a-zA-Z]+/).test(password) && (/[0-9]+/).test(password) && (/\W/).test(password) ) {
				//alert("Correct");
				return true;
			}
			else
			{
				alert("To ensure proper security of you account, make passwords 8 or more characters long, include at least 1 number, 1 letter and 1 punctuation mark. For best results, think of a meaningless sentence that means something to only you, and use the first letter of each word.");
				return false;
			}	
		};
		
		document.getElementById('passwordB').onblur = ComparePasswords;
		document.getElementById('addListing').submit = ComparePasswords;
		
	}
	
		
	function ComparePasswords(){
		
		var passwordA = document.getElementById('passwordA').value;
		var passwordB = document.getElementById('passwordB').value;
		
		//alert("comparepasswors");
		
		if ( passwordA != passwordB ) {
			alert("Both passwords do not match. Please try again.");
			return false;
		}	
	};
	
	
	$('#termsAndConditionsDialog').dialog({
		autoOpen:false,
		draggable:false,
		resizable:true,
		modal:true,
		closeText:'Close',
		dialogClass:'compare-dialog',
		width:977,
		height:480,
		show:'fade',
		hide:'fade',
		scrollable:true,
		closeOnEscape:true
});
	
	if( (typeof document.getElementById("ccTermsAndConditions") != undefined) && (document.getElementById("ccTermsAndConditions") != null)){
		document.getElementById("ccTermsAndConditions").addEventListener("click", function(){
			$('#termsAndConditionsDialog').dialog('open');
			
		});
	}
	
	if( (typeof document.getElementById("termsAndConditionsAgreed") != undefined) && (document.getElementById("termsAndConditionsAgreed") != null)){
		document.getElementById("termsAndConditionsAgreed").addEventListener("click", function(){
			
			$(".checkboxArea").addClass("checkboxAreaChecked");
			$(".checkboxAreaChecked").removeClass("checkboxArea");
	
			document.getElementById("termsAndConditions").setAttribute("checked", "checked");
			
			$('#termsAndConditionsDialog').dialog('close');
		});
	}
	
	if( (typeof document.getElementById("termsAndConditionsDisAgreed") != undefined) && (document.getElementById("termsAndConditionsDisAgreed") != null)){
		document.getElementById("termsAndConditionsDisAgreed").addEventListener("click", function(){
			
			$(".checkboxAreaChecked").addClass("checkboxArea");
			$(".checkboxArea").removeClass("checkboxAreaChecked");
			
			document.getElementById("termsAndConditions").removeAttribute("checked");
			
			$('#termsAndConditionsDialog').dialog('close');
		});
	}
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
			
			//console.log($(this).val());			
			$(this).val($(this).val().replace("&amp;", "&"));
			//console.log($(this).val());
			
			var _selection = specialtyProcedureSelections[$(this).val().toUpperCase()];
			//console.log(_selection);
			
			if(typeof(_selection) == "object"){
				if(_selection.value.charAt(0) == 'p'){
					$("#"+$(this).attr("name")+"ID").val(_selection.value.replace("procedure-",""));
					//console.log(_selection.value.replace("procedure-",""));
				}
			}
		}
	});
	
	$('.iprocedure-input').each(function(){
		if ($(this).val() != ""){
			
			$(this).val($(this).val().replace("&amp;", "&"));
			
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
	
	//console.log("hello");
	
	EvaluateSpecialtiesAndProcedures();
	
		// Check for duplicate listings
		/*
		$('.duplicateAccountCheck').dialog({
				autoOpen:false,
				draggable:false,
				resizable:false,
				modal:true,
				closeText:'',
				dialogClass:'compare-dialog',
				width:800,
				height:600,
				show:'fade',
				hide:'fade',
				my:'center center',
				at:'center center',
				of:'body'
		});   
		*/
		
		
		// Check if this email address or phone number already exists
		$.ajax({ 
		    type: "POST", 
		    url: "/doctor-marketing/addlistingcheckduplicate", // https://www.locateadoc.com
		    data: 	{
		    			email: document.getElementById("doctorEmail").value
		    		},
		    dataType: "HTML",
		    success: function(response) { 
		    	
		    	if(response == "")
		    	{
		    		$("#addListing").submit();
		    	}
		    	else
		    	{	
		    		//console.log(response);
		    		$('.ALList-box').dialog('open');
		    		$('#AL-association-list').html(response);

		    		return false;
		    	}      	
		    	
		    }
		});

}

function SubmitInformation2(){
	
	//console.log("hello");	
	//alert("hello11");
	EvaluateSpecialtiesAndProcedures();
	//alert("hello2");
	//return false;
}

function SubmitCCInformation(){
	  var 	billingRE = {};
	  		billingRE.ccNumber = /^[0-9]{12,19}$/;
	  		billingRE.ccExp = /^[0-9]{4}$/;
	  		billingRE.ccCVV = /^[0-9]{3,4}$/;
	  		billingRE.errors = '';

	  
	  if(!billingRE.ccNumber.test($("#billing-cc-number").val())){
		  billingRE.errors += "<li>Invalid Credit Card Number</li>";   
	  }
	  
	  if(!billingRE.ccExp.test($("#billing-cc-exp").val())){
		  billingRE.errors += "<li>Invalid Credit Card Expiration Number</li>"; 		  
	  }
	  
	  if(!billingRE.ccCVV.test($("#billing-cvv").val())){
		  billingRE.errors += "<li>Invalid Credit Card CVV Number</li>"; 		  
	  }
	  
	  if($("#billing-first-name").val().trim() == ''){
		  billingRE.errors += "<li>Missing First Name</li>"; 		  
	  }
	  
	  if($("#billing-last-name").val().trim() == ''){
		  billingRE.errors += "<li>Missing Last Name</li>"; 		  
	  }
	  
	  if(billingRE.errors.trim() != ''){
		  $("#validation-client").html("<p><b>Please correct the following information:</b></p><ul>" + billingRE.errors + "</ul>").show();
		  return false;
	  } else {
		  return true;
		  $( "#doctorMarketingBillingCCForm" ).submit();
	  }
		  
	// // This won't work because of cross HTTP security - Validate
	/*
	$.ajax({ 
	    type: "POST", 
	    url: url,
	    data: 	$form.serialize(),
	    success: function(response) { 
	    },
	    error: function(jqXHR, textStatus, errorThrown){
	    	console.log(jqXHR);
	    }
	});
	*/
}

function CheckDuplicateClose(){
	// Overlay close button called
		$('.prompt-box').dialog('close');						
	}

function ALListOpen(fieldTarget,forProcedure){
	$('.ALList-box').dialog('open');
	$('#AL-association-list').empty();
	$('#AL-association-list').append("<ul></ul>");
	var procCount = 0;
	if(forProcedure){
		
		var procedureListLength = SWprocedureArray.length;
		var specialtyId = 0;
		var mySpecialtyIds;
		var ifExists;
		var listInterval;
		
		// Pull the number of the field's id this procedure is in (not the procedure's id). Ex. procedure-1 return 1
		var procedureFieldId = fieldTarget.split("-")[1];
		
		// Get the Specialty Name of the current field
		var specialtyName = document.getElementById("specialty-" + procedureFieldId).value;
		
		
		// Find the specialty id of the selected specialty
		for(i in SWspecialtyArray)
		{
			if(SWspecialtyArray[i].label == specialtyName)
			{
				specialtyId = SWspecialtyArray[i].value.split("-")[1];
				break;
			}				
		}
		
		
		// If a specialty was entered next to the procedure, then calculate the number of the Specialties procedures
		if(specialtyId > 0)
		{
			procedureListLength = 0;
			
			for(i in procedureArray)
			{
				mySpecialtyIds = SWprocedureArray[i].specialtyIds;
				
				if(mySpecialtyIds)
				{
					ifExists = mySpecialtyIds.indexOf(specialtyId);
					
					if(ifExists >= 0)
					{
						procedureListLength++;
					}				
				}
			}
		}
		
		// Use the Procedure count to calculate the number of procedures to display in each of 3 columns
		listInterval = Math.ceil(procedureListLength/3);
		
		
		// Loop through all procedures
		for(i in procedureArray)
		{			
			
			// Get the specialty ids for this procedure
			mySpecialtyIds = SWprocedureArray[i].specialtyIds;
			
			// If a specialty was selected next to this procedure field, then only display that Specialties procedure. Otherwise display all procedures
			if(mySpecialtyIds && specialtyId > 0)
			{
				ifExists = mySpecialtyIds.indexOf(specialtyId);
			}
			else
			{
				ifExists = 1
			}
			
		
			// If the procedure exists for this specialty, or we are just displaying the procedure because no specialty was selected
			if(ifExists >= 0)
			{
				$('#AL-association-list ul:last').append("<li><a href='#'>"+SWprocedureArray[i].label+"</a></li>");
				procCount++;
				if((procCount % listInterval == 0) && (procCount != procedureListLength))$('#AL-association-list').append("<ul></ul>");
			}
		}
		$('#AL-association-list a').click(function(){
			$('#'+fieldTarget).val($(this).html());
			ALListClose();
			return false;
		});
	}else{
		var listInterval = Math.ceil(specialtyArray.length/3);
		for(i in SWspecialtyArray)
		{
			$('#AL-association-list ul:last').append("<li><a href='#'>"+SWspecialtyArray[i].label+"</a></li>");
			procCount++;
			if((procCount % listInterval == 0) && (procCount != SWspecialtyArray.length))$('#AL-association-list').append("<ul></ul>");
		}
		$('#AL-association-list a').click(function(){
			
			// The Name of the Specialty Clicked On
			var specialtyName = $(this).html();
			var specialtyId;
			
		
			// Find the specialty id of the selected specialty
			for(i in SWspecialtyArray)
			{
				if(SWspecialtyArray[i].label == specialtyName)
				{
					specialtyId = SWspecialtyArray[i].value.split("-")[1];
					break;
				}				
			}			
			
			// Get the incremental id of the specialty's input field
			specialtyFieldIdNum = $('#'+fieldTarget).attr("id").split("-")[1];

			// Set the hidden field storing the specialty's id
			$('#specialty' + specialtyFieldIdNum + 'ID').val(specialtyId); 
			
			// Set the value of the specialties Input field 
			$('#'+fieldTarget).val($(this).html());
			ALListClose();
			return false;
		});
	}
}
function ALListClose(){
	$('.ALList-box').dialog('close');						
}

function iALListOpen(fieldTarget,forProcedure){
	$('.ALList-box').dialog('open');
	$('#AL-association-list').empty();
	$('#AL-association-list').append("<ul></ul>");
	var procCount = 0;
	if(forProcedure){
		
		var procedureListLength = SWprocedureArray.length;
		var specialtyId = 0;
		var mySpecialtyIds;
		var ifExists;
		var listInterval;
		
		// Pull the number of the field's id this procedure is in (not the procedure's id). Ex. procedure-1 return 1
		var procedureFieldId = fieldTarget.split("-")[1];
		
		// Get the Specialty Name of the current field
		var specialtyName = document.getElementById("ispecialty").value;
		
		
		// Find the specialty id of the selected specialty
		for(i in SWspecialtyArray)
		{
			if(SWspecialtyArray[i].label == specialtyName)
			{
				specialtyId = SWspecialtyArray[i].value.split("-")[1];
				break;
			}				
		}
		
		
		// If a specialty was entered next to the procedure, then calculate the number of the Specialties procedures
		if(specialtyId > 0)
		{
			procedureListLength = 0;
			
			for(i in procedureArray)
			{
				mySpecialtyIds = SWprocedureArray[i].specialtyIds;
				
				if(mySpecialtyIds)
				{
					ifExists = mySpecialtyIds.indexOf(specialtyId);
					
					if(ifExists >= 0)
					{
						procedureListLength++;
					}				
				}
			}
		}
		
		// Use the Procedure count to calculate the number of procedures to display in each of 3 columns
		listInterval = Math.ceil(procedureListLength/3);
		
		
		// Loop through all procedures
		for(i in procedureArray)
		{			
			
			// Get the specialty ids for this procedure
			mySpecialtyIds = SWprocedureArray[i].specialtyIds;
			
			// If a specialty was selected next to this procedure field, then only display that Specialties procedure. Otherwise display all procedures
			if(mySpecialtyIds && specialtyId > 0)
			{
				ifExists = mySpecialtyIds.indexOf(specialtyId);
			}
			else
			{
				ifExists = 1
			}
			
		
			// If the procedure exists for this specialty, or we are just displaying the procedure because no specialty was selected
			if(ifExists >= 0)
			{
				$('#AL-association-list ul:last').append("<li><a href='#'>"+SWprocedureArray[i].label+"</a></li>");
				procCount++;
				if((procCount % listInterval == 0) && (procCount != procedureListLength))$('#AL-association-list').append("<ul></ul>");
			}
		}
		$('#AL-association-list a').click(function(){
			$('#'+fieldTarget).val($(this).html());
			ALListClose();
			return false;
		});
	}else{
		var listInterval = Math.ceil(specialtyArray.length/3);
		for(i in SWspecialtyArray)
		{
			$('#AL-association-list ul:last').append("<li><a href='#'>"+SWspecialtyArray[i].label+"</a></li>");
			procCount++;
			if((procCount % listInterval == 0) && (procCount != SWspecialtyArray.length))$('#AL-association-list').append("<ul></ul>");
		}
		$('#AL-association-list a').click(function(){
			
			// The Name of the Specialty Clicked On
			var specialtyName = $(this).html();
			var specialtyId;
			
		
			// Find the specialty id of the selected specialty
			for(i in SWspecialtyArray)
			{
				if(SWspecialtyArray[i].label == specialtyName)
				{
					specialtyId = SWspecialtyArray[i].value.split("-")[1];
					break;
				}				
			}			
			
			// Set the hidden field storing the specialty's id
			$('#specialtyID').val(specialtyId); 
			
			// Set the value of the specialties Input field 
			$('#'+fieldTarget).val($(this).html());
			ALListClose();
			return false;
		});
	}
}