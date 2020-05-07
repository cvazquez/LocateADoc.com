<cfif featuredResources.recordCount GT 0 AND isdefined("featuredResources.resource")>
<cfoutput>
	<div class="small-block image-block"
		style="	margin: 20px 10px;
				float: left;
				padding: 20px 18px;
				display: inline;
				width: 226px;
				font: 12px/15px Arial, Helvetica, sans-serif;
				background: url(/images/layout/bg-small-block.png) no-repeat;">
	<div class="resources">
		<a href="/resources" style="text-decoration:none;"><h3>Featured <strong>Resources</strong></h3></a>

		<div class="box gallery" style="padding-top: 5px;">
			<div class="column-height" style="height:300px;">
				<div class="hold">
				<ul class="articles">
					<cfloop query="featuredResources">
					<cfif currentrow mod 3 eq 1><li class="hold-list"></cfif>
					<div class="hold-resource-outer">
					<div class="hold-resource">
							<!--- <em class="date">#DateFormat(featuredResources.createdAt,"mm.dd.yy")#</em> --->
							<cfif featuredResources.resource eq "guide">
								<cfif val(featuredResources.specialtyID)>
									<cfset resourceLink = URLFor(controller=featuredResources.specialtySiloName)>
									<cfset resourceLinkText = "#featuredResources.specialtyname# Guides">
								<cfelse>
									<cfset resourceLink = URLFor(controller=featuredResources.procedureSiloName)>
									<cfset resourceLinkText = "#featuredResources.procedurename# Guides">
								</cfif>
							<cfelse>
								<cfset resourceLink = URLFor(controller="article",action=featuredResources.siloName)>
								<cfset resourceLinkText = featuredResources.title>
							</cfif>
							<h4>#LinkTo(href=resourceLink,text=resourceLinkText)#</h4>
							<cfset filteredContent = REReplace(featuredResources.content,"</?span[^>]*?>"," ","all")>
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
							</p></div>
							#LinkTo(href=resourceLink,text="read more")#

					</div>
					</div>
					<cfif currentrow mod 3 eq 0 or currentrow eq recordcount></li></cfif>
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
			<div class="foot" style="width: 230px;">
				<ul class="switcher">
					<li class="active"><a href="##"><span>1</span></a></li>
					<li><a href="##"><span>2</span></a></li>
					<li><a href="##"><span>3</span></a></li>
					<li><a href="##"><span>4</span></a></li>
				</ul>
				#LinkTo(controller="resources",text="view all resources")#
			</div>
		</div>
	</div>
	</div>
</cfoutput>
</cfif>