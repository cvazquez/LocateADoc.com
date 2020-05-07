function profileChangeLocation(event,lid)
{
	event.preventDefault();
	$.post("/profile/setlocation/" + lid + "?format=json",{},function (response){
		if(response)
			location.replace(location.href.split("?")[0]);
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

$(function(){
	/*	
		If the main gallery nav is clicked, while on a profile with a gallery tab, 
		then prompt the user if they meant to leave the profile and if they rather view the profile's gallery
	*/
	$("#MainGalleryNav").click(function(event){
		
		if($(".before").length)
		{
			event.preventDefault();
			$('.gallerynavprompt-box').dialog('open');
		}
		
	});
	
	$('.gallerynavprompt-box').dialog({
		autoOpen:false,
		draggable:false,
		resizable:false,
		modal:true,
		closeText:'',
		dialogClass:'compare-dialog',
		width:640,
		height:480,
		show:'fade',
		hide:'fade',
		my:'center center',
		at:'center center',
		of:'body'
	});	
});



function GalleryNavPromptClose(){
$('.gallerynavprompt-box').dialog('close');						
}

/* Virtual Office Tour */
var tour_page = 1;
var tour_pagecount = 0;
$(function(){
	$('.tour-modal').dialog({
			autoOpen:false,
			draggable:false,
			resizable:false,
			modal:true,
			closeText:'',
			dialogClass:'compare-dialog',
			width:977,
			show:'fade',
			hide:'fade'
	});		
	tour_pagecount = $('.tour-stop').size();
	if(tour_pagecount == 0)$('#tour_link').hide();
	$('.tour-stop').hide();
	$('#tour_1').show();
	$('.tour-modal .nextbutton').click(function(){
		if(tour_page < tour_pagecount){
			$('#tour_' + tour_page).hide();
			tour_page++;
			$('#tour_' + tour_page).show();
			tourButtonDisplay();
		}
	});
	$('.tour-modal .backbutton').click(function(){
		if(tour_page > 1){
			$('#tour_' + tour_page).hide();
			tour_page--;
			$('#tour_' + tour_page).show();
			tourButtonDisplay();
		}
	});
	tourButtonDisplay();
});
function tourOpen(){
	$('.tour-modal').dialog('open');
	$('.ui-widget-overlay').addClass('modal-shade');							
}
function tourClose(){
	$('.tour-modal').dialog('close');						
}
function tourButtonDisplay(){
	if(tour_page >= tour_pagecount)
		$('.tour-modal .nextbutton').hide();
	else
		$('.tour-modal .nextbutton').show();
	if(tour_page <= 1)
		$('.tour-modal .backbutton').hide();
	else
		$('.tour-modal .backbutton').show();
}


/* More Procedures */
//open-close init
$(function(){
	initOpenClose();
});

//open-close plugin
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

