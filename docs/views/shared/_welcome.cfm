<cfparam name="Client.FacebookPhoto" default="">
<cfoutput>
	<div class="welcome">
		<cfif structKeyExists(Request.oUser, "saveMyInfo") and Request.oUser.saveMyInfo eq 1>
			<p id="welcome_message">
				<cfif Client.FacebookPhoto eq "">
					<img class='welcome-brace' src='/images/empty_pixel.gif'>Welcome #Request.oUser.firstName#!
				<cfelse>
					<img class="fb-photo-small" src="#Client.FacebookPhoto#" />
				</cfif>
				#linkTo(
					text	= "Sign Out",
					onclick	= "forgetMe('#Request.oUser.id#'); return false;",
					href	= "##"
				)#
				<!--- Please <a class="join" href="##">SIGN IN</a> OR <a href="##">JOIN OUR COMMUNITY</a> --->
			</p>
		</cfif>
	</div>
</cfoutput>