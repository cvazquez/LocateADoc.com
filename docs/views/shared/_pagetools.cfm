<cfparam name="title" default="">
<cfparam name="ShareText" default="#title#">
<cfparam name="params.silourl" default="">
<cfparam name="doNotIndex" default="false">
<cfif NOT doNotIndex>
<cfoutput>
	<div class="options">
		<ul>
			<li class="email-link"><span class="st_email" displayText="Email" st_title="#ShareText#"></span></li>
			<li class="print-link"><a href="#params.silourl##params.silourl contains "?"?"&":"?"#print-view" target="_blank" title="Show printable format" rel="alternate">Print</a></li>
			<li class="share-link"><span class='st_sharethis' displayText='Share' st_title='#ShareText#'></span></li>
		</ul>
	</div>
</cfoutput>
</cfif>