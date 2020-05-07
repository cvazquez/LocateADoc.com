<cfoutput>
	<div class="video-holder">
		<table>
			<tr>
				<cfif photoFilename neq "">
					<td valign="top">
						<div class="staff-photo">
							<img src="/images/profile/staff/#photoFilename#" />
						</div>
					</td>
				</cfif>
				<td>
					<h3>#name#</h3>
					<p><strong>#title#</strong></p>
					<p>#description#</p>

					<cfif testimonial NEQ "">
						<p><strong>What do our clients say they love about this Staff Member?</strong></p>
						<p>#testimonial#</p>
					</cfif>
				</td>
			</tr>
		</table>
	</div>
</cfoutput>
