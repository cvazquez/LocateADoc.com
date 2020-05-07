<cfif procedures.recordCount>
	<cfoutput>
		<!-- sidebox -->
		<div class="sidebox ProceduresOffered">
			<div class="frame">
				<h4>Procedures <strong>Offered</strong></h4>
				<p>Listed below are some of our most requested procedures.</p>
				<div class="procedures-box">
					<ul class="procedures-list">
						<div class="topProcedures">
							<cfloop query="procedures">
								<cfif listFind(topProcedureIds, procedures.id)>
									<li>
										<cfif val(procedures.cost) eq 0	and (procedures.notes eq "" or procedures.notes eq "N/A" or procedures.notes eq "(NULL)")>
											<p>#procedures.name#</p>
										<cfelse>
											<a href="##" class="open-close">#procedures.name#</a>
											<div class="block">
												<div class="frame">
													<dl>
														<dt>Approx Cost:</dt>
														<dd>#procedures.cost#</dd>
													</dl>
													<p>Ideal Candidate: #procedures.notes#</p>
													<p>#linkTo(controller="#doctor.siloname#", action="contact", text="Contact Doctor about Procedure")#</p>
												</div>
											</div>
										</cfif>
									</li>
								</cfif>
							</cfloop>
						</div>
						<cfif procedures.recordCount gt listLen(topProcedureIds)>
							<div class="regProcedures" id="regProcedures">
								<div class="block1">
								<cfloop query="procedures">
									<cfif not listFind(topProcedureIds, procedures.id)>
										<li>
											<cfif val(procedures.cost) eq 0	and (procedures.notes eq "" or procedures.notes eq "N/A" or procedures.notes eq "(NULL)")>
												<p>#procedures.name#</p>
											<cfelse>
												<a href="##" class="open-close">#procedures.name#</a>
												<div class="block">
													<div class="frame">
														<dl>
															<dt>Approx Cost:</dt>
															<dd>#procedures.cost#</dd>
														</dl>
														<p>Ideal Candidate: #procedures.notes#</p>
														<p>#linkTo(controller="#doctor.siloname#", action="contact", text="Contact Doctor about Procedure")#</p>
													</div>
												</div>
											</cfif>
										</li>
									</cfif>
								</cfloop>
								</div>
							</div>
						</cfif>
					</ul>
					<cfif procedures.recordCount gt listLen(topProcedureIds)>
						<a href="##" class="moreProcedures">More Procedures >></a>
					</cfif>
				</div>
			</div>
		</div>
	</cfoutput>
</cfif>