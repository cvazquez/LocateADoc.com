<cfsavecontent variable="htmlhead">
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
</cfsavecontent>

<cfhtmlhead text='#htmlhead#'>

<cfset javaScriptIncludeTag(source	="askadoctor/form", head	= true)>
<cfset styleSheetLinkTag(source	= "askadoctor/form", head	= true)>


<cfoutput>
<!-- main -->
<div id="main">
	#includePartial("/shared/breadcrumbs")#
	#includePartial(partial	= "/shared/ad", size="generic728x90top")#
	<!-- container inner-container -->
	<div class="container inner-container">
		<!-- inner-holder -->
		<div class="inner-holder pattern-top article-container">
			#includePartial("/shared/pagetools")#

			<!-- content -->
			<div class="print-area" id="article-content">

<h1>Ask A LocateADoc Doctor</h1>


<cfif NOT flashIsEmpty()>
	<div class="area">
	<div class="bubble">
		<p>#flash("success")#</p>
	</div>
	</div>
</cfif>


<cfif AskADocQuestion.hasErrors()>
	<div class="ErrorBox">
		<p>Please correct the following missing items in your Question:</p>
		#errorMessagesFor("AskADocQuestion")#
	</div>
</cfif>


<h2>#askALocateADocDoctorContent.header#</h2>

<p>#askALocateADocDoctorContent.content#</p>



#startFormTag(	action			= "QuestionSave",
				spamProtection	= "true",
				id				= "AskADocQuestion-Form")#

<p class="TextField">
#textField(	label		= "Title<br />",
			objectName	= "AskADocQuestion",
			property	= "title",
			class		= "styled-input-askadoc",
			required	= true)#
</p>


<p class="TextField">
 #textArea(	label		= "Ask Your Question<br />",
			objectName	= "AskADocQuestion",
			property	= "question",
			class		= "styled-input-askadoc",
			required	= true)#
</p>


<p class="ComboBox">
<label for="combobox">Select a specialist or a procedure</label>
<div class="ui-widget">
<select id="combobox" name="SpecialtyOrProcedureId" required="true">
	<option value="">Select a Specialty or Procedure</option>
	<cfloop query="Application.qproceduresandspecialties">
		<option value="#Application.qproceduresandspecialties.type#-#Application.qproceduresandspecialties.id#"<cfif params.SPECIALTYORPROCEDUREID EQ "#Application.qproceduresandspecialties.type#-#Application.qproceduresandspecialties.id#"> selected</cfif>>#Application.qproceduresandspecialties.name#</option>
	</cfloop>
</select>
</div>
</p>


<p class="TextField">
	#textField(	label		= "First Name (optional)<br />",
				objectName	= "AskADocQuestion",
				property	= "firstName",
				class		= "styled-input-askadoc")#
</p>

<p class="TextField">
	#textField(	label		= "Last Name (optional)<br />",
				objectName	= "AskADocQuestion",
				property	= "lastName",
				class		= "styled-input-askadoc")#
</p>

<p class="TextField">
	#textField(	label		= "Email<br />",
				objectName	= "AskADocQuestion",
				property	= "email",
				class		= "styled-input-askadoc",
				required	= true)#
</p>

<script>
	var att = document.createAttribute("type");
	att.value = "email";
	document.getElementById("AskADocQuestion-email").setAttributeNode(att);

	//$("##AskADocQuestion-email").attr("type", "email");
</script>

<p class="SubmitTag">
#submitTag(	value	= "Submit",
			class	= "btn-search btn-large-text",
			id		= "AskADocSubmitButton")#
</p>
#endFormTag()#


			</div>

			<div class="aside3" id="article-widgets">
				#includePartial("/shared/latestquestions")#
				#includePartial(partial="/shared/sitewideminileadsidebox", isRedundant=(params.action eq "article"))#
				#includePartial(partial="/shared/sharesidebox",margins="10px 0")#
				#includePartial("/shared/beforeandaftersidebox")#
				#includePartial("/shared/featureddoctor")#
				#includePartial(partial	= "/shared/ad", size="generic300x250")#
				<!-- sidebox -->
				<div class="sidebox trending">
					<div class="frame">
						<h4>Trending <strong>Topics</strong></h4>
						<ul>
						<cfloop query="trendingTopics">
							<cfif specialtyId gt 0>
								<li><a href="#URLFor(controller=trendingTopics.specialtySiloName)#">#specialtyname# Guide</a></li>
							<cfelse>
								<li><a href="#URLFor(controller=trendingTopics.procedureSiloName)#">#procedurename# Guide</a></li>
							</cfif>
						</cfloop>
						</ul>
					</div>
				</div>
				<!-- sidebox -->
				<div class="sidebox">
					<div class="frame">
						<h4 class="withsubtitle">Latest <strong>Articles</strong></h4>
						<h3 class="subtitle">from LocateADoc.com</h3>
						<ul class="latestArticles">
						<cfloop query="latestArticles">
							<li>#linkTo(controller="article", action=latestArticles.siloName,text=latestArticles.title)#</li>
						</cfloop>
						</ul>
						#linkTo(action="articles",text="view all articles")#
					</div>
				</div>
			</div>

		</div>
	</div>
</div>
</cfoutput>