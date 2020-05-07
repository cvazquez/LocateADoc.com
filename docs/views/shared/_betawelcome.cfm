<!---

<cfparam name="Client.BetaWelcome" default="">
<cfparam name="URL.BetaWelcome" default="">

<cfif Client.BetaWelcome eq "" or URL.BetaWelcome neq "">
	<cfset Client.BetaWelcome = DateFormat(now(),"full") & " " & TimeFormat(now(),"full")>
	<cfoutput>
		#styleSheetLinkTag(source="thickbox", head=true)#
		#javaScriptIncludeTag(source="thickbox", head=true)#
		<script>
			$(function(){
					$("##BetaWelcomeLink").click();
			})
		</script>
		<div class="hidden" id="BetaWelcome">
			<a href="##TB_inline?width=450&height=370&inlineId=BetaWelcome" title="Welcome to LocateADoc 3.0 Beta" class="thickbox" id="BetaWelcomeLink"></a>
			<h1>Welcome to the new LocateADoc.com</h1>
			<p>Thank you for helping us better your patient experience on LocateADoc.com. Please provide feedback via the feedback button on the right hand side of each page. Thank you for participating and voicing your opinions.</p>
			<p align="center" style="margin:0; padding:0;"><img src="/images/layout/betawelcome.png"></p>
		</div>
	</cfoutput>
</cfif>
 --->
