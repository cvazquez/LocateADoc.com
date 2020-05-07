<cfoutput>
	<div class="tabnav">
		<ul class="tabset">
			<cfloop array="#tabs#" index="tab">
				<cfset action = trim(ListGetAt(tab,3,"|"))>
				<cfif action eq "contact">
					<cfset tracking = " clicktrackkeyvalues=""accountDoctorId:#params.key#;accountDoctorLocationId:#locationId#"" clicktracklabel=""ContactUsTab"" clicktracksection=""ProfileContact""">
					<cfset linkURL = Server.ThisServer neq "dev" ? "https://#CGI.SERVER_NAME#" : "">
				<cfelse>
					<cfset tracking = "">
					<cfset linkURL = "">
				</cfif>
				<li class="#ListGetAt(tab,1,"|")#"><a href="#linkURL#/#doctor.siloName#/#action#" class="#ListGetAt(tab,5,"|")#"#tracking#>#ListGetAt(tab,2,"|")#</a></li>
			</cfloop>
		</ul>
	</div>
</cfoutput>