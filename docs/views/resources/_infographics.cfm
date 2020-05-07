<cfoutput>
<div class="sidebox trending">
	<div class="frame">
		<h4><a href="http://www.locateadoc.com/article/locateadoccom-s-top-infographics" style="text-decoration: none;">Popular <strong>Infographics</strong></h4>
		<ul>
		<cfloop query="infoGraphics">
			<li><a href="#URLFor(controller="article", action="#infoGraphics.siloName#")#">#infoGraphics.title#</a></li>
		</cfloop>
		</ul>
	</div>
</div>
</cfoutput>