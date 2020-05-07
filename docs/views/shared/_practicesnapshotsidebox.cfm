<cfoutput>
	<cfif (currentLocationDetails.officeHours neq "")
	   or spokenLanguages.recordcount
	   or certifications.recordcount gt 0
	   or val(doctor.yearStartedPracticing) neq 0
	   or val(doctor.yearsInPractice) gt 0>
		<!-- sidebox -->
		<div class="sidebox PracticeSnapshot">
			<div class="frame">
				<h4>Practice <strong>Snapshot</strong></h4>
				<div class="practice-box">
					<cfif isAdvisoryBoard>
						<h5>LocateADoc.com Advisory Board</h5>
						<img src="/images/layout/badges/advisory_2013_small.jpg">
					</cfif>
					<cfif currentLocationDetails.officeHours neq "">
						<h5>Office Hours</h5>
						<cfset filteredOfficeHours = Replace(currentLocationDetails.officeHours,"&nbsp;"," ","all")>
						<cfset filteredOfficeHours = REReplace(filteredOfficeHours,"<p>\s*</p>","","all")>
						<cfset filteredOfficeHours = REReplace(filteredOfficeHours,"<p>\s*<br\s*/?>\s*</p>","","all")>
						<p>#filteredOfficeHours#</p>
					</cfif>
					<cfif spokenLanguages.recordcount>
						<h5>Languages</h5>
						<ul>
							<cfloop query="spokenLanguages">
								<li>#spokenLanguages.name#</li>
							</cfloop>
						</ul>
					</cfif>
					<cfif certifications.recordcount gt 0>
						<h5>Certifications & Memberships</h5>
						<cfloop query="certifications">
							<table class="certification">
							  <tr>
								<cfif logoFileName neq ""><td><img src="#logoFileName#" /></td></cfif>
								<td>#name#</td>
							  </tr>
							</table>
						</cfloop>
					</cfif>
					<cfif val(doctor.yearStartedPracticing) neq 0>
						<h5>Year Started Practicing</h5>
						<p>#doctor.yearStartedPracticing#</p>
					<cfelseif val(doctor.yearsInPractice) gt 0>
						<h5>Years in Practice</h5>
						<p>#doctor.yearsInPractice# years</p>
					</cfif>
				</div>
			</div>
		</div>
	</cfif>
</cfoutput>