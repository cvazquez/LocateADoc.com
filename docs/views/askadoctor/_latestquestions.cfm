<cfif latestQuestions.recordCount GT 0>
<cfparam default="" name="procedureSiloName">

<cfset questionsLink = "/ask-a-doctor/questions/" & procedureSiloName>

<cfhtmlhead text='<script type="text/javascript" src="/javascripts/askadoctor/latestquestions.js"></script>'>

<!-- sidebox -->
<cfoutput>
<div class="sidebox">
	<div class="frame">
		<h4 class="withsubtitle"><a href="#questionsLink#" style="text-decoration: none;">Latest <strong>Questions</strong></a></h4>
		<ul class="latestQuestions">
		<cfloop query="latestQuestions">
			<li <cfif latestQuestions.currentRow GT 5> class="hide"</cfif>>
				<a href="/ask-a-doctor/question/#latestQuestions.siloName#">#trim(replace(latestQuestions.title, "Q&A:", ""))#</a>
			</li>
		</cfloop>
		</ul>

		<!--- This is in case the user has javascript off, the link will still take them to the page --->
		<!--- <a href="/ask-a-doctor/questions/page-2" id="ViewMoreQuestionsLink">
		#submitTag(	alt		= "View More Ask A Doctor Questions",
					title	= "View More Ask A Doctor Questions",
					value	= "View More",
					class	= "btn-search btn-large-text",
					id		= "ViewMoreQuestions")#</a> --->
		<div class="TextAlignRight"><a href="#questionsLink##(latestQuestionsTotal GT 10 ? 'page-2' : '' )#" id="ViewMoreQuestions">view more questions</a></div>
	</div>
</div>
</cfoutput>
</cfif>