<cfoutput>
	<!--- <cfset widgetWidth = 669>
	<cfset widgetHeight = 504> --->
	<cfset widgetWidth = 700>
	<cfset widgetHeight = 550>
	<a name="ups3d"></a>
	<script language="javascript" type="text/javascript" src="http://www.UnderstandPlasticSurgery.com/assets/js/popup.js"></script>

	<div id="dwindow" style="z-index:9999;position:absolute;cursor:hand;left:0px;top:0px;display:none;">
		<!--- <div align="right" style="background-color:##678483;">
			<span style="color:##FFFFFF;font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px; font-weight:bold; padding-right:10px;">Click to Drag</span>
			<img src="http://www.Understandplasticsurgery.com/assets/images/navigation/max.gif" id="maxname" onclick="maximize()">
			<img src="http://www.Understandplasticsurgery.com/assets/images/navigation/close.gif" onclick="closeit()">
		</div> --->
		<table class="modal-box" style="width:#widgetWidth+32#px;height:#widgetHeight+41#px;">
			<tr class="row-buttons">
				<td colspan="2"><div class="closebutton" onclick="closeit(); return false;"></div></td>
			</tr>
			<tr class="row-t">
				<td class="l-t"></td>
				<td class="t"></td>
			</tr>
			<tr class="row-c">
				<td class="l"></td>
				<td class="c" style="width:#widgetWidth#px;height:#widgetHeight#px;">
					<div align="left" id="dwindowcontent" style="height:100%; background-color:##FFFFFF">
						<iframe id="cframe" src="" width="#widgetWidth#" height="#widgetHeight#" scrolling="no" border="0" style="border:none;" frameborder="0"></iframe>
					</div>
				</td>
			</tr>
			<tr class="row-b">
				<td class="l-b"></td>
				<td class="b"></td>
			</tr>
		</table>
	</div>
	<a class="gallery-link" href="javascript:loadwindow('http://content.understand.com/locateadoc.menu',#widgetWidth+32#,#widgetHeight+53#)">3D SURGERY GALLERY</a>
</cfoutput>
<!--- http://locateadoc.animations.understandplasticsurgery.com/ --->
<!--- http://www.UnderstandPlasticSurgery.com/iframes/drlocateadoc.asp --->