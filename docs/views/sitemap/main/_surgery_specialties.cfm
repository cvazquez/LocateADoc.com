<div class="SiteMapSurgerySpecialtiesHeader">Surgery Specialties</div>
<div class="SiteMapSurgerySpecialtiesList">
<cfoutput query="qSpecialties">
	#linkTo(text="#qSpecialties.name#", action="specialty", key="#qSpecialties.silo_name#")#<br />
<!--- 	<a href="/sitemapw/#qSpecialties.silo_name#.html">#qSpecialties.name#<br /> --->
</cfoutput>
</div>