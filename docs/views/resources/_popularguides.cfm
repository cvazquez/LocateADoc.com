<cfhtmlhead text='<script type="text/javascript" src="/resources/procedureselect"></script>'>
<cfset javaScriptIncludeTag(source="resources/procedure-select", head=true)>
<cfoutput>
<cfset clickTrackSection = "ResearchPopularProceduresAndTreatments">
<cfsavecontent variable="paramKeyValues">
	<cfloop collection="#params#" item="pC">
		<cfif isnumeric(params[pC])>
			#pC#:#val(params[pC])#;
		</cfif>
	</cfloop>
</cfsavecontent>
<cfsavecontent variable="clickTrackKeyValues">
	#paramKeyValues#
</cfsavecontent>

<!-- sidebox -->
<div class="sidebox">
	<div class="frame baap">
		#linkTo(	clickTrackSection	= "#clickTrackSection#",
					clickTrackLabel		= "Header",
					clickTrackKeyValues	= "#clickTrackKeyValues#",
		 			controller="article", action="locateadoccom-s-top-infographics",
		 			text="<h4>Research <strong>Procedures &amp; Treatments</strong></h4>",
		 			style="text-decoration: none;")#
		<div class="gallery">
			<div class="holder">
				<span class="text med resource-procedure-box">
					<input id="procedurename" type="text" value="" class="txt">
				</span>
				<p>Start typing a procedure or treatment name into the field above.</p>

				<h2>Popular Resource Guides</h2>
			</div>

			<ul id="RecentCategories">
			<cfloop query="popularResourceGuides">
				<li class="RecentCategory">
					#linkTo(	text		= popularResourceGuides.name,
								controller	= popularResourceGuides.siloname,
								class		= "RecentCategoryLink",
								clickTrackSection	= "#clickTrackSection#",
								clickTrackLabel		= "PopularResourceGuides",
								clickTrackKeyValues	= "#clickTrackKeyValues#")#
				</li>
			</cfloop>
			</ul>

			<div class="TextAlignRight"><a href="/resources/guides">view all Guides</a></div>
		</div>
	</div>
</div>
</cfoutput>