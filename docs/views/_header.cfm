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

<cfheader name="vary" value="User-Agent">

<cfset forceDoNotIndex = false>
<cfif structKeyExists(URL, "debug") or ReFindNoCase("^static[0-9]+\.locateadoc\.com$", CGI.HTTP_HOST)>
	<cfset doNotIndex = true>
	<cfset forceDoNotIndex = true>
</cfif>

<!--- These functions are needed for error pages --->
<cffunction name="mojoIncludePartial">
	<cfargument name="partial" type="any" required="true" hint="See documentation for @renderPartial.">
	<cfset var Local = {}>
	<cfset Local.returnContent = "">
	<cfset Local.fileName = "_" & ReplaceNoCase(ListLast(arguments.partial, "/"), ".cfm", "", "all") & ".cfm">
	<cfset Local.folderName = Reverse(ListRest(Reverse(arguments.partial), "/"))>
	<cfsavecontent variable="Local.returnContent">
		<cfinclude template="/views#Local.folderName#/#Local.fileName#">
	</cfsavecontent>
	<cfreturn Local.returnContent>
</cffunction>
<cffunction name="mojoStyleSheetLinkTag">
	<cfargument name="sources" type="string" required="false" default="" hint="The name of one or many CSS files in the `stylesheets` folder, minus the `.css` extension.">
	<cfset var Local = {}>
	<cfsavecontent variable="Local.css">
		<cfloop list="#Arguments.sources#" index="Local.i">
			<cfif Left(Trim(Local.i), 4) eq "http">
				<cfoutput>
					<link href="#Trim(Local.i)#" media="all" rel="stylesheet" type="text/css" />
				</cfoutput>
			<cfelse>
				<cfoutput>
					<link href="/stylesheets/#Trim(Local.i)#.css?#Hash(DateFormat(Now(), "yyyymmdd") & TimeFormat(Now(), "HHmmss"))#" media="all" rel="stylesheet" type="text/css" />
				</cfoutput>
			</cfif>
		</cfloop>
	</cfsavecontent>
	<cfreturn fnCompress(Local.css)>
</cffunction>
<cffunction name="mojoJavaScriptIncludeTag">
	<cfargument name="sources" type="string" required="false" default="" hint="The name of one or many JS files in the `javascripts` folder, minus the `.js` extension.">
	<cfset var Local = {}>
	<cfsavecontent variable="Local.js">
		<cfloop list="#Arguments.sources#" index="Local.i">
			<cfif Left(Trim(Local.i), 4) eq "http">
				<cfoutput>
					<script src="#Trim(Local.i)#" type="text/javascript"></script>
				</cfoutput>
			<cfelse>
				<cfoutput>
					<script src="/javascripts/#Trim(Local.i)#.js??#Hash(DateFormat(Now(), "yyyymmdd") & TimeFormat(Now(), "HHmmss"))#" type="text/javascript"></script>
				</cfoutput>
			</cfif>
		</cfloop>
	</cfsavecontent>
	<cfreturn fnCompress(Local.js)>
</cffunction>

<cfoutput>
	<cfif params.controller eq "profile" and not isError>
		#mojoIncludePartial("/profile/map")#
	</cfif>
	<cfif title eq "">
		<cfset title = "Find Doctors and Dentists for Breast Augmentation, LASIK, Plastic Surgery, Dental Veneers, Hair Restoration">
	</cfif>
	<cfset title = REReplace(title,"<[Bb][Rr][^>]*?>"," ","all")>
	<!--- <cfif metaDescriptionContent eq "">
		<cfset metaDescriptionContent = "Research your procedure and find doctors in your area for plastic surgery, breast implants, breast augmentation, and more.">
	</cfif> --->
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
	<head>
		<meta name="msvalidate.01" content="01C07C92C5F49D34E8972E79EEB708FD" />
		<meta name="SKYPE_TOOLBAR" content="SKYPE_TOOLBAR_PARSER_COMPATIBLE" />
		<meta name="p:domain_verify" content="166f9d65a48d1bd4a69ada3f516024ec" >
		<!--- Remove the below tag when ready --->
		<cfif forceDoNotIndex or (doNotIndex AND canonicalURL eq "")>
			<meta name="robots" content="noindex<!--- , nofollow --->" />
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
		<cfset og_title = title>
		<cfset og_description = trim(metaDescriptionContent)>
		<cfset ShareText = title>
		#mojoIncludePartial("/shared/socialmediameta")#
		<cfif not doNotIndex>
			<cfif relNext neq "">
				<link rel="next" href="#relNext#" />
			</cfif>
			<cfif relPrev neq "">
				<link rel="prev" href="#relPrev#" />
			</cfif>
		</cfif>
		<title>#trim(StripHTMLInclusiveReplaceScripts(title))# | LocateADoc.com</title>

		<!-- Stylesheets -->
			<cfif params.controller NEQ "home" OR ListFind("index,feedback", params.action)>
				#mojoStyleSheetLinkTag(sources="
					all,
					form,
					jquery.jscrollpane,
					facebook")#
			<cfelse>
				#mojoStyleSheetLinkTag(sources="all,facebook")#
			</cfif>
			#mojoStyleSheetLinkTag(sources="
				https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/base/jquery-ui.css,
				https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/sunny/jquery-ui.css,
				jquery.tooltip,
				custom_select")#

			<!--[if lt IE 8]>#mojoStyleSheetLinkTag("ie")#<![endif]-->
			<cfif not isError>#includeContent("customCSS")#</cfif>

		<!-- Javascripts -->
		<script type="text/javascript" src="/common/procedureselectdata"></script>
		#mojoJavaScriptIncludeTag(sources="
			#server.jquery.core#,
			#server.jquery.ui.core#,
			main,
			cookie,
			jquery.tooltip.min,
			custom_select")#
		<cfif not isError>#includeContent("customJS")#</cfif>
		<script type="text/javascript" language="javascript">
			window.google_analytics_uacct = "UA-4266205-1";
		</script>
		<!--- ShareThis --->
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
					headerTitle:'Share This Page - LocateADoc.com',
					doNotCopy:true,
					shorten:false
				});
			</script>
			<!-- ShareThis Buttons END -->
			<cfset Request.ShareHeadIncluded = "true">
		</cfif>
		<!--- Google Analytics - Keep at bottom before closing head tag --->
		<cfparam name="analyticsPageTrack" default="">
		<script type="text/javascript">
			var _gaq = _gaq || [];
			// test
			_gaq.push(['_setAccount', 'UA-4266205-1']);
			_gaq.push(['_setDomainName', 'locateadoc.com']);
			<cfif analyticsPageTrack neq "">
				_gaq.push(['_trackPageview', '#analyticsPageTrack#']);
			<cfelse>
				_gaq.push(['_trackPageview']);
			</cfif>
			(function() {
				var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
				ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js';
				var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
			})();
		</script>
	</head>
	<body>
	<div id="wrapper"#wrapperClass#>
		<div class="w1">
			<div class="w2">
				<div class="w3">
				#mojoIncludePartial("/shared/logo")#
</cfoutput>