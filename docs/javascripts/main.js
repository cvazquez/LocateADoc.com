var addthis_config = {
	services_exclude: 'print,email',
	ui_click: true
};




$(function(){
	ieHover("div.bodypart-tab div.box", "hover");
	initSort();
	initScroll();
	initCustomForms();
	initClearFormFields();
	initGallery();
	initSlideShow();
	initTabs();
	initOpenClose();
	initSelect();
	eqHeights('.home-frame');
	initAutosubmit();
	initStateLinks();
	initShowMore();
	initShowMoreDescription();
	unHide();
	initTooltips();
	
	
	$("#DoctorsOnlyNavButton").click(function()
	{
		window.document.location = "/doctor-marketing/add-listing";			
	});
	
});

$(function() {
	  
    $("#ContentIntroShowMore").click(function(){
		$(".ContentIntro").show();
		$("#ContentIntroShowMore").hide();
	});
  
  });

function DoctorsOnlyNavButton()
{
	window.document.location = "/doctor-marketing/add-listing";	
}


function initAutosubmit(){
	$('.search-form').each(function(){
		var _form = $(this);
		var _sel = $('select', _form);
		_sel.change(function(){_form.trigger('submit')});
	})
}


// column height
function eqHeights(el) {
 $(el).each(function() {
  var _heigh = 0;
  var _holder = $(this);
  var _child = _holder.find('.column-height');
 	_child.each(function(){
  	 if ($(this).outerHeight() > _heigh) { _heigh = $(this).outerHeight(); }
	_child.each(function(){	
	if ($(this).outerHeight() <= _heigh) {
	var real_height = (_heigh - $(this).outerHeight()) + $(this).height();
	$(this).css('height', real_height);
	};
	});
  });
 });
 }
// ieHover
function ieHover(h_list, h_class){
	if(jQuery.browser.msie && jQuery.browser.version < 7){
		if(!h_class) var h_class = 'hover';
		jQuery(h_list).mouseenter(function(){
			jQuery(this).addClass(h_class);
		}).mouseleave(function(){
			jQuery(this).removeClass(h_class);
		});
	};
};

/* Clear Form Fields */
function initClearFormFields(){
	clearFormFields({
		clearInputs: true,
		clearTextareas: true,
		passwordFieldText: true
	});
}
function clearFormFields(o)
{
	if (o.clearInputs == null) o.clearInputs = true;
	if (o.clearTextareas == null) o.clearTextareas = true;
	if (o.passwordFieldText == null) o.passwordFieldText = false;
	if (o.addClassFocus == null) o.addClassFocus = false;
	if (!o.filterClass) o.filterClass = "default";
	if(o.clearInputs) {
		var inputs = document.getElementsByTagName("input");
		for (var i = 0; i < inputs.length; i++ ) {		
			if((inputs[i].type == "text" || inputs[i].type == "password") && inputs[i].className.indexOf(o.filterClass) && typeof( $(inputs[i]).attr('noAutoClear') ) == 'undefined') {				
				inputs[i].valueHtml = $(inputs[i]).prop("defaultValue");
				if(inputs[i].className.search("noPreText") == -1){
					if(inputs[i].type == "text"){
						var preText = $('<div class="preText">'+inputs[i].valueHtml+'</div>')
							.css({
								color: $(inputs[i]).css('color'),
								fontFamily: $(inputs[i]).css('fontFamily'),
								fontSize: $(inputs[i]).css('fontSize'),
								lineHeight: $(inputs[i]).css('lineHeight'),
								paddingTop: $(inputs[i]).css('paddingTop'),
								paddingLeft: $(inputs[i]).css('paddingLeft'),
								height: $(inputs[i]).css('height'),
								width: $(inputs[i]).css('width'),
								textAlign: $(inputs[i]).css('textAlign'),
								position: 'absolute',
								cursor: 'text'
							});
						$(inputs[i]).before(preText);
						$(inputs[i]).val("");					
						preText.click(function(){
							//if($(this).parent().children("input:focus").length == 0)
								$(this).parent().children("input[type='text']").focus();						
						});
						inputs[i].onfocus = function ()	{
							$(this).parent().children(".preText").fadeOut('fast');					
						}
						inputs[i].onkeydown = function ()	{
							$(this).parent().children(".preText").fadeOut('fast');					
						}
						inputs[i].onblur = function () {
							if(this.value == "") {
								$(this).parent().children(".preText").fadeIn('fast');
							}
							if(o.addClassFocus) {
								this.className = this.className.replace(o.addClassFocus, "");
								this.parentNode.className = this.parentNode.className.replace("parent-"+o.addClassFocus, "");
							}
						}
					}else{ // Passwords
						inputs[i].onfocus = function ()	{
							if(this.valueHtml == this.value) this.value = "";
							if(this.fake) {
								inputsSwap(this, this.previousSibling);
								this.previousSibling.focus();
							}
							if(o.addClassFocus && !this.fake) {
								this.className += " " + o.addClassFocus;
								this.parentNode.className += " parent-" + o.addClassFocus;
							}
						}
						inputs[i].onblur = function () {
							if(this.value == "") {								
								this.value = this.valueHtml;
								if(o.passwordFieldText && this.type == "password") inputsSwap(this, this.nextSibling);
							}
							if(o.addClassFocus) {
								this.className = this.className.replace(o.addClassFocus, "");
								this.parentNode.className = this.parentNode.className.replace("parent-"+o.addClassFocus, "");
							}
						}
					}
				}
			}
		}
	}
	if(o.clearTextareas) {
		var textareas = document.getElementsByTagName("textarea");
		for(var i=0; i<textareas.length; i++) {
			if((textareas[i].className.indexOf(o.filterClass))&&(textareas[i].className.search("noPreText") == -1)) {
				textareas[i].valueHtml = textareas[i].value;
				textareas[i].onfocus = function() {
					if(this.value == this.valueHtml) this.value = "";
					if(o.addClassFocus) {
						this.className += " " + o.addClassFocus;
						this.parentNode.className += " parent-" + o.addClassFocus;
					}
				}
				textareas[i].onblur = function() {
					if(this.value == "") this.value = this.valueHtml;
					if(o.addClassFocus) {
						this.className = this.className.replace(o.addClassFocus, "");
						this.parentNode.className = this.parentNode.className.replace("parent-"+o.addClassFocus, "");
					}
				}
			}
		}
	}
	function inputsSwap(el, el2) {
		if(el) el.style.display = "none";
		if(el2) el2.style.display = "inline";
	}
}

function initSelect(){
	var _holder = $('.bodypart-tab');
	_holder.each(function(){
		var _this = $(this);
		var _select = $('#gender');
		var _block1 = _this.find('.m-box');
		var _box1 = _block1.find('.frm');
		var _block2 = _this.find('.w-box');
		var _box2 = _block2.find('.frm');
		var _btnFront = _this.find('.btn-front');
		var _btnBack = _this.find('.btn-back');
		_select.change(showItem);
		showItem();
		function showItem(){
			if(_select.val() == 'Male'){
				_block1.show();
				_box1.eq(0).show();
				_box1.eq(1).hide();
				_block2.hide();
			}
			else{
				_block1.hide();
				_block2.show();
				_box2.eq(0).show();
				_box2.eq(1).hide();
			}		}
		_btnFront.click(function(){
			if(_select.val() == 'Male') {
				_box1.eq(0).show();
				_box1.eq(1).hide();
			}
			else {
				_box2.eq(0).show();
				_box2.eq(1).hide();
			}
			return false;
		});
		_btnBack.click(function(){
			if(_select.val() == 'Male') {
				_box1.eq(1).show();
				_box1.eq(0).hide();
			}
			else {
				_box2.eq(1).show();
				_box2.eq(0).hide();
			}
			return false;
		});
	});
	var _frm = _holder.find('.frm');
	_frm.each(function(){
		var _this = $(this);
		var _box = _this.find('.box');
		_box.mouseenter(function(){
			_frm.css({zIndex:50});
		}).mouseleave(function(){
			_frm.css({zIndex:1});
		});
	});}

// initScroll
function initScroll(){
	$('.scrollable').jScrollPane({
		showArrows: true
	});
}
function initSort(){
	var _holder = $('.sort-box');
	_holder.each(function(){
		var _this = $(this);
		var _sortHeading = $('.sort-heading a',_this);
		var _activeEl = $('.sort-heading .active',_this);
		var _sortList = $('.sort-list > li',_this);
		if(_activeEl.length){
			sortFunction(_activeEl.text().charAt(0));
		}
		function sortFunction(_obj){
			var _sortItem = _obj;
			_sortList.hide().removeClass('show-item');
			_sortList.each(function(){
				var hold = $(this);
				var _tab = hold.find('.tab');
				if(hold.hasClass('first-child')) hold.removeClass('first-child');
				if(_tab.hasClass('active')) _tab.removeClass('active');
				if(_sortItem == hold.text().charAt(0)) {
					hold.addClass('show-item');
				}
			});
			var _activeItem = $('.show-item',_this);
			_activeItem.eq(0).addClass('first-child').find('.tab').addClass('active');
			if(_sortList.parents('.scrollable').length) {
				_sortList.parents('.scrollable').jScrollPane({showArrows: true});
			}
			else initTabs1();
		}
		_sortHeading.each(function(){
			var _this = $(this);
			var _sort = _this.text();
			_this.click(function(){
				if(!_this.hasClass('active')){
					_sortHeading.removeClass('active');
					_this.addClass('active');
					sortFunction(_sort);
				}
				return false;
			});
		});
	});
}

// initGallery
function initGallery(){
	$('.gallery:has(.hold)').each(function(){
		var _gall = $(this);
		var _slidesHolder = $('.hold>ul', _gall);
		var _pager = $('.switcher', _gall);
		_pager.empty();
		if (_gall.parents('.video-holder, .related-galleries, .aside1').length == 0){
			_slidesHolder.cycle({
				fx: 'scrollLeft',
				pager: _pager,
				pagerAnchorBuilder: function(i){
					return '<li><a href="#"><span>' + (i + 1) + '</span></a></li>'
				},
				activePagerClass:'active',
				pause: true,
				pauseOnPagerHover: true,
				timeout: 10000
			})
		}
	});
	$('.gallery:has(.holder)').each(function(){
		var _gall = $(this);
		var _slidesHolder = $('.holder>ul', _gall);
		var _pager = $('.switcher', _gall);
		var _next = $('.link-next', _gall);
		var _prev = $('.link-prev', _gall);
		_pager.empty();
		_slidesHolder.cycle({
			fx: 'scrollHorz',
			pager: _pager,
			pagerAnchorBuilder: function(i){
				return '<li><a href="#"><span>' + (i + 1) + '</span></a></li>'
			},
			activePagerClass:'active',
			next: _next,
			prev: _prev,
			pause: true,
			pauseOnPagerHover: true,
			timeout: 10000
		})
	});
	$('.video-holder').each(function(){
		var _fadeSpeed = 700;
		var _holder = $(this);
		var _gall = $('.gallery', _holder);
		var _links = $('ul>li', _gall);
		var _slides = $('.video .gallery-fade>li', _holder);
		_slides.hide().eq(0).show().addClass('active');
		_links.each(function(ind){
			$(this).attr('rel', ind);
			if (ind == _links.length-1) initVideoGall();
		})
		function initVideoGall(){
			//Only rotate the video thumbnails in the carousel if there are more than 3
			if(_links.length > 3)
			{
				_gall.cyclingGall({
					slideEl: '.hold>ul',
					autoSlide: 8000
				})
			}
			else
			{
				_gall.cyclingGall({
					slideEl: '.hold>ul',
					autoSlide: 0
				})
			}
			var _fadeLinks = $('ul>li', _gall);
			_fadeLinks.click(function(){
				if (!_slides.eq($(this).attr('rel')).is('.active') && _slides.filter(':animated').length == 0){
					_slides.fadeOut(_fadeSpeed).removeClass('active');
					_slides.eq($(this).attr('rel')).fadeIn(_fadeSpeed).addClass('active');
				}
				return false;
			})
		}
	})
	if ($('.side-gallery').parents('.doctor-gallery').length == 0){
		var _gall = $('.side-gallery');
		var _slidesHolder = $('.gallery>ul', _gall);
		var _pager = $('.switcher', _gall);
		var _next = $('.link-next', _gall);
		var _prev = $('.link-prev', _gall);
		_pager.empty();
		_slidesHolder.cycle({
			fx: 'scrollHorz',
			pager: _pager,
			pagerAnchorBuilder: function(i){
				return '<li><a href="#"><span>' + (i + 1) + '</span></a></li>'
			},
			activePagerClass:'active',
			next: _next,
			prev: _prev,
			pause: true,
			pauseOnPagerHover: true,
			timeout: 10000 //Here! Here it is! AAAAAAAA
		});
	}
	$('.related-galleries .gallery').cyclingGall({
		slideEl: '.hold>ul',
		autoSlide: 8000
	});
	$('.doctor-gallery').each(function(){
		var _holder = $(this);
		var _slideEl = $('.side-gallery>.gallery>ul.featured-carousel', _holder);
		var _els = $('>li', _slideEl);
		var _next = $('.link-next', _holder);
		var _prev = $('.link-prev', _holder);
		var _switcher = $('.switcher', _holder);
		_switcher.empty();
		var _n = _slideEl.attr("displaySize");
		var _slidesCount = Math.ceil(_els.length/3);
		var _curStep = 0;
		var _newSlide = $('<div>').addClass('slide').appendTo(_slideEl);
		_els.each(function(ind){
			if (Math.floor(ind/_n) <= _curStep) {
				$(this).appendTo(_newSlide)
			}
			else {
				_newSlide = $('<div>').addClass('slide').appendTo(_slideEl);
				_curStep++;
				$(this).appendTo(_newSlide)
			}
		})
		_slideEl.cycle({
			fx: 'scrollLeft',
			pager: _switcher,
			pagerAnchorBuilder: function(i){
				return '<li><a href="#"><span>' + (i + 1) + '</span></a></li>'
			},
			activePagerClass:'active',
			next: _next,
			prev: _prev,
			pause: true,
			pauseOnPagerHover: true,
			timeout: 10000
		});
	})
	$('.widget-gallery').each(function(){
		var _holder = $(this);
		var _slideEl = $('.media-gallery>ul', _holder);
		var _els = $('>li', _slideEl);
		var _switcher = $('.switcher', _holder);
		_switcher.empty();
		var _n = 3;
		var _slidesCount = Math.ceil(_els.length/3);
		var _curStep = 0;
		var _newSlide = $('<div>').addClass('slide').appendTo(_slideEl);
		_els.each(function(ind){
			if (Math.floor(ind/_n) <= _curStep) {
				$(this).appendTo(_newSlide)
			}
			else {
				_newSlide = $('<div>').addClass('slide').appendTo(_slideEl);
				_curStep++;
				$(this).appendTo(_newSlide)
			}
		})
		_slideEl.cycle({
			fx: 'scrollLeft',
			pager: _switcher,
			pagerAnchorBuilder: function(i){
				return '<li><a href="#"><span>' + (i + 1) + '</span></a></li>'
			},
			activePagerClass:'active',
			pause: true,
			pauseOnPagerHover: true
		});
	})
	$('.widget-gallery1').each(function(){
		var _holder = $(this);
		var _slideEl = $('.media-gallery1>ul', _holder);
		var _els = $('>li', _slideEl);
		var _switcher = $('.switcher', _holder);
		_switcher.empty();
		var _n = 2;
		var _slidesCount = Math.ceil(_els.length/3);
		var _curStep = 0;
		var _newSlide = $('<div>').addClass('slide').appendTo(_slideEl);
		_els.each(function(ind){
			if (Math.floor(ind/_n) <= _curStep) {
				$(this).appendTo(_newSlide)
			}
			else {
				_newSlide = $('<div>').addClass('slide').appendTo(_slideEl);
				_curStep++;
				$(this).appendTo(_newSlide)
			}
		})
		_slideEl.cycle({
			fx: 'scrollLeft',
			pager: _switcher,
			pagerAnchorBuilder: function(i){
				return '<li><a href="#"><span>' + (i + 1) + '</span></a></li>'
			},
			activePagerClass:'active',
			pause: true,
			pauseOnPagerHover: true
		});
	})
	$('.aside1').each(function(){
		if (typeof angle_descriptions != "undefined" && Object.size(angle_descriptions) < 5)
			return
		var _holder = $(this);
		var _fadeSpeed = 700;
		var _gall = $('.gallery', _holder);
		var _links = $('.hold>ul>li', _gall);
		var _slides = $('.fade-gal>li', _holder);
		_slides.hide().eq(0).show().addClass('active');
		_links.each(function(ind){
			$(this).attr('rel', ind);
			if (ind == _links.length-1) initVideoGall();
		})
		function initVideoGall(){
			_gall.cyclingGall({
				slideEl: '.hold>ul',
				autoSlide: 8000,
				direction: true
			})
			var _fadeLinks = $('.hold>ul>li', _gall);
			_fadeLinks.click(function(){
				if (!_slides.eq($(this).attr('rel')).is('.active') && _slides.filter(':animated').length == 0){
					_slides.fadeOut(_fadeSpeed).removeClass('active');
					_slides.eq($(this).attr('rel')).fadeIn(_fadeSpeed).addClass('active');
					_fadeLinks.removeClass('active');
					$(this).addClass('active')
					_fadeLinks.filter('[rel=' + $(this).attr('rel') + ']').addClass('active');
				}
				return false;
			})
		}
	})}

// scrolling gallery plugin
jQuery.fn.scrollGallery = function(_options){
	var _options = jQuery.extend({
		sliderHolder: '>div',
		slider:'>ul',
		slides: '>li',
		pagerLinks:'.switcher li',
		btnPrev:'a.link-prev',
		btnNext:'a.link-next',
		activeClass:'active',
		disabledClass:'disabled',
		generatePagination:'ul.switcher',
		curNum:'em.scur-num',
		allNum:'em.sall-num',
		circleSlide:true,
		pauseClass:'gallery-paused',
		pauseButton:'none',
		pauseOnHover:true,
		autoRotation:true,
		stopAfterClick:false,
		switchTime:7000,
		duration:650,
		easing:'swing',
		event:'click',
		splitCount:false,
		afterInit:false,
		vertical:false,
		step:false
	},_options);

	return this.each(function(){
		// gallery options
		var _this = jQuery(this);
		var _sliderHolder = jQuery(_options.sliderHolder, _this);
		var _slider = jQuery(_options.slider, _sliderHolder);
		var _slides = jQuery(_options.slides, _slider);
		var _btnPrev = jQuery(_options.btnPrev, _this);
		var _btnNext = jQuery(_options.btnNext, _this);
		var _pagerLinks = jQuery(_options.pagerLinks, _this);
		var _generatePagination = jQuery(_options.generatePagination, _this);
		var _curNum = jQuery(_options.curNum, _this);
		var _allNum = jQuery(_options.allNum, _this);
		var _pauseButton = jQuery(_options.pauseButton, _this);
		var _pauseOnHover = _options.pauseOnHover;
		var _pauseClass = _options.pauseClass;
		var _autoRotation = _options.autoRotation;
		var _activeClass = _options.activeClass;
		var _disabledClass = _options.disabledClass;
		var _easing = _options.easing;
		var _duration = _options.duration;
		var _switchTime = _options.switchTime;
		var _controlEvent = _options.event;
		var _step = _options.step;
		var _vertical = _options.vertical;
		var _circleSlide = _options.circleSlide;
		var _stopAfterClick = _options.stopAfterClick;
		var _afterInit = _options.afterInit;
		var _splitCount = _options.splitCount;

		// gallery init
		if(!_slides.length) return;

		if(_splitCount) {
			var curStep = 0;
			var newSlide = $('<slide>').addClass('split-slide');
			_slides.each(function(){
				newSlide.append(this);
				curStep++;
				if(curStep > _splitCount-1) {
					curStep = 0;
					_slider.append(newSlide);
					newSlide = $('<slide>').addClass('split-slide');
				}
			});
			if(curStep) _slider.append(newSlide);
			_slides = _slider.children();
		}

		var _currentStep = 0;
		var _sumWidth = 0;
		var _sumHeight = 0;
		var _hover = false;
		var _stepWidth;
		var _stepHeight;
		var _stepCount;
		var _offset;
		var _timer;

		_slides.each(function(){
			_sumWidth+=$(this).outerWidth(true);
			_sumHeight+=$(this).outerHeight(true);
		});

		// calculate gallery offset
		function recalcOffsets() {
			if(_vertical) {
				if(_step) {
					_stepHeight = _slides.eq(_currentStep).outerHeight(true);
					_stepCount = Math.ceil((_sumHeight-_sliderHolder.height())/_stepHeight)+1;
					_offset = -_stepHeight*_currentStep;
				} else {
					_stepHeight = _sliderHolder.height();
					_stepCount = Math.ceil(_sumHeight/_stepHeight);
					_offset = -_stepHeight*_currentStep;
					if(_offset < _stepHeight-_sumHeight) _offset = _stepHeight-_sumHeight;
				}
			} else {
				if(_step) {
					_stepWidth = _slides.eq(_currentStep).outerWidth(true)*_step;
					_stepCount = Math.ceil((_sumWidth-_sliderHolder.width())/_stepWidth)+1;
					_offset = -_stepWidth*_currentStep;
					if(_offset < _sliderHolder.width()-_sumWidth) _offset = _sliderHolder.width()-_sumWidth;
				} else {
					_stepWidth = _sliderHolder.width();
					_stepCount = Math.ceil(_sumWidth/_stepWidth);
					_offset = -_stepWidth*_currentStep;
					if(_offset < _stepWidth-_sumWidth) _offset = _stepWidth-_sumWidth;
				}
			}
		}

		// gallery control
		if(_btnPrev.length) {
			_btnPrev.bind(_controlEvent,function(){
				if(_stopAfterClick) stopAutoSlide();
				prevSlide();
				return false;
			});
		}
		if(_btnNext.length) {
			_btnNext.bind(_controlEvent,function(){
				if(_stopAfterClick) stopAutoSlide();
				nextSlide();
				return false;
			});
		}
		if(_generatePagination.length) {
			_generatePagination.empty();
			recalcOffsets();
			for(var i=0; i<_stepCount; i++) $('<li><a href="#"><span>'+(i+1)+'</span></a></li>').appendTo(_generatePagination);
			_pagerLinks = _generatePagination.children();
		}
		if(_pagerLinks.length) {
			_pagerLinks.each(function(_ind){
				jQuery(this).bind(_controlEvent,function(){
					if(_currentStep != _ind) {
						if(_stopAfterClick) stopAutoSlide();
						_currentStep = _ind;
						switchSlide();
					}
					return false;
				});
			});
		}

		// gallery animation
		function prevSlide() {
			recalcOffsets();
			if(_currentStep > 0) _currentStep--;
			else if(_circleSlide) _currentStep = _stepCount-1;
			switchSlide();
		}
		function nextSlide() {			
			recalcOffsets();
			if(_currentStep < _stepCount-1) _currentStep++;
			else if(_circleSlide) _currentStep = 0;
			switchSlide();			
		}
		function refreshStatus() {
			if(_pagerLinks.length) _pagerLinks.removeClass(_activeClass).eq(_currentStep).addClass(_activeClass);
			if(!_circleSlide) {
				_btnPrev.removeClass(_disabledClass);
				_btnNext.removeClass(_disabledClass);
				if(_currentStep == 0) _btnPrev.addClass(_disabledClass);
				if(_currentStep == _stepCount-1) _btnNext.addClass(_disabledClass);
			}
			if(_curNum.length) _curNum.text(_currentStep+1);
			if(_allNum.length) _allNum.text(_stepCount);
		}
		function switchSlide() {
			recalcOffsets();
			if(_vertical) _slider.animate({marginTop:_offset},{duration:_duration,queue:false,easing:_easing});
			else _slider.animate({marginLeft:_offset},{duration:_duration,queue:false,easing:_easing});
			refreshStatus();
			autoSlide();
		}

		// autoslide function
		function stopAutoSlide() {
			if(_timer) clearTimeout(_timer);
			_autoRotation = false;
		}
		function autoSlide() {
			if(!_autoRotation || _hover) return;
			if(_timer) clearTimeout(_timer);
			_timer = setTimeout(nextSlide,_switchTime+_duration);
		}
		if(_pauseOnHover) {
			_this.hover(function(){
				_hover = true;
				if(_timer) clearTimeout(_timer);				
			},function(){
				_hover = false;
				autoSlide();
			});
		}
		recalcOffsets();
		refreshStatus();
		autoSlide();

		// pause buttton
		if(_pauseButton.length) {
			_pauseButton.click(function(){
				if(_this.hasClass(_pauseClass)) {
					_this.removeClass(_pauseClass);
					_autoRotation = true;
					autoSlide();
				} else {
					_this.addClass(_pauseClass);
					stopAutoSlide();
				}
				return false;
			});
		}

		if(_afterInit && typeof _afterInit === 'function') _afterInit(_this, _slides);
	});
}


// slideshow init
function initSlideShow() {
	jQuery('div.gallery').fadeGallery({
		slideElements:'.fade-gal > li',
		pagerLinks:'.hold li'
	});
}
// slideshow plugin
jQuery.fn.fadeGallery = function(_options){
	var _options = jQuery.extend({
		slideElements:'div.slideset > div',
		pagerLinks:'div.pager a',
		btnNext:'a.next',
		btnPrev:'a.prev',
		btnPlayPause:'a.play-pause',
		btnPlay:'a.play',
		btnPause:'a.pause',
		pausedClass:'paused',
		disabledClass: 'disabled',
		playClass:'playing',
		activeClass:'active',
		currentNum:false,
		allNum:false,
		startSlide:null,
		noCircle:false,
		pauseOnHover:true,
		autoRotation:false,
		autoHeight:false,
		onChange:false,
		switchTime:3000,
		duration:650,
		event:'click'
	},_options);

	return this.each(function(){
		// gallery options
		var _this = jQuery(this);
		var _slides = jQuery(_options.slideElements, _this);
		var _pagerLinks = jQuery(_options.pagerLinks, _this);
		var _btnPrev = jQuery(_options.btnPrev, _this);
		var _btnNext = jQuery(_options.btnNext, _this);
		var _btnPlayPause = jQuery(_options.btnPlayPause, _this);
		var _btnPause = jQuery(_options.btnPause, _this);
		var _btnPlay = jQuery(_options.btnPlay, _this);
		var _pauseOnHover = _options.pauseOnHover;
		var _autoRotation = _options.autoRotation;
		var _activeClass = _options.activeClass;
		var _disabledClass = _options.disabledClass;
		var _pausedClass = _options.pausedClass;
		var _playClass = _options.playClass;
		var _autoHeight = _options.autoHeight;
		var _duration = _options.duration;
		var _switchTime = _options.switchTime;
		var _controlEvent = _options.event;
		var _currentNum = (_options.currentNum ? jQuery(_options.currentNum, _this) : false);
		var _allNum = (_options.allNum ? jQuery(_options.allNum, _this) : false);
		var _startSlide = _options.startSlide;
		var _noCycle = _options.noCircle;
		var _onChange = _options.onChange;

		// gallery init
		var _hover = false;
		var _prevIndex = 0;
		var _currentIndex = 0;
		var _slideCount = _slides.length;
		var _timer;
		if(_slideCount < 2) return;

		_prevIndex = _slides.index(_slides.filter('.'+_activeClass));
		if(_prevIndex < 0) _prevIndex = _currentIndex = 0;
		else _currentIndex = _prevIndex;
		if(_startSlide != null) {
			if(_startSlide == 'random') _prevIndex = _currentIndex = Math.floor(Math.random()*_slideCount);
			else _prevIndex = _currentIndex = parseInt(_startSlide);
		}
		_slides.hide().eq(_currentIndex).show();
		if(_autoRotation) _this.removeClass(_pausedClass).addClass(_playClass);
		else _this.removeClass(_playClass).addClass(_pausedClass);

		// gallery control
		if(_btnPrev.length) {
			_btnPrev.bind(_controlEvent,function(){
				prevSlide();
				return false;
			});
		}
		if(_btnNext.length) {
			_btnNext.bind(_controlEvent,function(){
				nextSlide();
				return false;
			});
		}
		if(_pagerLinks.length) {
			_pagerLinks.each(function(_ind){
				jQuery(this).bind(_controlEvent,function(){
					if(_currentIndex != _ind) {
						_prevIndex = _currentIndex;
						_currentIndex = _ind;
						switchSlide();
					}
					return false;
				});
			});
		}

		// play pause section
		if(_btnPlayPause.length) {
			_btnPlayPause.bind(_controlEvent,function(){
				if(_this.hasClass(_pausedClass)) {
					_this.removeClass(_pausedClass).addClass(_playClass);
					_autoRotation = true;
					autoSlide();
				} else {
					_autoRotation = false;
					if(_timer) clearTimeout(_timer);
					_this.removeClass(_playClass).addClass(_pausedClass);
				}
				return false;
			});
		}
		if(_btnPlay.length) {
			_btnPlay.bind(_controlEvent,function(){
				_this.removeClass(_pausedClass).addClass(_playClass);
				_autoRotation = true;
				autoSlide();
				return false;
			});
		}
		if(_btnPause.length) {
			_btnPause.bind(_controlEvent,function(){
				_autoRotation = false;
				if(_timer) clearTimeout(_timer);
				_this.removeClass(_playClass).addClass(_pausedClass);
				return false;
			});
		}

		// gallery animation
		function prevSlide() {
			_prevIndex = _currentIndex;
			if(_currentIndex > 0) _currentIndex--;
			else {
				if(_noCycle) return;
				else _currentIndex = _slideCount-1;
			}
			switchSlide();
		}
		function nextSlide() {
			_prevIndex = _currentIndex;
			if(_currentIndex < _slideCount-1) _currentIndex++;
			else {
				if(_noCycle) return;
				else _currentIndex = 0;
			}
			switchSlide();
		}
		function refreshStatus() {
			if(_pagerLinks.length) _pagerLinks.removeClass(_activeClass).eq(_currentIndex).addClass(_activeClass);
			if(_currentNum) _currentNum.text(_currentIndex+1);
			if(_allNum) _allNum.text(_slideCount);
			_slides.eq(_prevIndex).removeClass(_activeClass);
			_slides.eq(_currentIndex).addClass(_activeClass);
			if(_noCycle) {
				if(_btnPrev.length) {
					if(_currentIndex == 0) _btnPrev.addClass(_disabledClass);
					else _btnPrev.removeClass(_disabledClass);
				}
				if(_btnNext.length) {
					if(_currentIndex == _slideCount-1) _btnNext.addClass(_disabledClass);
					else _btnNext.removeClass(_disabledClass);
				}
			}
			if(typeof _onChange === 'function') {
				_onChange(_this, _currentIndex);
			}
		}
		function switchSlide() {
			_slides.eq(_prevIndex).fadeOut(_duration);
			_slides.eq(_currentIndex).fadeIn(_duration);
			if(_autoHeight) _slides.eq(_currentIndex).parent().animate({height:_slides.eq(_currentIndex).outerHeight(true)},{duration:_duration,queue:false});
			refreshStatus();
			autoSlide();
		}

		// autoslide function
		function autoSlide() {
			if(!_autoRotation || _hover) return;
			if(_timer) clearTimeout(_timer);
			_timer = setTimeout(nextSlide,_switchTime+_duration);
		}
		if(_pauseOnHover) {
			_this.hover(function(){
				_hover = true;
				if(_timer) clearTimeout(_timer);				
			},function(){
				_hover = false;
				autoSlide();
			});
		}
		refreshStatus();
		autoSlide();
	});
}


function initTabs() {
	$('ul.tabset').each(function(){
		var _list = $(this);
		var _links = _list.find('a.tab');

		_links.each(function() {
			var _link = $(this);
			var _href = _link.attr('href');
			var _tab = $(_href);

			if(_link.hasClass('active')) _tab.show();
			else _tab.hide();

			_link.click(function(){
				_links.filter('.active').each(function(){
					$($(this).removeClass('active').attr('href')).hide();
				});
				_link.addClass('active');
				_tab.show();
				return false;
			});
		});
	});
}

function initTabs1() {
	$('ul.tab-item').each(function(){
		var _list = $(this);
		var _links = _list.find('a.tab');

		_links.each(function() {
			var _link = $(this);
			var _href = _link.attr('href');
			var _tab = $(_href);

			if(_link.hasClass('active')) _tab.show();
			else _tab.hide();

			_link.click(function(){
				_links.filter('.active').each(function(){
					$($(this).removeClass('active').attr('href')).hide();
				});
				_link.addClass('active');
				_tab.show();
				return false;
			});
		});
	});
}


// custom forms init
function initCustomForms() {
	//$('select').customSelect();
	$('input:radio').customRadio();
	$('input:checkbox').customCheckbox();
}

// custom forms plugin
(function(jQuery){
	// custom checkboxes module
	jQuery.fn.customCheckbox = function(_options){
		var _options = jQuery.extend({
			checkboxStructure: '<div></div>',
			checkboxDisabled: 'disabled',
			checkboxDefault: 'checkboxArea',
			checkboxChecked: 'checkboxAreaChecked'
		}, _options);
		return this.each(function(){
			var checkbox = jQuery(this);
			if(!checkbox.hasClass('outtaHere') && checkbox.is(':checkbox')){
				var replaced = jQuery(_options.checkboxStructure);
				this._replaced = replaced;
				if(checkbox.is(':disabled')) replaced.addClass(_options.checkboxDisabled);
				else if(checkbox.is(':checked')) replaced.addClass(_options.checkboxChecked);
				else replaced.addClass(_options.checkboxDefault);

				replaced.click(function(){
					if(checkbox.is(':checked')) checkbox.removeAttr('checked');
					else checkbox.attr('checked', 'checked');
					changeCheckbox(checkbox);
				});
				checkbox.click(function(){
					changeCheckbox(checkbox);
				});
				replaced.insertBefore(checkbox);
				checkbox.addClass('outtaHere');
			}
		});
		function changeCheckbox(_this){
			_this.change();
			if(_this.is(':checked')) _this.get(0)._replaced.removeClass().addClass(_options.checkboxChecked);
			else _this.get(0)._replaced.removeClass().addClass(_options.checkboxDefault);
		}
	}

	// custom radios module
	jQuery.fn.customRadio = function(_options){
		var _options = jQuery.extend({
			radioStructure: '<div></div>',
			radioDisabled: 'disabled',
			radioDefault: 'radioArea',
			radioChecked: 'radioAreaChecked'
		}, _options);
		return this.each(function(){
			var radio = jQuery(this);
			if(!radio.hasClass('outtaHere') && radio.is(':radio')){
				var replaced = jQuery(_options.radioStructure);
				this._replaced = replaced;
				if(radio.is(':disabled')) replaced.addClass(_options.radioDisabled);
				else if(radio.is(':checked')) replaced.addClass(_options.radioChecked);
				else replaced.addClass(_options.radioDefault);
				replaced.click(function(){
					if($(this).hasClass(_options.radioDefault)){
						radio.attr('checked', 'checked');
						changeRadio(radio.get(0));
					}
				});
				radio.click(function(){
					changeRadio(this);
				});
				replaced.insertBefore(radio);
				radio.addClass('outtaHere');
			}
		});
		function changeRadio(_this){
			$(_this).change();
			$('input:radio[name='+$(_this).attr("name")+']').not(_this).each(function(){
				if(this._replaced && !$(this).is(':disabled')) this._replaced.removeClass().addClass(_options.radioDefault);
			});
			_this._replaced.removeClass().addClass(_options.radioChecked);
		}
	}

	// custom selects module
	jQuery.fn.customSelect = function(_options) {
		var _options = jQuery.extend({
			selectStructure: '<div class="selectArea"><span class="left"></span><span class="center"></span><a href="#" class="selectButton"></a><div class="disabled"></div></div>',
			hideOnMouseOut: false,
			copyClass: true,
			selectText: '.center',
			selectBtn: '.selectButton',
			selectDisabled: '.disabled',
			optStructure: '<div class="optionsDivVisible"><div class="select-top"></div><div class="select-center"><ul></ul><div class="select-bottom"></div></div>',
			optList: 'ul'
		}, _options);
		return this.each(function() {
			var select = jQuery(this);
			if(!select.hasClass('outtaHere')) {
				if(select.is(':visible')) {
					var hideOnMouseOut = _options.hideOnMouseOut;
					var copyClass = _options.copyClass;
					var replaced = jQuery(_options.selectStructure);
					var selectText = replaced.find(_options.selectText);
					var selectBtn = replaced.find(_options.selectBtn);
					var selectDisabled = replaced.find(_options.selectDisabled).hide();
					var optHolder = jQuery(_options.optStructure);
					var optList = optHolder.find(_options.optList);
					if(copyClass) optHolder.addClass('drop-'+select.attr('class'));

					if(select.attr('disabled')) selectDisabled.show();
					select.find('option').each(function(){
						var selOpt = $(this);
						var _opt = jQuery('<li><a href="#">' + selOpt.html() + '</a></li>');
						if(selOpt.attr('selected')) {
							selectText.html(selOpt.html());
							_opt.addClass('selected');
						}
						_opt.children('a').click(function() {
							optList.find('li').removeClass('selected');
							select.find('option').removeAttr('selected');
							$(this).parent().addClass('selected');
							selOpt.attr('selected', 'selected');
							selectText.html(selOpt.html());
							select.change();
							optHolder.hide();
							return false;
						});
						optList.append(_opt);
					});
					replaced.width(select.outerWidth());
					replaced.insertBefore(select);
					optHolder.css({
						width: select.outerWidth(),
						display: 'none',
						position: 'absolute'
					});
					jQuery(document.body).append(optHolder);

					var optTimer;
					replaced.hover(function() {
						if(optTimer) clearTimeout(optTimer);
					}, function() {
						if(hideOnMouseOut) {
							optTimer = setTimeout(function() {
								optHolder.hide();
							}, 200);
						}
					});
					optHolder.hover(function(){
						if(optTimer) clearTimeout(optTimer);
					}, function() {
						if(hideOnMouseOut) {
							optTimer = setTimeout(function() {
								optHolder.hide();
							}, 200);
						}
					});
					selectBtn.click(function() {
						if(optHolder.is(':visible')) {
							optHolder.hide();
						}
						else{
							if(_activeDrop) _activeDrop.hide();
							optHolder.children('ul').css({height:'auto', overflow:'hidden'});
							optHolder.css({
								top: replaced.offset().top + replaced.outerHeight(),
								left: replaced.offset().left,
								display: 'block'
							});
							if(optHolder.children('ul').height() > 200) optHolder.children('ul').css({height:200, overflow:'auto'});
							_activeDrop = optHolder;
						}
						return false;
					});
					select.addClass('outtaHere');
				}
			}
		});
	}

	// event handler on DOM ready
	var _activeDrop;
	jQuery(function(){
		jQuery('body').click(hideOptionsClick)
		jQuery(window).resize(hideOptions)
	});
	function hideOptions() {
		if(_activeDrop && _activeDrop.length) {
			_activeDrop.hide();
			_activeDrop = null;
		}
	}
	function hideOptionsClick(e) {
		if(_activeDrop && _activeDrop.length) {
			var f = false;
			$(e.target).parents().each(function(){
				if(this == _activeDrop) f=true;
			});
			if(!f) {
				_activeDrop.hide();
				_activeDrop = null;
			}
		}
	}
})(jQuery);

// open-close init
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



/*
 * jScrollPane - v2.0.0beta6 - 2010-12-06
 * http://jscrollpane.kelvinluck.com/
 *
 * Copyright (c) 2010 Kelvin Luck
 * Dual licensed under the MIT and GPL licenses.
 */
;(function(b,a,c){b.fn.jScrollPane=function(f){function d(C,L){var au,N=this,V,ah,v,aj,Q,W,y,q,av,aB,ap,i,H,h,j,X,R,al,U,t,A,am,ac,ak,F,l,ao,at,x,aq,aE,g,aA,ag=true,M=true,aD=false,k=false,Z=b.fn.mwheelIntent?"mwheelIntent.jsp":"mousewheel.jsp";aE=C.css("paddingTop")+" "+C.css("paddingRight")+" "+C.css("paddingBottom")+" "+C.css("paddingLeft");g=(parseInt(C.css("paddingLeft"))||0)+(parseInt(C.css("paddingRight"))||0);an(L);function an(aH){var aL,aK,aJ,aG,aF,aI;au=aH;if(V==c){C.css({overflow:"hidden",padding:0});ah=C.innerWidth()+g;v=C.innerHeight();C.width(ah);V=b('<div class="jspPane" />').wrap(b('<div class="jspContainer" />').css({width:ah+"px",height:v+"px"}));C.wrapInner(V.parent());aj=C.find(">.jspContainer");V=aj.find(">.jspPane");V.css("padding",aE)}else{C.css("width","");aI=C.outerWidth()+g!=ah||C.outerHeight()!=v;if(aI){ah=C.innerWidth()+g;v=C.innerHeight();aj.css({width:ah+"px",height:v+"px"})}aA=V.innerWidth();if(!aI&&V.outerWidth()==Q&&V.outerHeight()==W){if(aB||av){V.css("width",aA+"px");C.css("width",(aA+g)+"px")}return}V.css("width","");C.css("width",(ah)+"px");aj.find(">.jspVerticalBar,>.jspHorizontalBar").remove().end()}aL=V.clone().css("position","absolute");aK=b('<div style="width:1px; position: relative;" />').append(aL);b("body").append(aK);Q=Math.max(V.outerWidth(),aL.outerWidth());aK.remove();W=V.outerHeight();y=Q/ah;q=W/v;av=q>1;aB=y>1;if(!(aB||av)){C.removeClass("jspScrollable");V.css({top:0,width:aj.width()-g});n();D();O();w();af()}else{C.addClass("jspScrollable");aJ=au.maintainPosition&&(H||X);if(aJ){aG=ay();aF=aw()}aC();z();E();if(aJ){K(aG);J(aF)}I();ad();if(au.enableKeyboardNavigation){P()}if(au.clickOnTrack){p()}B();if(au.hijackInternalLinks){m()}}if(au.autoReinitialise&&!aq){aq=setInterval(function(){an(au)},au.autoReinitialiseDelay)}else{if(!au.autoReinitialise&&aq){clearInterval(aq)}}C.trigger("jsp-initialised",[aB||av])}function aC(){if(av){aj.append(b('<div class="jspVerticalBar" />').append(b('<div class="jspCap jspCapTop" />'),b('<div class="jspTrack" />').append(b('<div class="jspDrag" />').append(b('<div class="jspDragTop" />'),b('<div class="jspDragBottom" />'))),b('<div class="jspCap jspCapBottom" />')));R=aj.find(">.jspVerticalBar");al=R.find(">.jspTrack");ap=al.find(">.jspDrag");if(au.showArrows){am=b('<a class="jspArrow jspArrowUp" />').bind("mousedown.jsp",az(0,-1)).bind("click.jsp",ax);ac=b('<a class="jspArrow jspArrowDown" />').bind("mousedown.jsp",az(0,1)).bind("click.jsp",ax);if(au.arrowScrollOnHover){am.bind("mouseover.jsp",az(0,-1,am));ac.bind("mouseover.jsp",az(0,1,ac))}ai(al,au.verticalArrowPositions,am,ac)}t=v;aj.find(">.jspVerticalBar>.jspCap:visible,>.jspVerticalBar>.jspArrow").each(function(){t-=b(this).outerHeight()});ap.hover(function(){ap.addClass("jspHover")},function(){ap.removeClass("jspHover")}).bind("mousedown.jsp",function(aF){b("html").bind("dragstart.jsp selectstart.jsp",function(){return false});ap.addClass("jspActive");var s=aF.pageY-ap.position().top;b("html").bind("mousemove.jsp",function(aG){S(aG.pageY-s,false)}).bind("mouseup.jsp mouseleave.jsp",ar);return false});o()}}function o(){al.height(t+"px");H=0;U=au.verticalGutter+al.outerWidth();V.width(ah-U-g);if(R.position().left==0){V.css("margin-left",U+"px")}}function z(){if(aB){aj.append(b('<div class="jspHorizontalBar" />').append(b('<div class="jspCap jspCapLeft" />'),b('<div class="jspTrack" />').append(b('<div class="jspDrag" />').append(b('<div class="jspDragLeft" />'),b('<div class="jspDragRight" />'))),b('<div class="jspCap jspCapRight" />')));ak=aj.find(">.jspHorizontalBar");F=ak.find(">.jspTrack");h=F.find(">.jspDrag");if(au.showArrows){at=b('<a class="jspArrow jspArrowLeft" />').bind("mousedown.jsp",az(-1,0)).bind("click.jsp",ax);x=b('<a class="jspArrow jspArrowRight" />').bind("mousedown.jsp",az(1,0)).bind("click.jsp",ax);if(au.arrowScrollOnHover){at.bind("mouseover.jsp",az(-1,0,at));
x.bind("mouseover.jsp",az(1,0,x))}ai(F,au.horizontalArrowPositions,at,x)}h.hover(function(){h.addClass("jspHover")},function(){h.removeClass("jspHover")}).bind("mousedown.jsp",function(aF){b("html").bind("dragstart.jsp selectstart.jsp",function(){return false});h.addClass("jspActive");var s=aF.pageX-h.position().left;b("html").bind("mousemove.jsp",function(aG){T(aG.pageX-s,false)}).bind("mouseup.jsp mouseleave.jsp",ar);return false});l=aj.innerWidth();ae()}else{}}function ae(){aj.find(">.jspHorizontalBar>.jspCap:visible,>.jspHorizontalBar>.jspArrow").each(function(){l-=b(this).outerWidth()});F.width(l+"px");X=0}function E(){if(aB&&av){var aF=F.outerHeight(),s=al.outerWidth();t-=aF;b(ak).find(">.jspCap:visible,>.jspArrow").each(function(){l+=b(this).outerWidth()});l-=s;v-=s;ah-=aF;F.parent().append(b('<div class="jspCorner" />').css("width",aF+"px"));o();ae()}if(aB){V.width((aj.outerWidth()-g)+"px")}W=V.outerHeight();q=W/v;if(aB){ao=1/y*l;if(ao>au.horizontalDragMaxWidth){ao=au.horizontalDragMaxWidth}else{if(ao<au.horizontalDragMinWidth){ao=au.horizontalDragMinWidth}}h.width(ao+"px");j=l-ao;ab(X)}if(av){A=1/q*t;if(A>au.verticalDragMaxHeight){A=au.verticalDragMaxHeight}else{if(A<au.verticalDragMinHeight){A=au.verticalDragMinHeight}}ap.height(A+"px");i=t-A;aa(H)}}function ai(aG,aI,aF,s){var aK="before",aH="after",aJ;if(aI=="os"){aI=/Mac/.test(navigator.platform)?"after":"split"}if(aI==aK){aH=aI}else{if(aI==aH){aK=aI;aJ=aF;aF=s;s=aJ}}aG[aK](aF)[aH](s)}function az(aF,s,aG){return function(){G(aF,s,this,aG);this.blur();return false}}function G(aH,aF,aK,aJ){aK=b(aK).addClass("jspActive");var aI,s=function(){if(aH!=0){T(X+aH*au.arrowButtonSpeed,false)}if(aF!=0){S(H+aF*au.arrowButtonSpeed,false)}},aG=setInterval(s,au.arrowRepeatFreq);s();aI=aJ==c?"mouseup.jsp":"mouseout.jsp";aJ=aJ||b("html");aJ.bind(aI,function(){aK.removeClass("jspActive");clearInterval(aG);aJ.unbind(aI)})}function p(){w();if(av){al.bind("mousedown.jsp",function(aH){if(aH.originalTarget==c||aH.originalTarget==aH.currentTarget){var aG=b(this),s=setInterval(function(){var aI=aG.offset(),aJ=aH.pageY-aI.top;if(H+A<aJ){S(H+au.trackClickSpeed)}else{if(aJ<H){S(H-au.trackClickSpeed)}else{aF()}}},au.trackClickRepeatFreq),aF=function(){s&&clearInterval(s);s=null;b(document).unbind("mouseup.jsp",aF)};b(document).bind("mouseup.jsp",aF);return false}})}if(aB){F.bind("mousedown.jsp",function(aH){if(aH.originalTarget==c||aH.originalTarget==aH.currentTarget){var aG=b(this),s=setInterval(function(){var aI=aG.offset(),aJ=aH.pageX-aI.left;if(X+ao<aJ){T(X+au.trackClickSpeed)}else{if(aJ<X){T(X-au.trackClickSpeed)}else{aF()}}},au.trackClickRepeatFreq),aF=function(){s&&clearInterval(s);s=null;b(document).unbind("mouseup.jsp",aF)};b(document).bind("mouseup.jsp",aF);return false}})}}function w(){F&&F.unbind("mousedown.jsp");al&&al.unbind("mousedown.jsp")}function ar(){b("html").unbind("dragstart.jsp selectstart.jsp mousemove.jsp mouseup.jsp mouseleave.jsp");ap&&ap.removeClass("jspActive");h&&h.removeClass("jspActive")}function S(s,aF){if(!av){return}if(s<0){s=0}else{if(s>i){s=i}}if(aF==c){aF=au.animateScroll}if(aF){N.animate(ap,"top",s,aa)}else{ap.css("top",s);aa(s)}}function aa(aF){if(aF==c){aF=ap.position().top}aj.scrollTop(0);H=aF;var aI=H==0,aG=H==i,aH=aF/i,s=-aH*(W-v);if(ag!=aI||aD!=aG){ag=aI;aD=aG;C.trigger("jsp-arrow-change",[ag,aD,M,k])}u(aI,aG);V.css("top",s);C.trigger("jsp-scroll-y",[-s,aI,aG])}function T(aF,s){if(!aB){return}if(aF<0){aF=0}else{if(aF>j){aF=j}}if(s==c){s=au.animateScroll}if(s){N.animate(h,"left",aF,ab)}else{h.css("left",aF);ab(aF)}}function ab(aF){if(aF==c){aF=h.position().left}aj.scrollTop(0);X=aF;var aI=X==0,aH=X==j,aG=aF/j,s=-aG*(Q-ah);if(M!=aI||k!=aH){M=aI;k=aH;C.trigger("jsp-arrow-change",[ag,aD,M,k])}r(aI,aH);V.css("left",s);C.trigger("jsp-scroll-x",[-s,aI,aH])}function u(aF,s){if(au.showArrows){am[aF?"addClass":"removeClass"]("jspDisabled");ac[s?"addClass":"removeClass"]("jspDisabled")}}function r(aF,s){if(au.showArrows){at[aF?"addClass":"removeClass"]("jspDisabled");
x[s?"addClass":"removeClass"]("jspDisabled")}}function J(s,aF){var aG=s/(W-v);S(aG*i,aF)}function K(aF,s){var aG=aF/(Q-ah);T(aG*j,s)}function Y(aR,aM,aG){var aK,aH,aI,s=0,aQ=0,aF,aL,aO,aN,aP;try{aK=b(aR)}catch(aJ){return}aH=aK.outerHeight();aI=aK.outerWidth();aj.scrollTop(0);aj.scrollLeft(0);while(!aK.is(".jspPane")){s+=aK.position().top;aQ+=aK.position().left;aK=aK.offsetParent();if(/^body|html$/i.test(aK[0].nodeName)){return}}aF=aw();aL=aF+v;if(s<aF||aM){aN=s-au.verticalGutter}else{if(s+aH>aL){aN=s-v+aH+au.verticalGutter}}if(aN){J(aN,aG)}viewportLeft=ay();aO=viewportLeft+ah;if(aQ<viewportLeft||aM){aP=aQ-au.horizontalGutter}else{if(aQ+aI>aO){aP=aQ-ah+aI+au.horizontalGutter}}if(aP){K(aP,aG)}}function ay(){return -V.position().left}function aw(){return -V.position().top}function ad(){aj.unbind(Z).bind(Z,function(aI,aJ,aH,aF){var aG=X,s=H;T(X+aH*au.mouseWheelSpeed*ah/(Q-ah),false);S(H-aF*au.mouseWheelSpeed*v/(W-v),false);return aG==X&&s==H})}function n(){aj.unbind(Z)}function ax(){return false}function I(){V.unbind("focus.jsp").bind("focus.jsp",function(s){if(s.target===V[0]){return}Y(s.target,false)})}function D(){V.unbind("focus.jsp")}function P(){var aF,s;C.attr("tabindex",0).unbind("keydown.jsp").bind("keydown.jsp",function(aJ){if(aJ.target!==C[0]){return}var aH=X,aG=H,aI=aF?2:16;switch(aJ.keyCode){case 40:S(H+aI,false);break;case 38:S(H-aI,false);break;case 34:case 32:J(aw()+Math.max(32,v)-16);break;case 33:J(aw()-v+16);break;case 35:J(W-v);break;case 36:J(0);break;case 39:T(X+aI,false);break;case 37:T(X-aI,false);break}if(!(aH==X&&aG==H)){aF=true;clearTimeout(s);s=setTimeout(function(){aF=false},260);return false}});if(au.hideFocus){C.css("outline","none");if("hideFocus" in aj[0]){C.attr("hideFocus",true)}}else{C.css("outline","");if("hideFocus" in aj[0]){C.attr("hideFocus",false)}}}function O(){C.attr("tabindex","-1").removeAttr("tabindex").unbind("keydown.jsp")}function B(){if(location.hash&&location.hash.length>1){var aG,aF;try{aG=b(location.hash)}catch(s){return}if(aG.length&&V.find(aG)){if(aj.scrollTop()==0){aF=setInterval(function(){if(aj.scrollTop()>0){Y(location.hash,true);b(document).scrollTop(aj.position().top);clearInterval(aF)}},50)}else{Y(location.hash,true);b(document).scrollTop(aj.position().top)}}}}function af(){b("a.jspHijack").unbind("click.jsp-hijack").removeClass("jspHijack")}function m(){af();b("a[href^=#]").addClass("jspHijack").bind("click.jsp-hijack",function(){var s=this.href.split("#"),aF;if(s.length>1){aF=s[1];if(aF.length>0&&V.find("#"+aF).length>0){Y("#"+aF,true);return false}}})}b.extend(N,{reinitialise:function(aF){aF=b.extend({},aF,au);an(aF)},scrollToElement:function(aG,aF,s){Y(aG,aF,s)},scrollTo:function(aG,s,aF){K(aG,aF);J(s,aF)},scrollToX:function(aF,s){K(aF,s)},scrollToY:function(s,aF){J(s,aF)},scrollBy:function(aF,s,aG){N.scrollByX(aF,aG);N.scrollByY(s,aG)},scrollByX:function(s,aG){var aF=ay()+s,aH=aF/(Q-ah);T(aH*j,aG)},scrollByY:function(s,aG){var aF=aw()+s,aH=aF/(W-v);S(aH*i,aG)},animate:function(aF,aI,s,aH){var aG={};aG[aI]=s;aF.animate(aG,{duration:au.animateDuration,ease:au.animateEase,queue:false,step:aH})},getContentPositionX:function(){return ay()},getContentPositionY:function(){return aw()},getIsScrollableH:function(){return aB},getIsScrollableV:function(){return av},getContentPane:function(){return V},scrollToBottom:function(s){S(i,s)},hijackInternalLinks:function(){m()}})}f=b.extend({},b.fn.jScrollPane.defaults,f);var e;this.each(function(){var g=b(this),h=g.data("jsp");if(h){h.reinitialise(f)}else{h=new d(g,f);g.data("jsp",h)}e=e?e.add(g):g});return e};b.fn.jScrollPane.defaults={showArrows:false,maintainPosition:true,clickOnTrack:true,autoReinitialise:false,autoReinitialiseDelay:500,verticalDragMinHeight:0,verticalDragMaxHeight:99999,horizontalDragMinWidth:0,horizontalDragMaxWidth:99999,animateScroll:false,animateDuration:300,animateEase:"linear",hijackInternalLinks:false,verticalGutter:4,horizontalGutter:4,mouseWheelSpeed:30,arrowButtonSpeed:30,arrowRepeatFreq:100,arrowScrollOnHover:false,trackClickSpeed:30,trackClickRepeatFreq:100,verticalArrowPositions:"split",horizontalArrowPositions:"split",enableKeyboardNavigation:true,hideFocus:false}
})(jQuery,this);


/*! Copyright (c) 2010 Brandon Aaron (http://brandonaaron.net)
 * Licensed under the MIT License (LICENSE.txt).
 *
 * Thanks to: http://adomas.org/javascript-mouse-wheel/ for some pointers.
 * Thanks to: Mathias Bank(http://www.mathias-bank.de) for a scope bug fix.
 * Thanks to: Seamus Leahy for adding deltaX and deltaY
 *
 * Version: 3.0.4
 * 
 * Requires: 1.2.2+
 */

(function($) {

var types = ['DOMMouseScroll', 'mousewheel'];

$.event.special.mousewheel = {
    setup: function() {
        if ( this.addEventListener ) {
            for ( var i=types.length; i; ) {
                this.addEventListener( types[--i], handler, false );
            }
        } else {
            this.onmousewheel = handler;
        }
    },
    
    teardown: function() {
        if ( this.removeEventListener ) {
            for ( var i=types.length; i; ) {
                this.removeEventListener( types[--i], handler, false );
            }
        } else {
            this.onmousewheel = null;
        }
    }
};

$.fn.extend({
    mousewheel: function(fn) {
        return fn ? this.bind("mousewheel", fn) : this.trigger("mousewheel");
    },
    
    unmousewheel: function(fn) {
        return this.unbind("mousewheel", fn);
    }
});


function handler(event) {
    var orgEvent = event || window.event, args = [].slice.call( arguments, 1 ), delta = 0, returnValue = true, deltaX = 0, deltaY = 0;
    event = $.event.fix(orgEvent);
    event.type = "mousewheel";
    
    // Old school scrollwheel delta
    if ( event.wheelDelta ) { delta = event.wheelDelta/120; }
    if ( event.detail     ) { delta = -event.detail/3; }
    
    // New school multidimensional scroll (touchpads) deltas
    deltaY = delta;
    
    // Gecko
    if ( orgEvent.axis !== undefined && orgEvent.axis === orgEvent.HORIZONTAL_AXIS ) {
        deltaY = 0;
        deltaX = -1*delta;
    }
    
    // Webkit
    if ( orgEvent.wheelDeltaY !== undefined ) { deltaY = orgEvent.wheelDeltaY/120; }
    if ( orgEvent.wheelDeltaX !== undefined ) { deltaX = -1*orgEvent.wheelDeltaX/120; }
    
    // Add event and delta to the front of the arguments
    args.unshift(event, delta, deltaX, deltaY);
    
    return $.event.handle.apply(this, args);
}

})(jQuery);

/*
 * jQuery Cycle Plugin (with Transition Definitions)
 * Examples and documentation at: http://jquery.malsup.com/cycle/
 * Copyright (c) 2007-2010 M. Alsup
 * Version: 2.88 (08-JUN-2010)
 * Dual licensed under the MIT and GPL licenses.
 * http://jquery.malsup.com/license.html
 * Requires: jQuery v1.2.6 or later
 */
(function($){var ver="2.88";if($.support==undefined){$.support={opacity:!($.browser.msie)};}function debug(s){if($.fn.cycle.debug){log(s);}}function log(){if(window.console&&window.console.log){window.console.log("[cycle] "+Array.prototype.join.call(arguments," "));}}$.fn.cycle=function(options,arg2){var o={s:this.selector,c:this.context};if(this.length===0&&options!="stop"){if(!$.isReady&&o.s){log("DOM not ready, queuing slideshow");$(function(){$(o.s,o.c).cycle(options,arg2);});return this;}log("terminating; zero elements found by selector"+($.isReady?"":" (DOM not ready)"));return this;}return this.each(function(){var opts=handleArguments(this,options,arg2);if(opts===false){return;}opts.updateActivePagerLink=opts.updateActivePagerLink||$.fn.cycle.updateActivePagerLink;if(this.cycleTimeout){clearTimeout(this.cycleTimeout);}this.cycleTimeout=this.cyclePause=0;var $cont=$(this);var $slides=opts.slideExpr?$(opts.slideExpr,this):$cont.children();var els=$slides.get();if(els.length<2){log("terminating; too few slides: "+els.length);return;}var opts2=buildOptions($cont,$slides,els,opts,o);if(opts2===false){return;}var startTime=opts2.continuous?10:getTimeout(els[opts2.currSlide],els[opts2.nextSlide],opts2,!opts2.rev);if(startTime){startTime+=(opts2.delay||0);if(startTime<10){startTime=10;}debug("first timeout: "+startTime);this.cycleTimeout=setTimeout(function(){go(els,opts2,0,(!opts2.rev&&!opts.backwards));},startTime);}});};function handleArguments(cont,options,arg2){if(cont.cycleStop==undefined){cont.cycleStop=0;}if(options===undefined||options===null){options={};}if(options.constructor==String){switch(options){case"destroy":case"stop":var opts=$(cont).data("cycle.opts");if(!opts){return false;}cont.cycleStop++;if(cont.cycleTimeout){clearTimeout(cont.cycleTimeout);}cont.cycleTimeout=0;$(cont).removeData("cycle.opts");if(options=="destroy"){destroy(opts);}return false;case"toggle":cont.cyclePause=(cont.cyclePause===1)?0:1;checkInstantResume(cont.cyclePause,arg2,cont);return false;case"pause":cont.cyclePause=1;return false;case"resume":cont.cyclePause=0;checkInstantResume(false,arg2,cont);return false;case"prev":case"next":var opts=$(cont).data("cycle.opts");if(!opts){log('options not found, "prev/next" ignored');return false;}$.fn.cycle[options](opts);return false;default:options={fx:options};}return options;}else{if(options.constructor==Number){var num=options;options=$(cont).data("cycle.opts");if(!options){log("options not found, can not advance slide");return false;}if(num<0||num>=options.elements.length){log("invalid slide index: "+num);return false;}options.nextSlide=num;if(cont.cycleTimeout){clearTimeout(cont.cycleTimeout);cont.cycleTimeout=0;}if(typeof arg2=="string"){options.oneTimeFx=arg2;}go(options.elements,options,1,num>=options.currSlide);return false;}}return options;function checkInstantResume(isPaused,arg2,cont){if(!isPaused&&arg2===true){var options=$(cont).data("cycle.opts");if(!options){log("options not found, can not resume");return false;}if(cont.cycleTimeout){clearTimeout(cont.cycleTimeout);cont.cycleTimeout=0;}go(options.elements,options,1,(!opts.rev&&!opts.backwards));}}}function removeFilter(el,opts){if(!$.support.opacity&&opts.cleartype&&el.style.filter){try{el.style.removeAttribute("filter");}catch(smother){}}}function destroy(opts){if(opts.next){$(opts.next).unbind(opts.prevNextEvent);}if(opts.prev){$(opts.prev).unbind(opts.prevNextEvent);}if(opts.pager||opts.pagerAnchorBuilder){$.each(opts.pagerAnchors||[],function(){this.unbind().remove();});}opts.pagerAnchors=null;if(opts.destroy){opts.destroy(opts);}}function buildOptions($cont,$slides,els,options,o){var opts=$.extend({},$.fn.cycle.defaults,options||{},$.metadata?$cont.metadata():$.meta?$cont.data():{});if(opts.autostop){opts.countdown=opts.autostopCount||els.length;}var cont=$cont[0];$cont.data("cycle.opts",opts);opts.$cont=$cont;opts.stopCount=cont.cycleStop;opts.elements=els;opts.before=opts.before?[opts.before]:[];opts.after=opts.after?[opts.after]:[];opts.after.unshift(function(){opts.busy=0;});if(!$.support.opacity&&opts.cleartype){opts.after.push(function(){removeFilter(this,opts);});}if(opts.continuous){opts.after.push(function(){go(els,opts,0,(!opts.rev&&!opts.backwards));});}saveOriginalOpts(opts);if(!$.support.opacity&&opts.cleartype&&!opts.cleartypeNoBg){clearTypeFix($slides);}if($cont.css("position")=="static"){$cont.css("position","relative");}if(opts.width){$cont.width(opts.width);}if(opts.height&&opts.height!="auto"){$cont.height(opts.height);}if(opts.startingSlide){opts.startingSlide=parseInt(opts.startingSlide);}else{if(opts.backwards){opts.startingSlide=els.length-1;}}if(opts.random){opts.randomMap=[];for(var i=0;i<els.length;i++){opts.randomMap.push(i);}opts.randomMap.sort(function(a,b){return Math.random()-0.5;});opts.randomIndex=1;opts.startingSlide=opts.randomMap[1];}else{if(opts.startingSlide>=els.length){opts.startingSlide=0;}}opts.currSlide=opts.startingSlide||0;var first=opts.startingSlide;$slides.css({position:"absolute",top:0,left:0}).hide().each(function(i){var z;if(opts.backwards){z=first?i<=first?els.length+(i-first):first-i:els.length-i;}else{z=first?i>=first?els.length-(i-first):first-i:els.length-i;}$(this).css("z-index",z);});$(els[first]).css("opacity",1).show();removeFilter(els[first],opts);if(opts.fit&&opts.width){$slides.width(opts.width);}if(opts.fit&&opts.height&&opts.height!="auto"){$slides.height(opts.height);}var reshape=opts.containerResize&&!$cont.innerHeight();if(reshape){var maxw=0,maxh=0;for(var j=0;j<els.length;j++){var $e=$(els[j]),e=$e[0],w=$e.outerWidth(),h=$e.outerHeight();if(!w){w=e.offsetWidth||e.width||$e.attr("width");}if(!h){h=e.offsetHeight||e.height||$e.attr("height");}maxw=w>maxw?w:maxw;maxh=h>maxh?h:maxh;}if(maxw>0&&maxh>0){$cont.css({width:maxw+"px",height:maxh+"px"});}}if(opts.pause){$cont.hover(function(){this.cyclePause=1;},function(){this.cyclePause=0;});}if(supportMultiTransitions(opts)===false){return false;}var requeue=false;options.requeueAttempts=options.requeueAttempts||0;$slides.each(function(){var $el=$(this);this.cycleH=(opts.fit&&opts.height)?opts.height:($el.height()||this.offsetHeight||this.height||$el.attr("height")||0);this.cycleW=(opts.fit&&opts.width)?opts.width:($el.width()||this.offsetWidth||this.width||$el.attr("width")||0);if($el.is("img")){var loadingIE=($.browser.msie&&this.cycleW==28&&this.cycleH==30&&!this.complete);var loadingFF=($.browser.mozilla&&this.cycleW==34&&this.cycleH==19&&!this.complete);var loadingOp=($.browser.opera&&((this.cycleW==42&&this.cycleH==19)||(this.cycleW==37&&this.cycleH==17))&&!this.complete);var loadingOther=(this.cycleH==0&&this.cycleW==0&&!this.complete);if(loadingIE||loadingFF||loadingOp||loadingOther){if(o.s&&opts.requeueOnImageNotLoaded&&++options.requeueAttempts<100){log(options.requeueAttempts," - img slide not loaded, requeuing slideshow: ",this.src,this.cycleW,this.cycleH);setTimeout(function(){$(o.s,o.c).cycle(options);},opts.requeueTimeout);requeue=true;return false;}else{log("could not determine size of image: "+this.src,this.cycleW,this.cycleH);}}}return true;});if(requeue){return false;}opts.cssBefore=opts.cssBefore||{};opts.animIn=opts.animIn||{};opts.animOut=opts.animOut||{};$slides.not(":eq("+first+")").css(opts.cssBefore);if(opts.cssFirst){$($slides[first]).css(opts.cssFirst);}if(opts.timeout){opts.timeout=parseInt(opts.timeout);if(opts.speed.constructor==String){opts.speed=$.fx.speeds[opts.speed]||parseInt(opts.speed);}if(!opts.sync){opts.speed=opts.speed/2;}var buffer=opts.fx=="shuffle"?500:250;while((opts.timeout-opts.speed)<buffer){opts.timeout+=opts.speed;}}if(opts.easing){opts.easeIn=opts.easeOut=opts.easing;}if(!opts.speedIn){opts.speedIn=opts.speed;}if(!opts.speedOut){opts.speedOut=opts.speed;}opts.slideCount=els.length;opts.currSlide=opts.lastSlide=first;if(opts.random){if(++opts.randomIndex==els.length){opts.randomIndex=0;}opts.nextSlide=opts.randomMap[opts.randomIndex];}else{if(opts.backwards){opts.nextSlide=opts.startingSlide==0?(els.length-1):opts.startingSlide-1;}else{opts.nextSlide=opts.startingSlide>=(els.length-1)?0:opts.startingSlide+1;}}if(!opts.multiFx){var init=$.fn.cycle.transitions[opts.fx];if($.isFunction(init)){init($cont,$slides,opts);}else{if(opts.fx!="custom"&&!opts.multiFx){log("unknown transition: "+opts.fx,"; slideshow terminating");return false;}}}var e0=$slides[first];if(opts.before.length){opts.before[0].apply(e0,[e0,e0,opts,true]);}if(opts.after.length>1){opts.after[1].apply(e0,[e0,e0,opts,true]);}if(opts.next){$(opts.next).bind(opts.prevNextEvent,function(){return advance(opts,opts.rev?-1:1);});}if(opts.prev){$(opts.prev).bind(opts.prevNextEvent,function(){return advance(opts,opts.rev?1:-1);});}if(opts.pager||opts.pagerAnchorBuilder){buildPager(els,opts);}exposeAddSlide(opts,els);return opts;}function saveOriginalOpts(opts){opts.original={before:[],after:[]};opts.original.cssBefore=$.extend({},opts.cssBefore);opts.original.cssAfter=$.extend({},opts.cssAfter);opts.original.animIn=$.extend({},opts.animIn);opts.original.animOut=$.extend({},opts.animOut);$.each(opts.before,function(){opts.original.before.push(this);});$.each(opts.after,function(){opts.original.after.push(this);});}function supportMultiTransitions(opts){var i,tx,txs=$.fn.cycle.transitions;if(opts.fx.indexOf(",")>0){opts.multiFx=true;opts.fxs=opts.fx.replace(/\s*/g,"").split(",");for(i=0;i<opts.fxs.length;i++){var fx=opts.fxs[i];tx=txs[fx];if(!tx||!txs.hasOwnProperty(fx)||!$.isFunction(tx)){log("discarding unknown transition: ",fx);opts.fxs.splice(i,1);i--;}}if(!opts.fxs.length){log("No valid transitions named; slideshow terminating.");return false;}}else{if(opts.fx=="all"){opts.multiFx=true;opts.fxs=[];for(p in txs){tx=txs[p];if(txs.hasOwnProperty(p)&&$.isFunction(tx)){opts.fxs.push(p);}}}}if(opts.multiFx&&opts.randomizeEffects){var r1=Math.floor(Math.random()*20)+30;for(i=0;i<r1;i++){var r2=Math.floor(Math.random()*opts.fxs.length);opts.fxs.push(opts.fxs.splice(r2,1)[0]);}debug("randomized fx sequence: ",opts.fxs);}return true;}function exposeAddSlide(opts,els){opts.addSlide=function(newSlide,prepend){var $s=$(newSlide),s=$s[0];if(!opts.autostopCount){opts.countdown++;}els[prepend?"unshift":"push"](s);if(opts.els){opts.els[prepend?"unshift":"push"](s);}opts.slideCount=els.length;$s.css("position","absolute");$s[prepend?"prependTo":"appendTo"](opts.$cont);if(prepend){opts.currSlide++;opts.nextSlide++;}if(!$.support.opacity&&opts.cleartype&&!opts.cleartypeNoBg){clearTypeFix($s);}if(opts.fit&&opts.width){$s.width(opts.width);}if(opts.fit&&opts.height&&opts.height!="auto"){$slides.height(opts.height);}s.cycleH=(opts.fit&&opts.height)?opts.height:$s.height();s.cycleW=(opts.fit&&opts.width)?opts.width:$s.width();$s.css(opts.cssBefore);if(opts.pager||opts.pagerAnchorBuilder){$.fn.cycle.createPagerAnchor(els.length-1,s,$(opts.pager),els,opts);}if($.isFunction(opts.onAddSlide)){opts.onAddSlide($s);}else{$s.hide();}};}$.fn.cycle.resetState=function(opts,fx){fx=fx||opts.fx;opts.before=[];opts.after=[];opts.cssBefore=$.extend({},opts.original.cssBefore);opts.cssAfter=$.extend({},opts.original.cssAfter);opts.animIn=$.extend({},opts.original.animIn);opts.animOut=$.extend({},opts.original.animOut);opts.fxFn=null;$.each(opts.original.before,function(){opts.before.push(this);});$.each(opts.original.after,function(){opts.after.push(this);});var init=$.fn.cycle.transitions[fx];if($.isFunction(init)){init(opts.$cont,$(opts.elements),opts);}};function go(els,opts,manual,fwd){if(manual&&opts.busy&&opts.manualTrump){debug("manualTrump in go(), stopping active transition");$(els).stop(true,true);opts.busy=false;}if(opts.busy){debug("transition active, ignoring new tx request");return;}var p=opts.$cont[0],curr=els[opts.currSlide],next=els[opts.nextSlide];if(p.cycleStop!=opts.stopCount||p.cycleTimeout===0&&!manual){return;}if(!manual&&!p.cyclePause&&!opts.bounce&&((opts.autostop&&(--opts.countdown<=0))||(opts.nowrap&&!opts.random&&opts.nextSlide<opts.currSlide))){if(opts.end){opts.end(opts);}return;}var changed=false;if((manual||!p.cyclePause)&&(opts.nextSlide!=opts.currSlide)){changed=true;var fx=opts.fx;curr.cycleH=curr.cycleH||$(curr).height();curr.cycleW=curr.cycleW||$(curr).width();next.cycleH=next.cycleH||$(next).height();next.cycleW=next.cycleW||$(next).width();if(opts.multiFx){if(opts.lastFx==undefined||++opts.lastFx>=opts.fxs.length){opts.lastFx=0;}fx=opts.fxs[opts.lastFx];opts.currFx=fx;}if(opts.oneTimeFx){fx=opts.oneTimeFx;opts.oneTimeFx=null;}$.fn.cycle.resetState(opts,fx);if(opts.before.length){$.each(opts.before,function(i,o){if(p.cycleStop!=opts.stopCount){return;}o.apply(next,[curr,next,opts,fwd]);});}var after=function(){$.each(opts.after,function(i,o){if(p.cycleStop!=opts.stopCount){return;}o.apply(next,[curr,next,opts,fwd]);});};debug("tx firing; currSlide: "+opts.currSlide+"; nextSlide: "+opts.nextSlide);opts.busy=1;if(opts.fxFn){opts.fxFn(curr,next,opts,after,fwd,manual&&opts.fastOnEvent);}else{if($.isFunction($.fn.cycle[opts.fx])){$.fn.cycle[opts.fx](curr,next,opts,after,fwd,manual&&opts.fastOnEvent);}else{$.fn.cycle.custom(curr,next,opts,after,fwd,manual&&opts.fastOnEvent);}}}if(changed||opts.nextSlide==opts.currSlide){opts.lastSlide=opts.currSlide;if(opts.random){opts.currSlide=opts.nextSlide;if(++opts.randomIndex==els.length){opts.randomIndex=0;}opts.nextSlide=opts.randomMap[opts.randomIndex];if(opts.nextSlide==opts.currSlide){opts.nextSlide=(opts.currSlide==opts.slideCount-1)?0:opts.currSlide+1;}}else{if(opts.backwards){var roll=(opts.nextSlide-1)<0;if(roll&&opts.bounce){opts.backwards=!opts.backwards;opts.nextSlide=1;opts.currSlide=0;}else{opts.nextSlide=roll?(els.length-1):opts.nextSlide-1;opts.currSlide=roll?0:opts.nextSlide+1;}}else{var roll=(opts.nextSlide+1)==els.length;if(roll&&opts.bounce){opts.backwards=!opts.backwards;opts.nextSlide=els.length-2;opts.currSlide=els.length-1;}else{opts.nextSlide=roll?0:opts.nextSlide+1;opts.currSlide=roll?els.length-1:opts.nextSlide-1;}}}}if(changed&&opts.pager){opts.updateActivePagerLink(opts.pager,opts.currSlide,opts.activePagerClass);}var ms=0;if(opts.timeout&&!opts.continuous){ms=getTimeout(els[opts.currSlide],els[opts.nextSlide],opts,fwd);}else{if(opts.continuous&&p.cyclePause){ms=10;}}if(ms>0){p.cycleTimeout=setTimeout(function(){go(els,opts,0,(!opts.rev&&!opts.backwards));},ms);}}$.fn.cycle.updateActivePagerLink=function(pager,currSlide,clsName){$(pager).each(function(){$(this).children().removeClass(clsName).eq(currSlide).addClass(clsName);});};function getTimeout(curr,next,opts,fwd){if(opts.timeoutFn){var t=opts.timeoutFn.call(curr,curr,next,opts,fwd);while((t-opts.speed)<250){t+=opts.speed;}debug("calculated timeout: "+t+"; speed: "+opts.speed);if(t!==false){return t;}}return opts.timeout;}$.fn.cycle.next=function(opts){advance(opts,opts.rev?-1:1);};$.fn.cycle.prev=function(opts){advance(opts,opts.rev?1:-1);};function advance(opts,val){var els=opts.elements;var p=opts.$cont[0],timeout=p.cycleTimeout;if(timeout){clearTimeout(timeout);p.cycleTimeout=0;}if(opts.random&&val<0){opts.randomIndex--;if(--opts.randomIndex==-2){opts.randomIndex=els.length-2;}else{if(opts.randomIndex==-1){opts.randomIndex=els.length-1;}}opts.nextSlide=opts.randomMap[opts.randomIndex];}else{if(opts.random){opts.nextSlide=opts.randomMap[opts.randomIndex];}else{opts.nextSlide=opts.currSlide+val;if(opts.nextSlide<0){if(opts.nowrap){return false;}opts.nextSlide=els.length-1;}else{if(opts.nextSlide>=els.length){if(opts.nowrap){return false;}opts.nextSlide=0;}}}}var cb=opts.onPrevNextEvent||opts.prevNextClick;if($.isFunction(cb)){cb(val>0,opts.nextSlide,els[opts.nextSlide]);}go(els,opts,1,val>=0);return false;}function buildPager(els,opts){var $p=$(opts.pager);$.each(els,function(i,o){$.fn.cycle.createPagerAnchor(i,o,$p,els,opts);});opts.updateActivePagerLink(opts.pager,opts.startingSlide,opts.activePagerClass);}$.fn.cycle.createPagerAnchor=function(i,el,$p,els,opts){var a;if($.isFunction(opts.pagerAnchorBuilder)){a=opts.pagerAnchorBuilder(i,el);debug("pagerAnchorBuilder("+i+", el) returned: "+a);}else{a='<a href="#">'+(i+1)+"</a>";}if(!a){return;}var $a=$(a);if($a.parents("body").length===0){var arr=[];if($p.length>1){$p.each(function(){var $clone=$a.clone(true);$(this).append($clone);arr.push($clone[0]);});$a=$(arr);}else{$a.appendTo($p);}}opts.pagerAnchors=opts.pagerAnchors||[];opts.pagerAnchors.push($a);$a.bind(opts.pagerEvent,function(e){e.preventDefault();opts.nextSlide=i;var p=opts.$cont[0],timeout=p.cycleTimeout;if(timeout){clearTimeout(timeout);p.cycleTimeout=0;}var cb=opts.onPagerEvent||opts.pagerClick;if($.isFunction(cb)){cb(opts.nextSlide,els[opts.nextSlide]);}go(els,opts,1,opts.currSlide<i);});if(!/^click/.test(opts.pagerEvent)&&!opts.allowPagerClickBubble){$a.bind("click.cycle",function(){return false;});}if(opts.pauseOnPagerHover){$a.hover(function(){opts.$cont[0].cyclePause=1;},function(){opts.$cont[0].cyclePause=0;});}};$.fn.cycle.hopsFromLast=function(opts,fwd){var hops,l=opts.lastSlide,c=opts.currSlide;if(fwd){hops=c>l?c-l:opts.slideCount-l;}else{hops=c<l?l-c:l+opts.slideCount-c;}return hops;};function clearTypeFix($slides){debug("applying clearType background-color hack");function hex(s){s=parseInt(s).toString(16);return s.length<2?"0"+s:s;}function getBg(e){for(;e&&e.nodeName.toLowerCase()!="html";e=e.parentNode){var v=$.css(e,"background-color");if(v.indexOf("rgb")>=0){var rgb=v.match(/\d+/g);return"#"+hex(rgb[0])+hex(rgb[1])+hex(rgb[2]);}if(v&&v!="transparent"){return v;}}return"#ffffff";}$slides.each(function(){$(this).css("background-color",getBg(this));});}$.fn.cycle.commonReset=function(curr,next,opts,w,h,rev){$(opts.elements).not(curr).hide();opts.cssBefore.opacity=1;opts.cssBefore.display="block";if(w!==false&&next.cycleW>0){opts.cssBefore.width=next.cycleW;}if(h!==false&&next.cycleH>0){opts.cssBefore.height=next.cycleH;}opts.cssAfter=opts.cssAfter||{};opts.cssAfter.display="none";$(curr).css("zIndex",opts.slideCount+(rev===true?1:0));$(next).css("zIndex",opts.slideCount+(rev===true?0:1));};$.fn.cycle.custom=function(curr,next,opts,cb,fwd,speedOverride){var $l=$(curr),$n=$(next);var speedIn=opts.speedIn,speedOut=opts.speedOut,easeIn=opts.easeIn,easeOut=opts.easeOut;$n.css(opts.cssBefore);if(speedOverride){if(typeof speedOverride=="number"){speedIn=speedOut=speedOverride;}else{speedIn=speedOut=1;}easeIn=easeOut=null;}var fn=function(){$n.animate(opts.animIn,speedIn,easeIn,cb);};$l.animate(opts.animOut,speedOut,easeOut,function(){if(opts.cssAfter){$l.css(opts.cssAfter);}if(!opts.sync){fn();}});if(opts.sync){fn();}};$.fn.cycle.transitions={fade:function($cont,$slides,opts){$slides.not(":eq("+opts.currSlide+")").css("opacity",0);opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts);opts.cssBefore.opacity=0;});opts.animIn={opacity:1};opts.animOut={opacity:0};opts.cssBefore={top:0,left:0};}};$.fn.cycle.ver=function(){return ver;};$.fn.cycle.defaults={fx:"fade",timeout:4000,timeoutFn:null,continuous:0,speed:1000,speedIn:null,speedOut:null,next:null,prev:null,onPrevNextEvent:null,prevNextEvent:"click.cycle",pager:null,onPagerEvent:null,pagerEvent:"click.cycle",allowPagerClickBubble:false,pagerAnchorBuilder:null,before:null,after:null,end:null,easing:null,easeIn:null,easeOut:null,shuffle:null,animIn:null,animOut:null,cssBefore:null,cssAfter:null,fxFn:null,height:"auto",startingSlide:0,sync:1,random:0,fit:0,containerResize:1,pause:0,pauseOnPagerHover:0,autostop:0,autostopCount:0,delay:0,slideExpr:null,cleartype:!$.support.opacity,cleartypeNoBg:false,nowrap:0,fastOnEvent:0,randomizeEffects:1,rev:0,manualTrump:true,requeueOnImageNotLoaded:true,requeueTimeout:250,activePagerClass:"activeSlide",updateActivePagerLink:null,backwards:false};})(jQuery);
/*
 * jQuery Cycle Plugin Transition Definitions
 * This script is a plugin for the jQuery Cycle Plugin
 * Examples and documentation at: http://malsup.com/jquery/cycle/
 * Copyright (c) 2007-2010 M. Alsup
 * Version:	 2.72
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 */
(function($){$.fn.cycle.transitions.none=function($cont,$slides,opts){opts.fxFn=function(curr,next,opts,after){$(next).show();$(curr).hide();after();};};$.fn.cycle.transitions.scrollUp=function($cont,$slides,opts){$cont.css("overflow","hidden");opts.before.push($.fn.cycle.commonReset);var h=$cont.height();opts.cssBefore={top:h,left:0};opts.cssFirst={top:0};opts.animIn={top:0};opts.animOut={top:-h};};$.fn.cycle.transitions.scrollDown=function($cont,$slides,opts){$cont.css("overflow","hidden");opts.before.push($.fn.cycle.commonReset);var h=$cont.height();opts.cssFirst={top:0};opts.cssBefore={top:-h,left:0};opts.animIn={top:0};opts.animOut={top:h};};$.fn.cycle.transitions.scrollLeft=function($cont,$slides,opts){$cont.css("overflow","hidden");opts.before.push($.fn.cycle.commonReset);var w=$cont.width();opts.cssFirst={left:0};opts.cssBefore={left:w,top:0};opts.animIn={left:0};opts.animOut={left:0-w};};$.fn.cycle.transitions.scrollRight=function($cont,$slides,opts){$cont.css("overflow","hidden");opts.before.push($.fn.cycle.commonReset);var w=$cont.width();opts.cssFirst={left:0};opts.cssBefore={left:-w,top:0};opts.animIn={left:0};opts.animOut={left:w};};$.fn.cycle.transitions.scrollHorz=function($cont,$slides,opts){$cont.css("overflow","hidden").width();opts.before.push(function(curr,next,opts,fwd){$.fn.cycle.commonReset(curr,next,opts);opts.cssBefore.left=fwd?(next.cycleW-1):(1-next.cycleW);opts.animOut.left=fwd?-curr.cycleW:curr.cycleW;});opts.cssFirst={left:0};opts.cssBefore={top:0};opts.animIn={left:0};opts.animOut={top:0};};$.fn.cycle.transitions.scrollVert=function($cont,$slides,opts){$cont.css("overflow","hidden");opts.before.push(function(curr,next,opts,fwd){$.fn.cycle.commonReset(curr,next,opts);opts.cssBefore.top=fwd?(1-next.cycleH):(next.cycleH-1);opts.animOut.top=fwd?curr.cycleH:-curr.cycleH;});opts.cssFirst={top:0};opts.cssBefore={left:0};opts.animIn={top:0};opts.animOut={left:0};};$.fn.cycle.transitions.slideX=function($cont,$slides,opts){opts.before.push(function(curr,next,opts){$(opts.elements).not(curr).hide();$.fn.cycle.commonReset(curr,next,opts,false,true);opts.animIn.width=next.cycleW;});opts.cssBefore={left:0,top:0,width:0};opts.animIn={width:"show"};opts.animOut={width:0};};$.fn.cycle.transitions.slideY=function($cont,$slides,opts){opts.before.push(function(curr,next,opts){$(opts.elements).not(curr).hide();$.fn.cycle.commonReset(curr,next,opts,true,false);opts.animIn.height=next.cycleH;});opts.cssBefore={left:0,top:0,height:0};opts.animIn={height:"show"};opts.animOut={height:0};};$.fn.cycle.transitions.shuffle=function($cont,$slides,opts){var i,w=$cont.css("overflow","visible").width();$slides.css({left:0,top:0});opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts,true,true,true);});if(!opts.speedAdjusted){opts.speed=opts.speed/2;opts.speedAdjusted=true;}opts.random=0;opts.shuffle=opts.shuffle||{left:-w,top:15};opts.els=[];for(i=0;i<$slides.length;i++){opts.els.push($slides[i]);}for(i=0;i<opts.currSlide;i++){opts.els.push(opts.els.shift());}opts.fxFn=function(curr,next,opts,cb,fwd){var $el=fwd?$(curr):$(next);$(next).css(opts.cssBefore);var count=opts.slideCount;$el.animate(opts.shuffle,opts.speedIn,opts.easeIn,function(){var hops=$.fn.cycle.hopsFromLast(opts,fwd);for(var k=0;k<hops;k++){fwd?opts.els.push(opts.els.shift()):opts.els.unshift(opts.els.pop());}if(fwd){for(var i=0,len=opts.els.length;i<len;i++){$(opts.els[i]).css("z-index",len-i+count);}}else{var z=$(curr).css("z-index");$el.css("z-index",parseInt(z)+1+count);}$el.animate({left:0,top:0},opts.speedOut,opts.easeOut,function(){$(fwd?this:curr).hide();if(cb){cb();}});});};opts.cssBefore={display:"block",opacity:1,top:0,left:0};};$.fn.cycle.transitions.turnUp=function($cont,$slides,opts){opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts,true,false);opts.cssBefore.top=next.cycleH;opts.animIn.height=next.cycleH;});opts.cssFirst={top:0};opts.cssBefore={left:0,height:0};opts.animIn={top:0};opts.animOut={height:0};};$.fn.cycle.transitions.turnDown=function($cont,$slides,opts){opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts,true,false);opts.animIn.height=next.cycleH;opts.animOut.top=curr.cycleH;});opts.cssFirst={top:0};opts.cssBefore={left:0,top:0,height:0};opts.animOut={height:0};};$.fn.cycle.transitions.turnLeft=function($cont,$slides,opts){opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts,false,true);opts.cssBefore.left=next.cycleW;opts.animIn.width=next.cycleW;});opts.cssBefore={top:0,width:0};opts.animIn={left:0};opts.animOut={width:0};};$.fn.cycle.transitions.turnRight=function($cont,$slides,opts){opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts,false,true);opts.animIn.width=next.cycleW;opts.animOut.left=curr.cycleW;});opts.cssBefore={top:0,left:0,width:0};opts.animIn={left:0};opts.animOut={width:0};};$.fn.cycle.transitions.zoom=function($cont,$slides,opts){opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts,false,false,true);opts.cssBefore.top=next.cycleH/2;opts.cssBefore.left=next.cycleW/2;opts.animIn={top:0,left:0,width:next.cycleW,height:next.cycleH};opts.animOut={width:0,height:0,top:curr.cycleH/2,left:curr.cycleW/2};});opts.cssFirst={top:0,left:0};opts.cssBefore={width:0,height:0};};$.fn.cycle.transitions.fadeZoom=function($cont,$slides,opts){opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts,false,false);opts.cssBefore.left=next.cycleW/2;opts.cssBefore.top=next.cycleH/2;opts.animIn={top:0,left:0,width:next.cycleW,height:next.cycleH};});opts.cssBefore={width:0,height:0};opts.animOut={opacity:0};};$.fn.cycle.transitions.blindX=function($cont,$slides,opts){var w=$cont.css("overflow","hidden").width();opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts);opts.animIn.width=next.cycleW;opts.animOut.left=curr.cycleW;});opts.cssBefore={left:w,top:0};opts.animIn={left:0};opts.animOut={left:w};};$.fn.cycle.transitions.blindY=function($cont,$slides,opts){var h=$cont.css("overflow","hidden").height();opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts);opts.animIn.height=next.cycleH;opts.animOut.top=curr.cycleH;});opts.cssBefore={top:h,left:0};opts.animIn={top:0};opts.animOut={top:h};};$.fn.cycle.transitions.blindZ=function($cont,$slides,opts){var h=$cont.css("overflow","hidden").height();var w=$cont.width();opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts);opts.animIn.height=next.cycleH;opts.animOut.top=curr.cycleH;});opts.cssBefore={top:h,left:w};opts.animIn={top:0,left:0};opts.animOut={top:h,left:w};};$.fn.cycle.transitions.growX=function($cont,$slides,opts){opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts,false,true);opts.cssBefore.left=this.cycleW/2;opts.animIn={left:0,width:this.cycleW};opts.animOut={left:0};});opts.cssBefore={width:0,top:0};};$.fn.cycle.transitions.growY=function($cont,$slides,opts){opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts,true,false);opts.cssBefore.top=this.cycleH/2;opts.animIn={top:0,height:this.cycleH};opts.animOut={top:0};});opts.cssBefore={height:0,left:0};};$.fn.cycle.transitions.curtainX=function($cont,$slides,opts){opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts,false,true,true);opts.cssBefore.left=next.cycleW/2;opts.animIn={left:0,width:this.cycleW};opts.animOut={left:curr.cycleW/2,width:0};});opts.cssBefore={top:0,width:0};};$.fn.cycle.transitions.curtainY=function($cont,$slides,opts){opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts,true,false,true);opts.cssBefore.top=next.cycleH/2;opts.animIn={top:0,height:next.cycleH};opts.animOut={top:curr.cycleH/2,height:0};});opts.cssBefore={left:0,height:0};};$.fn.cycle.transitions.cover=function($cont,$slides,opts){var d=opts.direction||"left";var w=$cont.css("overflow","hidden").width();var h=$cont.height();opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts);if(d=="right"){opts.cssBefore.left=-w;}else{if(d=="up"){opts.cssBefore.top=h;}else{if(d=="down"){opts.cssBefore.top=-h;}else{opts.cssBefore.left=w;}}}});opts.animIn={left:0,top:0};opts.animOut={opacity:1};opts.cssBefore={top:0,left:0};};$.fn.cycle.transitions.uncover=function($cont,$slides,opts){var d=opts.direction||"left";var w=$cont.css("overflow","hidden").width();var h=$cont.height();opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts,true,true,true);if(d=="right"){opts.animOut.left=w;}else{if(d=="up"){opts.animOut.top=-h;}else{if(d=="down"){opts.animOut.top=h;}else{opts.animOut.left=-w;}}}});opts.animIn={left:0,top:0};opts.animOut={opacity:1};opts.cssBefore={top:0,left:0};};$.fn.cycle.transitions.toss=function($cont,$slides,opts){var w=$cont.css("overflow","visible").width();var h=$cont.height();opts.before.push(function(curr,next,opts){$.fn.cycle.commonReset(curr,next,opts,true,true,true);if(!opts.animOut.left&&!opts.animOut.top){opts.animOut={left:w*2,top:-h/2,opacity:0};}else{opts.animOut.opacity=0;}});opts.cssBefore={left:0,top:0};opts.animIn={left:0};};$.fn.cycle.transitions.wipe=function($cont,$slides,opts){var w=$cont.css("overflow","hidden").width();var h=$cont.height();opts.cssBefore=opts.cssBefore||{};var clip;if(opts.clip){if(/l2r/.test(opts.clip)){clip="rect(0px 0px "+h+"px 0px)";}else{if(/r2l/.test(opts.clip)){clip="rect(0px "+w+"px "+h+"px "+w+"px)";}else{if(/t2b/.test(opts.clip)){clip="rect(0px "+w+"px 0px 0px)";}else{if(/b2t/.test(opts.clip)){clip="rect("+h+"px "+w+"px "+h+"px 0px)";}else{if(/zoom/.test(opts.clip)){var top=parseInt(h/2);var left=parseInt(w/2);clip="rect("+top+"px "+left+"px "+top+"px "+left+"px)";}}}}}}opts.cssBefore.clip=opts.cssBefore.clip||clip||"rect(0px 0px 0px 0px)";var d=opts.cssBefore.clip.match(/(\d+)/g);var t=parseInt(d[0]),r=parseInt(d[1]),b=parseInt(d[2]),l=parseInt(d[3]);opts.before.push(function(curr,next,opts){if(curr==next){return;}var $curr=$(curr),$next=$(next);$.fn.cycle.commonReset(curr,next,opts,true,true,false);opts.cssAfter.display="block";var step=1,count=parseInt((opts.speedIn/13))-1;(function f(){var tt=t?t-parseInt(step*(t/count)):0;var ll=l?l-parseInt(step*(l/count)):0;var bb=b<h?b+parseInt(step*((h-b)/count||1)):h;var rr=r<w?r+parseInt(step*((w-r)/count||1)):w;$next.css({clip:"rect("+tt+"px "+rr+"px "+bb+"px "+ll+"px)"});(step++<=count)?setTimeout(f,13):$curr.css("display","none");})();});opts.cssBefore={display:"block",opacity:1,top:0,left:0};opts.animIn={left:0};opts.animOut={left:0};};})(jQuery);

$.fn.cyclingGall = function(_opt){
	var _options = $.extend({
		slideEl: '>ul',
		slides: '>li',
		switcher: false,
		autoSlide: 7000,
		duration: 700,
		btPrev: '.btn-prev, .prev, .prev-btn, .btn-up, .up-btn, .link-prev',
		btNext: '.btn-next, .next, .next-btn, .btn-down, .down-btn, .link-next',
		direction: false,
		activeClass: 'active',
		changeHeight: false
	}, _opt);
	var _enabledClass = 'slide-enabled';

	return this.each(function(){
		if ($(this).hasClass(_enabledClass)) return;
		var _holder = $(this),
			_animSpeed = _options.duration,
			_duration = _options.autoSlide,
			_slideEl = $(_options.slideEl, _holder),
			_slides = $(_options.slides, _slideEl),
			_btNext = $(_options.btNext, _holder),
			_btPrev = $(_options.btPrev, _holder),
			_switcher = _options.switcher ? $(_options.switcher, _holder) : false,
			_duration = _options.autoSlide,
			_activeClass = _options.activeClass,
			_direction = _options.direction,
			_frame = _options.changeHeight ? $(_options.changeHeight, _holder) : false;
		var _step = _slides.eq(0).outerWidth(true);
		var _active = 0;
		var _t;
		
		if (!_direction){
			var _offset = _step * (_slides.length);
			_slideEl.css('margin-left', -_offset);
			_slides.clone().appendTo(_slideEl);
			_slides.clone().appendTo(_slideEl);
		}
		else {
			_step = _slides.eq(0).outerHeight(true);
			var _offset = _step * (_slides.length);
			_slideEl.css('margin-top', -_offset);
			_slides.clone().appendTo(_slideEl);
			_slides.clone().appendTo(_slideEl);
		}
		if (_frame){
			if (_frame.height() != _slides.eq(_active).height()) _frame.css({
				'height': _slides.eq(_active).height()
			})
		}
			
		function changeSlide(_to){
			if (_switcher) {
				_switcher.eq(_active).removeClass(_activeClass);
				if (_to < 0) _switcher.eq(_slides.length-1).addClass(_activeClass);
				else if (_to > _slides.length-1) _switcher.eq(0).addClass(_activeClass);
				else _switcher.eq(_to).addClass(_activeClass);
			}
			if (_frame){
				var _toSl = _to;
				if (_to < 0) _toSl = _slides.length-1
				else if (_to > _slides.length-1) _toSl = 0;
				if (_frame.height() != _slides.eq(_toSl).height()) _frame.animate({
					'height': _slides.eq(_toSl).height()
				}, _animSpeed)
			}
			
			if (_direction){
				_slideEl.animate({
					'margin-top': -_step*_to - _offset
				}, _animSpeed, function(){
					_active = _to;
					if (_active < 0) {
						_active = _slides.length-1;
						_slideEl.css('margin-top',-_offset - _step*_active)
					}
					else if (_active > _slides.length-1) {
						_active = 0;
						_slideEl.css('margin-top',-_offset)
					}
				})
			}
			else {
				_slideEl.animate({
					'margin-left': -_step*_to - _offset
				}, _animSpeed, function(){
					_active = _to;
					if (_active < 0) {
						_active = _slides.length-1;
						_slideEl.css('margin-left',-_offset - _step*_active)
					}
					else if (_active > _slides.length-1) {
						_active = 0;
						_slideEl.css('margin-left',-_offset)
					}
				})
			}
		}
		
		if (_duration) {
			_t = setInterval(function(){
				changeSlide(_active+1)
			}, _duration)
			
			_holder.mouseenter(function(){
				if (_t) clearInterval(_t);
			}).mouseleave(function(){
				if (_t) clearInterval(_t);
				_t = setInterval(function(){
					changeSlide(_active+1)
				}, _duration)
			})
		}
		
		if (_switcher) {
			_switcher.click(function(){
				if (!_slideEl.is(':animated')) {
					changeSlide(_switcher.index($(this)));
				}
				return false;
			})
		}
		
		if (_btNext) {
			_btNext.click(function(){
				if (!_slideEl.is(':animated')) {
					changeSlide(_active+1);
				}
				return false;
			})
		}
		if (_btPrev) {
			_btPrev.click(function(){
				if (!_slideEl.is(':animated')) {
					changeSlide(_active-1);
				}
				return false;
			})
		}
	});
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

Object.size = function(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
}

function initStateLinks(){
	$(".state-link").each(function(){
		$(this).click(function(){
			var cityAddendum = $("#city-addendum").attr('value');
			$("#cities-list").empty().html('<img src="/images/layout/loading.gif" />');			
		    $.ajax({
			    type: "POST",
			    url: "/doctors/cities?format=json&stateName=" + $(this).attr("href").replace("#","") + ($(this).hasClass('mini') ? '&twocolumns=1' : '') + (cityAddendum ? '&addendum=' + cityAddendum : ''),
			    dataType: "json",
			    success: function(response) {
			    	$("#cities-list").html(response.content);
			    }
		    });
		    return false;
	    });
    });	
    $(".state-alpha").each(function(){
		$(this).click(function(){
			$("#state-list>.first-child>a>span").click();
		    return false;
	    });
    });	
}

function initShowMore(){
	$(".show-more").each(function(){
		$(this).click(function(){
			$("#"+$(this).attr("href").replace("#","")+"filters>.extra").removeClass("extra");
			$(this).parent().hide();
			return false;
		});
	});
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

function ChangeLocationAndOrDistance(){
	if(document.distanceform){
		ChangeLocation(document.locationform.location.value,document.distanceform.distance.value);
	}else{
		ChangeLocation(document.locationform.location.value,"");
	}
	return false;
}

function ChangeLocation(zip,distance){
	var filterURL = location.href.replace(/(#|\?).+/,"");
	
	zip = z.toLowerCase();

	if(typeof siloedFilters != "undefined" && filterURL.search(siloedFilters) == -1)
	{
		filterURL = filterURL.replace(siloedNames,"") + siloedFilters;
		if(filterURL.indexOf("/doctors/search/") == -1)
			filterURL = filterURL.replace("/doctors/","/doctors/search/");
	}

	if(zip.replace(/^\s+|\s+$/g, '') != "")
		filterURL = AddFilterToURL("location-"+escape(zip),filterURL);
	if(distance.replace(/^\s+|\s+$/g, '') != "")
		filterURL = AddFilterToURL("distance-"+escape(distance),filterURL);

	filterURL = filterURL.replace(/\s|(%20)/g,'_');
	document.resultsForm.action = filterURL;
	document.resultsForm.submit();
	return false;
}

function RemoveFilter(filtername)
{
	var debug = false;
	var filterURL = location.href.replace(/(#|\?).+/,"").replace(/\/$/,"");
	var filterRegEx = new RegExp("\/" + filtername + "-[^\/]+");
	if (filtername != "page") filterURL = filterURL.replace(/\/page-[0-9]+/,"");


	if(typeof siloedFilters != "undefined" && filterURL.search(siloedFilters) == -1)
	{
		filterURL = filterURL.replace(siloedNames,"") + siloedFilters;
		if(filterURL.indexOf("/doctors/search/") == -1)
			filterURL = filterURL.replace("/doctors/","/doctors/search/");
	}

	document.resultsForm.action = filterURL.replace(filterRegEx,"");

	if(debug) console.log("Action is set to: "+document.resultsForm.action);
	if(!debug) document.resultsForm.submit();
	return false;
}

function ResetFilters(){
	document.resultsForm.action = document.resultsForm.originalFilter.value;
	document.resultsForm.submit();
	return false;
}

function unHide(){
	$('.hidefirst').removeClass('hidefirst');
	$('.temporary').addClass('hidden');
}

function toggleContactForm(){
	if($('#contact-content').hasClass('hidden')){
		$('#contact-content').removeClass('hidden');
		$('#contact-minilead').addClass('hidden');
	}else{
		$('#contact-content').addClass('hidden');
		$('#contact-minilead').removeClass('hidden');
	}
	return false;
}

$(function(){
	$('.compare-modal').dialog({
			autoOpen:false,
			draggable:false,
			resizable:false,
			modal:true,
			closeText:'',
			dialogClass:'compare-dialog',
			width:$('.compare-modal .modal-box').length ? 977 : 790,
			show:'fade',
			hide:'fade'
	});		
});
function compareProcedures(){
	$('table.comparisons tr').empty();
	if ($('.compare-list-holder input:checked').length > 0){
		$('.compare-list-holder input:checked').each(function(){
			if ($('table.comparisons #compare_name').html() != "") $('table.comparisons #compare_name').append('<td rowspan="8" class="separator"><div></div></td>');
			$('#compare_'+$(this).attr('value')+" li[contentfor]").each(function(){
				$('table.comparisons #compare_' + $(this).attr('contentfor')).append('<td class="comparison"><div>'+$(this).html()+"</div></td>");
			});			
		});
		if ($('.compare-list-holder input:checked').length > 3)
			$('.comparison-scroll').addClass('comparison-IEfix');
		else
			$('.comparison-scroll').removeClass('comparison-IEfix');
		$('.compare-modal').dialog('open');
		$('.ui-widget-overlay').addClass('modal-shade');
	}else{
		alert("You must select at least one doctor to compare.");	
	}				
}
function compareDoctors(){
	$('table.comparisons tr').empty();
	if ($('.cont-list .check input:checked').length > 0){
		$('.cont-list .check input:checked').each(function(){
			if ($('table.comparisons #compare_name').html() != "") $('table.comparisons #compare_name').append('<td rowspan="11" class="separator"><div></div></td>');
			$('#compare_'+$(this).attr('value')+" li[contentfor]").each(function(){
				$('table.comparisons #compare_' + $(this).attr('contentfor')).append('<td class="comparison"><div>'+$(this).html()+"</div></td>");
			});			
		});
		if ($('.cont-list .check input:checked').length > 3)
			$('.comparison-scroll').addClass('comparison-IEfix');
		else
			$('.comparison-scroll').removeClass('comparison-IEfix');
		$('.compare-modal').dialog('open');
		$('.ui-widget-overlay').addClass('modal-shade');
	}else{
		alert("You must select at least one doctor to compare.");	
	}
}
function compareClose(){
	$('.compare-modal').dialog('close');						
}


function showNewsletter(){
	var pos = $('.newsletter').offset();
	if($('.newsletter-box').hasClass('hidden')){
		$('.newsletter-box').removeClass('hidden');
		$('.newsletter-box').offset({
			top: pos.top-10,
			left: pos.left
		});
		$('.newsletter-box').addClass('hidden');
	}
	$('.newsletter-box').slideDown();
}
function hideNewsletter(){
	$('.newsletter-box').removeClass('hidden');
	$('.newsletter-box').slideUp();
}
function NewsletterSubscribe(emailAddress){
	$('.newsletter-box .btn input').attr('disabled',true);
	$('.newsletter-box .btn p.message').removeClass('error');
	$('.newsletter-box .btn p.message').html('Processing...');
	$.ajax({
	    type: "POST",
	    url: "/common/subscribenewsletter?format=json&email=" + emailAddress,
	    dataType: "json",
	    success: function(response) {	    	
	    	$('.newsletter-box .btn input').attr('disabled',false);
	    	switch(response.result){
	    		case 'blank':
	    			$('.newsletter-box .btn p.message').html('Please enter an email address.');
	    			$('.newsletter-box .btn p.message').addClass('error');
	    			break;
	    		case 'invalid':
	    			$('.newsletter-box .btn p.message').html('Error: Improperly formatted email address.');
	    			$('.newsletter-box .btn p.message').addClass('error');
	    			break;
	    		case 'duplicate':
	    			$('.newsletter-box .btn p.message').html('Error: Email address is already subscribed.');
	    			$('.newsletter-box .btn p.message').addClass('error');	    			
	    			break;
	    		case 'success':
	    			$('.newsletter-box .c').html('You have successfully subscribed to our newsletter.');
	    			var t=setTimeout("hideNewsletter();",5000);
	    			break;
	    	}			
	    },
	    error: function() {
	   		$('.newsletter-box .btn input').attr('disabled',false);
			$('.newsletter-box .btn p.message').addClass('error');
			$('.newsletter-box .btn p.message').html('Error: Request failed. Please try again later.'); 	
	    }
    });	
    return false;
}

function HideFinancingForm(){
	$('#carecopy').show();
	$('#carecredit').hide();
}

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

$(function(){
	$('.populatesCountry').change(function(){
		$('.containsCountries a:contains("'+$('.populatesCountry option:selected').attr('country')+'")').click();
	});
});

// This function truncates the text within an element by removing just 
// enough text to make the element fit within the specified height.
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


$.widget("ui.verboseautocomplete", $.extend({}, $.ui.autocomplete.prototype, {

  _response: function(contents){
      $.ui.autocomplete.prototype._response.apply(this, arguments);
      $(this.element).trigger("autocompletesearchcomplete", [contents]);
  }
  
}));

/* The following script powers the specialty/procedure selection fields found on the
   front page, and on the top right corner across the site. */
$(function(){

		function split( val ) {
			return val.split( /,\s*/ );
		}
		function extractLast( term ) {
			return split( term ).pop();
		}

		$( "#global-search-terms,#global-search-results-terms" )
			// don't navigate away from the field on tab when selecting an item
			.bind( "keydown", function( event ) {
				if ( event.keyCode === $.ui.keyCode.TAB &&
						$( this ).data( "autocomplete" ).menu.active ) {
					event.preventDefault();
				}
			})
			.autocomplete({
				source: function( request, response ) {
					$.getJSON( "/search/autosuggest?format=json&debug=0", {
						term: extractLast( request.term )
					}, response);
				},
				search: function( event, ui ) {
					// custom minLength
					var term = extractLast( this.value );
					if ( term.length < 2 ) {
						return false;
					}					
				},
				focus: function() {
					// prevent value inserted on focus
					return false;
				},
				select: function( event, ui ) {			
					var terms = split( this.value );
					// remove the current input
					terms.pop();
					// add the selected item
					terms.push( ui.item.value );
					// add placeholder to get the comma-and-space at the end
					terms.push( "" );
					$(this).val(terms.join( ", " ).replace(/&[^&;]+?;/g,""));
					return false;
				},
				open: function(event, ui) {
					$(this).autocomplete( "widget" ).removeClass("small-autocomplete-scrolling");
					$(this).autocomplete("widget").addClass('small-autocomplete');
					if($(this).autocomplete( "widget" ).height() >= 300){
						$(this).autocomplete( "widget" ).addClass("small-autocomplete-scrolling");						
						}	
					$(this).autocomplete( "widget" ).find("li a").each(function(){
						$(this).html($(this).html().replace(/&amp;/g,"&"));
					});		
				}
			});


	/* Commented out Jason's Specialty Procedure Auto Suggestion */
	procedureSpecialtyArray = [];
	specialtyArray = [];
	SWspecialtyArray = [];
	procedureArray = [];
	SWprocedureArray = [];

	$('body').append('<div id="symbolcleaner" style="display:none;"></div>');
	for(i in specialtyProcedureSelections){
		$("#symbolcleaner").html(specialtyProcedureSelections[i].label)
		if(specialtyProcedureSelections[i].label.search("&") >= 0){
			specialtyProcedureSelections[$("#symbolcleaner").html().replace('&amp;','&').toUpperCase()] = {
				index:	$("#symbolcleaner").html().replace('&amp;','&').toUpperCase(),
				value:	specialtyProcedureSelections[i].value,
				label:	$("#symbolcleaner").html().replace('&amp;','&')
			};			
		}
		if(specialtyProcedureSelections[i].label != 'Acupuncture ')
			procedureSpecialtyArray.push({label:$("#symbolcleaner").html().replace('&amp;','&'),value:specialtyProcedureSelections[i].value});
		if(specialtyProcedureSelections[i].value.charAt(0) == 's'){
			specialtyArray.push($("#symbolcleaner").html().replace('&amp;','&'));
			SWspecialtyArray.push({label:$("#symbolcleaner").html().replace('&amp;','&'),value:specialtyProcedureSelections[i].value,specialtyId:specialtyProcedureSelections[i].value.split("-")[1]});
		}else{
			procedureArray.push($("#symbolcleaner").html().replace('&amp;','&'));
			SWprocedureArray.push({label:$("#symbolcleaner").html().replace('&amp;','&'),value:specialtyProcedureSelections[i].value,specialtyIds:specialtyProcedureSelections[i].specialtyIds});
		}
	}
	
	$(".procedure-couple").each(function(){
		var _ProcedureInput = $(".procedure-input",$(this));
		var _ProcedureOutput = $(".procedure-output",$(this));
		
		if(_ProcedureInput.hasClass('big-autocomplete'))
		{
		
			_ProcedureInput.autocomplete({
				source: procedureSpecialtyArray,
				open: function(event, ui) { 
					if(_ProcedureInput.hasClass('big-autocomplete')){					
						$(this).autocomplete( "widget" ).removeClass("big-autocomplete-scrolling");
						$(this).autocomplete("widget").addClass('big-autocomplete');
						if($(this).autocomplete( "widget" ).height() >= 300){
							$(this).autocomplete( "widget" ).addClass("big-autocomplete-scrolling");						
						}
					}else{
						$(this).autocomplete( "widget" ).removeClass("small-autocomplete-scrolling");
						$(this).autocomplete("widget").addClass('small-autocomplete');
						if($(this).autocomplete( "widget" ).height() >= 300){
							$(this).autocomplete( "widget" ).addClass("small-autocomplete-scrolling");						
						}					
					}
				},
				select: function(event, ui){
					_ProcedureOutput.val(ui.item.value);				
					_ProcedureInput.val(ui.item.label);
					_ProcedureOutput.change();				
					return false;
				},
				focus: function(event, ui){
					_ProcedureInput.val(ui.item.label);
					return false;
				},
				change: function(event, ui){
					var _selection = specialtyProcedureSelections[_ProcedureInput.val().toUpperCase()];
					if(typeof(_selection) != "object"){
						_ProcedureOutput.val("");
						if(_ProcedureInput.val() != ""){
							_ProcedureInput.val("");						
							_ProcedureInput.blur();
						}	
					}else{
						_ProcedureOutput.val(_selection.value);
						_ProcedureInput.val(_selection.label.replace('&amp;','&'));
					}
					//$(".blurtest").html($(".blurtest").html() + "["+_ProcedureOutput.val()+"]");
				}
			});
		}
	});
	
	$('#SWprocedure,#RSWprocedure').each(function(){
		var _SWprocedure = $(this); 
		_SWprocedure.verboseautocomplete({
			source: SWprocedureArray,
			open: function(event, ui){ 
				$(this).autocomplete("widget").removeClass("mini-autocomplete-scrolling");
				$(this).autocomplete("widget").addClass('mini-autocomplete');
				if($(this).autocomplete("widget").height() >= 300){
					$(this).autocomplete("widget").addClass("mini-autocomplete-scrolling");						
				}					
			},
			select: function(event, ui){			
				_SWprocedure.val(ui.item.label);			
				return false;
			},
			focus: function(event, ui){
				_SWprocedure.val(ui.item.label);
				return false;
			},
			change: function(event, ui){
				if(_SWprocedure.val() != ""){
					var _selection = specialtyProcedureSelections[_SWprocedure.val().toUpperCase()];
					if((typeof(_selection) != "object") || (_selection.value.charAt(0) == 's')){
						if(_SWprocedure != ""){
							_SWprocedure.val("");
							_SWprocedure.blur();	
						}			
					}else{				
						_SWprocedure.val(_selection.label.replace('&amp;','&'));
					}
				}
			}
		}).bind("autocompletesearchcomplete", function(event, contents) {		
		    if(contents.length == 0){
		    	$(this).autocomplete("widget").html('<li class="ui-menu-item"><p class="no-results">No results found.</p></li>');
		    	if($(this).autocomplete("widget").offset().top == 0){
			    	var ACpos = _SWprocedure.offset();
			    	$(this).autocomplete("widget").css("top",(ACpos.top + 20)+"px");
			    	$(this).autocomplete("widget").css("left",(ACpos.left)+"px");
			    }
			    $(this).autocomplete("widget").show();
		    }    
		});
	});
	$('#SWspecialtyprocedure,#RSWspecialtyprocedure').each(function(){
		var _SWspecialtyprocedure = $(this); 
		_SWspecialtyprocedure.autocomplete({
			source: procedureSpecialtyArray,
			open: function(event, ui){ 
				$(this).autocomplete("widget").removeClass("mini-autocomplete-scrolling");
				$(this).autocomplete("widget").addClass('mini-autocomplete');
				if($(this).autocomplete("widget").height() >= 300){
					$(this).autocomplete("widget").addClass("mini-autocomplete-scrolling");						
				}					
			},
			select: function(event, ui){			
				_SWspecialtyprocedure.val(ui.item.label);			
				return false;
			},
			focus: function(event, ui){
				_SWspecialtyprocedure.val(ui.item.label);
				return false;
			},
			change: function(event, ui){
				if(_SWspecialtyprocedure.val() != ""){
					var _selection = specialtyProcedureSelections[_SWspecialtyprocedure.val().toUpperCase()];
					if(typeof(_selection) != "object"){
						if(_SWspecialtyprocedure != ""){
							_SWspecialtyprocedure.val("");
							_SWspecialtyprocedure.blur();	
						}			
					}else{				
						_SWspecialtyprocedure.val(_selection.label.replace('&amp;','&'));
					}
				}
			}
		});
	});
	var SWmini_page = 1;
	var SWmini_pagecount = 0;

	$('.SWmini-modal').dialog({
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
	$('.SWproc-box').dialog({
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
	
	$('#NLprocedure').each(function(){
		var _NLprocedure = $(this); 
		_NLprocedure.autocomplete({
			source: procedureArray,
			open: function(event, ui){ 
				$(this).autocomplete("widget").removeClass("mini-autocomplete-scrolling");
				$(this).autocomplete("widget").addClass('mini-autocomplete');
				if($(this).autocomplete("widget").height() >= 300){
					$(this).autocomplete("widget").addClass("mini-autocomplete-scrolling");						
				}					
			},
			select: function(event, ui){			
				_NLprocedure.val(ui.item.label);			
				return false;
			},
			focus: function(event, ui){
				_NLprocedure.val(ui.item.label);
				return false;
			},
			change: function(event, ui){
				var _selection = specialtyProcedureSelections[_NLprocedure.val().toUpperCase()];
				if(typeof(_selection) != "object" || _selection.value.charAt(0) != 'p'){
					if(_NLprocedure.val() != ""){
						_NLprocedure.val("");
						_NLprocedure.blur();		
					}
				}else{				
					_NLprocedure.val(_selection.label);
				}
			}
		});
	});

});
function SWminiProcess(finalPhase,altForm){
	var procedureID = "";
	var specialtyID = "";
	var altFormPrefix = altForm ? 'R' : '';
	var SWform = altForm ? document.Rcontactadoctor_sidebox : document.contactadoctor_sidebox;

	if ($('#'+altFormPrefix+'SWprocedure').val() != ""){
		var _selection = specialtyProcedureSelections[$('#'+altFormPrefix+'SWprocedure').val().toUpperCase()];
		if(typeof(_selection) == "object"){

			if(_selection.value.charAt(0) == 'p'){
				procedureID = _selection.value.replace("procedure-","");
			}
		}
	}
	if (finalPhase && $('.doctor-list-container input:checkbox').filter(':checked').length == 0){
		alert("Please select at least one doctor.");
	}else{
		if(!finalPhase){
			$('.SWmini-modal').dialog('open');
			$('.ui-widget-overlay').addClass('modal-shade');
		}else{
			var doctorList = $('.doctor-list-container input:checkbox').serialize().replace(/doctors=/g,'').replace(/&/g,',');
			if($("#newsletterSlider").length > 0)
				var newsletterChecked = $('#newsletterSlider').val();
			else
				var newsletterChecked = $('#SWnewsletter').attr('checked');
			var SWid = $('#SWID').val();
		}
		$('#doctor-review').empty().html('<center><img src="/images/layout/loading.gif" /></center>');	
		$('#'+altFormPrefix+'SWinvalid').hide();
		$('#'+altFormPrefix+'SWmini').children('div').each(function(){		
			$(this).removeClass('invalidData');
		});
		if(finalPhase){
			$.ajax({
			    type: "POST",
			    url: "/common/contactadoctor",
			    data:  {
			    		procedure: procedureID,
			    		specialty: specialtyID,
			    		name: SWform.name.value,
			    		email: SWform.email.value,
			    		zip: SWform.zip.value,
			    		phone: SWform.phone.value,
			    		comments: SWform.comments.value,
			    		position: SWform.position.value,
			    		doctors: doctorList,
			    		newsletter: newsletterChecked,
			    		processing:true,
			    		SWID: SWid
			    },
			    dataType: "html",
			    success: function(response) {
			    	if(response.search('invalid--') == -1){
			    		$("#doctor-review").html(response);
			    	}else{
			    		$('#'+altFormPrefix+'SWinvalid').show();
			    		$('#'+altFormPrefix+'SWmini').children('div').each(function(){
			    			if(response.search($(this).prop('id').replace(/.*_/,'')) >= 0){
			    				$(this).addClass('invalidData');
			    			}
			    		});
			    		$('.SWmini-modal').dialog('close');
			    	}
			    }
		    });
		}else{
			if($("#saveMyInfoSlider").length > 0)
				saveMyInfo = $('#saveMyInfoSlider').val();
			else
				saveMyInfo = ($('#[id^="saveMyInfo"]:checked').val() != undefined)? "on" : "";
			$.ajax({
			    type: "POST",
			    url: "/common/contactadoctor",
			    data:  {
			    		procedure: procedureID,
			    		specialty: specialtyID,
			    		name: SWform.name.value,
			    		email: SWform.email.value,
			    		zip: SWform.zip.value,
			    		phone: SWform.phone.value,
			    		comments: SWform.comments.value,
			    		position: SWform.position.value,
			    		saveMyInfo1: saveMyInfo
			    },
			    dataType: "html",
			    success: function(response) {
			    	if(response.search('invalid--') == -1){
				    	$("#doctor-review").html(response);
				    	$('#doctor-review input:checkbox').customCheckbox();
				    	$('.doctor-list-container input:checkbox').change(function(){
				    		SWminiAuditCheckboxes();
				    	});
				    	$("#selectAllOrNone").click(function(){
				    		SWminiCheckAll();
				    	});
				    	$("#doctor-review .btn-request").click(function(){		    		
				    		SWminiProcess(true,altForm);
				    	});
				    	SWallChecked = true;
			    	}else{
			    		$('#'+altFormPrefix+'SWinvalid').show();
			    		$('#'+altFormPrefix+'SWmini').children('div').each(function(){
			    			if(response.search($(this).prop('id').replace(/.*_/,'')) >= 0){
			    				$(this).addClass('invalidData');
			    			}
			    		});
			    		$('.SWmini-modal').dialog('close');
			    	}
			    }
		    });
		}
	}
}

function SWminiOpen(){
	SWminiProcess(false,false);
}
function SWminiClose(){
	$('.SWmini-modal').dialog('close');						
}
function RSWminiOpen(){
	SWminiProcess(false,true);
}
var SWallChecked = false;
var SWCheckAudit = true;
function SWminiAuditCheckboxes(){
	if(SWCheckAudit){
		var _checkboxes = $('.doctor-list-container input:checkbox');
		if (_checkboxes.length == _checkboxes.filter(':checked').length){
			$("#selectAllOrNone").val("SELECT NONE");
			SWallChecked = true;
		}else{
			$("#selectAllOrNone").val("SELECT ALL");
			SWallChecked = false;
		}
	}
}
function SWminiCheckAll(){
	SWCheckAudit = false;	
	$('.doctor-list-container .checkboxArea' + (SWallChecked ? 'Checked' : '')).each(function(){
		$(this).click();		
	});	
	SWCheckAudit = true;
	SWminiAuditCheckboxes();
}

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

function SWProcOpen(fieldTarget){
	$('.SWproc-box').dialog('open');
	var listInterval = Math.ceil(SWprocedureArray.length/3);
	$('#SW-procedure-list').empty();
	$('#SW-procedure-list').append("<ul></ul>");
	var procCount = 0;
	for(i in SWprocedureArray){
		$('#SW-procedure-list ul:last').append("<li><a href='#'>"+SWprocedureArray[i].label+"</a></li>");
		procCount++;
		if((procCount % listInterval == 0) && (procCount != SWprocedureArray.length))$('#SW-procedure-list').append("<ul></ul>");
	}
	$('#SW-procedure-list a').click(function(){
		$('#'+fieldTarget).val($(this).html());
		SWProcClose();
		return false;
	});
}
function SWProcClose(){
	$('.SWproc-box').dialog('close');						
}

function newsletterSubmit(){
	var procedureID = "";
	var emailAddress = $('#NLemail').val();
	if ($('#NLprocedure').val() != ""){
		var _selection = specialtyProcedureSelections[$('#NLprocedure').val().toUpperCase()];
		if((typeof(_selection) == "object") && (_selection.value.charAt(0) == 'p')){			
			procedureID = _selection.value.replace("procedure-","");			
		}
	}
	$("#newsletter_widget .btn").hide();
	$("#NLloading").show();
	$('#NLemail').attr('disabled',true);
	$('#NLprocedure').attr('disabled',true);
	$('#NLemail').parent().parent().parent().removeClass('invalidData');
	$('#NLinvalid').hide();
	$.ajax({
	    type: "POST",
	    url: "/common/subscribeNewsletter?format=json&email=" + emailAddress + "&procedure=" + procedureID,
	    dataType: "json",
	    success: function(response) {	    	
	    	$('#NLemail').attr('disabled',false);
			$('#NLprocedure').attr('disabled',false);
			$("#newsletter_widget .btn").show();
			$("#NLloading").hide();
	    	switch(response.result){
	    		case 'blank':	    			
			   		$('#NLemail').parent().parent().parent().addClass('invalidData');
					$('#NLinvalid').html('Please enter an email address.');
					$('#NLinvalid').show();	
	    			break;
	    		case 'invalid':
			   		$('#NLemail').parent().parent().parent().addClass('invalidData');
					$('#NLinvalid').html('Error: Improperly formatted email address.');
					$('#NLinvalid').show();	
	    			break;
	    		case 'duplicate':
	    			$('#NLemail').parent().parent().parent().addClass('invalidData');
					$('#NLinvalid').html('Error: Email address is already subscribed.');
					$('#NLinvalid').show();	  			
	    			break;
	    		case 'success':
	    			$('#newsletter_widget').parent().html("<p>You have successfully subscribed to our newsletter.</p>");	
	    			break;
	    	}			
	    },
	    error: function() {
	   		$('#NLemail').attr('disabled',false);
	   		$('#NLprocedure').attr('disabled',false);
	   		$("#newsletter_widget .btn").show();
			$("#NLloading").hide();
			$('#NLinvalid').html('Error: Request failed. Please try again later.');
			$('#NLinvalid').show();	
	    }
    });	
    return false;
}

$(function(){
	var locationOpen = false;
	$('.choose-location').click(function(){
		//alert($('.doctor-gallery>.side-gallery>.gallery>ul').cycle.pause);		
		$('.doctor-gallery>.side-gallery>.gallery>ul').cycle('pause');
		if($("#locations_"+$(this).attr("practice")+" a").length > 9){
			$('#location-list').addClass("location-list-scrollable");
		}
		$('#location-list').html($("#locations_"+$(this).attr("practice")).html());		
		$('#location-list').slideDown('fast',function(){locationOpen = true;});	
		var linkPosition = $(this).offset();	
		$('#location-list').offset({left:linkPosition.left-80,top:linkPosition.top});
		return false;
	});
	$('#location-list').mouseover(function(){		
		$('.doctor-gallery>.side-gallery>.gallery>ul').cycle('pause');
	});
	$('#location-list').mouseleave(function(){		
		locationOpen = false;		
		$('.doctor-gallery>.side-gallery>.gallery>ul').cycle('resume');
		$('#location-list').slideUp('fast',function(){$('#location-list').removeClass("location-list-scrollable");});
	});
	$('.doctor-gallery').mouseover(function(e){
		if(locationOpen){
			$('#location-list').mouseleave();
		}
	});
});

function recordClick(event, thisObject)
{
	var thisHREF		= $(thisObject).attr("href");
	var thisSection		= $(thisObject).attr("clickTrackSection");
	var thisLabel		= $(thisObject).attr("clickTrackLabel");
	var thisKeyValues	= $(thisObject).attr("clickTrackKeyValues");

	if (thisHREF && (thisHREF[0] == "/" || thisHREF.match(/^http[s]?:\/\//) ) )
	{
		$.ajax({
			url:	"/common/recordclick",
			type:	"POST",
			data:	{	thisHREF: 		thisHREF, 
						thisSection:	thisSection,
						thisLabel:		thisLabel,
						thisKeyValues:	thisKeyValues
				 },
			async:	false
		});
	}	
}

$(document).ready(function(){
    $("a").live('click', function (e) {
		recordClick(e, $(this));
    });
});


/*
 // Plan to record coordinate of click 
function recordClick(event, thisObject)
{
	var thisHREF		= $(thisObject).attr("href");
	var thisSection		= $(thisObject).attr("clickTrackSection");
	var thisLabel		= $(thisObject).attr("clickTrackLabel");
	var thisKeyValues	= $(thisObject).attr("clickTrackKeyValues");

	if (thisHREF && (thisHREF[0] == "/" || thisHREF.match(/^http[s]?:\/\//) ) )
	{
		$.ajax({
			url:	"/common/recordclick",
			type:	"POST",
			data:	{	thisHREF: 		thisHREF, 
						thisSection:	thisSection,
						thisLabel:		thisLabel,
						thisKeyValues:	thisKeyValues,
						thisCoordinateX:	e.clientX,
						thisCoordinateY:	e.clientY
				 },
			async:	false
		});
	}	
}

$(document).ready(function(){
    $("a").live('click', function (e) {
    	//alert(e.clientX);
    
		recordClick(e, $(this));
    });
});
*/

function forgetMe(userId)
{
	$("#welcome_message").html("<img class='welcome-brace' src='/images/empty_pixel.gif'>Removing your information...");
	$.post("/common/forgetmyinfo/" + userId + "?format=json",{},function(response) {
		if(!response){
			alert("Couldn't remove your information. Please try again.");
		}else{			
			$("#welcome_message").fadeOut("fast",function(){
				$(".login-set").each(function(){
					$(this).fadeIn();
				});
			});
		}
	});
}

function initTooltips(){
	$(".tooltip").tooltip({
		delay: 0,
		track: true,
		showBody: " | "
	});
}