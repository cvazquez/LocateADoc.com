<cfoutput>
<div class="sidebox trending">
	<div class="frame">
		<h4>Trending <strong>Topics</strong></h4>
		<ul>
		<cfloop query="trendingTopics">
			<cfif specialtyId gt 0>
				<li><a href="#URLFor(controller=trendingTopics.specialtySiloName)#">#specialtyname# Guide</a></li>
			<cfelse>
				<li><a href="#URLFor(controller=trendingTopics.procedureSiloName)#">#procedurename# Guide</a></li>
			</cfif>
		</cfloop>
		</ul>
	</div>
</div>
</cfoutput>