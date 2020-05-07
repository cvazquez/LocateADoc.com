$(function(){
	initShowMoreDescription();
	initOpenClose();
});

//This affects the body region and body part selection on the resources procedure comparison page.
//It hides body parts that don't belong in the selected body region.
$(function(){
	$('#bodyregion').change(function(){
		$('.body-part-selection').html('');
		if($('#bodyregion').attr('value') != ""){
			$('#body-part-selection-full option').each(function(){
				if($(this).attr('bodyRegion') == $('#bodyregion').attr('value') || $(this).attr('bodyRegion') == 0)
					$('.body-part-selection').append($(this).clone());
			});
		}else{
			$('.body-part-selection').append($('#body-part-selection-full option').clone());
		}
	});
	$("#compare-procedure-search").click(function(){
		$(".compare-list-holder").empty().html('<center><img src="/images/layout/loading.gif" /></center>');			
	    var searchValues = "&bodyRegion=" + document.bodyform.bodyRegion.value + "&bodyPart=" + document.bodyform.bodyPart.value;
	    if($('#specialty').length) searchValues += "&specialty=" + $('#specialty').attr('value');
	    if($('#listonly').length) searchValues += "&listonly=1";
	    $.ajax({
		    type: "POST",
		    url: "/resources/changeCompare?format=json" + searchValues,
		    dataType: "json",
		    success: function(response) {
		    	$(".compare-list-holder").html(response.content);
		    }
	    });
	    return false;
  });	
});

$(document).ready(function() {
	  $("a").each(function () { if(this.href.indexOf("#")>=0) $(this).attr("data-ajax",false); });
	});

function showSWbox(){
	var pos = $('.SWbutton').offset();
	// Hide mini form if exists
	if($('.mini-popup-box') && typeof profileMiniHide == "function")
		profileMiniHide();
	if($('.SW-popup-box').hasClass('hidden')){
		$('.SW-popup-box').removeClass('hidden');
		$('.SW-popup-box').offset({
			top: pos.top+20,
			left: pos.left-50
		});
		$('.SW-popup-box').addClass('hidden');
	}
	$('.SW-popup-box').slideDown();
}
function hideSWbox(){
	$('.SW-popup-box').removeClass('hidden');
	$('.SW-popup-box').slideUp();
}

function ChangePage(pagenum,maxpages){
	return AddFilter("page-" + ((parseInt(pagenum) > parseInt(maxpages)) ? maxpages : pagenum));
}

function SearchValidatePage(currentPage, pageNumberSubmitted, numberOfPages)
{
	var thisPat = /[^0-9]/g;

	return !(currentPage == pageNumberSubmitted || 
			pageNumberSubmitted > numberOfPages || 
			pageNumberSubmitted < 1 ||
			pageNumberSubmitted.match(thisPat) != null);
}

function AddFilterToURL(filter,filterURL)
{
	var debug = false;
	var filtername = filter.split("-")[0];
	if (filtername != "page") filterURL = filterURL.replace(/\/page-[0-9]+/,"");
	var filterRegEx = new RegExp(filtername + "-[^\/]+");

	if(filterURL.search(filterRegEx) >= 0)
		return filterURL.replace(filterRegEx,filter);
	else
		return filterURL + "/" + filter;
}

function AddFilter(newfilter)
{
	var filterURL = location.href.replace(/(#|\?).+/,"").replace(/\/$/,"");
	
	if(typeof siloedFilters != "undefined" && filterURL.search(siloedFilters) == -1)
	{
		filterURL = filterURL.replace(siloedNames,"") + siloedFilters;
		if(filterURL.indexOf("/doctors/search/") == -1)
			filterURL = filterURL.replace("/doctors/","/doctors/search/");
	}
	
	document.resultsForm.action = AddFilterToURL(newfilter,filterURL);
	document.resultsForm.submit();
	return false;
}

function initShowMoreDescription(){
	$(".show-more-desc").each(function(){
		$(this).click(function(){
			$($(this).attr("href")).slideDown("fast");
			$(this).parent().hide();
			return false;
		});
	});
	$(".show-more-expand").each(function(){
		$(this).click(function(){			
			$($(this).attr("href")).show();
			var fullHeight = $($(this).attr("href")).height();
			$($(this).attr("href")).height($(this).parent().outerHeight());
			$(this).parent().parent().hide();
			$($(this).attr("href")).animate({height:fullHeight+"px"},"fast");			
			return false;
		});
	});
}

//This function truncates the text within an element by removing just 
//enough text to make the element fit within the specified height.
function SmartTruncate(field,limit,width,nohover,ellipsis){
	if(!width)width=0;
	if(!ellipsis)ellipsis = "...";
	$('body').append('<div id="truncation"></div>');
	var truncBox = $('#truncation');
	var truncStyles = ["font-family","font-weight","font-size","line-height"];
	$(field).each(function(){
		for(var i in truncStyles){
			truncBox.css(truncStyles[i],$(this).css(truncStyles[i]));
		}
		truncBox.css("width",(width==0) ? $(this).css("width") : width+"px");
		var originalstring = $(this).html();
		if(!nohover)$(this).attr("title",originalstring.replace("&amp;","&"));
		truncBox.html(originalstring);
		if(truncBox.height() > limit){
			var upperbound = originalstring.length;
			var lowerbound = 0;
			var checkpoint = Math.floor((upperbound+lowerbound)/2);
			while((upperbound - lowerbound) > 1){
				truncBox.html(originalstring.substring(0,checkpoint)+ellipsis);
				if(truncBox.height() > limit)
					upperbound = checkpoint;
				else
					lowerbound = checkpoint;
				checkpoint = Math.floor((upperbound+lowerbound)/2);
			}
			$(this).html(originalstring.substring(0,lowerbound)+ellipsis);
		}
	});
	truncBox.remove();
}


//open-close init
function initOpenClose() {
	$('.slide-block').each(function(){
		var _this = $(this);
		_this.OpenClose({
			activeClass:'active',
			opener:'a.open-close',
			slider:'div.block',
			effect:'slide',
			slTo:true,
			animSpeed:500
		});
		_this.OpenClose({
			activeClass:'active',
			opener:'a.open-close',
			slider:'div.slide',
			effect:'slide',
			animSpeed:500
		});
	});
	
	$('.sub-slide-block').each(function(){
		var _this = $(this);
		_this.OpenClose({
			activeClass:'active',
			opener:'a.sub-open-close',
			slider:'div.sub-block',
			effect:'slide',
			slTo:true,
			animSpeed:500
		});
		_this.OpenClose({
			activeClass:'active',
			opener:'a.sub-open-close',
			slider:'div.sub-slide',
			effect:'slide',
			animSpeed:500
		});
	});
	
	jQuery('ul.procedures-list > .topProcedures > li, ul.procedures-list > .regProcedures > .block1 > li').OpenClose({
		activeClass:'active',
		opener:'a.open-close',
		slider:'div.block',
		effect:'slide',
		animSpeed:350
	});

	jQuery('.procedures-box').OpenClose({
		activeClass:'active',
		opener:'a.moreProcedures',
		slider:'div.block1',
		effect:'slide',
		animSpeed:350
	});

	$('a.moreProcedures')
		.click(function(){
			$(this).text($(this).text()=='<< Fewer Procedures'?'More Procedures >>':'<< Fewer Procedures')
		})
		.css("float","right");
		
	$('a.open-close')
		.click(function(event){
			event.preventDefault()
		});
}

// open-close plugin
jQuery.fn.OpenClose = function(_options){
	// default options
	var _options = jQuery.extend({
		activeClass:'active',
		opener:'.opener',
		slider:'.slide',
		animSpeed: 400,
		animStart:false,
		animEnd:false,
		effect:'fade',
		slTo:false,
		event:'click'
	},_options);

	return this.each(function(){
		// options
		var _holder = jQuery(this);
		var _slideSpeed = _options.animSpeed;
		var _activeClass = _options.activeClass;
		var _opener = jQuery(_options.opener, _holder);
		var _slider = jQuery(_options.slider, _holder);
		var _animStart = _options.animStart;
		var _animEnd = _options.animEnd;
		var _effect = _options.effect;
		var _event = _options.event;
		var _scroll = _options.slTo;

		if(_slider.length) {
			_opener.bind(_event,function(){
				if(!_slider.is(':animated')) {
					if(typeof _animStart === 'function') _animStart();
					if(_holder.hasClass(_activeClass)) {
						_slider[_effect=='fade' ? 'fadeOut' : 'slideUp'](_slideSpeed,function(){
							if(typeof _animEnd === 'function') _animEnd();
						});
						_holder.removeClass(_activeClass);
					} else {
						_holder.addClass(_activeClass);
						_slider[_effect=='fade' ? 'fadeIn' : 'slideDown'](_slideSpeed,function(){
							if(typeof _animEnd === 'function') _animEnd();
						});
						if(_scroll) scrollTo(_slideSpeed);
					}
				}
				return false;
			});
			if(_holder.hasClass(_activeClass)) _slider.show();
			else _slider.hide();
		}
		function scrollTo(change_speed){
			var _top = _holder.offset().top;
			if(!$.browser.opera){
				$('body').animate({scrollTop: _top }, {queue:false, easing:'swing', duration:change_speed});
			}
			$('html').animate({scrollTop: _top }, {queue:false,easing:'swing', duration:change_speed});
		}
	});
}