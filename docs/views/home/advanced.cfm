<cfset javaScriptIncludeTag(source="doctors.searchforms", head=true)>
<cfoutput>
	<div id="main" class="bg2">
		#includePartial("/shared/doctorcallout")#
		#includePartial("/shared/pagetitle")#
		#includePartial("/shared/searchtabs")#
		<div class="container">
			<div class="home-holder">
				#includePartial("/shared/beforeandafter")#
				#includePartial("/shared/resources")#
				#includePartial(partial	= "/shared/ad",
								size	= "home300x250")#
				<!--- Uncomment below to add content to home page --->
				<!--- <div class="content">
					Home
				</div> --->
			</div>
			<div class="blocks-holder">
				#includePartial("/shared/joinourcommunity")#
				#includePartial("/shared/celebritysoundbytes")#
				#includePartial("/shared/caniaffordit")#
			</div>
		</div>
	</div>
</cfoutput>