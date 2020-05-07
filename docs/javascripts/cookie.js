function setCookie(c_name,value,exdays)
	{
	var exdate=new Date();
	exdate.setDate(exdate.getDate() + exdays);
	//var c_value=escape(value) + "; domain=.locateadoc.com; path=/" + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
	var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
	document.cookie=c_name + "=" + c_value;
	//alert("Cookie set: " + c_name + " to " + value);
	}
function getCookie(c_name)
	{
	//alert(document.cookie);
	var i,x,y,ARRcookies=document.cookie.split(";");
	for (i=0;i<ARRcookies.length;i++)
		{
		x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
		y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
		x=x.replace(/^\s+|\s+$/g,"");
		if (x==c_name)
			{
			return unescape(y);
			}
		}
	}
function deleteCookie(name)
	{
	setCookie(name,"",-1);
	//alert("Cookie deleted: " + name);
	}