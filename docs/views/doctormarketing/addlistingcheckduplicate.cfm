<cfoutput>

<!--- <cfdump var="#data#"> --->

<p>We found existing listings with your email address. Please log into <a href="https://www.practicedock.com/index.cfm/PageID/7151" target="PracticeDock">PracticeDock.com</a> to manager your subscription.</p>

<p>Your user name is one of the following:
	<ul>
	<cfloop query="data.findPDockUser">
		<li><strong>#data.findPDockUser.username_tx#</strong></li>
	</cfloop>
	</ul>
</p>

<p>If you do not know your password, use the password reset form on <a href="https://www.practicedock.com/index.cfm/PageID/7151" target="PracticeDock">PracticeDock.com</a>.</p>

</cfoutput>
