<cfparam name="missing" default="">
<cfif ListLen(missing)>
	<cfoutput>
		<div id="page1" class="centered">
			<img src="/images/mobile/find_your_doctor.png">
			<div id="bottom-content-wrapper">
				<div id="bottom-content">
					<h1 style="margin-top:10px;">Oops</h1>
					<p><br />It looks like you missed some required information listed below. Please <a href="javascript:history.go(-1)">go back</a> and fill them out.</p>
					<ul>
						<li>#ListChangeDelims(missing, "</li><li>")#</li>
					</ul>
					<a href="javascript:history.go(-1)" class="button">Go Back</a>
				</div>
			</div>
		</div>
	</cfoutput>
</cfif>