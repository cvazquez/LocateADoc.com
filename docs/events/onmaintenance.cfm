<!--- Handling Client.Debug variable --->
<cfif isDefined('URL.Debug')>
	<cfset Client.Debug = (URL.Debug eq 1)?True:False>
<cfelseif not isDefined('Client.Debug')>
	<cfset Client.Debug = False>
</cfif>
<cfheader statuscode="503">
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<meta name="robots" content="noindex, nofollow">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Maintenance - LocateADoc.com</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script>
	<script src="/javascripts/main.js" type="text/javascript"></script>
	<link href="/stylesheets/all.css" media="all" rel="stylesheet" type="text/css" />
	<!--[if lt IE 8]><link href="/stylesheets/ie.css" media="all" rel="stylesheet" type="text/css" />
	<![endif]-->
</head>
<body>
<div id="wrapper">
	<div class="w1">
		<div class="w2">
			<div class="w3">
				<h1 class="logo"><a>LocateADoc.com | Finding Doctors. Empowering Patients.</a></h1>
				<a class="hidden">Skip to navigation</a>
				<div id="main" class="bg2">
					<div class="doctor-callout"> <strong>ARE YOU A DOCTOR?</strong> <span><a href="http://www.locateadoc.com/doctors_only/addadoc/index.cfm" target="_blank">SIGN UP TODAY</a></span> </div>
					<div class="pagetitle">
						<h2>find <span>your</span> doctor</h2>
						<strong class="subtitle">We have more than <em>150,000</em> doctors in over <em>40</em> specialties.</strong> </div>
					<div class="search-tabs"> <span class="search-title">start your search</span>
						<ul class="tabset">
							<li class="location"><a class="tab active"><strong><span>CHOOSE BY LOCATION</span></strong><em></em></a></li>
							<li class="procedure"><a class="tab"><strong><span>CHOOSE BY PROCEDURE</span></strong><em></em></a></li>
							<li class="specialty"><a class="tab"><strong><span>CHOOSE BY SPECIALTY</span></strong><em></em></a></li>
						</ul>
					</div>
					<div class="container">
						<div class="home-holder">
							<center><img src="/images/layout/imgMaintenance.png" style="margin-top:40px;"></center>
						</div>
					</div>
				</div>
				<div id="header">
				</div>
			</div>
			<div id="footer">
				<div class="footer">
					<div class="slide-block">
						<div class="title"> <a href="##" class="open-close"><span>Expand +</span><em>Collapse -</em></a> </div>
						<div class="nav-bar">
							<ul class="nav">
								<li>Home</li>
								<li>Find A Doctor</li>
								<li>Before and After Gallery</li>
								<li>Resources</li>
								<li>Financing</li>
							</ul>
						</div>
						<div class="block" style="display: none; ">
							<div class="holder">
								<div class="frame">
									<div class="text-box">
										<p>Content &copy; 1999-#Year(Now())# LocateADoc.com. All Rights Reserved.</p>
										<p>Design and Programming &copy; 1999-#Year(Now())# Mojo Interactive</p>
										<p>All of the information on LocateADoc.com, (except for information provided by members of the LocateADoc.com community), is either written by health professionals or supported by public health recommendations.</p>
									</div>
									<ul class="logos">
										<li><a><img src="/images/layout/logo3-footer.gif" width="48" height="48" alt="VeriSign Secure Site" /></a></li>
									</ul>
								</div>
								<!--- <div class="frame"> <strong class="everyday-health"><a>everyday HEALTH</a></strong>
									<p class="member">LocateADoc.com is a member of the Everyday Health&trade; network.</p>
								</div> --->
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<cfinclude template="/views/shared/_modeindicators.cfm">
</body>
</html>
</cfoutput>
<cfsetting showdebugoutput="no">