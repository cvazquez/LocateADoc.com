<cfif recentCategories.recordCount GT 0>
<cfparam default="" name="procedureSiloName">

<cfset categoriesLink = "/ask-a-doctor/categories">

<cfhtmlhead text='<script type="text/javascript" src="/javascripts/askadoctor/recentcategories.js"></script>'>

<!-- sidebox -->
<cfoutput>
<div class="sidebox">
	<div class="frame">
		<h4 class="withsubtitle"><a href="#categoriesLink#" style="text-decoration: none;">Recent <strong>Categories</strong></a></h4>
		<ul class="latestCategories">
		<cfloop query="recentCategories">
			<li <cfif recentCategories.currentRow GT 5> class="hide"</cfif>>
				<a href="/ask-a-doctor/questions/#recentCategories.siloName#" class="askADoctorRecentCategoryLink">#recentCategories.procedureName#</a>
			</li>
		</cfloop>
		</ul>

		<div class="TextAlignRight"><a href="#categoriesLink##(recentCategoriesTotal GT 10 ? 'page-2' : '' )#">view more categories</a></div>
	</div>
</div>
</cfoutput>
</cfif>