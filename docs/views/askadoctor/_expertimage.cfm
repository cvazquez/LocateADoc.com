<cfoutput>
<div class="AskADocExpertsThumbnails">
	<div class="AskADocExpertsThumbnailBorder1">
	<div class="AskADocExpertsThumbnailBorder2">
	<div class="AskADocExpertsThumbnailBorder3">
		<cfsavecontent variable="altAndTitle">#experts.firstName# #experts.lastName#<cfif listLen(experts.title)>, #ListFirst(experts.title)#</cfif> - #experts.city#, #experts.state#</cfsavecontent>
		<a href="/#experts.siloName#" style="display: block;"><img style="display: block;" src="/images/profile/doctors/thumb/#experts.photoFilename#" width="63" height="72" alt="#altAndTitle#" title="#altAndTitle#"></a>
	</div>
	</div>
	</div>
	<a href="/#experts.siloName#">#experts.firstName# #experts.lastName#<cfif listLen(experts.title)>, #ListFirst(experts.title)#</cfif></a><br />
	#experts.city#, #experts.state#
</div>
</cfoutput>