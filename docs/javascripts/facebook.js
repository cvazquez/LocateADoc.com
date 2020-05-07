  // Load the SDK Asynchronously
  (function(d){
     var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement('script'); js.id = id; js.async = true;
     js.src = "//connect.facebook.net/en_US/all.js";
     ref.parentNode.insertBefore(js, ref);
   }(document));

  var loginClick = false;
  var forgetID = 0;

  // Init the SDK upon load
  window.fbAsyncInit = function() {
    FB.init({
      appId      : '350308611730717', // App ID
      channelUrl : '//'+window.location.hostname+'/common/facebookchannel', // Path to your Channel File
      status     : true, // check login status
      cookie     : true, // enable cookies to allow the server to access the session
      xfbml      : true  // parse XFBML
    });

	FB.getLoginStatus(function(response) {
		$(".fb-hidefirst").removeClass("fb-hidefirst");
		if(response.status == 'connected' || $('#welcome_message').length > 0)
			$(".login-set").hide();
		if(response.status == 'connected')
			$(".fb-only").each(function(){$(this).show();});
		//else
		//	$(".fb-logout").hide();
	});

    // listen for and handle auth.statusChange events
    FB.Event.subscribe('auth.statusChange', function(response) {
      CloseLoginBox();
      if (response.authResponse) {
        // user has auth'd your app and is logged into Facebook
        FB.api('/me',
        {fields: "birthday,email,first_name,gender,last_name,locale,location,name,picture.height(100).width(100)"},
        function(me){
          if (me.name) {
            me.loginClick = loginClick;
            me.locationString = location[name];
            delete me.location;
            $.ajax({
            	url: "/common/facebookresponse",
            	type: "POST",
            	dataType: "json",
            	data: me,
            	success: function(data){
					if(data.CITY != ""){
						if(loginClick)$('.FBpop input:text[name="city"]').parent().addClass("facebook-specified");
						$('.FBpop input:text[name="city"]').val(data.CITY);
            		}
					if(data.STATE != ""){
						if(loginClick)$('.FBpop select[name="state"]').parent().addClass("facebook-specified");
						$('.FBpop select[name="state"]').val(data.STATE);
						$('.FBpop select[name="state"]').change();
					}
					if(data.AGE != ""){
						if(loginClick)$('.FBpop select[name="age"]').parent().addClass("facebook-specified");
						$('.FBpop select[name="age"]').val(data.AGE);
						$('.FBpop select[name="age"]').change();
					}
					forgetID = data.USERID;
            	}
            });
            if(me.name){
                if(loginClick)$('.FBpop input:text[name="name"]').parent().addClass("facebook-specified");
            	$('.FBpop input:text[name="name"]').val(me.name);
            	if(loginClick)$('.FBpop input:text[name="coupon[name]"]').parent().addClass("facebook-specified");
            	$('.FBpop input:text[name="coupon[name]"]').val(me.name);
            }
            if(me.first_name){
                if(loginClick)$('.FBpop input:text[name="firstname"]').parent().addClass("facebook-specified");
                $('.FBpop input:text[name="firstname"]').val(me.first_name);
            }
            if(me.last_name){
                if(loginClick)$('.FBpop input:text[name="lastname"]').parent().addClass("facebook-specified");
            	$('.FBpop input:text[name="lastname"]').val(me.last_name);
            }
            if(me.email){
                if(loginClick)$('.FBpop input:text[name="email"]').parent().addClass("facebook-specified");
            	$('.FBpop input:text[name="email"]').val(me.email);
            	if(loginClick)$('.FBpop input:text[name="email"]').parent().addClass("facebook-specified");
            	$('.FBpop input:text[name="coupon[email]"]').val(me.email);
            }
            if(me.gender){
                if(me.gender == "male")
            		$('#patientGenderM').click();
            	else if(me.gender == "female")
            		$('#patientGenderF').click();
            }
            //document.getElementById('auth-displayname').innerHTML = me.name;
            $(".login-set").each(function(){$(this).hide();});
           	$("div.welcome").html('<p id="welcome_message"><img class="fb-photo-small" src="'+me.picture.data.url+'" /><a href="#">Sign Out</a></p>');
           	//<img src="'+me.picture.data.url+'"/>
			$("#welcome_message").click(function(){return FBlogout();});
			$(".fb-only").each(function(){$(this).show();});
			$("#facebookPhotoPreview").html('<img src="'+me.picture.data.url+'" />');
			if($("#showphoto").length > 0 && $("#showphoto").checked != "checked"){
				$("#showphoto").parent().find(".checkboxArea").click();
				updateFBPhotoPreview();
			}
			ResolvePrompt();
          }
        })
       	//$(".fb-logout").show();
      } else {
        // user has not auth'd your app, or is not logged into Facebook
        if($('#welcome_message').length == 0)
            $(".login-set").each(function(){$(this).show();});
       	//$(".fb-logout").hide();
      }
    });

	$(".fb-login").click(function(){
		//alert(window.location.hostname);
		loginClick = true;
		FB.login(function(response){}, {scope: 'email,user_location,user_birthday'});
	});

	$(function(){
		$('.login-modal').dialog({
			autoOpen:false,
			draggable:false,
			resizable:false,
			modal:true,
			closeText:'',
			dialogClass:'compare-dialog',
			width:390,
			show:'fade',
			hide:'fade'
		});
	});
  }

  function FBlogout(){
  	FB.logout();
  	$(".fb-only").each(function(){$(this).hide();});
  	if (forgetID > 0){
  	    forgetMe(forgetID);
  	}else{
      	$("div.welcome").html('');
      	$(".login-set").each(function(){$(this).show();});
  	}
  	return false;
  }

  function OpenLoginBox(){
        $('.login-modal').dialog("open");
  }
  function CloseLoginBox(){
        $('.login-modal').dialog("close");
  }
  
  function ResolvePrompt(){
  		$('#form-proper').show();
  		$('#form-prompt').hide();
  } 