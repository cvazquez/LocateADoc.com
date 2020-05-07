<cfcomponent extends="Controller" output="false">

	<cffunction name="init">

	</cffunction>

	<cffunction name="index">
		<cfset stylesheetLinkTag(sources="sitemap/index", head=true)>

		<cfset title = "Site Map - LocateADoc.com">
		<cfset metaDescriptionContent = "Research your procedure and find doctors in your area for plastic surgery, breast implants, breast augmentation, and more.">
		<cfset pageTitle = "<h2>find <span>your</span> doctor</h2><strong class='subtitle'><em>150,000+</em> doctors including Cosmetic and Plastic Surgery, Bariatrics, Hair Restoration, LASIK, Cosmetic Dentistry and IVF specialties</strong>">

		<cfset qSpecialties = model("SiteMapSpecialty").findAll(select="name,silo_name", where="live=1 AND category=1", order="name")>

		<cfset state_columns = 3>
		<cfset qStates = model("StateSummary").findAll(	select="name,siloName",
														where="countryId = 102",
														order="name")>

		<cfset qStatesCanada = model("StateSummary").findAll(	select="name,siloName",
																where="countryId = 12",
																order="name")>

		<cfset qStatesMexico = model("StateSummary").findAll(	select="name,siloName",
																where="countryId = 48",
																order="name")>
	</cffunction>

	<cffunction name="specialty">
		<cfset stylesheetLinkTag(sources="sitemap/index", head=true)>

		<cfset specialty_id = "">
		<cfset silo_name = params.key>

		<cfset specialty_name = "">
		<cfset doctor_singular = "">

		<cfset qProcedures = model("Specialty").findAll(
						select	= "	specialties.id AS specialtyId,
									specialties.name AS specialtyName,
									specialties.doctorSingular,
									procedures.name AS procedure_name,
									procedures.siloName AS PROCEDURE_SILO_NAME",
						include	= "SpecialtyProcedures(Procedure(resourceGuideProcedures(resourceGuide)))",
						where	= "specialties.siloName = '#silo_name#' AND resourceguides.content is not null",
						order	= "procedures.name")>


		<!--- <cfset specialty_id = qProcedures.specialtyId> --->
		<cfset specialties = model("Specialty").FindOneBySiloName(	select	= "id, name, doctorSingular",
																	value	 = silo_name)>
		<cfset specialty_id = specialties.id>

		<cfset specialty_name = specialties.name>
		<cfset doctor_singular = specialties.doctorSingular>

		<cfset title = "Site Map - #specialty_name# - LocateADoc.com">
		<cfset metaDescriptionContent = "Research your procedure and find doctors in your area for plastic surgery, breast implants, breast augmentation, and more.">
		<cfset pageTitle = "<h2>find <span>your</span> doctor</h2><strong class='subtitle'><em>150,000+</em> doctors including Cosmetic and Plastic Surgery, Bariatrics, Hair Restoration, LASIK, Cosmetic Dentistry and IVF specialties</strong>">


		<cfset qStates = model("Specialty").GetStates(specialtyId=specialty_id,countryId=102)>
		<cfset qStatesCanada = model("Specialty").GetStates(specialtyId=specialty_id,countryId=12)>
		<cfset qStatesMexico = model("Specialty").GetStates(specialtyId=specialty_id,countryId=48)>
		<cfset state_columns = 3>
	</cffunction>

</cfcomponent>