<cfoutput>
<div class="sidebox">
	<div class="frame">
		<h4 class="withsubtitle">Latest <strong>Articles</strong></h4>
		<h3 class="subtitle">from LocateADoc.com</h3>
		<ul class="latestArticles">
		<cfloop query="latestArticles">
			<li>#linkTo(controller="article", action=latestArticles.siloName,text=latestArticles.title)#</li>
		</cfloop>
		</ul>
		#linkTo(action="articles",text="view all articles")#
	</div>
</div>
</cfoutput>