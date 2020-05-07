<cfparam name="title" default="">
<cfparam name="wrapperClass" default="">
<cfparam name="metaDescriptionContent" default="">
<cfparam name="metaKeywordsContent" default="">
<cfparam name="canonicalURL" default="">
<cfparam name="Request.ShareHeadIncluded" default="">
<cfparam name="doNotIndex" default="false">
<cfparam name="relNext" default="">
<cfparam name="relPrev" default="">
<cfparam name="isError" default="false">
	<cfparam name="additionalCSS" default="">
	<cfparam name="additionalJS" default="">
	<cfparam name="analyticsPageTrack" default="">

<cfheader name="vary" value="User-Agent">

<!--- Make sure that links are not end up on mobile lead gen form --->
<cfif not Client.skipmobile>
	<!--- <cfset Client.skipmobile = true> --->
</cfif>

<cfif structKeyExists(URL, "debug") or ReFindNoCase("^static[0-9]+\.locateadoc\.com$", CGI.HTTP_HOST)>
	<cfset doNotIndex = true>
</cfif>

<cfoutput>
	<cfif title eq "">
		<cfset title = "Find Doctors and Dentists for Breast Augmentation, LASIK, Plastic Surgery, Dental Veneers, Hair Restoration">
	</cfif>
	<cfset title = REReplace(title,"<[Bb][Rr][^>]*?>"," ","all")>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
	<head>
		<meta name="msvalidate.01" content="01C07C92C5F49D34E8972E79EEB708FD" />
		<meta name="SKYPE_TOOLBAR" content="SKYPE_TOOLBAR_PARSER_COMPATIBLE" />
		<meta name="p:domain_verify" content="166f9d65a48d1bd4a69ada3f516024ec" >
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<!--- Remove the below tag when ready --->
		<cfif doNotIndex>
			<meta name="robots" content="noindex, nofollow" />
		</cfif>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<!--- Use whitespace to indicate no meta tag --->
		<cfif trim(metaDescriptionContent) neq "">
			<meta name="description" content="#trim(metaDescriptionContent)#">
		</cfif>
		<cfif canonicalURL neq "">
			<link rel="canonical" href="#canonicalURL#" />
		</cfif>

		<!-- Standard iPhone -->
		<link rel="apple-touch-icon" sizes="57x57" href="/touch-icon-iphone-114.png" />
		<!-- Retina iPhone -->
		<link rel="apple-touch-icon" sizes="114x114" href="/touch-icon-iphone-114.png" />
		<!-- Standard iPad -->
		<link rel="apple-touch-icon" sizes="72x72" href="/touch-icon-ipad-144.png" />
		<!-- Retina iPad -->
		<link rel="apple-touch-icon" sizes="144x144" href="/touch-icon-ipad-144.png" />

		<cfif metaKeywordsContent neq ""><meta name="keywords" content="#metaKeywordsContent#"></cfif>
<!---
		<cfset og_title = title>
		<cfset og_description = trim(metaDescriptionContent)>
		<cfset ShareText = title>
		#mojoIncludePartial("/shared/socialmediameta")#
 --->
		<cfif not doNotIndex>
			<cfif relNext neq "">
				<link rel="next" href="#relNext#" />
			</cfif>
			<cfif relPrev neq "">
				<link rel="prev" href="#relPrev#" />
			</cfif>
		</cfif>
		<title>#title#</title>

		<!--- Stylesheets --->
		<link rel="stylesheet" type="text/css" href="#Server.jquery.ui.css.core#">
		<link rel="stylesheet" href="//code.jquery.com/mobile/1.3.0/jquery.mobile-1.3.0.min.css" />
		<!--- <link rel="stylesheet" type="text/css" href="/stylesheets/mobile/jquery.mobile.css"> --->
		<link rel="stylesheet" type="text/css" href="/stylesheets/mobile/mobile.css">
		<link rel="stylesheet" type="text/css" href="/stylesheets/mobile/lad3fonts.css">
		<link rel="stylesheet" type="text/css" href="/stylesheets/mobile/anythingslider.css">
		#additionalCSS#
		<style>
			##slider, ##slider li {width: 290px;height: 167px;}
			div.anythingSlider {padding-bottom:0;margin-left:-45px;}
		</style>

	<!--- Javascripts --->
	<script type="text/javascript" src="/common/procedureselectdata"></script>
	<script src="#Server.jquery.core#"></script>
	<script src="#Server.jquery.ui.core#"></script>
	<script src="/javascripts/mobile/jquery.anythingslider.min.js"></script>
	<script src="/javascripts/mobile/jquery.anythingslider.fx.min.js"></script>
	<script src="/javascripts/mobile/main.js"></script>
	<!---
	Don't turn on. This code will break the Browse Doctor's By Body Part http://www.locateadoc.com/doctors
	<script>
	    $(document).on("mobileinit", function () {
	        $.mobile.hashListeningEnabled = false;
	        $.mobile.pushStateEnabled = false;
	        $.mobile.changePage.defaults.changeHash = false;

	        $.mobile.ajaxEnabled = false;
		    $.mobile.hashListeningEnabled = false;
	    });
	</script> --->
	<script src="//code.jquery.com/mobile/1.3.0/jquery.mobile-1.3.0.min.js"></script>
	<script type="text/javascript">
		$(function(){
			<!--- $("##page-wrapper a").attr("rel","external"); --->
			$(".nomobile").css("display","none");
			$(".dateflag br").replaceWith(" ");
		})
	</script>
	#additionalJS#

		<!--- ShareThis --->
<!---
		<cfif Request.ShareHeadIncluded eq "">
			<!-- ShareThis Buttons BEGIN -->
			<script type="text/javascript">
				var switchTo5x=false;
				var __st_loadLate=true; //if __st_loadLate is defined then the widget will not load on domcontent ready
			</script>
			#mojoJavaScriptIncludeTag("https://ws.sharethis.com/button/buttons.js")#
			<script type="text/javascript">
				stLight.options({
					publisher: "1d4deb23-992b-4a0e-9895-6ec71a191801",
					onhover: false,
					theme:'5',
					headerTitle:'Share This Page - LocateADoc.com'
				});
			</script>
			<!-- ShareThis Buttons END -->
			<cfset Request.ShareHeadIncluded = "true">
		</cfif>
 --->
		<!--- Google Analytics - Keep at bottom before closing head tag --->
		<script type="text/javascript">
			var _gaq = _gaq || []; _gaq.push(['_setAccount', 'UA-4266205-1']); _gaq.push(['_setDomainName', 'locateadoc.com']); <cfif analyticsPageTrack neq "">_gaq.push(['_trackPageview', '#analyticsPageTrack#']);<cfelse>_gaq.push(['_trackPageview']);</cfif>
			(function() {var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true; ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);})();
		</script>
	</head>
	<body>
		<div id="page-wrapper" data-role="page">
			<div id="header-wrapper">
				<div id="header">
					<div id="mobile-logo-wrapper" class="centered" data-role="collapsible" data-iconpos="right" data-theme="b" data-collapsed-icon="arrow-d" data-expanded-icon="arrow-u" data-inset="true">
						<!--- <h3 id="mobile-logo" style="background-image: url(/images/mobile/logo<cfif month(now()) eq 10>-breast</cfif>.png);">LocateADoc.com</h3> --->
						<h3 id="mobile-logo"><img src="/images/mobile/logo<cfif month(now()) eq 10>-breast</cfif>.png" border="0" width="250"></h3>
						<ul data-role="listview" data-inset="true" data-theme="b">
							<li><a href="/">HOME</a></li>
							<li><a href="/doctors">FIND A DOCTOR</a></li>
							<li><a href="/pictures">BEFORE AND AFTER GALLERY</a></li>
							<li><a href="/ask-a-doctor">ASK A DOCTOR</a></li>
							<li><a href="/resources">RESOURCES</a></li>
							<li><a href="/resources/blog-list">BlOG</a></li>
							<li><a href="/financing">FINANCING</a></li>
							<li><a href="/doctor-marketing">DOCTORS ONLY</a></li>
						</ul>
					</div>
				</div>
			</div>
			<div class="site">
</cfoutput>