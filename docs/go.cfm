<cfprocessingdirective suppressWhitespace="yes">
	<cfparam name="URL.ID" default="">
	<cfparam name="Request.IsSpider" default="0">
	<cfparam name="client.CFTOKEN" default="">
	<cfparam name="client.CFID" default="">
	<cfparam name="url.anchor" default="">


	<cfif IsNumeric(URL.ID)>
		<cftry>
			<cfquery datasource="myLocateadoc" name="qLink">
				SELECT url AS NewURL, source_id
				FROM tracking_links
				WHERE (ID = #URL.ID#)
			</cfquery>

			<cfif qLink.RecordCount OR server.thisServer EQ "dev">
				<cfif Request.IsSpider eq 0>
					<cfquery datasource="myLocateadoc">
						INSERT INTO tracking_link_hits
						SET		link_id		= #URL.ID#,
								client_ip	= '#CGI.REMOTE_ADDR#',
								hit_dt		= Now(),
							<cfif isdefined("client.user_account_id") AND isnumeric(client.user_account_id)>
								userId = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.user_account_id#">,
							</cfif>
							<cfif isdefined("client.facebookid") AND isnumeric(client.facebookid)>
								faceBookId = <cfqueryparam cfsqltype="cf_sql_bigint" value="#client.facebookid#">,
							</cfif>

							<cfif isdefined("client.pagehistory_1") AND client.pagehistory_1 NEQ "">
								pagehistory1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_1#">,
							</cfif>

							<cfif isdefined("client.pagehistory_2") AND client.pagehistory_2 NEQ "">
								pagehistory2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_2#">,
							</cfif>

							<cfif isdefined("client.pagehistory_3") AND client.pagehistory_3 NEQ "">
								pagehistory3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_3#">,
							</cfif>

							<cfif isdefined("client.pagehistory_4") AND client.pagehistory_4 NEQ "">
								pagehistory4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_4#">,
							</cfif>

							<cfif isdefined("client.pagehistory_5") AND client.pagehistory_5 NEQ "">
								pagehistory5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.pagehistory_5#">,
							</cfif>

							<cfif isdefined("client.referralfull") AND client.referralfull NEQ "">
								`refererExternal` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.referralfull#">,
							</cfif>

							`refererInternal` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_REFERER#">,

							<cfif isdefined("client.entrypage") AND client.entrypage NEQ "">
								`entryPage` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.entrypage#">,
							</cfif>

							<cfif isdefined("client.keywords") AND client.keywords NEQ "">
								`keywords` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.keywords#">,
							</cfif>

							`cfId` = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.cfid#">,
							`cfToken` = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.cftoken#">,
							`userAgent` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#">
					</cfquery>


					<cfif server.thisServer EQ "dev">
						<cfset websiteSourceId = 5444>
					<cfelse>
						<cfset websiteSourceId = 5450>
					</cfif>

					<cfif qLink.source_id EQ websiteSourceId>
						<!--- Recording the website clicks from emails into another table --->

						<cfquery datasource="myLocateadoc" name="qTrackingLinkHit">
							SELECT last_insert_id() AS id
						</cfquery>


						<cfquery datasource="myLocateadocEdits">
							INSERT IGNORE INTO `profilewebsiteclicks` (`accountDoctorId`, `userId`, `faceBookId`, `pagehistory1`, `pagehistory2`, `pagehistory3`, `pagehistory4`, `pagehistory5`, `ipAddress`, `refererExternal`, `refererInternal`, `entryPage`, `keywords`, `cfId`, `cfToken`, `userAgent`, `createdAt`)
							SELECT adl.accountDoctorId, tlh.userId, tlh.facebookId, tlh.pagehistory1, tlh.pagehistory2, tlh.pagehistory3, tlh.pagehistory4, tlh.pagehistory5, tlh.client_ip, tlh.refererExternal, tlh.refererInternal, tlh.entryPage, tlh.keywords, tlh.cfId, tlh.cfToken, tlh.userAgent, tlh.hit_dt
							FROM myLocateadoc.tracking_link_hits tlh
							INNER JOIN myLocateadoc.tracking_links tl On tlh.link_id = tl.ID AND tl.source_id = #websiteSourceId#
							INNER JOIN accountdoctorlocations adl ON adl.id = tl.info_id
							LEFT JOIN profilewebsiteclicks pwc ON pwc.accountDoctorId = adl.accountDoctorId AND pwc.ipAddress = tlh.client_ip AND date(pwc.createdAt) = date(tlh.hit_dt)
							WHERE tlh.id = #qTrackingLinkHit.id# AND pwc.id IS NULL
							GROUP BY adl.accountDoctorId, tlh.client_ip
						</cfquery>
					</cfif>

				</cfif>

				<!--- Prevent blanks --->
				<cfif trim(urlDecode(qLink.NewURL)) EQ "">
					<cfset qLink.NewURL = "/">
				</cfif>

				<!--- <cfoutput>
				ReFindNoCase("^https?://", qLink.NewURL) = #ReFindNoCase("^https?://", qLink.NewURL)#<cfabort>
				</cfoutput> --->

				<!--- Check for external redirects --->
				<cfif ReFindNoCase("^https?://", qLink.NewURL)>
					<!--- This is an external redirect --->
					<cflocation url="#qLink.NewURL#" addtoken="no" statuscode="301">
				<cfelse>
					<!--- This is an internal redirect --->
					<cflocation url="http://www.locateadoc.com#urlDecode(qLink.NewURL)##(url.anchor NEQ "" ? "###url.anchor#" : "")#" addtoken="no" statuscode="301">
				</cfif>


				<cfabort>
			<cfelse>
				<cfdump var="Home"><cfabort>
				<cflocation url="/" addtoken="no" statuscode="301">
			</cfif>
			<cfcatch>
				<cfif server.thisServer EQ "dev">
					<cfoutput>
					<cfdump var="#CFCATCH.Message#" label="Message">
					<cfdump var="#CFCATCH.Detail#" label="Detail">
					</cfoutput>
					<cfabort>
				<cfelse>
					<cfmail from="lad_errors@locateadoc.com"
							to="lad_errors@locateadoc.com"
							subject="ERROR LAD/go.cfm"
							type="html">
							<p>#CFCATCH.Message#</p>
							<p>#CFCATCH.Detail#</p>
					</cfmail>
					<cflocation url="/" addtoken="no" statuscode="301">
				</cfif>
			</cfcatch>
		</cftry>
	</cfif>
	<cflocation url="/" addtoken="no" statuscode="301">
</cfprocessingdirective>