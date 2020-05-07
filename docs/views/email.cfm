<cfparam name="title" default="LocateADoc.com">
<cfparam name="wrapperClass" default="">
<cfparam name="canonicalURL" default="">
<cfparam name="params.firstname" default="">
<cfparam name="params.emailTo" default="">


<cfoutput>
<cfif params.controller eq "profile">
	#includePartial("/profile/map")#
</cfif>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<cfif canonicalURL neq "">
		<link rel="canonical" href="#canonicalURL#" />
	</cfif>
	<meta name="robots" content="noindex, nofollow">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>#title# - Email</title>
</head>
<body style="margin: 0; color: ##6c6c6c; font: 12px BreeRegular, Arial, Helvetica, sans-serif; background: ##fff; width: #layoutWidth#px">
<a href="http://www.locateadoc.com" target="_blank"><img src="/images/mobile/emails/locateadoc-email-header.jpg" style=" border-style: none;"></a>
<div style="position: relative; overflow: hidden; margin: 0px; width: #layoutWidth#px!important;">
	<div  style="background: none!important;">
		<div  style="margin: 0 0 0 0!important;">
			<div  style="margin: 0 auto; position: relative; width: #layoutWidth#px!important; padding-top: 0px!important;">


				<cfif params.controller eq "profile">
					#includePartial("/profile/topsection")#
				</cfif>

				<cfif listFirst(params.firstname) NEQ "" OR listFirst(params.emailTo) NEQ "">
					<p>
					<strong>
					<cfif listFirst(params.firstname) NEQ "">
						#FormalCapitalize(listFirst(params.firstname))#
					<cfelse>
						#listFirst(params.emailTo)#
					</cfif>,
					</strong>
					</p>
				</cfif>

				<p>Thanks for your Ask A Doctor question. As requested, we've included a list of doctors in your area.</p>

				#includeContent()#

				<cfset layoutWidth = layoutWidth - 20>
				<div id="footer" style=" margin-left: 10px; margin-right: 10px; background: none!important; width: #layoutWidth#px">
					<div class="frame" style="width: #layoutWidth#px; display: block; clear: both;">
						<div class="text-box" style="width: #layoutWidth#px; float: left; margin-right: -5px; font: 12px/15px BreeLight, Arial, Helvetica, sans-serif; color: ##787268;">
							<p style="margin: 0; font: 12px/15px BreeLight, Arial, Helvetica, sans-serif;">Content &copy; 1998-2014 LocateADoc.com.<br />All Rights Reserved.</p>
							<p style="margin: 0; font: 12px/15px BreeLight, Arial, Helvetica, sans-serif;">Design and Programming<br />&copy; 1998-2014 <a href="http://www.mojointeractive.com">Mojo Interactive</a></p>
							<p style="margin: 0; font: 12px/15px BreeLight, Arial, Helvetica, sans-serif;">All of the information on LocateADoc.com, (except for information provided by members of the LocateADoc.com community), is either written by health professionals or supported by public health recommendations.</p>
							<br>
							<p style="margin: 0; font: 12px/15px BreeLight, Arial, Helvetica, sans-serif;">
								<a href="/home/about" class="about" style="color: ##0e7496;">About Us</a> |
								<a href="/home/privacy" style="color: ##0e7496;">Privacy Notice</a> |
								<a href="/home/terms" style="color: ##0e7496;">Conditions of Use</a> |
								<a href="/sitemap" style="color: ##0e7496;">Site Map</a> |
								<a href="http://tweets.locateadoc.com" style="color: ##0e7496;">Recent Tweets</a> |
								<a href="/home/about##advisoryboard" style="color: ##0e7496;">Advisory Board</a>
							</p>
						</div>
					</div>

					<div style="width: #layoutWidth#px; display: block; clear: both; padding-top: 20px;">
						<ul class="social-icons" style="padding: 0; margin: 0 0 10px; width: #layoutWidth#px; height: 32px;  list-style: none;">
							<li style="padding-top:10px; margin: 0; padding-left: 10px; float: left;">Find us on:</li>
							<li style="margin: 0; padding-left: 8px; float: left;"><a href="http://facebook.com/locateadoc" target="_blank" id="facebook-icon" title="Join our conversation on Facebook" style="background: url(http://www.locateadoc.com/images/layout/facebook-chiclet.png) no-repeat top left; font-size: 0; line-height: 0; width: 32px; height: 32px; display: block;">Facebook</a></li>
							<li style="margin: 0; padding-left: 20px; float: left;"><a href="http://twitter.com/locateadoc" target="_blank" id="twitter-icon" title="Follow us on Twitter" style="background: url(http://www.locateadoc.com/images/layout/twitter-chiclet.png) no-repeat top left; font-size: 0; line-height: 0; width: 32px; height: 32px; display: block;">Twitter</a></li>
							<li style="margin: 0; padding-left: 20px; float: left; "><a href="http://youtube.com/locateadoccom" target="_blank" id="youtube-icon" title="Subscribe to our YouTube channel" style="background: url(http://www.locateadoc.com/images/layout/youtube-chiclet.png) no-repeat top left; font-size: 0; line-height: 0; width: 32px; height: 32px; display: block;">YouTube</a></li>
							<li style="margin: 0; padding-left: 22px; float: left; "><a href="http://pinterest.com/locateadoc/" target="_blank" id="pinterest-icon" title="Check us out on Pinterest" style="width: 28px; height: 30px; margin-top: 1px; background: url(http://www.locateadoc.com/images/layout/pinterest-chiclet.png) no-repeat top left; font-size: 0; line-height: 0; display: block;">Pinterest</a></li>
						</ul>
						<ul class="logos" style="padding: 0;margin: 0; width: #layoutWidth#px; float: right;">
							<li style="padding-left: 28px; display: inline; vertical-align: middle;"><img src="/images/layout/logo3-footer.gif" width="48" height="48" alt="VeriSign Secure Site" style="ertical-align: middle; border-style: none;" /></li>
						</ul>
					</div>

				</div>
			</div>
		</div>
	</div>
</div>

</body>
</html>
</cfoutput>