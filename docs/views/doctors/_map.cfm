<CFSET index=1>

<cftry>
	<cfoutput>
		<style type="text/css"> v\:* {behavior:url(##default##VML);}</style>
		<!--- <script src="http://maps.google.com/maps?file=api&v=1&key=#Variables.GoogleAPIKey#" type="text/javascript"></script> --->
		<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
		<script type="text/javascript">
			var map;
			var listings = new Array();
			listings[0]=new Array();
			listings[0]["lat"]="";
			listings[0]["lon"]="";

			<cfloop query="search.results">
				<!--- <CFIF latitude IS NOT "" AND longitude IS NOT ""> --->
					<!--- format full name --->
					<cfset fullName = "#search.results.firstname# #Iif(search.results.middlename neq '',DE(search.results.middlename&' '),DE('')) & search.results.lastname#">
					<cfif LCase(search.results.title) eq "dr" or LCase(search.results.title) eq "dr.">
						<cfset fullName = "Dr. #fullName#">
					<cfelseif search.results.title neq "">
						<cfset fullName &= ", #search.results.title#">
					</cfif>
					listings[#index#]=new Array();
					listings[#index#]["lat"]="#search.results.latitude#";
					listings[#index#]["lon"]="#search.results.longitude#";
					listings[#index#]["title"]="#fullName#";
					listings[#index#]["name"]="#ReplaceNoCase(fullName,' ','&nbsp;','All')#";
					listings[#index#]["address"]="#REReplace(ReplaceNoCase(Address,'##','Ste. '),'(\&\w+;([bB][rR])?)|(</?[bB][rR]>?)',' ','all')#";
					listings[#index#]["city"]="#City#";
					listings[#index#]["state"]="#abbreviation#";
					listings[#index#]["zip"]="#postalCode#";
					<cfif ListContains(ValueList(search.featured.id),search.results.id)>
						listings[#index#]["type"]="featured";
					<cfelse>
						listings[#index#]["type"]="normal";
					</cfif>
					listings[#index#]["photo"]="#PhotoFilename#";
					listings[#index#]["link"]="/#search.results.siloName#";
					listings[#index#]["pincontainer"]="pin_#id#";
					listings[#index#]["pinicon"]="";
					<cfset index++>
				<!--- </CFIF> --->
			</cfloop>
			<cfif isDefined("params.plottest") and isDefined("search.plot.hull") and ListLen(search.plot.hull) gt 0>
				var cityPlotPolygon = [
				    <cfloop list="#search.plot.hull#" index="i">
						new google.maps.LatLng(#search.plot.coordinates[i].y#, #search.plot.coordinates[i].x#)<cfif i neq ListLast(search.plot.hull)>,</cfif>
					</cfloop>
				];
			<cfelse>
				var cityPlotPolygon = null;
			</cfif>
			<cfif isDefined("params.plottest") and isDefined("search.plot.lines") and ArrayLen(search.plot.lines) gt 0>
				var cityPlotLines = [
					<cfloop from="1" to="#ArrayLen(search.plot.lines)#" index="i">
						new google.maps.LatLng(#search.plot.lines[i].y#, #search.plot.lines[i].x#)<cfif i lt ArrayLen(search.plot.lines)>,</cfif>
					</cfloop>
					<!--- <cfloop from="1" to="#ArrayLen(search.plot.lines)#" index="i">
						[new google.maps.LatLng(#search.plot.lines[i].pointA.y#, #search.plot.lines[i].pointA.x#),
						new google.maps.LatLng(#search.plot.lines[i].pointB.y#, #search.plot.lines[i].pointB.x#)]
						<cfif i neq ArrayLen(search.plot.lines)>,</cfif>
					</cfloop> --->
				];
			<cfelse>
				var cityPlotLines = null;
			</cfif>
			<cfif isDefined("search.plot.lines") and ArrayLen(search.plot.lines) gt 0>
				var mapBounds = new google.maps.LatLngBounds(new google.maps.LatLng(#search.plot.zoneBottom#,#search.plot.zoneLeft#),new google.maps.LatLng(#search.plot.zoneTop#,#search.plot.zoneRight#));
			<cfelse>
				var mapBounds = null;
			</cfif>

			function loadMap() {getMap(#val(search.map.longitude)#, #val(search.map.latitude)#, #search.zoom#, "featured");}

		</script>

		#javaScriptIncludeTag(source="maps")#
		<script language="JavaScript" type="text/javascript">writeMap();</script>
	</cfoutput>
	<cfcatch>
		<cfset dumpStruct = {search_results=search.results}>
		<cfset fnCthulhuException(	scriptName="_map.cfm",
									message="Map Faux Error",
									detail="This is an error that's not an error. Lose 1 sanity, then hit refresh.",
									dumpStruct=dumpStruct,
									errorCode=408
									)>
	</cfcatch>
</cftry>