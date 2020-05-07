<cfoutput>
	<cfif coupons.recordcount gt 0>
	<!-- sidebox -->
	<div class="sidebox">
		<div class="frame">
			<h4>Special <strong>Offers</strong></h4>
			<div class="specialoffers-box">
				<cfloop query="coupons">
					<h5>#LinkTo(controller="#doctor.siloname#",action="offers",text=title,anchor="offer"&id)#</h5>
					<p>#details#</p>
				</cfloop>
			</div>
		</div>
	</div>
	</cfif>
</cfoutput>