<cfif quickSelect.stateAlphas.recordcount>
	<cfoutput>
		<cfif params.controller eq "resources" and params.action eq "specialty">
			<input id="city-addendum" type="hidden" value="specialty-#specialtyID#">
		<cfelseif params.controller eq "resources" and params.action eq "procedure">
			<input id="city-addendum" type="hidden" value="procedure-#procedureID#">
		</cfif>
	</cfoutput>
	<div class="quick-locsearch-mini sort-box">
		<div class="heading">
			<h4>Quick Search By <strong>Location</strong></h4>
			<p>Choose a letter below for a list of states and their corresponding cities to view a list of doctors in that area.</p>
			<ul class="list-item sort-heading">
				<cfset stateAlphasList = ValueList(quickSelect.stateAlphas.letter)>
				<!--- <cfoutput query="quickSelect.stateAlphas">
				<li><a href="##" class="tab state-alpha<cfif stateAlphas.currentrow eq 1> active</cfif>">#stateAlphas.letter#</a></li>
				</cfoutput>--->
				<cfoutput>
				<cfloop list="A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z" index="Local.alpha">
					<cfif ListFind(stateAlphasList,Local.alpha)>
						<li><a href="##" class="tab state-alpha<cfif Local.alpha eq ListFirst(stateAlphasList)> active</cfif>">#Local.alpha#</a></li>
					<cfelse>
						<li class="empty-alpha">#Local.alpha#</li>
					</cfif>
				</cfloop>
				</cfoutput>
			</ul>
		</div>
		<div class="tabholder">
			<div class="tabhold">
				<div class="tabframe">
					<ul class="tab-item sort-list"<!---  id="state-list" --->>
						<cfoutput query="quickSelect.States">
							<li><a href="###Replace(States.name," ","-","all")#" class="tab<!---  state-link ---> mini<cfif States.currentrow eq 1> active</cfif>"><span>#UCase(States.name)#</span></a></li>
						</cfoutput>
					</ul>
					<div class="subtabs">
						<cfoutput>#quickSelect.cities#</cfoutput>
						<!--- <div id="cities-list">
							#initialCities#
						</div> --->
					</div>
				</div>
			</div>
		</div>
	</div>
<!--- </cfoutput> --->
</cfif>