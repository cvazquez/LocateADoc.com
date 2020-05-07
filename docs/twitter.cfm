

<cfparam default="/" name="url.target">
<cfparam default="" name="url.specialty_id">
<cfparam default="" name="url.procedureId">
<cfparam default="" name="url.info_id">
<cfparam default="" name="url.twitter_user_id">
<cfparam default="" name="url.twitter_user_name">
<cfparam default="0" name="request.isspider">


<cftry>

<cfset url.target = urldecode(url.target)>

<cfif request.isspider EQ 0>
<cfquery datasource="myPro">
	INSERT INTO oauth_twitter_tracking
	SET
		<cfif isnumeric(url.twitter_user_id)>
			twitter_user_id = #url.twitter_user_id#,
		</cfif>
		twitter_user_name = <cfqueryparam value="#url.twitter_user_name#" cfsqltype="cf_sql_varchar">,
		<cfif isnumeric(url.specialty_id)>
			specialty_id = <cfqueryparam value="#url.specialty_id#" cfsqltype="cf_sql_integer">,
		</cfif>
		<cfif isnumeric(url.procedureId)>
			procedure_id = <cfqueryparam value="#url.procedureId#" cfsqltype="cf_sql_integer">,
		</cfif>
		<cfif isnumeric(url.info_id)>
			info_id = <cfqueryparam value="#url.info_id#" cfsqltype="cf_sql_integer">,
		</cfif>
		target_url = <cfqueryparam value="#url.target#" cfsqltype="cf_sql_varchar">,
		client_ip = <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_varchar">,
		<cfif isnumeric(client.cfid)>
			cfid = <cfqueryparam value="#client.cfid#" cfsqltype="cf_sql_integer">,
		</cfif>
		<cfif isnumeric(client.cftoken)>
			cftoken = <cfqueryparam value="#client.cftoken#" cfsqltype="cf_sql_integer">,
		</cfif>
		referer_url = <cfqueryparam value="#CGI.HTTP_REFERER#" cfsqltype="cf_sql_varchar">,
		user_agent = <cfqueryparam value="#cgi.HTTP_USER_AGENT#" cfsqltype="cf_sql_varchar">,
		is_active = 1,
		created_dt = now()
</cfquery>
</cfif>

<cfcatch type="any">
	<cfif ListGetAt(cgi.SERVER_NAME, 1, ".") NEQ "www">
		<P><CFDUMP VAR="#CFCATCH#" LABEL="CFCATCH"></P>
		<P><CFDUMP VAR="#CGI#" LABEL="CGI"></P>
		<p><CFDUMP VAR="#URL#" LABEL="URL"></P>
		<P>#Now()#</P>
		<cfabort>
	 <cfelse>
		<CFMAIL FROM="lad_errors@locateadoc.com"
				TO="lad_errors@locateadoc.com"
				SUBJECT="Error:#GetCurrentTemplatePath()#"
				TYPE="HTML">
				<P><CFDUMP VAR="#CFCATCH#" LABEL="CFCATCH"></P>
				<P><CFDUMP VAR="#CGI#" LABEL="CGI"></P>
				<p><CFDUMP VAR="#URL#" LABEL="URL"></P>
				<P>#Now()#</P>
		 </CFMAIL>
	 </cfif>
</cfcatch>

</cftry>

<cflocation addtoken="false" url="http://www.locateadoc.com#url.target#">