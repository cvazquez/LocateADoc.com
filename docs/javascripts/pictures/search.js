var FR
$(function(){
	// Results filtering
	FR = new filterResults({
		url			: gallerybase+"/filterresults",
		action		: "search",
		returns		: "json",
		div			: "#filters_content, #searchterm_content, #searchresults_content, #featureddoctor_content",
		opacity		: "0",
		click		: "a[filter]",
		change		: "select#distance2, input[name=page]",
		callback	: searchInit
	})
	
	// On load, check the URL for hash values and reform the URL
	//FR.reformURL()
	
	searchInit();
	
	var testcontent = "<h1>Title H1</h1>"
	testcontent += "<b>Here is some bold text</b><br>"
	testcontent += "<p>And here is some regular text<br>"
	testcontent += "<a href='#'>here's a link?</a>"
	testcontent += "<br>Some more text</p>"
})

function cityUpdate(){
	var thisval = $("input#city").val()
	$("[filter=location]").attr("value",thisval);
	return false;
}

function searchInit() {
	$('.setup-complete').remove();
	
	$("a.link-back")
		.click(function(event){
			event.preventDefault();
			history.back();
		});
	
	$("input#city").change(function(e){cityUpdate();});
		
	$("form#cityform").submit(function(){
		cityUpdate();
		$("[filter=location]").click();
		return false;
	});
		
	$("input#distance")
		.change(function(e){
			var thisval = $(this).val();
			$("#submit-distance").attr("value",thisval);
		})
		.keyup(function(event) {
			formListener(event,function(){
				$("#submit-distance").click();
			})
		});
	
	initOpenClose()
	initGallery()
	
	$('select').customSelect();
	
	$("a.distance").click(function(){
		$('select').customSelect()
	})
/*		
	$("#removeallfilters")
		.click(function(event){
			$("<div/>")
				.attr("id","pleasewait")
				.css("text-align","center")
				.html("<p>filtering your results...</p><img src='/images/layout/loading.gif' /></div>")
				.appendTo("body")
				.dialog({
					title			: "Please wait",
					modal			: true,
					resizable		: false,
					draggable		: false,
					closeOnEscape	: false
				})
		})
*/
	/*
	$("input[name=lastname]")
		.change(function(){
			$("a[filter=lastname]").attr("value",$(this).val())
		});
	
	$("input[name=procedure]")
		.change(function(){
			$("a[filter=procedure]").attr("value",$(this).val())
		});*/
		
	var latestTick = 0
	$("#city").autocomplete({
		create: function(event, ui) {$(this).autocomplete("widget").addClass('square-autocomplete');},
		minLength	: 2,
    	source		: function(req,add){
			$.getJSON("/doctors/location?format=json&callback=?", req, function(data) {
				if (data.TICK > latestTick){
					latestTick = data.TICK
	            	var suggestions = []
	                $.each(data.CONTENT,function(i,val){
	                	suggestions.push(val)
	            	})
	        		add(suggestions)
        		}
     		})
     	},
		select		: function(e,ui) {
			var filterURL = location.href.split("?")[0].replace("#","");
			if(filterURL.indexOf("/pictures/search/") == -1)
				filterURL = filterURL.replace("/pictures/","/pictures/search/");
			if(typeof siloedFilters != "undefined" && filterURL.search(siloedFilters) == -1)
				filterURL = filterURL.replace(siloedNames,"") + siloedFilters;
			filterURL = filterURL + "/location-"+ui.item.value;
			location.href = filterURL;
		}
	})
	
	$("#procedurename").autocomplete({
		create: function(event, ui) {$(this).autocomplete("widget").addClass('square-autocomplete');},
		minLength	: 2,
		source		: allProcedures,
		select		: function(e,ui) {
			var filterURL = location.href.split("?")[0].replace("#","");
			if(filterURL.indexOf("/pictures/search/") == -1)
				filterURL = filterURL.replace("/pictures/","/pictures/search/");
			if(typeof siloedFilters != "undefined" && filterURL.search(siloedFilters) == -1)
				filterURL = filterURL.replace(siloedNames,"") + siloedFilters;
			filterURL = filterURL + "/procedure-"+ui.item.procedureId;
			location.href = filterURL;

			//location.hash += "/procedure-"+ui.item.procedureId
		}
	})
	
	doctorArray = [];
	$("#doctor-box ul li a").each(function(){
		doctorArray.push({label:$(this).html().replace("&amp;","&"),value:$(this).html().replace("&amp;","&"),href:/*$(this).attr('href'),doctorId:*/$(this).attr('doctor')});
	});
	$("#doctorlastname").autocomplete({ 
		create: function(event, ui) {$(this).autocomplete("widget").addClass('square-autocomplete');},
		minLength	: 2, 
    	source		: doctorArray,/*function(req,add) {
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
     		},*/
		select		: function(e,ui) {
			var filterURL = location.href.split("?")[0].replace("#","");
			if(filterURL.indexOf("/pictures/search/") == -1)
				filterURL = filterURL.replace("/pictures/","/pictures/search/");
			if(typeof siloedFilters != "undefined" && filterURL.search(siloedFilters) == -1)
				filterURL = filterURL.replace(siloedNames,"") + siloedFilters;
			filterURL = filterURL + "/" + ui.item.href;
			location.href = filterURL;
			/*location.href += "/"+ui.item.href;*/

			//location.hash += "/doctor-"+ui.item.doctorId
		}
	})
	
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