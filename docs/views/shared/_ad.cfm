<!---
Adsense Usage
#includePartial(partial	= "/shared/ad",
				size	= "generic300x250")#

EverdayHealth Usage
#includePartial(partial	= "/shared/ad",
				dctile	= "1",
				ct		= "other",
				pos		= "top",
				sz		= "300x250",
				adType	= "EDH")#
--->


<cfparam name="request.adArray" default="#ArrayNew(1)#">
<cfparam name="arguments.size" default="">

<cfset thisDimension = "">
<cfset adProcedureIds = "">

<cfoutput><!-- Ad Section: #arguments.size# --></cfoutput>

<cfif reFindNoCase("160x600", arguments.size)>
	<cfset thisDimension = "160x600">
<cfelseif reFindNoCase("728x90", arguments.size)>
	<cfset thisDimension = "728x90">
<cfelseif reFindNoCase("300x250", arguments.size)>
	<cfset thisDimension = "300x250">
</cfif>



<!--- arguments.size NEQ "home300x250" AND --->
<cfif params.action NEQ "index" AND
	(isdefined("procedures") AND isQuery(procedures) AND procedures.recordCount GT 0 AND isdefined("procedures.id")
		AND (NOT isdefined("params.procedure") OR (isdefined("params.procedure") AND val(params.procedure) EQ 0))
	)>
	<cfset adProcedureIds = ListAppend(adProcedureIds, valueList(procedures.id))>
</cfif>

<cfif isdefined("params.key") AND params.action EQ "procedure" AND val(params.key) GT 0>
	<cfset adProcedureIds = ListAppend(adProcedureIds, params.key)>
</cfif>

<cfif isdefined("params.procedure") AND isnumeric(params.procedure)>
	<cfset adProcedureIds = ListAppend(adProcedureIds, params.procedure)>
</cfif>

<cfif isdefined("procedureID") AND isnumeric(procedureID)>
	<cfset adProcedureIds = ListAppend(adProcedureIds, procedureID)>
</cfif>
	<!--- <cfif ListFind("559,714,715,865", params.procedure) AND reFindNoCase("160x600|728x90", arguments.size)>
		<cfif reFindNoCase("160x600", arguments.size) AND NOT ArrayFindNoCase(request.adArray, "SummersEve160x600")>
			<cfset arguments.size = "SummersEve160x600">
			<cfset ArrayAppend(request.adArray, arguments.size)>
		<cfelseif reFindNoCase("728x90", arguments.size) AND NOT ArrayFindNoCase(request.adArray, "SummersEve728x90")>
			<cfset arguments.size = "SummersEve728x90">
			<cfset ArrayAppend(request.adArray, arguments.size)>
		</cfif>
	</cfif> --->

<cfif ListLen(adProcedureIds)>
	<cfset qAd = model("Ad").GetProcedureAd(	procedureIds	= adProcedureIds,
												dimension		= thisDimension)>

	<cfif qAd.recordCount GT 0>
		<cfif NOT ArrayFindNoCase(request.adArray, qAd.section)>
			<cfoutput>#qAd.content#</cfoutput>

			<cfset ArrayAppend(request.adArray, qAd.section)>
			<cfexit>
		</cfif>
	</cfif>
</cfif>



<cfif isdefined("topSpecialties") AND isQuery(topSpecialties) AND topSpecialties.recordCount GT 0 AND isdefined("topSpecialties.id")
		AND (NOT isdefined("params.specialty") OR (isdefined("params.specialty") AND val(params.specialty) EQ 0))>
	<cfset specialtyIdList = valueList(topSpecialties.id)>

	<cfloop list="#specialtyIdList#" index="iSid">
		<cfif ListFind("11,49", iSid)>
			<cfset params.specialty = iSid>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif isdefined("params.key") AND params.action EQ "specialty" AND val(params.key) GT 0>
	<cfset params.specialty = params.key>
</cfif>

<cfif isdefined("params.specialty")>
	<cfif isnumeric(params.specialty)>
		<cfset qAd = model("Ad").GetSpecialtyAd(	specialtyId	= params.specialty,
													dimension	= thisDimension)>
		<cfif qAd.recordCount GT 0>
			<cfif NOT ArrayFindNoCase(request.adArray, qAd.section)>
				<cfoutput>#qAd.content#</cfoutput>

				<cfset ArrayAppend(request.adArray, qAd.section)>
				<cfexit>
			</cfif>
		</cfif>
	</cfif>
</cfif>


<!--- These are hard coded sections passed in --->
<cfset qAd = model("Ad").GetGenericAd(	section	=	arguments.size)>

<cfif qAd.recordCount GT 0>
	<cfoutput>#qAd.content#</cfoutput><cfexit>
</cfif>
<cfexit>