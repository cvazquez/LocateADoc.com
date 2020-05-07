<cfoutput>
	<div id="page1" class="centered">
		<img src="/images/mobile/find_your_doctor.png">
		<div id="bottom-content-wrapper">
			<div id="bottom-content">
				<h1 style="margin-top:10px;">Oops</h1>
				<p><br />No doctors were found in your area. Please <a href="javascript:history.go(-1);">try again</a>.</p>
				<a href="javascript:history.go(-1);<!--- /mobile/page1?t=#REReplace(Client.mobile_entry_page,'\?.+','')# --->" class="button">Try Again</a>
			</div>
		</div>
	</div>
</cfoutput>