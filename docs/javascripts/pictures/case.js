var debug = false;

$(document).ready(function() {
	$("a.link-back")
		.click(function(event){
			if($(this).attr('href')=="#"){
				event.preventDefault();
				history.back();
			}
		})
		
	$("a[angleid]")
		.click(function(){
			$("#angledescription")
				.html(angle_descriptions[$(this).attr("angleid")])
		})
	
	$(".baagbox")
		.click(function(e){
			var isbefore = $(this).attr("baag")=="before"
			setTimeout("linkToOther("+isbefore+")",500)
		})
		

	
	/*
	$(window).load(function() {		
		positionImage("img.img-l");
		positionImage("img.img-r");
		
	});
	*/
	
  
})

function positionImage(whichImage)
{

	var paneHeight = 273;
	var paneHeightHalf = paneHeight/2;
	
	var paneWidth = 238;
	var paneWidthHalf = paneWidth/2;
	

	if (whichImage == "img.img-l")
	{
		$("img.img-l").each(function(index)
		{
			$(this).show();
			//$(this).css('display', 'block');
			
			if($.browser.msie)
			{
				//if(!$.browser.msie) console.dir($(this));
				$(this).css({"visibility":"visible"});
				if(debug) 
				{
					alert(whichImage + ":" + index);
				}
			}
			
			
			if($.browser.msie)
			{
				if(debug) 
				{
					alert("paneHeight:" + paneHeight);
					//alert("image height:" + $(this).height());
					//alert("image height:" + this.style.height);
					//alert("image height:" + this.height);
					//alert("this[index].height:" + this[index].height);
					//alert("$("img.img-l"):" + $("img.img-l")[index].height);
					//alert("$(this).attr('height'):" + $(this).attr("height"));
					
					
				}
			}
				
			
			if (this.height > 0 && this.height < paneHeight)
			{
				leftMarginTop = (paneHeightHalf - (this.height/2));
				
				this.style.marginTop = leftMarginTop + "px";
				
				
				if($.browser.msie)
				{
					if(debug) 
					{
						alert("this.style.marginTop:" + this.style.marginTop);
					}
				}
			}
			
			if (this.width > 0 && this.width < paneWidth)
			{
				leftMarginLeft = (paneWidthHalf - (this.width/2));
				
				this.style.marginLeft = leftMarginLeft + "px";
				
				if($.browser.msie)
				{
					if(debug)
					{
						alert("this.style.marginLeft:" + this.style.marginLeft);
					}
				}
			}
			
			
		});
	}
	
	if (whichImage == "img.img-r")
	{
		$("img.img-r").each(function(index)
		{
			$(this).show();
			//$(this).css('display', 'block');
			
			if($.browser.msie)
			{
				//if(!$.browser.msie) console.dir($(this));
				$(this).css({"visibility":"visible"});
				if(debug) 
				{
					alert(whichImage + ":" + index);
				}
			}
			
			if (this.height > 0 && this.height < paneHeight)
			{
				rightMarginTop = (paneHeightHalf - (this.height/2));
				
				this.style.marginTop = rightMarginTop + "px";
				
				if($.browser.msie)
				{
					if(debug) 
					{
						alert("this.style.marginTop:" + this.style.marginTop);
					}
				}
			}
			
			if (this.width > 0 && this.width < paneWidth)
			{
				rightMarginRight = (paneWidthHalf - (this.width/2));
				
				this.style.marginRight = rightMarginRight + "px";
				
				if($.browser.msie)
				{
					if(debug) 
					{
						alert("this.style.marginRight:" + this.style.marginRight);
					}
				}
			}
			
			
			
		});
	}
	
	

}

function linkToOther(before) {
	if (typeof $("#TB_Image").attr("src") == "undefined") {
		//this loop will wait for the thickbox image to exist before it
		//runs this callback.. since thickbox doesn't have a native callback method
		setTimeout("linkToOther("+before+")",500)
		return
	}
	
	if (before) {
		var other = "After"
		var othersrc = $("#TB_Image")
							.attr("src")
							.replace("before","after")
							.replace("fullsize","thumb")
							
		$("#TB_window").css("margin-left", "-145px")
	} else {
		var other = "Before"
		var othersrc = $("#TB_Image")
							.attr("src")
							.replace("after","before")
							.replace("fullsize","thumb")
							
		$("#TB_window").css("margin-left", "-85px")
	}
	var w = $("#TB_Image").width()
	var h = $("#TB_Image").height()
	$("#TB_window")
		.html($("#TB_window").html()+"<div class='otherbaag'>"+other+"</div>")
	$(".otherbaag")
		.css({
			"background"	: "url("+othersrc+")",
			"right"			: before?"-80px":"none",
			"left"			: before?"none":"-80px",
			"bottom"		: "100px",
			"cursor"		: "pointer"
		})
		.click(function(e){
			e.preventDefault()
			$("#TB_Image")
				.attr("src",othersrc.replace("thumb","fullsize"))
			$(this).remove()
			linkToOther(!before)
		})
		.fadeToggle()
	$("#TB_closeWindowButton,#TB_ImageOff").click(tb_remove)
}