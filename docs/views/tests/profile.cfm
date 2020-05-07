<cfoutput>
<h1>#h1Text#</h1>
<center>
<table class="testtable">
	<cfif isdefined("params.key")>
	<tr>
		<th class="casecolumn">First Name</th>
		<th class="casecolumn">Last Name</th>
		<th class="notecolumn">City</th>
		<th class="notecolumn">State</th>
		<th class="notecolumn">Link</th>
	</tr>
	<cfloop query="listings">
	<tr>
		<td>#listings.firstName#</td>
		<td>#listings.lastName#</td>
		<td>#listings.cityName#</td>
		<td>#listings.stateName#</td>
		<td><a href="/profile/welcome/#listings.accountDoctorId#" target="Profile#listings.accountDoctorId#">Profile</a> |
			<cfif server.thisServer EQ "dev" AND listFirst(cgi.SERVER_NAME NEQ "dev3")><a href="http://dev3.locateadoc.com/profile/welcome/#listings.accountDoctorId#" target="ProfileDev#listings.accountDoctorId#">Dev</a> |</cfif>
			<a href="http://#server.thisServer#.practicedock.com/admin/accounts/setupwizard.cfm?account_id=#listings.accountId#&a=account_tree&type=extended" target="Account#listings.accountId#">Account</a></td>
	</tr>
	</cfloop>

	<cfelse>
	<tr>
		<th class="casecolumn">Test Case</th>
		<th class="notecolumn">Notes</th>
	</tr>
	<tr>
		<td><a href="/tests/profile/advertisers" target="testsProfileAdvertisers">Advertisers</a></td>
		<td>Links to Advertiser Profiles</td>
	</tr>
	<tr>
		<td><a href="/tests/profile/pastadvertisers" target="TestsProfilePastAdvertisers">Past Advertisers</a></td>
		<td>Links to Past Advertiser Profiles</td>
	</tr>
	<tr>
		<td><a href="/tests/profile/basicplus" target="TestsProfileBasicPlus">Basic Plus</a></td>
		<td>Links to Basic Plus Profiles</td>
	</tr>
	<tr>
		<td><a href="/tests/profile/basic" target="TestsProfileBasic">Basic</a></td>
		<td>Links to Basic Profiles</td>
	</tr>
	<tr>
		<td><a href="/tests/profile/yext" target="TestsProfileYext">Yext</a></td>
		<td>Links to Yext Profiles</td>
	</tr>
	</cfif>
</table>
</center>
</cfoutput>