<!---
Filename: /LocateADoc/ads.cfm
URL: http://www.locateadoc.com/ads.cfm?
Date: 2001?
Programmer: Carlos Vazquez (carlos@mojointeractive.com)
COPYRIGHT:  Copyright (C) 2008 by Mojo Interactive, Inc.,
Purpose: Used to record that a link was clicked on and redirect to the destination page
Notes: Any other important information here.
Updates: Include who made the update, when and what was updated (or refer to SVN)
Project Folder(s):
[Update] - (date) - Full path location to any project folder or documents referring to this script.
Update description
2/1/2008 (Carlos Vazquez - carlos@mojointeractive.com)
Fixed problems like: http://carlos.locateadoc.com/ads.cfm?adv_id=http%3A%2F%2Fwww.heaven-house.kz%2Ftemplates_c%2Fsexes%2Fafacub%2F
(Add any additional information)
--->

<cfinclude template="/LocateADocModules/_ext2attr2.cfm">
<cfparam name="Attributes.lead_id" default="">
<cfparam name="Attributes.sid" default="">
<cfparam name="Attributes.did" default="">
<cfparam name="attributes.info_id" default="">
<CFPARAM NAME="Attributes.id" DEFAULT="">
<CFPARAM NAME="Attributes.adv_id" DEFAULT="">

<cfif not isDefined("request.IsSpider")>
	<cfmodule template="/LocateADocModules/SpiderFilter.cfm" ReturnVariable="request.IsSpider">
</cfif>

<CFIF IsNumeric(Attributes.id) AND (NOT IsNumeric(Attributes.adv_id))><CFSET Attributes.adv_id=Attributes.id></CFIF>

<cfif not isnumeric(attributes.adv_id)>
	<!--- <cflocation url="/index.cfm" addtoken="no"> --->
	<CFHEADER STATUSCODE="301" STATUSTEXT="Moved permanently">
	<CFHEADER NAME="Location" VALUE="/">
	<cfabort>
</cfif>

<!--- get the link --->
<cfquery datasource="myLocateadoc" name="get">
	SELECT link FROM advertisers
	WHERE adv_id = #attributes.adv_id#
</cfquery>

<cfif get.recordcount EQ 0>
	<!--- <cflocation url="/index.cfm" addtoken="no"> --->
	<CFHEADER STATUSCODE="301" STATUSTEXT="Moved permanently">
	<CFHEADER NAME="Location" VALUE="/">
	<cfabort>
</cfif>
<cfset LinkAttributes = ''>
<cfif Attributes.lead_id GT 4>
		<cfif isnumeric(attributes.did) AND structKeyExists(Application.strctSpecialty, attributes.sid)>
			<cfif attributes.did LT 100000>
				<cfquery datasource="myLocateadoc" name="qryInfo">
					SELECT info_id
					FROM doc_specialty_mapped
					WHERE sid = #attributes.sid# AND did = #attributes.did#
				</cfquery>
				<cfif qryInfo.recordcount GT 0>
					<cfset attributes.info_id = qryInfo.info_id>
				</cfif>
			<cfelse>
				<cfset url.info_id = url.did>
			</cfif>
		</cfif>
		<cfif not isnumeric(attributes.info_id)>
			<cfset attributes.info_id = 0>
		</cfif>

	<cfquery datasource="myLocateadoc">
		INSERT INTO doconly_tracking
			(lead_id,sid,info_id,date_entered,date_updated)
		VALUES
			(#Attributes.lead_id#,0#Attributes.sid#,#Attributes.info_id#,now(),now())
	</cfquery>
	<cfif Find("?","#get.link#")>
		<cfset LinkAttributes = '&sid=#Attributes.sid#&info_id=#Attributes.info_id#'>
	<cfelse>
		<cfset LinkAttributes = '?sid=#Attributes.sid#&info_id=#Attributes.info_id#'>
	</cfif>
<cfelse>
	<cfif NOT Request.IsSpider>
		<!--- Check if record exists --->
		<cfquery datasource="myLocateadoc" name="check">
			SELECT count(*) AS count FROM advertiser_tracking
			WHERE adv_id = #attributes.adv_id# and year(dateAccessed) = year(now()) and month(dateAccessed) = month(now()) AND day(dateAccessed) = day(now())
		</cfquery>

		<cfif check.count EQ 0>
		<!--- record doesn't exist, so we insert it --->
			<cfquery datasource="myLocateadoc">
				INSERT INTO advertiser_tracking (adv_id, dateAccessed)
				VALUES (#attributes.adv_id#, now())
			</cfquery>
		</cfif>

		<!--- Update numofclicks for this advertiser in this month and year --->
		<cfquery datasource="myLocateadoc">
			UPDATE advertiser_tracking
			set numOfClicks = numofClicks + 1
			WHERE adv_id = #attributes.adv_id# and year(dateAccessed) = year(now()) and month(dateAccessed) = month(now()) AND day(dateAccessed) = day(now())
		</cfquery>
	</cfif>
</cfif>

<!--- Relocate to advertisers web page
<cflocation url="#get.link##LinkAttributes#" addtoken="No"> --->
<CFHEADER STATUSCODE="301" STATUSTEXT="Moved permanently">
<CFHEADER NAME="Location" VALUE="#get.link##LinkAttributes#">
