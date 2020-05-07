<span class="search-title">start search</span>
<div class="frame">
	<cfif NOT isMobile>
		<ul class="tabset">
			<li><a href="#tab1" class="tab active">By Location</a></li>
			<li><a href="#tab2" class="tab">By Procedure</a></li>
			<li><a href="#tab3" class="tab">By Body Part</a></li>
		</ul>
	</cfif>
	<div class="tabholder">
		<cfoutput>
		<cfif NOT isMobile>
		<div id="tab1">
			<form name="doctorsearch" class="location-form" action="#URLfor(controller='doctors', action='search')#">
				<fieldset>
					<div class="row">
						<label for="country" id="doctorsearch-country" class="doctorsearch-labels">Country</label>
						<!--- <div style="width: 217px;" class="selectArea temporary"><span class="left"></span><span class="center">United States</span><a href="##" class="selectButton"></a></div> --->
						<div class="styled-select" style="width: 213px;">
							<select name="country" id="country" style="width:230px;">
								<option value="">Select Country</option>
								<option value="US" <cfif params.country eq 'US'>selected</cfif>>United States</option>
								<option value="CA" <cfif params.country eq 'CA'>selected</cfif>>Canada</option>
								<option value="MX" <cfif params.country eq 'MX'>selected</cfif>>Mexico</option>
							</select>
						</div>
					</div>
					<div class="row">
						<label for="city" id="citylabel" id="doctorsearch-location" class="doctorsearch-labels">City, State, Zip</label>
						<div class="styled-input" style="width: 213px; height:20px;"><input style="width: 175px;" name="location" id="city" type="text" <cfif params.location eq "">value="City, State or Zip"<cfelse>value="#params.location#" class="noPreText"</cfif> /></div>
					</div>
					<div class="row">
						<label for="distance" id="doctorsearch-distance" class="doctorsearch-labels">Distance</label>
						<!--- <div style="width: 217px;" class="selectArea temporary"><span class="left"></span><span class="center">Select Distance</span><a href="##" class="selectButton"></a></div> --->
						<div class="styled-select" style="width: 213px;">
							<select name="distance" id="distance" class="hidefirst" style="width:230px;">
								<option value="">Select Distance</option>
								<option name="distance-5" value="5" <cfif params.distance eq 5>selected</cfif>>5 Miles</option>
								<option name="distance-10" value="10" <cfif params.distance eq 10>selected</cfif>>10 Miles</option>
								<option name="distance-25" value="25" <cfif params.distance eq 25>selected</cfif>>25 Miles</option>
							</select>
						</div>
					</div>
					<div class="row">
						<label for="name" id="doctorsearch-lastname" class="doctorsearch-labels">Doctor Last Name</label>
						<div class="styled-input" style="width: 213px; height:20px;"><input style="width: 175px;" name="name" id="name" type="text" <cfif params.name eq "">value="Enter Name Here"<cfelse>value="#params.name#" class="noPreText"</cfif> /></div>
					</div>
					<div class="row">
						<label for="spec" id="doctorsearch-specialization" class="doctorsearch-labels">Specialization</label>
						<!--- <div style="width: 217px;" class="selectArea temporary"><span class="left"></span><span class="center">Select Specialty</span><a href="##" class="selectButton"></a></div> --->
						<div class="styled-select" style="width: 213px;">
							<select name="specialty" id="spec" class="short-box hidefirst" style="width:230px;">
								<option value="">Select Specialty</option>
								<cfloop query="Specialties">
									<option name="specialties_#Specialties.id#" value="#Specialties.id#" <cfif params.specialty eq Specialties.id>selected</cfif>>#name#</option>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="btn">
						<input type="button" class="btn-search" value="SEARCH" onclick="SubmitSearch();">
					</div>
				</fieldset>
			</form>
		</div>
		</cfif>
		<cfif NOT isMobile>
		<div id="tab2" class="procedure-tab sort-box location-form hidefirst">
			<form onsubmit="ProcedureMatch();return false;">
			<div class="text" style="margin:5px 0 0 -5px">
				<label for="typeProcedure">Type a procedure</label>
				<input type="text" id="typeProcedure">
			</div>
			<div class="clear"></div>
			<strong class="title">Start typing a procedure name above or click on the name below.</strong>
			<ul class="list-item sort-heading">
				<cfloop query="ProcedureAlphas">
					<li><a href="##" class="tab #Iif(ProcedureAlphas.letter eq 'A',DE(' active'),DE(''))#">#ProcedureAlphas.letter#</a></li>
				</cfloop>
			</ul>
			<div class="procedures">
				<div id="subtab-a">
					<div class="scrollable">
						<ul class="list sort-list">
							<cfloop query="Procedures">
								<li>#LinkTo(controller="doctors", action=Procedures.siloName, text=Procedures.name, class="procedureOption_#procedures.id#", label=UCase(Procedures.name))#</li>
							</cfloop>
						</ul>
					</div>
				</div>
			</div>
			</form>
		</div>
		</cfif>
		</cfoutput>
		<cfif isMobile>
			<cfif isMobile>
				<a href="#bodypart" data-role="button" data-icon="plus" data-theme="b" data-transition="flip" class="left-aligned">Browse Doctor's By Body Part</a>
			</cfif>
		<cfelse>
			<div id="tab3" class="bodypart-tab hidefirst">
				<form action="#">
					<fieldset>
						<div class="text-box">
							<strong class="title">To start, hover over one of the body parts.</strong>
							<div class="row">
								<label for="gender">Gender:</label>
								<div class="styled-select">
									<select id="gender" class="gender">
										<option>Female</option>
										<option>Male</option>
									</select>
								</div>
							</div>
							<div class="row">
								<p>View:</p>
								<ul class="links">
									<li><a class="btn-front" href="#">FRONT</a></li>
									<li><a class="btn-back" href="#">BACK</a></li>
								</ul>
							</div>
						</div>
						<!-- bodypart-tab -->
						<div class="body-box">
							<div class="w-box">
								<!--- WOMAN FRONT --->
								<div class="frm frm01">
									<img class="png" src="/images/layout/img-woman.png" width="141" height="298" alt="image description" />
									<cfset skip = "Body,Buttocks">
									<cfset skipParts = "Elbow,Wrist,Ankle,Calf">
									<cfoutput query="bodyParts" group="bodyRegionId">
										<cfif not listFind(skip,bodyRegionName)>
											<div class="box" style="top:#yCoordinate#px; left:#xCoordinate#px;">
												<div class="bg"></div>
												<div class="popup">
													<div class="t"></div>
													<div class="c">
														<div class="hold">
															<div class="heading">
																<h3>#bodyRegionName#</h3>
															</div>
															<div class="info">
																<cfset bodyPartNames = "">
																<cfoutput>
																	<cfif not ListFind(skipParts,bodyPartName)>
																		<cfset bodyPartNames = listAppend(bodyPartNames,' #linkTo(controller="doctors",action=bodyParts.siloName,text=bodyPartName)#')>
																	</cfif>
																</cfoutput>
																<p>Includes: #bodyPartNames#</p>
															</div>
														</div>
													</div>
													<div class="b"></div>
												</div>
											</div>
										</cfif>
									</cfoutput>
								</div>
								<!--- WOMAN BACK --->
								<div class="frm frm02">
									<img class="png" src="/images/layout/img-woman-back.png" width="140" height="300" alt="image description" />
									<cfset skip = "Chest,Abdomen,Groin">
									<cfset skipParts = "Fore Arm,Ears,Eyes,Face,Jaw,Mouth,Nose,Knee,Shin,Sole,Toes">
									<cfoutput query="bodyParts" group="bodyRegionId">
										<cfif not listFind(skip,bodyRegionName)>
											<div class="box" style="top:#yCoordinate#px; left:#xCoordinate#px;">
												<div class="bg"></div>
												<div class="popup">
													<div class="t"></div>
													<div class="c">
														<div class="hold">
															<div class="heading">
																<h3>#bodyRegionName#</h3>
															</div>
															<div class="info">
																<cfset bodyPartNames = "">
																<cfoutput>
																	<cfif not ListFind(skipParts,bodyPartName)>
																		<cfset bodyPartNames = listAppend(bodyPartNames,' #linkTo(controller="doctors",action=bodyParts.siloName,text=bodyPartName)#')>
																	</cfif>
																</cfoutput>
																<p>Includes: #bodyPartNames#</p>
															</div>
														</div>
													</div>
													<div class="b"></div>
												</div>
											</div>
										</cfif>
									</cfoutput>
								</div>
							</div>
							<div class="m-box">
								<!--- MAN FRONT --->
								<div class="frm frm03">
									<img class="png" src="/images/layout/img-man.png" width="163" height="295" alt="image description" />
									<cfset skip = "Body,Buttocks">
									<cfset skipParts = "Elbow,Wrist,Ankle,Calf">
									<cfoutput query="bodyParts" group="bodyRegionId">
										<cfif not listFind(skip,bodyRegionName)>
											<div class="box" style="top:#yCoordinate#px; left:#xCoordinate#px;">
												<div class="bg"></div>
												<div class="popup">
													<div class="t"></div>
													<div class="c">
														<div class="hold">
															<div class="heading">
																<h3>#bodyRegionName#</h3>
															</div>
															<div class="info">
																<cfset bodyPartNames = "">
																<cfoutput>
																	<cfif not ListFind(skipParts,bodyPartName)>
																		<cfset bodyPartNames = listAppend(bodyPartNames,' #linkTo(controller="doctors",action=bodyParts.siloName,text=bodyPartName)#')>
																	</cfif>
																</cfoutput>
																<p>Includes: #bodyPartNames#</p>
															</div>
														</div>
													</div>
													<div class="b"></div>
												</div>
											</div>
										</cfif>
									</cfoutput>
								</div>
								<!--- MAN BACK --->
								<div class="frm frm04">
									<img class="png" src="/images/layout/img-man-back.png" width="158" height="291" alt="image description" />
									<cfset skip = "Chest,Abdomen,Groin">
									<cfset skipParts = "Fore Arm,Ears,Eyes,Face,Jaw,Mouth,Nose,Knee,Shin,Sole,Toes">
									<cfoutput query="bodyParts" group="bodyRegionId">
										<cfif not listFind(skip,bodyRegionName)>
											<div class="box" style="top:#yCoordinate#px; left:#xCoordinate#px;">
												<div class="bg"></div>
												<div class="popup">
													<div class="t"></div>
													<div class="c">
														<div class="hold">
															<div class="heading">
																<h3>#bodyRegionName#</h3>
															</div>
															<div class="info">
																<cfset bodyPartNames = "">
																<cfoutput>
																	<cfif not ListFind(skipParts,bodyPartName)>
																		<cfset bodyPartNames = listAppend(bodyPartNames,' #linkTo(controller="doctors",action=bodyParts.siloName,text=bodyPartName)#')>
																	</cfif>
																</cfoutput>
																<p>Includes: #bodyPartNames#</p>
															</div>
														</div>
													</div>
													<div class="b"></div>
												</div>
											</div>
										</cfif>
									</cfoutput>
								</div>
							</div>
						</div>
					</fieldset>
				</form>
			</div>
		</cfif>
	</div>
</div>

<cfif isMobile>
	<cfsavecontent variable="additionalPages">
		<cfoutput>
			<div id="bodypart" data-role="page" data-url="bodypart" data-transition="flip">
				<ul data-role="listview">
					<li data-role="list-divider">Browse Doctor's By Body Part</li>
					</cfoutput>
					<cfoutput query="bodyPartsMobile" group="bodyRegionName">
						<li>
							<p>#bodyRegionName#</p>
							<ul>
								<cfoutput group="bodyPartName">
								<li>
									<p>#bodyPartName#</p>
									<ul>
										<cfoutput>
											<li>
												<a href="#URLFor(action=bodyPartsMobile.siloName)#" rel="external">#procedureName#</a>
											</li>
										</cfoutput>
									</ul>
								</li>
								</cfoutput>
							</ul>
						</li>
					</cfoutput>
					<cfoutput>
				</ul>
			</div>
		</cfoutput>
	</cfsavecontent>
</cfif>