<!--- <cfset javascriptIncludeTag(source="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js",head=true)> --->
<cfoutput>
	<!-- main -->
	<div id="main">
		#includePartial("/shared/breadcrumbs")#
		#includePartial(partial	= "/shared/ad", size="generic728x90top")#
		<!-- container inner-container -->
		<div class="container inner-container">
			<div class="inner-holder">
				#includePartial("/shared/pagetools")#
				<!-- content-frame -->
				<div class="content-frame">
					<div id="content">
						<!-- resources-box -->
						<div class="resources-box">
							<div class="title">
								<cfif params.action eq "compare">
								<h1 class="page-title">Compare Procedures</h1>
								<cfelse>
								<h1 class="page-title"><cfif specialtyID gt 0>#specialtyInfo.name# </cfif>Procedures</h1>
								</cfif>
							</div>
							<cfif params.action eq "compare" or specialtyID eq 0>
							#linkTo(text="BACK TO SURGERY GUIDES", action="surgery", class="back-link")#
							<cfelse>
							#linkTo(text="BACK TO #UCase(specialtyInfo.name)# GUIDES", controller=specialtyInfo.siloName, class="back-link")#
							</cfif>
							<div style="float:right;">
								<!-- #linkTo(text="COMPARE PROCEDURES", action="compare", class="compare-link")# -->
								#includePartial("ups3d")#
								<!--- <a class="calculator-link" href="##">BMI CALCULATOR</a> --->
							</div>
						</div>
						<!-- holder -->
						<div class="holder compare-procedures print-area">
							<h5>Select Your Procedure</h5>
							<cfif params.action eq "compare">
							<p>Choose a body region and/or body part to compare multiple procedures.</p>
							<cfelse>
							<p>Choose a body region and/or body part to narrow the list of procedures.</p>
							</cfif>
							<form name="bodyform" method="post">
								<div class="styled-select" style="width: 195px; float:left; margin-right:10px;">
									<select id="bodyregion" name="bodyRegion" class="hidefirst" style="width:215px;">
										<option value="">Select Body Region</option>
										<cfloop query="bodyRegions">
											<option value="#id#">#name#</option>
										</cfloop>
									</select>
								</div>
								<div class="styled-select" style="width: 195px;" id="drop-body-part-selection">
									<select class="body-part-selection hidefirst" name="bodyPart" style="width:215px;">
										<option bodyRegion="0" value="">Select Body Part</option>
										<cfloop query="bodyParts">
											<option bodyRegion="#bodyRegionID#" value="#id#">#name#</option>
										</cfloop>
									</select>
								</div>
								<select id="body-part-selection-full" style="display:none;">
									<option bodyRegion="0" value="">Select Body Part</option>
									<cfloop query="bodyParts">
										<option bodyRegion="#bodyRegionID#" value="#id#">#name#</option>
									</cfloop>
								</select>
								<cfif params.action neq "compare">
									<input type="hidden" id="listonly" value="#specialtyID#">
								</cfif>
								<cfif specialtyID neq 0>
									<input type="hidden" id="specialty" value="#specialtyID#">
								</cfif>
								<div class="btn" style="margin-top:10px;">
									<input type="button" id="compare-procedure-search" class="btn-search" value="SEARCH">
								</div>
							</form>

							<div class="compare-list-holder">
								#comparison#
							</div>
						</div>
					</div>
					<!-- sidebar -->
					<div id="sidebar">
						<div class="search-box resources-menu">
							<div class="t">&nbsp;</div>
							<div class="c">
								<div class="c-add">
									<div class="title">
										<h3>Resource Guides</h3>
									</div>
									#LinkTo(text="Surgery Guide Home",action="surgery")#
											<a class="guide-title" href="##">POPULAR PROCEDURES</a>
											<div class="guide-list">
												<ul>
													<cfloop query="popularProcedures">
													<li>#LinkTo(controller=popularProcedures.siloName,text=popularProcedures.name)#</li>
													</cfloop>
												</ul>
											</div>
								</div>
							</div>
							<div class="b">&nbsp;</div>
						</div>
						#includePartial("/shared/sponsoredlink")#
						<!-- side-ad -->
						#includePartial(partial="/shared/ad", size="generic160x600")#
					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>

<div class="compare-modal hidefirst">
	<center>
		<table class="modal-box">
			<tr class="row-buttons">
				<td colspan="2"><div class="closebutton" onclick="compareClose(); return false;"></div></td>
			</tr>
			<tr class="row-t">
				<td class="l-t"></td>
				<td class="t"></td>
			</tr>
			<tr class="row-c">
				<td class="l"></td>
				<td class="c">
					<h2>Compare Procedures</h2>
					<div class="comparison-short-scroll">
						<table class="comparisons">
							<tr id="compare_name"></tr>
							<tr id="compare_cost"></tr>
							<tr id="compare_candidate"></tr>
							<tr id="compare_length"></tr>
							<tr id="compare_treatment"></tr>
							<tr id="compare_results"></tr>
							<tr id="compare_backtowork"></tr>
							<tr id="compare_button"></tr>
						</table>
					</div>
				</td>
			</tr>
			<tr class="row-b">
				<td class="l-b"></td>
				<td class="b"></td>
			</tr>
		</table>
	</center>
</div>