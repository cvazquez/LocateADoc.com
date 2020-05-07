<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1>
	<cfset params = Request.oUser.appendUserInfo(params)>
</cfif>

<cfset javaScriptIncludeTag(source="profile/comments", head=true)>
<cfset styleSheetLinkTag(source="profile/comments", head=true)>
<!-- content -->
<div class="content print-area">
	<div class="welcome-box">
		<h1 id="commenttop"><cfoutput>#doctor.fullNameWithTitle# Reviews</cfoutput></h1>
		<cfif successMessage neq "">
			<h3 style="color:black;"><cfoutput>#successMessage#</cfoutput></h3>
		</cfif>
		  <!--- <p>Your first-hand experiences really help other patients. Thanks!</p>
		  <p>What makes a good review?</p>
		  <ul>
			<li>Write about your overall experiences</li>
			<li>Write about what you like or dislike about your physician</li>
			<li>Write about whether you would recommend</li>
			<li>Write as if you are talking to a peer who is asking your opinion</li>
			<li>Not too short and not too long. Aim for between 75 and 300 words</li>
		  </ul> --->
		  <p>Ready to share your story about <b><cfoutput>#doctor.fullNameWithTitle#</cfoutput></b>? Select <b>"Add a Review"</b> to get started.</p>
		<h2><a href="#" class="comment-link" id="comment-open">Add a Review</a></h2>

<!--- 		<div class="comment-modal hidefirst">
			<center>
				<table class="modal-box comment-box">
					<tr class="row-buttons">
						<td colspan="2"><div class="closebutton"></div></td>
					</tr>
					<tr class="row-t">
						<td class="l-t"></td>
						<td class="t"></td>
					</tr>
					<tr class="row-c">
						<td class="l"></td>
						<td class="c"> --->

			<div class="add-comment" id="addcomment" style="display:none;">
				<h2><a href="#" class="comment-link" id="comment-close">Add a Review</a></h2>
				<cfoutput>
				#LinkTo(controller="home",action="terms",anchor="reviewguidelines",target="_blank",class="terms-link",text="Review and Comment Posting Guidelines")#
				<cfif errorList neq "">
					<h3 class="invalid-input">There are errors in your form input. Please resolve the issues in each highlighted field and submit the form again.</h3>
				</cfif>
				<form name="addcomment" class="FBpop" action="#params.silourl#" method="post">
					<fieldset>
						<div class="row login-set">
							<!--- <a class="fb_button fb_button_large fb-login login-set fb-hidefirst"><span class="fb_button_text">Complete with Facebook</span></a> --->
							<label class="full">To submit a review, please Sign in with Facebook or complete the fields below.</label>
							<div class="facebook-sign-in fb-login"></div>
						</div>
						<div style="width:400px;float:left;">
							<div class="row">
								<label <cfif ListFind(errorList,"firstname")>class="invalid-input" </cfif>for="firstname">First Name</label>
								<div class="styled-input" style="width: 245px; height:20px;"><input style="width:209px;" name="firstname" id="firstname" type="text" class="noPreText" value="#params.firstname#" /></div>
							</div>
							<div class="row">
								<label <cfif ListFind(errorList,"lastname")>class="invalid-input" </cfif>for="lastname">Last Name</label>
								<div class="styled-input" style="width: 245px; height:20px;"><input style="width:209px;" name="lastname" id="lastname" type="text" class="noPreText" value="#params.lastname#" /></div>
							</div>
							<div class="row show-name">
								<input type="checkbox" name="showname" id="showname" value="1" <cfif params.showname eq 1>checked </cfif>/>
								<label for="showname">Show my first name with my recommendation</label>
							</div>
							<div class="row show-name fb-only" style="display:none;">
								<input type="checkbox" name="showphoto" id="showphoto" value="1" onchange="updateFBPhotoPreview();" <cfif params.showphoto eq 1>checked </cfif>/>
								<label for="showphoto">Show my facebook profile photo</label>
							</div>
							<div class="row">
								<label <cfif ListFind(errorList,"city")>class="invalid-input" </cfif>for="city">City</label>
								<div class="styled-input" style="width: 245px; height:20px;"><input style="width:209px;" name="city" id="city" type="text" class="noPreText" value="#params.city#" /></div>
							</div>
							<div class="row">
								<label <cfif ListFind(errorList,"state")>class="invalid-input" </cfif>for="state">State</label>
									<div class="styled-select" style="width: 245px;">
									<select name="state" id="state" class="comment-states" style="width:265px;">
										<option value="">Select State</option>
										<cfset currentCountry = "">
										<cfloop query="states">
											<cfif states.country neq currentCountry>
												<cfif currentrow gt 1><option value="">&nbsp;</option></cfif>
												<cfset currentCountry = states.country>
												<option value="">--#states.country#--</option>
											</cfif>
											<option name="state_#id#" value="#id#" <cfif params.state eq id>selected </cfif>>#name#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="row">
								<label <cfif ListFind(errorList,"email")>class="invalid-input" </cfif>for="email">Email</label>
								<div class="styled-input" style="width: 245px; height:20px;"><input style="width:209px;" name="email" id="email" type="text" class="noPreText" value="#params.email#" /></div>
							</div>
						</div>
						<div id="facebookPhotoPreview" class="fb-only" style="float:left;clear:right;border:2px solid ##96B8B7;padding:4px;display:none;"></div>
						<cfif variables.procedures.recordcount gt 0>
						<div class="row">
							<label class="full<cfif ListFind(errorList,"procedures")> invalid-input</cfif>">Procedures Performed</label>
							<div class="procedures-checklist">
								<cfloop query="variables.procedures">
									<div class="procedure">
										<input id="procedureId#variables.procedures.id#" type="checkbox" name="procedures" value="#variables.procedures.id#" <cfif ListFind(params.procedures,procedures.id) gt 0>checked </cfif>>
										<p><label class="procedure-list-labels tooltip" for="procedureId#variables.procedures.id#" style="margin-left:0;font: 13px/20px BreeLight, Arial, Helvetica, sans-serif; width:175px; letter-spacing:-1px;" title="#variables.procedures.name#">#variables.procedures.name#</label></p>
									</div>
								</cfloop>
							</div>
						</div>
						</cfif>
						<div class="row">
							<cfset params.reviewComment = htmlEditFormat(params.reviewComment)>
							<cfset newline = chr(13) & chr(10) & chr(13) & chr(10)>
							<!--- <cfset params.reviewComment = rereplace(params.reviewComment, "(\f|\n|\r|\r\n)*", "[return]", "all")> --->

							<label <cfif ListFind(errorList,"comments")>class="invalid-input" </cfif>for="reviewComment">Comments</label>
							<textarea cols="75" name="reviewComment" rows="8" wrap="physical" id="reviewComment">#params.reviewComment#</textarea>
						</div>
						<div class="row">
							<label class="full<cfif ListFind(errorList,"rating")> invalid-input</cfif>">How likely are you to recommend this doctor?</label>
							<div class="rating-container">
								<div class="rating-slider"> </div>
								<div class="rating-display">#params.rating#</div>
								<div class="rating-scale">
									<div class="rating-0">Extremely Unlikely</div>
									<div class="rating-10">Extremely Likely</div>
								</div>
							</div>
						</div>
						<input type="hidden" name="rating" id="rating" value="#params.rating#">
						<div class="row">

							<label class="full<cfif ListFind(errorList,"captcha")> invalid-input</cfif>">Please enter the numbers pictured to the right:</label>
							<div class="styled-input captcha-input" style="width: 245px; height:20px;"><input style="width:209px;" type="text" class="noPreText" name="captcha_input"></div>
							<input type="hidden" name="captcha_check" value="#captcha_check#">
							<div class="captcha">
								<cfimage
									 action="captcha"
									 height="52"
									 width="250"
									 text="#rand_num#"
									 difficulty="high"
									 fonts="DejaVu LGC Sans"
									 fontsize="30"
								/>
							</div>
						</div>
						<div class="row login-set">
							#Request.oUser.getCheckBox(labelStyle="width:300px;margin-left:10px;")#
						</div>
					</fieldset>
					<input type="hidden" name="process_comment" value="1">
					<div class="btn">
						<input type="button" class="btn-search" value="SUBMIT" onclick="submit();">
					</div>
				</form>
				</cfoutput>
			</div>

<!--- 						</td>
					</tr>
					<tr class="row-b">
						<td class="l-b"></td>
						<td class="b"></td>
					</tr>
				</table>
			</center>
		</div> --->
		<cfoutput>
			<div itemscope itemtype="http://schema.org/Product">
				<meta itemprop="name" content="#doctor.fullNameWithTitle#" />
				<div itemprop="aggregateRating" itemscope itemtype="http://schema.org/AggregateRating">
				   <meta itemprop="reviewCount" content = "#recommendations.recordcount#"/>
				   <meta itemprop="worstRating" content = "0"/>
				   <meta itemprop="ratingValue" content = "#aggregateRating#"/>
				   <meta itemprop="bestRating" content = "10"/>
				</div>
			</div>
		</cfoutput>

		<cfif recommendations.recordcount gt 0>
			<cfoutput>
			#IncludePartial("commentpagination")#
			<cfloop query="recommendations">
				<div class="video-holder comment page_#Ceiling(currentrow/5)#<cfif currentrow gt 5> hidden</cfif>" itemprop="review" itemscope itemtype="http://schema.org/Review">
					<table><tr>
					<cfif recommendations.photoLocation neq "">
						<td class="review-photo">
							<img src="#recommendations.photoLocation#" style="float:left; margin-right:15px;">
						</td>
					</cfif>
					<td class="review-body">
						<p itemprop="description">
							<cfset filteredContent = recommendations.content>
							<!--- <cfset filteredContent = REReplace(filteredContent,"\r\n","|","all")>
							<cfset filteredContent = REReplace(filteredContent,"(\r|\n|\|)(\r|\n|\s\|)+","<br><br>","all")>
							<cfset filteredContent = REReplace(filteredContent,"\|","","all")> --->
							<!--- <cfset filteredContent = REReplace(filteredContent,"(\n)","<br>","all")> --->
							<cfset filteredContent = REReplace(filteredContent,"(\r)","<br>","all")>
							<!--- <cfset filteredContent = REReplace(filteredContent,"(\r|\n|\|)(\r|\n|\s\|)+","<br>","all")> --->
							<cfset filteredContent = '<img src="/images/profile/miscellaneous/quote_left.gif" style="margin:0 5px 2px 0;">' & filteredContent & '<img src="/images/profile/miscellaneous/quote_right.gif" style="margin:2px 0 0 5px;">'>
							#paragraphFormat(filteredContent)#
						</p>
						<span itemprop="itemReviewed" itemscope itemtype="http://schema.org/Person">
							<meta itemprop="name" content="#doctor.fullNameWithTitle#" />
						</span>
						<cfif procedureList neq "">
							<p>
								Procedures performed:<br />
								<ul>
									#procedureList#
								</ul>
							</p>
						</cfif>
					</td>
					</tr></table>
					<p align="right">
						<div itemprop="reviewRating" itemscope="" itemtype="http://schema.org/Rating" style="display:none;">
						<meta itemprop="worstRating" content = "0"/>
						<meta itemprop="ratingValue" content = "#rating#"/>
						<meta itemprop="bestRating" content = "10"/>
						</div>
						<span itemprop="datePublished" class="review-date">#DateFormat(createdAt,"medium")#</span>
						<span itemprop="author" class="author-name"><cfif showName>#firstName#<cfelse>Anonymous</cfif></span>,
						#city#, #state#

					</p>
				</div>
			</cfloop>
			#IncludePartial("commentpagination")#
			</cfoutput>
		</cfif>
	</div>

	<cfoutput>
	<!-- image-list -->
	<center>
	<ul class="image-list">
		<cfif financingoptions.recordCount>
		<li>
			<div class="image">
				<a href="#URLFor(action='financing',controller='#doctor.siloname#')#">
					<img src="/images/profile/img5-image-list.jpg" width="175" height="90" alt="Financing" />
					<strong class="caption">Financing</strong>
				</a>
			</div>
		</li>
		</cfif>
		<cfif hasContactForm>
		<li>
			<div class="image">
				<a href="#URLFor(	action		= 'contact',
									controller	= '#doctor.siloname#',
									protocol	= "#(Server.ThisServer neq "dev" ? 'https' : '')#",
									onlyPath	= "#(Server.ThisServer neq "dev" ? 'false' : 'true')#")#">
					<img src="/images/profile/img4-image-list.jpg" width="175" height="90" alt="Contact Us" />
					<strong class="caption">Contact Us</strong>
				</a>
			</div>
		</li>
		</cfif>
		<cfif latestPictures.recordCount>
		<li>
			<div class="image">
				<a href="#URLFor(action='pictures',controller='#doctor.siloname#')#">
					<img src="/images/profile/img7-image-list.jpg" width="175" height="90" alt="Before and After Gallery" />
					<strong class="caption">Before and After Gallery</strong>
				</a>
			</div>
		</li>
		</cfif>
	</ul>
	</center>
	</cfoutput>
</div>

<!--- <cfif errorList neq "">
	<script type="text/javascript">
		$(function(){
			<!--- A strange error occurs if we were to load this page with the anchor,
			so if invalid data is found, jump to the anchor after the page loads --->
			window.scrollTo(0,$('#addcomment').offset().top);
		});
	</script>
</cfif> --->

<!-- aside -->
<div class="aside">
	<cfoutput>
		#includePartial("/shared/minileadsidebox")#
		#includePartial(partial="/shared/sharesidebox",margins="10px 0")#
		<cfif displayAd IS TRUE>
			#includePartial(partial	= "/shared/ad",
							size	= "#adType#300x250")#
		</cfif>
		#includePartial("/shared/proceduresofferedsidebox")#
	</cfoutput>
</div>
<script type="text/javascript">
	$(function(){
		SmartTruncate('.procedure-list-labels',20,175,true);
	});
</script>