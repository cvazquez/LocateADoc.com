<cfparam name="params.firstname" default="">
<cfparam name="params.lastname" default="">
<cfparam name="params.name" default="">
<cfparam name="params.email" default="">
<cfparam name="params.zip" default="">
<cfparam name="params.phone" default="">

<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1>
	<cfset params = Request.oUser.appendUserInfo(params)>
	<cfif params.firstname neq "" and params.lastname neq "">
		<cfset params.name = "#params.firstname# #params.lastname#">
	</cfif>
</cfif>


<cfoutput>
	<div id="MobileHomePage" class="centered SectionHome">
		<img src="/images/mobile/find_your_doctor.png">
		<div id="bottom-content-wrapper" style="margin-top:0px; min-height:265px;">
			<div id="bottom-content">
				<h1 style="padding:10px 0;">Welcome...<!---  to the Mobile LocateADoc.com ---></h1>
				<p>LocateADoc.com is the premier online physician directory connecting you with local doctors you choose in your area.<br /><br />
				<!--- Search for a doctor in your area: --->
				Ready to search for a doctor in your area?</p>
				<!--- <a href="/mobile/page1?t=#Client.mobile_entry_page#" class="button" onclick="validate(); return false;">Find a Doctor</a>
				<div style="text-align:center;"><a href="#Client.mobile_entry_page##(Client.mobile_entry_page contains "?")?"&":"?"#desktop=1" style="font-size:16px!important;">No thanks, continue to site</a></div> --->


					<div class="centered search-box">
						<div>
							<div id="bottom-content">
								<img src="/images/mobile/start-your-search.png" class="search-title">
								#includePartial(partial="/mobile/mini_form",toDesktop=true)#
							</div>
						</div>
					</div>

					<div class="home-holder">
						<div class="mobileWidget">
							#includePartial("/askadoctor/latestquestionshome_mobile")#
						</div>
						<div style="clear: both;"></div>
						<div class="mobileWidget">
							#includePartial("/shared/blogs_mobile")#
						</div>
						<cfif latestPictures.recordCount GT 0>
							<div class="mobileWidget">
								#includePartial("/shared/beforeandaftersidebox")#
							</div>
						</cfif>
					</div>

			</div>
		</div>
	</div>
</cfoutput>




<!--- <cfset javaScriptIncludeTag(source="doctors.searchforms", head=true)>
<cfoutput>
	<div id="main" class="bg2">
		#includePartial("/shared/doctorcallout")#
		#includePartial("/shared/pagetitle")#
		#includePartial("/shared/searchbar")#
		<div class="container below-search-bar">
			<div class="home-holder">
				#includePartial("/askadoctor/latestquestionshome")#
				#includePartial("/shared/blogs")#
				#includePartial("/shared/beforeandafter")#
			</div>

			<div class="home-content-holder">
				<h3>Welcome to <strong>LocateADoc.com</strong></h3>
				<div class="home-content">
					#welcomeContent.content#
				</div>
			</div>
			<div class="vertical-block-holder">
				#includePartial("/shared/resourceshome")#
			</div>

			<div class="blocks-holder stretched-block-holder">
				<div style="float: left; width: 300px; padding-left: 25px;">
					#includePartial("/shared/areyouadoctor")#
					#includePartial("/shared/caniaffordit")#
				</div>
				#includePartial("/shared/topguides")#
				#includePartial("/shared/toppictures")#
			</div>
			<div class="blocks-holder">
				#includePartial("/shared/populararticles")#
			</div>
			<center>
			Find <a href="https://plus.google.com/103192838916738467784" rel="publisher">LocateADoc.com on Google+</a>
			</center>
		</div>
	</div>
</cfoutput> --->