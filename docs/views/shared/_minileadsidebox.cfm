<cfparam name="params.firstname" default="">
<cfparam name="params.lastname" default="">
<cfparam name="params.email" default="">
<cfparam name="params.phone" default="">
<cfparam name="params.procedures" default="">
<cfparam name="hasContactForm" default="false">

<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1>
	<cfset params = Request.oUser.appendUserInfo(params)>
</cfif>

<cfif NOT hasContactForm>
	<cfoutput>#includePartial(partial="/shared/sitewideminileadsidebox", isRedundant=true)#</cfoutput>
	<cfexit>
</cfif>

<!--- <cfset structAppend(params, getUserInfo())> --->

<cfif Len(Variables.miniErrorList) gt 0 and ListGetAt(Variables.miniErrorList,1) eq 2>
	<cfset sideLeadFormOn = true>
	<cfif Len(Variables.miniFormData) gt 0>
		<cfset params.firstname = Replace(ListGetAt(Variables.miniFormData,1),"fn=","")>
		<cfset params.lastname = Replace(ListGetAt(Variables.miniFormData,2),"ln=","")>
		<cfset params.email = Replace(ListGetAt(Variables.miniFormData,3),"em=","")>
		<cfset params.phone = Replace(ListGetAt(Variables.miniFormData,4),"ph=","")>
	</cfif>
<cfelse>
	<cfset sideLeadFormOn = false>
</cfif>

<cfoutput>
	<!-- sidebox -->
	<div class="sidebox">
		<div class="frame">
			<h4>Contact the <strong>Doctor</strong></h4>
			<cfif params.controller eq "profile">
				<cfif currentLocationDetails.phonePlus neq "">
					<p>Please contact our office at <b>#formatPhone(currentLocationDetails.phonePlus)#</b> or complete the form below to request more information from #doctor.fullNameWithTitle#<cfif Right(doctor.fullNameWithTitle,1) neq ".">.</cfif></p>
				<cfelse>
					<p>Use the form below to request more information from #doctor.fullNameWithTitle#.</p>
				</cfif>
			<cfelseif params.controller eq "pictures" and params.action eq "case">
				<cfset formattedPhone = formatPhone(doctors.phone)>
				<cfif formattedPhone neq "">
					<p>Please contact our office at <b>#formattedPhone#</b> or complete the form below to request more information from #doctor.fullNameWithTitle#<cfif Right(doctor.fullNameWithTitle,1) neq ".">.</cfif></p>
				<cfelse>
					<p>Use the form below to request more information from #doctor.fullNameWithTitle#.</p>
				</cfif>
			</cfif>
			<div class="minilead-box">
				<!--- <p>Enter text here</p> --->
				<cfif sideLeadFormOn>
					<p class="invalid-message">Your submission contains invalid information. Please correct the highlighted fields.</p>
					<script type="text/javascript">
						$(function(){
							window.scrollTo(0,$('.minilead-box .invalid-message').offset().top);
						});
					</script>
				</cfif>
				<form	name="contactus_sidebox"
						class="FBpop"
						action="#URLFor(	controller	= "#doctor.siloname#",
											action		= "contact",
											protocol	= "#(Server.ThisServer neq "dev" ? 'https' : '')#",
											onlyPath	= "#(Server.ThisServer neq "dev" ? 'false' : 'true')#"
								)#"
						method="post">
					<div <cfif ListFind(Variables.miniErrorList,"firstname") and sideLeadFormOn>class="invalidData"</cfif>>
						<h5>First Name</h5>
						<div class="stretch-input"><span><input type="text" class="noPreText" name="firstname" value="#params.firstname#" /></span></div>
					</div>
					<div <cfif ListFind(Variables.miniErrorList,"lastname") and sideLeadFormOn>class="invalidData"</cfif>>
						<h5>Last Name</h5>
						<div class="stretch-input"><span><input type="text" class="noPreText" name="lastname" value="#params.lastname#" /></span></div>
					</div>
					<div <cfif ListFind(Variables.miniErrorList,"email") and sideLeadFormOn>class="invalidData"</cfif>>
						<h5>Email Address</h5>
						<div class="stretch-input"><span><input type="text" class="noPreText" name="email" value="#params.email#" /></span></div>
					</div>
					<div <cfif ListFind(Variables.miniErrorList,"phone") and sideLeadFormOn>class="invalidData"</cfif>>
						<h5>Daytime Phone</h5>
						<div class="stretch-input"><span><input type="text" class="noPreText" name="phone" value="#params.phone#" /></span></div>
					</div>
					<cfif variables.procedures.recordcount>
						<div>
							<h5>
								Procedures of Interest
								<sub style="font-size: 10px; line-height: 10px; margin-left: 4px; margin-top: 0px;">(optional)</sub>
							</h5>
							<style type="text/css">
								.stretch-button{
									cursor: pointer;
								}
								.stretch-button span{
									width:147px;
									color: ##7F7F7F;
	 								font: 14px/18px BreeOblique,Arial,Helvetica,sans-serif;
									text-align:center;
								}
								.stretch-button:hover span{
									color: ##555555;
								}
								.mini-procedure-list{
									display:inline-block;
								}
								.mini-procedure-list ul{
									width:150px;
									padding: 0 0 0 15px;
									margin:0;
								}
								.procedures-modal .clear-button,
								.procedures-modal .done-button{
									background: url("/images/layout/btn-search.png") no-repeat scroll 0 0 transparent;
								    border: 0 none;
								    color: ##FFFFFF;
								    cursor: pointer;
								    display: block;
								    font: 12px/30px BreeBold,Arial,Helvetica,sans-serif;
								    height: 30px;
								    margin: 0;
								    padding: 0 0 2px;
								    text-align: center;
								    text-decoration: none;
								    width: 94px;
								}
								.procedures-modal .clear-button{
									float:left;
								}
								.procedures-modal .done-button{
									float:right;
								}
							</style>
							<script type="text/javascript">
								$(function(){
									$('.procedures-modal').dialog({
										autoOpen:false,
										draggable:false,
										resizable:false,
										modal:true,
										closeText:'',
										dialogClass:'compare-dialog',
										width:977,
										show:'fade',
										hide:'fade'
									});
								});
								function procedureSelectionShow(){
									$('.procedures-modal').dialog('open');
								}
								function procedureSelectionHide(){
									var selectedProcedures = $(".procedures-checklist input:checked");
									var procedureList = "";
									if(selectedProcedures.length > 0){
										$(".mini-procedure-list").html("<ul></ul>");
										selectedProcedures.each(function(){
											$(".mini-procedure-list ul").append("<li>"+$('label[for="'+$(this).attr("id")+'"]').html()+"</li>");
											procedureList += ((procedureList!="") ? "," : "") + $(this).val();
										});
										$("##ML-procedures").val(procedureList);
									}else{
										$(".mini-procedure-list").html("");
									}
									$('.procedures-modal').dialog('close');
								}
								function clearProcedures(){
									$(".procedures-checklist .checkboxAreaChecked").each(function(){$(this).click()});
								}
							</script>
							<div class="stretch-input stretch-button" onclick="procedureSelectionShow();"><span>Select Procedures</span></div>
							<div class="mini-procedure-list"></div>
						</div>
					</cfif>
					<div class="login-set" style="margin:10px 0; float:right; padding-right:5px;">
						#Request.oUser.getCheckBox()#
					</div>
					<div style="clear:both;"></div>
					<div class="btn">
						<input type="hidden" name="process_mini" value="2">
						<input type="hidden" id="ML-procedures" name="procedures" value="#params.procedures#">
						<input type="button" class="btn-search" value="Submit" onclick="submit();" />
					</div>
					<cfif variables.procedures.recordcount>
					<div class="procedures-modal hidefirst">
						<table class="modal-box">
							<tr class="row-buttons">
								<td colspan="2"><div class="closebutton" onclick="procedureSelectionHide(); return false;"></div></td>
							</tr>
							<tr class="row-t">
								<td class="l-t"></td>
								<td class="t"></td>
							</tr>
							<tr class="row-c">
								<td class="l"></td>
								<td class="c">
									<div>
										<h3>Select any procedures of interest:</h3>
										<div class="procedures-checklist">
											<cfloop query="variables.procedures">
												<div class="procedure">
													<input id="procedureId#variables.procedures.id#" type="checkbox" name="MLP" value="#variables.procedures.id#" <cfif ListFind(params.procedures,procedures.id) gt 0>checked </cfif>>
													<p><label class="procedure-list-labels<!---  tooltip --->" for="procedureId#variables.procedures.id#" style="margin-left:0;font: 13px/20px BreeLight, Arial, Helvetica, sans-serif; letter-spacing:-1px;" title="#variables.procedures.name#">#variables.procedures.name#</label></p>
												</div>
											</cfloop>
										</div>
										<input type="button" class="clear-button" value="CLEAR" onclick="clearProcedures();" />
										<input type="button" class="done-button" value="DONE" onclick="procedureSelectionHide();" />
									</div>
								</td>
							</tr>
							<tr class="row-b">
								<td class="l-b"></td>
								<td class="b"></td>
							</tr>
						</table>
					</div>
					</cfif>
				</form>
			</div>
		</div>
	</div>
</cfoutput>