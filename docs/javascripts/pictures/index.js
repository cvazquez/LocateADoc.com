var allProcedures = [];
$(function(){
	var latestTick = 0
	$("#city,#city2").autocomplete({
		minLength: 1,
    	source: function(req, add){
			$.getJSON("/doctors/location?format=json&callback=?", req, function(data) {
				if (data.TICK > latestTick){
					latestTick = data.TICK
	            	var suggestions = []
	                $.each(data.CONTENT, function(i, val){
	                	suggestions.push(val)
	            	})
	        		add(suggestions)
        		}
     		})
     	}
	})
	$(".procedures .scrollable .list li a").each(function(){
		allProcedures.push({
			value		: $(this).html().replace('&amp;','&'),
			label		: $(this).html().replace('&amp;','&'),
			procedureId	: $(this).attr("class").replace('ui-link', '')
		});
	});
	$("#typeProcedure").autocomplete({
		minLength	: 2,
		source		: allProcedures,
		open: function(event, ui) { 			
			$(this).autocomplete("widget").addClass('small-autocomplete-scrolling');
		},
		select		: function(e,ui) {
			window.location = $("."+ui.item.procedureId).attr('href');
			//$("."+ui.item.procedureId).click();
		}
	})	
	$("#doctorlastname").autocomplete({ 
		minLength	: 2, 
    	source		: function(req,add) {
				$.getJSON("/miscellaneous/gallerycasedoctornames.cfm",req,function(response) {
					var cols = response.COLUMNS
					var data = response.DATA
					var doctornames = []
					for (var i in data) {
						doctornames.push({
							value		: data[i][2]+" "+data[i][3]+(data[i][1].length!=0?", "+data[i][1]:""),
							label		: data[i][2]+" "+data[i][3]+(data[i][1].length!=0?", "+data[i][1]:""),
							doctorId	: data[i][0]
						})
					}
					add(doctornames)
				})
     		},
		select		: function(e,ui) {
			location.href = "/pictures/search/doctor-"+ui.item.doctorId
		}
	})
	// User clicks 'Search' button on the DOCTOR search tab
	$("button#doctorsearch")
		.click(function(){
			var searchurl = gallerybase+"/search"
			var filtercount = 0
			$("div#tab2 select, div#tab2 input[type=text]").each(function(){
				if ($(this).val().length != 0 && $(this).attr("name") != "doctorlastname" && $(this).attr("name") != "country" && $(this).attr("name")) {
					searchurl += "/"+$(this).attr("name")+"-"+$(this).val().replace("-","_")
																			.replace("  "," ")
																			.replace("  "," ")
																			.replace("  "," ")
																			.replace(" ","_")
																			.replace(" ","_")
																			.replace(" ","_")
					filtercount++
				}
			})
			if (filtercount != 0) location.href = searchurl
		})
	
	// User clicks 'Search' button on the ADVANCED search tab
	$("button#advancedsearch")
		.click(function(){
			var searchurl = gallerybase+"/search"
			var filtercount = 0
			$("div#tab4 select,div#tab4 #city2")
				.each(function(){
					if ($(this).val().length != 0) {
						searchurl += "/"+$(this).attr("name")+"-"+$(this).val().replace("-","_").replace(" ","_")
						filtercount++
					}
				})
			if (filtercount != 0) location.href = searchurl
		})
			
		
	// These are all the first-letters represented in the list of procedures
	var letters = {}
	$("div.procedures a").each(function(){
		letters[$(this).text().charAt(0)] = 0
	})
	
	// Use that list to determine which letters to remove from the nav
	$("ul#alphabet li").each(function(){
		if (typeof letters[$(this).text()] == "undefined") $(this).remove()
	})
	$("#tab1,#tab2,#tab3,#tab4")
		.css("visibility","visible")
});

function ProcedureMatch(){
	var _matches = $('.procedures .list li a[label="'+$('#typeProcedure').val().toUpperCase()+'"]');
	if(_matches.length)window.location = _matches.attr('href');
}

$(function(){
	/*var latestTick = 0
	$("#city")
		.autocomplete({ 
			minLength: 1,
    		source: function(req, add){
				$.getJSON("/doctors/location?format=json&callback=?", req, function(data) {
					if (data.TICK > latestTick){
						latestTick = data.TICK
	        	    	var suggestions = []
	                	$.each(data.CONTENT, function(i, val){
	                		suggestions.push(val)
	                	})
	                	add(suggestions)
	                }
				})
			}
		})*/
	$("#country")
		.change(function(){
			if (this.value == 'CA') {
				if ($("#city").val() == "City, State or Zip")
					$("#city")
						.val("City, Province or Postal Code")
				$("#citylabel")
					.html("City, Province, Postal Code")
			} else {
				if ($("#city").val() == "City, Province or Postal Code")
					$("#city")
						.val("City, State or Zip")
				$("#citylabel")
					.html("City, State, Zip")
			}
		})
	
	/*$("#city")
		.keyup(function(event) {
			formListener(event,function(){
				$("button#doctorsearch").click()
			})
		})*/
})


