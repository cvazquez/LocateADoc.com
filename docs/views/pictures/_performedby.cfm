<cfif doctors.recordcount>
<div id="performedBy" class="frame">
	<h4>Performed <strong>By</strong></h4>
	<cfoutput query="doctors" group="id">
		<!--- format phone number --->
		<cfset formattedPhone = formatPhone(doctors.phone)>
		<cfset tooltip = "#fullNameWithTitle# | #accountPracticeName#">
		<cfif specialties.recordcount>
			<cfset tooltip &= " | <i>Specialty: #specialties.name#</i>">
		</cfif>
			<cfset tooltip &= " | #name#, #stateName# #postalCode#">
		<cfif formattedPhone neq "">
			<cfset tooltip &= " | <b>#formattedPhone#</b>">
		</cfif>
		<h5 class="fullName tooltip" title="#tooltip#"><a href="/#doctors.doctorSiloName#">#fullNameWithTitle#</a></h5>
		<div class="box">
				<div class="visual tooltip" title="#tooltip#">
				<div class="t">
					<div class="b">
						<a href="/#doctors.doctorSiloName#/pictures"><img src="#doctorImageThumbBase#/#photoFilename#" alt="image description" width="63" height="72" /></a>
					</div>
				</div>
			</div>
			<div class="descr">
				<div class="desc-text tooltip" title="#tooltip#">
					<div class="name" style="height:12px; overflow:hidden;">#accountPracticeName#</div>
					<cfif specialties.recordcount><div class="specialty" style="height:12px; overflow:hidden;"><i>#specialties.name#</i></div></cfif>
					<div>#name#, #stateName# #postalCode#</div>
					<div style="height:12px;">
						<cfif formattedPhone neq "">
							<strong class="phone">#formattedPhone#</strong>
						</cfif>
					</div>
				</div>
				<strong class="more"><a href="/#doctors.doctorSiloName#/pictures">VIEW MORE PHOTOS</a></strong>
			</div>
		</div>
	</cfoutput>
</div>
<script type="text/javascript">
	$(function(){
		SmartTruncate('.fullName',17,268,true);
		SmartTruncate('.name',12,176,true);
		SmartTruncate('.specialty',12,176,true);
		<!--- $(".tooltip").tooltip({
			delay: 0,
			track: true,
			showBody: " | "
		}); --->
	});
</script>
</cfif>
<!--- <cfsavecontent variable="tooltipJSandCSS">
	<cfoutput>
		<link rel="stylesheet" type="text/css" href="/stylesheets/jquery.tooltip.css" />
		<script type="text/javascript" src="/javascripts/jquery.tooltip.min.js"></script>
	</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#tooltipJSandCSS#"> --->