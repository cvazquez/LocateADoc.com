<!--- Place code here that should be executed on the "onSessionStart" event. --->
<cfparam name="Application.SharedModulesSuffix" default="">

<CFTRY>
	<CFIF NOT IsDefined("Client.EntryPage")>
		<CFSET ThisEntryPage="http#(CGI.SERVER_PORT_SECURE)?"s":""#://#CGI.SERVER_NAME##CGI.PATH_INFO#">
		<CFIF CGI.QUERY_STRING IS NOT ""><CFSET ThisEntryPage=ThisEntryPage & "?" & CGI.QUERY_STRING></CFIF>
		<cfset Client.EntryPage = ThisEntryPage>
	</CFIF>
	<CFIF NOT IsDefined("Client.ReferralFull")>
		<cfset Client.ReferralFull = CGI.HTTP_REFERER>
	</CFIF>
	<CFCATCH>
		<CFMAIL FROM="lad_errors@locateadoc.com"
				TO="lad_errors@locateadoc.com"
				SUBJECT="Error:#ExpandPath('.')#"
				TYPE="HTML">
				#CFCATCH.Message#<BR>
				#CFCATCH.Detail#
		</CFMAIL>
	</CFCATCH>
</CFTRY>
<!--- set keywords used to find us --->

<CFTRY>
	<CFSET Keywords="">
	<CFIF not StructKeyExists(Client, "Keywords")>
		<CFSET Referer=ReplaceNoCase(CGI.HTTP_REFERER,"http://","","ALL")>
		<CFSET Referer=ReplaceNoCase(Referer,"www.","","ALL")>
		<CFSET Referer=LCase(ListFirst(Referer,"/"))>
		<CFLOOP COLLECTION="#Application.stSearchEngines#" ITEM="i">
			<CFIF Referer CONTAINS i>
				<CFLOOP LIST="#ListRest(URLDecode(CGI.HTTP_REFERER),'?')#" INDEX="j" DELIMITERS="&">
					<CFIF ListFirst(j, "=") IS Application.stSearchEngines[i]>
						<CFSET Keywords=Trim(ReplaceList(ListRest(j,"="),"\,/,'"," "))><CFBREAK>
					</CFIF>
				</CFLOOP>
			</CFIF>
		</CFLOOP>
		<cfif keywords EQ ""> <!--- Search for q since it's common --->
			<CFLOOP LIST="#ListRest(URLDecode(CGI.HTTP_REFERER),'?')#" INDEX="j" DELIMITERS="&">
				<CFIF ListFirst(j, "=") IS "q">
					<CFSET Keywords=Trim(ReplaceList(ListRest(j,"="),"\,/,'"," "))><CFBREAK>
				</CFIF>
			</CFLOOP>
		</cfif>
		<cfset Client.Keywords = Keywords>
	</CFIF>
	<CFCATCH>
		<CFMAIL FROM="lad_errors@locateadoc.com"
				TO="lad_errors@locateadoc.com"
				SUBJECT="Error:#GetCurrentTemplatePath()#"
				TYPE="HTML">
			<P><CFDUMP VAR="#CFCATCH#" LABEL="CFCATCH"></P>
			<P><CFDUMP VAR="#Variables#" LABEL="Variables"></P>
			<P><CFDUMP VAR="#CGI#" LABEL="CGI"></P>
		</CFMAIL>
	</CFCATCH>
</CFTRY>

<CFMODULE TEMPLATE="/LocateADocModules#Application.SharedModulesSuffix#/SpiderFilter.cfm" ReturnVariable="Client.IsSpider">
<cfset setUserLocation()>