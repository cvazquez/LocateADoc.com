<cfoutput>
	<!-- save-search -->
	<div class="save-search cs">
		<h3>Save Your Search Results</h3>
		<cfif structKeyExists(client,"userid") and val(client.userid)>
			<p>
				You can save this customized search to your account for retrieval later on.
			</p>
			<a href="##" class="btn-save">SAVE&nbsp;&nbsp;SEARCH</a>
		<cfelse>
			<p>
				Want to save this search? As a registered user you can save this customized search to your account.
			</p>
			<p>
				<a class="mark" href="##">
					<strong>SIGN IN</strong>
				</a>
				or
				<a href="##">
					JOIN OUR COMMUNITY
				</a>
			</p>
		</cfif>
	</div>
</cfoutput>