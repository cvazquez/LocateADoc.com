<cfset javaScriptIncludeTag(source	="askadoctor/form", head	= true)>
<cfset styleSheetLinkTag(source	= "askadoctor/form_mobile", head	= true)>
<!--- <cfset javaScriptIncludeTag(source="askadoctor/procedure-select", head=true)> --->
<cfhtmlhead text='<script type="text/javascript" src="/ask-a-doctor/procedureselect"></script>'>

<!--- <cfhtmlhead text='
	<link rel="stylesheet" href="//code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css" />
	<script src="//code.jquery.com/jquery-1.10.2.min.js"></script>
	<script src="//code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>
	<style>
	html, body { padding: 0; margin: 0; }
	html, .ui-mobile, .ui-mobile body {
    	height: 235px;
	}
	.ui-mobile, .ui-mobile .ui-page {
    	min-height: 235px;
	}
	.ui-content{
		padding:10px 15px 0px 15px;
	}

	</style>'>
 --->

<cfsavecontent variable="additionalJS1">
	<cfoutput>
		<script type="text/javascript">
			$(function(){
				// Autocomplete
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

					if(specialtyProcedureSelections[i].value.charAt(0) == 's'){
						//Do nothing
					}else{

						SWprocedureArray.push({label:$("##symbolcleaner").html().replace('&amp;','&'),value:specialtyProcedureSelections[i].value});
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
						var _selection = specialtyProcedureSelections[_SWspecialtyprocedure.val().toUpperCase()];//$(".procedure-selections option[label='"+_SWspecialtyprocedure.val().toUpperCase()+"']");
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

<cfoutput>

<div id="page1" class="centered askADocHome">
	<div id="bottom-content-wrapper">
		<div id="mobile-content">

				<!-- content-frame -->
				<div class="content-frame">
					<div id="content">
						<!-- resources-box -->
						<div class="resources-box">
							<div class="title">
								<h1 class="page-title">#specialContent.header#</h1>
								<span>#specialContent.description#</span>
							</div>
							<div class="box">
								<div class="descr resources-content">
									<div class="visual">
										<div class="t">&nbsp;</div>
										<div class="c">
											<a href="/ask-a-doctor/categories"><img src="/images/layout/img-askadoctor-home.jpg" alt="Welcome to the Ask a Doctor page on LocateADoc.com" title="Welcome to the Ask a Doctor page on LocateADoc.com" width="276" height="150" /></a>
										</div>
										<div class="b">&nbsp;</div>
									</div>
									#specialContent.content#
								</div>
							</div>
						</div>
						<!-- holder -->
						<div class="holder">
							<div class="aside1">
								<!-- widget -->
								<div class="widget widget-gallery">
									<div class="title">
										<h2>Ask A LocateADoc Doctor</h2>
									</div>



									<cfif NOT flashIsEmpty()>
										<div class="area">
										<div class="bubble">
											<p>#flash("success")#</p>
										</div>
										</div>

										<cfsavecontent variable="FacebookConversionTracker">
											<script type="text/javascript">
												var fb_param = {};
												fb_param.pixel_id = '6005618727157';
												fb_param.value = '0.00';
												fb_param.currency = 'USD';
												(function(){
												  var fpw = document.createElement('script');
												  fpw.async = true;
												  fpw.src = '//connect.facebook.net/en_US/fp.js';
												  var ref = document.getElementsByTagName('script')[0];
												  ref.parentNode.insertBefore(fpw, ref);
												})();
											</script>
											<noscript><img height="1" width="1" alt="" style="display:none" src="https://www.facebook.com/offsite_event.php?id=6005618727157&amp;value=0&amp;currency=USD" /></noscript>
										</cfsavecontent>
										<cfset FacebookConversionTracker = ReReplace(FacebookConversionTracker, "\t+", "", "ALL")>
										<cfhtmlhead text="#FacebookConversionTracker#">
									</cfif>


									<cfif AskADocQuestion.hasErrors()>
										<div class="ErrorBox">
											<p>Please correct the following missing items in your Question:</p>
											#errorMessagesFor("AskADocQuestion")#
										</div>
									</cfif>


									<h3 style="padding-top: 15px;">Ask your question to LocateADoc.com's Q&A Panel</h3>

									<p>By submitting a question, you agree to have your question posted on LocateADoc.com and engage in a public dialogue.</p>



									#startFormTag(	action			= "QuestionSave",
													spamProtection	= "true",
													id				= "AskADocQuestion-Form",
													onSubmit		= "_gaq.push(['_trackEvent', 'AskADoctor', 'Submit', 'Question']) ")#

									<!--- <p class="ComboBox">
									<label for="combobox">Select a Specialty, Procedure or Treatment</label>
									<div class="ui-widget">
									<select id="combobox" name="SpecialtyOrProcedureId">
										<option value="">Select a Procedure</option>
										<cfloop query="Application.qproceduresandspecialties">
											<option value="#Application.qproceduresandspecialties.type#-#Application.qproceduresandspecialties.id#"<cfif params.SPECIALTYORPROCEDUREID EQ "#Application.qproceduresandspecialties.type#-#Application.qproceduresandspecialties.id#"> selected</cfif>>#Application.qproceduresandspecialties.name#</option>
										</cfloop>
									</select>
									</div>
									</p> --->

									<p class="input-wrapper">
										<!--- <label for="specialty">Select a Specialty, Procedure or Treatment</label> --->
										<input placeholder="Type a Procedure or Treatment" type="text" name="SpecialtyOrProcedureId" value="<cfif (IsDefined('ProcedureInfo.name') and ProcedureInfo.name neq '')>#ProcedureInfo.name#</cfif>" class="styled-input-askadoc <cfif (IsDefined('ProcedureInfo.name') and ProcedureInfo.name neq '')>no</cfif>PreText" required="yes" id="SpecialtyOrProcedureId">
									</p>

									<!--- <div class="ui-input-search ui-shadow-inset ui-input-has-clear ui-body-inherit ui-corner-all">
										<input data-type="search" placeholder="Search fruits..." data-lastval="">
										<a href="#" tabindex="-1" aria-hidden="true" class="ui-input-clear ui-btn ui-icon-delete ui-btn-icon-notext ui-corner-all ui-input-clear-hidden" title="Clear text">Clear text</a>
									</div> --->

									<!--- <div role="main" class="ui-content" style="padding: 30px 0px 0px 0px!important;">
										<ul data-role="listview" data-filter="true" data-filter-reveal="true" data-filter-placeholder="Search procedures..." data-inset="true">
											<cfloop query="Application.qproceduresandspecialties">
											<li><a href="##">#Application.qproceduresandspecialties.name#</a></li>
											</cfloop>
										</ul>
									</div> --->

									<p class="TextField">
									 #textArea(	label		= "",
												objectName	= "AskADocQuestion",
												property	= "question",
												class		= "styled-input-askadoc",
												required	= true,
												placeholder	= "Ask Your Question")#
									</p>

									<p class="TextField">
										#textField(	label		= "",
													objectName	= "AskADocQuestion",
													property	= "postalCode",
													class		= "styled-input-askadoc",
													required		= true,
													placeholder	= "Postal Code")#
									</p>

									<p class="TextField">
										#textField(	label		= "",
													objectName	= "AskADocQuestion",
													property	= "firstName",
													class		= "styled-input-askadoc",
													placeholder	= "First Name (optional)")#
									</p>

									<p class="TextField">
										#textField(	label		= "",
													objectName	= "AskADocQuestion",
													property	= "email",
													class		= "styled-input-askadoc",
													required	= true,
													placeholder	= "Email")#
									</p>

									<p class="TextField">
										<!--- #checkBox(	objectName	= "AskADocQuestion",
													property	= "listOfDoctors",
													label		= "Would you like a list of doctors in your area emailed to you?",
													class		= "styled-input-askadoc",
													labelPlacement	= "after")# --->

										<input class="custom" id="AskADocQuestion-listOfDoctors" name="AskADocQuestion[listOfDoctors]" type="checkbox" value="1" data-mini="true">
										<label for="AskADocQuestion-listOfDoctors">
											Would you like a list of doctors in your area emailed to you?
										</label>

									</p>


									<script>
										var att = document.createAttribute("type");
										att.value = "email";
										document.getElementById("AskADocQuestion-email").setAttributeNode(att);
									</script>

									<div align="center" class="SubmitTag">
										#submitTag(	alt		= "Submit Your Ask A Doctor Question",
													title	= "Submit Your Ask A Doctor Question",
													value	= "Submit",
													class	= "btn-search btn-large-text",
													id		= "AskADocSubmitButton"
													)#
									</div>

									#endFormTag()#
								</div>

								</div>
								<!-- aside2 -->
								<div class="aside3" id="article-widgets">
									<div class="swm mobileWidget">
										<h2>Contact A Doctor</h2>
										#includePartial("/mobile/mini_form")#
									</div>
									<div class="mobileWidget lastestQuestions">
										#includePartial("/askadoctor/latestquestionshome_mobile")#
									</div>
									<div class="mobileWidget recentCategories">
										#includePartial("recentcategories")#
									</div>
									<div class="mobileWidget experts">
										#includePartial("experts")#
									</div>
								</div>
							</div>
						</div>

					</div>

				</div>

				</div>
			</div>

	<div class="prompt-box hidefirst">
		<center>
			<table class="modal-box">
				<tr class="row-buttons">
					<td colspan="2"><div class="closebutton" onclick="ALListClose(); return false;"></div></td>
				</tr>
				<tr class="row-t">
					<td class="l-t"></td>
					<td class="t"></td>
				</tr>
				<tr class="row-c">
					<td class="l"></td>
					<td class="c">
						<span id="OverlaySearchResults"></span>
					</td>
				</tr>
				<tr class="row-b">
					<td class="l-b"></td>
					<td class="b"></td>
				</tr>
			</table>
		</center>
	</div>
	</cfoutput>