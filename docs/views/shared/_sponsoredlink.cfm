<!--- format full name --->
<cfif sponsoredLink.valid>
	<cfset fullName = "#sponsoredLink.doctor.firstname# #Iif(sponsoredLink.doctor.middlename neq '',DE(sponsoredLink.doctor.middlename&' '),DE('')) & sponsoredLink.doctor.lastname#">
	<cfif LCase(sponsoredLink.doctor.title) eq "dr" or LCase(sponsoredLink.doctor.title) eq "dr.">
		<cfset fullName = "Dr. #fullName#">
	<cfelseif sponsoredLink.doctor.title neq "">
		<cfset fullName &= ", #sponsoredLink.doctor.title#">
	</cfif>

	<cfset clickTrackSection = "SponsoredLink">
	<cfoutput>
		<cfsavecontent variable="paramKeyValues">
			<cfloop collection="#params#" item="pC">
				<cfif isnumeric(params[pC])>
					#pC#:#val(params[pC])#;
				</cfif>
			</cfloop>
		</cfsavecontent>
		<cfsavecontent variable="clickTrackKeyValues">
			accountDoctorLocationId:#sponsoredLink.doctor.accountDoctorLocationId#;
			zoneId:#sponsoredLink.doctor.zoneId#;
			zoneStateId:#sponsoredLink.doctor.zoneStateId#;
			zoneSpecialtyId:#sponsoredLink.doctor.zoneSpecialtyId#;
			zoneProcedureId:#sponsoredLink.doctor.zoneProcedureId#;
			#paramKeyValues#
		</cfsavecontent>

		<div class="sponsor-box">
			<div class="title">
				<h3><span>Top Doctor</span></h3>
			</div>
			<div class="sponsor">
				<div class="visual">
					<div class="t">
						<div class="b">
							<a	clickTrackSection	= "#clickTrackSection#"
								clickTrackLabel		= "Photo"
								clickTrackKeyValues	= "#clickTrackKeyValues#"
								href="/#sponsoredLink.doctor.siloName#"><img width="63" height="72" src="#Globals.doctorPhotoBaseURL & sponsoredLink.doctor.photoFilename#" alt="#fullname#" /></a>
						</div>
					</div>
				</div>
				<h3><a	clickTrackSection	= "#clickTrackSection#"
						clickTrackLabel		= "Fullname"
						clickTrackKeyValues	= "#clickTrackKeyValues#"
						href="/#sponsoredLink.doctor.siloName#">#fullName#</a></h3>
				<!--- <span>Medical Director</span> --->
				<strong>#sponsoredLink.doctor.practice#</strong>
				<em>#sponsoredLink.doctor.city#, #sponsoredLink.doctor.state#</em>
				<cfif sponsoredLink.doctor.phonePlus neq ""><b>#formatPhone(sponsoredLink.doctor.phonePlus)#</b></cfif>
			</div>
			<ul class="list">
				<cfloop query="sponsoredLink.procedures">
				<li><a	clickTrackSection	= "#clickTrackSection#"
						clickTrackLabel		= "Procedure"
						clickTrackKeyValues	= "#clickTrackKeyValues#"
						href="/#sponsoredLink.doctor.siloName#">#sponsoredLink.procedures.name#</a></li>
				</cfloop>
			</ul>
		</div>
	</cfoutput>
</cfif>