<!--- <cfsavecontent variable="flexVideoModal"> --->
	<cfoutput>
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
							<div align="center" id="docVidDiv" class="hidden">
								<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=8,0,0,0" width="400" height="266" id="FLVPlayer">
								    <param name="movie" value="/videos/flvplayer_progressive.swf"/>
								    <param name="salign" value="lt" />
								    <param name="quality" value="high" />
								    <param name="scale" value="noscale" />
								    <param name="FlashVars" value="&MM_ComponentVersion=1&skinName=/videos/clear_skin_3&streamName=/videos/#flexVideo[params.key].name#.flv&autoPlay=true&autoRewind=false" />
								    <embed src="/videos/flvplayer_progressive.swf" flashvars="&MM_ComponentVersion=1&skinName=/videos/clear_skin_3&streamName=/videos/#flexVideo[params.key].name#.flv&autoPlay=true&autoRewind=false" quality="high" scale="noscale" width="400" height="266" name="FLVPlayer" salign="LT" type="application/x-shockwave-flash" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" />
								</object>
								<div style="height: 90px; overflow: auto; margin-top: 10px;">
									<p style="margin-top: 0;">#flexVideo[params.key].description#</p>
								</div>
							</div>
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
<!--- </cfsavecontent> --->
<!--- <cfset contentFor(modalWindows=flexVideoModal)> --->

<cfsavecontent variable="script">

	<script src="/javascripts/ac_runactivecontent.js" type="text/javascript"></script>
	<script type="text/javascript">
		var flexWindowContent = "";
		function openVWindowFlex(){
			if (flexWindowContent == "")
				flexWindowContent = $('#docVidDiv').html();
			else
				$('#docVidDiv').html(flexWindowContent);
			$('.video-modal').dialog("open");
			$('#docVidDiv').removeClass('hidden');
			return false;
		}

		function closeVWindow(){
			$('.video-modal').dialog("close");
			$('#docVidDiv').addClass('hidden');
			$('#docVidDiv').html('');
			return false;
		}

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
	</script>
</cfsavecontent>
<cfhtmlhead text="#fnCompress(script)#">

<cfoutput>
	<div class="video-holder">
		<div class="video">
			<ul class="gallery-fade">
				<li style="display: list-item;" class="active">
					<a id="pixelfishVidDisplay"
						href="##<!--- TB_inline?width=400&amp;height=380&amp;inlineId=docVidDiv --->"
						title="Play Video"
						onclick='return openVWindowFlex();'>
						<img src="/images/video/#flexVideo[params.key].name#.png" width="240" height="180" alt="Video: #practice.name#">
					</a>
				</li>
			</ul>
		</div>
		<!-- text-box -->
		<div class="text-box">
			<h2 id="docVidHeadline">#practice.name#</h2>
			<div id="docVidDescription" style="height: 160px; overflow: hidden;">
				<p style="margin-top: 0;">#flexVideo[params.key].description#</p>
			</div>
		</div>
	</div>
</cfoutput>