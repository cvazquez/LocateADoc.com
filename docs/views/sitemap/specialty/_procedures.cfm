<div class="SiteMapSurgerySpecialtiesHeader"><cfoutput>#specialty_name#</cfoutput> Procedures</div>
<div class="SiteMapSurgerySpecialtiesList">
<cfoutput query="qProcedures">
	<a href="/#qProcedures.procedure_silo_name#">#qProcedures.procedure_name#<br />
</cfoutput>
</div>