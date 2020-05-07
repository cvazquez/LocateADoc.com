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

</cfcomponent>