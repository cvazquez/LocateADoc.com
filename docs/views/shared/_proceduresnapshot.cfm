<cfif isDefined("ProcedureInfo") and IsQuery(ProcedureInfo) and ProcedureInfo.recordcount>
	<cfif Len(ProcedureInfo.avgfee) or Len(ProcedureInfo.candidate) or Len(ProcedureInfo.timeSpan) or Len(ProcedureInfo.treatments) or Len(ProcedureInfo.results) or Len(ProcedureInfo.timeBackToWork)>
		<cfoutput>
			<!-- sidebox -->
			<div class="sidebox snapshot">
				<div class="frame">
					<h4>Procedure <strong>Snapshot</strong></h4>
					<ul>
					<cfif Len(ProcedureInfo.avgfee)><li><span>Avg. Cost:</span> $#ProcedureInfo.avgfee#</li></cfif>
					<cfif Len(ProcedureInfo.candidate)><li><span>Candidate:</span> #ProcedureInfo.candidate#</li></cfif>
					<cfif Len(ProcedureInfo.timeSpan)><li><span>Length:</span> #ProcedureInfo.timeSpan#</li></cfif>
					<cfif Len(ProcedureInfo.treatments)><li><span>Treatment:</span> #ProcedureInfo.treatments#</li></cfif>
					<cfif Len(ProcedureInfo.results)><li><span>Results:</span> #ProcedureInfo.results#</li></cfif>
					<cfif Len(ProcedureInfo.timeBackToWork)><li><span>Back to Work:</span> #ProcedureInfo.timeBackToWork#</li></cfif>
					</ul>
					<cfif params.controller neq "Resources">
						#LinkTo(controller=ProcedureInfo.siloName,text="View #ProcedureInfo.name# Guide")#
					</cfif>
				</div>
			</div>
		</cfoutput>
	</cfif>
</cfif>