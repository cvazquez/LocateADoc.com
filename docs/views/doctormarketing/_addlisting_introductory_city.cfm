<cfset imageFileName = ''>
<cfswitch expression="#params.specialtyID#">
	<cfcase value="29">
		<cfset imageFileName = 'acupuncture'>
	</cfcase>
	<cfcase value="5">
		<cfset imageFileName = 'chiropractor'>
	</cfcase>
	<cfcase value="1,3">
		<cfset imageFileName = 'dentistry'>
	</cfcase>
	<cfcase value="39,12,19,13">
		<cfset imageFileName = 'optometryandeyecategories'>
	</cfcase>
</cfswitch>

<style>

.full-content {
    width: 98%!important;
	font: 16px/18px BreeLight,Arial,Helvetica,sans-serif;
	padding: 30px 0px 25px 10px!important;
}

div#moreFeatures .full-content {
    width: <cfif imageFileName NEQ "">58<cfelse>100</cfif>%!important;
	padding: 0px 0px 0px!important;
	font: 16px/18px BreeLight,Arial,Helvetica,sans-serif;
}

div#moreFeatures table.more-features tr:nth-child(even){
	background-color: #C7D8D8!important;
}
div#moreFeatures table.more-features tr:nth-child(odd){
	background-color: white!important;
}

div#moreFeatures{
    width: <cfif imageFileName NEQ "">70<cfelse>100</cfif>%;
    float: left;
}

#imageFileName{
	    float: left;
    /* width: 30%; */
    margin-top: 4%;
    margin-left: -26%;
}

#imageFileName img{
    border: none;
    width: 480px;
}
}
</style>

<cfoutput>
<div class="full-content">
	<h1 class="title-shadow">Introductory City Listings</h1>

	<p style="margin-right: 15px;">Thank you for choosing LocateADoc.com to help you connect with more prospective patients and clients. Since you chose <strong>#SP_titles.specialty#</strong> as your primary area to list your practice, you are eligible for our <strong>Introductory City Listing</strong> which gives your practice:</p>

	<div id="moreFeatures">
		#includePartial(	partial		= "morefeatures",
							introOnly	= true)#
	</div>

	<cfif imageFileName NEQ "">
		<div id="imageFileName">
			<img src="/images/doctors_only/intro/#imageFileName#.png">
		</div>
	</cfif>
	<div style="clear: both;"></div>

	<p>During our roll-out period, we are offering <strong>Introductory City Listings</strong> at the rate of $#introListingAmount# / month, while allowing you to cancel at any time after your first month. No risk with our secure credit card and check processing, on secure servers, plus a secure platform to manage your account. (SSL and PCI compliant).</p>

	<p style="text-align: center;">
		<form action="/doctor-marketing/add-listing" method="post">
			<input type="hidden" id="form-page" name="page" value="2">
			<input type="hidden" name="doctorfirstname" value="#params.doctorfirstname#">
			<input type="hidden" name="doctorlastname" value="#params.doctorlastname#">
			<input type="hidden" name="doctoremail" value="#params.doctoremail#">
			<input type="hidden" name="practicename" value="#params.practicename#">
			<input type="hidden" name="state" value="#params.state#">
			<input type="hidden" name="zip" value="#params.zip#">
			<input type="hidden" name="country" value="#params.country#">
			<input type="hidden" name="doctorphone" value="#params.doctorphone#">
			<input type="hidden" name="specialtyID" value="#params.specialtyID#">
			<input type="hidden" name="physician" value="#params.physician#">
			<input type="hidden" name="introductoryAccept" value="2">

			<div style="text-align: center;">
				<h2>YES, SIGN ME UP FOR $#INTROLISTINGAMOUNT#/MONTH</h2>
				<input type="submit" class="btn-red-orange" clicktrackkeyvalues="accountDoctorId:IntroductoryListing" clicktracklabel="Signup" clicktracksection="DoctorsOnly" value="Sign Up" style="border: none;">
			</div>
		</form>

	</p>

	<p>Additional lead generation features are available for an additional charge each month. Support packages are also available to further help set up your listing.
		If you want to extend your reach beyond your city, into more specialties, or add more exposure with additional lead generation tools, please <a href="http://www.practicedock.com/index.cfm/PageID/7150">contact us today</a>.</p>
</div>
</cfoutput>