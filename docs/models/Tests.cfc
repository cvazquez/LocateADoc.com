<cfcomponent extends="Model" output="false">

<cffunction name="init">
        <cfset table("accountdoctors")>
    </cffunction>

	<cffunction name="advertisers" returntype="query">
		<cfset var qAdvertisers = "">

		<cfquery datasource="#get("datasourcename")#" name="qAdvertisers">
			SELECT a.id AS accountId, ad.id AS accountDoctorId, ad.firstName, ad.lastName, c.name AS cityName, s.name AS stateName
			FROM accountproductspurchased app
			INNER JOIN accounts a ON a.id = app.accountId AND a.deletedAt IS NULL
			INNER JOIN accountproductspurchaseddoctorlocations appdl ON appdl.accountProductsPurchasedId = app.id AND appdl.deletedAt IS NULL
			INNER JOIN accountdoctorlocations adl ON adl.id = appdl.accountDoctorLocationId AND adl.deletedAt IS NULL
			INNER JOIN accountpractices ap ON  adl.accountPracticeId = ap.id AND adl.deletedAt IS NULL AND ap.deletedAt IS NULL
			INNER JOIN accountdoctors ad ON ad.id = adl.accountDoctorId AND ad.deletedAt IS NULL
			INNER JOIN accountlocations al ON al.id = adl.accountLocationId AND al.deletedAt IS NULL
			LEFT JOIN states s ON s.id = al.stateId
			LEFT JOIN cities c ON c.id = al.cityId
			WHERE app.dateEnd >= now() AND app.deletedAt IS NULL
			GROUP BY ad.id
			ORDER BY s.name, c.name
		</cfquery>

		<cfreturn qAdvertisers>
	</cffunction>

	<cffunction name="pastadvertisers" returntype="query">
		<cfset var qPastAdvertisers = "">

		<cfquery datasource="#get("datasourcename")#" name="qPastAdvertisers">
			SELECT a.id AS accountId, ad.id AS accountDoctorId, ad.firstName, ad.lastName, c.name AS cityName, s.name AS stateName
			FROM accountproductspurchasedhistory apph
			INNER JOIN accounts a ON a.id = apph.accountId AND a.deletedAt IS NULL
			LEFT JOIN accountproductspurchased app ON app.accountId = apph.accountId AND app.dateEnd > now() AND app.deletedAt IS NULL
			INNER JOIN accountpractices ap ON ap.accountId = apph.accountId AND ap.deletedAt IS NULL
			INNER JOIN accountdoctorlocations adl ON adl.accountPracticeId = ap.id AND adl.deletedAt IS NULL
			INNER JOIN accountdoctors ad ON ad.id = adl.accountDoctorId AND ad.deletedAt IS NULL
			INNER JOIN accountlocations al ON al.id = adl.accountLocationId AND al.deletedAt IS NULL
			LEFT JOIN states s ON s.id = al.stateId
			LEFT JOIN cities c ON c.id = al.cityId
			WHERE app.id IS NULL
			GROUP BY ad.id
			ORDER BY rand()
			LIMIT 100;
		</cfquery>

		<cfreturn qPastAdvertisers>
	</cffunction>


	<cffunction name="basicplus" returntype="query">
		<cfset var qBasicPlus = "">

		<cfquery datasource="#get("datasourcename")#" name="qBasicPlus">
			SELECT a.id AS accountId, ad.id AS accountDoctorId, ad.firstName, ad.lastName, c.name AS cityName, s.name AS stateName
			FROM accountdoctoremails ade
			INNER JOIN accountdoctorlocations adl ON adl.accountDoctorId = ade.accountDoctorId AND adl.deletedAt IS NULL
			INNER JOIN accountpractices ap ON ap.id = adl.accountPracticeId AND ap.deletedAt IS NULL
			INNER JOIN accounts a ON a.id = ap.accountId AND a.deletedAt IS NULL
			LEFT JOIN accountproductspurchased app ON app.accountId = ap.accountId
			LEFT JOIN accountproductspurchasedhistory apph ON apph.accountId = ap.accountId
			INNER JOIN accountdoctors ad ON ad.id = adl.accountDoctorId AND ad.deletedAt IS NULL
			INNER JOIN accountlocations al ON al.id = adl.accountLocationId AND al.deletedAt IS NULL
			LEFT JOIN states s ON s.id = al.stateId
			LEFT JOIN cities c ON c.id = al.cityId
			WHERE ade.categories = "lead" AND ade.deletedAt IS NULL AND app.id IS NULL AND apph.id IS NULL
			GROUP BY ad.id
			ORDER BY s.name, c.name;
		</cfquery>

		<cfreturn qBasicPlus>
	</cffunction>

	<cffunction name="basic" returntype="query">
		<cfset var qBasic = "">

		<cfquery datasource="#get("datasourcename")#" name="qBasic">
			SELECT a.id AS accountId, ad.id AS accountDoctorId, ad.firstName, ad.lastName, c.name AS cityName, s.name AS stateName
			FROM accountdoctorlocations adl
			INNER JOIN accountpractices ap ON ap.id = adl.accountPracticeId AND ap.deletedAt IS NULL
			INNER JOIN accounts a ON a.id = ap.accountId AND a.deletedAt IS NULL
			LEFT JOIN accountproductspurchased app ON app.accountId = ap.accountId
			LEFT JOIN accountproductspurchasedhistory apph ON apph.accountId = ap.accountId
			INNER JOIN accountdoctors ad ON ad.id = adl.accountDoctorId AND ad.deletedAt IS NULL
			INNER JOIN accountlocations al ON al.id = adl.accountLocationId AND al.deletedAt IS NULL
			INNER JOIN states s ON s.id = al.stateId
			INNER JOIN cities c ON c.id = al.cityId
			WHERE adl.deletedAt IS NULL AND app.id IS NULL AND apph.id IS NULL
			GROUP BY ad.id
			ORDER BY rand()
			LIMIT 100;
		</cfquery>

		<cfreturn qBasic>
	</cffunction>

	<cffunction name="yext" returntype="query">
		<cfset var qYext = "">

		<cfquery datasource="#get("datasourcename")#" name="qYext">
			SELECT a.id AS accountId, ad.id AS accountDoctorId, ad.firstName, ad.lastName, c.name AS cityName, s.name AS stateName
			FROM accountdoctorassociations ada
			INNER JOIN accountdoctors ad ON ad.id = ada.accountDoctorId AND ad.deletedAt IS NULL
			INNER JOIN accountdoctorlocations adl ON adl.accountDoctorId = ad.id AND adl.deletedAt IS NULL
			INNER JOIN accountpractices ap ON ap.id = adl.accountPracticeId AND ap.deletedAt IS NULL
			INNER JOIN accounts a ON a.id = ap.accountId AND a.deletedAt IS NULL
			INNER JOIN accountlocations al ON al.id = adl.accountLocationId AND al.deletedAt IS NULL
			INNER JOIN states s ON s.id = al.stateId
			INNER JOIN cities c ON c.id = al.cityId
			LEFT JOIN accountproductspurchased app ON app.accountId = ap.accountId AND app.deletedAt is NULL
			WHERE ada.associationId = 7 AND ada.deletedAt IS NULL AND app.id IS NULL
			GROUP BY ad.id
			ORDER BY rand()
			LIMIT 100;
		</cfquery>

		<cfreturn qYext>
	</cffunction>
</cfcomponent>