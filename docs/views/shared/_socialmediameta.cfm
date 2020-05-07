<cfparam name="og_title" default="">
<cfparam name="og_description" default="">
<cfparam name="og_type" default="">
<cfparam name="og_image" default="http#CGI.SERVER_PORT_SECURE?"s":""#://www.locateadoc.com/images/layout/locateadocfacebookicon.jpg">
<cfparam name="doNotIndex" default="false">
<cfif og_type eq "">
	<cfswitch expression="#params.controller#">
		<cfcase value="Profile">
			<cfset og_type = "doctor">
		</cfcase>
		<cfcase value="Resources">
			<cfset og_type = ListFindNoCase("authorsList,blog", params.action) ? "blog" : "article">
		</cfcase>
		<cfdefaultcase>
			<cfset og_type = params.controller>
		</cfdefaultcase>
	</cfswitch>
</cfif>
<cfoutput>
	<!--- Social media --->
	<cfif og_title neq ""><meta property="og:title" content="#og_title#">
	</cfif>
	<cfif og_description neq ""><meta property="og:description" content="#og_description#">
	</cfif>
	<cfif og_type neq ""><meta property="og:type" content="#og_type#"></cfif>
	<meta property="og:image" content="#og_image#">
	<cfif NOT doNotIndex>
		<cfif structKeyExists(url, "silourl") AND trim(url.silourl) NEQ "">
			<meta property="og:url" content="http#CGI.SERVER_PORT_SECURE?"s":""#://#CGI.SERVER_NAME##url.silourl#">
		<cfelse>
			<meta property="og:url" content="http#CGI.SERVER_PORT_SECURE?"s":""#://#CGI.SERVER_NAME##CGI.PATH_INFO##CGI.QUERY_STRING neq ""?"?#CGI.QUERY_STRING#":""#">
		</cfif>
	</cfif>
	<meta property="og:site_name" content="locateadoc.com">
	<meta property="fb:admins" content="100001968954969" />
	<meta property="fb:app_id" content="213900231968426">
</cfoutput>