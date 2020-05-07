<cfcomponent extends="Controller" output="false">

<cffunction name="init">
	<cfset filters(through="initalize")>
</cffunction>

<cffunction name="initalize" access="private">
	<cfset styleSheetLinkTag(sources="tests", head="true")>
</cffunction>

<cffunction name="profile">
	<cfset h1Text = "Profile Tests">

	<cfif isdefined("params.key")>
		<cfswitch expression="#params.key#">
			<cfcase value="advertisers">
				<cfset h1Text = "Advertisers">
				<cfset listings = model("Tests").advertisers()>
			</cfcase>
			<cfcase value="pastadvertisers">
				<cfset h1Text = "Past Advertisers">
				<cfset listings = model("Tests").pastadvertisers()>
			</cfcase>
			<cfcase value="basicplus">
				<cfset h1Text = "Basic Plus">
				<cfset listings = model("Tests").basicplus()>
			</cfcase>
			<cfcase value="basic">
				<cfset h1Text = "Basic">
				<cfset listings = model("Tests").basic()>
			</cfcase>
			<cfcase value="yext">
				<cfset h1Text = "Yext">
				<cfset listings = model("Tests").yext()>
			</cfcase>
		</cfswitch>
	</cfif>
</cffunction>

<cffunction name="pictures">
	<cfset h1Text = "Gallery Tests">
	<cfif isdefined("params.key")>
		<cfswitch expression="#params.key#">
			<cfcase value="docsWithOrigPhoto">
				<cfset h1Text = "Doctor's With Original Photos">
				<cfset docsWithOrigPhoto()>
			</cfcase>
		</cfswitch>
	</cfif>
</cffunction>

<cffunction name="docsWithOrigPhoto">
	<cfsetting requesttimeout="18000">
	<cfquery datasource="myLocateadocLB3" name="docs">
	SELECT id,photoFilename FROM accountdoctors
	WHERE photoFilename IS NOT NULL
	AND photoFilename <> ''
	</cfquery>

	<cfset origfound= 0>
	<cfset regfound = 0>
	<cfset LAD2path	= "/export/home/locateadoc.com/docs/images/doctor/photos">
	<cfset LAD3path	= "/export/home/dev3.locateadoc.com/docs/images/profile/doctors">
	<cfloop query="docs">
		<cfif fileExists("#LAD2path#/uploaded/#photoFilename#")>
			<cfset origfound++>
			<cftry>
				<cfset orig	= imageRead("#LAD2path#/uploaded/#photoFilename#")>
				<cfcatch type="any">
					<cfscript>
						imageFile	= createObject("java","java.io.File").init("#LAD2origpath#/uploaded/#photoFilename#");
						ImageIO		= createObject("java","javax.imageio.ImageIO");
						bi			= ImageIO.read(imageFile);
						if (isdefined("bi")){
							orig		= ImageNew(bi);
						}
					</cfscript>
				</cfcatch>
			</cftry>
			<cfset new	= resizeFromCenter(orig,236,175)>
			<cfset imageWrite(orig,"#LAD3path#/uploaded/#photoFilename#")>
			<cfset imageWrite(new,"#LAD3path#/#photoFilename#")>
		<cfelseif fileExists("#LAD2path#/#photoFilename#")>
			<cfset regfound++>
			<cftry>
				<cfset orig	= imageRead("#LAD2path#/#photoFilename#")>
				<cfcatch type="any">
					<cfscript>
						imageFile	= createObject("java","java.io.File").init("#LAD2path#/#photoFilename#");
						ImageIO		= createObject("java","javax.imageio.ImageIO");
						bi			= ImageIO.read(imageFile);
						if (isdefined("bi")){
							orig		= ImageNew(bi);
						}
					</cfscript>
				</cfcatch>
			</cftry>
			<cfset new	= resizeFromCenter(orig,236,175)>
			<cfset imageWrite(orig,"#LAD3path#/uploaded/#photoFilename#")>
			<cfset imageWrite(new,"#LAD3path#/#photoFilename#")>
		</cfif>
	</cfloop>
	<cfoutput>#origfound# originals found<br>#regfound# regulars found<br>#(origfound+regfound)# total conversions</cfoutput><cfabort>
</cffunction>

<cffunction name="botTest">
	<cfparam name="params.agent" default="bot">
	<cfhttp url="http://#CGI.SERVER_NAME#/doctors/index/bottest" userAgent="#params.agent#">
	<cfabort>
</cffunction>

<cffunction name="BasicPlusUnopenedLeadThreshold" output="true">
	<!---
		http://carlos3.locateadoc.com/test/basicplusunopenedleadthreshold?reload=true
	--->
	<cfset BasicPlusUnopenedLeadThreshold = model("Account").BasicPlusUnopenedLeadThreshold(accountId=340806)>
	<cfoutput>
		<p>
		<a href="http://carlos.practicedock.com/admin/LocateADoc/stats/folio_popup_view_ltp.cfm?start=1&perpage=10&account_id=340806&entity_id=&level_id=1&info_id=&FolioStatsPracticeId=&SortBy=DateDown&LeadDisplay=Unopened&FolioOnly=checked&PhoneOnly=checked&MiniOnly=checked&MonthRange=1095&Apply=Apply" target="_blank">Link</a><br />
		BasicPlusUnopenedLeadThreshold = #BasicPlusUnopenedLeadThreshold#<br />
		</p>
	</cfoutput>

	<cfset BasicPlusUnopenedLeadThreshold = model("Account").BasicPlusUnopenedLeadThreshold(accountId=189117)>
	<cfoutput>
		<p>
		<a href="http://carlos.practicedock.com/admin/LocateADoc/stats/folio_popup_view_ltp.cfm?start=1&perpage=10&account_id=310295&entity_id=&level_id=1&info_id=&FolioStatsPracticeId=&SortBy=DateDown&LeadDisplay=Unopened&FolioOnly=checked&PhoneOnly=checked&MiniOnly=checked&MonthRange=1095&Apply=Apply" target="_blank">Link</a><br />
		BasicPlusUnopenedLeadThreshold = #BasicPlusUnopenedLeadThreshold#<br />
		</p>
	</cfoutput>


	<cfset BasicPlusUnopenedLeadThreshold = model("Account").BasicPlusUnopenedLeadThreshold(accountId=311501)>
	<cfoutput>
		<p>
		<a href="http://carlos.practicedock.com/admin/LocateADoc/stats/folio_popup_view_ltp.cfm?start=1&perpage=10&account_id=311501&entity_id=&level_id=1&info_id=&FolioStatsPracticeId=&SortBy=DateDown&LeadDisplay=Unopened&FolioOnly=checked&PhoneOnly=checked&MiniOnly=checked&MonthRange=1095&Apply=Apply" target="_blank">Link</a><br />
		BasicPlusUnopenedLeadThreshold = #BasicPlusUnopenedLeadThreshold#<br />
		</p>
	</cfoutput>


	<cfset BasicPlusUnopenedLeadThreshold = model("Account").BasicPlusUnopenedLeadThreshold(accountId=344800)>
	<cfoutput>
		<p>
		<a href="http://carlos.practicedock.com/admin/LocateADoc/stats/folio_popup_view_ltp.cfm?start=1&perpage=10&account_id=344800&entity_id=&level_id=1&info_id=&FolioStatsPracticeId=&SortBy=DateDown&LeadDisplay=Unopened&FolioOnly=checked&PhoneOnly=checked&MiniOnly=checked&MonthRange=1095&Apply=Apply" target="_blank">Link</a><br />
		BasicPlusUnopenedLeadThreshold = #BasicPlusUnopenedLeadThreshold#<br />
		</p>
	</cfoutput>


	<cfabort>

	<cfset renderNothing()>
</cffunction>

<cffunction name="BasicPlusUnopenedThresholdEmailTest" output="true">
	<!---
		http://carlos3.locateadoc.com/test/basicplusunopenedthresholdemailtest
	--->

	<cfset testController = controller("scheduled")>

	<cfset testController.BasicPlusUnopenedThresholdEmail(	accountId	= 155707,
															clientEmail = "carlos@mojointeractive.com")>

	<!--- <cfset BasicPlusUnopenedThresholdEmail(	accountId	= 189117,
											clientEmail = "carlos@mojointeractive.com")>

	<cfset BasicPlusUnopenedThresholdEmail(	accountId	= 311501,
											clientEmail = "carlos@mojointeractive.com")> --->


	<cfabort>

	<cfset renderNothing()>
</cffunction>


</cfcomponent>