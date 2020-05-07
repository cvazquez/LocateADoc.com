<cfoutput>
<div class="home_unsubscribe">
<h1>Unsubscribe</h1>
</cfoutput>


<cfif successMsg NEQ "">
	<cfoutput>
		<div class="successMsg">#successMsg#</div>
	</cfoutput>
	<cfexit method="exitTemplate">
<cfelseif errorMsg NEQ "">
	<cfoutput>
		<div class="errorMsg">#errorMsg#</div>
	</cfoutput>
</cfif>



<!--- START: DEFAULT UNSUBSCRIBE BEHAVIOR IF USER HAS NOT BEEN UNSUBSCRIBED BY THIS POINT --->
<cfif NOT blnUnsubSuccess>
	<cfquery name="qryTables" datasource="myLocateadocLB">
		SELECT				table_id, name
		FROM				newsletter_email_tables
		WHERE				is_newsletter = 1
		AND					is_active = 1
		ORDER BY			name
	</cfquery>

  <cfoutput>
	<h2>Remove your email address from the following newsletters:</h2>

	<div class="home_unsubscribe_form">
	  <form name="frmUnsub" method="post" action="/home/unsubscribe">
		<input type="hidden" name="processing" value="1" />

		<b>Newsletter:</b><br />

		<label for="table_id_all"><input type="checkbox" name="table_id" value="All" id="table_id_all" />All</label>

		<cfloop query="qryTables">
			<label for="table_id_#table_id#"><input type="checkbox" name="table_id" value="#table_id#" id="table_id_#table_id#" />#name#</label>

		</cfloop>

		<br clear="all" /><br />

		<b>Email Address:</b>
		<blockquote>
			<input name="email" type="text" value="#Form.email#" />
		</blockquote>
		<br clear="all" />

		<div align="center">
			<input type="submit" name="unsubscribe" value="Remove Me" />
		</div>
	  </form>
	</div>

  </cfoutput>
</cfif>
<!--- END: DEFAULT UNSUBSCRIBE BEHAVIOR IF USER HAS NOT BEEN UNSUBSCRIBED BY THIS POINT --->

<cfoutput></div></cfoutput>