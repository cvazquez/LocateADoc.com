<!--- Place code here that should be executed on the "onRequestStart" event. --->
<cfparam name="REQUEST.WHEELS.DEPRECATION" default="#[]#"><!--- This is to fix a weird error in Wheels --->
<cfparam default="" name="client.postalCode">
<cfparam default="" name="client.LastVisitCheck">


<!--- Generate current URL --->
<cfset rootURL = "http#(CGI.SERVER_PORT_SECURE)?"s":""#://#CGI.SERVER_NAME#">
<cfset myQueryString = CGI.QUERY_STRING neq "" ? "?#CGI.QUERY_STRING#" : "">
<cfset siloUrlStr = reMatch("silourl=.+", CGI.QUERY_STRING)>
<cfif arrayLen(siloUrlStr)>
	<cfset Request.currentURL = "#rootURL##ListRest(siloUrlStr[1], "=")#">
<cfelseif CGI.PATH_INFO neq "">
	<cfset Request.currentURL = "#rootURL##CGI.PATH_INFO##myQueryString#">
<cfelse>
	<cfset Request.currentURL = "#rootURL##CGI.SCRIPT_NAME##CGI.PATH_INFO##myQueryString#">
</cfif>
<cfif structKeyExists(URL, "silourl")>
	<cfset Request.additionalIndicatorList = "Current URL: #Request.currentURL# [Rewrite]">
<cfelse>
	<cfset Request.additionalIndicatorList = "Current URL: #Request.currentURL#">
</cfif>

<!--- Client trail for error debugging --->
<cfparam name="Client.URLHistory_5" default="">
<cfparam name="Client.URLHistory_4" default="">
<cfparam name="Client.URLHistory_3" default="">
<cfparam name="Client.URLHistory_2" default="">
<cfparam name="Client.URLHistory_1" default="">
<cfset Client.URLHistory_5 = Client.URLHistory_4>
<cfset Client.URLHistory_4 = Client.URLHistory_3>
<cfset Client.URLHistory_3 = Client.URLHistory_2>
<cfset Client.URLHistory_2 = Client.URLHistory_1>
<cfset Client.URLHistory_1 = "(#DateFormat(now(),'yyyy-mm-dd')# #TimeFormat(now(),'HH:mm:ss.L')#) #CGI.HTTP_REFERER# => #Request.currentURL#">

<!--- Handling Client.Debug variable --->
<cfset Client.Debug = (structKeyExists(URL, 'Debug'))?((URL.Debug eq 1)?True:False):(structKeyExists(Client, 'Debug')?Client.Debug:False)>

<!--- User management --->
<cfset Request.oUser = createObject("component","LocateADocModules#Application.SharedModulesSuffix#.com.locateadoc.user")>
<cfset Request.oUser.init(model("user"))>

<cfif IsDefined("url.ForceAppInit")>
	<cfif url.ForceAppInit EQ "redesign">
		<!--- /?ForceAppinit=redesign --->
		<cfset ApplicationStop()>
		<cflocation url="#CGI.PATH_INFO#" addtoken="false">
	</cfif>
</cfif>

<!--- Clickover --->
<cfset Request.oClickOver = createObject("component", "LocateADocModules#Application.SharedModulesSuffix#.com.locateadoc.clickover")>

<cfif not isDefined("Client.IsSpider")>
	<cfmodule template="/LocateADocModules#Application.SharedModulesSuffix#/SpiderFilter.cfm" ReturnVariable="Client.IsSpider">
</cfif>

<!--- Mobile Site --->
<cfset Client.forcemobile = (structKeyExists(URL, 'forcemobile'))?((URL.forcemobile eq 1)?True:False):(structKeyExists(Client, 'forcemobile')?Client.forcemobile:False)>
<cfset Client.skipmobile = (structKeyExists(URL, 'skipmobile'))?((URL.skipmobile eq 1)?True:False):(structKeyExists(Client, 'skipmobile')?Client.skipmobile:False)>
<cfset Client.desktop = (structKeyExists(URL, 'desktop'))?((URL.desktop eq 1)?True:False):(structKeyExists(Client, 'desktop')?Client.desktop:False)>
<cfinvoke component="LocateADocModules#Application.SharedModulesSuffix#.com.util.regexp" method="isMobileBrowser" returnvariable="Request.isMobileBrowser">

<!--- <cfdump var="#Client.forcemobile#"><br />
<cfdump var="#Client.skipmobile#"><br />
<cfdump var="#Client.desktop#"><br />
<cfdump var="#Request.isMobileBrowser#"><br />
<cfabort> --->

<!--- Set this to true inside a controller to force the rewrite
	  function to use the mobile layout for the current action	--->
<cfset Request.mobileLayout = false>

<cfif Request.isMobileBrowser>

	<!--- <cfoutput>
		now() = #now()#<br />
		Client.LastVisitCheck = #Client.LastVisitCheck#<br />
		dateDiff("h", now(), client.LastVisitCheck) = #dateDiff("h", now(), client.LastVisitCheck)#<br />

		<cfdump var="#client#">
	</cfoutput>
	<cfabort> --->

	<cfparam default="#now()#" name="client.LastVisitCheck">
	<cfif isDate(client.LastVisitCheck) AND dateDiff("h", client.LastVisitCheck, now()) GT 24>
		<cfparam default="FALSE" name="url.skipmobile" type="boolean">
		<cfparam default="FALSE" name="url.desktop" type="boolean">
		<cfif url.skipmobile IS FALSE AND url.desktop IS FALSE>
			<!--- After 24 hours, force back to a mobile browser, as long as the user to explicitly say to skip mobile and set to desktop. This is to override any client variables that say to skip the mobile site --->

			<cfset client.skipmobile = FALSE>
			<cfset client.desktop = FALSE>

			<!--- <cfoutput>HELLO</cfoutput>
			<cfabort> --->
		</cfif>
	</cfif>

	<cfset client.LastVisitCheck = now()>
</cfif>




<cftry>
	<cfif not structKeyExists(URL,"rewrite")>
		<!--- Recognize 2.0 URLs --->
		<cfset oldURL = "http#CGI.SERVER_PORT_SECURE ? "s" : ""#://#CGI.SERVER_NAME##CGI.PATH_INFO##CGI.QUERY_STRING neq "" ? "?#CGI.QUERY_STRING#" : ""#">
		<!--- <cfset oldURL = "http#CGI.SERVER_PORT_SECURE ? "s" : ""#://www.locateadoc.com#CGI.PATH_INFO##CGI.QUERY_STRING neq "" ? "?#CGI.QUERY_STRING#" : ""#"> --->
		<cfset newURL = trim(Request.oClickOver.getClickOverURL(originalURL=oldURL, modelAccountDoctorLocation=model("accountDoctorLocation")))>
		<cfif newURL neq "" and Left(newURL,1) neq "?">
			<cflocation url="http://#CGI.SERVER_NAME##newURL#" addtoken="no" statuscode="301">
		</cfif>

		<!--- 3.0 URL Structure 301 Redirects --->
		<cfset URLcontroller = "">
		<cfset URLaction = "">
		<cfset URLkey = "">
		<cfset URLparams = "">
		<cfif ListLen(CGI.PATH_INFO,"/") gt 0>
			<cfset URLcontroller = ListFirst(CGI.PATH_INFO,"/")>
		</cfif>
		<cfif ListLen(CGI.PATH_INFO,"/") gt 1>
			<cfset URLaction = ListGetAt(CGI.PATH_INFO,2,"/")>
		</cfif>
		<cfif ListLen(CGI.PATH_INFO,"/") gt 2>
			<cfset URLkey = ListGetAt(CGI.PATH_INFO,3,"/")>
		</cfif>
		<cfif ListLen(CGI.PATH_INFO,"/") gt 3>
			<cfset URLparams = ListRest(ListRest(ListRest(CGI.PATH_INFO,"/"),"/"),"/")>
		</cfif>

		<cfswitch expression="#URLcontroller#">
			<cfcase value="profile">
				<cfset skipActionList = "printcoupon,checkPrint,setlocation,submitcouponlead">
				<cfif not ListFind(skipActionList, URLaction)>
					<cfswitch expression="#URLaction#">
						<cfcase value="welcome">
							<cfset URLaction = "">
						</cfcase>
						<cfcase value="case">
							<cfset tempURLkey = URLparams>
							<cfset URLparams = URLkey>
							<cfset URLkey = tempURLkey>
						</cfcase>
						<cfcase value="gallery">
							<cfset URLaction = "pictures">
						</cfcase>
						<cfcase value="doctor">
							<cfset URLaction = "about">
						</cfcase>
					</cfswitch>

					<cfif not Server.isInteger(URLkey)>
						<cflocation statuscode="301" url="/doctors" addtoken="no">
					</cfif>
					<cfset doctorSilo = model("accountDoctorSiloName").findAllByAccountDoctorId(value=URLkey, where="isActive=1", select="siloName")>
					<cfif not doctorSilo.recordCount>
						<cfset dumpStruct = {doctorSilo=doctorSilo}>
						<cfset fnCthulhuException(	scriptName="onrequeststart.cfm",
													message="Couldn't find active silo name for doctor (id: #URLkey#).",
													detail="Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn!",
													dumpStruct=dumpStruct,
													redirectURL="/doctors"
													)>
					</cfif>
					<cfif URLaction eq "case" and Server.isInteger(URLparams)>
						<cfset URLaction = "pictures">
						<cfset caseProcedureSilo = model("galleryCaseProcedure").findAll(
													include="procedure, galleryCase(galleryCaseDoctors)",
													select="siloName",
													where="galleryCaseId = #URLparams# AND gallerycaseprocedures.isPrimary = 1 AND accountDoctorId = #URLkey#"
													)>
						<cfif caseProcedureSilo.recordCount>
							<cfset URLaction &= "/#caseProcedureSilo.siloName#-c#URLparams#">
							<cfset URLparams = "">
						<cfelse>
							<cfset dumpStruct = {caseProcedureSilo=caseProcedureSilo}>
							<cfset fnCthulhuException(	scriptName="onrequeststart.cfm",
														message="Can't find a procedure silo name for the gallery case (id: #URLparams#) for this doctor (id: #URLkey#).",
														detail="Seriously?",
														dumpStruct=dumpStruct,
														redirectURL="/#doctorSilo.siloName#/pictures"
														)>
						</cfif>
					</cfif>
					<cflocation url="/#doctorSilo.siloName##URLaction neq ""?"/#URLaction#":""##URLparams neq ""?"/#URLparams#":""##CGI.QUERY_STRING neq ""?"?#CGI.QUERY_STRING#":""#" addtoken="no" statuscode="301">
				</cfif>
			</cfcase>
			<cfcase value="resources">
				<cfswitch expression="#URLaction#">
					<cfcase value="specialty">
						<cfset specialtySilo = model("specialty").findByKey(key=URLkey, select="siloName")>
						<cfif isObject(specialtySilo)>
							<cfset URLaction &= specialtySilo.siloName>
							<cflocation statuscode="301" url="/#specialtySilo.siloName##CGI.QUERY_STRING neq ""?"?#CGI.QUERY_STRING#":""#" addtoken="no">
						</cfif>
					</cfcase>
					<cfcase value="procedure">
						<cfset procedureSilo = model("procedure").findByKey(key=URLkey, select="siloName")>
						<cfif isObject(procedureSilo)>
							<cfset URLaction &= procedureSilo.siloName>
							<cflocation statuscode="301" url="/#procedureSilo.siloName##CGI.QUERY_STRING neq ""?"?#CGI.QUERY_STRING#":""#" addtoken="no">
						</cfif>
					</cfcase>
					<cfcase value="guide">
						<cfif not FindNoCase("preview=true",CGI.QUERY_STRING)>
							<cfset guidePage = model("resourceGuideSiloName")
												.findOneByResourceGuideId(
													value=URLkey,
													include="resourceGuide",
													where="isActive = 1",
													select="resourceguidesilonames.siloName, resourceguides.id as ResourceGuideId"
													)>
							<cfif isObject(guidePage)>
								<cfset guideProcedure = model("resourceGuideSubProcedure")
													.findOne(
														include="procedure",
														where="resourceGuideId = #guidePage.ResourceGuideId#",
														select="siloName"
														)>
								<cfif isObject(guideProcedure)>
									<cflocation url="/#guideProcedure.procedure.siloName#/#guidePage.siloName#" addtoken="no" statuscode="301">
								</cfif>
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="video">
						<cfset reMatchSpecialty = ReMatchNoCase("specialty-[0-9]+",URLkey)>
						<cfif arrayLen(reMatchSpecialty) neq 0>
							<cfset specialtySilo = model("Specialty").findByKey(key=ListLast(reMatchSpecialty[1],"-"), select="siloName")>
							<cfif isObject(specialtySilo)>
								<cflocation url="/resources/video/#specialtySilo.siloName##URLparams#" addtoken="no" statuscode="301">
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="articles">
						<cfif URLkey neq "" and URLkey does not contain "show-all" and not arrayLen(reMatch("tag-[ a-z-]+",URLkey))>
							<cfset pageSilo = "">
							<cfset reMatchPage = ReMatchNoCase("page-[0-9]+",URLparams)>
							<cfif arrayLen(reMatchPage) gt 0>
								<cfset pageSilo = ListLast(reMatchPage, "-")>
							</cfif>
							<cfset reMatchSpecialty = ReMatchNoCase("specialty-[0-9]+",URLkey)>
							<cfif arrayLen(reMatchSpecialty) neq 0>
								<cfset specialtySilo = model("Specialty").findByKey(key=ListLast(reMatchSpecialty[1],"-"), select="siloName")>
								<cfif isObject(specialtySilo)>
									<cflocation url="/articles/#specialtySilo.siloName##pageSilo neq "" and Server.isInteger(pageSilo[1])?"/#pageSilo[1]#":""#" addtoken="no" statuscode="301">
								</cfif>
							</cfif>
							<cfset reMatchProcedure = ReMatchNoCase("procedure-[0-9]+",URLkey)>
							<cfif arrayLen(reMatchProcedure) neq 0>
								<cfset procedureSilo = model("Procedure").findByKey(key=ListLast(reMatchProcedure[1],"-"), select="siloName")>
								<cfif isObject(procedureSilo)>
									<cflocation url="/articles/#procedureSilo.siloName##pageSilo neq "" and Server.isInteger(pageSilo[1])?"/#pageSilo[1]#":""#" addtoken="no" statuscode="301">
								</cfif>
							</cfif>
						</cfif>
						<cflocation url="/articles#URLkey neq ""?"/#URLkey#":""#" addtoken="no" statuscode="301">
					</cfcase>
					<cfcase value="article">
						<cfif not FindNoCase("preview=true",CGI.QUERY_STRING)>
							<cfset articleSilo = model("resourceArticleSiloName")
												.findOneByresourceArticleId(
													value=URLkey,
													where="isActive = 1",
													select="siloName"
													)>
							<cfif isObject(articleSilo)>
								<cflocation url="/article/#articleSilo.siloName#" addtoken="no" statuscode="301">
							<cfelse>
								<cflocation url="/articles" addtoken="no" statuscode="301">
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="blog">
						<cfif val(URLkey) GT 0>
							<cfquery datasource="wordpressLB" name="blogSilo">
								SELECT concat(CONVERT(DATE_FORMAT(p.post_date,"%Y/%m/%d/") USING utf8), myLocateadoc3.CreateSiloNameWithDash(p.post_title)) as siloName
								FROM lad_posts p
								WHERE p.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(URLkey)#">
									AND p.post_type = 'post' AND p.post_status = 'publish'
							</cfquery>
						<cfelse>
							<cfset blogSilo = QueryNew("")>
						</cfif>
						<cfif blogSilo.recordCount>
							<cflocation url="/blog/#blogSilo.siloName#" addtoken="no" statuscode="301">
						<cfelse>
							<cflocation url="/blog" addtoken="no" statuscode="301">
						</cfif>
					</cfcase>
				</cfswitch>
			</cfcase>
			<cfcase value="pictures">
				<cfswitch expression="#URLaction#">
					<cfcase value="case">
						<cfif Server.isInteger(URLkey)>
							<cfset procedureSilo = model("galleryCaseProcedure").findAll(include="procedure, galleryCase(galleryCaseDoctors)", select="siloName", where="galleryCaseId = #URLkey# AND gallerycaseprocedures.isPrimary = 1")>
							<cfif procedureSilo.recordCount>
								<cflocation url="/pictures/#procedureSilo.siloName#-c#URLkey#" addtoken="no" statuscode="301">
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="search">
						<cfset URLparams = "/#URLkey##URLparams neq "" ? "/#URLparams#" : ""#">
						<cfset procedureSilo = "">
						<cfset genderSilo = "">
						<cfset locationSilo = "">
						<cfset bodyPartSilo = "">
						<cfloop list="#URLparams#" delimiters="/" index="currentFilter">
							<cfset currentKey = ListFirst(currentFilter,"-")>
							<cfset currentValue = ListLast(currentFilter, "-")>
							<cfif currentValue neq 0>
								<cfif currentKey eq "gender">
									<cfset genderSilo = model("galleryGender").findByKey(key=val(currentValue), select="name")>
								</cfif>
								<cfif currentKey eq "bodypart">
									<cfset bodyPartSilo = model("bodyPart").findByKey(key=val(currentValue), select="siloName")>
								</cfif>
								<cfif currentKey eq "procedure">
									<cfset procedureSilo = model("procedure").findByKey(key=val(currentValue), select="siloName")>
								</cfif>
								<cfif currentKey eq "location">
									<cfset locationSilo = "/" & ReReplace(Trim(LCase(currentValue)),"[^a-z]+","-","all")>
								</cfif>
							</cfif>
						</cfloop>
						<cfif isDefined("procedureSilo") and isObject(procedureSilo)>
							<cfset locationURL = "">
							<cfset URLparams = ReReplaceNoCase(URLparams, "/procedure-[0-9]+", "", "all")>
							<!--- Check location --->
							<cfif isDefined("locationSilo") and locationSilo neq "" and fnIsSiloLocation(locationSilo)>
								<cfset URLparams = ReReplaceNoCase(URLparams, "/location-[^/]+", "", "all")>
								<cfset locationURL = locationSilo>
							</cfif>
							<cflocation url="/pictures/#LCase(procedureSilo.siloName)##locationURL##URLparams neq "" ? "#URLparams#" : ""#" addtoken="no" statuscode="301">
						<cfelseif isDefined("genderSilo") and isObject(genderSilo) and isDefined("bodyPartSilo") and isObject(bodyPartSilo)>
							<cfset URLparams = ReReplaceNoCase(URLparams, "/gender-[0-9]", "", "all")>
							<cfset URLparams = ReReplaceNoCase(URLparams, "/bodypart-[0-9]+", "", "all")>
							<cflocation url="/pictures/#LCase(genderSilo.name)#/#bodyPartSilo.siloName##URLparams neq "" ? "#URLparams#" : ""#" addtoken="no" statuscode="301">
						<cfelseif URLparams neq "">
							<cflocation url="/pictures#URLparams#" addtoken="no" statuscode="301">
						</cfif>
					</cfcase>
				</cfswitch>
			</cfcase>
			<cfcase value="doctors">
				<cfif URLaction eq "search">
					<cfset URLparams = "/#URLkey##URLparams neq "" ? "/#URLparams#" : ""#">
					<cfset procedureSilo = "">
					<cfset specialtySilo = "">
					<cfset locationSilo = "">
					<cfset bodyPartSilo = "">
					<cfloop list="#URLparams#" delimiters="/" index="currentFilter">
						<cfset currentKey = ListFirst(currentFilter,"-")>
						<cfset currentValue = ListLast(currentFilter, "-")>
						<cfif currentValue neq 0>
							<cfif currentKey eq "procedure">
								<cfset procedureSilo = model("procedure").findByKey(key=currentValue, select="siloName")>
							</cfif>
							<cfif currentKey eq "specialty">
								<cfset specialtySilo = model("specialty").findByKey(key=currentValue, select="siloName")>
							</cfif>
							<cfif currentKey eq "bodypart">
								<cfset bodyPartSilo = model("bodyPart").findByKey(key=currentValue, select="siloName")>
							</cfif>
							<cfif currentKey eq "location">
								<cfset locationSilo = "/" & ReReplace(Trim(LCase(currentValue)),"[^a-z]+","-","all")>
							</cfif>
						</cfif>
					</cfloop>
					<cfif isDefined("procedureSilo") and isObject(procedureSilo)>
						<cfset locationURL = "">
						<cfset URLparams = ReReplaceNoCase(URLparams, "/procedure-[0-9]+", "", "all")>
						<!--- Check location --->
						<cfif isDefined("locationSilo") and locationSilo neq "" and fnIsSiloLocation(locationSilo)>
							<cfset URLparams = ReReplaceNoCase(URLparams, "/location-[^/]+", "", "all")>
							<cfset locationURL = locationSilo>
						</cfif>
						<cflocation url="/doctors/#LCase(procedureSilo.siloName)##locationURL##URLparams neq "" ? "#URLparams#" : ""#" addtoken="no" statuscode="301">
					<cfelseif isDefined("specialtySilo") and isObject(specialtySilo)>
						<cfset locationURL = "">
						<cfset URLparams = ReReplaceNoCase(URLparams, "/specialty-[0-9]+", "", "all")>
						<!--- Check location --->
						<cfif isDefined("locationSilo") and locationSilo neq "" and fnIsSiloLocation(locationSilo)>
							<cfset URLparams = ReReplaceNoCase(URLparams, "/location-[^/]+", "", "all")>
							<cfset locationURL = locationSilo>
						</cfif>
						<cflocation url="/doctors/#LCase(specialtySilo.siloName)##locationURL##URLparams neq "" ? "#URLparams#" : ""#" addtoken="no" statuscode="301">
					<cfelseif isDefined("bodyPartSilo") and isObject(bodyPartSilo)>
						<cfset URLparams = ReReplaceNoCase(URLparams, "/bodypart-[0-9]+", "", "all")>
						<cflocation url="/doctors/#bodyPartSilo.siloName##URLparams neq "" ? "#URLparams#" : ""#" addtoken="no" statuscode="301">
					<cfelseif URLparams neq "">
						<cflocation url="/doctors#URLparams#" addtoken="no" statuscode="301">
					</cfif>
				</cfif>
			</cfcase>
			<cfcase value="doctor-marketing">
				<cfif URLaction eq "article">
					<cfif not FindNoCase("preview=true",CGI.QUERY_STRING)>
						<cfset articleSilo = model("resourceArticleSiloName")
											.findOneByresourceArticleId(
												value=URLkey,
												where="isActive = 1",
												select="siloName"
												)>
						<cfif isObject(articleSilo)>
							<cflocation url="/doctor-marketing/#articleSilo.siloName#" addtoken="no" statuscode="301">
						<cfelse>
							<cflocation url="/doctor-marketing/articles" addtoken="no" statuscode="301">
						</cfif>
					</cfif>
				</cfif>
			</cfcase>
		</cfswitch>
	</cfif>
	<cfcatch>
		<cfif not isDefined("errorDump") or not isCustomFunction("errorDump")>
			<cfinclude template="/LocateADocModules#Application.sharedModulesSuffix#/_exception.cfm">
		</cfif>
		<cfif not isDefined("identifySpider") or not isCustomFunction("identifySpider")>
			<cfinclude template="/LocateADocModules#Application.sharedModulesSuffix#/_identifySpider.cfm">
		</cfif>

		<!--- Record new error in DB --->
		<cfset errorCode = 503>
		<cfif cfcatch.message contains "The request has exceeded the allowable time limit">
			<cfset errorCode = 408>
		</cfif>
		<cfset errorURL = "http#CGI.HTTPS eq "on" ? "s" : ""#://#CGI.HTTP_HOST##CGI.SCRIPT_NAME neq "/rewrite.cfm" ? CGI.SCRIPT_NAME : ""##CGI.PATH_INFO##CGI.QUERY_STRING neq "" ? "?#CGI.QUERY_STRING#" : ""#">
		<cfquery datasource="myLocateadocEdits">
			INSERT DELAYED INTO servererrors
			SET	errorMessage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfcatch.message#">,
				errorCode = "#errorCode#",
				url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#errorURL#">,
				server = "#Server.ThisServer#",
				scriptName = "/events/onrequeststart.cfm",
				ipAddress = "#CGI.REMOTE_ADDR#",
				userAgent = "#CGI.HTTP_USER_AGENT#",
				isSpider = "#Client.isSpider#",
				spiderName = "#identifySpider(CGI.HTTP_USER_AGENT)#",
				referrer = "#CGI.HTTP_REFERER#",
				cfId = "#Client.CFID#",
				cfToken = "#Client.CFToken#",
				userAction = "User was presented with the 'raw' exception page.",
				createdAt = now()
		</cfquery>

		<cfif Server.ThisServer eq "dev" or Client.debug>
			<cfcontent reset="yes">
			<cfoutput><h1>Exception in onrequeststart.cfm</h1></cfoutput>
			<cfdump var="#cfcatch#">
		<cfelse>
			<!--- Send error email --->
			<cfset emailAddress = "lad3_errors@locateadoc.com">
			<cfset errorDump(
								showOutput=false,
								sendEmail=true,
								fromEmail=emailAddress,
								toEmail=emailAddress,
								subject="Uncaught Exception: #cfcatch.message#",
								message="This error was generated in /events/onrequeststart.cfm",
								QueriesScope=true
								)>
			<cfinclude template="/views/common/_raw_exception.cfm">
		</cfif>
	</cfcatch>
</cftry>