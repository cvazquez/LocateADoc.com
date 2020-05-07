<cfcomponent output="false" displayname="Clients Visual Database" extends="DashboardCommons">
<cffunction name="init">
	<cfargument name="account_id">
	<cfargument name="startDate" default="" required="false">
	<cfargument name="endDate" default="" required="false">

	<cfset super.init(account_id)>

	<cfset this.specialty_has_gallery = SpecialtyHasGallery()>
	<cfset this.specialty_has_financing = SpecialtyHasFinancing()>

</cffunction>

<cffunction name="GetLeadsGeo" returntype="query" access="public" output="false" hint="Returns the geographical position for each of this accounts leads">
	<cfset var qLeadsGeo = QueryNew("")>

	<cfquery name="qLeadsGeo" datasource="myLocateadoc" timeout="100">
	Select Distinct
	  f.folio_id,
	  Concat(f.firstname, ' ', f.lastname) as name,
	  hphone as phone,
	  f.zip,
	  date,
	  lat_dbl,
	  lon_dbl
	From folio f
	Join user_financing uf
	  On f.zip = uf.zip_tx
	<!--- Join util_postal up
	  On up.postal_id = uf.zip_tx --->
	Join util_postal up
	  On Left(f.zip, 5) = up.postal_code_tx
	Join doc_info di
	  On f.info_id = di.info_id
	Join lad_account_entities lae
	  On di.doctor_entity_id = lae.entity_id
	Where lae.account_id = <cfqueryparam value="#variables.account_id#">
	<!---   And uf.is_approved = 1 --->
	  And f.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
		AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
	  And f.is_active = 1 and f.is_duplicate = 0
	</cfquery>

	<cfreturn qLeadsGeo>

</cffunction>


<cffunction name="GetProfileMissingItems" access="public" returntype="query" output="false">
	<cfset var qProfileMissingItems = QueryNew("")>
	<cfset var qProfileMissingItemsCoupons = GetProfileMissingItemsCoupons()>
	<cfset var qProfileMissingItemsStaffBios = GetProfileMissingItemsStaffBios()>
	<cfset var qProfileMissingItemsProcedures = GetProfileMissingItemsProcedures()>
	<cfset var qProfileMissingItemsPatientTestimonial = GetProfileMissingItemsPatientTestimonial()>
	<cfset var qProfileMissingItemsTop5Procedures = GetProfileMissingItemsTop5Procedures()>
	<cfset var qProfileMissingItemsVirtualPracticeTour = GetProfileMissingItemsVirtualPracticeTour()>
	<cfset var qProfileMissingItemsBAGallery = GetProfileMissingItemsBAGallery()>
	<cfset var qProfileOlderBAGallery = GetProfileOlderBAGallery()>
	<cfset var qProfileMissingItemsFeederMarkets = GetProfileMissingItemsFeederMarkets()>
	<cfset var qProfileMissingItemsFiveBenefits = GetProfileMissingItemsFiveBenefits()>
	<cfset var qProfileMissingItemsUVP = GetProfileMissingItemsUVP()>
	<cfset var qProfileMissingItemsPhoto = GetProfileMissingItemsPhoto()>
	<cfset var qProfileMissingItemsLogo = GetProfileMissingItemsLogo()>
	<cfset var qProfileMissingItemsPracticeName = GetProfileMissingItemsPracticeName()>


	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItems" datasource="myLocateadoc">
		SELECT
		<cfif qProfileMissingItemsPracticeName.recordcount GTE 1>
			0 AS name_check,
			#qProfileMissingItemsPracticeName.entity_id# AS practicename_entity_id,
		<cfelse>
			1 AS name_check,
			lae.entity_id AS practicename_entity_id,
		</cfif>

		<cfif qProfileMissingItemsLogo.recordcount EQ 0>
			1 AS logo_check,
			lae.entity_id AS logo_entity_id,
		<cfelse>
			0 AS logo_check,
			#qProfileMissingItemsLogo.entity_id# AS logo_entity_id,
		</cfif>

		<cfif qProfileMissingItemsPhoto.recordcount GTE 1>
			0 AS photo_check,
			#qProfileMissingItemsPhoto.entity_id# AS photo_entity_id,
		<cfelse>
			1 AS photo_check,
			lae.entity_id AS photo_entity_id,
		</cfif>

		<cfif qProfileMissingItemsUVP.recordcount EQ 0>
			1 AS uvp_check,
			lae.entity_id AS uvp_entity_id,
		<cfelse>
			0 AS uvp_check,
			#qProfileMissingItemsUVP.entity_id# AS uvp_entity_id,
		</cfif>

		<cfif qProfileMissingItemsFiveBenefits.recordcount EQ 0>
			1 AS benefits_check,
			lae.entity_id AS top5benefits_entity_id,
		<cfelse>
			0 AS benefits_check,
			#qProfileMissingItemsFiveBenefits.entity_id# AS top5benefits_entity_id,
		</cfif>

		<cfif qProfileMissingItemsFeederMarkets.recordcount EQ 0>
			1 AS markets_check,
			lae.entity_id AS feeder_markets_entity_id,
		<cfelse>
			0 AS markets_check,
			#qProfileMissingItemsFeederMarkets.entity_id# AS feeder_markets_entity_id,
		</cfif>

		<cfif qProfileMissingItemsBAGallery.recordcount EQ 0>
			0 AS gallery_check,
		<cfelse>
			1 AS gallery_check,
		</cfif>

		<cfif qProfileOlderBAGallery.recordcount EQ 0>
			0 AS gallery_old_check,
		<cfelse>
			1 AS gallery_old_check,
		</cfif>

		<cfif qProfileMissingItemsVirtualPracticeTour.recordcount EQ 0>
			0 AS vpt_check,
		<cfelse>
			1 AS vpt_check,
		</cfif>

		<cfif qProfileMissingItemsTop5Procedures.recordcount EQ 0>
			0 AS top5procedures_check,
			lae.entity_id AS top5procedures_entity_id,
		<cfelse>
			1 AS top5procedures_check,
			#qProfileMissingItemsTop5Procedures.entity_id# AS top5procedures_entity_id,
		</cfif>

		<cfif qProfileMissingItemsPatientTestimonial.recordcount EQ 0>
			1 AS patient_testimonial_check,
			lae.entity_id AS patient_testimonial_entity_id,
		<cfelse>
			0 AS patient_testimonial_check,
			#qProfileMissingItemsPatientTestimonial.entity_id# AS patient_testimonial_entity_id,
		</cfif>

		<cfif qProfileMissingItemsProcedures.recordcount EQ 0>
			0 AS procedures_check,
			lae.entity_id AS procedures_entity_id,
		<cfelse>
			1 AS procedures_check,
			#qProfileMissingItemsProcedures.entity_id# AS procedures_entity_id,
		</cfif>

		<cfif qProfileMissingItemsStaffBios.recordcount EQ 0>
			0 AS staff_pics_bios_check,
			di.info_id AS staff_bio_info_id,
		<cfelse>
			1 AS staff_pics_bios_check,
			#qProfileMissingItemsStaffBios.info_id# AS staff_bio_info_id,
		</cfif>

		<cfif qProfileMissingItemsCoupons.recordcount EQ 0>
			0 AS coupon_check,
			lae.entity_id AS coupon_entity_id,
		<cfelse>
			1 AS coupon_check,
			#qProfileMissingItemsCoupons.entity_id# AS coupon_entity_id,
		</cfif>

		di.info_id,
		lae.entity_id,
		lae.account_id,
		lae.level_id,
		lae.entity_name_tx

	FROM lad_account_entities lae
	INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id AND di.is_active = 1
	WHERE lae.account_id = <cfqueryparam value="#variables.account_id#">
	Group By lae.account_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItems>
</cffunction>


<cffunction name="GetProfileMissingItemsPracticeName" access="private" returntype="query" output="false">
	<cfset var qProfileMissingItemsPracticeName = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsPracticeName" datasource="myLocateadoc">
		SELECT lae.entity_id
		FROM lad_account_entities lae
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 3 AND lae.is_active = 1 AND
			length( lae.entity_name_tx) = 0
		Group By lae.entity_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsPracticeName>
</cffunction>

<cffunction name="GetProfileMissingItemsLogo" access="private" returntype="query" output="false">
	<cfset var qProfileMissingItemsLogo = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsLogo" datasource="myLocateadoc">
		SELECT lae.entity_id
		FROM lad_account_entities lae
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 3 AND lae.is_active = 1 AND
			length( lae.logo_filename_tx) = 0
		Group By lae.entity_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsLogo>
</cffunction>


<cffunction name="GetProfileMissingItemsPhoto" access="private" returntype="query" output="false">
	<cfset var qProfileMissingItemsPhoto = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsPhoto" datasource="myLocateadoc">
		SELECT lae.entity_id
		FROM lad_account_entities lae
		INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id AND di.is_active = 1
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4 AND lae.is_active = 1 AND
			length( lae.photo_filename_tx) = 0
		Group By lae.entity_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsPhoto>
</cffunction>


<cffunction name="GetProfileMissingItemsUVP" access="private" returntype="query" output="false">
	<cfset var qProfileMissingItemsUVP = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsUVP" datasource="myLocateadoc">
		SELECT lae.entity_id
		FROM lad_account_entities lae
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 3 AND lae.is_active = 1
			AND length(lae.uvp_tx) = 0
		Group By lae.entity_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsUVP>
</cffunction>

<cffunction name="GetProfileMissingItemsFiveBenefits" access="private" returntype="query" output="false">
	<cfset var qProfileMissingItemsFiveBenefits = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsFiveBenefits" datasource="myLocateadoc">
		SELECT lae.entity_id
		FROM lad_account_entities lae
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 3 AND lae.is_active = 1
			AND length(lae.five_benefits) = 0
		Group By lae.entity_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsFiveBenefits>
</cffunction>


<cffunction name="GetProfileMissingItemsFeederMarkets" access="private" returntype="query" output="false">
	<cfset var qProfileMissingItemsFeederMarkets = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsFeederMarkets" datasource="myLocateadoc">
		SELECT lae.entity_id
		FROM lad_account_entities lae
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 3 AND lae.is_active = 1
			AND length( lae.feeder_markets) = 0
		Group By lae.entity_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsFeederMarkets>
</cffunction>


<cffunction name="GetProfileMissingItemsBAGallery" access="private" returntype="query" output="false">
	<cfset var qProfileMissingItemsBAGallery = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsBAGallery" datasource="myLocateadoc">
		SELECT lae.entity_id
		FROM lad_account_entities lae
		INNER JOIN gallery_doctors gd ON gd.entity_id = lae.entity_id AND gd.is_active = 1
		INNER JOIN gallery g ON g.doctor_id = gd.id AND g.is_active = 1
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4 AND lae.is_active = 1
		Group By lae.entity_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsBAGallery>
</cffunction>


<cffunction name="GetProfileOlderBAGallery" access="private" returntype="query" output="false" hint="Check if an account has not updated their gallery in over 30 days.">
	<cfset var qProfileOlderBAGallery = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileOlderBAGallery" datasource="myLocateadoc">
		SELECT lae.entity_id
		FROM lad_account_entities lae
		INNER JOIN gallery_doctors gd ON gd.entity_id = lae.entity_id AND gd.is_active = 1
		INNER JOIN gallery g ON g.doctor_id = gd.id AND g.is_active = 1 AND (to_days(now()) - to_days(g.db_created_dt)) > 30
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4 AND lae.is_active = 1
		Group By lae.entity_id
	</cfquery>
	</cfif>

	<cfreturn qProfileOlderBAGallery>
</cffunction>


<cffunction name="GetProfileMissingItemsVirtualPracticeTour" access="private" returntype="query" output="false">
	<cfset var qProfileMissingItemsVirtualPracticeTour = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsVirtualPracticeTour" datasource="myLocateadoc">
		SELECT vll.info_id
		FROM lad_account_entities lae
		INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id AND di.is_active = 1
		INNER JOIN myPro.vpt_locateadoc_listings vll ON vll.info_id = di.info_id AND vll.is_active = 1
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id =4 AND lae.is_active = 1
		Group By di.info_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsVirtualPracticeTour>
</cffunction>


<cffunction name="GetProfileMissingItemsTop5Procedures" access="private" returntype="query" output="false">
	<cfset var qProfileMissingItemsTop5Procedures = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsTop5Procedures" datasource="myLocateadoc">
		SELECT lae.entity_id
		FROM lad_account_entities lae
		INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id AND di.is_active = 1
		INNER JOIN doc_specialty_mapped dsm ON dsm.info_id = di.info_id AND dsm.is_active =1
					AND dsm.top5_procedure_ids <> "NA,NA,NA,NA,NA" AND dsm.top5_procedure_ids <> "" AND NOT ISNULL(dsm.top5_procedure_ids)
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4 AND lae.is_active = 1

		Group By lae.entity_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsTop5Procedures>
</cffunction>


<cffunction name="GetProfileMissingItemsPatientTestimonial" access="private" returntype="query" output="false">
	<cfset var qProfileMissingItemsPatientTestimonial = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsPatientTestimonial" datasource="myLocateadoc">
		SELECT lae.entity_id
		FROM lad_account_entities lae
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4 AND lae.is_active = 1
			AND length( lae.testimonial_tx) = 0
		Group By lae.entity_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsPatientTestimonial>
</cffunction>


<cffunction name="GetProfileMissingItemsProcedures" access="private" returntype="query" output="false">
	<cfset var qProfileMissingItemsProcedures = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsProcedures" datasource="myLocateadoc">
		SELECT lae.entity_id
		FROM lad_account_entities lae
		INNER JOIN doc_procedures dp ON dp.doctor_entity_id = lae.entity_id
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4 AND lae.is_active = 1
		Group By lae.entity_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsProcedures>
</cffunction>


<cffunction name="GetProfileMissingItemsStaffBios" access="private" returntype="query" output="false">
	<cfset var qProfileMissingItemsStaffBios = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsStaffBios" datasource="myLocateadoc">
		SELECT dsi.info_id
		FROM lad_account_entities lae
		INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id AND di.is_active = 1
		INNER JOIN doc_staff_info dsi ON dsi.info_id = di.info_id AND dsi.is_active = 1
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id =4 AND lae.is_active = 1
		Group By dsi.info_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsStaffBios>
</cffunction>


<cffunction name="GetProfileMissingItemsCoupons" access="private" returntype="query" output="false">
	<cfset var qProfileMissingItemsCoupons = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsCoupons" datasource="myLocateadoc">
		SELECT lae.entity_id
		FROM lad_account_entities lae
		INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id AND di.is_active = 1
		INNER JOIN doc_coupons dc ON dc.location_id = di.info_id and dc.coupon_is_shown=1 AND dc.expire_date > now()
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id =4 AND lae.is_active = 1
		Group By lae.entity_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsCoupons>
</cffunction>


<cffunction name="GetProfileMissingItemsRecommended" access="public" returntype="query" output="false">
	<cfset var qProfileMissingItemsRecommended = QueryNew("")>

	<!--- The reason to call these separately is it's tricky to pull the correct info_id to link to that has the missing data --->
	<cfset var qProfileMissingOfficeHours = GetProfileMissingOfficeHours()>
	<cfset var qProfileMissingLanguagesSpoken = GetProfileMissingLanguagesSpoken()>
	<cfset var qProfileMissingRecommendations = GetProfileMissingRecommendations()>
	<cfset var qProfileMissingInsiderInterview = GetProfileMissingInsiderInterview()>
	<cfset var qProfileMissingHeadline = GetProfileMissingHeadline()>
	<cfset var qProfileMissingFinancing = GetProfileMissingFinancing()>

	<cfif isnumeric(variables.account_id)>
	<cfquery name="qProfileMissingItemsRecommended" datasource="myLocateadoc">
	SELECT
		<cfif qProfileMissingOfficeHours.recordcount EQ 0>
			0 AS office_hours_missing,
			di.info_id AS office_hours_info_id,
		<cfelse>
			#qProfileMissingOfficeHours.info_id# AS	office_hours_info_id,
			1 AS office_hours_missing,
		</cfif>

		<cfif qProfileMissingLanguagesSpoken.recordcount EQ 0>
			0 AS languages_spoken_missing,
			di.info_id AS languages_spoken_info_id,
		<cfelse>
			#qProfileMissingLanguagesSpoken.info_id# AS	languages_spoken_info_id,
			1 AS languages_spoken_missing,
		</cfif>

		<cfif qProfileMissingRecommendations.recordcount EQ 0>
			cast(concat(di.info_id,"-", dsm.sid) AS char) AS recommendations_info_sid,
			1 AS recommendations_missing,
		<cfelse>
			0 AS recommendations_missing,
			"#qProfileMissingRecommendations.info_sid#" AS recommendations_info_sid,
		</cfif>

		<cfif qProfileMissingInsiderInterview.recordcount EQ 0>
			0 AS insider_interview_missing,
			lae.entity_id AS insider_interview_entity_id,
		<cfelse>
			#qProfileMissingInsiderInterview.entity_id# AS	insider_interview_entity_id,
			1 AS insider_interview_missing,
		</cfif>

		<cfif qProfileMissingHeadline.recordcount EQ 0>
			0 AS headline_missing,
			lae.entity_id AS headline_entity_id,
		<cfelse>
			#qProfileMissingHeadline.entity_id# AS	headline_entity_id,
			1 AS headline_missing,
		</cfif>

		<cfif qProfileMissingFinancing.recordcount EQ 0>
			1 AS Financing_missing,
			lae.entity_id AS Financing_entity_id,
		<cfelse>
			#qProfileMissingFinancing.entity_id# AS Financing_entity_id,
			0 AS Financing_missing,
		</cfif>

		di.info_id AS info_id
	FROM lad_account_entities lae
	INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id AND di.is_active = 1
	INNER JOIN doc_specialty_mapped dsm ON dsm.info_id = di.info_id AND dsm.is_active = 1
	WHERE lae.account_id = <cfqueryparam value="#variables.account_id#">
	Group By lae.account_id
	</cfquery>
	</cfif>

	<cfreturn qProfileMissingItemsRecommended>
</cffunction>



<cffunction name="GetProfileMissingFinancing" access="private" returntype="query" output="false" hint="return listings with no office hours">
	<cfset var qProfileMissingFinancing = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery datasource="myLocateadoc" name="qProfileMissingFinancing">
			SELECT lae.entity_id
			FROM lad_account_entities lae
			INNER JOIN doc_associations da ON da.association_type = "Financing"
			INNER JOIN doc_associations_mapped dam ON dam.doctor_entity_id = lae.entity_id AND dam.association_id = da.association_id AND dam.is_active = 1
			WHERE lae.account_id = #variables.account_id# AND lae.is_active = 1 AND lae.level_id = 4
		</cfquery>
	</cfif>

	<cfreturn qProfileMissingFinancing>
</cffunction>


<cffunction name="GetProfileMissingHeadline" access="private" returntype="query" output="false" hint="return listings with no office hours">
	<cfset var qProfileMissingHeadline = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery datasource="myLocateadoc" name="qProfileMissingHeadline">
			SELECT lae.entity_id
			FROM lad_account_entities lae
			WHERE lae.account_id = #variables.account_id# AND lae.is_active = 1 AND lae.level_id = 4
				AND lae.headline_tx = ""
		</cfquery>
	</cfif>

	<cfreturn qProfileMissingHeadline>
</cffunction>

<cffunction name="GetProfileMissingInsiderInterview" access="private" returntype="query" output="false" hint="return listings with no office hours">
	<cfset var qProfileMissingInsiderInterview = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery datasource="myLocateadoc" name="qProfileMissingInsiderInterview">
			SELECT lae.entity_id
			FROM lad_account_entities lae
			INNER JOIN lad_doctor_question_list ldql ON ldql.doctor_entity_id = lae.entity_id and ldql.is_shown=1 AND ldql.answer = ""
			WHERE lae.account_id = #variables.account_id# AND lae.is_active = 1 AND lae.level_id = 4
		</cfquery>
	</cfif>

	<cfreturn qProfileMissingInsiderInterview>
</cffunction>


<cffunction name="GetProfileMissingRecommendations" access="private" returntype="query" output="false" hint="return listings with no recommendations">
	<cfset var qProfileMissingRecommendations = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery datasource="myLocateadoc" name="qProfileMissingRecommendations">
			SELECT CAST(concat(di.info_id, "-", dsm.sid) AS char) AS info_sid
			FROM lad_account_entities lae
			INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id AND di.is_active = 1
			INNER JOIN doc_specialty_mapped dsm On dsm.info_id = di.info_id AND dsm.is_active = 1
			INNER JOIN doc_recommendations AS dr ON dr.info_id = di.info_id AND (dr.removed_dt IS NULL)
											AND ((dr.approved_dt IS NOT NULL) OR (dr.preapprove_dt IS NOT NULL))
			WHERE lae.account_id = #variables.account_id# AND lae.is_active = 1 AND lae.level_id = 4
			GROUP BY lae.entity_id;
		</cfquery>
	</cfif>

	<cfreturn qProfileMissingRecommendations>
</cffunction>


<cffunction name="GetProfileMissingOfficeHours" access="private" returntype="query" output="false" hint="return listings with no office hours">
	<cfset var qProfileMissingOfficeHours = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery datasource="myLocateadoc" name="qProfileMissingOfficeHours">
			SELECT info_id
			FROM lad_account_entities lae
			INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id AND di.is_active = 1 AND di.officeHours = ""
			WHERE lae.account_id = #variables.account_id# AND lae.is_active = 1 AND lae.level_id = 4
		</cfquery>
	</cfif>

	<cfreturn qProfileMissingOfficeHours>
</cffunction>


<cffunction name="GetProfileMissingLanguagesSpoken" access="private" returntype="query" output="false" hint="return listings with no languages spoken">
	<cfset var qProfileMissingLanguagesSpoken = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery datasource="myLocateadoc" name="qProfileMissingLanguagesSpoken">
			SELECT info_id
			FROM lad_account_entities lae
			INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id AND di.is_active = 1 AND di.LanguagesSpoken = ""
			WHERE lae.account_id = #variables.account_id# AND lae.is_active = 1 AND lae.level_id = 4
		</cfquery>
	</cfif>

	<cfreturn qProfileMissingLanguagesSpoken>
</cffunction>


<cffunction name="GetProfileLastUpdated" access="public" returntype="String" output="false" hint="return the date the doctors listing was last updated and by whom">
	<cfset var qProfileLastUpdated = QueryNew("")>
	<cfset var max_date = "">

	<cfquery datasource="myLocateadoc" name="qProfileLastUpdated">
		SELECT max(la.db_updated_dt) AS date_account,
				max(d.db_updated_dt) AS date_doctor,
				max(p.db_updated_dt) AS date_practice,
				max(di.db_updated_dt) AS date_listing,
				max(dsm.db_updated_dt) AS date_specialty
		FROM lad_accounts la
		INNER JOIN lad_account_entities d On d.account_id = la.account_id AND d.level_id = 4 AND d.is_active = 1
		INNER JOIN lad_account_entities p On p.account_id = la.account_id AND p.level_id = 3 AND p.is_active = 1
		INNER JOIN doc_info di On di.doctor_entity_id = d.entity_id AND di.is_active = 1
		INNER JOIN doc_specialty_mapped dsm On dsm.info_id = di.info_id AND dsm.is_active = 1
		WHERE la.account_id = #variables.account_id#
	</cfquery>

	<cfset max_date = qProfileLastUpdated.date_account>

	<cfif qProfileLastUpdated.date_doctor GT max_date>
		<cfset max_date = qProfileLastUpdated.date_doctor>
	<cfelseif qProfileLastUpdated.date_practice GT max_date>
		<cfset max_date = qProfileLastUpdated.date_practice>
	<cfelseif qProfileLastUpdated.date_listing GT max_date>
		<cfset max_date = qProfileLastUpdated.date_listing>
	<cfelseif qProfileLastUpdated.date_specialty GT max_date>
		<cfset max_date = qProfileLastUpdated.date_specialty>
	</cfif>

	<cfreturn DateFormat(max_date, "mmm dd, yyyy")>
</cffunction>

<cffunction name="SpecialtyHasGallery" returntype="boolean" access="public" output="false" hint="Returns whether any of the specialties in this account can have a gallery">
	<cfset var qSpecialtyHasGallery = QueryNew("")>

	<cfquery datasource="myLocateadoc" name="qSpecialtyHasGallery">
		SELECT count(*) AS has_gallery
		FROM lad_account_entities lae
		INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id AND di.is_active = 1
		INNER JOIN doc_specialty_mapped dsm On dsm.info_id = di.info_id AND dsm.is_active = 1
		INNER JOIN specialty s ON s.id = dsm.sid AND s.is_bagallery > 0
		WHERE lae.account_id = #variables.account_id# AND lae.is_active = 1
	</cfquery>

	<cfif qSpecialtyHasGallery.has_gallery GT 0>
		<cfreturn true>
	</cfif>

	<cfreturn false>
</cffunction>

<cffunction name="SpecialtyHasFinancing" returntype="boolean" access="public" output="false" hint="Returns whether any of the specialties in this account can have Financing">
	<cfset var qSpecialtyHasFinancing = QueryNew("")>

	<cfquery datasource="myLocateadoc" name="qSpecialtyHasFinancing">
		SELECT count(*) AS has_Financing
		FROM lad_account_entities lae
		INNER JOIN doc_info di ON di.doctor_entity_id = lae.entity_id AND di.is_active = 1
		INNER JOIN doc_specialty_mapped dsm On dsm.info_id = di.info_id AND dsm.is_active = 1
		INNER JOIN specialty s ON s.id = dsm.sid AND s.is_financing > 0
		WHERE lae.account_id = #variables.account_id# AND lae.is_active = 1
	</cfquery>

	<cfif qSpecialtyHasFinancing.has_Financing GT 0>
		<cfreturn true>
	</cfif>

	<cfreturn false>
</cffunction>


<cffunction name="GetStatsSurveyRecommendation" access="public" returntype="query" output="false">
	<cfset var qStatsSurveyRecommendation = QueryNew("")>
	<cfset var cacheSpan = createTimeSpan(1,0,0,0)>

	<cfif isnumeric(variables.account_id)>
		<cfquery name="qStatsSurveyRecommendation" datasource="myLocateadoc">
		Select
			Cast( IfNull( Truncate(Avg(survey.recommendation_rating), 2), "0") as char) as AverageRating
		From folio_survey_results survey
		Inner join folio f
		  on f.folio_id = survey.lead_id
		Join doc_info di
		  On f.info_id = di.info_id
		Join lad_account_entities lae
		  On di.doctor_entity_id = lae.entity_id
		Where lae.account_id = "#variables.account_id#"
		  And f.is_active = 1 AND f.is_duplicate = 0
		  And f.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
		   AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
		  And survey.recommendation_rating is not null AND survey.lead_type = "Folio"
		</cfquery>
	</cfif>
	<cfreturn qStatsSurveyRecommendation>
</cffunction>


<cffunction name="getRecommendations" access="public" returntype="query" output="false" hint="Main query for the recommendations pie chart">
	<cfset var qRecommendations = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery datasource="myLocateadoc" name="qRecommendations">
			SELECT
				   CASE
				   		when a.rate = 0 THEN 'Extremely Unlikely'
		   	   			when a.rate BETWEEN 1 AND 3 THEN 'Unlikely'
		   	   			WHEN a.rate BETWEEN 4 AND 6 THEN 'Neutral'
		   	   			WHEN a.rate BETWEEN 7 AND 9 THEN 'Likely'
		   	   			ELSE 'Extremely Likely'
  					END
					AS ratings,
					SUM(a.count) AS bCount,
				    SUM(a.count) AS aRecommendation_rating,
					a.rate AS rate
			FROM
			(
	            SELECT dr.womm AS rate, COUNT(DISTINCT(concat(dr.firstname, dr.lastname, dr.from_email, dr.from_city))) AS count
	            FROM doc_recommendations dr
	            JOIN doc_info di ON dr.info_id = di.info_id
	            JOIN lad_account_entities lae ON di.doctor_entity_id = lae.entity_id
	            WHERE lae.account_id = <cfqueryparam value="#variables.account_id#">
	            	AND dr.added_dt BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
									AND		<cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
	            GROUP BY dr.womm

	         UNION ALL

	            SELECT survey.recommendation_rating AS rate, COUNT(survey.recommendation_rating) AS count
				FROM folio_survey_results survey
				INNER JOIN folio f
					ON f.folio_id = survey.lead_id
				JOIN doc_info di
					ON f.info_id = di.info_id
				JOIN lad_account_entities lae
					ON di.doctor_entity_id = lae.entity_id
				WHERE lae.account_id = <cfqueryparam value="#variables.account_id#">
					AND f.is_active = 1 AND f.is_duplicate = 0
					AND survey.recommendation_rating IS NOT NULL
					AND survey.lead_type = "Folio"
					AND f.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
								AND		<cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
				GROUP BY survey.recommendation_rating

				UNION ALL

				Select survey.recommendation_rating AS rate, COUNT(survey.recommendation_rating) AS count
				From lad_account_entities lae
				INNER Join doc_info di On di.doctor_entity_id = lae.entity_id
				INNER join folio_mini_leads fml on   fml.info_id = di.info_id
								AND fml.created_dt BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
								AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
				INNER JOIN folio_survey_results survey ON fml.id = survey.lead_id AND survey.lead_type = "Mini"
														 AND survey.recommendation_rating is not null
				WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4
				Group by survey.recommendation_rating
			) AS a
			GROUP BY ratings
			ORDER BY a.rate DESC
		</cfquery>
	</cfif>

	<cfreturn qRecommendations>
</cffunction>

<cffunction name="getRecommendationsDataTypes" access="public" returntype="struct" output="false" hint="Data types for the recommendations pie chart">

	<cfset var RecommendationsDataTypes = structNew()>

	<cfset RecommendationsDataTypes["bCount"] = "number">
	<cfset RecommendationsDataTypes["aRecommendation_rating"] = "string">

	<cfreturn RecommendationsDataTypes>
</cffunction>

<cffunction name="GetStatsSurveyContact" access="public" returntype="query" output="false">
	<cfset var qStatsSurveyContact = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery name="qStatsSurveyContact" datasource="myLocateadoc">
		Select survey_joined.label, sum(survey_joined.result) as result, 0 as percentage
		FROM
		(
		SELECT if( survey.has_doctor_contacted = "yes", "Yes", if( survey.has_doctor_contacted = "no", "No", "Unsure")) as label,
		  Count(*) as result, 0 as percentage
		From lad_account_entities lae
		INNER Join doc_info di On di.doctor_entity_id = lae.entity_id
		INNER join folio f on f.info_id = di.info_id and f.is_active = 1 AND f.is_duplicate = 0
					  And f.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
						AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
			INNER JOIN folio_survey_results survey ON f.folio_id = survey.lead_id AND survey.lead_type = "Folio"
												 AND survey.has_doctor_contacted is not null
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4
		Group by survey.has_doctor_contacted

		UNION ALL

		Select
		  if( survey.has_doctor_contacted = "yes", "Yes", if( survey.has_doctor_contacted = "no", "No", "Unsure")) as label,
		  Count(*) as result, 0 as percentage
		From lad_account_entities lae
		INNER Join doc_info di On di.doctor_entity_id = lae.entity_id
		INNER join folio_mini_leads fml on   fml.info_id = di.info_id
						AND fml.created_dt BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
						AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
		INNER JOIN folio_survey_results survey ON fml.id = survey.lead_id AND survey.lead_type = "Mini"
												 AND survey.has_doctor_contacted is not null
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4
		Group by survey.has_doctor_contacted
		) AS survey_joined
		GROUP BY survey_joined.label
		Order by label DESC
		</cfquery>
	</cfif>
	<cfreturn qStatsSurveyContact>
</cffunction>

<cffunction name="GetStatsSurveyTimeToSurgery" access="public" returntype="query" output="false">
	<cfset var qStatsSurveyTimeToSurgery = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery name="qStatsSurveyTimeToSurgery" datasource="myLocateadoc" >
		Select survey_joined.label, sum(survey_joined.result) as result, 0 as percentage,
(CASE label WHEN '1 month' THEN 'a' WHEN '2 months' THEN 'b' WHEN '3 months' THEN 'c' WHEN '4 months' THEN 'd' WHEN '5 months' THEN 'e' WHEN '6 months' THEN 'f' WHEN '7 months' THEN 'g' WHEN '8 months' THEN 'h' WHEN '9 months' THEN 'i' WHEN '10 months' THEN 'j' WHEN '11 months' THEN 'k' WHEN '12 months' THEN 'l' WHEN '2 years' THEN 'm' WHEN '3 years' THEN 'n' WHEN '4 years' THEN 'o' ELSE 'z' END) as orderNum
		FROM
		(
		SELECT survey.wants_procedure_performed_in as label,
		  Count(survey.wants_procedure_performed_in) as result, 0 as percentage
		From lad_account_entities lae
		INNER Join doc_info di On di.doctor_entity_id = lae.entity_id
		INNER join folio f on f.info_id = di.info_id and f.is_active = 1 AND f.is_duplicate = 0
					  And f.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
						AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
			INNER JOIN folio_survey_results survey ON f.folio_id = survey.lead_id AND survey.lead_type = "Folio"
												 AND survey.wants_procedure_performed_in is not null
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4
		Group by survey.wants_procedure_performed_in

		UNION ALL

		Select survey.wants_procedure_performed_in as label,
		   Count(survey.wants_procedure_performed_in) as result, 0 as percentage
		From lad_account_entities lae
		INNER Join doc_info di On di.doctor_entity_id = lae.entity_id
		INNER join folio_mini_leads fml on   fml.info_id = di.info_id
						AND fml.created_dt BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
						AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
		INNER JOIN folio_survey_results survey ON fml.id = survey.lead_id AND survey.lead_type = "Mini"
												 AND survey.wants_procedure_performed_in is not null
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4
		Group by survey.wants_procedure_performed_in
		) AS survey_joined
		GROUP BY survey_joined.label
		Order by OrderNum ASC

<!---
		Order by result DESC
		Order by label ASC
		limit 4;
--->
		</cfquery>




	</cfif>
	<cfreturn qStatsSurveyTimeToSurgery>
</cffunction>

<cffunction name="GetStatsSurveyScheduledAppt" access="public" returntype="query" output="false">
	<cfset var qStatsSurveyScheduledAppt = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery name="qStatsSurveyScheduledAppt" datasource="myLocateadoc">
		Select survey_joined.label, sum(survey_joined.result) as result, 0 as percentage
		FROM
		(
		SELECT if( survey.has_scheduled_appointment = 1, "Yes", if(survey.has_scheduled_appointment = 0, "No", "No Answer") ) as label,
		  Count(*) as result, 0 as percentage
		From lad_account_entities lae
		INNER Join doc_info di On di.doctor_entity_id = lae.entity_id
		INNER join folio f on f.info_id = di.info_id and f.is_active = 1 AND f.is_duplicate = 0
					  And f.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
						AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
			INNER JOIN folio_survey_results survey ON f.folio_id = survey.lead_id AND survey.lead_type = "Folio"
												 AND survey.has_scheduled_appointment is not null
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4
		Group by survey.has_scheduled_appointment

		UNION ALL

		Select
		  if( survey.has_scheduled_appointment = 1, "Yes", if(survey.has_scheduled_appointment = 0, "No", "No Answer") ) as label,
		  Count(*) as result, 0 as percentage
		From lad_account_entities lae
		INNER Join doc_info di On di.doctor_entity_id = lae.entity_id
		INNER join folio_mini_leads fml on   fml.info_id = di.info_id
						AND fml.created_dt BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
						AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
		INNER JOIN folio_survey_results survey ON fml.id = survey.lead_id AND survey.lead_type = "Mini"
												 AND survey.has_scheduled_appointment is not null
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4
		Group by survey.has_scheduled_appointment
		) AS survey_joined
		GROUP BY survey_joined.label
		Order by label DESC
		</cfquery>
	</cfif>
	<cfreturn qStatsSurveyScheduledAppt>
</cffunction>

<cffunction name="GetStatsSurveyTimelyContact" access="public" returntype="query" output="false">
	<cfset var qStatsSurveyTimelyContact = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery name="qStatsSurveyTimelyContact" datasource="myLocateadoc">
		Select survey_joined.label, sum(survey_joined.result) as result, 0 as percentage
		FROM
		(
		SELECT if( survey.was_contacted_timely = 1, "Yes", "No") as label, Count(*) as result, 0 as percentage
		From lad_account_entities lae
		INNER Join doc_info di On di.doctor_entity_id = lae.entity_id
		INNER join folio f on f.info_id = di.info_id and f.is_active = 1 AND f.is_duplicate = 0
					  And f.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
						AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
			INNER JOIN folio_survey_results survey ON f.folio_id = survey.lead_id AND survey.lead_type = "Folio"
												 AND survey.was_contacted_timely is not null
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4
		Group by survey.was_contacted_timely

		UNION ALL

		Select if( survey.was_contacted_timely = 1, "Yes", "No") as label, Count(*) as result, 0 as percentage
		From lad_account_entities lae
		INNER Join doc_info di On di.doctor_entity_id = lae.entity_id
		INNER join folio_mini_leads fml on   fml.info_id = di.info_id
						AND fml.created_dt BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
						AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
		INNER JOIN folio_survey_results survey ON fml.id = survey.lead_id AND survey.lead_type = "Mini"
												 AND survey.was_contacted_timely is not null
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4
		Group by survey.was_contacted_timely
		) AS survey_joined
		GROUP BY survey_joined.label
		Order by label DESC
		</cfquery>
	</cfif>
	<cfreturn qStatsSurveyTimelyContact>
</cffunction>

<cffunction name="GetStatsSurveyScheduledApptOtherDr" access="public" returntype="query" output="false">
	<cfset var qStatsSurveyScheduledApptOtherDr = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery name="qStatsSurveyScheduledApptOtherDr" datasource="myLocateadoc">
		Select survey_joined.label, sum(survey_joined.result) as result, 0 as percentage
		FROM
		(
		SELECT if( survey.has_scheduled_appointment_other_doctor = 1, "Yes", "No") as label, Count(*) as result, 0 as percentage
		From lad_account_entities lae
		INNER Join doc_info di On di.doctor_entity_id = lae.entity_id
		INNER join folio f on f.info_id = di.info_id and f.is_active = 1 AND f.is_duplicate = 0
					  And f.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
						AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
			INNER JOIN folio_survey_results survey ON f.folio_id = survey.lead_id AND survey.lead_type = "Folio"
												 AND survey.has_scheduled_appointment_other_doctor is not null
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4
		Group by survey.has_scheduled_appointment_other_doctor

		UNION ALL

		Select if( survey.has_scheduled_appointment_other_doctor = 1, "Yes", "No") as label, Count(*) as result, 0 as percentage
		From lad_account_entities lae
		INNER Join doc_info di On di.doctor_entity_id = lae.entity_id
		INNER join folio_mini_leads fml on   fml.info_id = di.info_id
						AND fml.created_dt BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
						AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
		INNER JOIN folio_survey_results survey ON fml.id = survey.lead_id AND survey.lead_type = "Mini"
												 AND survey.has_scheduled_appointment_other_doctor is not null
		WHERE lae.account_id = <cfqueryparam value="#variables.account_id#"> AND lae.level_id = 4
		Group by survey.has_scheduled_appointment_other_doctor
		) AS survey_joined
		GROUP BY survey_joined.label
		Order by label DESC
		</cfquery>
	</cfif>
	<cfreturn qStatsSurveyScheduledApptOtherDr>
</cffunction>

<cffunction name="GetAvgTimeToOpen" access="public" returntype="query" output="false">
	<cfset var qAvgTimeToOpen = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery name="qAvgTimeToOpen" datasource="myLocateadoc">
			SELECT
						LeadType,
						Truncate( Avg(TIMESTAMPDIFF(Hour, date, date_entered)) , 1)  as Hours,
						Truncate( Avg(TIMESTAMPDIFF(Day, date, date_entered)) , 1)  as Days,
						0 AS Seconds,
						0 AS Minutes
			FROM (
			      Select
						'folio' as LeadType,
						f.date, fo.date_entered,
						0 AS Seconds,
						0 AS Minutes
					From folio f
					Join doc_info di
					On f.info_id = di.info_id
					Join lad_account_entities lae
					On di.doctor_entity_id = lae.entity_id
					INNER JOIN folio_opens fo ON fo.folio_id = f.folio_id
					Where lae.account_id = <cfqueryparam value="#variables.account_id#">
					/*  and f.is_lead_opened = 1 */
					  And f.is_active = 1 AND f.is_duplicate = 0
					  AND f.date > "2009-09-17" /* date we started recording this */
					  And f.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
							AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
					  And TIMESTAMPDIFF(Hour, f.date, fo.date_entered) > 0
			 group by fo.folio_id
			 order by fo.date_entered asc
			 ) AS raw
			 GROUP BY LeadType


<!--- 		Select
			'folio' as LeadType,
			Truncate( Avg(TIMESTAMPDIFF(Hour, f.date, fo.date_entered)) , 1)  as Hours,
			Truncate( Avg(TIMESTAMPDIFF(Day, f.date, fo.date_entered)) , 1)  as Days,
			0 AS Seconds,
			0 AS Minutes
		From folio f
		Join doc_info di
		On f.info_id = di.info_id
		Join lad_account_entities lae
		On di.doctor_entity_id = lae.entity_id
		INNER JOIN folio_opens fo ON fo.folio_id = f.folio_id
		Where lae.account_id = <cfqueryparam value="#variables.account_id#">
		/*  and f.is_lead_opened = 1 */
		  And f.is_active = 1 AND f.is_duplicate = 0
		  AND f.date > "2009-09-17" /* date we started recording this */
		  And f.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
			AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
		  And TIMESTAMPDIFF(Hour, f.date, f.date_updated) > 0 --->

		Union

		Select
			'mini' as LeadType,
			Truncate( Avg(TIMESTAMPDIFF(Hour, uah.date, uah.lead_opened_dt)) , 1)  as Hours,
			Truncate( Avg(TIMESTAMPDIFF(Day, uah.date, uah.lead_opened_dt)) , 1)  as Days,
			0 AS Seconds,
			0 AS Minutes
		From user_accounts_hits uah
		Join doc_info di
		On uah.info_id = di.info_id
		Join lad_account_entities lae
		On di.doctor_entity_id = lae.entity_id
		Where lae.account_id = <cfqueryparam value="#variables.account_id#">
		  And uah.is_active = 1 AND uah.is_duplicate = 0 And uah.has_folio_lead = 0
		  AND uah.date > "2009-09-17"
		  And uah.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
			AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
		  And TIMESTAMPDIFF(hour, uah.date, uah.lead_opened_dt) > 0
		  GROUP BY LeadType

		Union

		Select
			'phone' as LeadType,
			0 AS hours,
			0 AS days,
			avg(second(pl.call_length)) as Seconds,
			avg(minute(pl.call_length))  as Minutes
		From lad_account_entities lae
		INNER Join doc_info di On di.doctor_entity_id = lae.entity_id
		INNER JOIN phoneplus_leads pl On pl.info_id = di.info_id And pl.is_active = 1
			And pl.call_start BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date"> AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
		Where lae.account_id = <cfqueryparam value="#variables.account_id#">
		</cfquery>
	</cfif>
	<cfreturn qAvgTimeToOpen>
</cffunction>

<cffunction name="GetAvgOpenRate" access="public" returntype="query" output="false">
	<cfset var qAvgOpenRate = QueryNew("")>

	<cfif isnumeric(variables.account_id)>
		<cfquery name="qAvgOpenRate" datasource="myLocateadoc">
		select
			'folio' as LeadType,
			Truncate((100 - Avg(IF(f.is_lead_opened > 0, 1, 0)) * 100),1) as RateOfUnopen,
			Truncate( Avg(IF(f.is_lead_opened > 0, 1, 0)) * 100 ,1) as RateOfOpen
		From folio f
		Join doc_info di
		On f.info_id = di.info_id
		Join lad_account_entities lae
		On di.doctor_entity_id = lae.entity_id
		Where lae.account_id = <cfqueryparam value="#variables.account_id#">
		/*  and f.is_lead_opened = 1 */
		  And f.is_active = 1 AND f.is_duplicate = 0
		  And f.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
			AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
		  And TIMESTAMPDIFF(DAY, f.date, f.date_updated) > 0

		Union

		Select
			'mini' as LeadType,
			if( Truncate((100 - Avg(IF(uah.lead_opened > 0, 1, 0)) * 100),1) is null,
				0,
				Truncate( (100 - Avg(IF(uah.lead_opened > 0, 1, 0)) * 100), 1 )) as RateOfUnopen,

			if( Truncate( Avg(IF(uah.lead_opened > 0, 1, 0)) * 100 ,1) is null,
				0,
				Truncate( Avg(IF(uah.lead_opened > 0, 1, 0)) * 100 ,1) ) as RateOfOpen

		From user_accounts_hits uah
		Join doc_info di
		On uah.info_id = di.info_id
		Join lad_account_entities lae
		On di.doctor_entity_id = lae.entity_id
		Where lae.account_id = <cfqueryparam value="#variables.account_id#">
		  And uah.is_active = 1 AND uah.has_folio_lead = 0
		  And uah.date BETWEEN <cfqueryparam value="#variables.startDate#" cfsqltype="cf_sql_date">
			AND <cfqueryparam value="#variables.endDate#" cfsqltype="cf_sql_date">
		  And TIMESTAMPDIFF(DAY, uah.date, uah.lead_opened_dt) > 0

		Union

		Select
			'phone' as LeadType,
			0 as RateOfUnopen,
			100 as RateOfOpen
		</cfquery>
	</cfif>
	<cfreturn qAvgOpenRate>
</cffunction>


<cffunction name="ProfileComplete" access="public" returntype="Numeric" output="false">
	<cfargument name="qProfileMissingItems" default="#QueryNew('')#" type="query">

<!--- Calculate what percentage of the PROfile is complete --->
	<cfscript>
	var profileCount = 12;
	var profileCounter = 0;
	var profileComplete = 0;
	var profileWeight = 0;
	var displayMax = 5;
	var displayCount = 0;


	if (arguments.qProfileMissingItems.name_check EQ true)
	{
		displayCount = displayCount + 1;
		profileWeight = profileWeight + .10;
		profileCounter = profileCounter + Min(arguments.qProfileMissingItems.name_check, 1);
	}

	if (arguments.qProfileMissingItems.logo_check EQ true)
	{
		profileWeight = profileWeight;
		displayCount = displayCount + 1;
	}

	if (arguments.qProfileMissingItems.photo_check EQ true)
	{
		profileWeight = profileWeight + .10;
		displayCount = displayCount + 1;
		profileCounter = profileCounter + Min(arguments.qProfileMissingItems.photo_check, 1);
	}

	if(this.specialty_has_gallery EQ true)
	{
		profileCounter = profileCounter + Min(arguments.qProfileMissingItems.gallery_check, 1);
		if (arguments.qProfileMissingItems.gallery_check) profileWeight = profileWeight + .15;
		profileCount = profileCount + 1;
	}

	if (arguments.qProfileMissingItems.uvp_check EQ true)
	{
		profileWeight = profileWeight + .15;
		if(NOT this.specialty_has_gallery) profileWeight = profileWeight + .05;
		displayCount = displayCount + 1;
		profileCounter = profileCounter + Min(arguments.qProfileMissingItems.uvp_check, 1);
	}


	if (arguments.qProfileMissingItems.benefits_check EQ true)
	{
		profileWeight = profileWeight + .05;
		displayCount = displayCount + 1;
		profileCounter = profileCounter + Min(arguments.qProfileMissingItems.benefits_check, 1);
	}

	if (arguments.qProfileMissingItems.markets_check EQ true)
	{
		profileWeight = profileWeight + .10;
		displayCount = displayCount + 1;
		profileCounter = profileCounter + Min(arguments.qProfileMissingItems.markets_check, 1);
	}

	if (arguments.qProfileMissingItems.vpt_check EQ true)
	{
		profileWeight = profileWeight + .15;
		if(NOT this.specialty_has_gallery) profileWeight = profileWeight + .05;
		displayCount = displayCount + 1;
		profileCounter = profileCounter + Min(arguments.qProfileMissingItems.vpt_check, 1);
	}

	if (arguments.qProfileMissingItems.top5procedures_check EQ true)
	{
		profileWeight = profileWeight + .10;
		if(NOT this.specialty_has_gallery) profileWeight = profileWeight + .05;
		displayCount = displayCount + 1;
		profileCounter = profileCounter + Min(arguments.qProfileMissingItems.top5procedures_check, 1);
	}

	if (arguments.qProfileMissingItems.patient_testimonial_check EQ true)
	{
		profileWeight = profileWeight + .05;
		displayCount = displayCount + 1;
		profileCounter = profileCounter + Min(arguments.qProfileMissingItems.patient_testimonial_check, 1);
	}
	//if (arguments.qProfileMissingItems.procedures_check) profileWeight = profileWeight + .10;

	if (arguments.qProfileMissingItems.staff_pics_bios_check EQ true)
	{
		profileWeight = profileWeight + .05;
		displayCount = displayCount + 1;
		profileCounter = profileCounter + Min(arguments.qProfileMissingItems.staff_pics_bios_check, 1);
	}

	//profileCounter = profileCounter + Min(arguments.qProfileMissingItems.logo_check, 1);

	if (arguments.qProfileMissingItems.procedures_check EQ true)
	{
		profileCounter = profileCounter + Min(arguments.qProfileMissingItems.procedures_check, 1);
	}

	if (arguments.qProfileMissingItems.coupon_check EQ true)
	{
		profileCounter = profileCounter + Min(arguments.qProfileMissingItems.coupon_check, 1);
	}

	//profileComplete = Round((profileCounter / profileCount) * 100);
	</cfscript>

	<!--- <cfreturn profileComplete> --->

	<cfreturn (profileWeight * 100)>
</cffunction>

<cffunction name="ProfileCompleteRecommended" access="public" returntype="Numeric" output="false">
	<cfargument name="qProfileMissingItemsRecommended" default="#QueryNew('')#" type="query">
<!--- Calculate what percentage of the PROfile is complete --->
	<cfscript>
	var profileCount = 5;
	var profileCounter = 0;
	var profileComplete = 0;
	var officehours_check = 1;

	profileCounter = profileCounter + Min(arguments.qProfileMissingItemsRecommended.insider_interview_missing, 1);
	if(this.specialty_has_Financing)
	{
		profileCounter = profileCounter + Min(arguments.qProfileMissingItemsRecommended.Financing_missing, 1);
		profileCount = profileCount + 1;
	}
	profileCounter = profileCounter + Min(arguments.qProfileMissingItemsRecommended.recommendations_missing, 1);
	profileCounter = profileCounter + Min(arguments.qProfileMissingItemsRecommended.office_hours_missing, 1);
	profileCounter = profileCounter + Min(arguments.qProfileMissingItemsRecommended.languages_spoken_missing, 1);
	profileCounter = profileCounter + Min(arguments.qProfileMissingItemsRecommended.headline_missing, 1);

	profileComplete = Round((profileCounter / profileCount) * 100);
	</cfscript>

	<cfreturn profileComplete>
</cffunction>

<cffunction name="GetLeadOpenTime" access="public" returntype="query" output="false">
	<cfargument default="" name="lead_id">
	<cfargument default="" name="lead_type">

	<cfset var qLeadOpenTime = QueryNew("")>

	<cfif isnumeric(arguments.lead_id) AND ListFindNoCase("folio,mini", arguments.lead_type)>
		<cfquery datasource="myLocateadoc" name="qLeadOpenTime">
			<cfif arguments.lead_type EQ "Folio">
				SELECT
				Truncate( TIMESTAMPDIFF(Hour, f.date, fo.date_entered) , 1)  as Hours,
				Truncate( TIMESTAMPDIFF(Day, f.date, fo.date_entered) , 1)  as Days
				FROM folio_opens fo
				INNER JOIN folio f ON f.folio_id = fo.folio_id AND f.date > "2009-09-17"
				WHERE fo.folio_id = #arguments.lead_id#
				ORDER BY fo.opened_id
				LIMIT 1
			<cfelseif arguments.lead_type EQ "Mini">
				SELECT 	Truncate( TIMESTAMPDIFF(Hour, date, lead_opened_dt) , 1)  as Hours,
						Truncate( TIMESTAMPDIFF(Day, date, lead_opened_dt) , 1)  as Days
				FROM user_accounts_hits
				WHERE id = #arguments.lead_id#
			</cfif>
		</cfquery>
	</cfif>

	<cfreturn qLeadOpenTime>
</cffunction>


</cfcomponent>