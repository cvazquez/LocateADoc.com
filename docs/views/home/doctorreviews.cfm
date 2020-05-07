<cfoutput>
<h1>Doctor Reviews</h1>

<img class="patient-review-icon" src="/images/layout/patient-review-medical.png" />

<p>LocateADoc.com provides you with information that will help you choose a doctor.
We offer doctor reviews, general information about procedures, and a directory of over
150,000 physicians. Our website gives you what you need to make the right decisions for
yourself and your family.</p>

<p>Whenever you search for a doctor, you should research their background for information
that might help you decide whether he or she is the right doctor for you. With our
physician profiles, you can easily find out how many years of experience the doctors you
are considering have. You can also see their board certifications and other
qualifications while viewing their educational backgrounds. Though these are extremely
important factors in choosing a doctor, there are several other things you should also
consider.</p>

<p>Read testimonials and reviews written by real patients to find the right surgeon or
physician for you.  By reading patient testimonials, you can get an idea of how each
physician's patients feel about the results of their procedures, and the work of the
physician.</p>

<p>LocateADoc.com also gives you the opportunity to view <a href="/pictures">before and after photos</a> that
feature real patients and real results. By viewing these pictures, you can see the
doctor's expertise firsthand. With our sortable before and after galleries, you can
filter the photos by gender, age, and the specific procedure of your interest. You can
also filter the photos by location so that you can see the results patients have gotten
from surgeons in your area.</p>

<p>LocateADoc.com is a comprehensive overview that can help you <a href="/">find a doctor</a> or plastic
surgeon. We publish <a href="/resources">procedure guides</a>, doctor reviews, articles, and before and after
photo galleries to give you information when you are considering plastic and cosmetic
surgery or other medical procedures. We have everything you need to make an informed
decision. View our physician profiles and contact a doctor today.</p>

<h2>Doctor Reviews by Procedure / Treatment</h2>

<div class="doctor-review-procedures">
<cfloop query="ProcedureList">
	<cfif ProcedureList.currentrow mod 4 eq 1><div class="doctor-review_procedure_row"></cfif>
		<div class="doctor-review_procedure_cell"><a href="/#ProcedureList.siloName#/reviews">#ProcedureList.name#</a> (#ProcedureList.reviewCount#)</div>
	<cfif (ProcedureList.currentrow mod 4 eq 0) OR (ProcedureList.currentrow eq ProcedureList.recordcount)></div></cfif>
</cfloop>
</div>

<!--- <table class="doctor-review-procedures">
<cfloop query="ProcedureList">
	<cfif ProcedureList.currentrow mod 4 eq 1><tr></cfif>
		<td><a href="/#ProcedureList.siloName#/reviews">#ProcedureList.name#</a> (#ProcedureList.reviewCount#)</td>
	<cfif (ProcedureList.currentrow mod 4 eq 0) OR (ProcedureList.currentrow eq ProcedureList.recordcount)></tr></cfif>
</cfloop>
</table> --->

</cfoutput>