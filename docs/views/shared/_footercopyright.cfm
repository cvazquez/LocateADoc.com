<cfparam name="Request.currentURL" default="http://www.locateadoc.com">
<cfparam name="Request.isMobileBrowser" default="false">
<cfparam name="Client.forcemobile" default="false">
<cfset thisURL = ReReplace(ReReplace(Request.currentURL,"desktop=[01]&?","","all"),"(\?|&)$","")>
<cfoutput>
	<div class="text-box">
		<p>Content &copy; 1998-#Year(Now())# LocateADoc.com. All Rights Reserved.</p>
		<p>Design and Programming &copy; 1998-#Year(Now())# <a href="http://www.mojointeractive.com">Mojo Interactive</a></p>
		<p>All of the information on LocateADoc.com, (except for information provided by members of the LocateADoc.com community), is either written by health professionals or supported by public health recommendations.</p>
		<br>
		<p>
			<a href="/home/about" class="about">About Us</a> |
			<a href="/home/privacy">Privacy Notice</a> |
			<a href="/home/terms">Conditions of Use</a> |
			<a href="/sitemap">Site Map</a> |
			<a href="http://tweets.locateadoc.com">Recent Tweets</a> |
			<a href="/home/about##advisoryboard">Advisory Board</a>
			<cfif Request.isMobileBrowser or Client.forcemobile> | <a href="#thisURL##thisURL contains "?" ? "&" : "?"#desktop=0">Mobile Version</a></cfif>
		</p>
	</div>
</cfoutput>