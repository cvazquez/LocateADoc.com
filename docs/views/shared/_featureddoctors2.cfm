<cfparam name="arguments.doctors" default="">
<cfparam name="params.showRawData" default="0">

<cfif IsQuery(arguments.doctors) and arguments.doctors.recordcount gt 0>
<cfoutput>
	<div class="resources-box doctor-gallery">
		<div class="title">
			<div>
				<p class="title-header"><em>Featured</em> Doctors</p>
				<span class="carouselInstructions">Click on any of the Doctors to view their Profile.  Move your mouse over the carousel to pause its position.</span>
			</div>
			<cfif arguments.doctors.recordcount gt 3>
			<div class="sw-box">
				<div>
					<a class="link-prev" href="##">Previous</a>
					<ul class="switcher">
						<li class="active"><a href="##"><span>1</span></a></li>
						<li><a href="##"><span>2</span></a></li>
						<li><a href="##"><span>3</span></a></li>
						<li><a href="##"><span>4</span></a></li>
					</ul>
					<a class="link-next" href="##">Next</a>
				</div>
			</div>
			</cfif>
		</div>
		<div class="side-gallery">
			<div class="gallery">
				<ul <cfif arguments.doctors.hasPowerPosition>class="carousel-static"<cfelse>class="featured-carousel" displaySize="3"</cfif>>
					<cfset clickTrackSection = "FeaturedDoctorsCarousel">
					<cfsavecontent variable="paramKeyValues">
						<cfloop collection="#params#" item="pC">
							<cfif isnumeric(params[pC])>
								#pC#:#val(params[pC])#;
							</cfif>
						</cfloop>
					</cfsavecontent>

					<cfloop query="arguments.doctors">
						<cfsavecontent variable="clickTrackKeyValues">
							accountDoctorLocationId:#arguments.doctors.id#;
							position:#arguments.doctors.currentRow#;
							practiceRank:#arguments.doctors.PracticeRank#;
							zoneId:#arguments.doctors.zoneId#;
							zoneStateId:#arguments.doctors.zoneStateId#;
							#paramKeyValues#
						</cfsavecontent>

						<!--- format full name --->
						<cfset fullName = "#arguments.doctors.firstname# #Iif(arguments.doctors.middlename neq '',DE(arguments.doctors.middlename&' '),DE('')) & arguments.doctors.lastname#">
						<cfif LCase(arguments.doctors.title) eq "dr" or LCase(arguments.doctors.title) eq "dr.">
							<cfset fullName = "Dr. #fullName#">
						<cfelseif arguments.doctors.title neq "">
							<cfset fullName &= ", #arguments.doctors.title#">
						</cfif>
						<cfset allLocations = model("AccountPractice").getAllLocations(
							practiceID = arguments.doctors.practiceID,
							doctorID = arguments.doctors.doctorID,
							state = val(params.state)
						)>

						<cfset tooltip = "#fullName# | #arguments.doctors.practice# | <i>Specialty: #specialty#</i>">
						<cfif allLocations.recordcount gt 1>
							<cfset tooltip &= " | Multiple Locations">
						<cfelse>
							<cfset tooltip &= " | #arguments.doctors.city#, #arguments.doctors.state#">
						</cfif>
						<cfif arguments.doctors.phone neq "">
							<cfset tooltip &= " | <b>#formatPhone(arguments.doctors.phone)#</b>">
						</cfif>
						<li>
							<p class="featured-doctor-name tooltip" title="#tooltip#"><a	clickTrackSection = "#clickTrackSection#"
																		clickTrackLabel		= "FullName"
																		clickTrackKeyValues	= "#clickTrackKeyValues#"
																		href="/#arguments.doctors.siloName#?l=#arguments.doctors.locationID#">#fullName#<cfif client.debug and val(params.showRawData)> [#PracticeRank#]</cfif></a></p>
							<div class="box">
								<div class="image tooltip" title="#tooltip#">
									<div class="t">
										<div class="b">
											<a	clickTrackSection	= "#clickTrackSection#"
												clickTrackLabel		= "Photo"
												clickTrackKeyValues	= "#clickTrackKeyValues#"
												href="/#arguments.doctors.siloName#?l=#arguments.doctors.locationID#">
												<img width="63" height="72" alt="#fullName#" src="#Globals.doctorPhotoBaseURL & arguments.doctors.photoFilename#" />
											</a>
										</div>
									</div>
								</div>
								<div class="descr"<!---  style="font: 11px/12px Arial, Helvetica, sans-serif;" --->>
									<div class="tooltip" title="#tooltip#">
										<div<!---  style="height:12px; overflow:hidden;" --->>
											<div class="innerPractice">
												#arguments.doctors.practice#
											</div>
										</div>
										<div <!--- style="height:12px; overflow:hidden;" --->>
											<div class="innerSpecialty">
												<i>#Replace(Replace(specialty, "(", "<span style='display:none;'>("), ")", ")</span>")#</i>
											</div>
										</div>
										<div class="innerLocation"<!---  style="height:12px; overflow:hidden;" --->>
											<cfif allLocations.recordcount gt 1>
											<a href="##" class="choose-location" practice="#arguments.doctors.practiceID#">Choose Location</a>
											<cfelse>
											#arguments.doctors.city#, #arguments.doctors.state#
											</cfif>
										</div>
										<div class="innerPhone"<!--- style="height:12px; overflow:hidden;" --->>
											<cfif arguments.doctors.phone neq "">
												<b>#formatPhone(arguments.doctors.phone)#</b>
											</cfif>
										</div>
									</div>
									<!--- <span class="left"></span> --->
									<div class="details">
										<ul>
											<!--- <li><span class="rating"><cfif comments gt 0 and rating neq "">#Numberformat(rating,"9.0")#<cfelse>--</cfif></span></li> --->
											<cfif val(comments) gt 0>
											<cfset reviewNumberLabel = "#comments# Review#(comments GT 1 ? "s" : "")#">
											<li><a	clickTrackSection	= "#clickTrackSection#"
													clickTrackLabel		= "Comments"
													clickTrackKeyValues	= "#clickTrackKeyValues#"
													title="Patient Reviews" href="/#arguments.doctors.siloName#/reviews?l=#arguments.doctors.locationID#">
													<img src="/images/layout/ico105.gif" alt="#reviewNumberLabel#" <!--- style="vertical-align: middle;"  --->>
													#reviewNumberLabel#</a></li>
											</cfif>
										</ul>
										<strong class="more">#linkTo(	clickTrackSection	= "#clickTrackSection#",
																		clickTrackLabel		= "View",
																		clickTrackKeyValues	= "#clickTrackKeyValues#",
																		text="VIEW PROFILE",
																		href="/#arguments.doctors.siloName#?l=#arguments.doctors.locationID#")#
										</strong>
									</div>
								</div>
							</div>
							<cfif allLocations.recordcount gt 1>
								<div <!--- style="display:none;"  --->class="practiceLocations" id="locations_#arguments.doctors.practiceID#">
									<cfloop query="allLocations">
										<a	clickTrackSection	= "#clickTrackSection#"
											clickTrackLabel		= "AllLocations"
											clickTrackKeyValues	= "#clickTrackKeyValues#accountLocationId:#allLocations.locationID#"
											href="/#arguments.doctors.siloName#?l=#allLocations.locationID#">
											#REReplace(REReplace(allLocations.address,"&lt;[bB][rR](&rt;)?","<br>","all"),"(&(l|g)t;)|(<br>$)","","all")#<br>
											#allLocations.city#, #allLocations.state# #allLocations.postalCode#
										</a>
									</cfloop>
								</div>
							</cfif>
						</li>
						<cfif arguments.doctors.hasPowerPosition and arguments.doctors.currentrow eq 1 AND NOT isMobile>
						</ul><ul class="featured-carousel carousel-short" displaySize="2">
						</cfif>
					</cfloop>
				</ul>
			</div>
		</div>
	</div>

	<cfif client.debug and val(params.showRawData)>
		<cfquery datasource="#get('dataSourceName')#" name="rawData">
			SELECT dataA.*, CASE WHEN dataB.CPL IS NULL THEN 0 ELSE dataB.CPL END AS CPL
				,(SELECT 1 FROM accountproductspurchased app2
				  JOIN accountproductspurchaseddoctorlocations appdl2 on app2.id = appdl2.accountProductsPurchasedId
				  WHERE app2.accountproductid = 5
				  AND appdl2.accountDoctorLocationId = dataA.accountDoctorLocationId
				  AND appdl2.specialtyId = dataA.specialtyId
				  AND now() <= app2.dateEnd	LIMIT 1) as AB_1stSpot
				,(SELECT 1 FROM accountproductspurchased app2
				  JOIN accountproductspurchaseddoctorlocations appdl2 on app2.id = appdl2.accountProductsPurchasedId
				  WHERE app2.accountproductid = 4
				  AND appdl2.accountDoctorLocationId = dataA.accountDoctorLocationId
				  AND appdl2.specialtyId = dataA.specialtyId
				  AND now() <= app2.dateEnd	LIMIT 1) as AB_2ndSpot
				,(SELECT 1 FROM accountproductspurchased app2
				  JOIN accountproductspurchaseddoctorlocations appdl2 on app2.id = appdl2.accountProductsPurchasedId
				  WHERE app2.accountproductid = 9
				  AND appdl2.accountDoctorLocationId = dataA.accountDoctorLocationId
				  AND appdl2.specialtyId = dataA.specialtyId
				  AND now() <= app2.dateEnd	LIMIT 1) as AB_3rdSpot
				,(SELECT 1 FROM accountproductspurchased app2
				  JOIN accountproductspurchaseddoctorlocations appdl2 on app2.id = appdl2.accountProductsPurchasedId
				  WHERE app2.accountproductid = 10
				  AND appdl2.accountDoctorLocationId = dataA.accountDoctorLocationId
				  AND appdl2.specialtyId = dataA.specialtyId
				  AND now() <= app2.dateEnd	LIMIT 1) as AB_4thSpot
			FROM(
				SELECT DISTINCT app.id, app.accountid, datediff(now(),app.dateStart) as age,
					datediff(app.dateEnd,now()) as timeLeft, count(apph.id) as historycount, s.name as aa_specialty,
					appdl.accountDoctorLocationId, appdl.specialtyId, CONCAT(ad.firstname,' ',ad.lastname) AS aa_fullname,
					<!--- FLOOR(DATEDIFF(now(),CASE WHEN min(apph.dateStart) IS NOT NULL THEN min(apph.dateStart) ELSE app.dateStart END)/365) AS y_yearsServiced,
					FLOOR((CASE WHEN now() > app.dateStart THEN DATEDIFF(now(),app.dateStart) ELSE 0 END + SUM(DATEDIFF(apph.dateEnd,apph.dateStart)))/365) AS y_closerYearsServiced, --->
					CAST(GROUP_CONCAT(CONCAT(apph.dateStart,'|',CASE WHEN now() > apph.dateEnd THEN apph.dateEnd ELSE DATE(now()) END)) AS CHAR) as zz_dateSpans,
					CAST(CASE WHEN now() > app.dateStart THEN CONCAT(app.dateStart,'|',DATE(now())) ELSE '' END AS CHAR) as zz_currentDateSpan,
					appdl.practicerankscore as aba_prank, appdl.practicerankspecialtyscore as aba_sprank,
					'' as profilecompletion, '' as YearsInService,
					(SELECT count(1)
						FROM gallerycasedoctors gcd JOIN gallerycases gc ON gcd.galleryCaseId = gc.id
						WHERE gcd.accountdoctorid = adl.accountDoctorId
						AND gc.deletedAt IS NULL) AS BAAGCases,
					(SELECT count(DISTINCT DATE(gc.createdAt))
						FROM gallerycasedoctors gcd JOIN gallerycases gc ON gcd.galleryCaseId = gc.id
						WHERE gcd.accountdoctorid = adl.accountDoctorId
						AND gc.createdAt > DATE_ADD(now(),INTERVAL -30 DAY)
						AND gc.deletedAt IS NULL) AS BAAGFrequency
				FROM accountproductspurchased app
					LEFT OUTER JOIN accountproductspurchasedhistory apph on apph.accountId = app.accountId
					JOIN accountproductspurchaseddoctorlocations appdl on app.id = appdl.accountProductsPurchasedId
					JOIN accountdoctorlocations adl on appdl.accountDoctorLocationId = adl.id
					JOIN accountdoctors ad on adl.accountdoctorid = ad.id
					JOIN specialties s on appdl.specialtyId = s.id
				WHERE app.deletedAt is null
					AND appdl.deletedAt is null
					AND app.accountProductId = 1
					AND now() <= app.dateEnd
					AND adl.id IN (#ValueList(arguments.doctors.ID)#)
				GROUP BY app.id, appdl.accountDoctorLocationId, appdl.specialtyId
			) dataA
			JOIN(
				SELECT dataC.accountid,
					(SELECT cplFolioPhonePlusMini FROM accountproductspurchasedcplreports
					 WHERE accountproductspurchasedcplreports.accountid = dataC.accountid
					 ORDER BY createdAt desc LIMIT 1) as CPL
				  FROM(
					SELECT DISTINCT app.accountid
					FROM accountproductspurchased app
					WHERE app.deletedAt is null
						AND app.accountProductId = 1
						AND now() <= app.dateEnd
				  ) dataC
			) dataB on dataA.accountid = dataB.accountid
			ORDER BY aba_prank DESC, accountid asc, accountDoctorLocationId asc, specialtyId asc;
		</cfquery>
		<cfset currentAccount = 0>
		<cfset ProfileComplete = 0>
		<cfset yearsOfService = 0>
		<cfset oDCV = createObject("component", "models.DashboardClientsVisual")>
		<cfloop query="rawData">
			<cfif currentAccount neq rawData.accountid>
				<cfset currentAccount = rawData.accountid>
				<cfset oDCV.init(rawData.accountid)>
				<cfset qProfileMissingItems = oDCV.GetProfileMissingItems()>
				<cfset ProfileComplete = val(oDCV.ProfileComplete(qProfileMissingItems))>
				<cfset DateList = ListSort(ListAppend(rawData.zz_DateSpans,rawData.zz_CurrentDateSpan), "text", "asc")>
				<cfset DateArray = []>
				<cfloop list="#DateList#" index="dateCouple">
					<cfset coupleStart = ParseDateTime(ListFirst(dateCouple,'|'))>
					<cfset coupleEnd = ParseDateTime(ListLast(dateCouple,'|'))>
					<cfif ArrayLen(DateArray) eq 0>
						<cfset ArrayAppend(DateArray,{start=coupleStart,end=coupleEnd})>
					<cfelse>
						<cfif DateCompare(coupleStart,DateArray[ArrayLen(DateArray)].end) lt 0>
							<cfset DateArray[ArrayLen(DateArray)].end = coupleEnd>
						<cfelseif DateCompare(coupleEnd,DateArray[ArrayLen(DateArray)].end) gt 0>
							<cfset ArrayAppend(DateArray,{start=coupleStart,end=coupleEnd})>
						</cfif>
					</cfif>
				</cfloop>
				<cfset yearsOfService = 0>
				<cfloop array="#DateArray#" index="dateCouple">
					<cfset yearsOfService += DateDiff("d",dateCouple.start,dateCouple.end)>
				</cfloop>
				<cfset yearsOfService = Int(yearsOfService/365)>
			</cfif>
			<cfset QuerySetCell(rawData, "profilecompletion", ProfileComplete, rawData.currentrow)>
			<cfset QuerySetCell(rawData, "YearsInService", yearsOfService, rawData.currentrow)>
		</cfloop>
		<div <!--- style="height:300px; width:700px; overflow:scroll;"  --->class="rawData">
		<cfdump var="#rawData#" metainfo="false">
		</div>
	</cfif>

	<div id="location-list">
	</div>
	<cfif not isMobile>
	<script type="text/javascript">
		$(function(){
			SmartTruncate('.innerPractice',15<cfif NOT isMobile>,147<cfelse>,70</cfif>,true);
			SmartTruncate('.innerSpecialty',15<cfif NOT isMobile>,147<cfelse>,70</cfif>,true);
		});
	</script>
	</cfif>
</cfoutput>
<!--- <cfsavecontent variable="tooltipJSandCSS">
	<cfoutput>
		<link rel="stylesheet" type="text/css" href="/stylesheets/jquery.tooltip.css" />
		<script type="text/javascript" src="/javascripts/jquery.tooltip.min.js"></script>
	</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#tooltipJSandCSS#"> --->
</cfif>