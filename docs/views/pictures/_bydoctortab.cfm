<cfoutput>
	<div id="tab2" style="visibility:hidden">
		<!-- location-form -->
		<form class="location-form">
			<fieldset>
				<strong class="title">To find a doctor near you, complete the following fields.</strong>
				<div class="row">
					<label for="country">Country</label>
					<div class="styled-select" style="width: 215px;">
						<select name="country" id="country" class="country hidefirst" style="width: 235px;">
							<option name="country-US" value="US">United States</option>
							<option name="country-CA" value="CA">Canada</option>
							<option name="country-MX" value="MX">Mexico</option>
						</select>
					</div>
				</div>
				<div class="row">
					<label for="city" id="citylabel">City, State, Zip</label>
					<div class="styled-input" style="width: 215px; height:20px;">
						#textFieldTag(
							name	= "location",
							id		= "city",
							style	= "width:179px;"
						)#
					</div>
				</div>
				<div class="row">
					<label for="distance">Distance</label>
					<div class="styled-select" style="width: 215px;">
					#selectTag(
						includeBlank= "None selected",
						name		= "distance",
						options		= distances,
						style		= "width:235px;"
					)#
					</div>
				</div>
				<div class="btn">
					#buttonTag(
						content	= "SEARCH",
						id		= "doctorsearch",
						type	= "button",
						class	= "btn-search")#
				</div>
				<strong class="title">OR search by Last Name below:</strong>
				<div class="row">
					<label for="name">Doctor Last Name</label>
					<div class="styled-input" style="width: 215px; height:20px;">
						#textFieldTag(
							name	= "doctorlastname",
							id		= "doctorlastname",
							style	= "width:179px;"
						)#
					</div>
				</div>
				<!--- <div class="row">
					<label for="spec">Specialization</label>
					#selectTag(
						includeBlank= "None selected",
						name		= "specialty",
						options		= specializations
					)#
				</div> --->

			</fieldset>
		</form>
	</div>
</cfoutput>