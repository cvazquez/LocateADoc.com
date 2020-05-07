<cfoutput>
	<cfif val(search.results.recordcount)>
		<!-- results-list -->
		<ul class="results-list">
			<cfloop query="search.results">
				<cfif params.intab>
					<cfset caseURL = "/#doctor.siloName#/pictures/#ListFirst(procedureSiloNames)#-c#galleryCaseId#">
				<cfelse>
					<cfset caseURL = "/pictures/#ListFirst(procedureSiloNames)#-c#galleryCaseId#">
				</cfif>
				<cfif val(params.procedure)>
					<cfset displayProcedure = search.searchfilters.procedure>
				<cfelse>
					<cfset displayProcedure = ListFirst(procedureNames)>
				</cfif>

				<li>
					<div>
						<h2><a href="#caseURL#">#displayProcedure#</a></h2>
						<div class="images">
							<cfset descriptionList = "">
							<cfif search.results.age neq ""><cfset descriptionList = ListAppend(descriptionList,"#search.results.age# year old")></cfif>
							<cfif search.results.galleryGenderId neq "">
								<cfset descriptionList = ListAppend(descriptionList,(search.results.galleryGenderId eq 1) ? "Male" : "Female")>
							</cfif>
							<cfset descriptionList = Replace(descriptionList,",",", ","all")>
							<cfset formattedPhone = formatPhone(search.results.phone)>

							<cfset thisURL = "">
							<cfif server.thisServer EQ "dev">
								<cfif FileExists("/export/home/dev3.locateadoc.com/docs/images/gallery/thumb/#galleryCaseId#-#listFirst(galleryCaseAngleIds)#-before.jpg")>
									<cfset thisURL = "http://dev3.locateadoc.com">
								<cfelse>
									<cfset thisURL = "http://www.locateadoc.com">
								</cfif>
							</cfif>

							<a href="#caseURL#">
								<!--- [Procedure Name] [Before|After] Image - DoctorFirstname [MiddleInitial] DoctorLastName, Designation(s) - LocateADoc.com --->
								<cfset altBeforeText = "#displayProcedure# Before Image - #search.results.doctorsFullName# - LocateADoc.com">
								<img caseid="#galleryCaseId#" class="casedetails img-l" width="98" height="79" title="#altBeforeText#" alt="#altBeforeText#" src="#thisURL#/pictures/gallery/#listFirst(procedureSiloNames)#-before-thumb-#galleryCaseId#-#listFirst(galleryCaseAngleIds)#.jpg" />
								<cfset altAfterText = "#displayProcedure# After Image - #search.results.doctorsFullName# - LocateADoc.com">
								<img caseid="#galleryCaseId#" class="casedetails img-r" width="90" height="79" title="#altAfterText#" alt="#altAfterText#" src="#thisURL#/pictures/gallery/#listFirst(procedureSiloNames)#-after-thumb-#galleryCaseId#-#listFirst(galleryCaseAngleIds)#.jpg" />
							</a>
							<span class="before">before</span>
							<span class="after">after</span>
						</div>
						<div class="description">
							<cfif not params.intab>
								<cfif search.results.isPastAdvertiser>
									<p>#search.results.doctorsFullName#</p>
								<cfelse>
									<p>#LinkTo(controller=search.results.doctorSiloName,action="pictures",text=search.results.doctorsFullName,class="gallery-doctor-link")#</p>
								</cfif>
							</cfif>
							<cfif descriptionList neq "">
								<p>#descriptionList#</p>
							</cfif>
							<cfif params.intab>
								<cfif search.results.gallerySkinToneName neq "">
									<p>Skin tone: #search.results.gallerySkinToneName#</p>
								</cfif>
								<cfif search.results.bodyPartList neq "">
									<p>Performed on: #Replace(search.results.bodyPartList,",",", ","all")#</p>
								</cfif>
							<cfelse>

								<cfif formattedPhone neq "">
									<p><b>#formattedPhone#</b></p>
								</cfif>

								<cfif not (val(params.location.city) and val(params.location.state))>
									<p><i>#city#, #stateAbbreviation#</i></p>
								</cfif>

								<cfif not search.results.isPastAdvertiser>
								#LinkTo(controller=search.results.doctorSiloName,action="contact",class="btn-contactdoc",text=" ")#
								</cfif>
							</cfif>
						</div>
					</div>
					<cfset filteredDescription = trim(REReplace(search.results.description,"<[^a>]+>","","all"))>
					<cfif filteredDescription neq "">
						<div class="FilteredDescription">
							<div class="content-field content-field1">
								<p id="gallerycontent_#currentrow#">#filteredDescription#</p>
							</div>
							<div id="fullContent-#currentrow#" class="content-field content-field2">
								<p>#filteredDescription#</p>
							</div>
						</div>
					</cfif>
				</li>
			</cfloop>
		</ul>

		<script type="text/javascript">
			$(function(){
				<cfloop query="search.results">
				SmartTruncate('##gallerycontent_#currentrow#',51,0,true,'... <a class="show-more-expand" href="##fullContent-#currentrow#">Show more</a>');
				</cfloop>
				initShowMoreDescription();
			});
		</script>

		<!-- pager-hold -->
		<div class="pager-hold">
			<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
				#includePartial("/shared/pagination_mobile")#
			<cfelse>
				#includePartial("/shared/pagination")#
			</cfif>
		</div>
	<cfelse>
		<p>No pictures found for your search criteria.</p>
		<p><a href="/pictures" class="link-back">Return to the search form to modify your search</a></p>
	</cfif>
</cfoutput>