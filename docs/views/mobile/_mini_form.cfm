<cfparam name="params.firstname" default="">
<cfparam name="params.lastname" default="">
<cfparam name="params.name" default="">
<cfparam name="params.email" default="">
<cfparam name="params.zip" default="">
<cfparam name="params.phone" default="">
<cfparam name="specialtyID" default="0">
<cfparam name="procedureID" default="0">
<cfparam name="additionalJS" default="">
<cfparam name="params.silourl" default="">
<cfparam name="params.t" default="">
<cfparam name="Arguments.toDesktop" default="false">
<cfset Client.mobile_entry_page = (params.silourl neq "") ? params.silourl : params.t>
<cfset Client.mobile_to_desktop = Arguments.toDesktop>

<!--- Load user info --->
<cfif Request.oUser.saveMyInfo eq 1>
	<cfset params = Request.oUser.appendUserInfo(params)>
</cfif>

<cfsavecontent variable="additionalJS1">
	<cfoutput>
		<script type="text/javascript">
			$(function(){
				<cfif params.zip eq "">
					// Get phone's location
					if(navigator.geolocation)
					{
						navigator.geolocation.getCurrentPosition(function(position)
						{
							var lat = position.coords.latitude;
							var lon = position.coords.longitude;
							$.post("http://#CGI.SERVER_NAME#/api/coordinates2location?lat=" + lat + "&lon=" + lon + "&format=json",{},function(response) {
								$("[name$='zip']").val(response.POSTALCODE).removeClass('input-default');
							});
						});
					}
				</cfif>

				// Autocomplete
				<!--- procedureSpecialtyArray = [];
				$(".procedure-selections option").each(function(){
					procedureSpecialtyArray.push({label:$(this).html(),value:$(this).attr('value')});
				}); --->
				procedureSpecialtyArray = [];
				SWprocedureArray = [];
				$('body').append('<div id="symbolcleaner" style="display:none;"></div>');
				for(i in specialtyProcedureSelections){
					$("##symbolcleaner").html(specialtyProcedureSelections[i].label)
					if(specialtyProcedureSelections[i].label.search("&") >= 0){
						specialtyProcedureSelections[$("##symbolcleaner").html().replace('&amp;','&').toUpperCase()] = {
							index:	$("##symbolcleaner").html().replace('&amp;','&').toUpperCase(),
							value:	specialtyProcedureSelections[i].value,
							label:	$("##symbolcleaner").html().replace('&amp;','&')
						};
					}
					if(specialtyProcedureSelections[i].label != 'Acupuncture ')
						//procedureSpecialtyArray.push({label:$("##symbolcleaner").html().replace('&amp;','&'),value:specialtyProcedureSelections[i].value});
					if(specialtyProcedureSelections[i].value.charAt(0) == 's'){
						//specialtyArray.push($("##symbolcleaner").html().replace('&amp;','&'));
					}else{
						//procedureArray.push($("##symbolcleaner").html().replace('&amp;','&'));
						SWprocedureArray.push({label:$("##symbolcleaner").html().replace('&amp;','&'),value:specialtyProcedureSelections[i].value});
					}
				}

				var _SWspecialtyprocedure = $("##specialty");
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
						var _selection = specialtyProcedureSelections[_SWspecialtyprocedure.val().toUpperCase()];//$(".procedure-selections option[label='"+_SWspecialtyprocedure.val().toUpperCase()+"']");
						if(_selection.length != 0){
							_SWspecialtyprocedure.val(_selection.html());
						}
					}
				});
				$("##site-wide-mini input.PreText").addClass('input-default');
				$("##site-wide-mini input").attr("onfocus","$(this).removeClass('input-error');if(this.value==this.defaultValue && !$(this).hasClass('noPreText')){this.value='';$(this).removeClass('input-default');}");
				$("##site-wide-mini input").attr("onblur","if($.trim(this.value)==''){this.value=this.defaultValue;if(!$(this).hasClass('noPreText')) $(this).addClass('input-default');}");
			})
			function validate()
			{
				var error = false;
				$("##site-wide-mini input").each(function(index) {
					if ($(this).attr("required") && ($(this).val() == '' || ($(this).val() == $(this)[0].defaultValue && !$(this).hasClass('noPreText'))))
						{
						$(this).addClass("input-error");
						error = true;
						}
					})
				if($("##site-wide-mini ##name").val().split(' ').length < 2)
						{
						$("##site-wide-mini ##name").addClass("input-error");
						error = true;
						}
				if(!error)
					$("##site-wide-mini").submit();
			}
		</script>
	</cfoutput>
</cfsavecontent>
<cfset additionalJS &= additionalJS1>
<cfoutput>
	<form action="/mobile/page2?t=#Client.mobile_entry_page#" method="post" id="site-wide-mini">
		<input	type="hidden"	name="isFolioMini"	value="0">
		<input	type="hidden"	name="position"		value="11">
		<input	type="hidden"	name="sourceId"		value="56">
		<!--- <input	type="hidden"	name="specialty"	value="#specialtyID#"	id="specialtyid"> --->
		<input	type="hidden"	name="procedure"	value="#ProcedureID#"	id="procedureid">
		<input	type="hidden"	name="comments"		value=""	id="comments">
		<p class="input-wrapper">
			<cfset specialtyProcedureValue = "">
			<cfif (IsDefined('ProcedureInfo.name') and ProcedureInfo.name neq '')>
				<cfset specialtyProcedureValue = ProcedureInfo.name>
			<cfelseif specialtyID neq 0>
				<!--- #Application.strctSpecialty[specialtyID].name# --->
			<cfelse><!--- Specialty or  --->
			</cfif>
			<input	type="text" name="specialtyprocedure" placeholder="Procedure or Treatment" value="#specialtyProcedureValue#" class="<cfif (IsDefined('ProcedureInfo.name') and ProcedureInfo.name neq '')>no</cfif>PreText" required="yes" id="specialty">
		</p>
		<p class="input-wrapper">
			<input	type="text" name="name" placeholder="Patient Name" value="#params.name neq "" ? params.name : ""#" class="#params.name neq "" ? "no" : ""#PreText" required="yes" id="name">
		</p>
		<p class="input-wrapper">
			<input	type="email" name="email" placeholder="Email Address" value="#params.email neq "" ? params.email : ""#" class="#params.email neq "" ? "no" : ""#PreText" required="yes">
		</p>
		<p class="input-wrapper">
			<input	type="text" name="zip" placeholder="Zip Code" value="#params.zip neq "" ? params.zip : ""#" class="#params.zip neq "" ? "no" : ""#PreText" required="yes">
		</p>
		<p class="input-wrapper">
			<input	type="text" name="phone" placeholder="Daytime Phone" value="#params.phone neq "" ? params.phone : ""#" class="#params.phone neq "" ? "no" : ""#PreText" required="yes">
		</p>
		<!--- #Request.oUser.getCheckBox(label="Save my information", inputClass="saveMyInfo", inputStyle="float:left;")# --->
	    <label for="saveMyInfoSlider" class="saveMyInfoSliderLabel">Save my information:</label>
        <select name="saveMyInfoSlider" id="saveMyInfoSlider" data-role="slider" data-mini="true">
            <option value="">No</option>
            <option value="on" selected>Yes</option>
        </select>
		<!--- <input type="submit" style="margin-left: -9999px; float:left;"> --->
		<a href="##" class="button" onclick="validate(); return false;">Contact a Doctor</a>
		<!--- <div class="hidden">
		<select class="procedure-selections">
			<cfloop query="ProceduresAndSpecialties">
				<option label="#REReplace(UCase(ProceduresAndSpecialties.name),'[ ][ ]+',' ','all')#" value="#ProceduresAndSpecialties.type#-#ProceduresAndSpecialties.id#">#REReplace(ProceduresAndSpecialties.name,'[ ][ ]+',' ','all')#</option>
			</cfloop>
		</select>
		</div> --->
	</form>
</cfoutput>

<script type="text/javascript">
	$(function(){
		var showTopBar = false;
		$(window).scroll(function(){
			var scrolledUnder = $(window).scrollTop() > 100;
			var scrolledOver = ($(window).scrollTop() + $(window).height()) < $("#site-wide-mini").offset().top;
			if (!showTopBar && (scrolledUnder && scrolledOver)){
				$("#topBar").fadeIn("fast");
				$("#topBarContent").fadeIn("fast");
			}else if (showTopBar && !(scrolledUnder && scrolledOver)){
				$("#topBar").fadeOut("fast");
				$("#topBarContent").fadeOut("fast");
			}
			showTopBar = (scrolledUnder && scrolledOver);
		});
	});
	function scrollToContact(){
		$(window).scrollTop($("#site-wide-mini").offset().top - 50);
		return false;
	}
</script>
<cfoutput>
	<div id="topBar"></div>
	<div id="topBarContent">
		<center>
			<a href="##" onclick="return scrollToContact();" class="button">CONTACT A DOCTOR</a>
		</center>
	</div>
</cfoutput>