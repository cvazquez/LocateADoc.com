<cfset javaScriptIncludeTag(source="doctors.searchforms", head=true)>

	<div id="main" class="bg3">
<cfoutput>
	<cfif not isMobile>
		#includePartial("/shared/doctorcallout")#
	</cfif>
		<div class="search-types">
			<div class="holder">
				<cfif not isMobile>
					#includePartial("/shared/breadcrumbs")#
				</cfif>
					#includePartial("/shared/pagetitle")#

				#includePartial("doctorsearch")#
			</div>
		</div>
		<div class="container">
			<cfif not isMobile>
			<div class="twocolumns">
				<div class="content">
					<iframe id="featuredframe" src="/doctors/featured" style="width:600px;height:491px;border:0;margin:0;padding:0;overflow-x:hidden;overflow-y:hidden;" scrolling="no"></iframe>
				</div>
				<div class="aside">
					<div class="sidebox">
						#includePartial("/shared/resourceguides")#
					</div>
					#includePartial(partial	= "/shared/ad",
									size	= "generic300x250")#
				</div>
			</div>
			</cfif>
</cfoutput>
		<noscript>
			<div style="height:200px; width:650px; overflow-y:scroll; background: url('/images/layout/bg-hor-blue.gif') no-repeat scroll 0 100% transparent;">
				<h2>Doctors by Procedure</h2>
				<ul>
				<cfloop query="Procedures">
					<cfoutput><li>#LinkTo(controller="doctors", action=Procedures.siloName, text=Procedures.name)#</li></cfoutput>
				</cfloop>
				</ul>
				<h2>Doctors by Body Part - Women</h2>
				<cfoutput query="bodyParts" group="bodyRegionId">
					<h3>#bodyRegionName#</h3>
					<ul>
						<cfoutput>
							<li><a href="/doctors/female/#bodyParts.siloName#">#bodyPartName#</a></li>
						</cfoutput>
					</ul>
				</cfoutput>
				<h2>Doctors by Body Part - Men</h2>
				<cfoutput query="bodyParts" group="bodyRegionId">
					<h3>#bodyRegionName#</h3>
					<ul>
						<cfoutput>
							<li><a href="/doctors/male/#bodyParts.siloName#">#bodyPartName#</a></li>
						</cfoutput>
					</ul>
				</cfoutput>
			</div>
		</noscript>
<cfoutput>
	<cfif not isMobile>
			<div class="search-content-holder">
				<h3>Find a <strong>Local Doctor</strong></h3>
				<div class="search-content">
					<p><b>Find a local doctor</b> with the experience, and specialization you need on LocateADoc.com. Take advantage of our vast resources by filtering your search results by procedure, body part, and location.  Don't waste time or money scheduling appointments with unqualified doctors any longer!</p>
					<p>Regardless of the injury, ailment, or disease you're looking to remedy, you want to be in the care of a doctor with experience. With LocateADoc.com, you can review hundreds of doctors, <b>filtering by location and distance</b>, and you can review how many years of experience they have performing your specific procedure. If that information is not readily available, you can easily give them a call knowing exactly what questions you need to ask.</p>
					<p>Quality, cannot be quantified. To ensure the best quality of care, read through the physicians' review section to see what patients have experienced in the past.   With the rapid advances in medical science, it has become increasingly important to see a specialized doctor. Whatever your procedure may be, save yourself time and money by finding out as much <b>information about your local doctors</b> before making an appointment.</p>
					<p>Lastly, whether you're interested in plastic surgery or #LinkTo(controller="doctors",action="cosmetic-dentistry",text="cosmetic dentistry")#, it's also important that you <b>find a local doctor who fits your medical needs</b>. While getting recommendations from friends or relatives is a great way to find a local doctor, don't stop your search there. Let LocateADoc.com be your one-stop #LinkTo(controller="resources",text="research resource")#. Because when it comes to your health, you can never be too careful.</p>
				</div>
			</div>
			<div class="vertical-block-holder">
				#includePartial(partial="/shared/sitewideminileadsidebox",smallBlock=true)#
				#includePartial("/shared/caniaffordit")#
			</div>
			#includePartial("topmarkets")#
	<cfelseif isMobile>
		<div class="swm mobileWidget">
			<h2>Contact A Doctor</h2>
			#includePartial(partial="/mobile/mini_form",toDesktop=false)#
		</div>
	</cfif>
		</div>
	</div>
</cfoutput>