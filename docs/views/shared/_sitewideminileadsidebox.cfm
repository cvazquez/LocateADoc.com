<cfparam name="arguments.isPopup" default="false">
<cfparam name="arguments.isRedundant" default="false">
<cfparam name="arguments.lockFields" default="false">
<cfparam name="arguments.smallBlock" default="false">
<cfparam name="arguments.widgetContent" default="Use the form below to request more information from a doctor in your area.">

<cfparam name="params.specialty" default="">
<cfparam name="params.procedure" default="">
<cfparam name="params.name" default="">
<cfparam name="params.firstname" default="">
<cfparam name="params.lastname" default="">
<cfparam name="params.email" default="">
<cfparam name="params.zip" default="">
<cfparam name="params.postalCode" default="">
<cfparam name="params.phone" default="">
<cfparam name="hasContactForm" default="">
<cfparam name="isPastAdvertiser" default="0">

<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1>
	<cfset params = Request.oUser.appendUserInfo(params)>
</cfif>


<cfset redundant = Iif(arguments.isRedundant,DE('R'),DE(''))>

<!--- <cfif Len(flash("SWminiErrorList")) gt 0 and ListGetAt(flash("SWminiErrorList"),1) eq 2>
	<cfset sideLeadFormOn = true>
	<cfif Len(flash("SWminiFormData")) gt 0>
		<cfset params.specialty = Replace(ListGetAt(flash("SWminiFormData"),1),"sp=","")>
		<cfset params.procedure = Replace(ListGetAt(flash("SWminiFormData"),2),"pr=","")>
		<cfset params.name = Replace(ListGetAt(flash("SWminiFormData"),3),"na=","")>
		<cfset params.email = Replace(ListGetAt(flash("SWminiFormData"),4),"em=","")>
		<cfset params.zip = Replace(ListGetAt(flash("SWminiFormData"),5),"zp=","")>
		<cfset params.phone = Replace(ListGetAt(flash("SWminiFormData"),6),"ph=","")>
	</cfif>
<cfelse>
	<cfset sideLeadFormOn = false>
</cfif> --->

<cfif params.controller eq "resources">
	<cfset SWpositionID = 7> <!--- Resources --->
<cfelseif params.controller eq "pictures">
	<cfset SWpositionID = 8> <!--- Gallery --->
<cfelseif params.controller eq "profile" and isPastAdvertiser>
	<cfset SWpositionID = 10> <!--- Past advertiser --->
<cfelse>
	<cfset SWpositionID = 9> <!--- Basic listings --->
</cfif>

<cfoutput>

	<cfif arguments.isPopup>

		<a href="##" onclick="showSWbox(); return false;" class="btn-contact SWbutton">CONTACT A DOCTOR</a>
		<div class="SW-popup-box hidden">

			<table class="modal-box">
				<tr class="row-buttons">
					<td colspan="2"><div class="closebutton" onclick="hideSWbox(); return false;"></div></td>
				</tr>
				<tr class="row-t">
					<td class="l-t"></td>
					<td class="t"></td>
				</tr>
				<tr class="row-c">
					<td class="l"></td>
					<td class="c">

						<p>#arguments.widgetContent#</p>
						<p class="invalid-message" id="#Redundant#SWinvalid" style="display:none;">Your submission contains invalid information. Please correct the highlighted fields.</p>


	<cfelse>

		<!-- sidebox -->
		<div class="<cfif arguments.smallBlock>small-block<cfelse>sidebox</cfif>">
			<div class="frame">
				<cfif arguments.smallBlock>
				<h3>Contact a <strong>Doctor</strong></h3>
				<cfelse>
				<h4>Contact a <strong>Doctor</strong></h4>
				</cfif>
				<!--- <cfif params.controller eq "profile"> --->
					<p>#arguments.widgetContent#</p>
				<!--- </cfif> --->
				<div class="minilead-box">
					<p class="invalid-message" id="#Redundant#SWinvalid" style="display:none;">Your submission contains invalid information. Please correct the highlighted fields.</p>
	<!--- 				<script type="text/javascript">
						$(function(){
							window.scrollTo(0,$('.SWminilead-box .invalid-message').offset().top);
						});
					</script> --->

	</cfif>

						<form id="#Redundant#SWmini" class="FBpop" name="#Redundant#contactadoctor_sidebox" action="" method="post">
							<!--- <div id="SWfield_specialty">
								<h5>Specialty</h5>
								<div class="stretch-input"><span><input type="text" id="#Redundant#SWspecialty" class="noPreText" <cfif IsDefined("SpecialtyInfo.name")>value="#SpecialtyInfo.name#" disabled</cfif> /></span></div>
							</div>
							<div id="SWfield_procedure">
								<h5>Procedure</h5>
								<div class="stretch-input"><span><input type="text" id="#Redundant#SWprocedure" class="noPreText" <cfif IsDefined("ProcedureInfo.name")>value="#ProcedureInfo.name#" disabled</cfif> /></span></div>
							</div> --->
							<div id="SWfield_procedure">
								<h5 style="font-size:14px; line-height:15px;">
									Procedure of Interest
									<cfif not (IsDefined("ProcedureInfo.name") and ProcedureInfo.name neq "")>
										<div style="float:right; margin-right:3px; cursor:pointer; font-size:13px;" class="tooltip" title=" | <div style='width:200px;'>To select a procedure, start typing into the field. A list of matching procedure names will appear. Select the procedure you want from this list.<br><br>If you are uncertain of the name of your desired procedure, you can select from a comprehensive procedure list by clicking this icon.</div>">
											<img src="/images/layout/ico-about.gif" onclick="SWProcOpen('#Redundant#SWprocedure');">
										</div>
									</cfif>
								</h5>
								<div class="stretch-input"><span><input type="text" id="#Redundant#SWprocedure" class="noPreText" <cfif IsDefined("ProcedureInfo.name") and ProcedureInfo.name neq "">value="#ProcedureInfo.name#" <cfif arguments.lockFields>disabled</cfif><!--- <cfelseif IsDefined("SpecialtyInfo.name")>value="#SpecialtyInfo.name#" <cfif arguments.lockFields>disabled</cfif> ---></cfif> /></span></div>
							</div>
							<div id="SWfield_name">
								<h5 style="font-size:14px; line-height:15px;">Patient Name</h5>
								<div class="stretch-input"><span><input type="text" class="noPreText" name="name" value="#params.firstname# #params.lastname#" /></span></div>
							</div>
							<div id="SWfield_email">
								<h5 style="font-size:14px; line-height:15px;">Email Address</h5>
								<div class="stretch-input"><span><input type="text" class="noPreText" name="email" value="#params.email#" /></span></div>
							</div>
							<div id="SWfield_zip">
								<h5 style="font-size:14px; line-height:15px;">Zip Code</h5>
								<div class="stretch-input"><span><input type="text" class="noPreText" name="zip" value="#params.postalCode#" /></span></div>
							</div>
							<div id="SWfield_phone">
								<h5 style="font-size:14px; line-height:15px;">Daytime Phone</h5>
								<div class="stretch-input"><span><input type="text" class="noPreText" name="phone" value="#params.phone#" /></span></div>
								<!--- <p class="optionalReminder">(optional)</p> --->
							</div>
							<div id="SWfield_comments">
								<!--- <h5>Comments</h5>
								<p class="optionalReminder">(optional)</p> --->
								<a href="##" onclick="$('###Redundant#SWmini textarea').slideDown();return false;">Add a comment or question</a>
								<textarea name="comments" cols="10" rows="4" style="display:none;" class="noPreText"></textarea>
							</div>
							<div class="login-set" style="margin:10px 0; float:right; padding-right:5px;">
								#Request.oUser.getCheckBox(label="Save my information")#
							</div>
							<div style="clear:both;"></div>
							<div class="btn">
								<input type="hidden" name="position" value="#SWpositionID#">
								<input type="button" class="btn-contactadoc" onclick="#Redundant#SWminiOpen();" />
							</div>
						</form>

	<cfif arguments.isPopup>

					</td>
				</tr>
				<tr class="row-b">
					<td class="l-b"></td>
					<td class="b"></td>
				</tr>
			</table>
		</div>

	<cfelse>

				</div>
			</div>
		</div>

	</cfif>

	<cfif not arguments.isRedundant>

		<div class="SWmini-modal hidefirst">
			<center>
				<table class="modal-box">
					<tr class="row-buttons">
						<td colspan="2"><div class="closebutton" onclick="SWminiClose(); return false;"></div></td>
					</tr>
					<tr class="row-t">
						<td class="l-t"></td>
						<td class="t"></td>
					</tr>
					<tr class="row-c">
						<td class="l"></td>
						<td class="c" id="doctor-review">

						</td>
					</tr>
					<tr class="row-b">
						<td class="l-b"></td>
						<td class="b"></td>
					</tr>
					<!--- <tr class="row-buttons">
						<td colspan="2">
							<div class="backbutton"></div>
							<div class="nextbutton"></div>
						</td>
					</tr> --->
				</table>
			</center>
		</div>

		<div class="SWproc-box hidefirst">
			<center>
				<table class="modal-box">
					<tr class="row-buttons">
						<td colspan="2"><div class="closebutton" onclick="SWProcClose(); return false;"></div></td>
					</tr>
					<tr class="row-t">
						<td class="l-t"></td>
						<td class="t"></td>
					</tr>
					<tr class="row-c">
						<td class="l"></td>
						<td class="c">
							<div id="SW-procedure-list"></div>
						</td>
					</tr>
					<tr class="row-b">
						<td class="l-b"></td>
						<td class="b"></td>
					</tr>
					<!--- <tr class="row-buttons">
						<td colspan="2">
							<div class="backbutton"></div>
							<div class="nextbutton"></div>
						</td>
					</tr> --->
				</table>
			</center>
		</div>

	</cfif>

</cfoutput>