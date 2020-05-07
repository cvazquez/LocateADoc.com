<cfoutput>

<!--- 	<cfset tabCount = 0>
		<div class="bootstrap-copy">
		  <ul class="nav nav-pills">
			<cfloop array="#tabs#" index="tab">
				<cfset action = trim(ListGetAt(tab,3,"|"))>
				<cfset tabCount++>

				<cfif action eq "contact">
					<cfset tracking = " clicktrackkeyvalues=""accountDoctorId:#params.key#;accountDoctorLocationId:#locationId#"" clicktracklabel=""ContactUsTab"" clicktracksection=""ProfileContact""">
					<cfset linkURL = Server.ThisServer neq "dev" ? "https://#CGI.SERVER_NAME#" : "">
				<cfelse>
					<cfset tracking = "">
					<cfset linkURL = "">
				</cfif>

				<cfif params.action EQ variables.action OR (params.action EQ "welcome" AND variables.action EQ "")>
					<cfset showLink = FALSE>
				<cfelse>
					<cfset showLink = TRUE>
				</cfif>


				<li <cfif NOT showLink> class="active"</cfif>>
					<a href="#linkURL#/#doctor.siloName#/#action#<cfif action EQ "contact">##ContactForm</cfif>" data-ajax="false" rel="external" #tracking#>#ListGetAt(tab,4,"|")#</a>
				</li>
			</cfloop>
		  </ul>
	 </div> --->


		<div class="bootstrap-copy bootstrap-col-mds">
		  <cfset tabCount = 0>
		  <div class="row">
	  		<cfloop array="#tabs#" index="tab">
				<cfset action = trim(ListGetAt(tab,3,"|"))>
				<cfset tabCount++>

				<cfif action eq "contact">
					<cfset tracking = " clicktrackkeyvalues=""accountDoctorId:#params.key#;accountDoctorLocationId:#locationId#"" clicktracklabel=""ContactUsTab"" clicktracksection=""ProfileContact""">
					<cfset linkURL = Server.ThisServer neq "dev" ? "https://#CGI.SERVER_NAME#" : "">
				<cfelse>
					<cfset tracking = "">
					<cfset linkURL = "">
				</cfif>

				<cfif params.action EQ variables.action OR (params.action EQ "welcome" AND variables.action EQ "")>
					<cfset showLink = FALSE>
				<cfelse>
					<cfset showLink = TRUE>
				</cfif>

			  <div class="col-xs-1 col-md-1 <cfif NOT showLink>active</cfif>">
				  <cfif showLink><a href="#linkURL#/#doctor.siloName#/#action#<cfif action EQ "contact">##ContactForm</cfif>" data-ajax="false" rel="external" #tracking#></cfif>#ListGetAt(tab,4,"|")#<cfif showLink></a></cfif>
				</div>
			</cfloop>
			</div>
		</div>


		  <!--- <div class="row">
		    <div class="col-md-3">
		      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
		    </div>
		    <div class="col-md-3">
		      <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
		    </div>
		    <div class="col-md-3">
		      <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam.</p>
		    </div>
		    <div class="col-md-3">
		      <p>Eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.</p>
		    </div>
		  </div> --->
	<!--- <div class="tabnav">
		<cfset tabCount = 0>
		<cfloop array="#tabs#" index="tab">
			<cfset action = trim(ListGetAt(tab,3,"|"))>
			<cfset tabCount++>

			<cfif action eq "contact">
				<cfset tracking = " clicktrackkeyvalues=""accountDoctorId:#params.key#;accountDoctorLocationId:#locationId#"" clicktracklabel=""ContactUsTab"" clicktracksection=""ProfileContact""">
				<cfset linkURL = Server.ThisServer neq "dev" ? "https://#CGI.SERVER_NAME#" : "">
			<cfelse>
				<cfset tracking = "">
				<cfset linkURL = "">
			</cfif>

			<cfif params.action EQ variables.action OR (params.action EQ "welcome" AND variables.action EQ "")>
				<cfset showLink = FALSE>
			<cfelse>
				<cfset showLink = TRUE>
			</cfif>

				<div class="Align2Tabs">
				<div class="#ListGetAt(tab,1,"|")# tabset"<cfif NOT showLink> style="color:silver;"</cfif>>
					<cfif showLink><a href="#linkURL#/#doctor.siloName#/#action#<cfif action EQ "contact">##ContactForm</cfif>" data-ajax="false" rel="external" class="#ListGetAt(tab,4,"|")#"#tracking#></cfif>#ListGetAt(tab,2,"|")#<cfif showLink></a></cfif>
				</div>
				</div>

		</cfloop>
	</div> --->
</cfoutput>