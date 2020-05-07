<cfoutput>
	<!-- main -->
	<div id="main">
		<!-- breadcrumbs -->
		<ul class="breadcrumbs">
			<li><a href="##">Home</a></li>
			<li><a href="##">Search</a></li>
			<li><span>Results</span></li>
		</ul>
		<!-- ad-space -->
		#includePartial(partial	= "/shared/ad",
						size	= "#adType#728x90top#(explicitAd IS TRUE ? "Explicit" : "")#")#
		<!-- container inner-container -->
		<div class="container inner-container">
			<!-- inner-holder -->
			<div class="inner-holder">
				<!-- options -->
				<div class="options">
					<ul>
						<li class="email-link"><a href="##">Email</a></li>
						<li class="print-link"><a href="##">Print</a></li>
						<li class="share-link"><a href="##">Share</a></li>
					</ul>
				</div>
				<!-- content -->
				<div id="content">
					<!-- resources-box search-term -->
					<div class="resources-box search-term">
						<!-- title -->
						<div class="title">
							<div>
								<h2>Search Term: #params.key#</h2>
								<span>(#resultCount# results)</span>
							</div>

							<cfif params.action NEQ "results" AND resultCount GT 10>
							<form action="#cgi.PATH_INFO#" class="pager-form" method="get" onSubmit="return SearchValidatePage(#params.page#, this.page.value, #numberOfPages#);">
								<fieldset>
									<label for="page">Page</label>
									<span class="text"><input name="page" id="page" class="txt" type="text" value="#params.page#" /></span>
									<span>of #numberOfPages#</span>
									<cfif prevPage GT 0>
									#linkTo(text		= "prev",
											controller	= params.controller,
											action		= params.action,
											key			= urlEncodedFormat(params.key),
											params		= "page=#prevPage#",
											class		= "link-prev")#
									</cfif>
									<cfif nextPage LTE numberOfPages >
									#linkTo(text		= "next",
											controller	= params.controller,
											action		= params.action,
											key			= urlEncodedFormat(params.key),
											params		= "page=#nextPage#",
											class		= "link-next")#
									</cfif>
								</fieldset>
							</form>
							</cfif>
						</div>
					</div>
					<!-- content -->
					<div class="content">
	<cfif doctorCount GT 0>
	<!-- widget -->
	<div class="widget">
		<div class="title">
			<h2>Doctors In Your Area</h2>
			<ul class="res-list">
				<li>(#doctorCount# results</li>
				<li><a href="#lcase(viewAllDoctorsURL)#">view all</a>)</li>
			</ul>
		</div>
		<div class="cont-list cont-list2">
			<p style="padding: 10px 0px 10px 0px; font: 12px BreeRegular, Arial, Helvetica, sans-serif;">Listed below are results closest matching your area.  To see all results from your search criteria, please select <a href="#viewAllDoctorsURL#">View All</a>.</p>
			<ul>
				<cfloop query="qDoctors">
					<cfset thisDoctorsURL = "/#qDoctors.siloName#">
				<li>
					<div class="head">
						<strong>#ListFirst(ListChangeDelims(qDoctors.specialtyList, ", ", ","))#</strong>
						<cfif qDoctors.photoFilename NEQ "">
							<div class="box" style="width: 75px;">
								<div class="visual" style="width: 71px;">
									<div class="t" style="width: 71px;">
										<div class="b">
											<a href="#thisDoctorsURL#" style="float: left; padding-right: 10px;"><img src="#(server.thisServer EQ "dev" ? "http://dev3.locateadoc.com" : "")#/images/profile/doctors/thumb/#qDoctors.photoFilename#" width="63" height="72" border="0"></a>
										</div>
									</div>
								</div>
							</div>
						</cfif>
						<div class="doctorbox">
							<ul>
								<li>
									<h3>
									<a href="#thisDoctorsURL#">
									<cfif qDoctors.firstName EQ "" AND qDoctors.lastName EQ "">
										#qDoctors.practice#
									<cfelse>
										#qDoctors.firstName# #qDoctors.lastName#<cfif qDoctors.title NEQ "">,</cfif> #qDoctors.title#
									</cfif>
									</a>
									</h3>
								</li>
								<li>#qDoctors.city#, #qDoctors.State#</li>
							</ul>
							<cfif (qDoctors.firstName NEQ "" OR qDoctors.lastName NEQ "") AND qDoctors.practice NEQ "">
								<strong>#qDoctors.practice#</strong>
							</cfif>
							<strong>#formatPhone(qDoctors.phone)#</strong>
						</div>
					</div>
					<div class="box">
						<p><a href="#thisDoctorsURL#">http://#cgi.server_name##thisDoctorsURL#</a></p>
					</div>
				</li>
				</cfloop>
			</ul>
		</div>
	</div>
	</cfif>
	<cfif galleryCount GT 0>
	<!-- widget -->
	<div class="widget">
		<div class="title">
			<h2>Before and After Gallery</h2>
			<ul class="res-list">
				<li>(#galleryCount# results</li>
				<li><a href="#lcase(viewAllGalleriesURL)#">view all</a>)</li>
			</ul>
		</div>
		<p style="padding: 5px 0px 0px 0px;">Listed below are results closest matching your area.  To see all results from your search criteria, please select <a href="#viewAllGalleriesURL#">View All</a>.</p>
		<ul class="results-list search-results-gallery-list">
			<cfloop query="qGalleries">
				<li>
					<div class="images">
						<a href="/pictures/case/#qGalleries.galleryCaseId#">
							<img caseid="#qGalleries.galleryCaseId#" class="casedetails img-l" width="98" height="79" alt="Before" src="#(server.thisServer EQ "dev" ? "http://www.locateadoc.com" : "")#/pictures/gallery/#listFirst(qGalleries.procedureSiloNames)#-before-thumb-#qGalleries.galleryCaseId#-#listFirst(qGalleries.galleryCaseAngleIds)#.jpg" />
							<img caseid="#qGalleries.galleryCaseId#" class="casedetails img-r" width="90" height="79" alt="After" src="#(server.thisServer EQ "dev" ? "http://www.locateadoc.com" : "")#/pictures/gallery/#listFirst(qGalleries.procedureSiloNames)#-after-thumb-#qGalleries.galleryCaseId#-#listFirst(qGalleries.galleryCaseAngleIds)#.jpg" />
						</a>
						<span class="before">before</span>
						<span class="after">after</span>
					</div>
					<div class="description">
						<h4>#ListFirst(qGalleries.procedureNames)#</h4>
						<a href="/pictures/case/#qGalleries.galleryCaseId#">view details</a>
					</div>
				</li>
			</cfloop>
		</ul>
	</div>
	</cfif>

	<cfif AskADoctorCount GT 0>
	<!-- widget -->
	<div class="widget">
		<div class="title">
			<h2>Ask A Doctor</h2>
			<ul class="res-list">
				<li>(#AskADoctorCount# results<cfif params.action NEQ "results" OR (params.action EQ "results" AND AskADoctorCount LTE 2)>)</cfif></li>
				<cfif params.action EQ "results" AND AskADoctorCount GT 2>
				<li>
						#linkTo(text		= "view all",
								controller	= params.controller,
								action		= "askadoctor",
								key			= lcase(urlencodedFormat(params.key)))#
					)
				</li>
				</cfif>
			</ul>
		</div>
		<div class="cont-list">
			<ul>
				<cfloop query="qAskADoctorResults">
				<li>
					<div class="head">
						<div>
							<em class="date"><cfif isDate(qAskADoctorResults.publishAt)>#DateFormat(qAskADoctorResults.publishAt, "mm.dd.YY")#</cfif></em>
							<h3 class="guides"><a href="#qAskADoctorResults.link#">#qAskADoctorResults.title#</a></h3>
						</div>
					</div>
					<div class="box">
						<p>#qAskADoctorResults.teaser#</p>
						<p><a href="#qAskADoctorResults.link#">http://#cgi.server_name##qAskADoctorResults.link#</a></p>
					</div>
				</li>
				</cfloop>
			</ul>
		</div>
	</div>
	</cfif>

	<cfif guideCount GT 0>
	<!-- widget -->
	<div class="widget">
		<div class="title">
			<h2>Guides</h2>
			<ul class="res-list">
				<li>(#guideCount# results<cfif params.action NEQ "results" OR (params.action EQ "results" AND guideCount LTE 2)>)</cfif></li>
				<cfif params.action EQ "results" AND guideCount GT 2>
				<li>
						#linkTo(text		= "view all",
								controller	= params.controller,
								action		= "guides",
								key			= lcase(urlencodedFormat(params.key)))#
					)
				</li>
				</cfif>
			</ul>
		</div>
		<div class="cont-list">
			<ul>
				<cfloop query="qGuideResults">
				<li>
					<div class="head">
						<strong>#qGuideResults.type# Guide</strong>
						<div>
							<em class="date"><cfif isDate(qGuideResults.publishAt)>#DateFormat(qGuideResults.publishAt, "mm.dd.YY")#</cfif></em>
							<h3 class="guides"><a href="#qGuideResults.link#">#qGuideResults.title#</a></h3>
						</div>
					</div>
					<div class="box">
						<p>#qGuideResults.teaser#</p>
						<p><a href="#qGuideResults.link#">http://#cgi.server_name##qGuideResults.link#</a></p>
					</div>
				</li>
				</cfloop>
			</ul>
		</div>
	</div>
	</cfif>
	<cfif featuresAndArticlesCount GT 0>
	<!-- widget -->
	<div class="widget">
		<div class="title">
			<h2>Features and Articles</h2>
			<ul class="res-list">
				<li>(#featuresAndArticlesCount# results<cfif params.action NEQ "results" OR (params.action EQ "results" AND featuresAndArticlesCount LTE 2)>)</cfif></li>
				<cfif params.action EQ "results" AND featuresAndArticlesCount GT 2>
					<li>
							#linkTo(text		= "view all",
									controller	= params.controller,
									action		= "features",
									key			= lcase(urlencodedFormat(params.key)))#
						)
					</li>
				</cfif>
			</ul>
		</div>
		<div class="cont-list">
			<ul>
				<cfloop query="qFeaturesAndArticlesResults">
				<li>
					<div class="head">
						<strong>#qFeaturesAndArticlesResults.recordType#</strong>
						<div>
							<em class="date"><cfif isDate(qFeaturesAndArticlesResults.publishAt)>#DateFormat(qFeaturesAndArticlesResults.publishAt, "mm.dd.YY")#</cfif></em>
							<h3 class="featuresarticles"><a href="#qFeaturesAndArticlesResults.link#">#qFeaturesAndArticlesResults.title#</a></h3>
						</div>
					</div>
					<div class="box">
						<p>#qFeaturesAndArticlesResults.teaser#</p>
						<p><a href="#qFeaturesAndArticlesResults.link#">http://#cgi.server_name##qFeaturesAndArticlesResults.link#</a></p>
					</div>
				</li>
				</cfloop>
			</ul>
		</div>
	</div>
	</cfif>
	<cfif params.action NEQ "results" AND resultCount GT 10>
		<form action="#cgi.PATH_INFO#" class="pager-form" method="get" onSubmit="return SearchValidatePage(#params.page#, this.page.value, #numberOfPages#);">
			<fieldset>
				<label for="page">Page</label>
				<span class="text"><input name="page" id="page" class="txt" type="text" value="#params.page#" /></span>
				<span>of #numberOfPages#</span>
				<cfif prevPage GT 0>
				#linkTo(text		= "prev",
						controller	= params.controller,
						action		= params.action,
						key			= urlEncodedFormat(params.key),
						params		= "page=#prevPage#",
						class		= "link-prev")#
				</cfif>
				<cfif nextPage LTE numberOfPages >
				#linkTo(text		= "next",
						controller	= params.controller,
						action		= params.action,
						key			= urlEncodedFormat(params.key),
						params		= "page=#nextPage#",
						class		= "link-next")#
				</cfif>
			</fieldset>
		</form>
	</cfif>
					</div>
				</div>
				<!-- sidebar -->
				<div id="sidebar">
					<!-- search-box -->
					<div class="search-box">
						<div class="t">&nbsp;</div>
						<div class="c">
							<div class="c-add">
								<div class="title">
									<h3>Filter Search Results</h3>
								</div>
								<ul>
									<li>
										<form action="/search/results">
											<fieldset>
												<label for="search">New Search</label>
												<span class="text"><input id="global-search-results-terms" class="txt" type="text" name="key" value="Search" /></span>
											</fieldset>
										</form>
									</li>
									<cfif params.action EQ "results">
									<li class="slide-block active">
										<a class="open-close" href="##">Categories</a>
										<div class="slide">
											<ul>
												<li><a href="<cfif doctorCount GT 0>#lcase(viewAllDoctorsURL)#<cfelse>/doctors</cfif>">Doctors</a> (#doctorCount#)</li>
												<li><a href="<cfif galleryCount GT 0>#lcase(viewAllGalleriesURL)#<cfelse>/pictures</cfif>">Before &amp; After Gallery</a> (#galleryCount#)</li>
												<li><a href="<cfif askADoctorCount GT 0>/search/askadoctor/#lcase(urlEncodedFormat(params.key))#<cfelse>/ask-a-doctor</cfif>">Ask A Doctor</a> (#askADoctorCount#)</li>
												<li><a href="<cfif guideCount GT 0>/search/guides/#lcase(urlEncodedFormat(params.key))#<cfelse>/resources/surgery</cfif>">Guides</a> (#guideCount#)</li>
												<li><a href="<cfif featuresAndArticlesCount GT 0>/search/features/#lcase(urlEncodedFormat(params.key))#<cfelse>/resources/articles</cfif>">Features &amp; Articles</a> (#featuresAndArticlesCount#)</li>
											</ul>
										</div>
									</li>
									</cfif>
								</ul>
							</div>
						</div>
						<div class="b">&nbsp;</div>
					</div>
					#includePartial("/shared/sponsoredlink")#
					<cfif displayAd IS TRUE>
						#includePartial(partial	= "/shared/ad",
										size	= "generic160x600#(explicitAd IS TRUE ? "Explicit" : "")#")#
					</cfif>
				</div>
			</div>
		</div>
	</div>
<cfif client.debug IS TRUE>#debugText#</cfif>
</cfoutput>