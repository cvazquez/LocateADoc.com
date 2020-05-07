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
					<div class="blog-header">
						<h1>#header#</h1>
					</div>

					<div class="article">

					<table border="0">
					<tr valign="top">
						<td>
						<ul style="padding-left: 20px; margin-top: 0px; margin-bottom: 20px;">
						<cfloop query="qProcedures">
							<cfset thisProcedureCount = listLen(MakeSet(sCategories[qProcedures.procedureId].questionList))>
							<li><a href="/ask-a-doctor/questions/#qProcedures.procedureSiloName#">#qProcedures.procedureName#</a> (#thisProcedureCount#)</li>
						</cfloop>
						</ul>
						</td>
					</tr>
					</table>

					</div>
				</div>

				<!-- aside2 -->
				<div class="aside3" id="article-widgets">
					#includePartial("/shared/sharesidebox")#
					#includePartial("latestquestions")#
					#includePartial("experts")#
				</div>

			</div>
		</div>
	</div>
</cfoutput>