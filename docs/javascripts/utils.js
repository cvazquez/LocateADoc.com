/* This script contains useful little helper functions that can be used anywhere */

// When applied to a text input, enforces numbers only
// Usage: $("myinput").numbersOnly()
$.fn.numbersOnly = function() {
	return this.each(function() {
		$(this).keydown(function(e) {
			var key = e.charCode || e.keyCode || 0
			// allow backspace, tab, delete, arrows, numbers and keypad numbers ONLY
			return (
				key == 8 ||
				key == 9 ||
				key == 46 ||
				(key >= 37 && key <= 40) ||
				(key >= 48 && key <= 57) ||
				(key >= 96 && key <= 105)
			)
		})
	})
}

// Will take a string with delimited "key:value" pairs and create an object (assoc array) out of it 
function toObject(txt,del) {
	// txt = key:value pairs with delimiter (ex: "success:1||newid:420||name:Jay")
	// returns associative array (ex: array["success"] = 1, array["newid"] = 420, array["name"] = "Jay")
	if (!del) var del = "||"
	for (i=0;i<txt.length;i++) {
		if (txt.charCodeAt(i)>20) break
	}
	txt = txt.substr(i)
	var arr1 = txt.split(del)
	var arr2 = []
	for (i=0;i<arr1.length;i++) {
		if (arr1[i].indexOf(":") >= 0) {
			arr2[arr1[i].substr(0,arr1[i].indexOf(":"))] = arr1[i].substr(arr1[i].indexOf(":")+1)
		} else {
			arr2[i] = arr1[i].substr(arr1[i].indexOf(":")+1)
		}
	}
	return arr2
}

// Will return an object containing the obj.width and obj.height of the current browser vieport
function getViewport() {
	var viewport = {}
	if (window.innerWidth) {
		viewport.width = window.innerWidth
		viewport.height = window.innerHeight
	} else if (document.documentElement && document.documentElement.clientWIdth && document.documentElement.clientHeight) {
		viewport.width =  document.documentElement.clientWidth
		viewport.height = document.documentElement.clientHeight
	} else {
		viewport.width = document.getElementsByTagName("body")[0].clientWidth
		viewport.height = document.getElementsByTagName("body")[0].clientHeight
	}
	return viewport
}

// Will center any element in the browser
// Usage: $("mydiv").center()
$.fn.center = function(options) {
	var options = options || {x:true,y:true}
	if (typeof(options.x)=="undefined") options.x = true
	if (typeof(options.y)=="undefined") options.y = true
	this.css("position","absolute")
	if (options.y) this.css("top",($(window).height()-this.height())/2+$(window).scrollTop()+"px")
	if (options.x) this.css("left",($(window).width()-this.width())/2+$(window).scrollLeft()+"px")
	return this
}

// This function will listen to a text input field, if 'Return' pressed, fires the callback function
/* Usage example:
	$("mytextfield")
		.keyup(function(event) {
			formListener(event,function(){
				alert("Return key was pressed")
			})
		})
*/
function formListener(event,callback) {
	var key = event.keyCode || event.which
	if (key==13) callback()
}