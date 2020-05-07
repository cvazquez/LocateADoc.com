<cfoutput>
	<div>
		<h1>#search.searchHeader#</h1>
		<cfif Len(trim(search.searchSummary)) gt 0><h2>#trim(search.searchSummary)#</h2></cfif>
		<cfif search.landingContent neq "" and params.page eq 1>
			<div class="landing-content">
				#search.landingContent#
			</div>
		</cfif>

		<div class="col">
			<span class="totalmatched">
				(#search.totalRecords# case<cfif #search.totalRecords# neq 1>s</cfif> matched your search)
			</span>
			#includePartial("/shared/pagination#mobileSuffix#")#
		</div>
	</div>
</cfoutput>