<cfoutput>
	#javascriptIncludeTag(sources="
		pictures/searchtab,
		filterresults,
		hashchange,
		utils",
		head=true)#

	<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
	<cfelse>
		#styleSheetLinkTag("/pictures/search")#
	</cfif>
	<script>
	var gallerybase = '#URLFor(controller="pictures")#';
	var doctorId = #params.key#;
	</script>

	<!-- content -->
	<div class="content profilegallery">
		<h1 style="margin-bottom:0;">
			#galleryHeader#
		</h1>
		<cfif topProcedureListWithFilters neq "">
			<p class="top-procedure-list">Some of our most popular procedures include: #topProcedureListWithFilters#</p>
		</cfif>
		<div class="baagtab slim">
			#galleryContent#
		</div>
<!--- 		<!-- image-list -->
		<center>
		<ul class="image-list">
			<li id="tour_link">
				<div class="image">
					<a href="##" class="tour_link" onclick="tourOpen(); return false;">
						<img src="/images/layout/img1-image-list.jpg" width="175" height="90" alt="Take the Office Tour" />
						<strong class="caption">Take the Office Tour</strong>
					</a>
				</div>
			</li>
			<cfif hasContactForm>
			<li>
				<div class="image">
					<a href="#URLFor(action='contact',key=params.key)#">
						<img src="/images/profile/img4-image-list.jpg" width="175" height="90" alt="Contact Us" />
						<strong class="caption">Contact Us</strong>
					</a>
				</div>
			</li>
			</cfif>
			<cfif staffInfo.recordCount>
			<li>
				<div class="image">
					<a href="#URLFor(action='staff',key=params.key)#">
						<img src="/images/layout/img3-image-list.jpg" width="175" height="90" alt="Meet Our Staff" />
						<strong class="caption">Meet Our Staff</strong>
					</a>
				</div>
			</li>
			</cfif>
		</ul>
		</center> --->
	</div>
	<div class="aside slim-aside">
		<cfoutput>
			<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
				#includePartial("/shared/minileadsidebox_mobile")#
			<cfelse>
				#includePartial("/shared/minileadsidebox")#
				#includePartial(partial="/shared/sharesidebox",margins="10px 0")#
			</cfif>
			#includePartial("/shared/paymentoptionssidebox")#
			#includePartial("/shared/specialofferssidebox")#
		</cfoutput>
	</div>
</cfoutput>