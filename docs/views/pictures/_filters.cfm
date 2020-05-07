<cfoutput>
	<div class="t">&nbsp;</div>
	<div class="c">
		<div class="c-add">
			<div class="title">
				<cfif params.intab>
					<h3>Filter Gallery Cases</h3>
				<cfelse>
					<h3>Filter Search Results</h3>
					<p>#linkTo(controller="pictures",text="start new search")#</p>
					<!--- <p>#linkTo(text="remove all filters",id="removeallfilters",action="search")#</p> --->
				</cfif>
			</div>
			<ul class="list">
				<cfif not params.intab>
					<li class="slide-block<cfif (isStruct(params.location) and (val(params.location.city) or val(params.location.state))) or (isSimpleValue(params.location) and params.location neq 0)> active</cfif>">
						<a class="open-close" href="">Location</a>
						<div class="slide">
							<cfif IsDefined("params.location.querystring") and val(len(params.location.querystring))>
								<ul id="locationfilters">
									<li>
										<cfif val(len(params.location.cityname)) and val(len(params.location.stateabbr))>
											<cfif params.location.zipfound>
												<cfif params.location.countryname is "United States">
													<cfset zip = "Zip code">
												<cfelse>
													<cfset zip = "Postal code">
												</cfif>
												#zip#: #params.location.zipcode#
												<br>
												<a filter="location" value="0" href="##">remove</a>
												<hr>
												Show all results for<br>
												<a href="##" filter="location" value="#params.location.cityname#, #params.location.stateabbr#" title="Show all results for #params.location.cityname#, #params.location.stateabbr#">#params.location.cityname#, #params.location.stateabbr#</a>
											<cfelse>
												#params.location.cityname#<cfif params.location.stateFound>, #params.location.stateabbr#</cfif>
												<br>
												<a filter="location" value="0" href="##">remove</a>
											</cfif>
										<cfelseif val(len(params.location.cityname)) and val(len(params.location.statename))>
											#params.location.cityname#, #params.location.statename#
											<br>
											<a filter="location" value="0" href="##">remove</a>
										<cfelse>
											#params.location.querystring#
											<br>
											<a filter="location" value="0" href="##">remove</a>
										</cfif>
									</li>
								</ul>
							<cfelse>
								City, <cfif params.country eq 'CA'>province, or postal code<cfelse>state, or zip code</cfif>.
								<form id="cityform" style="margin:0;padding:0;">
									<span class="text med">
										<input id="city" type="text" name="location" value="" class="txt">
									</span>
								</form>
								<a href="##" filter="location" class="location-submit" value="<cfif IsDefined("params.location.querystring") and val(len(params.location.querystring))>#params.location.querystring#</cfif>">Go</a>
								<br>&nbsp;
							</cfif>
						</div>
					</li>
				</cfif>
				<cfif IsDefined("params.location.querystring") and val(len(params.location.querystring))>
					<li class="slide-block<cfif val(params.distance)> active</cfif>">
						<a class="open-close distance" href="">Distance</a>
						<div class="slide">
						<!--- 	<ul>
								<!--- <cfif val(params.distance)>
									<li>
										#val(params.distance)# miles<br>
										<a filter="distance" value="0" href="distance-0">remove</a>
									</li>
								<cfelse> --->
									<li>
										#selectTag(
											name		= "distance",
											id			= "distance2",
											filter		= "distance",
											label		= "",
											includeblank= false,
											options		= distances,
											selected	= params.distance)#
									</li>
								<!--- </cfif> --->
							</ul>--->
							<form name="distanceform" action="##" class="location-form" onsubmit="ChangeLocationAndOrDistance(); return false;">
								<fieldset>
									<span class="text">
									#textFieldTag(
										name="distance",
										id="distance",
										value=params.distance,
										class="txt noPreText"
									)#
									</span>
									<em>miles</em>
								</fieldset>
								<a href="##" id="submit-distance" filter="distance" value="" class="location-submit">Go</a>
								<cfif params.distance neq "">
									<a href="##" filter="distance" value="0" class="location-submit">Clear</a>
								</cfif>
							</form>
						</div>
					</li>
				</cfif>
				<cfif val(arrayLen(search.filters.procedures)) or val(params.procedure)>
					<li class="slide-block<cfif val(params.procedure)> active</cfif>">
						<a class="open-close" href="">Procedure/Treatment</a>
						<div class="slide" style="display:none;">
							<cfif not val(params.procedure)>
								Procedure Name is like:
								<span class="text med">
									<input id="procedurename" type="text" name="procedure" value="" class="txt">
								</span>
								<hr>
							</cfif>
							<ul id="procedurefilters">
								<cfif val(params.procedure) and structKeyExists(search.searchfilters,"procedure")>
									<li>
										#search.searchfilters.procedure#<br>
										<a filter="procedure" value="0" href="##">remove</a>
									</li>
								<cfelse>
									<cfset proCount = arrayLen(search.filters.procedures)>
									<cfif val(proCount)>
										<div class="filter-modal hidefirst" id="procedure-box">
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
												<!--- <div id="allProcs"> --->
												<table class="allDocs">
													<tr>
														<td>
															<ul>
																<cfset row = 1>
																<cfloop from=1 to="#proCount#" index="i">
																	<cfset name	= listGetAt(search.filters.procedures[i],1,"|")>
																	<cfset id	= listGetAt(search.filters.procedures[i],2,"|")>
																	<cfset count= listGetAt(search.filters.procedures[i],3,"|")>
																	<cfif val(count)>
																		<li>
																			<a filter="procedure" value="#id#" href="##">#name#</a> (#count#)
																		</li>
																		<cfif row++ eq ceiling(proCount/3) and i neq proCount>
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
										<!--- </div> --->
										<cfif proCount lte 10>
											<cfloop from=1 to="#arrayLen(search.filters.procedures)#" index="i">
												<cfset name	= listGetAt(search.filters.procedures[i],1,"|")>
												<cfset id	= listGetAt(search.filters.procedures[i],2,"|")>
												<cfset count= listGetAt(search.filters.procedures[i],3,"|")>
												<cfif val(count)>
													<li>
														<a filter="procedure" value="#id#" href="##">#name#</a> (#count#)
													</li>
												</cfif>
											</cfloop>
										<cfelseif val(proCount)>
											<cfloop from=1 to="5" index="i">
												<cfset name	= listGetAt(search.filters.procedures[i],1,"|")>
												<cfset id	= listGetAt(search.filters.procedures[i],2,"|")>
												<cfset count= listGetAt(search.filters.procedures[i],3,"|")>
												<cfif val(count)>
													<li>
														<a filter="procedure" value="#id#" href="##">#name#</a> (#count#)
													</li>
												</cfif>
											</cfloop>
											<li>...</li>
											<li>
												<!--- <a class="thickbox" href="##TB_inline?width=800&height=600&inlineId=allProcs">View all #proCount# procedures</h3> --->
												<a class="filter-more-link" href="##procedure">View all #proCount# procedures</h3>
											</li>
										</cfif>
									<cfelse>
										No procedures matched your search criteria<br>
										<a filter="procedure" value="0" href="##">remove</a>
									</cfif>
								</cfif>
							</ul>
						</div>
					</li>
				</cfif>
				<cfif structKeyExists(search.searchfilters,"procedure") and search.searchfilters.procedure contains "breast">
					<cfif val(arrayLen(search.filters.startingbreastsizes)) or (val(params.breast_size_start) AND isDefined("search.searchfilters.breast_size_start"))>
						<li class="slide-block<cfif val(params.breast_size_start)> active</cfif>">
							<a class="open-close" href="">Breast Size Before</a>
							<div class="slide" style="display:none;">
								<ul>
									<cfif (val(params.breast_size_start) AND isDefined("search.searchfilters.breast_size_start"))>
										<li>
											#search.searchfilters.breast_size_start#<br>
											<a filter="breast_size_start" value="0" href="##">remove</a>
										</li>
									<cfelse>
										<cfloop from=1 to="#arrayLen(search.filters.startingbreastsizes)#" index="i">
											<cfset name	= listGetAt(search.filters.startingbreastsizes[i],1,"|")>
											<cfset id	= listGetAt(search.filters.startingbreastsizes[i],2,"|")>
											<cfset count= listGetAt(search.filters.startingbreastsizes[i],3,"|")>
											<cfif val(count)>
												<li>
													<a filter="breast_size_start" value="#id#" href="##">#name#</a> (#count#)
												</li>
											</cfif>
										</cfloop>
									</cfif>
								</ul>
							</div>
						</li>
					</cfif>
					<cfif val(arrayLen(search.filters.endingbreastsizes)) or (val(params.breast_size_end) AND isDefined("search.searchfilters.breast_size_end"))>
						<li class="slide-block<cfif val(params.breast_size_end)> active</cfif>">
							<a class="open-close" href="">Breast Size After</a>
							<div class="slide" style="display:none;">
								<ul>
									<cfif (val(params.breast_size_end) AND isDefined("search.searchfilters.breast_size_end"))>
										<li>
											#search.searchfilters.breast_size_end#<br>
											<a filter="breast_size_end" value="0" href="##">remove</a>
										</li>
									<cfelse>
										<cfloop from=1 to="#arrayLen(search.filters.endingbreastsizes)#" index="i">
											<cfset name	= listGetAt(search.filters.endingbreastsizes[i],1,"|")>
											<cfset id	= listGetAt(search.filters.endingbreastsizes[i],2,"|")>
											<cfset count= listGetAt(search.filters.endingbreastsizes[i],3,"|")>
											<cfif val(count)>
												<li>
													<a filter="breast_size_end" value="#id#" href="##">#name#</a> (#count#)
												</li>
											</cfif>
										</cfloop>
									</cfif>
								</ul>
							</div>
						</li>
					</cfif>
					<cfif val(arrayLen(search.filters.implanttypes)) or val(params.implant_type)>
						<li class="slide-block<cfif val(params.implant_type)> active</cfif>">
							<a class="open-close" href="">Implant Type</a>
							<div class="slide" style="display:none;">
								<ul>
									<cfif val(params.implant_type)>
										<li>
											#search.searchfilters.implant_type#<br>
											<a filter="implant_type" value="0" href="##">remove</a>
										</li>
									<cfelse>
										<cfloop from=1 to="#arrayLen(search.filters.implantTypes)#" index="i">
											<cfset name	= listGetAt(search.filters.implantTypes[i],1,"|")>
											<cfset id	= listGetAt(search.filters.implantTypes[i],2,"|")>
											<cfset count= listGetAt(search.filters.implantTypes[i],3,"|")>
											<cfif val(count)>
												<li>
													<a filter="implant_type" value="#id#" href="##">#name#</a> (#count#)
												</li>
											</cfif>
										</cfloop>
									</cfif>
								</ul>
							</div>
						</li>
					</cfif>
					<cfif val(arrayLen(search.filters.implantplacements)) or val(params.implant_placement)>
						<li class="slide-block<cfif val(params.implant_placement)> active</cfif>">
							<a class="open-close" href="">Implant Placement</a>
							<div class="slide" style="display:none;">
								<ul>
									<cfif val(params.implant_placement)>
										<li>
											#search.searchfilters.implant_placement#<br>
											<a filter="implant_placement" value="0" href="##">remove</a>
										</li>
									<cfelse>
										<cfloop from=1 to="#arrayLen(search.filters.implantPlacements)#" index="i">
											<cfset name	= listGetAt(search.filters.implantPlacements[i],1,"|")>
											<cfset id	= listGetAt(search.filters.implantPlacements[i],2,"|")>
											<cfset count= listGetAt(search.filters.implantPlacements[i],3,"|")>
											<cfif val(count)>
												<li>
													<a filter="implant_placement" value="#id#" href="##">#name#</a> (#count#)
												</li>
											</cfif>
										</cfloop>
									</cfif>
								</ul>
							</div>
						</li>
					</cfif>
					<cfif val(arrayLen(search.filters.entrypoints)) or val(params.point_of_entry)>
						<li class="slide-block<cfif val(params.point_of_entry)> active</cfif>">
							<a class="open-close" href="">Implant Entry Point</a>
							<div class="slide" style="display:none;">
								<ul>
									<cfif val(params.point_of_entry)>
										<li>
											#search.searchfilters.point_of_entry#<br>
											<a filter="point_of_entry" value="0" href="##">remove</a>
										</li>
									<cfelse>
										<cfloop from=1 to="#arrayLen(search.filters.entrypoints)#" index="i">
											<cfset name	= listGetAt(search.filters.entrypoints[i],1,"|")>
											<cfset id	= listGetAt(search.filters.entrypoints[i],2,"|")>
											<cfset count= listGetAt(search.filters.entrypoints[i],3,"|")>
											<cfif val(count)>
												<li>
													<a filter="point_of_entry" value="#id#" href="##">#name#</a> (#count#)
												</li>
											</cfif>
										</cfloop>
									</cfif>
								</ul>
							</div>
						</li>
					</cfif>
				</cfif>
				<cfif not params.intab>
					<cfif val(arrayLen(search.filters.doctors)) or val(params.doctor)>
						<li class="slide-block<cfif val(params.doctor) or val(len(params.doctorlastname))> active</cfif>">
							<a class="open-close" href="">Doctor</a>
							<div class="slide" style="display:none;">
								<cfif not val(params.doctor)>
									Doctor Name is like:
									<span class="text med">
										<input id="doctorlastname" type="text" name="doctorlastname" value="<cfif val(len(params.doctorlastname)) and params.doctorlastname neq 0>#params.doctorlastname#</cfif>" class="txt">
									</span>
									<hr>
								</cfif>
								<ul>
									<cfif val(params.doctor)>
										<li>
											#search.searchfilters.doctor#<br>
											<a filter="doctor" value="0" href="##">remove</a>
										</li>
									<cfelse>
										<cfset docCount = val(arrayLen(search.filters.doctors))>
										<cfif val(docCount)>
											<!--- <div id="allDocs"> --->
											<div class="filter-modal hidefirst" id="doctor-box">
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
																				<cfloop from=1 to="#arrayLen(search.filters.doctors)#" index="i">
																					<cfset name	= listGetAt(search.filters.doctors[i],1,"|")>
																					<cfset id	= listGetAt(search.filters.doctors[i],2,"|")>
																					<cfset count= listGetAt(search.filters.doctors[i],3,"|")>
																					<cfif val(count)>
																						<li>
																							<a filter="doctor" value="#id#" doctor="doctor-#id#" href="##">#name#</a> (#count#)
																						</li>
																						<cfif row++ eq ceiling(docCount/3) and i neq docCount>
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
											<!--- </div> --->
											<cfif docCount lte 10>
												<cfloop from=1 to="#arrayLen(search.filters.doctors)#" index="i">
													<cfset name	= listGetAt(search.filters.doctors[i],1,"|")>
													<cfset id	= listGetAt(search.filters.doctors[i],2,"|")>
													<cfset count= listGetAt(search.filters.doctors[i],3,"|")>
													<cfif val(count)>
														<li>
															<a filter="doctor" value="#id#" href="##">#name#</a> (#count#)
														</li>
													</cfif>
												</cfloop>
											<cfelseif val(docCount)>
												<cfloop from=1 to="5" index="i">
													<cfset name	= listGetAt(search.filters.doctors[i],1,"|")>
													<cfset id	= listGetAt(search.filters.doctors[i],2,"|")>
													<cfset count= listGetAt(search.filters.doctors[i],3,"|")>
													<cfif val(count)>
														<li>
															<a filter="doctor" value="#id#" href="##">#name#</a> (#count#)
														</li>
													</cfif>
												</cfloop>
												<li>...</li>
												<li>
													<!--- <a class="thickbox" href="##TB_inline?width=800&height=600&inlineId=allDocs">View all #docCount# doctors</h3> --->
													<a class="filter-more-link" href="##doctor">View all #docCount# doctors</h3>
												</li>
											</cfif>
										<cfelse>
											No doctors matched your search criteria<br>
											<a filter="doctor" value="0" href="##">remove</a>
										</cfif>
									</cfif>
								</ul>
							</div>
						</li>
					</cfif>
				</cfif>
				<cfif val(arrayLen(search.filters.genders)) or val(params.gender)>
					<li class="slide-block<cfif val(params.gender)> active</cfif>">
						<a class="open-close" href="">Gender</a>
						<div class="slide">
							<ul>
								<cfif val(params.gender)>
									<li>
										#search.searchfilters.gender#<br>
										<a filter="gender" value="0" href="##">remove</a>
									</li>
								<cfelse>
									<cfloop from=1 to="#arrayLen(search.filters.genders)#" index="i">
										<cfset name	= listGetAt(search.filters.genders[i],1,"|")>
										<cfset id	= listGetAt(search.filters.genders[i],2,"|")>
										<cfset count= listGetAt(search.filters.genders[i],3,"|")>
										<cfif val(count)>
											<li>
												<a filter="gender" value="#id#" href="##">#name#</a> (#count#)
											</li>
										</cfif>
									</cfloop>
								</cfif>
							</ul>
						</div>
					</li>
				</cfif>
				<cfif val(arrayLen(search.filters.ages)) or (val(params.age_start) and val(params.age_end))>
					<li class="slide-block<cfif val(params.age_start)> active</cfif>">
						<a class="open-close" href="">Age</a>
						<div class="slide" style="display:none;">
							<ul>
								<cfif val(params.age_start) and val(params.age_end)>
									<li>
										#val(params.age_start)# to #val(params.age_end)#<br>
										<a filter="age" value="0" href="##">remove</a>
									</li>
								<cfelse>
									<cfset rangeArr = structKeyArray(ageRanges)>
									<cfset arraySort(rangeArr,"text")>
									<cfloop from="1" to="#arrayLen(rangeArr)#" index="i">
										<cfset range= rangeArr[i]>
										<cfset low	= val(listFirst(range,"_"))>
										<cfset high	= val(listLast(range,"_"))>
										<cfset tally= 0>
										<cfloop from="1" to="#arrayLen(search.filters.ages)#" index="o">
											<cfset value = val(listFirst(search.filters.ages[o],"|"))>
											<cfset count = val(listLast(search.filters.ages[o],"|"))>
											<cfif value gte low and value lte high>
												<cfset tally = tally+count>
											</cfif>
										</cfloop>
										<cfif val(tally)>
											<li>
												<a filter="age" value="#range#" href="##">#ageRanges[range]#</a> <div>(#tally#)</div>
											</li>
										</cfif>
									</cfloop>
								</cfif>
							</ul>
						</div>
					</li>
				</cfif>
				<cfif val(arrayLen(search.filters.heights)) or (val(params.height_start) and val(params.height_end))>
					<li class="slide-block<cfif val(len(params.height)) and params.height neq 0> active</cfif>">
						<a class="open-close" href="">Height</a>
						<div class="slide" style="display:none;">
							<ul>
								<cfif val(params.height_start) and val(params.height_end)>
									<li>
										#params.height_start# to #params.height_end#<br>
										<a filter="height" value="0" href="##">remove</a>
									</li>
								<cfelse>
									<cfset rangeArr = structKeyArray(heightRanges)>
									<cfset arraySort(rangeArr,"text")>
									<cfloop from="1" to="#arrayLen(rangeArr)#" index="i">
										<cfset range= rangeArr[i]>
										<cfset low	= val(listFirst(range,"_"))>
										<cfset high	= val(listLast(range,"_"))>
										<cfset tally= 0>
										<cfloop from="1" to="#arrayLen(search.filters.heights)#" index="i">
											<cfset value = listFirst(search.filters.heights[i],"|")>
											<cfif value gte low and value lte high>
												<cfset tally += ListLast(search.filters.heights[i],"|")>
											</cfif>
										</cfloop>
										<cfif val(tally)>
											<li>
												<a filter="height" value="#range#" href="##">#heightRanges[range]#</a> <div>(#tally#)</div>
											</li>
										</cfif>
									</cfloop>
								</cfif>
							</ul>
						</div>
					</li>
				</cfif>
				<cfif val(arrayLen(search.filters.weights)) or (val(params.weight_start) and val(params.weight_end))>
					<li class="slide-block<cfif val(len(params.weight)) and params.weight neq 0> active</cfif>">
						<a class="open-close" href="">Weight</a>
						<div class="slide" style="display:none;">
							<ul>
								<cfif val(params.weight_start) and val(params.weight_end)>
									<li>
										#params.weight_start# to #params.weight_end#<br>
										<a filter="weight" value="0" href="##">remove</a>
									</li>
								<cfelse>
									<cfset rangeArr = structKeyArray(weightRanges)>
									<cfset arraySort(rangeArr,"text")>
									<cfloop from="1" to="#arrayLen(rangeArr)#" index="i">
										<cfset range= rangeArr[i]>
										<cfset low	= val(listFirst(range,"_"))>
										<cfset high	= val(listLast(range,"_"))>
										<cfset tally= 0>
										<cfloop from="1" to="#arrayLen(search.filters.weights)#" index="i">
											<cfset value = listFirst(search.filters.weights[i],"|")>
											<cfif value gte low and value lte high>
																								<cfset tally += ListLast(search.filters.weights[i],"|")>
											</cfif>
										</cfloop>
										<cfif val(tally)>
											<li>
												<a filter="weight" value="#range#" href="##">#weightRanges[range]#</a> <div>(#tally#)</div>
											</li>
										</cfif>
									</cfloop>
								</cfif>
							</ul>
						</div>
					</li>
				</cfif>
				<cfif val(arrayLen(search.filters.bodyparts)) or val(params.bodypart)>
					<li class="slide-block<cfif val(params.bodypart)> active</cfif>">
						<a class="open-close" href="">Body part</a>
						<div class="slide" style="display:none;">
							<ul>
								<cfif val(params.bodypart)>
									<li>
										#search.searchfilters.bodypart#<br>
										<a filter="bodypart" value="0" href="##">remove</a>
									</li>
								<cfelse>
									<cfloop from=1 to="#arrayLen(search.filters.bodyParts)#" index="i">
										<cfset name	= listGetAt(search.filters.bodyParts[i],1,"|")>
										<cfset id	= listGetAt(search.filters.bodyParts[i],2,"|")>
										<cfset count= listGetAt(search.filters.bodyParts[i],3,"|")>
										<cfif val(count)>
											<li>
												<a filter="bodypart" value="#id#" href="##">#name#</a> (#count#)
											</li>
										</cfif>
									</cfloop>
								</cfif>
							</ul>
						</div>
					</li>
				</cfif>
				<cfif val(arrayLen(search.filters.skintones)) or val(params.skintone)>
					<li class="slide-block<cfif val(params.skintone)> active</cfif>">
						<a class="open-close" href="">Skin tone</a>
						<div class="slide" style="display:none;">
							<ul>
								<cfif val(params.skintone)>
									<li>
										#search.searchfilters.skintone#<br>
										<a filter="skintone" value="0" href="##">remove</a>
									</li>
								<cfelse>
									<cfloop from=1 to="#arrayLen(search.filters.skinTones)#" index="i">
										<cfset name	= listGetAt(search.filters.skinTones[i],1,"|")>
										<cfset id	= listGetAt(search.filters.skinTones[i],2,"|")>
										<cfset count= listGetAt(search.filters.skinTones[i],3,"|")>
										<cfif val(count)>
											<li>
												<a filter="skintone" value="#id#" href="##">#name#</a> (#count#)
											</li>
										</cfif>
									</cfloop>
								</cfif>
							</ul>
						</div>
					</li>
				</cfif>
			</ul>
		</div>
	</div>
	<div class="b">&nbsp;</div>
	<script>
		var allProcedures = []
		<cfloop from=1 to="#arrayLen(search.filters.procedures)#" index="i">
			allProcedures.push({
				value		: "#JSStringFormat(listGetAt(search.filters.procedures[i],1,"|"))#",
				label		: "#JSStringFormat(listGetAt(search.filters.procedures[i],1,"|"))#",
				procedureId	: #listGetAt(search.filters.procedures[i],2,"|")#
			})
		</cfloop>
	</script>
</cfoutput>