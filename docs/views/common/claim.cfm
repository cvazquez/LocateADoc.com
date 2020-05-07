<cfoutput>
<cfif isObject(qDoctor)>
	<p>#qDoctor.firstName# #qDoctor.lastName#, #qDoctor.title#,</p>

	<p>By claiming your profile and updating the content on your profile, you will enhance your presence and reputation online by taking control of another page in the search engine results. Claiming your listing and adding content including your photo to your profile is free. Additionally, you will receive 8 complimentary leads to try out our service.</p>

	<p>Add your Profile Listing and this profile will be merged with the new one you are creating. <a href="/doctor-marketing/add-listing">Add your Profile Listing</a> in our Doctors Only area today. It's quick and easy.</p>

	<p>Please contact us with any questions, 1-888-834-8593 or email <a href="mailto:info@LocateADoc.com?Subject=LocateADoc.com%20New%20Listing%20Inquiry">info@LocateADoc.com</a>.</p>
<cfelse>
	<p style="font-size: 1.5em; font-weight: bold; color: maroon;">You have entered an invalid doctor.</p>
</cfif>
</cfoutput>
<cfsetting showdebugoutput="false">