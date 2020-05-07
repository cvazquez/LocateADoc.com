<cfprocessingdirective suppressWhitespace="yes">
	<cfsetting enablecfoutputonly="yes" showdebugoutput="no">
	<cfparam name="url.id" default="">
	<cfparam name="url.corrections" default="0">
	<cfparam name="request.isspider" default="0">
	<cfparam name="cftoken" default="">
	<cfparam name="url.source" default="">
	<cfparam name="url.source_id" default="">
	<cfparam name="url.target" default="">
	<cfparam name="url.target_id" default="#url.id#">  <!--- url.target_id <=> url.id --->
	<cfparam name="url.specialtyId" default="">
	<cfparam name="url.infoId" default="">
	<cfparam name="url.twitter_user_id" default="">
	<cfparam name="url.twitter_user_name" default="">
	<cfparam name="url.anchor" default="">

	<cfif URL.Corrections EQ 0>
		<cfset urlCorrections = "http://#CGI.HTTP_HOST#/redirect.cfm">
		<cfset tmpQueryString = URLDecode(CGI.QUERY_STRING)>

		<!--- START: URL SCREENING GAUNTLET --->
		<!--- Over-zealous escape sequence correction --->
		<cfif FindNoCase("&amp;", tmpQueryString)>
			<cfset tmpQueryString = REReplace(tmpQueryString, "&(amp[;]?)+", "&", "ALL")>
			<cfset tmpQueryString = REReplace(tmpQueryString, "&{2,}", "&", "ALL")>
		</cfif>
		<!--- END: URL SCREENING GAUNTLET --->

		<cfif tmpQueryString NEQ URLDecode(CGI.QUERY_STRING)>
			<CFHEADER STATUSCODE="301" STATUSTEXT="Moved permanently">
			<CFHEADER NAME="Location" VALUE="#urlCorrections#?#tmpQueryString#&corrections=1">
			<CFABORT>
		</cfif>
	</cfif>


	<!--- <cfoutput>url.target = #url.target#<br /><br />
	#urldecode(url.target)#
	</cfoutput>

	<cfabort> --->


	<cfscript>
		//If an id is not specified
		if( NOT isNumeric(url.target_id) AND len(url.target_id) EQ 0)
		{
			// Establish Link Source and get id
			sourceId = getLinkSource(sourceId = url.source_id,  source = url.source);

			// Establish link target and get id
			targetId = getLinkTarget(targetId = url.target_id ,
				target = url.target ,
				sourceId = sourceId ,
				specialtyId = url.specialtyId ,
				infoId = url.infoId);

			callModule(sourceId = sourceId, targetId = targetId);
		}
		else
		{
			callModule( targetId = url.target_id);
		}
	</cfscript>

	<!--- Functions --->
	<cffunction name="getLinkSource">
	    <cfargument name="sourceId" default="-1">
	    <cfargument name="source">

	    <cfset var id = 0>

	    <!--- If given id, verify it exists --->
	    <cfif isNumeric(arguments.sourceId) AND arguments.sourceId GT 0>
	        <cfquery name='qGetLinkSource' datasource="myLocateadocLB">
		        SELECT 1
		        FROM tracking_sources
		        WHERE id = <cfqueryparam value="#arguments.sourceId#">
		        LIMIT 1
	        </cfquery>
	        <!--- If exists, use --->
	        <cfif qGetLinkSource.recordCount gt 0>
	            <cfset id = arguments.sourceId>
	        <!--- Else create source --->
	        <cfelse>
	           <cfset id = createLinkSource(arguments.source)>
	        </cfif>
	    <!--- Else create source --->
	    <cfelse>
	        <cfset id = createLinkSource(arguments.source)>
	    </cfif>

	    <cfreturn id>
	</cffunction>

	<cffunction name="getLinkTarget">
	    <cfargument name="targetId" default="-1">
	    <cfargument name="sourceId" default="-1">
	    <cfargument name="target">
	    <cfargument name="infoId" default="0">
	    <cfargument name="specialtyId" default="">

	    <cfset var id = 0>

	    <!--- If given id, verify it exists --->
	    <cfif isNumeric(arguments.targetId) AND arguments.targetId GT 0>
	        <cfquery name='qGetLinkTarget' datasource="myLocateadocLB">
		        SELECT 1
		        FROM tracking_links
		        WHERE id = <cfqueryparam value="#arguments.targetId#">
		        LIMIT 1
	        </cfquery>
	        <!--- If exists, use --->
	        <cfif qGetLinkTarget.recordCount gt 0>
	            <cfset id = arguments.targetId>
	        <cfelse>
	        <!--- Else create target --->
	            <cfset id = createLinkTarget(target = arguments.target,
	                                         sourceId = arguments.sourceId,
	                                         specialtyId = url.specialtyId ,
	                                         infoId = url.infoId )>
	        </cfif>
	    <!--- Else create target --->
	    <cfelse>
	        <cfset id = createLinkTarget(target = arguments.target,
	                                         sourceId = arguments.sourceId,
	                                         specialtyId = url.specialtyId ,
	                                         infoId = url.infoId )>
	    </cfif>

	    <cfreturn id>
	</cffunction>

	<cffunction name="createLinkSource">
	    <cfargument name="source" default="">

	    <cfset var id = 0>

	    <!--- Double check this doesn't exist (happens when calling script doesn't know ID --->
	    <cfquery name="qCheckForExistingSource" datasource="myLocateadoc">
			SELECT id
			FROM tracking_sources
			WHERE source = <cfqueryparam value="#arguments.source#">
			LIMIT 1
	    </cfquery>

	    <cfif qCheckForExistingSource.recordCount EQ 1>
	        <cfset id = qCheckForExistingSource.id>
	    <cfelse>
		    <cfquery name="qCreateLinkSource" datasource="myLocateadoc">
			    INSERT INTO tracking_sources
			    	(source)
			    VALUES
			    	( <cfqueryparam value="#arguments.source#"> )
		    </cfquery>
		    <cfquery name="qGetInsertId" datasource="myLocateadoc">
		    	SELECT LAST_INSERT_ID() as newId
		    </cfquery>

		    <cfset id = qGetInsertId.newId>
	    </cfif>

	    <!--- Return source id --->
	    <cfreturn id>
	</cffunction>



	<cffunction name="createLinkTarget">
	    <cfargument name="target" default="">
	    <cfargument name="sourceId" default="0">
	    <cfargument name="infoId" default="0">
	    <cfargument name="specialtyId" default="">
	    <cfset var id = 0>

		<cflock name="RedirectCreateLinkTarget" timeout="5">
	    <!--- Double check this doesn't exist (happens when calling script doesn't know ID --->
	    <cfquery name="qCheckForExistingLink" datasource="myLocateadocLB">
			SELECT id
			FROM tracking_links
			WHERE url = <cfqueryparam value="#arguments.target#">
				AND source_id = <cfqueryparam value="#arguments.sourceId#">
			LIMIT 1
	    </cfquery>

	    <cfif qCheckForExistingLink.recordCount EQ 1>
	        <cfset id = qCheckForExistingLink.id>
	    <cfelse>
		    <cfquery name="qCreateLinkTarget" datasource="myLocateadocReplace">
			    REPLACE INTO tracking_links
			    	(url, source_id, info_id, sid, created_dt)
			    VALUES
			    (
			        <cfqueryparam value="#arguments.target#">,
			        <cfqueryparam value="#arguments.sourceId#">,
		            <cfqueryparam value="#arguments.infoId#">,
		            <cfqueryparam value="#arguments.specialtyId#" null="#Len(arguments.specialtyId) EQ 0#">,
					now()
			     )
		    </cfquery>
		    <cfquery name="qGetInsertId" datasource="myLocateadocLB">
			    SELECT id AS newId
			    FROM tracking_links
			    WHERE url = <cfqueryparam value="#arguments.target#">
			    	AND source_id = <cfqueryparam value="#arguments.sourceId#">
		    </cfquery>

		    <cfset id = qGetInsertId.newId>
	    </cfif>
		</cflock>

	    <!--- Return target id --->
	    <cfreturn id>
	</cffunction>

	<cffunction name="callModule">
	    <cfargument name="sourceId">
	    <cfargument name="targetId">

	    <cfset url.id = arguments.targetId>

		<!--- <cfdump var="#url#"><br clear="all" /><cfdump var="#arguments#"><br clear="all" /><cfabort> --->
	    <cfinclude template="/go.cfm">
	</cffunction>

</cfprocessingdirective>