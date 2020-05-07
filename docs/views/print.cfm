<cfparam name="title" default="LocateADoc.com">
<cfparam name="wrapperClass" default="">
<cfparam name="canonicalURL" default="">
<cfparam name="doNotIndex" default="false">
<cfoutput>
<cfif params.controller eq "profile">
	#includePartial("/profile/map")#
</cfif>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<cfif NOT doNotIndex>
	<cfif canonicalURL neq "">
		<link rel="canonical" href="#canonicalURL#" />
	</cfif>
	</cfif>
	<meta name="robots" content="noindex, nofollow">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>#title#</title>
	<!-- Stylesheets -->
	#styleSheetLinkTag(sources="
		all,
		form,
		jquery.jscrollpane,
		http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.14/themes/base/jquery-ui.css,
		http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.14/themes/sunny/jquery-ui.css,
		print-view")#
	<!--[if lt IE 8]>#styleSheetLinkTag("ie")#<![endif]-->
	#includeContent("customCSS")#
	<!-- Javascripts -->
	<!--- http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.js, --->
	#javaScriptIncludeTag(sources="
		https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js,
		http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js,
		main,
		http://s7.addthis.com/js/250/addthis_widget.js##pubid=mojouser")#
	#includeContent("customJS")#
	<script type="text/javascript">
		window.google_analytics_uacct = "UA-4266205-3";
	</script>
</head>
<body>
<div id="wrapper" class="printable">
	<div class="w1">
		<div class="w2">
			<div class="w3">
			<img src="/images/layout/logo.gif" />
			<div class="print-options">
				<a href="##" class="addthis_button_print addthis-image-override hidefromprint" <!--- onclick="window.print(); return false;" --->>PRINT</a>
				<a href="##" class="hidefromprint" onclick="window.close(); return false;">CLOSE</a>
			</div>
				<cfif params.controller eq "profile">
					#includePartial("/profile/topsection")#
				</cfif>
				#includePartial("/shared/noscript")#
				#includeContent()#

				<div id="footer">
					<div class="frame">
						#includePartial("/shared/footercopyright")#
						#includePartial("/shared/footerlogos")#
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

</body>
</html>
</cfoutput>