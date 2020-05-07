<cfoutput>
	<div class="video-holder">
	<cfif staffInfo.photoFilename neq "">
		<div class="staff-photo">
			<img src="/images/profile/staff/#staffInfo.photoFilename#" />
		</div>
	</cfif>
	<div class="staff-description">
		<h3>#staffInfo.name#</h3>
		<p><strong>#staffInfo.title#</strong></p>
		<p>#staffInfo.description#</p>

		<cfif staffInfo.testimonial NEQ "">
			<p><strong>What do our clients say they love about this Staff Member?</strong></p>
			<p>#staffInfo.testimonial#</p>
		</cfif>
	</div>
	</div>
</cfoutput>
