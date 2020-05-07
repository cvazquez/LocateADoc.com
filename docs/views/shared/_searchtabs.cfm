<cfoutput>
	<div class="search-tabs">
		<span class="search-title">start your search</span>
		<ul class="tabset">
			<li class="location"><a href="##tab1" id="tab1link" class="tab active"><strong><span>CHOOSE BY LOCATION</span></strong><em></em></a></li>
			<li class="procedure"><a href="##tab2" id="tab2link" class="tab"><strong><span>CHOOSE BY PROCEDURE</span></strong><em></em></a></li>
			<li class="specialty"><a href="##tab3" id="tab3link" class="tab"><strong><span>CHOOSE BY SPECIALTY</span></strong><em></em></a></li>
		</ul>
		<div id="tab1" class="tab">
			<div class="holder">
				<form name="doctorsearch" action="##" class="location-form">
					<fieldset>
						<p>Search by location, plus procedure type or doctor specialty</p>
						<div class="row">
							<label for="country">Country</label>
							<!--- fake styled select box that will persist until jQuery loads --->
							<div style="width: 313px;" class="selectArea temporary"><span class="left"></span><span class="center">United States</span><a href="##" class="selectButton"></a></div>
							<select name="country" id="country" class="country hidefirst">
								<option name="country-US" value="US">United States</option>
								<option name="country-CA" value="CA">Canada</option>
								<option name="country-MX" value="MX">Mexico</option>
							</select>
							<div class="col">
								<label for="distance">Distance</label>
								<!--- fake styled select box that will persist until jQuery loads --->
								<div style="width: 287px;" class="selectArea temporary"><span class="left"></span><span class="center">Select Distance</span><a href="##" class="selectButton"></a></div>
								<select name="distance" id="distance" class="hidefirst">
									<option value="">Select Distance</option>
									<option name="distance-5" value="5">5 Miles</option>
									<option name="distance-10" value="10">10 Miles</option>
									<option name="distance-25" value="25">25 Miles</option>
								</select>
							</div>
						</div>
						<div class="row">
							<label for="city" id="citylabel">City, State, Zip</label>
							<div class="text-city"><input name="location" id="city" type="text" <cfif params.location eq "" or params.location eq "City, State or Zip">value="City, State or Zip"<cfelse>value="#params.location#" class="noPreText"</cfif> /></div>
							<!--- <a class="link" href="##">change</a> --->
							<div class="col" style="padding-left: 52px;">
								<label for="name">Doctor's Name</label>
								<div class="text-name"><input name="name" id="name" type="text" value="Enter Name Here" /></div>
							</div>
						</div>
						<div class="row">
							<div class="btn">
								<a href="##" class="more" onclick="ProceduresLink();">CHOOSE PROCEDURE</a>
								<span>or</span>
								<a href="##" class="more" onclick="SpecialtiesLink();">CHOOSE SPECIALTY</a>
								<span>or</span>
								<input class="btn-search" type="button" value="SEARCH" onclick="SubmitSearch();" />
							</div>
						</div>
					</fieldset>
				</form>
			</div>
		</div>
		<!--- TODO: Dump all these inline styles into the css files once I find something that works --->
		<style type="text/css">
			.sort-heading li .active{color:##974e5f; text-decoration:none;}
			.procedures .list li.show-item{display:inline !important;}
			.specialties .list li.show-item{display:inline !important;}
			.list-item li a{
				display: inline;
				width: auto;
				color: ##6c6c6c;
				text-decoration: underline;
			}
			.list-item li a:hover{
				text-decoration: none;
				color: ##974e5f;
			}
			.sort-box a{
				font-family: BreeRegular,Arial,Helvetica,sans-serif;
				font-size: 14px;
			}
		</style>
		<div id="tab2" class="tab sort-box hidefirst">
			<ul class="list-item sort-heading" style="display: block; float:none; margin:0 0 23px;">
				<cfloop query="ProcedureAlphas">
				<li style="float:left; display:inline; margin:0 10px 0 0;"><a href="##" class="tab #Iif(ProcedureAlphas.letter eq 'A',DE(' active'),DE(''))#">#ProcedureAlphas.letter#</a></li>
				</cfloop>
			</ul>
			<div class="procedures scrollable" style="height:140px;">
				<ul class="list sort-list">
					<cfloop query="Procedures">
					<li style="float:left; display:inline; margin:0 20px 5px 0; width:250px; height:40px;"><a href="##" onclick="SubmitSearch('procedure-#Procedures.id#')">#Procedures.name#</a></li>
					</cfloop>
				</ul>
			</div>
		</div>
		<div id="tab3" class="tab sort-box hidefirst">
			<ul class="list-item sort-heading" style="display: block; float:none; margin:0 0 23px;">
				<cfloop query="SpecialtyAlphas">
				<li style="float:left; display:inline; margin:0 10px 0 0;"><a href="##" class="tab #Iif(SpecialtyAlphas.letter eq 'A',DE(' active'),DE(''))#">#SpecialtyAlphas.letter#</a></li>
				</cfloop>
			</ul>

				<div class="specialties scrollable" style="height:140px;">
					<ul class="list sort-list">
						<cfloop query="Specialties">
						<li style="float:left; display:inline; margin:0 20px 5px 0; width:250px; height:20px;"><a href="##" onclick="SubmitSearch('specialty-#Specialties.id#')">#Specialties.name#</a></li>
						</cfloop>
					</ul>
				</div>

		</div>
	</div>
</cfoutput>