<center>
<table class="testtable">
	<tr>
		<td colspan="2">
			Things to consider when testing the search page:
			<ul>
			<li>Filters: Try adding a filter, and see if the search result count matches the predicted value for that filter.</li>
			<li>Map: Take a look at the map and see if it is properly centered and zoomed over the area searched.</li>
			<li>Featured Carousel: This zone searched for the carousel will change whenever a zip code is searched, or when city AND state have been specified. Defining a specialty or procedure will narrow down the carousel results.</li>
			</ul>
			<a href="#citydistance">City-Distance search cases</a>
		</td>
	</tr>
	<tr>
		<th class="casecolumn">Test Case</th>
		<th class="notecolumn">Notes</th>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/">Blank search</a></td>
		<td>Should automatically dump you into the search form</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-flaffanargan/">Gibberish</a></td>
		<td>Should automatically dump you into the search form</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-Orlando%2C_FL/">City-wide search: Orlando, FL</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-Florida/">State-wide search: Florida</a></td>
		<td>Should display all doctors in Florida</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-32803/">Zip search: 32803</a></td>
		<td>Should display only doctors within the zip code</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-Orlando%2C_FL_32803/">Orlando, FL 32803</a></td>
		<td>Should be identical to zip search above</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-90210/">90210</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-90210/distance-10">90210, 10-mile radius</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-Orlando%2C_FL/distance-10/">Orlando, FL, 10-mile radius</a></td>
		<td>Should return all doctors from the Orlando area, plus doctors within 10 miles of Orlando's boundaries</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-90210/distance-25">90210, 25-mile radius</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-19107/distance-25/">19107, 25-mile radius</a></td>
		<td>Philadelphia</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-19107/distance-25/">19107, Pennsylvania, 25-mile radius</a></td>
		<td>Cities and states are ignored if a zip code is present, therefore this should include results from neighboring states, and is identical to the one above.</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-springfield/">Springfield</a></td>
		<td>Should return results from all Springfields</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-Springfield%2C_KY/">Springfield, KY</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-Dishwater%2C_KY/">Dishwater, KY</a></td>
		<td>Ficticious city name. Will search Kentucky instead.</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-Orlando%2C_KY/">Orlando, KY</a></td>
		<td>Real city name, incorrect state. Will search Kentucky instead.</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-California/name-slaughter/">Doctors named Slaughter in California</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/name-slaughter/">Doctors named Slaughter in the US</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-California/name-Slaug/">Doctors named Slaug in California</a></td>
		<td>Partial name search; should be same as searching for Slaughter</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-California/name-laughter/">Doctors named Laughter in California</a></td>
		<td>Partial name searches should not check in reverse, therefore this should return no results</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/specialty-9/">Plastic Surgery, USA</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/specialty-9/location-Orlando%2C_FL/">Orlando, FL Plastic Surgery</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/specialty-9/location-90210">90210, Plastic Surgery</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/specialty-9/location-90210/distance-25">90210 + 25 mile radius, Plastic Surgery</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/specialty-9/location-90210/distance-25/procedure-2">90210 + 25 mile radius, Plastic Surgery, Abdominal Liposuction (Liposculpture) 2: Freddy's Revenge</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-90210/distance-10/name-Slaughter/specialty-5/">Chiropractors named Slaughter within 10 miles of 90210</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/procedure-991">Kickboxing doctors</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/procedure-194">Doctors with sweaty feet</a></td>
		<td>There are quite a lot of them</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/procedure-976">Doctors with diabetic shoes</a></td>
		<td>There are even more of these</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/procedure-974">Podiatric Surgeons</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/bodypart-27">Doctors associated with the face</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/bodypart-35">Doctors associated with the feet</a></td>
		<td>Surprisingly, does not include kickboxing, sweaty feet, or diabetic shoes</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-CA/location-Toronto%2C_ON/">Toronto, ON, Canada</a></td>
		<td>Canadian search is work-in-progress</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-CA/location-M5B1W8/">M5B1W8, Canada</a></td>
		<td>Canadian search is work-in-progress</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-CA/location-M5B_1W8/">M5B 1W8, Canada</a></td>
		<td>Canadian search is work-in-progress</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-CA/location-M5B%2D1W8/">M5B-1W8, Canada</a></td>
		<td>Canadian search is work-in-progress</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-CA/specialty-5/">Chiropractors in Canada</a></td>
		<td>Canadian search is work-in-progress</td>
	</tr>
</table>

<table class="testtable" id="citydistance">
	<tr>
		<td colspan="2">
			<h1 style="color:#111; margin-left:230px;">City-Distance search</h1>
			<p>All links in this category will define a variable, which will cause the search area to be rendered on the map.</p>
			<p>This variable will persist for as long as you stay within the doctor search. You may change pages, filters, and locations.</p>
			<p>Two shapes will be rendered onto the map:</p>
			<ul>
				<li>The blue shape represents the smallest area that contains all midpoints of postal regions within the city.</li>
				<li>The green shape represents the full search area. Its edges are spread away from the blue shape at a length equal to the distance the user provided, plus 2 miles to compensate for the size of a postal region.</li>
			</ul>
		</td>
	</tr>
	<tr>
		<th class="casecolumn">Test Case</th>
		<th class="notecolumn">Notes</th>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-Orlando%2C_FL/distance-1/plottest-1">Orlando, FL, 1-mile</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-Orlando%2C_FL/distance-3/plottest-1">Orlando, FL, 3-mile</a></td>
		<td>The map here is a bit more zoomed out, as the google maps API is set to automatically position and zoom the view to fit the bounding region.</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-Orlando%2C_FL/distance-10/plottest-1">Orlando, FL, 10-mile</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-winter_park%2C_fl/distance-3/plottest-1">Winter Park, FL, 3-mile</a></td>
		<td>Winter Park has only two viable postal code regions. Additional points are added to define a polygon.</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-maitland%2C_fl/distance-5/plottest-1">Maitland, FL, 5-mile</a></td>
		<td>Maitland has only one viable postal code region. Additional points are added to define a polygon.</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-new_york%2C_ny/distance-1/plottest-1">New York, NY, 1-mile</a></td>
		<td>Traces Manhattan rather nicely</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-los_angeles%2C_ca/distance-5/plottest-1">Los Angeles, CA, 5-mile</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-las_vegas%2C_nv/distance-2/plottest-1">Las Vegas, NV, 2-mile</a></td>
		<td>Note that the shape stretches to nearby Mt. Charleston, as it contains a Las Vegas postal region.</td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-seattle%2C_wa/distance-2/plottest-1">Seattle, WA, 2-mile</a></td>
		<td></td>
	</tr>
	<tr>
		<td><a target="_blank" href="/doctors/search/country-US/location-tampa%2C_fl/distance-20/plottest-1">Tampa, FL, 20-mile</a></td>
		<td>Pulls many doctors from St. Petersburg. If you look at the compare doctor tool, you can see the distance these doctors are from Tampa.</td>
	</tr>
</table>

<cfset stateses = model("State").findAll(
	select="abbreviation,name",
	where="countryId = 102",
	order="name asc"
)>
<cfset statesies = model("State").findAll(
	select="abbreviation,name",
	where="countryId = 12",
	order="name asc"
)>
<select>
<option value="">Select State</option>
<option value="">-- United States --</option>
<cfoutput query="stateses">
<option value="#abbreviation#">#name#</option>
</cfoutput>
<option value=""></option>
<option value="">-- Canada --</option>
<cfoutput query="statesies">
<option value="#abbreviation#">#name#</option>
</cfoutput>
</select>
</center>