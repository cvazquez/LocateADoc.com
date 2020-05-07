<div id="main">
	<ul class="breadcrumbs">
		<li><a href="/">Home</a></li>
		<li><a href="/doctors">Doctors</a></li>
		<li>States</li>
	</ul>
	<div class="container inner-container">
		<div class="inner-holder">
			<div class="content-frame">
				<div class="financing">
					<cfoutput>
						<h1>United States Doctors</h1>
						<ul>
							<cfloop query="qryUSStates">
								<li style="float:left; width:200px;"><a href="/doctors/#qryUSStates.siloName#-cities">#qryUSStates.name#</a></li>
							</cfloop>
						</ul>
						<div style="clear:both;"></div>
						<h2 style="margin-top:20px;">Other Countries</h2>
						<h3 style="margin-top:10px;">Canada Doctors</h3>
						<ul>
							<cfloop query="qryCAStates">
								<li style="float:left; width:200px;"><a href="/doctors/#qryCAStates.siloName#-cities">#qryCAStates.name#</a></li>
							</cfloop>
						</ul>
						<div style="clear:both;"></div>
						<h3 style="margin-top:15px;">Mexico Doctors</h3>
						<ul>
							<cfloop query="qryMXStates">
								<li style="float:left; width:200px;"><a href="/doctors/#qryMXStates.siloName#-cities">#qryMXStates.name#</a></li>
							</cfloop>
						</ul>
						<div style="clear:both;"></div>
					</cfoutput>
				</div>
			</div>
		</div>
	</div>
</div>
