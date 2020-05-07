<cfparam name="params.firstname" default="">
<cfparam name="params.lastname" default="">
<cfparam name="params.email" default="">
<cfparam name="params.phone" default="">
<cfparam name="params.procedures" default="">
<cfparam name="hasContactForm" default="false">

<cfsavecontent variable="additionalJS1">
	<cfoutput>
		<script type="text/javascript">
			$(function(){

				// Create object of doctors procedures to use in contact form drop box
				doctorsSpecialtyProcedureSelections = [];
				<cfloop query="variables.procedures">
					<cfif variables.procedures.name eq 'Acupuncture '>
						<cfset nameString = 'Acupuncture '>
					<cfelse>
						<cfset nameString = formatForSelectBox(variables.procedures.name)>
					</cfif>

					<cfset nameString = deAccent(nameString)>

					doctorsSpecialtyProcedureSelections["#UCase(nameString)#"] = {
						index:	"#trim(UCase(nameString))#",
						value:	"procedure-#variables.procedures.id#",
						label:	"#nameString#",
						test:	"#nameString#",
						specialtyIds:	''<!--- [#ListQualify(variables.procedures.specialtyIds, '"')#] --->
					};
				</cfloop>

				// Autocomplete
				SWprocedureArray = [];
				$('body').append('<div id="symbolcleaner" style="display:none;"></div>');
				for(i in doctorsSpecialtyProcedureSelections){
					$("##symbolcleaner").html(doctorsSpecialtyProcedureSelections[i].label)
					if(doctorsSpecialtyProcedureSelections[i].label.search("&") >= 0){
						doctorsSpecialtyProcedureSelections[$("##symbolcleaner").html().replace('&amp;','&').toUpperCase()] = {
							index:	$("##symbolcleaner").html().replace('&amp;','&').toUpperCase(),
							value:	doctorsSpecialtyProcedureSelections[i].value,
							label:	$("##symbolcleaner").html().replace('&amp;','&')
						};
					}

					if(doctorsSpecialtyProcedureSelections[i].value.charAt(0) == 's'){
						//Do nothing
					}else{

						SWprocedureArray.push({label:$("##symbolcleaner").html().replace('&amp;','&'),value:doctorsSpecialtyProcedureSelections[i].value});
					}
				}

				var _SWspecialtyprocedure = $("##SpecialtyOrProcedureId");
				var _SWspecialtyid = $("##specialtyid");
				var _SWprocedureid = $("##procedureid");
				_SWspecialtyprocedure.autocomplete({
					source: SWprocedureArray,
					select: function(event, ui){
						_SWspecialtyprocedure.val(ui.item.label);
						if(ui.item.value.split('-')[0] == 'specialty')
							{
							_SWspecialtyid.val(ui.item.value.split('-')[1]);
							_SWprocedureid.val('');
							}
						else
							{
							_SWspecialtyid.val('');
							_SWprocedureid.val(ui.item.value.split('-')[1]);
							}
						return false;
					},
					focus: function(event, ui){
						_SWspecialtyprocedure.val(ui.item.label);
						return false;
					},
					change: function(event, ui){
						var _selection = doctorsSpecialtyProcedureSelections[_SWspecialtyprocedure.val().toUpperCase()];//$(".procedure-selections option[label='"+_SWspecialtyprocedure.val().toUpperCase()+"']");
						if(_selection.length != 0){
							_SWspecialtyprocedure.val(_selection.html());
						}
					}
				});
			})
		</script>
	</cfoutput>
</cfsavecontent>

<cfhtmlhead text="#additionalJS1#">


<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1>
	<cfset params = Request.oUser.appendUserInfo(params)>
</cfif>

<cfif NOT hasContactForm>
	<cfif isMobile>
		<cfoutput>
			<h2 id="contact-a-doctor">Contact A Doctor</h2>
			#includePartial("/mobile/mini_form")#
		</cfoutput>
	<cfelse>
		<cfoutput>#includePartial(partial="/shared/sitewideminileadsidebox", isRedundant=true)#</cfoutput>
	</cfif>
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
	<div class="sidebox MiniLeadSideBox">
		<div class="frame">
			<h4>Contact the <strong>Doctor</strong></h4>
			<cfif params.controller eq "profile">
				<cfif currentLocationDetails.phonePlus neq "">
					<p>Please contact our office at <b style="white-space: nowrap;">#formatPhone(currentLocationDetails.phonePlus)#</b> or complete the form below to request more information from #doctor.fullNameWithTitle#<cfif Right(doctor.fullNameWithTitle,1) neq ".">.</cfif></p>
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
						<div class="stretch-input"><span><input type="text" placeholder="First Name" class="noPreText" name="firstname" value="#params.firstname#" required="true" /></span></div>
					</div>
					<div <cfif ListFind(Variables.miniErrorList,"lastname") and sideLeadFormOn>class="invalidData"</cfif>>
						<div class="stretch-input"><span><input type="text" placeholder="Last Name" class="noPreText" name="lastname" value="#params.lastname#" required="true" /></span></div>
					</div>
					<div <cfif ListFind(Variables.miniErrorList,"email") and sideLeadFormOn>class="invalidData"</cfif>>
						<div class="stretch-input"><span><input type="email" placeholder="Email Address" class="noPreText" name="email" value="#params.email#" required="true" /></span></div>
					</div>
					<div <cfif ListFind(Variables.miniErrorList,"phone") and sideLeadFormOn>class="invalidData"</cfif>>
						<div class="stretch-input"><span><input type="text" placeholder="Daytime Phone" class="noPreText" name="phone" value="#params.phone#" /></span></div>
					</div>
					<cfif variables.procedures.recordcount>
						<div class="stretch-input"><span><input placeholder="Type a Procedure or Treatment" type="text" name="SpecialtyOrProcedureId" value="<cfif (IsDefined('ProcedureInfo.name') and ProcedureInfo.name neq '')>#ProcedureInfo.name#</cfif>" class="styled-input-askadoc <cfif (IsDefined('ProcedureInfo.name') and ProcedureInfo.name neq '')>no</cfif>PreText" required="yes" id="SpecialtyOrProcedureId"></span></div>
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
				</form>
			</div>
		</div>
	</div>
</cfoutput>