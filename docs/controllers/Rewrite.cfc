<cfcomponent extends="Controller" output="false">

	<cffunction name="init">
	</cffunction>

	<cffunction name="index">
		<cfset var Local = {}>
		<cfset Local.controller = "">
		<cfset Local.action = "">
		<cfset Local.key = "">
		<cfif params.key eq "">
			<!--- Redirect to home page if key is empty --->
			<cfset dumpStruct = {params=params}>
			<cfset fnCthulhuException(	scriptName="Rewrite.cfc",
										message="No silo name passed.",
										detail="If you don't mind, I'd like to stop listening to you and start talking.",
										dumpStruct=dumpStruct,
										redirectURL="/"
										)>
		</cfif>
		<!--- Check if the key matches a procedure --->
		<cfset Local.procedure = model("procedure").findAllBySiloNameAndIsPrimary(values="#params.key#,1", select="id")>
		<cfif Local.procedure.recordCount>
			<!--- If procedure matches, check if we have a guide for it --->
			<cfset Local.procedureGuide = model("resourceGuideProcedure").findAllByProcedureId(
																				value=Local.procedure.id,
																				include="resourceGuide",
																				select="content")>
			<cfif Local.procedureGuide.recordCount and Local.procedureGuide.content neq "">
				<!--- If guide found and it's not empty, set variables to load procedure guide page --->
				<cfset Local.controller = "Resources">
				<cfset Local.action="procedure">
				<cfset Local.key=Local.procedure.id>
			<cfelse>
				<!--- If no procedure guide, redirect to the specialty guide for the procedure --->
				<cfset Local.specialty = model("specialty").findAll(
														include="specialtyProcedures",
														where="specialtyprocedures.procedureId = #Local.procedure.id#",
														select="specialties.siloName")>
				<cflocation url="/#Local.specialty.siloName#" addtoken="no" statuscode="301">
			</cfif>
		<cfelse>
			<!--- Check for merged procedures --->
			<cfset Local.siloProcedure = model("Procedure").findOneBySiloName(
																				value=params.key,
																				select="id",
																				includeSoftDeletes="true")>
			<cfif isObject(Local.siloProcedure)>
				<!--- If it's merged, get the new procedure --->
				<cfset Local.procedureRedirect = model("procedureRedirect").findOneByProcedureIdFrom(
																				value=Local.siloProcedure.id,
																				select="procedureIdTo",
																				order="id DESC")>
				<cfif isObject(Local.procedureRedirect)>
					<!--- Redirect if the new procedure is found --->
					<cfset Local.siloProcedure = model("Procedure").findByKey(
																				key=Local.procedureRedirect.procedureIdTo,
																				select="siloName")>
					<cflocation url="#ReplaceNoCase(params.silourl, params.key, Local.siloProcedure.siloName)#"
								addtoken="no"
								statuscode="301">
				</cfif>
			</cfif>
			<!--- Check if the key matches a specialty --->
			<cfset Local.specialty = model("specialty").findAllBySiloName(value=params.key, select="id")>
			<cfif Local.specialty.recordCount>
				<!--- If specialty matches, set variables to load specialty guide page --->
				<cfset Local.controller = "Resources">
				<cfset Local.action="specialty">
				<cfset Local.key=Local.specialty.id>
			<cfelse>
				<!--- Check if the key matches a doctor's name --->
				<cfset Local.doctor = model("AccountDoctorSiloName").findAllBySiloName(value=params.key, include = "AccountDoctor", select="id,accountDoctorId,isActive")>
				<cfif Local.doctor.recordCount>
					<cfif Local.doctor.isActive>
						<!--- If the silo name is active, set variables to load their profile page --->
						<cfset Local.controller = "Profile">
						<cfset Local.action = "welcome">
						<cfset Local.key = doctor.accountDoctorId>
					<cfelse>
						<!--- Otherwise find active silo name for doctor --->
						<cfset Local.currentSiloName = model("AccountDoctorSiloName").findAll(where="accountDoctorId = #Local.doctor.accountDoctorId# AND isActive = 1", select="siloName")>
						<cfif Local.currentSiloName.recordCount>
							<!--- If found, redirect to active silo name --->
							<cflocation url="/#Local.currentSiloName.siloName#" addtoken="no" statuscode="301">
						<cfelse>
							<!--- Otherwise, redirect to doctor directory --->
							<cfset dumpStruct = {params=params,Local=Local,currentSiloName=Local.currentSiloName}>
							<cfset fnCthulhuException(	scriptName="Rewrite.cfc",
														message="Couldn't find active silo name for doctor (id: #Local.doctor.accountDoctorId#)",
														detail="Your time machine seems to be broken.",
														dumpStruct=dumpStruct,
														redirectURL="/doctors"
														)>
						</cfif>
					</cfif>
				<cfelse>
					<!--- If key doesn't match anything, redirect to home page --->
					<cfset dumpStruct = {params=params,Local=Local,doctor=Local.doctor}>
					<cfset fnCthulhuException(	scriptName="Rewrite.cfc",
												message="The silo name '#params.key#' doesn't match any specialty, procedure, or doctor.",
												detail="Hi, you've reached the wrong Universe. Please select another one.",
												dumpStruct=dumpStruct,
												redirectURL="/"
												)>
				</cfif>
			</cfif>
		</cfif>

		<!--- Adjusting Client vars --->
		<cfif Client.EntryPage contains "rewrite/index">
			<cfset Client.entryPage = "/#Local.controller#/#Local.action##Local.key neq ""?"/#Local.key#":""#">
			<cfset Client.entryPageSiloed = "/#params.key#">
		</cfif>
		<!--- Convert URL vars to params --->
		<cfset Local.queryString = ListLast(params.silourl, "?")>
		<cfset Local.queryArray = ListToArray(Local.queryString, "&")>
		<cfloop array="#Local.queryArray#" index="Local.i">
			<cfset params[#ListFirst(Local.i,"=")#] = ListLast(Local.i,"=")>
		</cfloop>
		<!--- Calling the correct page --->
		<cfset params.controller = Local.controller>
		<cfset params.action = Local.action>
		<cfset params.key = Local.key>
		<cfinvoke 	component="/controllers/#params.controller#"	method="#params.action#Rewrite" returnvariable="Local.tempVars" params="#params#">

		<cfset structAppend(variables, Local.tempVars, false)>
		<cfif structKeyExists(params, "print-view")>
			<cfset Local.layout = "/print">
		<cfelse>
			<cfset Local.layout = true>
		</cfif>

		<!--- <cfoutput>
		Client.desktop = #Client.desktop#<br />
		Request.isMobileBrowser = #Request.isMobileBrowser#<br />
		Client.forcemobile = #Client.forcemobile#<br />
		Request.mobileLayout = #Request.mobileLayout#<br />
		</cfoutput>

		<cfabort> --->
		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile) and Request.mobileLayout>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfif params.controller EQ "Profile">
				<!--- Render mobile page --->
				<cfset renderPage(template="/#params.controller#/#params.action#_mobile", layout="/layout_mobile")>
			<cfelse>
				<cfset renderPage(template="/#params.controller#_mobile/#params.action#", layout="/layout_mobile")>
			</cfif>
		<cfelse>
			<cfset renderPage(controller = params.controller, action=params.action, layout=#Local.layout#)>
		</cfif>
	</cffunction>

	<cffunction name="reviewsDirect">
		<cfparam name="params.siloname" default="">
		<cfparam name="params.key" default="">

		<cfif params.siloname eq "">
			<!--- Redirect to home page if key is empty --->
			<cfset dumpStruct = {params=params}>
			<cfset fnCthulhuException(	scriptName="Rewrite.cfc",
										message="No silo name passed.",
										detail="No glib remark or pithy comeback detected.",
										dumpStruct=dumpStruct,
										redirectURL="/"
										)>
		</cfif>

		<!--- Check if the key matches a procedure --->
		<cfset Local.procedure = model("procedure").findAllBySiloNameAndIsPrimary(values="#params.siloname#,1", select="id")>
		<cfif Local.procedure.recordCount>
			<!--- If procedure matches, check if we have a guide for it --->
			<cfset Local.procedureGuide = model("resourceGuideProcedure").findAllByProcedureId(
																				value=Local.procedure.id,
																				include="resourceGuide",
																				select="content")>
			<cfif Local.procedureGuide.recordCount and Local.procedureGuide.content neq "">
				<!--- If guide found and it's not empty, set variables to load procedure guide page --->
				<cfset Local.controller = "Resources">
				<cfset Local.action="reviews">
				<cfset Local.key=Local.procedure.id>
			<cfelse>
				<!--- If no procedure guide, redirect to the specialty guide for the procedure --->
				<cfset Local.specialty = model("specialty").findAll(
														include="specialtyProcedures",
														where="specialtyprocedures.procedureId = #Local.procedure.id#",
														select="specialties.siloName")>
				<cflocation url="/#Local.specialty.siloName#" addtoken="no" statuscode="301">
			</cfif>
		<cfelse>
			<!--- Check for merged procedures --->
			<cfset Local.siloProcedure = model("Procedure").findOneBySiloName(
																				value=params.siloname,
																				select="id",
																				includeSoftDeletes="true")>
			<cfif isObject(Local.siloProcedure)>
				<!--- If it's merged, get the new procedure --->
				<cfset Local.procedureRedirect = model("procedureRedirect").findOneByProcedureIdFrom(
																				value=Local.siloProcedure.id,
																				select="procedureIdTo",
																				order="id DESC")>
				<cfif isObject(Local.procedureRedirect)>
					<!--- Redirect if the new procedure is found --->
					<cfset Local.siloProcedure = model("Procedure").findByKey(
																				key=Local.procedureRedirect.procedureIdTo,
																				select="siloName")>
					<cflocation url="#ReplaceNoCase(params.silourl, params.siloname, Local.siloProcedure.siloName)#"
								addtoken="no"
								statuscode="301">
				</cfif>
			</cfif>

			<!--- Check if the key matches a doctor's name --->
			<cfset Local.doctor = model("AccountDoctorSiloName").findAllBySiloName(value=params.siloname, include = "AccountDoctor", select="id,accountDoctorId,isActive")>
			<cfif Local.doctor.recordCount>
				<cfif Local.doctor.isActive>
					<!--- If the silo name is active, set variables to load their profile page --->
					<cfset Local.controller = "Profile">
					<cfset Local.action = "reviews">
					<cfset Local.key = doctor.accountDoctorId>
				<cfelse>
					<!--- Otherwise find active silo name for doctor --->
					<cfset Local.currentSiloName = model("AccountDoctorSiloName").findAll(where="accountDoctorId = #Local.doctor.accountDoctorId# AND isActive = 1", select="siloName")>
					<cfif Local.currentSiloName.recordCount>
						<!--- If found, redirect to active silo name --->
						<cflocation url="/#Local.currentSiloName.siloName#" addtoken="no" statuscode="301">
					<cfelse>
						<!--- Otherwise, redirect to doctor directory --->
						<cfset dumpStruct = {params=params,Local=Local,currentSiloName=Local.currentSiloName}>
						<cfset fnCthulhuException(	scriptName="Rewrite.cfc",
													message="Couldn't find active silo name for doctor (id: #Local.doctor.accountDoctorId#)",
													detail="Are you the brain specialist?",
													dumpStruct=dumpStruct,
													redirectURL="/doctors"
													)>
					</cfif>
				</cfif>
			<cfelse>
				<!--- If key doesn't match anything, redirect to home page --->
				<cfset dumpStruct = {params=params,Local=Local,doctor=Local.doctor}>
				<cfset fnCthulhuException(	scriptName="Rewrite.cfc",
											message="The silo name '#params.siloname#' doesn't match any procedure or doctor.",
											detail="The opinions of a critic are no more valuable than those of the meek or infirm.",
											dumpStruct=dumpStruct,
											redirectURL="/"
											)>
			</cfif>
		</cfif>

		<!--- Adjusting Client vars --->
		<cfif Client.EntryPage contains "rewrite/index">
			<cfset Client.entryPage = "/#Local.controller#/#Local.action##Local.key neq ""?"/#Local.key#":""#">
			<cfset Client.entryPageSiloed = "/#params.key#">
		</cfif>
		<!--- Convert URL vars to params --->
		<cfset Local.queryString = ListLast(params.silourl, "?")>
		<cfset Local.queryArray = ListToArray(Local.queryString, "&")>
		<cfloop array="#Local.queryArray#" index="Local.i">
			<cfset params[#ListFirst(Local.i,"=")#] = ListLast(Local.i,"=")>
		</cfloop>

		<!--- Calling the correct page --->
		<cfset params.controller = Local.controller>
		<cfset params.action = Local.action>
		<cfset params.key = Local.key>
		<cfset Request.overrideLayout = "">
		<cfinvoke 	component="/controllers/#params.controller#"	method="#params.action#Rewrite" returnvariable="Local.tempVars" params="#params#">
		<cfset structAppend(variables, Local.tempVars, false)>
		<cfif structKeyExists(params, "print-view")>
			<cfset Local.layout = "/print">
		<cfelse>
			<cfset Local.layout = true>
		</cfif>

		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile) and Request.mobileLayout>
				<cfset isMobile = true>
				<cfset mobileSuffix = "_mobile">

				<!--- Render mobile page --->
				<cfif reFindNoCase("^reviews/?", params.action) AND params.controller EQ "resources">
					<cfset renderPage(layout="/layout_mobile",template="/resources/procedure")>
				<cfelse>
					<cfset renderPage(template="/#params.controller#/#params.action#_mobile", layout="/layout_mobile")>
				</cfif>
		<cfelse>

			<cfif Request.overrideLayout neq "">
				<cfset renderPage(controller = params.controller, action=Request.overrideLayout, layout=#Local.layout#)>
			<cfelse>
				<cfset renderPage(controller = params.controller, action=params.action, layout=#Local.layout#)>
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>