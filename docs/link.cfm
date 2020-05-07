<!---
Filename: link.cfm
Purpose: Tracks the number of times a user clicks on a particular link within a newsletter sent through
		the newsletter system.
--->

<!--- must be on http://www.locateadoc.com/link.cfm --->
<cfparam name="url.email_id" default="">
<cfparam name="url.id" default="">

<cfif not isnumeric(url.id)>
	<b>There is a problem with the url you entered. Please make sure what you are entering is correct.</b><br>
	Thank You.
	<cfabort>
</cfif>

<cfif not isnumeric(url.email_id)>
	<cfset url.email_id = 0>
</cfif>

<cfquery datasource="myLocateadoc" name="geT">
	SELECT link FROM newsletter_links
	where link_id = #url.id#
</cfquery>

<cfquery datasource="myLocateadoc" name="check">
	SELECT count(*) as howmany FROM newsletter_tracking
	where link_id = #url.id# and email_id = #url.email_id# and user_ip = '#cgi.remote_addr#' and month(date_sent) = month(now()) and year(date_sent) = year(now())
</cfquery>

<cfif check.howmany EQ 0>
	<cfquery datasource="myLocateadoc">
		INSERT INTO newsletter_tracking (link_id, email_id, numOfClicks, user_ip, date_sent)
		VALUES (#url.id#, #url.email_id#, 0, '#cgi.remote_addr#', now())
	</cfquery>
</cfif>

<cfquery datasource="myLocateadoc">
	UPDATE newsletter_tracking
	SET numOfClicks = numOfClicks + 1
	where link_id = #url.id# and email_id = #url.email_id# and user_ip = '#cgi.remote_addr#' and month(date_sent) = month(now()) and year(date_sent) = year(now())
</cfquery>

<cflocation addtoken="no" url="#get.link#">