<cfparam name="embedFaceTouchup" default="false">
<cfoutput>
			<div id="header">
				#mojoIncludePartial("/shared/mainnav")#
				#mojoIncludePartial("/shared/additionalnav")#
				<a class="hidden" href="##wrapper">Back to top</a>
				#mojoIncludePartial("/shared/searchform")#
				<cfif not isError>#mojoIncludePartial("/shared/welcome")#</cfif>

				<!--- <div id="DoctorsOnlyNav">
					<a href="/doctor-marketing/add-listing" id="DoctorsOnlyNavLink">
						<input onClick="DoctorsOnlyNavButton();" class="btn-doctorsonly btn-large-text" id="DoctorsOnlyNavButton" type="submit" value="Doctors Only">
					</a>
				</div> --->
			</div>
		</div>
		<div id="footer">
			<div class="footer">
				<div class="slide-block active">
					<div class="title">
						<a href="##" class="open-close"><span>Expand +</span><em>Collapse -</em></a>
					</div>
					#mojoIncludePartial("/shared/footernav")#
					<div class="block">
						<div class="holder">
							<div class="frame">
								#mojoIncludePartial("/shared/footercopyright")#
								#mojoIncludePartial("/shared/footerlogos")#
							</div>
						</div>
					</div>
				</div>
			</div>
			</div>
		</div>
	</div>
</div>
<!--- Include all the divs for modal windows --->
<cfif not isError>#includeContent("modalWindows")#</cfif>
<!--- Debug mode indicator --->
<cfif not isError>#mojoIncludePartial("/shared/modeindicators")#</cfif>

<script type="text/javascript">
	var __chd__ = {"aid":11082,"chaid":"www_locateadoc_com"};(function() { var c = document.createElement('script'); c.type = 'text/javascript'; c.async = true;c.src = ('https:' == document.location.protocol ? 'https://z': 'http://p') + '.chango.com/static/c.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(c, s);})();
</script>


<!--- Face touch up app embed code --->
<cfif embedFaceTouchup>
<script type="text/javascript" src="http://www.facetouchup.com/app/ftu_embed.js"></script>
</cfif>

<cfif NOT doNotIndex>
<img border="0" alt="" src="/backend/asfree/autositemap/autositemap.php">
</cfif>
</body>
</html>
</cfoutput>