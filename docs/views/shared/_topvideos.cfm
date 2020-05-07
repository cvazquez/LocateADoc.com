<cfoutput>
	<div class="small-block image-block" style="width:268px;">
		<div class="frame">
			<a href="/resources/video" style="text-decoration:none;"><h3>Latest <strong>Videos</strong></h3></a>
			<h5 style="margin-bottom:5px;">Check out our latest videos:</h5>
			<div class="widget widget-gallery1"<!---  style="margin-top:-20px;" --->>
				<div class="title">
					<ul class="switcher">
						<li class="active"><a href="##"><span>1</span></a></li>
						<li><a href="##"><span>2</span></a></li>
						<li><a href="##"><span>3</span></a></li>
						<li><a href="##"><span>4</span></a></li>
					</ul>
				</div>
				<div class="media-gallery1">
					<ul>
						<cfloop query="videoCarousel">
							<li>
								<div class="visual" style="height:94px; padding:0;">
									<div class="t">
										<div class="b">
											<a href='/#videoCarousel.siloName#?vid=#videoCarousel.id#'>
												<img src="http://#Globals.domain & videoCarousel.imagePreview#" alt="#videoCarousel.headline#" width="114" height="86" />
											</a>
										</div>
									</div>
								</div>
								<h3>#videoCarousel.headline#</h3>
								<span>(#LinkTo(href="/#videoCarousel.siloName#?vid=#videoCarousel.id#",text="view details")#)</span>
							</li>
						</cfloop>
					</ul>
				</div>
			</div>
			<strong class="more">#LinkTo(controller="resources",action="video",text="VIEW ALL VIDEOS")#</strong>
		</div>
	</div>
</cfoutput>