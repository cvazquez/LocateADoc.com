<cfoutput>
	<div class="t">&nbsp;</div>
	<div class="c">
		<div class="c-add">
			<div class="title">
				<h3>Filter Search Results</h3>
				<p>#linkTo(controller="doctors",text="start new search")#</p>
				<!--- <p>#linkTo(text="reset filters",href="javascript:ResetFilters();",id="removeallfilters")#</p> --->
			</div>
			<ul class="list">
				<cfloop list="#search.filters.index#" index="Local.filter">
					<cfif Local.filter eq "location">
					<li class="slide-block<cfif trim(params.location) neq ""> active</cfif>">
						<a class="open-close" href="">Location</a>
						<div class="slide">
							<span class="location-title">City, <cfif params.country eq 'CA'>province, or postal code<cfelse>state, or zip code</cfif>.</span>
							<form name="locationform" action="##" class="location-form" onsubmit="ChangeLocationAndOrDistance(); return false;">
								<input type="hidden" id="country" value="<cfif params.country eq ''>US<cfelse>#params.country#</cfif>">
								<fieldset>
									<span class="text-regular">
									#textFieldTag(
										name="location",
										id="city",
										value=Replace(params.location,"_"," ","all"),
										class="txt noPreText"
									)#
									</span>
								</fieldset>
								<div id="square-autocomplete"></div>
								<a href="##" onclick="ChangeLocationAndOrDistance(); return false;" class="location-submit">Go</a>
								<cfif params.location neq "" and not (params.name eq "" and params.procedure eq "" and params.specialty eq "" and params.bodypart eq "")>
									<a href="##" onclick="javascript:RemoveFilter('location'); return false;" class="location-submit">Clear</a>
								</cfif>
							</form>
							<cfif ListLen(search.citySuggestion) gt 0>
								<ul><li>
								<hr>
								Show all results for<br>
								<cfloop list="#search.citySuggestion#" index="suggestedCity" delimiters="|">
									<a href="##" onclick='javascript:AddFilter("location-#URLEncodedFormat(Replace(suggestedCity," ","_","all"))#"); return false;'>#suggestedCity#</a><br>
								</cfloop>
								</li></ul>
							</cfif>
							<cfif isDefined("Client.locationError") and Client.locationError neq "">
								<p class="locationError">#Client.locationError#</p>
								<cfset Client.locationError = "">
							</cfif>
						</div>
					</li>
					<cfelseif Local.filter eq "distance">
					<li class="slide-block<cfif val(params.distance)> active</cfif>">
						<a class="open-close" href="">Distance</a>
						<div class="slide">
							<form name="distanceform" action="##" class="location-form" onsubmit="ChangeLocationAndOrDistance(); return false;">
								<fieldset>
									<span class="text">
									#textFieldTag(
										name="distance",
										value=params.distance,
										class="txt noPreText"
									)#
									</span>
									<em>miles</em>
								</fieldset>
								<a href="##" onclick="ChangeLocationAndOrDistance(); return false;" class="location-submit">Go</a>
								<cfif params.distance neq "">
									<a href="##" onclick="javascript:RemoveFilter('distance'); return false;" class="location-submit">Clear</a>
								</cfif>
							</form>
						</div>
					</li>
					<cfelseif isdefined("search.filters.#Local.filter#") AND ArrayLen(evaluate('search.filters.'&Local.filter)) gt 0>
					<li class="slide-block<cfif (evaluate('params.'&Local.filter) neq 0) and (evaluate('params.'&Local.filter) neq "")> active</cfif>">
						<a class="open-close" href="">
							<cfif Local.filter eq "bodypart">
								BODY PART
							<cfelse>
								#UCase(humanize(Local.filter))#<cfif Local.filter eq "procedure">/TREATMENT</cfif>
							</cfif>
						</a>
						<div class="slide" style="display:none;">
							<ul id="#Local.filter#filters" style="margin:0px; padding:0px;">

								<cfif (evaluate('params.'&Local.filter) neq 0) and (evaluate('params.'&Local.filter) neq "")>
									<cfset id = listGetAt(evaluate('search.filters.'&Local.filter)[1],1,"|")>

									<cfif listLen(evaluate('search.filters.'&Local.filter)[1], "|") GTE 2>
										<cfset name = listGetAt(evaluate('search.filters.'&Local.filter)[1],2,"|")>
									<cfelse>
										<cfset name = "">
									</cfif>

									<cfif listLen(evaluate('search.filters.'&Local.filter)[1], "|") GTE 3>
										<cfset count = listGetAt(evaluate('search.filters.'&Local.filter)[1],3,"|")>
									<cfelse>
										<cfset count = 0>
									</cfif>

									<cfif val(count) AND name NEQ "">
										<li>
											#name#<br>
											<a filter="#Local.filter#" value="0" href="javascript:RemoveFilter('#Local.filter#');">remove</a>
										</li>
									</cfif>
								<cfelse>
									<cfset itemCount = arrayLen(evaluate('search.filters.'&Local.filter))>
									<cfif itemCount gt 10>
										<div class="filter-modal hidefirst" id="#Local.filter#-box">
											<center>
												<table class="modal-box filter-box">
													<tr class="row-buttons">
														<td colspan="2"><div class="closebutton"></div></td>
													</tr>
													<tr class="row-t">
														<td class="l-t"></td>
														<td class="t"></td>
													</tr>
													<tr class="row-c">
														<td class="l"></td>
														<td class="c">
														<div class="filter-scroll">
															<table class="allDocs">
																<tr>
																	<td>
																		<ul>
																			<cfset row = 1>
																			<cfloop from=1 to="#itemCount#" index="Local.currentItem">
																				<cfset id = listGetAt(evaluate('search.filters.'&Local.filter)[Local.currentItem],1,"|")>
																				<cfset name = listGetAt(evaluate('search.filters.'&Local.filter)[Local.currentItem],2,"|")>
																				<cfset count = listGetAt(evaluate('search.filters.'&Local.filter)[Local.currentItem],3,"|")>
																				<cfif val(count)>
																					<li>
																						<a filter="#Local.filter#" value="#id#" href="" onclick="javascript:AddFilter('#Local.filter#-#lcase(id)#');return false;">#name#</a> (#count#)
																					</li>
																					<cfif row++ eq ceiling(itemCount/3) and Local.currentItem neq itemCount>
																						</ul></td><td><ul>
																						<cfset row = 1>
																					</cfif>
																				</cfif>
																			</cfloop>
																		</ul>
																	</td>
																</tr>
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
									</cfif>
									<cfif Local.filter eq "procedure">
										<span class="location-title">Procedure Name is like:</span>
										<span class="text med">
											<input id="procedurename" type="text" name="procedurename" value="" class="txt">
										</span>
										<hr>
									</cfif>

									<cfloop from=1 to="#itemCount#" index="Local.currentItem">
									<!--- <cfloop from=1 to="#Min(10,arrayLen(evaluate('search.filters.'&Local.filter)))#" index="Local.currentItem"> --->
										<cfset id = listGetAt(evaluate('search.filters.'&Local.filter)[Local.currentItem],1,"|")>

										<cfif listLen(evaluate('search.filters.'&Local.filter)[Local.currentItem], "|") GTE 2>
											<cfset name = listGetAt(evaluate('search.filters.'&Local.filter)[Local.currentItem],2,"|")>
										<cfelse>
											<cfset name = "">
										</cfif>

										<cfif listLen(evaluate('search.filters.'&Local.filter)[Local.currentItem], "|") GTE 3>
											<cfset count = listGetAt(evaluate('search.filters.'&Local.filter)[Local.currentItem],3,"|")>
										<cfelse>
											<cfset count = 0>
										</cfif>

										<cfif name NEQ "">
										<li>
											<a filter="#Local.filter#" value="#id#" href="" onclick="javascript:AddFilter('#Local.filter#-#lcase(id)#');return false;">#name#</a> (#count#)
										</li>
										</cfif>

										<cfif Local.currentItem eq 5 and itemCount gt 10>
											<li>...</li>
											<li>
												<a class="filter-more-link" href="###Local.filter#">View all #itemCount# #pluralize(Local.filter)#</a>
											</li>
											<cfbreak>
										</cfif>
									</cfloop>
								</cfif>
<!--- 								</ul>
								</div>
								</li> --->
							</ul>
						</div>
					</li>
					</cfif>
				</cfloop>
			</ul>
		</div>
	</div>
	<div class="b">&nbsp;</div>
</cfoutput>