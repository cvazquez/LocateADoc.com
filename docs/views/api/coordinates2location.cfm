<cfoutput>
	<h1>Location API</h1>
	<form action="#URLfor(action="coordinates2location")#">
		<table>
			<tr>
				<td>
					<label for="lat">Latitude:</label>
				</td>
				<td>
					<input type="text" name="lat" value="#params.lat#"><br />
				</td>
			</tr>
			<tr>
				<td>
					<label for="lat">Longitude:</label>
				</td>
				<td>
					<input type="text" name="lon" value="#params.lon#">
				</td>
			</tr>
			<tr>
				<td colspan="2" align="right">
					<input type="submit">
				</td>
			</tr>
		</table>
	</form>
	<cfif params.lat neq "">
		<h2>Location Response</h2>
		<table>
			<cfloop collection="#location#" item="i">
				<tr>
					<td align="right">response.#i# = </td>
					<td>#location[i]#</td>
				</tr>
			</cfloop>
		</table>
	</cfif>
</cfoutput>