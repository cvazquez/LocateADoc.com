<cfparam name="params.specialty" default="0">
<cfparam name="params.procedure" default="">
<cfif params.specialty eq "">
	<cfset params.specialty = 0>
</cfif>
<cfif params.procedure eq "">
	<cfset params.procedure = 0>
</cfif>

<!--- <cfsavecontent variable="additionalJS"> --->
	<cfoutput>
		<script type="text/javascript">
			$(function() {
				startSlider();
			});

			function startSlider()
			{
				$('##slider').anythingSlider({

				    buildStartStop      : false,
				    buildNavigation		: false,
				    onSlideBegin		: function(slider) {
				    			    		var cDoc = $(".activePage").attr("doctor");
				    			    		if(!cDoc) cDoc=1;
				    			    		//alert(cDoc);
				    			   			$("##checkContainer"+cDoc).fadeOut();
				    },
				    onSlideComplete     : function(slider) {
							                var cDoc = $(".activePage").attr("doctor");
						                	if(cDoc)
						                		$("##currentDoc").html(cDoc);
						                	else
						                		$("##currentDoc").html("1");
						                	$("##checkContainer"+cDoc).fadeIn();
									    },
				    // Callback when the plugin finished initializing
				    onInitialized: function(e, slider) {

				        var time = 1000, // allow movement if < 1000 ms (1 sec)
				            range = 50,  // swipe movement of 50 pixels triggers the slider
				            x = 0, y = 0, t = 0, touch = "ontouchend" in document,
				            st = (touch) ? 'touchstart' : 'mousedown',
				            mv = (touch) ? 'touchmove' : 'mousemove',
				            en = (touch) ? 'touchend' : 'mouseup';

				        slider.$window
				            .bind(st, function(e){
				                // prevent image drag (Firefox)
				                e.preventDefault();
				                t = (new Date()).getTime();
				                x = e.originalEvent.touches ? e.originalEvent.touches[0].pageX : e.pageX;
				                y = e.originalEvent.touches ? e.originalEvent.touches[0].pageY : e.pageY;
				            })
				            .bind(en, function(e){
				                t = 0; x = 0; y = 0;
				            })
				            .bind(mv, function(e){
				                e.preventDefault();
				                var newx = e.originalEvent.touches ? e.originalEvent.touches[0].pageX : e.pageX,
				                newy = e.originalEvent.touches ? e.originalEvent.touches[0].pageY : e.pageY,
				                r = (x === 0) ? 0 : Math.abs(newx - x),
				                dy = (y === 0) ? 0 : y - newy,
				                // allow if movement < 1 sec
				                ct = (new Date()).getTime();
				                if (Math.abs(dy) > r)
				                {
									window.scrollBy(0,dy);
									x = 0;
				                }
				                else if (t !== 0 && ct - t < time && r > range) {
				                    if (newx < x) { slider.goForward(); }
				                    if (newx > x) { slider.goBack(); }
				                    t = 0; x = 0; y = 0;
				                }
				            });
				    }
				}).show();
			}

			function submit()
			{
				if($("##contactChecks :input:checked").length == 0)
					{
					alert("Please select at least one doctor to contact.");
					return;
					}
				else
					$("##doctors-form").submit();
			}
		</script>
	</cfoutput>
<!--- </cfsavecontent> --->

<cfoutput>
	<div id="page3">
		<div id="message">
			<p class="centered">Please swipe left-right to scroll through your search results below and confirm who you would like to contact.</p>
		</div>
		<form id="doctors-form" action="/mobile/page3?t=#Client.mobile_entry_page#" method="post">
			<input		type="hidden"	name="page"						value="3">
			<input		type="hidden"	name="SWID"						value="#FolioMiniLeadSiteWideId#">
			<!--- <input		type="hidden"	name="listingIds"				value=""										id="listingIds"> --->
			<!--- <input		type="hidden"	name="newsletter"> --->
			<input		type="hidden"	name="isFolioMini"				value="0">
			<input		type="hidden"	name="position"					value="11">
			<input		type="hidden"	name="sourceId"					value="56">
			<!--- <input		type="hidden"	name="action"					value="search"									id="action"> --->
			<input		type="hidden"	name="specialty"				value="#params.specialty#"					id="specialtyid">
			<input		type="hidden"	name="procedure"				value="#params.procedure#"					id="procedureid">
			<input		type="hidden"	name="comments"					value=""										id="comments">
			<!--- <input		type="hidden"	name="specialty"				value="#params.specialty#"> --->
			<input		type="hidden"	name="name"						value="#params.name#">
			<input		type="hidden"	name="email"					value="#params.email#">
			<input		type="hidden"	name="zip"						value="#params.zip#">
			<input		type="hidden"	name="phone"					value="#params.phone#">
			<div id="doctor-selector">
				<div class="doctor-back">
					<div class="centered">
						<div style="width:290px; margin:0 auto;">
							<h1>Doctor <span id="currentDoc">1</span> of #listings.recordCount#</h1>
							<div <!--- style="float:right;"  --->id="contactChecks">
								<cfloop query="listings">
									<div id="checkContainer#listings.currentRow#"#(listings.currentRow neq 1)?' style="display:none;"':''#>
										<input name="doctors" type="checkbox" id="contact#listings.currentRow#" checked value="#listings.id#" data-role="none"> <label for="contact#listings.currentRow#">Contact This Doctor</label>
									</div>
								</cfloop>
							</div>
							<ul id="slider" style="display:none;">
								<cfloop query="listings">
									<li doctor="#listings.currentRow#">
										<div>
											<div>
												<div style="clear:both;"></div>
												<p>
													<cfif listings.photoFileName neq "">
														<img src="http://www.locateadoc.com/images/profile/doctors/thumb/#listings.photoFileName#" width="74" alt="#listings.firstName# #listings.lastName#" align="right">
													</cfif>
													<h2>#listings.firstName# #listings.lastName#</h2>
													<h3>#listings.practice#</h3>
													<address>
														#listings.address#<br />
														#listings.city#, #listings.abbreviation# #listings.postalCode#
													</address>
													<cfif listings.phone neq "">
														<span class="doctorphone">#CreateObject("component","com.util.formatting.Phone").FormatPhoneNumber(listings.phone)#</span><br />
													</cfif>
													<cfif listings.distance neq "">
														<span class="distance">#NumberFormat(listings.distance, "9.99")# miles away</span>
													</cfif>
												</p>
												<div style="clear:both;"></div>
											</div>
										</div>
									</li>
								</cfloop>
							</ul>
						</div>
					</div>
				</div>
			</div>
			<div id="comments">
				<div class="centered">
					<div class="padded">
						<p>What else would you like to ask?</p>
						<textarea id="comments_entered"></textarea>
						<!--- <input type="checkbox" name="newsletter" id="bl" checked> <label for="bl">Free monthly newsletter of up-to-date elective surgery stories with unique perspectives directly from doctors and patients.</label> --->
						<label for="newsletterSlider" style="display:inline-block; float:left; margin: 7px 25px 0 0;">
							<strong>Yes!</strong>
							I'd like to receive the FREE monthly "Beautiful Living" e-newsletter with up to date elective surgery info and unique perspectives from doctors and patients.
						</label>
				        <select name="newsletterSlider" id="newsletterSlider" data-role="slider" data-mini="true">
				            <option value="0">No</option>
				            <option value="1" selected>Yes</option>
				        </select>
						<a href="##" class="button" onclick="submit(); return false;">Contact Doctors</a>
					</div>
				</div>
			</div>
		</form>
	</div>
</cfoutput>