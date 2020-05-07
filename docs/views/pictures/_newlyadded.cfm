<html>
<head>
	<script type="text/javascript" src="/common/procedureselectdata"></script>
	<cfset styleSheetLinkTag(source="all", head=true)>
	<cfset javaScriptIncludeTag(source="#server.jquery.core#,#server.jquery.ui.core#,main", head=true)>
</head>
<body class="container" style="background:none;margin:0;padding:0;width:600px;height:315px;">
<cfoutput>
<!-- newly-pictures -->
<div class="newly-pictures">
	<div class="gallery">
		<div class="heading">
			<h3>Recently Added <strong>Pictures</strong></h3>
			<cfif topPictures.recordcount gt 2>
			<a href="##" class="link-prev">Previous</a>
			<ul class="switcher">
				<li class="active"><a href="##"><span>1</span></a></li>
				<li><a href="##"><span>2</span></a></li>
				<li><a href="##"><span>3</span></a></li>
				<li><a href="##"><span>4</span></a></li>
			</ul>
			<a href="##" class="link-next">Next</a>
			</cfif>
		</div>
		<div class="holder">
			<ul>
				<cfloop query="topPictures">
					<cfset fullName = "#topPictures.firstname# #Iif(topPictures.middlename neq '',DE(topPictures.middlename&' '),DE('')) & topPictures.lastname#">
					<cfif LCase(topPictures.title) eq "dr" or LCase(topPictures.title) eq "dr.">
						<cfset fullName = "Dr. #fullName#">
					<cfelseif topPictures.title neq "">
						<cfset fullName &= ", #topPictures.title#">
					</cfif>
					<cfif currentrow mod 2 eq 1>
					  <li>
						<div class="col1">
					<cfelse>
						<div class="col2">
					</cfif>
							<div class="images">
								<a href="/pictures/#topPictures.siloName#-c#topPictures.galleryCaseId#" target="_top"><img src="/pictures/gallery/#topPictures.siloName#-before-thumb-#galleryCaseId#-#galleryCaseAngleId#.jpg" width="133" height="107" alt="#topPictures.name# Before Picture" />
								<img src="/pictures/gallery/#topPictures.siloName#-after-thumb-#galleryCaseId#-#galleryCaseAngleId#.jpg" width="122" height="107" alt="#topPictures.name# After Picture" /></a>
								<span class="before">before</span>
								<span class="after">after</span>
							</div>
							<div class="description">
								<h4>#topPictures.name#</h4>
								<p>performed by <a href="/#topPictures.doctorSiloName#" target="_top">#fullName#</a></p>
								<strong class="more">#linkTo(href="/pictures/#topPictures.siloName#-c#topPictures.galleryCaseId#", target="_top", text="READ MORE")#</strong>
							</div>
						</div>
					<cfif (currentrow mod 2 eq 0) or (currentrow eq recordcount)>
					  </li>
					</cfif>
				</cfloop>
			</ul>
		</div>
		<cfif locationSilo neq "">
			<div class="foot">
				<a href="/pictures#locationSilo#" target="_top">view all galleries</a>
			</div>
		</cfif>
	</div>
</div>
</cfoutput>
</body>
</html>