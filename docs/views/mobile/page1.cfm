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
	<div id="page2" class="centered">
		<img src="/images/mobile/find_your_doctor.png">
		<div id="bottom-content-wrapper">
			<div id="bottom-content">
				<img src="/images/mobile/start-your-search.png" class="search-title">
				#includePartial(partial="mini_form",toDesktop=true)#
			</div>
		</div>
	</div>
</cfoutput>