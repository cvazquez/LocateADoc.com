<cfset styleSheetLinkTag(source	= "askadoctor/question", head	= true)>

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

				<div class="article">
					<cfif isDate(Question.publishAt)>
						<cfset thisDate = Question.publishAt>
					<cfelseif isDate(Question.createdAt)>
						<cfset thisDate = Question.createdAt>
					<cfelse>
						<cfset thisDate = "">
					</cfif>

					<cfif isDate(thisDate)>
						<cfif DateDiff("yyyy",thisDate,now()) eq 0>
							<div class="dateflag">#Replace(DateFormat(thisDate,"mmm d")," ","<br>")#</div>
						<cfelse>
							<div class="dateflag">#Replace(DateFormat(thisDate,"mmm yyyy")," ","<br>")#</div>
						</cfif>
					</cfif>

					<h1 class="blog-head">#Question.header#</h1>


					<cfif IsDate(Question.publishAt)>
						<p class="post-date">posted on #DateFormat(Question.publishAt ,"m/d/yyyy")#</p>
					</cfif>


					<cfif answers.recordCount GT 0>
						<p><strong><em><span style="font-size: 20px;">Ask A Doctor Question:</span>&nbsp;</em></strong></p>
					</cfif>

					<cfset filteredContent = Question.content>
					<cfif Find("<h2",filteredContent) eq 0>
						<cfset filteredContent = REReplace(filteredContent,"h3","h2","all")>
					</cfif>
					#filteredContent#
					<cfif isDefined("Question.firstName") AND Question.firstName NEQ "" AND NOT reFindNoCase(Question.firstName, filteredContent)>
						<span style="white-space: nowrap;"> - #Question.firstName#</span>
					</cfif>

					<cfif answers.recordCount GT 0>
						<div id="answers">
						<!--- <p><strong><em><span style="font-size: 20px;">Answer<cfif answers.recordCount GT 1>s</cfif>:&nbsp;</span></em></strong></p> --->
						<cfloop query="answers">
							<div class="answer">
							<p><strong><em><span style="font-size: 20px;">Answer:&nbsp;</span></em></strong></p>
							<cfsaveContent variable="altText">
								#answers.firstname# #answers.middleName# #answers.lastName#<cfif answers.title NEQ "">, #answers.title#</cfif>
							</cfsaveContent>

							<p>
							<cfif answers.photoFileName NEQ "">
								<cfif NOT answers.isDeactivated><a href="/#answers.doctorSiloName#"></cfif>
								<img alt="#altText# - LocateADoc.com" alt="#altText# - LocateADoc.com" src="/images/profile/doctors/#answers.photoFileName#" style="width: 100px; float: left;">
								<cfif NOT answers.isDeactivated></a></cfif>
							</cfif>
							#answers.content#
							</p>
							<p style="text-align: right; padding-bottom 10px;">
								--<cfif NOT answers.isDeactivated><a href="/#answers.doctorSiloName#" name="#altText#"></cfif>#altText#<cfif NOT answers.isDeactivated></a></cfif><br>
								<cfif answers.phone NEQ ""><em>#formatPhone(answers.phone)#</em><br /></cfif>
								<em>#answers.city#, #answers.state#</em>
							</p>
							<div class="clear"></div>
							</div>
							<!--- <div class="clear" style="border-top: 2px solid; border-color: rgba(0,39,59,.08); width: 440px; margin: auto;"></div> --->
						</cfloop>
						</div>
					</cfif>

					<div style="width: 30%; margin-left: auto; margin-right: auto; padding-top: 15px;"><a href="/ask-a-doctor" class="btn-askadoctor SWbutton"></a></div>

					<p class="askadoctor-conditions">LocateADoc.com does not evaluate or guarantee the accuracy of any Ask A Doctor Q&A content. <a href="/home/terms">Read full conditions of use here</a>.</p>
				</div>

				<div class="post-info">
					<cfif ListLen(Question.specialtyIDs) + ListLen(Question.procedureIDs)>
						<div class="metadata">
							posted in
							<cfset postList = "">
							<cfloop from="1" to="#ListLen(Question.specialtyIDs)#" index="i">
								<cfset postList = ListAppend(postList,LinkTo(action="questions",key="#ListGetAt(Question.specialtySilonames,i)#",text=ListGetAt(Question.specialties,i,":")))>
							</cfloop>
							<cfloop from="1" to="#ListLen(Question.procedureIDs)#" index="i">
								<cfset postList = ListAppend(postList,LinkTo(action="questions",key="#ListGetAt(Question.procedureSilonames,i)#",text=ListGetAt(Question.procedures,i,":")))>
							</cfloop>
							#postList#
						</div>
					</cfif>
				</div>

				<!--- COMMENTS --->
				<div id="disqus_thread"></div>
				<script type="text/javascript">
				    var disqus_shortname = 'locateadoc';
				    var disqus_identifier = 'article_#Question.ID#';
				    var disqus_url = 'http://www.locateadoc.com/ask-a-doctor/question/#params.key#';
				    <cfif Globals.domain eq "dev3.locateadoc.com">
				    	var disqus_developer = 1;
				    </cfif>

				    $(function(){
				        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
				        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
				        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
				    });
				</script>
				<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
		</div>

			<!-- aside2 -->
			<div class="aside3" id="article-widgets">
				<!-- sidebox -->
				#includePartial("/shared/sharesidebox")#
				<cfif latestPictures.recordCount GT 0>
					#includePartial("/shared/beforeandaftersidebox")#
				</cfif>
				#includePartial("latestquestions")#
				#includePartial("recentcategories")#
				#includePartial("experts")#
			</div>
		</div>
	</div>
</div>
</cfoutput>