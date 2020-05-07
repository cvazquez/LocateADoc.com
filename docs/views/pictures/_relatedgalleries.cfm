<cfoutput>
<cfif relatedGals.recordcount>
	<div class="frame">
		<h4>Related <strong>Galleries</strong></h4>
		<p>Click on a thumbnail to view gallery.</p>
		<div class="related-galleries">
			<div class="gallery">
				<a href="##" class="link-prev">prev</a>
				<div class="hold">
					<ul>
						<cfloop query="relatedGals">
							<li>
								<div class="frame">
									<a href="/pictures/#trim(listFirst(procedureSiloNames))#-c#galleryCaseId#">
										<cfset altAfterText = "#relatedGals.procedureNames# After Picture #relatedGals.doctorsFullName# - LocateADoc.com">
										<img src="/pictures/gallery/#trim(listFirst(procedureSiloNames))#-after-thumb-#galleryCaseId#-#listFirst(galleryCaseAngleIds)#.jpg" width="76" height="52" alt="#altAfterText#" title="#altAfterText#"  />
									</a>
								</div>
							</li>
						</cfloop>
					</ul>
				</div>
				<a href="##" class="link-next">next</a>
			</div>
		</div>
		<strong class="more">
			<a href="/pictures/#procedures.siloName#<cfif val(len(trim(client.locationstring)))>/location-#client.locationstring#</cfif>">
				Click here to view all Before & After gallery cases related to #procedures.name#<cfif val(len(trim(client.locationstring)))> in #client.locationstring#</cfif>
			</a>
		</strong>
	</div>
</cfif>
</cfoutput>