<cfoutput>
	<ul class="add-nav">
		<li><a href="/" class="home-link">Home</a></li>
		<li><a href="/resources/blog-list" class="blog-link">Blog</a></li>
		<li><a href="##"class="newsletter" onclick="showNewsletter(); return false;">Newsletter Signup</a></li>
		<li><a href="/doctor-reviews" class="about">Doctor Reviews</a></li>
	</ul>
	<div class="newsletter-box hidden">
		<div class="closebutton" onclick="hideNewsletter(); return false;"></div>
		<div class="t"></div>
		<div class="c">
		<form name="newsletterform" onsubmit="NewsletterSubscribe(this.email.value); return false;">
			<label for="email">Email:</label>
			<div class="stretch-input"><span><input class="noPreText" type="text" name="email" value="#Request.oUser.email#" /></span></div>
			<div class="btn">
				<input type="submit" value="Subscribe" class="btn-compare">
				<p class="message">&nbsp;</p>
			</div>
		</form>
		</div>
		<div class="b"></div>
	</div>

	<div id="fb-root"></div>
	<script type="text/javascript" src="/javascripts/facebook.js"></script>

	<div class="sign-in-field login-set">

	<!--- <a class="fb_button fb_button_medium fb-hidefirst login-set" style="display:block;" onclick="OpenLoginBox();"><span class="fb_button_text">Login</span></a> --->
	<a class="fb-hidefirst user-link" onclick="OpenLoginBox();">Sign In</a>

	<div class="login-modal hidefirst">
		<table class="modal-box" style="width:350px;">
			<tr class="row-buttons">
				<td colspan="2"><div class="closebutton" onclick="CloseLoginBox(); return false;"></div></td>
			</tr>
			<tr class="row-t">
				<td class="l-t"></td>
				<td class="t"></td>
			</tr>
			<tr class="row-c">
				<td class="l"></td>
				<td class="c">
					<div>
						<p class="login-heading">Welcome!</p>
						<p>To personalize your LocateADoc.com experience, sign in below.</p>
						<center>
						<!--- <a class="fb_button fb_button_large fb-login"><span class="fb_button_text">Sign in with Facebook</span></a> --->
						<div class="facebook-sign-in fb-login"></div>
						</center>
						<p class="login-sub">Information provided remains private and will not be used without your permission.</p>
						<br>
						<p>Questions? Have a look through the LocateADoc.com <a href="/home/terms">Conditions of Use</a>.</p>
					</div>
				</td>
			</tr>
			<tr class="row-b">
				<td class="l-b"></td>
				<td class="b"></td>
			</tr>
		</table>
	</div>

	<!--- <a class="fb_button fb_button_medium fb-hidefirst fb-logout" style="display:block;"><span class="fb_button_text">Logout</span></a> --->
	<!--- <a href="##" id="fb-login">Login</a>
	<a href="##" id="fb-logout">Logout</a> --->
	</div>
</cfoutput>