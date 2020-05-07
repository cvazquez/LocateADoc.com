<cfparam name="title" default="">
<cfparam name="ShareText" default="#title#">
<cfparam name="Arguments.margins" default="0">
<cfoutput>
	<!-- social sidebox -->
	<div style="margin:#Arguments.margins#; display:inline-block;">
		<div style="line-height:40px; margin-bottom:10px; clear:right;">
			#includePartial("/shared/socialbuttons")#
		</div>
		<div id="more-social-link"><div class='st_sharethis' displayText='More Social Networks >>' st_title='#ShareText#' style="text-align:right;"></div></div>
	</div>
</cfoutput>