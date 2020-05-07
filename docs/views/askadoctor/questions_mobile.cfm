<cfoutput>
	<div id="page1" class="centered askADocQuestions">
		<div id="bottom-content-wrapper">
			<div id="mobile-content">
				<div class="title">
					<h1 class="page-title">#header#</h1>

					<cfif search.pages gt 1>
						<div class="pagination">#includePartial("/shared/_pagination_mobile.cfm")#</div>
					</cfif>
				</div>

				<!-- content -->
				<div class="print-area" id="article-content">
					<cfif isDefined("Questions") and Questions.recordcount>
						<cfloop query="Questions">
							<div class="askadoc-question">
								<cfset articleDate = (params.action eq "question" or params.action eq "questions") ? Questions.publishAt : Questions.createdAt>
								<cfif IsDate(articleDate)>
									<cfif DateDiff("yyyy",articleDate,now()) eq 0>
										<div class="dateflag">#DateFormat(articleDate,"mmm d")#</div>
									<cfelse>
										<div class="dateflag">#DateFormat(articleDate,"mmm yyyy")#</div>
									</cfif>
								</cfif>

								<h3 class="preview"><a href="/ask-a-doctor/question/#Questions.siloName#">#Questions.title#</a></h3>

								<cfset filteredContent = Questions.content>
								<cfset newImageTag = "">
								<cfset articleImages = REFind("<img.+?>",filteredContent,0,true)>
								<cfif articleImages.len[1] gt 0>
									<cfset imageTag = Mid(filteredContent,articleImages.pos[1],articleImages.len[1])>
									<cfset imageWidthLocation = REFind('width\s?(=|:)\s?"?[0-9]+("|px)?',imageTag,0,true)>
									<cfset imageHeightLocation = REFind('height\s?(=|:)\s?"?[0-9]+("|px)?',imageTag,0,true)>
									<cfif imageWidthLocation.pos[1] and imageHeightLocation.pos[1]>
										<cfset newImageTag = imageTag>
										<cfset imageWidth = val(REReplace(Mid(imageTag,imageWidthLocation.pos[1],imageWidthLocation.len[1]),"[^0-9]","","all"))>
										<cfset imageHeight = val(REReplace(Mid(imageTag,imageHeightLocation.pos[1],imageHeightLocation.len[1]),"[^0-9]","","all"))>
										<cfif imageWidth gt 100 and imageHeight gt 100>
											<cfif imageWidth lt imageHeight>
												<cfset newImageWidth = Ceiling(imageWidth/imageHeight * 100)>
												<cfset newImageHeight = 100>
											<cfelse>
												<cfset newImageHeight = Ceiling(imageHeight/imageWidth * 100)>
												<cfset newImageWidth = 100>
											</cfif>
											<cfif newImageWidth gt 20 and newImageHeight gt 20>
												<cfset newImageTag = Replace(Replace(newImageTag,'"#imageHeight#"','"#newImageHeight#"',"all"),'"#imageWidth#"','"#newImageWidth#"',"all")>
												<cfset newImageTag = Replace(Replace(newImageTag,'#imageHeight#px','#newImageHeight#px',"all"),'#imageWidth#px','#newImageWidth#px',"all")>
												<cfset newImageTag = REReplace(newImageTag,"float:\s?right","float: left","all")>
												<cfset newImageTag = REReplace(newImageTag,"border-?[^:]+:[^;]+;","","all")>
											<cfelse>
												<cfset newImageTag = "">
											</cfif>
										</cfif>
									</cfif>
								</cfif>

								<cfif newImageTag EQ "" AND Questions.photoFileName NEQ "">
									<cfsavecontent variable="newImageTitle">#Questions.firstName# #Questions.lastname#<cfif Questions.doctorTitle NEQ "">, #Questions.doctorTitle#</cfif> Picture - LocateADoc.com</cfsavecontent>
									<cfsavecontent variable="newImageTag">
										<div class="askadoc-questions-doctor-photo">
										<img alt="#newImageTitle#" src="/images/profile/doctors/thumb/#Questions.photoFileName#">
										</div>
									</cfsavecontent>
								</cfif>

								<cfset filteredContent = REReplace(filteredContent,"<[^<]+?>","","all")>
								<cfset filteredContent = Replace(filteredContent,"&nbsp;"," ","all")>
								<cfset filteredContent = trim(filteredContent)>
								<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
								<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>

								<cfif REFind("\r|\n",filteredContent)>
									<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
								</cfif>

								<cfset filteredContent = '<div class="askadoc-questions-doctor-content">' & CutText(filteredContent, 200) & '</div>'>

								<cfif Questions.patientFirstName NEQ "" AND NOT reFindNoCase(Questions.patientFirstName, filteredContent)>
									#newImageTag & filteredContent#
								<cfelse>
									<cfset filteredContent = reReplace(filteredContent, "(\s*)\-(\s*)", '<span style="white-space: nowrap;"> - </span>', "all")>
									#newImageTag & filteredContent#
								</cfif>
								<a href="/ask-a-doctor/question/#Questions.siloName#" style="font-size: smaller;">View&nbsp;full&nbsp;question&nbsp;&amp;&nbsp;answer&nbsp;&gt;&gt;</a>
							</div>
							<!--- <div class="askadoc-question-separator"></div> --->
						</cfloop>
					</cfif>
				</div>
				<cfif search.pages gt 1>
					<div class="pagination clear">#includePartial("/shared/_pagination_mobile.cfm")#</div>
				</cfif>
			</div>
			<form name="resultsForm" action="##" method="post"></form>
			<div class="aside3" id="article-widgets">
				<div class="swm mobileWidget">
					<h2>Contact A Doctor</h2>
					#includePartial("/mobile/mini_form")#
				</div>
				<div class="mobileWidget lastestQuestions">
					#includePartial("latestquestions")#
				</div>
				<div class="mobileWidget recentCategories">
					#includePartial("recentcategories")#
				</div>
				<div class="mobileWidget experts">
					#includePartial("experts")#
				</div>
			</div>
		</div>
	</div>
</cfoutput>