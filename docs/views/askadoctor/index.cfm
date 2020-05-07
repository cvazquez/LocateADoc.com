<cfsavecontent variable="htmlhead">
<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.17/themes/smoothness/jquery-ui.css" />
</cfsavecontent>

<cfhtmlhead text='#htmlhead#'>

<cfset javaScriptIncludeTag(source	="askadoctor/form", head	= true)>
<cfset styleSheetLinkTag(source	= "askadoctor/form", head	= true)>
<cfset javaScriptIncludeTag(source="askadoctor/procedure-select", head=true)>
<cfhtmlhead text='<script type="text/javascript" src="/ask-a-doctor/procedureselect"></script>'>

<cfoutput>
	<!-- main -->
	<div id="main">
		#includePartial("/shared/breadcrumbs")#
		#includePartial(partial	= "/shared/ad", size="generic728x90top")#
		<!-- container inner-container -->
		<div class="container inner-container">
			<div class="inner-holder">
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

									<p class="ComboBox">
									<label for="combobox">Select a Specialty, Procedure or Treatment</label>
									<div class="ui-widget">
									<select id="combobox" name="SpecialtyOrProcedureId">
										<option value="">Select a Specialty or Procedure</option>
										<cfloop query="Application.qproceduresandspecialties">
											<option value="#Application.qproceduresandspecialties.type#-#Application.qproceduresandspecialties.id#"<cfif params.SPECIALTYORPROCEDUREID EQ "#Application.qproceduresandspecialties.type#-#Application.qproceduresandspecialties.id#"> selected</cfif>>#Application.qproceduresandspecialties.name#</option>
										</cfloop>
									</select>
									</div>
									</p>

									<p class="TextField">
									 #textArea(	label		= "Ask Your Question<br />",
												objectName	= "AskADocQuestion",
												property	= "question",
												class		= "styled-input-askadoc",
												required	= true)#
									</p>

									<p class="TextField">
										#textField(	label		= "Postal Code<br />",
													objectName	= "AskADocQuestion",
													property	= "postalCode",
													class		= "styled-input-askadoc",
													required		= true)#
									</p>

									<p class="TextField">
										#textField(	label		= "First Name (optional)<br />",
													objectName	= "AskADocQuestion",
													property	= "firstName",
													class		= "styled-input-askadoc")#
									</p>

									<p class="TextField">
										#textField(	label		= "Email<br />",
													objectName	= "AskADocQuestion",
													property	= "email",
													class		= "styled-input-askadoc",
													required	= true)#
									</p>

									<p class="TextField">
										#checkBox(	objectName	= "AskADocQuestion",
													property	= "listOfDoctors",
													label		= "Would you like a list of doctors in your area emailed to you?",
													class		= "styled-input-askadoc",
													labelPlacement	= "after")#
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
							<div class="aside2">
								#includePartial("/shared/sharesidebox")#
								#includePartial("latestquestions")#
								#includePartial("experts")#
							</div>
							</div>
						</div>

					<!-- sidebar -->
					<div id="sidebar">
						<div class="search-box resources-menu">
							<div class="t">&nbsp;</div>
							<div class="c">
								<div class="c-add">
									<div class="title">
										<h3>Search All Categories</h3>

										<span class="text med resource-procedure-box">
											<input id="procedurename" type="text" value="" class="txt">
										</span>
										<p>Start typing a procedure or treatment name into the field above.</p>


										<h2>Most Recent Categories</h2>

										<ul id="askADoctorRecentCategories">
										<cfloop query="recentCategories">
											<li class="askADoctorRecentCategory">
												<a href="/ask-a-doctor/questions/#recentCategories.siloName#" class="askADoctorRecentCategoryLink">#recentCategories.procedureName#</a>
											</li>
										</cfloop>
										</ul>

										<a href="/ask-a-doctor/categories">View All Categories</a>
									</div>
								</div>
							</div>
							<div class="b">&nbsp;</div>
						</div>
							#includePartial("/shared/sponsoredlink")#
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