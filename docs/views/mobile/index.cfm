<cfoutput>
	<div id="page1" class="centered">
		<img src="/images/mobile/find_your_doctor.png">
		<div id="bottom-content-wrapper" style="margin-top:0px; min-height:265px;">
			<div id="bottom-content">
				<h1 style="padding:10px 0;">Welcome...<!---  to the Mobile LocateADoc.com ---></h1>
				<p>LocateADoc.com is the premier online physician directory connecting you with local doctors you choose in your area.<br /><br />
				<!--- Search for a doctor in your area: --->
				Ready to search for a doctor in your area?</p>
				<a href="/mobile/page1?t=#Client.mobile_entry_page#" class="button" onclick="validate(); return false;">Find a Doctor</a>
				<div style="text-align:center;"><a href="#Client.mobile_entry_page##(Client.mobile_entry_page contains "?")?"&":"?"#desktop=1" style="font-size:16px!important;">No thanks, continue to site</a></div>
			</div>
		</div>
	</div>
</cfoutput>