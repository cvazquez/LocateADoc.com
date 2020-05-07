<div id="tab3" class="bodypart-tab" style="visibility:hidden">
	<form action="##">
		<fieldset>
			<div class="text-box">
				<strong class="title">To start, hover over one of the body parts.</strong>
				<div class="row">
					<label for="gender">Gender:</label>
					<div class="styled-select" style="width: 90px;">
						<select id="gender" class="gender" style="width:110px;">
							<option>Female</option>
							<option>Male</option>
						</select>
					</div>
				</div>
				<div class="row">
					<p>View:</p>
					<ul class="links">
						<li><a class="btn-front" href="##">FRONT</a></li>
						<li><a class="btn-back" href="##">BACK</a></li>
					</ul>
				</div>
			</div>
			<div class="body-box">
				<div class="w-box">
					<!--- WOMAN FRONT --->
					<div class="frm frm01">
						<img class="png" src="/images/layout/img-woman.png" width="141" height="298" alt="image description" />
						<div class="BodyPartsLinks">
						<cfset skip = "Body,Buttocks">
						<cfset skipParts = "Elbow,Wrist,Ankle,Calf">
						<cfoutput query="femaleBodyParts" group="bodyRegionId">
							<cfif not listFind(skip,bodyRegionName)>
								<div class="box" <cfif NOT isMobile>style="top:#regionDots[bodyRegionName].y#px; left:#regionDots[bodyRegionName].x#px;"</cfif>>
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
															<cfset bodyPartNames = listAppend(bodyPartNames," <a href=""/pictures/female/#bodyPartSiloName#"">#bodyPartName#</a>")>
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
					<!--- WOMAN BACK --->
					<div class="frm frm02">
						<img class="png" src="/images/layout/img-woman-back.png" width="140" height="300" alt="image description" />
						<div class="BodyPartsLinks">
						<cfset skip = "Chest,Abdomen,Groin">
						<cfset skipParts = "Fore Arm,Ears,Eyes,Face,Jaw,Mouth,Nose,Knee,Shin,Sole,Toes">
						<cfoutput query="femaleBodyParts" group="bodyRegionId">
							<cfif not listFind(skip,bodyRegionName)>
								<div class="box"  <cfif NOT isMobile>style="top:#regionDots[bodyRegionName].y#px; left:#regionDots[bodyRegionName].x#px;"</cfif>>
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
															<cfset bodyPartNames = listAppend(bodyPartNames," <a href=""/pictures/female/#bodyPartSiloName#"">#bodyPartName#</a>")>
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
				<div class="m-box">
					<!--- MAN FRONT --->
					<div class="frm frm03">
						<img class="png" src="/images/layout/img-man.png" width="163" height="295" alt="image description" />
						<div class="BodyPartsLinks">
						<cfset skip = "Body,Buttocks">
						<cfset skipParts = "Elbow,Wrist,Ankle,Calf">
						<cfoutput query="maleBodyParts" group="bodyRegionId">
							<cfif not listFind(skip,bodyRegionName)>
								<div class="box" <cfif NOT isMobile>style="top:#regionDots[bodyRegionName].y#px; left:#regionDots[bodyRegionName].x#px;"</cfif>>
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
															<cfset bodyPartNames = listAppend(bodyPartNames," <a href=""/pictures/male/#bodyPartSiloName#"">#bodyPartName#</a>")>
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
					<!--- MAN BACK --->
					<div class="frm frm04">
						<img class="png" src="/images/layout/img-man-back.png" width="158" height="291" alt="image description" />
						<div class="BodyPartsLinks">
						<cfset skip = "Chest,Abdomen,Groin">
						<cfset skipParts = "Fore Arm,Ears,Eyes,Face,Jaw,Mouth,Nose,Knee,Shin,Sole,Toes">
						<cfoutput query="maleBodyParts" group="bodyRegionId">
							<cfif not listFind(skip,bodyRegionName)>
								<div class="box" <cfif NOT isMobile>style="top:#regionDots[bodyRegionName].y#px; left:#regionDots[bodyRegionName].x#px;"</cfif>>
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
															<cfset bodyPartNames = listAppend(bodyPartNames," <a href=""/pictures/male/#bodyPartSiloName#"">#bodyPartName#</a>")>
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
			</div>
		</fieldset>
	</form>
</div>
<noscript>
	<h2>Pictures by Body Part - Women</h2>
	<cfoutput query="femaleBodyParts" group="bodyRegionId">
		<h3>#bodyRegionName#</h3>
		<ul>
			<cfoutput>
				<li><a href="/pictures/female/#bodyPartSiloName#">#bodyPartName#</a></li>
			</cfoutput>
		</ul>
	</cfoutput>
	<h2>Pictures by Body Part - Men</h2>
	<cfoutput query="maleBodyParts" group="bodyRegionId">
		<h3>#bodyRegionName#</h3>
		<ul>
			<cfoutput>
				<li><a href="/pictures/male/#bodyPartSiloName#">#bodyPartName#</a></li>
			</cfoutput>
		</ul>
	</cfoutput>
</noscript>