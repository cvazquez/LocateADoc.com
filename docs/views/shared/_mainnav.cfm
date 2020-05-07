<cfoutput>
	<ul id="nav">
		<!--- <li<cfif params.controller eq "home"> class="active"</cfif>><a href="/"><span>Home</span><em></em></a></li> --->
		<li<cfif ListFindNoCase("doctors,profile",params.controller)> class="active"</cfif>><a href="/doctors"><span>Find A Doctor</span><em></em></a></li>
		<li<cfif params.controller eq "askADoctor"> class="active"</cfif>><a href="/ask-a-doctor"><span>Ask A Doctor</span><em></em></a></li>
		<li<cfif params.controller eq "pictures"> class="active"</cfif>><a href="/pictures" id="MainGalleryNav"><span>Before and After Gallery</span><em></em></a></li>
		<li<cfif params.controller eq "resources"> class="active"</cfif>><a href="/resources"><span>Resources</span><em></em></a></li>
		<li<cfif params.controller eq "financing"> class="active"</cfif>><a href="/financing"><span>Financing</span><em></em></a></li>
		<li<cfif params.controller eq "doctorMarketing"> class="active"</cfif>><a href="/doctor-marketing/add-listing"><span>Doctors Only</span><em></em></a></li>
	</ul>
</cfoutput>