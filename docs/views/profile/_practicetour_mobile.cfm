<cfoutput>
	<cfif tour.tourStops.recordcount gt 0>
		<!-- sidebox -->
		<div class="sidebox">
			<div class="frame">
				<h4>Office <strong>Tour</strong></h4>
				<p>#accountName.name# Office Tour</p>
				<ul class="image-list" style="margin:0 0 0 40px;">
					<li id="tour_link">
						<div class="image">
							<a href="##" class="tour_link" onclick="tourOpen(); return false;">
								<img src="/images/layout/img1-image-list.jpg" width="175" height="90" alt="Take the Office Tour">
								<strong class="caption">Take the Office Tour</strong>
							</a>
						</div>
					</li>
				</ul>
				<!--- <a href="##" onclick="tourOpen(); return false;"><img src="/images/layout/img1-image-list.jpg" border="0"></a> --->
			</div>
		</div>
	</cfif>
</cfoutput>

<div class="tour-modal hidefirst">
	<center>
		<table class="modal-box">
			<tr class="row-buttons">
				<td colspan="2"><div class="closebutton" onclick="tourClose(); return false;"></div></td>
			</tr>
			<tr class="row-t">
				<td class="l-t"></td>
				<td class="t"></td>
			</tr>
			<tr class="row-c">
				<td class="l"></td>
				<td class="c">
					<cfoutput query="tour.tourStops">
					<table class="tour-stop" id="tour_#currentrow#"><tr>
						<td class="tour-picture">
							<img src="#tour.imgPath & tour.tourStops.locationImage2#" />
						</td>
						<td class="tour-body">
							<cfif practice.logoFileName neq "">
								<img src="#practiceImageBase#/#practice.logoFileName#" height="62" alt="#practice.name#" />
							</cfif>
							<h2>Office Tour</h2>
							<h4>#tour.tourStops.title#</h4>
							<p>#tour.tourStops.description#</p>
						</td>
					</tr></table>
					</cfoutput>
				</td>
			</tr>
			<tr class="row-b">
				<td class="l-b"></td>
				<td class="b"></td>
			</tr>
			<tr class="row-buttons">
				<td colspan="2">
					<div class="backbutton"></div>
					<div class="nextbutton"></div>
				</td>
			</tr>
		</table>
	</center>
</div>