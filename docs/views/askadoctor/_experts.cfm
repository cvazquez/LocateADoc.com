<cfhtmlhead text='<script type="text/javascript" src="/javascripts/askadoctor/experts.js"></script>'>
<cfset styleSheetLinkTag(source	= "askadoctor/experts", head	= true)>

<!-- sidebox -->
<cfoutput>
<div class="sidebox">
	<div class="frame">
		<h4 class="withsubtitle">Ask A Doctor <strong>Experts</strong></h4><br />


			<cfloop query="experts" startrow="1" endrow="3">
				#includePartial("expertimage")#
			</cfloop>


		<cfif experts.recordCount GT 3>
		<div class="clear"></div>
		<p>
			<cfloop query="experts" startrow="4" endrow="6">
				#includePartial("expertimage")#
			</cfloop>
		</p>
		</cfif>

		<cfif experts.recordCount GT 6>
		<div class="clear"></div>
		<div class="AskADocExpertsHidden" id="AskADocExpertsHidden" style="display:none;">
			<p class="hide">
			<cfloop query="experts" startrow="7" endrow="9">
				#includePartial("expertimage")#
			</cfloop>
			</p>
		</div>
		</cfif>

		<cfif experts.recordCount GT 9>
		<div class="clear"></div>
		<div class="AskADocExpertsHidden" id="AskADocExpertsHidden" style="display:none;">
			<p class="hide">
				<cfloop query="experts" startrow="10" endrow="12">
					#includePartial("expertimage")#
				</cfloop>
			</p>
		</div>
		</cfif>

		<cfif experts.recordCount GT 6>
			<div class="clear"></div>
			<!--- <div style="padding-top: 10px;">
			<a href="/ask-a-doctor/experts/page-2" id="ViewMoreExpertsLink">
			#submitTag(	alt		= "View More Ask A Doctor Experts",
						title	= "View More Ask A Doctor Experts",
						value	= "View More",
						class	= "btn-search btn-large-text",
						id		= "ViewMoreExperts")#</a>
			</div> --->
			<div class="TextAlignRight"><a href="/ask-a-doctor/experts/page-2" id="ViewMoreExperts">view more experts</a></div>
		</cfif>
	</div>
</div>
</cfoutput>