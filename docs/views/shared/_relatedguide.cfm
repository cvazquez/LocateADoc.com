<cfif isDefined("RelatedGuide") and RelatedGuide.recordcount>
	<cfoutput>
		<div class="sidebox sidebox2 RelatedGuide">
			<div class="frame related-guide">
				<h4>Related <strong>Guide</strong></h4>
				<cfif val(RelatedGuide.specialtyID)>
				<h5>#LinkTo(controller="#RelatedGuide.specialtySiloName#",text="#RelatedGuide.specialtyname# Guide")#</h5>
				<cfelse>
				<h5>#LinkTo(controller="#RelatedGuide.procedureSiloName#",text=RelatedGuide.title)#</h5>
				</cfif>
				<cfset filteredContent = REReplace(RelatedGuide.content,"</?span[^>]*?>"," ","all")>
				<cfset filteredContent = Replace(filteredContent,"&nbsp;"," ","all")>
				<cfset filteredContent = REReplace(filteredContent,"<h[0-9][^>]*?>.+?</h[0-9]>","","all")>
				<cfset filteredContent = REReplace(filteredContent,"<p>\s*?</p>","","all")>
				<!--- Resize images in blog preview --->
				<cfset guideImages = REFind("<img.+?>",filteredContent,0,true)>
				<cfset newImageTag = "">
				<cfif guideImages.len[1] gt 0>
					<cfset imageTag = Mid(filteredContent,guideImages.pos[1],guideImages.len[1])>
					<cfset newImageTag = imageTag>
					<cfset imageWidthLocation = REFind('width\s?(=|:)\s?"?[0-9]+("|px)?',imageTag,0,true)>
					<cfset imageHeightLocation = REFind('height\s?(=|:)\s?"?[0-9]+("|px)?',imageTag,0,true)>
					<cfif imageWidthLocation.pos[1] and imageHeightLocation.pos[1]>
						<cfset widthString = Mid(imageTag,imageWidthLocation.pos[1],imageWidthLocation.len[1])>
						<cfset heightString = Mid(imageTag,imageHeightLocation.pos[1],imageHeightLocation.len[1])>
						<cfset imageWidth = REReplace(widthString,"[^0-9]","","all")>
						<cfset imageHeight = REReplace(heightString,"[^0-9]","","all")>
						<cfif imageWidth gt 80 and imageHeight gt 80>
							<cfif imageWidth lt imageHeight>
								<cfset newImageWidth = Ceiling(imageWidth/imageHeight * 80)>
								<cfset newImageHeight = 80>
							<cfelse>
								<cfset newImageHeight = Ceiling(imageHeight/imageWidth * 80)>
								<cfset newImageWidth = 80>
							</cfif>
							<cfset newWidthString = Replace(widthString,imageWidth,newImageWidth)>
							<cfset newHeightString = Replace(heightString,imageHeight,newImageHeight)>
							<cfset newImageTag = Replace(Replace(newImageTag,'#heightString#','#newHeightString#',"all"),'#widthString#','#newWidthString#',"all")>
							<!--- <cfset filteredContent = Replace(filteredContent,imageTag,"[!!temp!!]")> --->
							<!--- Show only one image --->
							<!--- <cfset filteredContent = Replace(filteredContent,"[!!temp!!]",newImageTag)> --->
						</cfif>
					</cfif>
					<cfset filteredContent = newImageTag & REReplace(filteredContent,"<img.+?>",'','all')>
				</cfif>
				<cfif Left(filteredContent,5) eq "<div>">
					<p>#Left(filteredContent,Find("</div>",filteredContent,50+Len(newImageTag))+6)#</p>
				<cfelse>
					<p>#Left(filteredContent,Find("</p>",filteredContent,50+Len(newImageTag))+4)#</p>
				</cfif>
				<strong class="more">
					<cfif val(RelatedGuide.specialtyID)>
						#LinkTo(controller="#RelatedGuide.specialtySiloName#",text="READ MORE")#
					<cfelse>
						#LinkTo(controller="#RelatedGuide.procedureSiloName#",text="READ MORE")#
					</cfif>
				</strong>
			</div>
		</div>
	</cfoutput>
</cfif>