<cfparam name="zoom" default="11">
<cfoutput>
	#javaScriptIncludeTag(source="https://maps.google.com/maps/api/js?sensor=false", head=true)#
	#javaScriptIncludeTag(source="maps", head=true)#
</cfoutput>

<cfsavecontent variable="myCSS">
	<cfoutput>
		<style type="text/css"> v\:* {behavior:url(##default##VML);}</style>
	</cfoutput>
</cfsavecontent>
<cfset contentFor(customCSS=myCSS)>

<cfsavecontent variable="myJS">
	<cfoutput>
		<script type="text/javascript">
			var mapInit = false;
			var map;
			var listings = new Array();
			var aList = new Array();
			listings[0]=new Array();
			listings[0]["lat"]="";
			listings[0]["lon"]="";

			<cfloop query="doctorLocations">
				<!--- <cfif latitude neq "" and longitude neq ""> --->
					listings[#doctorLocations.currentRow#]=new Array();
					listings[#doctorLocations.currentRow#]["lat"]="#doctorLocations.latitude#";
					listings[#doctorLocations.currentRow#]["lon"]="#doctorLocations.longitude#";
					listings[#doctorLocations.currentRow#]["name"]="Location #doctorLocations.currentRow#";
					listings[#doctorLocations.currentRow#]["title"]="Location #doctorLocations.currentRow#";
					listings[#doctorLocations.currentRow#]["address"]="#REReplace(ReplaceNoCase(doctorLocations.address,'##','Ste. '),'(\&\w+;([bB][rR])?)|(</?[bB][rR]>?)',' ','all')#";
					listings[#doctorLocations.currentRow#]["city"]="#doctorLocations.name#";
					listings[#doctorLocations.currentRow#]["state"]="#doctorLocations.abbreviation#";
					listings[#doctorLocations.currentRow#]["zip"]="#doctorLocations.postalCode#";
					listings[#doctorLocations.currentRow#]["img"]="#doctorLocations.currentRow#";
					listings[#doctorLocations.currentRow#]["photo"]="#doctor.PhotoFilename#";
					listings[#doctorLocations.currentRow#]["link"]="##";
					listings[#doctorLocations.currentRow#]["type"]="#(doctorLocations.id eq currentLocation.id ? 'current' : 'normal')#";
					listings[#doctorLocations.currentRow#]["pincontainer"]="pin_#doctorLocations.id#";
					listings[#doctorLocations.currentRow#]["pinicon"]="";
				<!--- </cfif> --->
			</cfloop>

			<cfif mapCenter.longitude eq "">
				<cfif Server.isInteger(currentLocation.postalCode)>
					<cfset currentZipLocation = model("PostalCode").findAllByPostalCode(currentLocation.postalCode)>
					<cfif currentZipLocation.recordCount>
						<cfset mapCenter.longitude = currentZipLocation.longitude>
						<cfset mapCenter.latitude = currentZipLocation.latitude>
						<cfset mapCenter.zoom = 11>
					</cfif>
				</cfif>
			</cfif>

			<cfif mapCenter.longitude eq "">
				<!--- Set map to US --->
				<cfset mapCenter.longitude = -95.668945>
				<cfset mapCenter.latitude = 37.055177>
				<cfset mapCenter.zoom = 4>
			</cfif>

			var cityPlotPolygon = null;
			var cityPlotLines = null;
			var mapBounds = null;

			function loadMap() {
						if(!mapInit)
						{
							mapInit = true;
							getMap(#mapCenter.longitude#, #mapCenter.latitude#, #mapCenter.zoom#, "location");
						}
				}

		</script>
	</cfoutput>
</cfsavecontent>
<cfset contentFor(customJS=myJS)>

<cfsavecontent variable="mapModal">
	<cfoutput>
		<div class="hidden" id="mapModal">
			<div id="map" style="width: 690px; height: 400px; border:solid; border-color:9391D9;"></div>
			<div id="message" style="padding-top:0px; padding-bottom:0px;">
				How to Use the Map
				<ul style="margin-top:2px; margin-bottom:0px; padding-top:0px; padding-bottom:0px;">
					<li>Moving Around: to move the map, use the arrow buttons, or click on the map and drag it.</li>
					<li>Zooming: to zoom in our out, click the plus or minus signs, or turn the mouse wheel.</li>
					<li>Pins: to read a doctor's information, click on a pin.</li>
				</ul>
			</div>
		</div>
	</cfoutput>
</cfsavecontent>
<cfset contentFor(modalWindows=mapModal)>