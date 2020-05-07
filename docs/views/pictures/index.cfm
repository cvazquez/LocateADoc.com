<cfoutput>

	<cfif isMobile>
		#javaScriptIncludeTag(sources="
								pictures/index
							",head=true)#
		<!--- #javaScriptIncludeTag(sources="
								pictures/index,
								utils,
								main
							",head=true)# --->
	<cfelse>
		#javaScriptIncludeTag(sources="
								pictures/index,
								http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js,
								utils
							",head=true)#
	</cfif>
	<script>
	var gallerybase = '#URLFor(controller="pictures")#'
	</script>
	<!-- main -->
	<div id="main" class="bg7">
		<!-- search-types -->
		<div class="search-types">
			<!-- holder -->
			<div class="holder">
				<div class="pagetitle">
					<!--- <h1 class="hidden">Before and After Plastic Surgery Pictures</h1> --->
					<h1 class="gallery-header">Before and After Photos</h1>
				</div>
				<cfif not isMobile><span class="search-title">start search</span></cfif>
				<!-- frame -->
				<div class="frame">
					<ul class="tabset">
						<cfif not isMobile>
							<li><a href="##tab1" class="tab<cfif activeTab eq 1> active</cfif>">By Procedure</a></li>
							<li><a href="##tab2" class="tab<cfif activeTab eq 2> active</cfif>">By Doctor</a></li>

							<li><a href="##tab3" class="tab<cfif activeTab eq 3> active</cfif>">By Body Part</a></li>
							<li><a href="##tab4" class="tab<cfif activeTab eq 4> active</cfif>">Advanced</a></li>
						</cfif>
					</ul>
					<div class="tabholder">
							<!--- Research by Body Part --->
							<cfif isMobile>
								<a href="##bodypart" data-role="button" data-icon="plus" data-theme="b" data-transition="flip" class="left-aligned">View Body Part Pictures</a>
							</cfif>

							<!--- TAB: By Procedure --->
							#includePartial("byProcedureTab")#

						<cfif not isMobile>
							<!--- TAB: By Doctor --->
							#includePartial("byDoctorTab")#

							<!--- TAB: By Bodypart --->
							#includePartial("byBodyPartTab")#

							<!--- TAB: Advanced --->
							#includePartial("byAdvancedTab")#
						</cfif>

					</div>
				</div>
			</div>
		</div>
		<!-- container -->
		<div class="container">

				<!-- twocolumns -->
				<div class="twocolumns">
					<!-- content -->
					<div class="content">
						<cfif isMobile>
							<cfif latestPictures.recordCount GT 0>
								<div class="mobileWidget">
									#includePartial("/shared/beforeandaftersidebox")#
								</div>
							</cfif>
						<cfelse>
							<iframe id="featuredframe" src="/pictures/recentlyadded" style="width:600px;height:315px;border:0;margin:0;padding:0;overflow-x:hidden;overflow-y:hidden;" scrolling="no"></iframe>
						</cfif>
					</div>
					<cfif not isMobile>
						<!-- aside -->
						<div class="aside">
							#includePartial("/shared/featureddoctors3")#
						</div>
					</cfif>
				</div>

		<cfif NOT isMobile>
			<div class="search-content-holder">
				<h3>Before and <strong>After Photos</strong></h3>
				<div class="search-content">
					<p>Cosmetic procedures are doubly complicated because to be considered successful, a procedure must maintain or improve a patient's health and achieve a desired aesthetic result. With the vast resources of LocateADoc.com you can review the <b>before and after photos</b> of 100+ procedures, read up on the doctor who performed them, and read patients' reviews- all before making an appointment!</p>
					<p>LocateADoc.com exists for one reason: to empower patients so you have trust in the doctor you are selecting. Besides helping you #LinkTo(controller="doctors",text="find a specialist")# for your procedure, we've compiled a <b>comprehensive gallery of before and after photos</b> of real procedures performed by real doctors who are listed in our system.</p>
					<p>If you're thinking about having a cosmetic procedure, the first thing you should do is review our galleries of before and after photos. Filter results by procedure, gender, age, height, and weight to see the results patients similar to you have achieved. If you like what you see, filter the results by location to <b>find a specialist in your area</b>. That's what LocateADoc.com is all about!</p>
					<p>Before and after photos are a good place to start making your decision. Review everything from #LinkTo(controller="doctors",action="abdominal-liposuction-liposculpture",text="abdominal liposuction surgery")# to Zerona laser fat removal and everything in between. With LocateADoc.com you'll spend less time and money being bounced from one doctor to the next, and you'll make the right decision the first time. Your health is too important to be left to trial and error. Get educated and get the body you want today. More in-depth information can be found on specific procedures in #LinkTo(controller="resources",text="our articles page")#.</p>
				</div>
			</div>
		</cfif>
			<div class="vertical-block-holder">
				<cfif isMobile>
					<div class="swm mobileWidget">
						<h2>Contact A Doctor</h2>
						#includePartial(partial="/mobile/mini_form",toDesktop=false)#
					</div>
				<cfelse>
					#includePartial(partial="/shared/sitewideminileadsidebox",smallBlock=true)#
					#includePartial("/shared/caniaffordit")#
				</cfif>
			</div>
		</div>
	</div>
</cfoutput>

<cfif isMobile>
	<cfsavecontent variable="additionalPages">
		<cfoutput>
			<div id="bodypart" data-role="page" data-url="bodypart" data-transition="flip">
				<ul data-role="listview">
					<li data-role="list-divider">View Body Part Pictures</li>
					</cfoutput>
					<cfoutput query="bodyParts" group="bodyRegionName">
						<li>
							<p>#bodyRegionName#</p>
							<ul>
								<cfoutput group="bodyPartName">
								<li>
									<p>#bodyPartName#</p>
									<ul>
										<cfoutput>
											<li>
												<a href="#URLFor(action=bodyParts.siloName)#" rel="external">#procedureName#</a>
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