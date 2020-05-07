<cfoutput>
	<form action="/pictures/locationtest" method="post">
		<b>Enter a location string:</b>
		<input type="text" name="locstring" value="#params.locstring#">
		<input type="submit">
	</form>
	<p>&nbsp;</p>
	<cfif isStruct(location)>
		<cfif val(len(trim(location.latitude))) and val(len(trim(location.longitude)))>
			<p>
				<a href="http://maps.google.com/maps?q=#location.latitude#+#location.longitude#" target="_new">Check lat & long on Google Maps</a>
			</p>
		</cfif>
		<cfif val(len(trim(location.zipcode)))>
			<p>
				<a href="http://maps.google.com/maps?q=#location.zipcode#" target="_new">Check zipcode on Google Maps</a>
			</p>
		</cfif>
		<cfdump var="#location#">
	</cfif>
</cfoutput>
<p>&nbsp;</p>
Example searches (click 'test' to run test):
<table>
	<tr>
		<th>query</th>
		<th></th>
		<th>expectation</th>
	</tr>
	<tr>
		<td>Orlando</td>
		<td><a href="#">test</a></td>
		<td>Will return everything. City,Ctate,Zip,Country,Long & Lat</td>
	</tr>
	<tr>
		<td>32809</td>
		<td><a href="#">test</a></td>
		<td>Will return everything. City,Ctate,Zip,Country,Long & Lat</td>
	</tr>
	<tr>
		<td>Boston, MA</td>
		<td><a href="#">test</a></td>
		<td>Will return everything. City,Ctate,Zip,Country,Long & Lat</td>
	</tr>
	<tr>
		<td>B0E1C0</td>
		<td><a href="#">test</a></td>
		<td>A Canadian Zipcode. Will return everything.</td>
	</tr>
	<tr>
		<td>XSXSX 21234 DX</td>
		<td><a href="#">test</a></td>
		<td>Since there is a US Zipcode in there, it will return everything for it.</td>
	</tr>
	<tr>
		<td>Miami</td>
		<td><a href="#">test</a></td>
		<td>There are several cities named Miami (in FL,AZ,OK and one in Canada). This will return the one in Canada, but will also return the other records as ALTERNATES</td>
	</tr>
	<tr>
		<td>Miami, NV</td>
		<td><a href="#">test</a></td>
		<td>There is no Miami in Nevada, but state matches will supercede city matches, this will return Nevada but without Zip or Long & Lat</td>
	</tr>
	<tr>
		<td>Calgary</td>
		<td><a href="#">test</a></td>
		<td>A place in Canada</td>
	</tr>
	<tr>
		<td>Salt Lake City</td>
		<td><a href="#">test</a></td>
		<td>This one is interesting because it returns Lake City, FL as an alternate</td>
	</tr>
</table>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script>
<script>
$(function(){
	$("a[href=#]").click(function(event){
		event.preventDefault()
		$("input[name=locstring]").val($(this).parent().prev("td").text())
		$("form").submit()
	})
})
</script>