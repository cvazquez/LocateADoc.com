<cfset javaScriptIncludeTag(source="doctors.searchforms", head=true)>
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
</cfoutput>