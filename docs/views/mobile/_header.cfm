<cfheader name="vary" value="User-Agent">
<cfparam name="additionalCSS" default="">
<cfparam name="additionalJS" default="">
<cfparam name="analyticsPageTrack" default="">
<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<html>
		<head>
			<title>Find Doctors for Breast Implants, Augmentation & Plastic Surgery | LocateADoc.com</title>
			<cfif params.action neq "index"><meta name="robots" content="noindex, nofollow"></cfif>
			<meta name="description" content="Research your procedure and find doctors in your area for plastic surgery, breast implants, breast augmentation, and more.">
			<meta name="keywords" content="breast augmentation, liposuction, tummy tuck, plastic surgery, cosmetic surgery, hair restoration, lasik, lasik eye surgery, cosmetic dentistry, dental implants">
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<meta name="viewport" content="width=device-width; initial-scale=1;<!---  maximum-scale=1.0; minimum-scale=1; --->" />

			<!--- CSS --->
			<link rel="stylesheet" type="text/css" href="#Server.jquery.ui.css.core#">
			<link rel="stylesheet" type="text/css" href="/stylesheets/mobile/mobile.css">
			<link rel="stylesheet" type="text/css" href="/stylesheets/mobile/lad3fonts.css">
			<link rel="stylesheet" type="text/css" href="/stylesheets/mobile/anythingslider.css">
			#additionalCSS#
			<style>
				##slider, ##slider li {width: 290px;height: 167px;}
				div.anythingSlider {padding-bottom:0;margin-left:-45px;}
			</style>

			<!--- JS --->
			<script src="#Server.jquery.core#"></script>
			<script src="#Server.jquery.ui.core#"></script>
			<script src="/javascripts/mobile/jquery.anythingslider.min.js"></script>
			<script src="/javascripts/mobile/jquery.anythingslider.fx.min.js"></script>
			#additionalJS#
			<script type="text/javascript">var _gaq=_gaq || [];_gaq.push(['_setAccount','UA-4266205-1']);_gaq.push(['_setDomainName', 'locateadoc.com']);_gaq.push(['_trackPageview'<cfif analyticsPageTrack neq "">, '#analyticsPageTrack#'</cfif>]);(function() {var ga=document.createElement('script'); ga.type='text/javascript'; ga.async=true;ga.src=('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';var s=document.getElementsByTagName('script')[0];s.parentNode.insertBefore(ga,s);})();</script>
		</head>
		<body>
			<div id="page-wrapper">
				<div id="header-wrapper">
					<div id="header">
						<div class="centered">
							<img src="/images/mobile/logo<cfif month(now()) eq 10>-breast</cfif>.png">
						</div>
					</div>
				</div>
				<div class="site">
</cfoutput>