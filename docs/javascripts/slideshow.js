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
	})
}

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