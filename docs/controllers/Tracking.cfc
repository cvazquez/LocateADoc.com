<cfcomponent extends="Controller" output="false">

	<cffunction name="init">

	</cffunction>

	<cffunction name="newsletter">
		<!---
		Filename: http://www.locateadoc.com/tracking/newsletter.cfm
		Date: 4/16/2002
		Programmed By: Carlos Vazquez (carlos@mojointeractive.com)
		COPYRIGHT:  Copyright (C) 2002 by Mojo Interactive, Inc., All Rights Reserved
		Purpose: Track when a user opens up a newsletter
		Updates: 12/9/2005 - Working on delaying the update to prevent lockups
		Notes:
			<img src="http://www.locateadoc.com/tracking/newsletter.cfm?email_id=##">

			http://carlos3.locateadoc.com/tracking/newsletter?email_id=3273356
		--->
		<cfparam default="" name="url.email_id">

		<cfif isnumeric(url.email_id)>
			<cfquery datasource="myLocateadoc">
				UPDATE newsletter_emails
				set is_opened = is_opened + 1
				WHERE email_id = #url.email_id#
			</cfquery>
			<!---
			Right now we're doing a workaround for UPDATE DELAYED by first doing a SELECT
			from the record, change the values we want to update, and then doing a REPLACE
			DELAYED INTO ...

			<cfquery datasource="myLocateadoc" name="qryEmail">
				SELECT *
				FROM newsletter_emails
				WHERE email_id = #url.email_id#
			</cfquery>

			<cfset opened_count = is_opened + 1>
			<cfloop list="#qryEmail.columnsList#" index="idxField">
				<cfset idxField
			</cfloop>


			REPLACE DELAYED INTO newsletter_emails (
			VALUES
			--->
		</cfif>

		<cflocation addtoken="no" url="/images/empty_pixel.gif">
	</cffunction>


	<cffunction name="carecredit">
		<!---
		Filename: http://www.locateadoc.com/tracking/carecredit/[financingPatientLeadId]
		Date: 7/2/2015
		Programmed By: Carlos Vazquez (carlos@mojointeractive.com)
		COPYRIGHT:  Copyright (C) 2015 by Mojo Interactive, Inc., All Rights Reserved
		Purpose: An email was sent to carecredit applicants, to resign up for financing, because CareCredit's financing page dissapeared. This script is tracking users who click on the email.
		--->
		<cfparam default="" name="params.key">

		<cfif isnumeric(params.key) AND val(params.key) GT 0>
			<cfquery datasource="myLocateadocEdits">
				UPDATE financingpatientleads
				set careCreditResendClickAt = now()
				WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#params.key#"> AND careCreditResendClickAt IS NULL
			</cfquery>
		</cfif>

		<cflocation addtoken="no" url="https://www.carecredit.com/sw/patient/application2.html?id=UjhdZARECV1cB1NjVUoGNg%3D%3D">
	</cffunction>
</cfcomponent>