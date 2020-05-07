<cfset strPixelfishDivID = "docVidDiv">
<cfset strVidDisplayLinkID = "pixelfishVidDisplay">
<cfset strVideoHeadline = "docVidHeadline">
<cfset strVideoDescription = "docVidDescription">
<cfset intMaxDescLen = 270><!--- Max characters allowed for a video description blurb --->

<cfif pixelfish.show>
	<cfoutput>
	<script language="javascript" type="text/javascript">#Chr(60)#!--
		var hDivPixelfish = null;
		var hVidHeadline = null;
		var hVidDescription = null;

		/* ===========================================================================
			Function: popPixelfishFlash()

			Input:
				strEmbedCode-	String value to populate pixelfish's objectId with;
							identifies the video uniquely and typically ends with '=='
				strHeadline-	String video title / section headline
				strDescription-	String description of video
				autoPlay-		String either 'off' or 'on'

			Output:
				-none-

			Side-effects:
				Alters the innerHTML of the following containers (by ID)-
					#strPixelfishDivID#
					#strVideoHeadline#
					#strVideoDescription#


			Purpose:
				This function is meant to be called by the onclick event associated to
			all of the image thumbnails in the carosel.  The code we were given swaps
			the preview image out based on the thumbnail, but it does nothing to change
			the video, headline, or description that should display when the preview
			image is clicked.  This function supplements that behavior.
		============================================================================== */
		function popPixelfishFlash(strEmbedCode, strHeadline, strDescription, autoPlay)
		{
			if(!hDivPixelfish)
			{
				hDivPixelfish = document.getElementById("#strPixelfishDivID#");
				if(!hDivPixelfish)
				{
					alert("Couldn't find Pixelfish Div by ID '#strPixelfishDivID#'!");
					return;
				}
			}

			if(!hVidHeadline)
			{
				hVidHeadline = document.getElementById("#strVideoHeadline#");
				if(!hVidHeadline)
				{
					alert("Couldn't find header by ID '#strVideoHeadline#'!");
					return;
				}
			}

			if(!hVidDescription)
			{
				hVidDescription = document.getElementById("#strVideoDescription#");
				if(!hVidDescription)
				{
					alert("Couldn't find description by ID '#strVideoDescription#'!");
					return;
				}
			}

			var strPixelfish = '';
			var strShortDesc = '';
			var blnVidStartsPaused = 1;

			if(autoPlay == 'on')
				blnVidStartsPaused = 0;

			strShortDesc = strDescription.replace(/(<br \/>)|(<\/?p>)/gi, ' ');
			var strMoreLink = '... <a href="##" onclick="$(\'###strVidDisplayLinkID#\').click();">(view more)<\/a>';
			<!--- strShortDesc = strShortDesc.substring(0, #intMaxDescLen#);

			if(strDescription.length > #intMaxDescLen#)
			{
					strShortDesc += '... <a href="##" onclick="$(\'###strVidDisplayLinkID#\').click();"' +
						'>(view more)<\/a>';

					if
					(
						strShortDesc.substring(0, 2) == '<p' &&
						strShortDesc.substring(strShortDesc.length - 3, 3) != '<\/p>'
					)
					{
						strShortDesc += '<\/p>';
					}
			} --->

			//Clear video-specific containers' content
			hVidHeadline.innerHTML = '';
			hVidDescription.innerHTML = '';
			hDivPixelfish.innerHTML = '';

			//START: CREATE PIXELFISH FLASH CODE
			strPixelfish += "\n\n" +
				'<object		id="Object1"' + "\n" +
				'				width="#pixelfish.width#"' + "\n" +
				'				height="#pixelfish.height#"' + "\n" +
				'				classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"' + "\n" +
				'				codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=7,0,0,0"' + "\n" +
				'				style="margin: auto;"' + "\n" +
				'>' + "\n" +
				'		<param name="allowScriptAccess" value="sameDomain" />' + "\n" +
				'		<param name="movie" value="http://stream.pixelfish.com/Files/pixelfishPlayerMojo.swf" />' + "\n" +
				'		<param name="flashvars" ' + "\n" +
				'			value="version=1' +
								'&object_id=' + strEmbedCode +
								'&object_type=videoinstance' +
								'&server=stream.pixelfish.com' +
								'&launch_stopped=' + blnVidStartsPaused +
								'&linkTitle=Click Here to Contact the Doctor' +
								'&linkURL=#urlFor(	controller	= doctor.siloName,
													action		= "contact",
													protocol	= "#(Server.ThisServer neq "dev" ? 'https' : '')#",
													onlyPath	= "#(Server.ThisServer neq "dev" ? 'false' : 'true')#")#' +
								'&linkFont=20&' +
								'linkColor=0xFFFFFF' +
							'"' + "\n" +
				'		/>' + "\n" +
				'		<param name="quality" value="high" />' + "\n" +
				'		<param name="base" value="." />' + "\n";

			strPixelfish += "\n\n" +
				'		<embed	src="http://stream.pixelfish.com/Files/pixelfishPlayerMojo.swf"' + "\n" +
				'				flashvars="version=1' +
									'&object_id=' + strEmbedCode +
									'&object_type=videoinstance' +
									'&server=stream.pixelfish.com' +
									'&launch_stopped=' + blnVidStartsPaused +
									'&linkTitle=Click Here to Contact the Doctor' +
									'&linkURL=#urlFor(	controller=doctor.siloName,
														action="contact",
														protocol	= "#(Server.ThisServer neq "dev" ? 'https' : '')#",
														onlyPath	= "#(Server.ThisServer neq "dev" ? 'false' : 'true')#")#' +
									'&linkFont=20' +
									'&linkColor=0xFFFFFF"' +
				'				quality="high"' + "\n" +
				'				width="#pixelfish.width#"' + "\n" +
				'				height="#pixelfish.height#"' + "\n" +
				'				name="FLVPlayer"' + "\n" +
				'				allowScriptAccess="sameDomain"' + "\n" +
				'				type="application/x-shockwave-flash"' + "\n" +
				'				pluginspage="http://www.macromedia.com/go/getflashplayer" base="."' + "\n" +
				'				style="margin: auto;"' + "\n" +
				'			/>' + "\n" +
				'	</object>';
			//END: CREATE PIXELFISH FLASH CODE



			//Plug in the new flash details
			hVidHeadline.innerHTML = strHeadline;
			try
			{
				hVidDescription.innerHTML = strShortDesc;
			}
			catch(nonseneIE8issue)
			{
				//Do nothing; IE is an idiot.
			}

			hDivPixelfish.innerHTML = strPixelfish +
					'<div style="height: 90px; width: 560px; overflow: auto; margin-top: 10px;">' +
					strDescription.replace(/[\n\r]{2,}/g, '</p><p>') +
					'</div>';

			SmartTruncate('##docVidDescription',<cfif pixelfish.videos.RecordCount GT 1>75<cfelse>160</cfif>,320,true,strMoreLink);

			return;
		};


	function openDMWindow(strEmbedCode, strHeadline, strDescription, autoPlay){
		popDailyMotionFlash(strEmbedCode, strHeadline, strDescription, autoPlay);
		$('.video-modal').dialog("open");
		$('###strPixelfishDivID#').removeClass('hidden');
		return false;
	}

	function openVWindow(strEmbedCode, strHeadline, strDescription, autoPlay){
		popPixelfishFlash(strEmbedCode, strHeadline, strDescription, autoPlay);
		$('.video-modal').dialog("open");
		$('###strPixelfishDivID#').removeClass('hidden');
		return false;
	}

	function openMojoWindow(videoSource, videoSourceOgg, strHeadline, strDescription, autoPlay)
	{
		popMojoHTML5(videoSource, videoSourceOgg, strHeadline, strDescription, autoPlay);
		$('.video-modal').dialog("open");
		$('###strPixelfishDivID#').removeClass('hidden');
		return false;
	}

	function closeVWindow(){
		$('.video-modal').dialog("close");
		$('###strPixelfishDivID#').addClass('hidden');
		$('###strPixelfishDivID#').html('');
		return false;
	}

	function popDailyMotionFlash(strEmbedCode, strHeadline, strDescription, autoPlay)
		{
			if(!hDivPixelfish)
			{
				hDivPixelfish = document.getElementById("#strPixelfishDivID#");
				if(!hDivPixelfish)
				{
					alert("Couldn't find Pixelfish Div by ID '#strPixelfishDivID#'!");
					return;
				}
			}

			if(!hVidHeadline)
			{
				hVidHeadline = document.getElementById("#strVideoHeadline#");
				if(!hVidHeadline)
				{
					alert("Couldn't find header by ID '#strVideoHeadline#'!");
					return;
				}
			}

			if(!hVidDescription)
			{
				hVidDescription = document.getElementById("#strVideoDescription#");
				if(!hVidDescription)
				{
					alert("Couldn't find description by ID '#strVideoDescription#'!");
					return;
				}
			}

			var strPixelfish = '';
			var strShortDesc = '';
			var blnVidStartsPlayed = 0;

			if(autoPlay == 'on')
				blnVidStartsPlayed = 1;

			strShortDesc = strDescription.replace(/(<br \/>)|(<\/?p>)/gi, ' ');
			var strMoreLink = '... <a href="##" onclick="$(\'###strVidDisplayLinkID#\').click();">(view more)<\/a>';

			//Clear video-specific containers' content
			hVidHeadline.innerHTML = '';
			hVidDescription.innerHTML = '';
			hDivPixelfish.innerHTML = '';

			//START: CREATE DailyMotion FLASH CODE
			strPixelfish += '<iframe frameborder="0" width="#pixelfish.width#" height="#pixelfish.height#" src="//www.dailymotion.com/embed/video/' + strEmbedCode + '?logo=0&info=0&autoPlay=' + blnVidStartsPlayed + '"></iframe>';

			//Plug in the new flash details
			hVidHeadline.innerHTML = strHeadline;
			try
			{
				hVidDescription.innerHTML = strShortDesc;
			}
			catch(nonseneIE8issue)
			{
				//Do nothing; IE is an idiot.
			}

			hDivPixelfish.innerHTML = strPixelfish +
					'<div style="height: 90px; width: 560px; overflow: auto; margin-top: 10px;">' +
					strDescription.replace(/[\n\r]{2,}/g, '</p><p>') +
					'</div>';

			SmartTruncate('##docVidDescription',<cfif pixelfish.videos.RecordCount GT 1>75<cfelse>160</cfif>,320,true,strMoreLink);

			return;
		};


		function popMojoHTML5(videoSource, videoSourceOgg, strHeadline, strDescription, autoPlay)
		{
			if(!hDivPixelfish)
			{
				hDivPixelfish = document.getElementById("#strPixelfishDivID#");
				if(!hDivPixelfish)
				{
					alert("Couldn't find Pixelfish Div by ID '#strPixelfishDivID#'!");
					return;
				}
			}

			if(!hVidHeadline)
			{
				hVidHeadline = document.getElementById("#strVideoHeadline#");
				if(!hVidHeadline)
				{
					alert("Couldn't find header by ID '#strVideoHeadline#'!");
					return;
				}
			}

			if(!hVidDescription)
			{
				hVidDescription = document.getElementById("#strVideoDescription#");
				if(!hVidDescription)
				{
					alert("Couldn't find description by ID '#strVideoDescription#'!");
					return;
				}
			}

			var strPixelfish = '';
			var strShortDesc = '';
			var blnVidStartsPlayed = '';

			if(autoPlay == 'on')
				blnVidStartsPlayed = 'autoplay';


			// Firefox has issues with autoplay. If this is firefox, then shut off autplay
			//http://www.quirksmode.org/css/contents.html
			if(jQuery.browser.mozilla)
			{
				// Firefox
				blnVidStartsPlayed = '';
			}
			else if(jQuery.browser.msie && parseInt(jQuery.browser.version) < 8)
			{
				//ie
			}
			else if(jQuery.browser.webkit)
			{
				// This is chrome. All Good!
			}


			strShortDesc = strDescription.replace(/(<br \/>)|(<\/?p>)/gi, ' ');
			var strMoreLink = '... <a href="##" onclick="$(\'###strVidDisplayLinkID#\').click();">(view more)<\/a>';

			//Clear video-specific containers' content
			hVidHeadline.innerHTML = '';
			hVidDescription.innerHTML = '';
			hDivPixelfish.innerHTML = '';

			//START: CREATE DailyMotion FLASH CODE
			strPixelfish += '\
					 <video width="#pixelfish.width#" height="#pixelfish.height#" ' + blnVidStartsPlayed + ' controls>\
					  <source src="/videos/' + videoSource + '" type="video/mp4">' + ((videoSourceOgg != '') ? '<source src="/videos/' + videoSourceOgg + '" type="video/ogg">' : '') +
						'Your browser does not support the video tag.\
					</video>';

			//Plug in the new flash details
			hVidHeadline.innerHTML = strHeadline;
			try
			{
				hVidDescription.innerHTML = strShortDesc;
			}
			catch(nonseneIE8issue)
			{
				//Do nothing; IE is an idiot.
			}

			hDivPixelfish.innerHTML = strPixelfish +
					'<div style="height: 90px; width: 560px; overflow: auto; margin-top: 10px;">' +
					strDescription.replace(/[\n\r]{2,}/g, '</p><p>') +
					'</div>';

			SmartTruncate('##docVidDescription',<cfif pixelfish.videos.RecordCount GT 1>75<cfelse>160</cfif>,320,true,strMoreLink);

			return;
		};

	$(function(){
		$('.video-modal').dialog({
				autoOpen:false,
				draggable:false,
				resizable:false,
				modal:true,
				closeText:'',
				dialogClass:'compare-dialog',
				width:977,
				show:'fade',
				hide:'fade'
		});
	});

	// --></script>
	</cfoutput>
</cfif>

<cfoutput>

<!-- content -->
<div class="content">
  <!--- #pixelfishModal# --->
  <div id="tab-welcome" class="print-area">
	<!-- welcome-box -->
	<div class="welcome-box">
		<h1>#doctor.fullNameWithTitle#</h1>
		<cfif trim(doctor.headline) neq "">
			<h4>#doctor.headline#</h4>
		</cfif>
		<cfif structKeyExists(flexVideo,params.key)>
			#includePartial("flexvideo")#
		</cfif>
		<!--- START: IF VIDEOS EXIST PRESENT THEM --->
		<cfif pixelfish.show>
			<div class="video-modal hidefirst">
				<center>
					<table class="modal-box" style="width:592px;height:491px;">
						<tr class="row-buttons">
							<td colspan="2"><div class="closebutton" onclick="closeVWindow(); return false;"></div></td>
						</tr>
						<tr class="row-t">
							<td class="l-t"></td>
							<td class="t"></td>
						</tr>
						<tr class="row-c">
							<td class="l"></td>
							<td class="c" style="width:560px;height:450px;">
								<div class="hidden" id="#strPixelfishDivID#"></div>
							</td>
						</tr>
						<tr class="row-b">
							<td class="l-b"></td>
							<td class="b"></td>
						</tr>
					</table>
				</center>
			</div>
				<!-- video-holder -->
				<div class="video-holder">
					<div class="video">
						<ul class="gallery-fade">
							<!--- This list is translated into an array in jQuery that are loaded as the preview image when the
							thumbnail at the same index is clicked.  Only item 0 is displayed by default; all of the other LIs
							are silently set to 'display: none' upon page-load.  Clicking on a preview image here will cause
							the Pixelfish window to appear so the user can watch a video. --->
							<cfloop query="pixelfish.videos">
								<cfif pixelfish.videos.embedCodeDailyMotion NEQ "">
									<cfset embedCode = pixelfish.videos.embedCodeDailyMotion>
								</cfif>
								<li>
									<a	id="#strVidDisplayLinkID#"
										href="##"
										title="Play Video"
										class="<!--- thickbox  --->v_#pixelfish.videos.id#"
										<cfif pixelfish.videos.videoSource NEQ "">
											onclick='return openMojoWindow("#pixelfish.videos.videoSource#", "#pixelfish.videos.videoSourceOgg#", "#headline#","#description#","#pixelfish.videos.autoPlay#");'>
										<cfelseif pixelfish.videos.embedCodeDailyMotion NEQ "">
											onclick='return openDMWindow("#embedCodeDailyMotion#","#headline#","#description#","#pixelfish.videos.autoPlay#");'>
										<cfelse>
											onclick='return openVWindow("#embedCode#","#headline#","#description#","on");'>
										</cfif>
										<!--
										--><img
												src="#imagePreview#"
												width="240"
												height="180"
												alt="Video: #headline#"
											/><!--
									--></a>
								</li>
							</cfloop>
						</ul>
					</div>
					<!-- text-box -->
					<div class="text-box">
						<h3 id="#strVideoHeadline#"></h3>
						<div id="#strVideoDescription#" style="height: <cfif pixelfish.videos.RecordCount GT 1>85<cfelse>160</cfif>px; overflow: hidden;"></div>
							<cfif pixelfish.videos.RecordCount GT 1>
								<h3>Video Library:</h3>
								<div class="gallery">
									<a href="##" class="link-prev">Previous</a>
									<div class="hold"<cfif pixelfish.videos.RecordCount EQ 2> style="width: 180px !important; overflow: hidden !important;"</cfif>>
										<ul>
											<!--- This list is translated into an array in jQuery; clicking on one of them results in the
											preview image at the same index being loaded.  The onlick event here calls popPixelfishFlash(),
											which changes the content of our pop-up window so that the appropriate Pixelfish video is in
											place.  The content swap is done here, rather than when the preview is clicked, so that the
											video is swapped out before the user is able to see it. --->
											<cfloop query="pixelfish.videos">
												<li>
													<div class="frame">
														<a	href="##"
															class="vl_#pixelfish.videos.id#"
															onclick='
																<cfif pixelfish.videos.videoSource NEQ "">
																	popMojoHTML5(
																		"#pixelfish.videos.videoSource#",
																		"#pixelfish.videos.videoSourceOgg#",
																		"#headline#",
																		"#description#",
																		"on");
																<cfelseif pixelfish.videos.embedCodeDailyMotion NEQ "">
																	popDailyMotionFlash(
																		"#pixelfish.videos.embedCodeDailyMotion#",
																		"#headline#",
																		"#description#",
																		"on");

																<cfelse>
																	popPixelfishFlash(
																	"#embedCode#",
																	"#headline#",
																	"#description#",
																	"on"
																	);
																</cfif>'
														><img	src="#imageThumbnail#"
																width="76"
																height="52"
																alt="#headline#"
															/></a>
													</div>
												</li>
											</cfloop>
										</ul>
									</div>
									<a href="##" class="link-next">Next</a>
								</div>
							</cfif>
						</div>
					</div>
		</cfif>
		<!--- END: IF VIDEOS EXIST PRESENT THEM --->

		<!-- text-block -->
		<div class="text-block">
			<cfif doctor.consultationCost1 gt 0>
				<div style="margin-bottom:30px;">#includePartial(partial="consultation", linkOffer=(coupons.recordCount gt 0))#</div>
			</cfif>
			<cfif len(trim(doctor.pledge))>
				<div class="video-holder">
					<p>#doctor.pledge#</p>
				</div>
			</cfif>
			<cfif len(trim(accountInfo.content))>
				<div class="video-holder">
					<h2>#practice.name#</h2>
					<p>#accountInfo.content#</p>
				</div>
			</cfif>
			<!--- Testimonial --->
			<cfif len(trim(doctor.patientTestimonial))>
				<div class="video-holder">
					<h3>#LinkTo(controller=doctor.siloName,action="reviews",text="Patient Testimonials")#</h3>
					<table itemprop="review" itemscope itemtype="http://schema.org/Review">
						<!--- <meta itemprop="itemReviewed" content="#doctor.fullNameWithTitle#" /> --->
						<tr>
							<cfif len(trim(doctor.patientPhoto))>
								<cfset thisURL = "">
								<cfif server.thisServer EQ "dev">
									<cfif NOT FileExists("#Globals.serverImagePath#/images/profile/testimonials/#doctor.patientPhoto#")>
										<cfset thisURL = "http://www.locateadoc.com">
									</cfif>
								</cfif>
								<td>
									<img src="#thisURL#/images/profile/testimonials/#doctor.patientPhoto#" style="margin-right:10px;" itemprop="image">
								</td>
							</cfif>
							<td>
								<p itemprop="reviewBody">
									<img src="/images/profile/miscellaneous/quote_left.gif" style="margin:0 5px 2px 0;">
									#doctor.patientTestimonial#
									<img src="/images/profile/miscellaneous/quote_right.gif" style="margin:2px 0 0 5px;">
								</p>
								<span style="text-align:right;" itemprop="author">-#doctor.patientName#, #doctor.patientOccupation#</span>
								<meta itemprop="worstRating" content = "0"/>
								<meta itemprop="ratingValue" content = "10"/>
								<meta itemprop="bestRating" content = "10"/>
							</td>
						</tr>
					</table>
				</div>
			</cfif>
			<!--- Top 5 benefits --->
			<cfif top5Benefits.recordCount>
				<h3>Top Benefits</h3>
				<ul>
					<cfloop query="top5Benefits">
						<li>#top5Benefits.name#</li>
					</cfloop>
				</ul>
			</cfif>
			<!--- Top procedures --->
			<cfif topProcedures.recordCount>
				<p><strong>Some of our most asked about procedures:</strong> #topProcedureNames#</p>
			</cfif>
			<!--- Areas Served --->
			<cfif feederMarkets.recordCount>
				<p><strong>Areas Served:</strong> #valueList(feederMarkets.name, ", ")#
			</cfif>
		</div>
		<!-- image-list -->
		<cfif isAdvertiser or hasContactForm or staffInfo.recordCount>
			<center>
			<ul class="image-list">
				<cfif isAdvertiser>
					<li id="tour_link">
						<div class="image">
							<a href="##" class="tour_link" onclick="tourOpen(); return false;">
								<img src="/images/layout/img1-image-list.jpg" width="175" height="90" alt="Take the Office Tour" />
								<strong class="caption">Take the Office Tour</strong>
							</a>
						</div>
					</li>
				</cfif>
				<cfif hasContactForm>
					<li>
						<div class="image">
							<a href="#URLFor(	action='contact',
												controller='#doctor.siloname#',
												protocol	= "#(Server.ThisServer neq "dev" ? 'https' : '')#",
												onlyPath	= "#(Server.ThisServer neq "dev" ? 'false' : 'true')#"
												)#">
								<img src="/images/profile/img4-image-list.jpg" width="175" height="90" alt="Contact Us" />
								<strong class="caption">Contact Us</strong>
							</a>
						</div>
					</li>
				</cfif>
				<cfif staffInfo.recordCount>
					<li>
						<div class="image">
							<a href="#URLFor(action='staff',controller='#doctor.siloname#')#">
								<img src="/images/layout/img3-image-list.jpg" width="175" height="90" alt="Meet Our Staff" />
								<strong class="caption">Meet Our Staff</strong>
							</a>
						</div>
					</li>
				</cfif>
			</ul>
			</center>
		</cfif>
	</div>
  </div>
</div>

<!-- aside -->
<div class="aside">
	#includePartial("/shared/beforeandaftersidebox")#
	#includePartial("/shared/proceduresofferedsidebox")#
	#includePartial("practiceTour")#
	#includePartial("ups3d")#
	#includePartial(partial="/shared/sharesidebox",margins="10px 0")#
	<cfif displayAd IS TRUE>
		#includePartial(partial	= "/shared/ad",
						size	= "#adType#300x250")#
	</cfif>
	#includePartial("/shared/minileadsidebox")#

</div>

<cfif pixelfish.show>
<script language="javascript" type="text/javascript"><!--
	<cfif pixelfish.videos.videoSource NEQ "">
		popMojoHTML5(
			"#pixelfish.videos.videoSource[1]#",
			"#pixelfish.videos.videoSourceOgg[1]#",
			'#Replace(pixelfish.videos.headline[1], "'", "&##39;")#',
			'#Replace(pixelfish.videos.description[1], "'", "&##39;")#',
			'on');
	<cfelseif pixelfish.videos.embedCodeDailyMotion NEQ "">
		popDailyMotionFlash(
			'#pixelfish.videos.embedCodeDailyMotion[1]#',
			'#Replace(pixelfish.videos.headline[1], "'", "&##39;")#',
			'#Replace(pixelfish.videos.description[1], "'", "&##39;")#',
			'on'
		);
	<cfelse>
		popPixelfishFlash(
			'#pixelfish.videos.embedCode[1]#',
			'#Replace(pixelfish.videos.headline[1], "'", "&##39;")#',
			'#Replace(pixelfish.videos.description[1], "'", "&##39;")#',
			'on'
		);
	</cfif>
// --></script>
</cfif>
<cfif params.vid gt 0>
	<script type="text/javascript">
		$(function(){
			$(".vl_#params.vid#").click();
			$(".v_#params.vid#").click();
		});
	</script>
</cfif>
</cfoutput>