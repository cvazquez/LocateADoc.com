<cfoutput>
	<div class="search-bar">
		<div class="holder">
			<form name="doctorsearch" action="##" method="post">
				<fieldset>
					<label for="city" class="search-title">start your search</label>
					<input type="hidden" id="country" value="<!--- US --->">
					<div class="row">
						<div class="text-long">
							<div class="bar-body"><input id="city" class="big-autocomplete" name="location" type="text" value="City, State or Zip" /></div>
							<div class="bar-cap"></div>
						</div>
						<div class="col"></div>
						<div class="text-long" style="overflow:visible;">
							<div class="bar-body procedure-couple">
								<input class="procedure-output" name="procedureorspecialty" type="hidden" value="" />
								<input type="text" id="SpecialtyProcedureTreatment" class="procedure-input big-autocomplete" value="Specialty, Procedure or Treatment" />
								<p class="exampletext">Ex: Dentistry, Breast Lift Surgery, Hair Removal</p>
							</div>
							<div class="bar-cap"></div>
						</div>
						<div class="col">
							<!--- fake styled select box that will persist until jQuery loads --->
							<!--- <div style="width: 217px;" class="selectArea temporary"><span class="left"></span><span class="center">Select Specialty</span><a href="##" class="selectButton"></a></div>
							<select name="specialty" class="short-box hidefirst">
								<option value="">Specialty</option>
								<cfloop query="Specialties">
									<option name="specialties_#Specialties.id#" value="#Specialties.id#">#Specialties.name#</option>
								</cfloop>
							</select>--->
							<input class="btn-search-large" type="button" value="<!--- SEARCH --->" onmousemove="SelectSpecialty();" onclick="SubmitSearch();" />
							<br><a href="##" class="link" onclick="AdvancedSearch();">advanced search</a>
						</div>
					</div>
				</fieldset>
			</form>
		</div>
	</div>
</cfoutput>