<cfoutput>
#styleSheetLinkTag(	source	= "/askadoctor/questionshome", head	 = true)#
	<div class="resources" style="padding-left: 10px;">
		<div class="heading-blue">
			<a href="/ask-a-doctor/categories" style="text-decoration:none;"><h2>Ask A Doctor <strong>Questions</strong></h2></a>
		</div>
		<div class="box gallery" style="padding-left: 10px;
										width: 300px;
										position: relative;
										overflow: visible;">
			<div class="column-height" style="height:190px;">
				<div class="hold">
				<ul class="articles" style="overflow: visible!important; margin: 0px 0px 0px; height: 180px; width: 300px;">
					<cfloop query="latestQuestions">
					<cfif currentrow mod 2 eq 1><li class="hold-list" style="width: 300px; height: 180px;"></cfif>
					<!--- <div class="hold-resource-outer">
					<div class="hold-resource"> --->

					<div style="width:300px;
								margin:0 auto;
								<cfif latestQuestions.currentrow mod 2 eq 0>
									padding-top: 10px;
								</cfif>
								">
					<div style="float:left;
								width:70px;">
						<cfsavecontent variable="altTitleText">#latestQuestions.firstName# #latestQuestions.lastName#<cfif latestQuestions.title NEQ ""> , #latestQuestions.title#</cfif> - #latestQuestions.city#, #latestQuestions.state#</cfsavecontent>
						<div class="AskADocExpertsThumbnails">
						<div class="AskADocExpertsThumbnailBorder1">
						<div class="AskADocExpertsThumbnailBorder2">
						<div class="AskADocExpertsThumbnailBorder3">
						<a href="/ask-a-doctor/question/#latestQuestions.siloName#"><img src="/images/profile/doctors/thumb/#latestQuestions.photoFilename#" width="63" alt="#altTitleText#" title="#altTitleText#"></a>
						</div>
						</div>
						</div>
						</div>
					</div>

					<div style="float:right;
								width: 211px;
								margin: 0px 12px 0px 0px;">
						<cfset resourceLink = URLFor(controller="ask-a-doctor",action="question",key=latestQuestions.siloName)>
						<cfset resourceLinkText = trim(replace(latestQuestions.title, "Q&A:", ""))>

						<h4>#LinkTo(href=resourceLink,text=resourceLinkText)#</h4>
						<!--- <cfset filteredContent = REReplace(latestQuestions.content,"</?span[^>]*?>"," ","all")>
						<cfset filteredContent = Replace(filteredContent,"&nbsp;"," ","all")>
						<cfset filteredContent = REReplace(filteredContent,"<h[0-9][^>]*?>.+?</h[0-9]>","","all")>
						<cfset filteredContent = REReplace(filteredContent,"<p>\s*?</p>","","all")>
						<cfset filteredContent = REReplace(filteredContent,"<img.+?>","","all")>
						<cfset filteredContent = REReplace(filteredContent,'style=".+?"',"","all")>
						<cfset filteredContent = REReplace(filteredContent,"<.+?>","","all")>
						<div class="truncated-guide"><p>
							<cfif Left(filteredContent,5) eq "<div>">
								#Left(filteredContent,Find("</div>",filteredContent,50)+6)#
							<cfelse>
								#Left(trim(filteredContent),200)#...
							</cfif>
						</p></div> --->
						#LinkTo(href=resourceLink,text="read more")#
					</div>
					</div>
					<div style="clear: both;"></div>
					<!--- </div>
					</div> --->
					<cfif currentrow mod 2 eq 0 or currentrow eq recordcount></li></cfif>
					</cfloop>
				</ul>
				</div>
				<script type="text/javascript">
					$(function(){
						SmartTruncate('.truncated-guide p',30,188,true);
						SmartTruncate('.hold-resource h4 a',33,188,true);
					});
				</script>
			</div>
			<div class="foot">
				<ul class="switcher">
					<li class="active"><a href="##"><span>1</span></a></li>
					<li><a href="##"><span>2</span></a></li>
					<li><a href="##"><span>3</span></a></li>
					<li><a href="##"><span>4</span></a></li>
				</ul>
				#LinkTo(controller="ask-a-doctor",action="categories",text="view all questions")#
			</div>
		</div>
	</div>
</cfoutput>