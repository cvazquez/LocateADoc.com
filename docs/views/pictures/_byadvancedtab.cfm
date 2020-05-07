<cfoutput>
	<div id="tab4" style="visibility:hidden">
		<form class="location-form">
			<fieldset>
				<strong class="title">Search by specifics.</strong>
				<div class="row">
					<label for="gender2">Gender</label>
					<div class="styled-select" style="width: 215px;">
						#selectTag(
							includeBlank="None selected",
							name="gender",
							options=genders,
							style="width:235px"
						)#
					</div>
				</div>
				<div class="row">
					<label for="age">Age</label>
					<div class="styled-select" style="width: 215px;">
						#selectTag(
							includeBlank="None selected",
							name="age",
							options=ageRanges,
							style="width:235px"
						)#
					</div>
				</div>
				<div class="row">
					<label for="height">Height</label>
					<div class="styled-select" style="width: 215px;">
						#selectTag(
							includeBlank="None selected",
							name="height",
							options=heightRanges,
							style="width:235px"
						)#
					</div>
				</div>
				<div class="row">
					<label for="weight">Weight</label>
					<div class="styled-select" style="width: 215px;">
						#selectTag(
							includeBlank="None selected",
							name="weight",
							options=weightRanges,
							style="width:235px"
						)#
					</div>
				</div>
				<div class="row">
					<label for="city" id="citylabel">City, State, Zip</label>
					<div class="styled-input" style="width: 215px; height:20px;">
						#textFieldTag(
							name	= "location",
							id		= "city2",
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
							style="width:235px"
						)#
					</div>
				</div>
				<!--- <div class="row">
					<label for="spec2">Specialization</label>
					#selectTag(
						includeBlank="None selected",
						name="specialty",
						options=specializations
					)#
				</div> --->
				<div class="btn">
					#buttonTag(content="SEARCH",id="advancedsearch",type="button",class="btn-search")#
				</div>
			</fieldset>
		</form>
	</div>
</cfoutput>