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

<cfif qQuestions.recordCount Gt 0>
	<h1>#qProcedure.name# Questions and Answers Archive</h1>
	<div class="pagination">#includePartial("/shared/_pagination.cfm")#</div>

	<dl>
		<cfset displayCount = 0>
		<cfset groupAnswersCount = 0>
		<cfset previousQuestionId = 0>

		<cfloop query="qQuestions">
			<cfif qQuestions.siloName NEQ "" AND isDate(qQuestions.approvedAt) AND qQuestions.approvedAt LTE now()>
				<cfset displayCount = displayCount + 1>
				<cfset thisQuestionId = qQuestions.xFactorQuestionId>


				<!--- Check if the next and previous question is the same question, and group the answers under this question --->
				<cfset groupAnswers = FALSE>
				<cfset thisPatientId = qQuestions.patientId>
				<cfset previousPatientId = qQuestions.patientId[DecrementValue(qQuestions.CurrentRow)]>
				<cfset nextPatientId = qQuestions.patientId[IncrementValue(qQuestions.CurrentRow)]>

				<cfif thisPatientId EQ previousPatientId AND previousQuestionId EQ qQuestions.xFactorQuestionId[DecrementValue(qQuestions.CurrentRow)]>
					<!--- This and the previous question are the same. Start to number the question. Make sure the previous question actually displayed though --->
					<cfset groupAnswers = TRUE>
					<cfset groupAnswersCount = groupAnswersCount + 1>

				<cfelseif thisPatientId EQ nextPatientId>
					<cfset groupAnswersCount = 1>

				<cfelse>
					<cfset groupAnswers = FALSE>
					<cfset groupAnswersCount = 0>

				</cfif>


				<cfif groupAnswers IS FALSE>
					<cfif isDate(qQuestions.approvedAt)>
						<cfif DateDiff("yyyy",qQuestions.approvedAt,now()) eq 0>
							<div class="dateflag">#Replace(DateFormat(qQuestions.approvedAt,"mmm d")," ","<br>")#</div>
						<cfelse>
							<div class="dateflag">#Replace(DateFormat(qQuestions.approvedAt,"mmm yyyy")," ","<br>")#</div>
						</cfif>
					</cfif>
					<h2><a name="#qQuestions.xFactorQuestionId#">#qQuestions.title#</a></h2>

					<h3 class="ArchiveQA">Question:</h3>
					#qQuestions.question#
					<cfif isDefined("qQuestions.patientFirstName") AND qQuestions.patientFirstName NEQ "" AND NOT FindNoCase(qQuestions.patientFirstName, qQuestions.question)>
						<span style="white-space: nowrap;"> - #qQuestions.patientFirstName#</span><br /><br />
					</cfif>
				</cfif>

				<h3 class="ArchiveQA">Answer<cfif groupAnswersCount GT 0>&nbsp;#groupAnswersCount#</cfif>:<!---  (#thisPatientId#) ---></h3>

					<cfsaveContent variable="altText">
						#qQuestions.firstname# #qQuestions.middleName# #qQuestions.lastName#<cfif qQuestions.doctorTitle NEQ "">, #qQuestions.doctorTitle#</cfif>
					</cfsaveContent>

					<cfif qQuestions.photoFileName NEQ "">
					<p>
					<cfif NOT qQuestions.isDeactivated><a href="/#qQuestions.doctorSiloName#"></cfif>
					<img alt="#altText# - LocateADoc.com" alt="#altText# - LocateADoc.com" src="/images/profile/doctors/#qQuestions.photoFileName#" style="width: 100px; float: left;">
					<cfif NOT qQuestions.isDeactivated></a></cfif>
					</cfif>
					#qQuestions.answer#
					</p>
					<p style="text-align: right; padding-bottom 10px;">
						--<cfif NOT qQuestions.isDeactivated><a href="/#qQuestions.doctorSiloName#" name="#altText#"></cfif>#altText#<cfif NOT qQuestions.isDeactivated></a></cfif><br><em>#qQuestions.city#, #qQuestions.state#</em>
					</p>

				<cfif thisPatientId NEQ nextPatientId><BR><BR></cfif>

				<cfset previousQuestionId = qQuestions.xFactorQuestionId>
			</cfif>
		</cfloop>

		<cfif displayCount EQ 0>
			<!--- no active questions for this archive page. We will redirct to the Ask A Doctor procedure page --->
			<cflocation addtoken="false" statuscode="301" url="/ask-a-doctor/questions/#qProcedure.siloName#">
		</cfif>
	</dl>

	<div class="pagination">#includePartial("/shared/_pagination.cfm")#</div>
<cfelse>
	<H1> Health Questions and Answers</H1>

	<p>Our expert doctors and specialists have prepared an archive of health related questions and answers that have been asked of them. You may search our Answer Archive below to see if there is an answer to your health question. If you would like to see all the questions and answers for a certain specialty you may browse the archive.<p>

			<H2>Most Popular Specialties</H2>
			<TABLE CELLPADDING="8" CELLSPACING="0" BORDER="0">
			<TR>
				<TD VALIGN="top"><H3>Plastic Surgery</H3>
				<UL><LI><A HREF="/ask-a-doctor/archive/2831">Abdomen</A><br>Total Q&A: 38
					<LI><A HREF="/ask-a-doctor/archive/186">Arm Lifts (Brachioplasty)</A><br>Total Q&A: 3
					<LI><A HREF="/ask-a-doctor/archive/191">Body Lift</A><br>Total Q&A: 4
					<LI><A HREF="/ask-a-doctor/archive/3141">Breast Augmentation  (Saline Implants)</A><br>Total Q&A: 85
					<LI><A HREF="/ask-a-doctor/archive/2131">Breast Augmentation (Breast Implants)</A><br>Total Q&A: 48
					<LI><A HREF="/ask-a-doctor/archive/196">Breast Lift Surgery</A><br>Total Q&A: 3
					<LI><A HREF="/ask-a-doctor/archive/197">Breast Reconstruction Surgery</A><br>Total Q&A: 8
					<LI><A HREF="/ask-a-doctor/archive/858">Breast Reduction Surgery</A><br>Total Q&A: 52
					<LI><A HREF="/ask-a-doctor/archive/1621">Buttocks Augmentation (Butt Implants)</A><br>Total Q&A: 1
					<LI><A HREF="/ask-a-doctor/archive/1472">Calf Augmentation (Implants)</A><br>Total Q&A: 1<LI><A HREF="/ask-a-doctor/archive/1894">Cosmetic BOTOX®</A><br>Total Q&A: 10<LI><A HREF="/ask-a-doctor/archive/992">Cosmetic Laser Procedures</A><br>Total Q&A: 4<LI><A HREF="/ask-a-doctor/archive/213">Electrosurgical Skin Resurfacing</A><br>Total Q&A: 24<LI><A HREF="/ask-a-doctor/archive/214">Endoscopic Plastic Surgery</A><br>Total Q&A: 2<LI><A HREF="/ask-a-doctor/archive/1976">Eyelid Lift Surgery (Blepharoplasty)</A><br>Total Q&A: 16<LI><A HREF="/ask-a-doctor/archive/1403">Face Lift Surgery (Rhytidectomy)</A><br>Total Q&A: 12<LI><A HREF="/ask-a-doctor/archive/221">Hand Surgery</A><br>Total Q&A: 17<LI><A HREF="/ask-a-doctor/archive/222">Inverted Nipple Repair</A><br>Total Q&A: 3<LI><A HREF="/ask-a-doctor/archive/2127">Liposuction Surgery (Lipoplasty)</A><br>Total Q&A: 3<LI><A HREF="/ask-a-doctor/archive/1072">Neck Lift</A><br>Total Q&A: 8<LI><A HREF="/ask-a-doctor/archive/804">Nipple Reduction</A><br>Total Q&A: 9<LI><A HREF="/ask-a-doctor/archive/249">Skin Rejuvenation</A><br>Total Q&A: 4<LI><A HREF="/ask-a-doctor/archive/226">Thigh (Leg) Lift</A><br>Total Q&A: 7<LI><A HREF="/ask-a-doctor/archive/2174">Thigh Liposculpture (Liposuction)</A><br>Total Q&A: 65<LI><A HREF="/ask-a-doctor/archive/3298">Tummy Tuck (Abdominoplasty) </A><br>Total Q&A: 43<LI><A HREF="/ask-a-doctor/archive/253">Ultrasonic Liposuction</A><br>Total Q&A: 9</UL><H3>LASIK - Laser Eye Surgery</H3>
				<UL><LI><A HREF="/ask-a-doctor/archive/1500">Cataract Surgery</A><br>Total Q&A: 17
					<LI><A HREF="/ask-a-doctor/archive/1506">Corneal Transplant Surgery</A><br>Total Q&A: 4
					<LI><A HREF="/ask-a-doctor/archive/1528">Excimer LASIK</A><br>Total Q&A: 4
					<LI><A HREF="/ask-a-doctor/archive/1543">Hyperopic Implantable Contact Lens</A><br>Total Q&A: 2
					<LI><A HREF="/ask-a-doctor/archive/1546">Implantable Contact Lens</A><br>Total Q&A: 2
					<LI><A HREF="/ask-a-doctor/archive/1549">INTACS</A><br>Total Q&A: 5
					<LI><A HREF="/ask-a-doctor/archive/700">LASEK</A><br>Total Q&A: 8<LI><A HREF="/ask-a-doctor/archive/372">LASIK Eye Surgery</A><br>Total Q&A: 174<LI><A HREF="/ask-a-doctor/archive/178">Photo-Astigmatic Refractive Keratectomy</A><br>Total Q&A: 1<LI><A HREF="/ask-a-doctor/archive/1587">Presbyopia Surgery</A><br>Total Q&A: 3<LI><A HREF="/ask-a-doctor/archive/1590">PRK (Photorefractive Keratectomy)</A><br>Total Q&A: 1<LI><A HREF="/ask-a-doctor/archive/800">Pterygium Surgery</A><br>Total Q&A: 1<LI><A HREF="/ask-a-doctor/archive/1599">Refractive Cataract Surgery</A><br>Total Q&A: 20<LI><A HREF="/ask-a-doctor/archive/1611">Toric Contact Lens</A><br>Total Q&A: 2<LI><A HREF="/ask-a-doctor/archive/791">Wavefront Treatment for Irregular Astigmatism</A><br>Total Q&A: 1</UL><H3>Hair Restoration (Replacement)</H3>
				<UL><LI><A HREF="/ask-a-doctor/archive/1645">Hair Transplants (Scalp)</A><br>Total Q&A: 7</UL><H3>Dentistry</H3>
				<UL><LI><A HREF="/ask-a-doctor/archive/895">Extractions of Teeth</A><br>Total Q&A: 20<LI><A HREF="/ask-a-doctor/archive/880">Regular Checkup</A><br>Total Q&A: 2<LI><A HREF="/ask-a-doctor/archive/894">TMJ Treatments</A><br>Total Q&A: 28<LI><A HREF="/ask-a-doctor/archive/882">Tooth-Colored Fillings</A><br>Total Q&A: 4</UL><H3>Acupuncture</H3>
				<UL><LI><A HREF="/ask-a-doctor/archive/672">Facial Renewal Acupuncture</A><br>Total Q&A: 4</UL>
				</TD>
				<TD VALIGN="top">
				<H3>Orthopedic Surgery</H3> <UL><LI><A HREF="/ask-a-doctor/archive/669">Knee and hip replacement surgery</A><br>Total Q&A: 1</UL><H3>Infertility (IVF)</H3> <UL><LI><A HREF="/ask-a-doctor/archive/337">Artificial Insemination</A><br>Total Q&A: 22<LI><A HREF="/ask-a-doctor/archive/341">Egg Donation</A><br>Total Q&A: 6<LI><A HREF="/ask-a-doctor/archive/338">In Vitro Fertilization (IVF)</A><br>Total Q&A: 36<LI><A HREF="/ask-a-doctor/archive/943">Sperm Cryopreservation (Sperm Freezing)</A><br>Total Q&A: 2<LI><A HREF="/ask-a-doctor/archive/944">Testicular Biopsy</A><br>Total Q&A: 2<LI><A HREF="/ask-a-doctor/archive/1482">Tubal Ligation Reversal</A><br>Total Q&A: 2<LI><A HREF="/ask-a-doctor/archive/941">Varicocele Repair</A><br>Total Q&A: 1</UL><H3>Facial Plastic Surgery</H3>
				 <UL><LI><A HREF="/ask-a-doctor/archive/1856">Birthmark Removal</A><br>Total Q&A: 4<LI><A HREF="/ask-a-doctor/archive/2153">Blepharoplasty (Asian Eyes)</A><br>Total Q&A: 10<LI><A HREF="/ask-a-doctor/archive/2086">BOTOX® Injections Treatment</A><br>Total Q&A: 90<LI><A HREF="/ask-a-doctor/archive/2146">Brow Lift (Forehead Lift)</A><br>Total Q&A: 6<LI><A HREF="/ask-a-doctor/archive/1469">Cheek Augmentation (Implants)</A><br>Total Q&A: 4<LI><A HREF="/ask-a-doctor/archive/1804">Chemical Peel</A><br>Total Q&A: 30<LI><A HREF="/ask-a-doctor/archive/1464">Chin Augmentation (Implants)</A><br>Total Q&A: 12<LI><A HREF="/ask-a-doctor/archive/1891">Collagen Injection Treatments</A><br>Total Q&A: 15<LI><A HREF="/ask-a-doctor/archive/27">Craniofacial Surgery</A><br>Total Q&A: 10<LI><A HREF="/ask-a-doctor/archive/1928">Dermabrasion</A><br>Total Q&A: 52<LI><A HREF="/ask-a-doctor/archive/4">Ear Surgery (Otoplasty)</A><br>Total Q&A: 794<LI><A HREF="/ask-a-doctor/archive/1400">Endoscopic Forehead Lift</A><br>Total Q&A: 6<LI><A HREF="/ask-a-doctor/archive/30">Eyelid Surgery (Blepharoplasty)</A><br>Total Q&A: 16<LI><A HREF="/ask-a-doctor/archive/1850">Fat Injections</A><br>Total Q&A: 16<LI><A HREF="/ask-a-doctor/archive/1787">Laser Hair Removal</A><br>Total Q&A: 45<LI><A HREF="/ask-a-doctor/archive/1826">Laser Tattoo Removal</A><br>Total Q&A: 18<LI><A HREF="/ask-a-doctor/archive/19">Lip Augmentation</A><br>Total Q&A: 12<LI><A HREF="/ask-a-doctor/archive/2">Lower Eyelid Surgery (Blepharoplasty)</A><br>Total Q&A: 10<LI><A HREF="/ask-a-doctor/archive/1936">Microdermabrasion</A><br>Total Q&A: 25<LI><A HREF="/ask-a-doctor/archive/1810">Mole Removal</A><br>Total Q&A: 50<LI><A HREF="/ask-a-doctor/archive/22">Neck Liposuction</A><br>Total Q&A: 10<LI><A HREF="/ask-a-doctor/archive/3904">Nose Job (Rhinoplasty)</A><br>Total Q&A: 102<LI><A HREF="/ask-a-doctor/archive/1821">Permanent Cosmetics</A><br>Total Q&A: 3<LI><A HREF="/ask-a-doctor/archive/2092">Restylane® Injection</A><br>Total Q&A: 15<LI><A HREF="/ask-a-doctor/archive/24">Scalp Flaps / Scalp Lift</A><br>Total Q&A: 8<LI><A HREF="/ask-a-doctor/archive/1798">Tattoo Removal</A><br>Total Q&A: 30</UL><H3>Cosmetic Dentistry</H3> <UL><LI><A HREF="/ask-a-doctor/archive/1629">Bridges (Dental Partials)</A><br>Total Q&A: 2<LI><A HREF="/ask-a-doctor/archive/373">Corrective Jaw Surgery</A><br>Total Q&A: 8<LI><A HREF="/ask-a-doctor/archive/631">Cosmetic and Restorative Dentistry</A><br>Total Q&A: 2<LI><A HREF="/ask-a-doctor/archive/156">Cosmetic Gum Contouring</A><br>Total Q&A: 6<LI><A HREF="/ask-a-doctor/archive/155">Dental Veneers</A><br>Total Q&A: 32<LI><A HREF="/ask-a-doctor/archive/39">Orthodontics</A><br>Total Q&A: 48<LI><A HREF="/ask-a-doctor/archive/34">Porcelain Veneers</A><br>Total Q&A: 24<LI><A HREF="/ask-a-doctor/archive/1637">Root Canals (Endodontic Therapy)</A><br>Total Q&A: 12<LI><A HREF="/ask-a-doctor/archive/32">Tooth Whitening</A><br>Total Q&A: 4</UL>
				</TD>
			</TR>
			</TABLE>

			<H2>Other Specialties</H2>
			<TABLE CELLPADDING="8" CELLSPACING="0" BORDER="0">
			<TR>
				<TD VALIGN="top"><H3>Urology</H3>
				<UL><LI><A HREF="/ask-a-doctor/archive/630">Vasectomy Reversal</A><br>Total Q&A: 9</UL><H3>Orthodontics (Dentistry)</H3>
				<UL><LI><A HREF="/ask-a-doctor/archive/332">Invisalign</A><br>Total Q&A: 12</UL><H3>Optometry</H3>
				<UL><LI><A HREF="/ask-a-doctor/archive/4160">Complete Eye Examinations</A><br>Total Q&A: 6</UL>
				</TD>
				<TD VALIGN="top">
				<H3>Podiatry</H3> <UL><LI><A HREF="/ask-a-doctor/archive/640">Blisters</A><br>Total Q&A: 7<LI><A HREF="/ask-a-doctor/archive/646">Dry Skin</A><br>Total Q&A: 2<LI><A HREF="/ask-a-doctor/archive/649">Fractures</A><br>Total Q&A: 7<LI><A HREF="/ask-a-doctor/archive/652">Gangrene</A><br>Total Q&A: 1<LI><A HREF="/ask-a-doctor/archive/653">Gout</A><br>Total Q&A: 1<LI><A HREF="/ask-a-doctor/archive/658">Neuroma</A><br>Total Q&A: 2<LI><A HREF="/ask-a-doctor/archive/659">Orthotics and Biomechanical Problems</A><br>Total Q&A: 1<LI><A HREF="/ask-a-doctor/archive/664">Tendonitis</A><br>Total Q&A: 1<LI><A HREF="/ask-a-doctor/archive/666">Warts</A><br>Total Q&A: 15</UL><H3>Oral & Maxillofacial Surgery</H3> <UL><LI><A HREF="/ask-a-doctor/archive/898">Dental Crowns (Implant)</A><br>Total Q&A: 12<LI><A HREF="/ask-a-doctor/archive/905">Facial Cosmetic Surgery</A><br>Total Q&A: 5<LI><A HREF="/ask-a-doctor/archive/381">Genioplasty</A><br>Total Q&A: 2<LI><A HREF="/ask-a-doctor/archive/965">Jaw Surgery</A><br>Total Q&A: 10<LI><A HREF="/ask-a-doctor/archive/966">orthognathic surgery</A><br>Total Q&A: 4<LI><A HREF="/ask-a-doctor/archive/903">Teeth Extraction</A><br>Total Q&A: 60<LI><A HREF="/ask-a-doctor/archive/904">Wisdom Teeth Extraction</A><br>Total Q&A: 18</UL><H3>Dermatology</H3> <UL><LI><A HREF="/ask-a-doctor/archive/1868">Acne Treatments</A><br>Total Q&A: 66<LI><A HREF="/ask-a-doctor/archive/67">Arm Liposuction</A><br>Total Q&A: 12<LI><A HREF="/ask-a-doctor/archive/69">Nail Fungus</A><br>Total Q&A: 1<LI><A HREF="/ask-a-doctor/archive/61">Scar Revision / Scar Repair</A><br>Total Q&A: 230<LI><A HREF="/ask-a-doctor/archive/60">Sclerotherapy</A><br>Total Q&A: 24</UL>
				</TD>
			</TR>
			</TABLE>
</cfif>

				</div>
		</div>

			<!-- aside2 -->
			<div class="aside3" id="article-widgets">
				<!-- sidebox -->
				#includePartial("/shared/sharesidebox")#
				#includePartial("latestquestions")#
				#includePartial("experts")#
			</div>
		</div>
	</div>
</div>
</cfoutput>