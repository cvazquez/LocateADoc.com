<cfoutput>
	<div id="main">
		<ul class="breadcrumbs">
			<li><a href="/">Home</a></li>
			<li><a href="/doctors">Doctors</a></li>
			<li><a href="/doctors/states">States</a></li>
			<li>#state.name#</li>
		</ul>
		<div class="container inner-container">
			<div class="inner-holder">
				<div class="content-frame">
					<div class="financing">
						<h1>#state.name# Doctors</h1>
						<ul>
							<cfloop query="qryCities">
								<li style="float:left; width:200px;"><a href="/doctors/#qryCities.siloName#-#LCase(state.abbreviation)#">#qryCities.name#</a></li>
							</cfloop>
						</ul>
						<div style="clear:both;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>
