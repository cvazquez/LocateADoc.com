
<cfif server.thisServer EQ "dev">
	<cfset websiteLeadLinkPrefix = "http://carlos.practicedock.com">
<cfelse>
	<cfset websiteLeadLinkPrefix = "https://www.practicedock.com">
</cfif>
<cfset websiteLeadLink = "#websiteLeadLinkPrefix#/admin/LocateADoc/leads/index.cfm?id=#qProfileWebsiteClick.id#&type=website">

<cfoutput>
<HTML>
<HEAD>
	<style type="text/css">
		ul.PDOMS li a{
			font-weight:bold;
			text-decoration:none;
		}
		.first-button{
			margin-right:10px;
		}
		.social-button{
			width: 25px;
			height: 25px;
			display: inline-block;
			margin: 0 20px 0 5px;
		}
		 .BrowserDataLeft
		 {
		 	width: 25%;
		 }
		 .doctor-email-list
		 {
		 	margin-top: -10px!important;
		 	margin-bottom: 0px!important;
		 	margin-left: -30px!important;
		 }
	</style>
</HEAD>
<BODY>

<table style="margin:0px; padding:0px; border-spacing:0px; border:1px solid ##C4C4C4;">
	<tr style="margin:0px; padding:0px; font-size:0;"><td><A HREF="http://www.practicedock.com"><IMG SRC="http://www.locateadoc.com/images/layout/email/PDock_header.jpg" BORDER="0"></A></td></tr>
	<tr style="margin:0px; padding:0px;">
		<td style="width:554px; margin:0px; padding:15px;">

	<p>A potential patient found you on LocateADoc.com and went directly to your practice website.
		This link exchange helps <strong>improve your website ranking</strong>, plus when <strong>we send a potential patient to your website</strong> you can track the day, time, IP address and keyword search that led them to your LocateADoc.com profile page so you can check your website's visitors.</p>

	<p><a href="#websiteLeadLink#">View This Website Visitor</a>, the information we provide is useful to track the user on your websites analytical software</p>
	<cfif qDoctor.emails NEQ "">
		<p>
			<strong>This email was sent to:</strong><br />
			<cfloop list="#qDoctor.emails#" index="iE">
				&bull;&nbsp;#iE#<br />
			</cfloop>
		<cfif val(qDoctor.accountId) GT 0>
			<a style="font-size: xx-small;" href="https://www.practicedock.com/admin/accounts/setupwizard.cfm?account_id=#qDoctor.accountId#&a=account_tree&type=extended" target="_blank">Click here to add or remove an email address</a>.
		</cfif>
		</p>
	</cfif>

	<p><a href="#websiteLeadLink#"><img src="http://www.locateadoc.com/images/newsletters/view_this_visitor.png" width=107 height=35 border="0"></a>
	<a href="#websiteLeadLinkPrefix#/admin/LocateADoc/stats/folio_popup_view_ltp.cfm?account_id=#qDoctor.accountId#&FolioOnly=checked&MiniOnly=checked&PhoneOnly=checked&WebsiteOnly=checked"><img src="http://www.locateadoc.com/images/newsletters/view_all.png" width=107 height=35 border="0"></a></p>

	<p><a href="https://www.practicedock.com/index.cfm/PageID/7151">Login into the PracticeDock lead manager</a> now to view and respond to your patient leads.</p>

</td></tr></table>
</BODY>
</HTML>
</cfoutput>