<cfcomponent output="false" displayname="Common Functions" hint="Functions used for both the admin and client dashboards">

<cffunction name="init">
	<cfargument name="account_id">
	<cfargument name="startDate" default="" required="false">
	<cfargument name="endDate" default="" required="false">

	<cfset var qFeaturedDate = QueryNew("")>

	<cfset variables.account_id = arguments.account_id>

	<cfset variables.strctMeta = structNew()>
	<cfset variables.strctMeta.header_list ="">
	<cfset variables.strctMeta.column_list = "">
	<cfset variables.strctMeta.title = "">
	<cfset variables.strctMeta.report_type = "query">
	<cfset variables.questionCount = 0>


	<cfif NOT isDate(arguments.startDate) OR NOT isDate(arguments.endDate)>
		<cfset qFeaturedDate = GetFeaturedDates()>
	</cfif>

	<cfif isDate(arguments.startDate)>
		<cfset variables.startDate = arguments.startDate>
	<cfelseif isDate(qFeaturedDate.date_start)>
		<cfset variables.startDate = qFeaturedDate.date_start>
	<cfelse>
		<cfset variables.startDate = dateAdd("y", -1, now())>
	</cfif>

	<cfif isDate(arguments.endDate)>
		<cfset variables.endDate = arguments.endDate>
	<cfelseif isDate(qFeaturedDate.date_end)>
		<cfset variables.endDate = qFeaturedDate.date_end>
	<cfelse>
		<cfset variables.endDate = now()>
	</cfif>

	<!--- <cfsavecontent variable="request.master_page_title">
			<cfoutput>
			 #request.master_page_title# for
			#DateFormat(variables.startDate,'MM/DD/YYYY')#
			-
			#DateFormat(variables.endDate,'MM/DD/YYYY')#
			</cfoutput>
	</cfsavecontent> --->

<!--- <cfdump var="#variables#"> --->
	<cfreturn this>
</cffunction>

<cffunction name="GetReportMetaData" returntype="struct" access="public" output="false">
	<cfreturn variables.strctMeta>
</cffunction>


<cffunction name="StructDataTypes" access="public" returntype="struct" output="false">
	<cfscript>
		var queryDataTypes = structNew();
		queryDataTypes["aLeadType"] = "string";
		queryDataTypes["bLeadCount"] = "number";
	</cfscript>

	<cfreturn queryDataTypes>
</cffunction>


<cffunction name="ifBlankZero" access="public">
	<cfargument name="arg1">
	<cfif Len(arguments.arg1) eq 0>
		<cfreturn 0 />
	</cfif>
	<cfreturn arguments.arg1>
</cffunction>

<cffunction name="simpleTable" access="public" output="true" returntype="string">
	<cfargument name="qTable" type="query">
	<cfargument name="maxRows" type="numeric" default="10">

	<cfset var output=''>
	<cfset var extraClasses = ''>
	<cfset var shownRows = 0>
	<cfif isNumeric(arguments.maxRows)>
		<cfset shownRows = arguments.maxRows>
	</cfif>
	<cfsavecontent variable="output">
	<div class="paged list">
		<ul class="list">
			<cfloop query="qTable">
				<cfif currentRow GT shownRows>
					<cfset extraClasses = 'hiddenlist '>
				</cfif>
				<li class="#extraClasses#line">
					<div class="left">#value#</div>
					<div class="right">#valueCount#</div>
				</li>
			</cfloop>
		</ul>
		<div class="list navigation">
			Show Top <a href="##show-10" class="selected show-10">10</a> |
					<a href="##show-20" class="show-20">20</a> |
					<a href="##show-50" class="show-50">50</a>
		</div>
	</div>
	</cfsavecontent>

	<cfreturn output>
</cffunction>

<cffunction name="displayPercentage" access="public" output="true" returntype="string">
	<cfargument name="label" type="string">
	<cfargument name="value" type="string">
	<cfargument name="percentageOfWhole" type="numeric">
	<cfargument name="isShown" type="boolean" default="true">

	<cfset var out = ''>
	<cfset var extraClasses = ''>

	<cfif arguments.isShown eq false>
		<cfset extraClasses = "hidden">
	</cfif>

	<cfsavecontent variable="out">
	<cfoutput>
	<li class="#extraClasses#" value="#value#">
		<label class="left">#arguments.label# #arguments.value#%</label>
	</li>
	</cfoutput>
	</cfsavecontent>
	<cfreturn out>
</cffunction>

<cffunction name="displayAbsolute" access="public" output="true" returntype="string">
	<cfargument name="label" type="string">
	<cfargument name="value" type="string">
	<cfargument name="percentageOfWhole" type="numeric">
	<cfargument name="isShown" type="boolean" default="true">
	<cfargument name="urlDrillDown" type="string" required="false" default="">
	<cfargument name="ChartType" type="string" required="false" default="old">
	<cfargument name="questionNumber" type="numeric" required="false" default="-1">


	<cfset var out = ''>
	<cfset var extraClasses = ''>

	<cfif arguments.isShown eq false>
		<cfset extraClasses = "hidden">
	</cfif>
	<cfsavecontent variable="out">


	<cfoutput>

<cfif arguments.label eq 'yes'>
<cfset imageSet = 'yes.gif'>
<cfelseif arguments.label eq 'no' >
<cfset imageSet = 'no.gif'>
<cfelseif arguments.label eq 'unsure' >
<cfset imageSet = 'unsure.gif'>
<cfelse>
<cfset imageSet = 'cal.gif'>
</cfif>

		<cfif arguments.ChartType eq "old">
			<li class="#extraClasses#" value="#arguments.percentageOfWhole#">
				<cfif urlDrillDown neq "">
					<a href="#urlDrillDown#"><div style="height:20px;"><label class="left">#arguments.label#<div class="right value">#arguments.value#</div></label></div></a>
				<cfelse>
					<label class="left">#arguments.label#<div class="right value">#arguments.value#</div></label>
				</cfif>
			</li>
		<cfelse>

			<li class="#extraClasses#">
				<cfif urlDrillDown neq "">
					<span class="icon"><a href="#urlDrillDown#"><img src="/admin/dashboard/images/#imageSet#" width="25" height="25" alt="#arguments.label#" border="0" /></a></span>
					   <span class="lilable">#arguments.label#</span>
				<cfelse>
					<img src="/admin/dashboard/images/#imageSet#.gif" width="25" height="25" alt="#arguments.label#" border="0" />
				</cfif>

				<strong class="livalue">#arguments.value#</strong>
				<!--- <span style="width: #arguments.percentageOfWhole#%" class="index#Min(arguments.questionNumber,4)#">(#arguments.percentageOfWhole#%)</span> --->
			</li>

		</cfif>
	</cfoutput>

	</cfsavecontent>
	<cfreturn out>
</cffunction>

<cffunction name="displayAbsoluteDashBoard" access="public" output="true" returntype="string">
	<cfargument name="label" type="string">
	<cfargument name="value" type="string">
	<cfargument name="percentageOfWhole" type="numeric">
	<cfargument name="isShown" type="boolean" default="true">
	<cfargument name="urlDrillDown" type="string" required="false" default="">
	<cfargument name="ChartType" type="string" required="false" default="old">
	<cfargument name="questionNumber" type="numeric" required="false" default="-1">


	<cfset var out = ''>
	<cfset var extraClasses = ''>

	<cfif arguments.isShown eq false>
		<cfset extraClasses = "hidden">
	</cfif>
	<cfsavecontent variable="out">
<!---
<div style="font-size: 0.75em; font-weight: bold; margin-bottom:10px;">
<a href="http://www.practicedock.com/admin/dashboard/index.cfm?action=ReportSurveyLeads&amp;id=310824" target="_blank"> The patient wants the procedure performed in </a>
</div>
--->




	<cfoutput>
		<cfif arguments.ChartType eq "old">
			<li class="#extraClasses#" value="#arguments.percentageOfWhole#">
				<cfif urlDrillDown neq "">
					<a href="#urlDrillDown#"><div style="height:20px;"><label class="left">#arguments.label#<div class="right value">#arguments.value#</div></label></div></a>
				<cfelse>
					<label class="left">#arguments.label#<div class="right value">#arguments.value#</div></label>
				</cfif>
			</li>
		<cfelse>


<cfif arguments.label eq 'yes'>
<cfset imageSet = 'yes.gif'>
<cfelseif arguments.label eq 'no' >
<cfset imageSet = 'no.gif'>
<cfelseif arguments.label eq 'unsure' >
<cfset imageSet = 'unsure.gif'>
<cfelse>
<cfset imageSet = 'cal.gif'>
</cfif>


<!---
<ul style="width:275px; display:block; list-style:none; font-size: 0.75em; font:'Trebuchet MS', Arial, Helvetica, sans-serif; color:##000; padding:0; margin:0;">

<li style="display: block; padding: 0pt; height: 26px; border: 1px solid rgb(204, 204, 204); margin-bottom: 10px; background: none repeat scroll 0% 0% rgb(255, 255, 255);">

<div style="display: block; float: left; padding: 0pt 5px; height: 5px;">
	<img src="http://www.practicedock.com/admin/dashboard/images/#imageSet#" alt="yes" style="display: block; float: left;" height="25" width="25"><span style="padding: 5px 0pt 0pt 5px; display: block; float: left;">
		<cfif arguments.label neq ''>#arguments.label#<cfelse>Less than a month</cfif>
	</span>
</div>

<div style="display: block; float: right; padding: 5px 5px 0pt; height: 25px;">#arguments.value#</div>

</ul>
--->

<table style="width: 275px; font:14px 'Trebuchet MS',Arial,Helvetica,sans-serif; color: rgb(0, 0, 0); margin-bottom: 10px;" cellpadding="0" cellspacing="0" border="0">
<tbody>
<tr><td style="height: 3px;"></td></tr>
<tr style="padding: 3px;">
  <td style="border-bottom: 1px solid rgb(204, 204, 204); border-left: 1px solid rgb(204, 204, 204); border-top: 1px solid rgb(204, 204, 204); background: none repeat scroll 0% 0% rgb(255, 255, 255); padding: 3px;" width="10%"><img src="http://www.practicedock.com/admin/dashboard/images/#imageSet#" alt="#arguments.label#" height="25" width="25"></td>
  <td style="border-bottom: 1px solid rgb(204, 204, 204); border-top: 1px solid rgb(204, 204, 204); background: none repeat scroll 0% 0% rgb(255, 255, 255); padding: 3px;" valign="left" width="65%"><cfif arguments.label neq ''>#arguments.label#<cfelse>Less than a month</cfif></td>
  <td style="border-bottom: 1px solid rgb(204, 204, 204); border-top: 1px solid rgb(204, 204, 204); border-right: 1px solid rgb(204, 204, 204); background: none repeat scroll 0% 0% rgb(255, 255, 255); padding: 3px; text-align: center;" valign="middle" width="25%">#arguments.value#</td>
</tr>
</tbody></table>



		</cfif>
	</cfoutput>
	</cfsavecontent>
	<cfreturn out>
</cffunction>


<cffunction name="accountInfo" returntype="query">

<cfquery name="qAccount" datasource="myLocateadoc">
	SELECT la.account_name_tx AS name
	FROM lad_accounts la
	WHERE la.account_id = #attributes.id#
</cfquery>
	<cfset name = qAccount.name>
	<cfreturn name>

</cffunction>


<cffunction name="computePercentage" returntype="query">
	<cfargument name="qIn">
	<cfargument name="columnToStorePercentage" default="result">
	<cfset var newQ = qIn>
	<cfset var qTotal = ''>
	<cfset var total = 0>
	<cfset var tmpPercentage = 0>

	<cfif newQ.recordCount eq 0>
		<cfset newQ = QueryNew("label, result, percentage")>
	</cfif>

	<cfquery dbtype="query" name="qTotal">
	Select sum(result) as total from arguments.qIn
	</cfquery>
	<cfset total = qTotal.total>

	<cfloop query="qIn">
		<cfscript>
		if(result neq 0){
			tmpPercentage = Round(result / total * 100);
		}else{
			tmpPercentage = 0;
		}
		QuerySetCell(newQ, arguments.columnToStorePercentage,tmpPercentage,CurrentRow);
		</cfscript>
	</cfloop>
	<cfreturn newQ>
</cffunction>

<cffunction name="createLabeledBarChart" access="public" output="true" returntype="string">
	<cfargument name="questionText" type="string">
	<cfargument name="answerResultSet" type="query">
	<cfargument name="rowDisplayOverride" type="numeric" default="3">
	<cfargument name="displayFunction" type="any">
	<cfargument name="urlDrillDown" type="any" default="" required="false">
	<cfargument name="classOverride" type="String" default="graphic module left" required="false">
	<cfargument name="NoAnswerOverride" type="string" default="No Data to Report" required="false">
	<cfargument name="TextLimit" type="numeric" required="false" default="40">
	<cfargument name="ChartType" type="string" required="false" default="old">

	<cfset var barchartOutput = ''>
	<cfset var maxResults = arguments.rowDisplayOverride>
	<cfset var class = arguments.classOverride>
	<cfset var questionNumber = 0>

	<cfif arguments.TextLimit eq 0>
		<cfset arguments.TextLimit = 40>
	</cfif>

	<cfif not isdefined("variables.questionCount")>
		<cfset variables.questionCount = 0>
	</cfif>

	<cfset variables.questionCount = variables.questionCount + 1>

	<cfif arguments.answerResultSet.recordCount LT 3>
		<cfset maxResults = arguments.answerResultSet.recordCount>
	</cfif>

	<cfsavecontent variable="barchartOutput">
	<cfoutput>
	<div class="#class#">
			<div class="small bold">
				<cfif arguments.urlDrillDown NEQ "" and arguments.answerResultSet.recordCount neq 0>
				<a href="#urlDrillDown#">
				</cfif>
				#arguments.questionText#
				<cfif arguments.urlDrillDown NEQ ""></a></cfif>
			</div>
			<ul class="<cfif arguments.ChartType eq "old">barchart<cfelse>chartlist</cfif>">
				<cfif arguments.answerResultSet.recordCount eq 0>
					<cfif arguments.ChartType eq "old">
						<label class="left bold">#Left(arguments.NoAnswerOverride, arguments.TextLimit)#</label></li>
					<cfelse>
						<li>
							#Left(arguments.NoAnswerOverride, arguments.TextLimit)#
						</li>
					</cfif>
				<cfelse>
					<cfloop from="1" to="#maxResults#" step="1" index="questionNumber">
						<cfoutput>
							#arguments.displayFunction(Left(arguments.answerResultSet.label[questionNumber], arguments.TextLimit),
								arguments.answerResultSet.result[questionNumber],
								arguments.answerResultSet.percentage[questionNumber],
								true,
								arguments.urlDrillDown,
								arguments.ChartType,
								questionNumber
								)#
						</cfoutput>
					</cfloop>

					<cfloop from="#maxResults+1#" to="#arguments.answerResultSet.recordCount#"
							step="1" index="questionNumber">
						<cfoutput>
							#arguments.displayFunction(Left(arguments.answerResultSet.label[questionNumber], arguments.TextLimit),
								arguments.answerResultSet.result[questionNumber],
								arguments.answerResultSet.percentage[questionNumber],
								false,
								arguments.urlDrillDown,
								arguments.ChartType,
								questionNumber
								)#
						</cfoutput>
					</cfloop>
				</cfif>
			</ul>
			<cfif maxResults LT arguments.answerResultSet.recordCount>
				<a class="show-full-report#variables.questionCount# left" id="ViewUnView#variables.questionCount#">View more</a>
			</cfif>
	</div>
	</cfoutput>
	</cfsavecontent>
	<cfreturn barchartOutput>
</cffunction>

<cffunction name="createLabeledBarChartDashboard" access="public" output="true" returntype="string">

	<cfargument name="questionText" type="string">
	<cfargument name="answerResultSet" type="query">
	<cfargument name="rowDisplayOverride" type="numeric" default="3">
	<cfargument name="displayFunction" type="any">
	<cfargument name="urlDrillDown" type="any" default="" required="false">
	<cfargument name="classOverride" type="String" default="overflow: hidden; padding: 5px 10px;z-index: 2; float: left;" required="false">
	<cfargument name="NoAnswerOverride" type="string" default="No Data to Report" required="false">
	<cfargument name="TextLimit" type="numeric" required="false" default="40">
	<cfargument name="ChartType" type="string" required="false" default="old">
	<cfargument name="account_id" type="numeric" required="false" default="0">


	<cfset var barchartOutput = ''>
	<cfset var maxResults = arguments.rowDisplayOverride>
	<cfset var class = arguments.classOverride>
	<cfset var questionNumber = 0>

	<cfif arguments.TextLimit eq 0>
		<cfset arguments.TextLimit = 40>
	</cfif>

	<cfif not isdefined("variables.questionCount")>
		<cfset variables.questionCount = 0>
	</cfif>

	<cfset variables.questionCount = variables.questionCount + 1>

	<cfif arguments.answerResultSet.recordCount LT 3>
		<cfset maxResults = arguments.answerResultSet.recordCount>
	</cfif>

	<cfsavecontent variable="barchartOutput">
	<cfoutput>

	<div style="overflow:hidden; padding:5px 10px; width:285px; z-index:2; float:left;">

			<div style="font-size: 0.75em; font-weight: bold; margin-bottom: 10px;">
				<cfif arguments.urlDrillDown NEQ "" and arguments.answerResultSet.recordCount neq 0>
				<a href="#urlDrillDown#">
				</cfif>
				#arguments.questionText#
				<cfif arguments.urlDrillDown NEQ ""></a></cfif>
			</div>
	<cfif arguments.ChartType eq "old">
			<ul style="margin: 0;padding: 0;width: 275px;list-style-type: none; float:left;"><!--- ><ul style="margin: 2.5px 0; padding: 0; background-color: white; position: relative; border:1px solid ##D6D6D6; height:20px;">--->
	<cfelse>
		<ul style="margin: 0;padding: 0;width: 275px;list-style-type: none;">
	</cfif>

				<cfif arguments.answerResultSet.recordCount eq 0>
					<cfif arguments.ChartType eq "old">
						<label style="float: left; font-weight: bold;">#Left(arguments.NoAnswerOverride, arguments.TextLimit)#</label></li>
					<cfelse>
						<li>
							#Left(arguments.NoAnswerOverride, arguments.TextLimit)#
						</li>
					</cfif>
				<cfelse>
					<cfloop from="1" to="#maxResults#" step="1" index="questionNumber">
						<cfoutput>
							#arguments.displayFunction(
								Left(arguments.answerResultSet.label[questionNumber],arguments.TextLimit),
								arguments.answerResultSet.result[questionNumber],
								arguments.answerResultSet.percentage[questionNumber],
								true,
								arguments.urlDrillDown,
								arguments.ChartType,
								questionNumber
								)#
						</cfoutput>
					</cfloop>

					<cfloop from="#maxResults+1#" to="#arguments.answerResultSet.recordCount#"
							step="1" index="questionNumber">
						<cfoutput>
							#arguments.displayFunction(Left(arguments.answerResultSet.label[questionNumber], arguments.TextLimit),
								arguments.answerResultSet.result[questionNumber],
								arguments.answerResultSet.percentage[questionNumber],
								false,
								arguments.urlDrillDown,
								arguments.ChartType,
								questionNumber
								)#
						</cfoutput>
					</cfloop>
				</cfif>
			</ul>

			<cfif arguments.answerResultSet.recordCount GT 3 >
				<a style="font-size: 80%; text-decoration: underline; cursor: pointer; float: left;'" id="ViewUnView#variables.questionCount#" href="http://www.practicedock.com/admin/dashboard/index.cfm?action=client&id=#arguments.account_id#">View more</a>
			</cfif>

	</div>
	</cfoutput>
	</cfsavecontent>
	<cfreturn barchartOutput>
</cffunction>


<cffunction name="getByType" returntype="query" access="public" output="false" hint="Return A count of Folio, Mini and PhonePlus leads within a passed data range">
	<cfset var qGetByType = "">

	<cfquery name="qGetByType" datasource="myLocateadoc">
	select
		"Folio Leads" as aLeadType,
		count(distinct(f.folio_id)) as bLeadCount
	From lad_account_entities lae
	INNER Join doc_info di On di.doctor_entity_id = lae.entity_id
	INNER JOIN folio f ON f.info_id = di.info_id
			  And f.is_active = 1 AND f.is_duplicate = 0
			  And f.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
			  AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
	Where lae.account_id = <cfqueryparam value="#variables.account_id#">

	Union

	select
		"Mini Leads" as aLeadType,
		count(distinct u.id) as bLeadCount
	From user_accounts_hits u
	Join doc_info di
	On u.info_id = di.info_id
	Join lad_account_entities lae
	On di.doctor_entity_id = lae.entity_id
	Where lae.account_id = <cfqueryparam value="#variables.account_id#">
	  And u.is_active = 1 AND u.is_duplicate = 0
	    And u.has_folio_lead = 0 AND u.is_cover_up = 1
	  And u.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
		AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">

	Union

	Select
		"Phone Leads" as aLeadType,
		if(count(distinct p.id) IS NULL OR count(distinct p.id) = "", 0, count(distinct p.id)) as bLeadCount
	From phoneplus_leads p
	Join doc_info di
	On p.info_id = di.info_id
	Join lad_account_entities lae
	On di.doctor_entity_id = lae.entity_id
	Where lae.account_id = <cfqueryparam value="#variables.account_id#">
	  And p.call_start BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
		AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
		AND p.is_active = 1
	</cfquery>

	<cfreturn qGetByType>
</cffunction>

<!--- <cffunction name="GetFeaturedStartDate" access="private" returntype="query" output="false" hint="Retrieve the start date of the current active featured product">
	<cfset var qFeaturedStartDate = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery name="qFeaturedStartDate" datasource="myLocateadoc">
			SELECT min(date_start) AS date_start, max(date_end) AS date_end
			FROM lad_account_products_purchased
			WHERE account_id = #variables.account_id# AND product_id = 1 AND is_active = 1
		</cfquery>
	</cfif>

	<cfreturn qFeaturedStartDate>
</cffunction> --->

<cffunction name="GetFeaturedDates" access="private" returntype="query" output="false" hint="Retrieve the start and end date of the current active featured product">
	<cfset var qFeaturedDates = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery name="qFeaturedDates" datasource="myLocateadoc">
			SELECT min(date_start) AS date_start, max(date_end) AS date_end
			FROM lad_account_products_purchased
			WHERE account_id = #variables.account_id# AND product_id = 1 AND is_active = 1
		</cfquery>

		<cfif qFeaturedDates.date_start GT now()>
			<!--- Start date is in future. Check history table for last featured product contract --->
			<cfquery name="qFeaturedDates2" datasource="myLocateadoc">
				SELECT date_start, <!--- if(date_end < now(), date_add(now(), INTERVAL 1 DAY), date_end)  AS --->date_end
				FROM lad_account_products_purchased_history
				WHERE account_id = #variables.account_id# AND product_id = 1
				order by date_end desc
				limit 1
			</cfquery>
			<cfif qFeaturedDates2.recordcount GT 0>
				<cfset qFeaturedDates = qFeaturedDates2>
			</cfif>
		</cfif>

	</cfif>

	<cfreturn qFeaturedDates>
</cffunction>

<cffunction name="GetFeaturedDatesStruct" returntype="struct" access="public" output="false" hint="Returns the start and end dates for the current product">
	<cfset var strctReturn = StructNew()>

	<cfset strctReturn.startDate = variables.startDate>
	<cfset strctReturn.endDate = variables.endDate>

	<cfreturn strctReturn>
</cffunction>

</cfcomponent>