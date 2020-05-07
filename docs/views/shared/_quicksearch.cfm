<!--- <cfoutput> --->
	<div class="quick-locsearch sort-box">
		<div class="heading">
			<h4>Quick Search By <strong>Location</strong></h4>
			<ul class="list-item sort-heading">
				<cfoutput query="quickSelect.stateAlphas">
					<li><a href="##" class="tab state-alpha<cfif stateAlphas.currentrow eq 1> active</cfif>">#stateAlphas.letter#</a></li>
				</cfoutput>
			</ul>
		</div>
		<p>Choose a letter for a list of states and their corresponding cities to view a list of doctors in that area.</p>
		<div class="tabholder">
			<div class="tabhold">
				<div class="tabframe">
					<ul class="tab-item sort-list"<!---  id="state-list" --->>
						<cfoutput query="quickSelect.states">
							<li><a href="###Replace(States.name," ","-","all")#" class="tab<!---  state-link ---><cfif States.currentrow eq 1> active</cfif>"><span>#UCase(States.name)#</span></a></li>
						</cfoutput>
					</ul>
					<div class="subtabs">
						<cfoutput>#quickSelect.cities#</cfoutput>
						<!--- <div id="cities-list"> --->
							<!--- #initialCities# --->
						<!--- </div> --->
						<!--- <cfoutput query="initialCities" group="stateid">
							<div id="#Replace(state," ","-","all")#">
								<ul>
									<cfoutput>
										<li>#linkTo(text=name, route="doctorSearch2", filter1="state-#stateid#", filter2="city-#id#")#</li>
									</cfoutput>
								</ul>
							</div>
						</cfoutput> --->
					</div>
				</div>
			</div>
		</div>
	</div>
<!--- </cfoutput> --->