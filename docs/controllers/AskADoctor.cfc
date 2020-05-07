<cfcomponent extends="Controller" output="false">

	<!--- Global variables --->
	<cfset breadcrumbs = []>
	<cfset arrayAppend(breadcrumbs,linkTo(href="/",text="Home"))>

	<!--- None of the Ask A Doctor pages will show the mobile find a doctor search --->
	<!--- <cfset Request.isMobileBrowser = true> --->

	<!--- determine destination of breadcrumb link --->
	<cfparam name="client.returnlink" default="">
	<cfif (CGI.HTTP_REFERER contains CGI.HTTP_HOST) and not (CGI.HTTP_REFERER contains "/profile")>
		<cfset client.returnlink = CGI.HTTP_REFERER>
	</cfif>

	<cffunction name="init">
		<cfset provides("html,json")>
		<cfset filters(through="recordHit",type="after",except="")>
		<cfset usesLayout("checkPrint")>
	</cffunction>

	<cffunction name="checkPrint">
		<cfif structKeyExists(params, "print-view")>
			<cfreturn "/print">
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>

	<cffunction name="index">
		<cfparam name="params.SpecialtyOrProcedureId" default="">

		<cfset specialContent = model("SpecialContent").findOneById(
				select	= "title, metaKeywords, metaDescription, header, content, description",
				value	= "23"
			)>

		<cfset title = specialContent.title>
		<cfset metaDescriptionContent = specialContent.metaDescription>
		<cfset metaKeywordsContent = specialContent.metaKeywords>

		<cfset AskADocQuestion = model("AskADocQuestion").new()>

		<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10)>
		<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>

		<cfset recentCategories = model("AskADocQuestion").recentCategories(limit=10)>
		<cfset recentCategoriesTotal = model("AskADocQuestion").GetTotal().total>

		<cfset experts = model("AskADocQuestion").experts(offset=0,limit=12)>

		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,'<span>Ask A Doctor</span>')>

		<!--- <cfoutput>
		<p>Client.desktop =#Client.desktop#</p>
		<p>Request.isMobileBrowser = #Request.isMobileBrowser#</p>
		<p>Client.forcemobile = #Client.forcemobile#</p>
		</cfoutput>
		<cfabort> --->

		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset renderPage(template="index_mobile", layout="/layout_mobile")>
		</cfif>

	</cffunction>

	<cffunction name="QuestionSave">
		<cfset var local = {}>

		<cfset local.specialty = FALSE>
		<cfset local.procedure = FALSE>
		<cfset local.specialtyId = 0>
		<cfset local.procedureId = 0>
		<cfset local.SpecialtyOrProcedureName = "">
		<cfset local.emailFrom = "askadoc-question@locateadoc.com">
		<cfset local.emailFromDoctorsList = "noreply@locateadoc.com">
		<cfset local.siloName = "">
		<cfset local.hasCFHTTPResponse = FALSE>

		<cfparam name="params.AskADocQuestion.firstname" default="">
		<cfparam name="params.AskADocQuestion.question" default="">
		<cfparam name="params.SpecialtyOrProcedureId" default="">
		<cfparam name="params.AskADocQuestion.email" default="">
		<cfparam name="params.AskADocQuestion.listOfDoctors" default="">
		<cfparam name="params.AskADocQuestion.postalCode" default="">

		<cfset AskADocQuestion = model("AskADocQuestion").new(params.ASKADOCQUESTION)>

		<cfif ReFindNoCase("^(specialty-)[0-9]+", params.SPECIALTYORPROCEDUREID)>

			<cfif val(ListLast(params.SPECIALTYORPROCEDUREID, "-")) GT 0>
				<cfset AskADocQuestion.specialtyId = val(ListLast(params.SPECIALTYORPROCEDUREID, "-"))>
				<cfset local.specialty = TRUE>
			</cfif>

		<cfelseif ReFindNoCase("^(procedure-)[0-9]+", params.SPECIALTYORPROCEDUREID)>

			<cfif val(ListLast(params.SPECIALTYORPROCEDUREID, "-")) GT 0>
				<cfset AskADocQuestion.procedureId = val(ListLast(params.SPECIALTYORPROCEDUREID, "-"))>
				<cfset local.procedure = TRUE>
			</cfif>
		<cfelseif trim(params.SPECIALTYORPROCEDUREID) NEQ "">
			<!--- For mobile sites, look up the actual procedure name --->
			<cfset searchProcedure = model("Procedure").FindOneByName(	value	= params.SPECIALTYORPROCEDUREID,
																	select	= "id")>
			<cfif isObject(searchProcedure)>
				<cfset AskADocQuestion.procedureId = searchProcedure.id>
				<cfset local.procedure = TRUE>
			<cfelse>
				<cfset searchSpecialty = model("Specialty").FindOneByName(	value	= params.SPECIALTYORPROCEDUREID,
																		select	= "id")>
				<cfif isObject(searchSpecialty)>
					<cfset AskADocQuestion.specialtyId = searchSpecialty.id>
					<cfset local.specialty = TRUE>
				</cfif>
			</cfif>
		</cfif>


		<cfif isdefined("client.facebookid") AND val(client.facebookid) GT 0>
			<cfset AskADocQuestion.faceBookId = val(client.facebookid)>
		</cfif>
		<cfif isdefined("client.facebookphoto") AND trim(client.facebookphoto) NEQ "">
			<cfset AskADocQuestion.faceBookPhoto = client.facebookphoto>
		</cfif>

		<cfif params.AskADocQuestion.postalCode NEQ "">
			<cfset AskADocQuestion.postalCode = params.AskADocQuestion.postalCode>
		</cfif>

		<cfset AskADocQuestion.ipAddress = cgi.REMOTE_ADDR>
		<cfset AskADocQuestion.refererInternal = cgi.HTTP_REFERER>
		<cfset AskADocQuestion.userAgent = cgi.HTTP_USER_AGENT>


		<cfparam default="" name="client.referralfull">
		<cfparam default="" name="client.entrypage">
		<cfparam default="" name="client.keywords">
		<cfparam default="" name="client.cfid">
		<cfparam default="" name="client.cfToken">

		<cfset AskADocQuestion.refererExternal = client.referralfull>
		<cfset AskADocQuestion.entryPage = client.entrypage>
		<cfset AskADocQuestion.keywords = client.keywords>
		<cfset AskADocQuestion.cfId = client.cfid>
		<cfset AskADocQuestion.cfToken = client.cfToken>

		<cfset saveForm = AskADocQuestion.save()>

		<cfif saveForm>

			<cfif local.specialty>
				<cfset local.qSpecialty = model("Specialty").findOneById(	value	= AskADocQuestion.specialtyId,
																			select	= "name, siloName")>
				<cfset local.SpecialtyOrProcedureName = local.qSpecialty.name>
				<cfset local.siloName = local.qSpecialty.siloName>

				<cfset saveSpecialty = model("AskADocQuestionSpecialty").new()>
				<cfset saveSpecialty.askADocQuestionId = AskADocQuestion.id>
				<cfset saveSpecialty.specialtyId = AskADocQuestion.specialtyId>
				<cfset local.specialtyId = AskADocQuestion.specialtyId>

				<cfset saveSpecialty.save()>

			<cfelseif local.procedure>
				<cfset local.qProcedure = model("Procedure").findOneById(	value	= AskADocQuestion.procedureId,
																			select	= "name, siloName")>
				<cfset local.SpecialtyOrProcedureName = local.qProcedure.name>
				<cfset local.siloName = local.qProcedure.siloName>

				<cfset saveProcedure = model("AskADocQuestionProcedure").new()>

				<cfset saveProcedure.askADocQuestionId = AskADocQuestion.id>
				<cfset saveProcedure.procedureId = AskADocQuestion.procedureId>
				<cfset local.procedureId = AskADocQuestion.procedureId>
				<cfset saveProcedure.save()>
			</cfif>

			<!--- check if the patient came from a profile page --->
			<cfset ProfileCheck = model("AskADocQuestion").ProfileCheck(askADocQuestionId	 = AskADocQuestion.id)>

			<cfif server.thisServer EQ "dev">
				<cfset local.emailTo = params.AskADocQuestion.email>
			<cfelse>
				<cfset local.emailTo = local.emailFrom>
			</cfif>

			<cfmail from	= "#local.emailFrom#"
					to		= "#local.emailTo#"
					replyTo	= "#params.AskADocQuestion.email#"
					subject	= "A New Ask A Doctor Questions Has Been Submitted"
					bcc		= "exclusiveleads@locateadoc.com"
					type	= "html" >
				<p><strong>First Name:</strong> #params.AskADocQuestion.firstname#</p>
				<p><strong>Question:</strong><br /> #ParagraphFormat(params.AskADocQuestion.question)#</p>
				<p><strong>Specialty/Procedure:</strong> #local.SpecialtyOrProcedureName#</p>
				<p><strong>Email:</strong> #params.AskADocQuestion.email#</p>

				<p><strong><a href="https://www.practicedock.com/admin/wheels/index.cfm/article/editaskadoctor/#AskADocQuestion.id#">View Question</a></strong></p>
				<cfif profileCheck.recordCount GT 0>
					<p><strong>The patient was on the following Profile page before submitting this question:</strong><br />
						<a href="http://www.locateadoc.com/#profileCheck.siloName#" target="_blank">#profileCheck.firstName# #profileCheck.lastName#</a> - <a href="https://www.practicedock.com/admin/accounts/setupwizard.cfm?a=account_tree&type=extended&account_id=#profileCheck.accountId#" target="_blank">Account Page</a>
					</p>
				</cfif>
			</cfmail>

			<cfif params.AskADocQuestion.listOfDoctors EQ 1>

				<cfif params.AskADocQuestion.postalCode NEQ "">
					<cfset local.location = ParseLocation(params.AskADocQuestion.postalCode)>
					<cfset local.hasCFHTTPResponse = FALSE>

					<cfif local.location.ZIPFOUND IS false AND client.postalcode NEQ "">
						<cfset local.location = ParseLocation(client.postalcode)>
					</cfif>


					<cfif local.location.ZIPFOUND IS true>
						<cfhttp url="http://#cgi.server_name#/doctors/#local.siloName#/location-#lcase(local.location.zipCode)#?email-view&perpage=5&firstname=#urlEncodedFormat(params.AskADocQuestion.firstname)#&email=#urlencodedFormat(local.emailTo)#"
								method="GET"
								resolveurl="TRUE" redirect="true">
						</cfhttp>

						<cfif cfhttp.StatusCode EQ "200 OK">
							<cfset local.doctorResults = CFHTTP.FileContent>
							<cfset local.doctorResults = reReplaceNoCase(local.doctorResults, "[a-z0-9]+\.locateadoc\.com", "www.locateadoc.com", "all")>
							<cfset local.hasCFHTTPResponse = TRUE>
						</cfif>
					</cfif>


					<cfif local.hasCFHTTPResponse>

						<cfmail from	= "#local.emailFromDoctorsList#"
							to		= "#params.AskADocQuestion.email#"
							replyTo	= "#local.emailFromDoctorsList#"
							subject	= "LocateADoc.com: Your Requested List of Doctors in #local.SpecialtyOrProcedureName#"
							bcc		= "exclusiveleads@locateadoc.com"
							type	= "html" >
							<div style="width:320px">
								#local.doctorResults#
								<p>This email was sent to #local.emailTo#</p>
							</div>
						</cfmail>
					</cfif>
				</cfif>
			</cfif>


			<!--- Check if questions exist for this specialty/procedure --->
			<cfset Questions = model("AskADocQuestion").GetQuestions(
					specialty = local.specialtyId,
					procedure = local.procedureId,
					limit = 1)>



			<cfsavecontent variable="local.successTest">
				<cfoutput>
					Your Ask A LocateADoc Doctor Question has submitted successfully.<br /><br />

					Ask another one below<cfif Questions.recordcount EQ 0>.<cfelse> or view related <a href="/ask-a-doctor/questions/#local.siloName#">#local.SpecialtyOrProcedureName# questions</a>.</cfif>
				</cfoutput>
			</cfsavecontent>

            <cfset redirectTo(	controller	= params.controller,
								action		= "index",
								success		= local.successTest)>
		<cfelse>


			<cfif AskADocQuestion.hasErrors()>
				<cfset specialContent = model("SpecialContent").findOneById(
					select	= "title, metaKeywords, metaDescription, header, content, description",
					value	= "23"
				)>

				<cfset title = specialContent.title>
				<cfset metaDescriptionContent = specialContent.metaDescription>
				<cfset metaKeywordsContent = specialContent.metaKeywords>

				<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10)>
				<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>

				<cfset recentCategories = model("AskADocQuestion").recentCategories(limit=10)>

				<cfset experts = model("AskADocQuestion").experts(offset=0,limit=12)>

				<!--- Breadcrumbs --->
				<cfset arrayAppend(breadcrumbs,'<span>Ask A Doctor</span>')>


				<!--- Render mobile page --->
				<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
					<cfset recentCategoriesTotal = model("AskADocQuestion").GetTotal().total>
					<cfset renderPage(template="index_mobile", layout="/layout_mobile")>
				<cfelse>
					<cfset renderPage(	controller	= params.controller,
										action		= "index",
										template	= "index")>
				</cfif>
				<cfreturn>

			<cfelse>
				<cfmail from	= "lad3_errors@locateadoc.com"
						to		= "lad3_errors@locateadoc.com"
						subject	= "AskADoc Question Form Error"
						type	= "html">
					<cfdump var="#saveForm#" label="AskADocQuestion">
					<cfdump var="#AskADocQuestion.allErrors()#" label="AskADocQuestionallErrors">
					<cfdump var="#params#" label="PARAMS">
					<cfdump var="#cgi#" label="CGI">
					<cfdump var="#client#" label="CLIENT">
					<cfdump var="#AskADocQuestion#" label="AskADocQuestion">
				</cfmail>

				<cfset dumpStruct = {params=params,AskADocQuestion=AskADocQuestion}>
				<cfset fnCthulhuException(	scriptName="AskADoctor.cfc",
											message="Error Submitting AskADoctor Question",
											detail="NIGERIAN PRINCE, Y U NO SEND ME MY MONEY?",
											dumpStruct=dumpStruct,
											redirectURL="/ask-a-doctor")>
			</cfif>
		</cfif>

	</cffunction>

	<cffunction name="Questions">
		<cfparam name="params.specialty" default="0">
		<cfparam name="params.procedure" default="0">
		<cfparam name="params.tag" default="">
		<cfparam name="params.show" default="">
		<cfparam name="params.page" default="1">
		<cfparam name="params.rewrite" default="0">
		<cfparam name="params.siloname" default="">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">
		<cfparam name="params.key" default="">
		<cfparam name="params.filter1" default="">
		<cfparam name="params.filter2" default="">

		<cfset var Local = {}>
		<cfset Procedure = "">
		<cfset Specialty = "">

		<!---Search the URL for filter params and reformat them for the search--->
		<cfloop collection="#params#" item="i">
			<cfif left(i,6) is "filter">
				<cfset Local.filtername = listFirst(params[i],"-")>
				<cfset Local.filtervalue = Replace(params[i],"#Local.filtername#-","")>
				<cfset params[Local.filtername] = Local.filtervalue>
			</cfif>
		</cfloop>

		<cfset specialContent = model("SpecialContent").findOneById(
			select	= "title, header, content, metaDescription, metaKeywords",
			value	= "id = 24"
		)>

		<cfset title = specialContent.title>
		<cfset metaDescriptionContent = specialContent.metaDescription>
		<cfset metaKeywordsContent = specialContent.metaKeywords>
		<cfset header = specialContent.header>


		<cfif params.filter1 NEQ "" AND NOT reFindNoCase("^page\-[0-9]+", params.filter1)>
			<cfset Procedure = model("procedure").findOneBySiloName(	value	= params.filter1,
																		select	= "id, name, siloName")>

			<cfif NOT isObject(Procedure)>
				<cfset Specialty = model("specialty").findOneBySiloName(	value	= params.filter1,
																			select	= "id, name, siloName")>

				<cfif NOT isObject(Specialty)>
					<cflocation addtoken="false" statuscode="301" url="/ask-a-doctor/questions">
				<cfelse>
					<cfset params.specialty = Specialty.id>

					<cfset title = Specialty.name & " " & title>
					<cfset metaDescriptionContent = specialContent.metaDescription & " for " & Specialty.name>
					<cfset metaKeywordsContent = specialContent.metaKeywords & ", " & Specialty.name>
					<cfset header = Specialty.name & " " & header>
				</cfif>
			<cfelse>
				<cfset params.procedure = Procedure.id>

				<cfset title = Procedure.name & " " & title>
				<cfset metaDescriptionContent = specialContent.metaDescription & " for " & Procedure.name>
				<cfset metaKeywordsContent = specialContent.metaKeywords & ", " & Procedure.name>
				<cfset header = Procedure.name & " " & header>
			</cfif>
		</cfif>

		<cfif reFindNoCase("^page\-[0-9]+$", params.filter2)>
			<cfset params.page = listLast(params.filter2, "-")>
		</cfif>

		<!--- Init pagination variables --->
		<cfset search = {}>
		<cfset search.page = Max(val(params.page),1)>
		<cfset offset = (search.page-1)*10>
		<cfset limit = 10>

		<!--- Get the list of q/a's --->
		<cfset Questions = model("AskADocQuestion").GetQuestions(
			specialty = params.specialty,
			procedure = params.procedure,
			tag = params.tag,
			offset = offset,
			limit = limit
			)>

		<cfif Questions.recordcount eq 0>
			<cfset dumpStruct = {local=local,params=params,articleInfo=Questions}>
			<cfset fnCthulhuException(	scriptName="AskADoctor.cfc",
										message="No question found (offset: #offset#, limit: #limit#).",
										detail="NIGERIAN PRINCE, Y U NO SEND ME MY MONEY?",
										dumpStruct=dumpStruct,
										redirectURL="/ask-a-doctor/questions"
										)>
			<cfset redirectTo(action="index",statuscode="301")>
		</cfif>

		<!--- Get the number of records and pages from the full result set --->
		<cfquery datasource="#get('dataSourceName')#" name="count">
			Select Found_Rows() AS foundrows
		</cfquery>
		<cfset search.totalrecords = count.foundrows>
		<cfset search.pages = ceiling(search.totalrecords/limit)>

		<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10)>
		<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>
		<cfset experts = model("AskADocQuestion").experts(offset=0,limit=12)>

		<cfset recentCategories = model("AskADocQuestion").recentCategories(limit=10)>
		<cfset recentCategoriesTotal = model("AskADocQuestion").GetTotal().total>

		<cfset relNext = getNextPage(search.page,search.pages)>
		<cfset relPrev = getPrevPage(search.page)>

		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor">Ask A Doctor</a></span>')>


		<cfif search.page GT 1>

			<cfif val(params.procedure) GT 0 AND isObject(Procedure)>
				<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor/questions/#Procedure.siloName#">#title#</a> - Page #search.page#</span>')>
				<cfset title = title & " - Page " & search.page>
			<cfelseif val(params.specialty) GT 0 AND isObject(Specialty)>
				<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor/questions/#Specialty.siloName#">#title#</a> - Page #search.page#</span>')>
				<cfset title = title & " - Page " & search.page>
			<cfelse>
				<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor/questions">#title#</a> - Page #search.page#</span>')>
				<cfset title = title & " - Page " & search.page>
			</cfif>

		<cfelse>
			<cfset arrayAppend(breadcrumbs,"<span>#title#</span>")>
		</cfif>

		<cfif val(params.procedure) GT 0>
			<cfset check = model("AskADocQuestion").CheckSimilarCategoryResults(
												procedureId			= params.procedure,
												totalRecords		= search.totalrecords)>

			<!--- The first record returned has the shortest procedure length. If this isn't that procedure's page, then canonicalize to it --->
			<cfif check.recordCount GT 0 AND  check.otherProcedureId NEQ params.procedure>
				<cfset canonicalURL = "http://#cgi.server_name#/ask-a-doctor/questions/#check.otherProcedureSiloName#">
			</cfif>
		</cfif>

		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset renderPage(template="questions_mobile", layout="/layout_mobile")>
		</cfif>

	</cffunction>

	<cffunction name="Question">
		<cfparam default="" name="params.key">
		<cfparam default="" name="params.preview">

		<cfset var Local = {}>

		<cfset listTitle = "">
		<cfset Answers = QueryNew("")>
		<cfset latestPictures = QueryNew("")>
		<cfset local.accountDoctorIds = "">
		<cfset local.procedureIds = "">
		<cfset AskADocQuestionId = "">

		<cfif params.preview IS TRUE AND isnumeric(params.key)>

			<cfset Question = model("AskADocQuestion").GetQA(id = params.key, preview = true)>

			<cfif Question.recordCount GT 0>
				<!--- Retrieve answers --->
				<cfset Answers = model("AskADocQuestionAnswer").GetAnswer(id = params.key, preview = true)>
				<cfset AskADocQuestionId = Question.id>
			</cfif>

		<cfelse>

			<!--- New Question version --->
			<cfset Question = model("AskADocQuestion").GetQA(siloName = params.key, preview = false)>

			<cfif Question.recordCount GT 0>
				<cfset AskADocQuestionId = Question.id>

				<!--- Check if this is an archived question and redirect to the archive page --->
				<cfif Question.xfactorQuestionId GT 0>

					<cfset local.otoPlastyProcedureIds = "4,76,212,265">
					<cfif ListFind(local.otoPlastyProcedureIds, Question.xFactorProcedureId)>
						<!--- An otoplasty procedures. Check if other procedures can be used --->
						<cfloop list="#Question.xFactorProcedureIds#" index="xpids">
							<cfif Not ListFind(local.otoPlastyProcedureIds,xpids)>
								<cfset Question.xFactorProcedureId = xpids>
								<cfbreak>
							</cfif>
						</cfloop>
					</cfif>

					<cfquery datasource="myLocateadoc" name="qArchive">
						SELECT a.id
						FROM xfactor_questions AS a
						INNER JOIN xfactor_questions_procedure_names AS p ON (a.ID = p.question_id)
						INNER JOIN specialty_procedures AS sp ON (sp.procedure_name_id = p.procedure_name_id)
						INNER JOIN specialty_procedure_names AS spn ON (sp.procedure_name_id = spn.procedure_name_id)
						WHERE (sp.procedure_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Question.xFactorProcedureId#">)
						AND (spn.is_active > 0)
						ORDER BY p.order_id, pid DESC, db_updated_dt DESC
					</cfquery>

					<!--- Determine what page this question belongs on --->
					<cfset archiveIds = valueList(qArchive.id)>
					<cfset stepCount = 0>
					<cfset questionsPerPage = 12>
					<cfset page = 1>
					<cfloop list="#archiveIds#" index="archiveId">
						<cfset stepCount = stepCount + 1>
						<cfif archiveId EQ Question.xfactorQuestionId>

							<cfset page = ceiling(stepCount / questionsPerPage)>
							<cfbreak>
						</cfif>
					</cfloop>

					<cflocation addtoken="false" statuscode="301" url="/ask-a-doctor/archive/#Question.xFactorProcedureId#/page-#page####Question.xfactorQuestionId#">

				</cfif>

				<!--- Retrieve answers --->
				<cfset Answers = model("AskADocQuestionAnswer").GetAnswer(id = question.id, preview = false)>

				<cfset local.accountDoctorIds = valueList(Answers.accountDoctorId)>
				<cfset local.procedureIds = valueList(Question.procedureIds)>
			<cfelse>

				<!--- If not found, try an older title version and 301 redirect to the new one--->
				<cfset Question = model("AskADocQuestion").CheckOldTitle(siloName = params.key, preview = false)>

				<cfif Question.recordCount GT 0>
					<cflocation addtoken="false" url="/ask-a-doctor/question/#Question.siloName#" statuscode="301">
				</cfif>

				<!--- then try old question version --->
				<cfset Question = model("ResourceArticleSiloName").GetArticle(siloname = params.key)>

				<cfset local.accountDoctorIds = valueList(Question.accountDoctorIds)>
				<cfset local.procedureIds = valueList(Question.procedureIds)>
			</cfif>
		</cfif>

		<cfif Question.recordCount EQ 0>
			<cflocation addtoken="false" statuscode="301" url="/ask-a-doctor/questions">
		</cfif>

		<cfset title = Question.title>
		<cfset metaDescriptionContent = Question.metaDescription>
		<cfset metaKeywordsContent = Question.metaKeywords>

		<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10)>
		<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>

		<cfset recentCategories = model("AskADocQuestion").recentCategories(limit=10)>
		<cfset recentCategoriesTotal = model("AskADocQuestion").GetTotal().total>

		<cfset experts = model("AskADocQuestion").experts(offset=0,limit=12)>

		<cfif listLen(local.accountDoctorIds) AND listLen(local.procedureIds)>
			<cfset displayCasesDoctorName = TRUE>

			<cfset latestPictures		= model("GalleryCase").findAll(
					select	= "gallerycases.id AS galleryCaseId, procedures.name, procedures.siloName, gallerycasedoctors.accountDoctorId, gallerycaseangles.id AS galleryCaseAngleId, accountdoctors.firstName, accountdoctors.lastName, accountdoctors.middleName, accountdoctors.title",
					include	= "galleryCaseProcedures(procedure),galleryCaseDoctors(accountDoctor(accountDoctorLocations(AccountProductsPurchasedDoctorLocations(AccountProductsPurchased)))),galleryCaseAngles",
					where	= "	accountDoctorId IN (#local.accountDoctorIds#) AND
								procedures.id IN (#local.procedureIds#) AND
								accountproductspurchased.dateEnd >= now() AND
								gallerycaseprocedures.galleryCaseId IS NOT NULL AND gallerycaseprocedures.isPrimary = 1 AND
								gallerycasedoctors.galleryCaseId IS NOT NULL AND
								accountdoctorlocations.id IS NOT NULL AND
								gallerycaseangles.id IS NOT NULL",
					order	= "gallerycases.id DESC, gallerycaseangles.orderNumber asc",
					group	= "accountdoctors.id")>

			<cfif latestPictures.recordCount EQ 1>
				<cfset latestPictures		= model("GalleryCase").findAll(
					select	= "gallerycases.id AS galleryCaseId, procedures.name, procedures.siloName, gallerycasedoctors.accountDoctorId, gallerycaseangles.id AS galleryCaseAngleId, accountdoctors.firstName, accountdoctors.lastName, accountdoctors.middleName, accountdoctors.title",
					include	= "galleryCaseProcedures(procedure),galleryCaseDoctors(accountDoctor(accountDoctorLocations(AccountProductsPurchasedDoctorLocations(AccountProductsPurchased)))),galleryCaseAngles",
					where	= "	accountDoctorId IN (#local.accountDoctorIds#) AND
								procedures.id IN (#local.procedureIds#) AND
								accountproductspurchased.dateEnd >= now() AND
								gallerycaseprocedures.galleryCaseId IS NOT NULL AND gallerycaseprocedures.isPrimary = 1 AND
								gallerycasedoctors.galleryCaseId IS NOT NULL AND
								accountdoctorlocations.id IS NOT NULL AND
								gallerycaseangles.id IS NOT NULL",
					order	= "gallerycases.id DESC, gallerycaseangles.orderNumber asc",
					group	= "gallerycases.id",
					$limit	= "4")>
			</cfif>

			<cfif latestPictures.recordCount EQ 0>
				<!--- If the advertiser has no BAAG photos, can we use PracticeRank to display some associated photos --->
				<cfset latestPictures		= model("GalleryCase").findAll(
					select	= "gallerycases.id AS galleryCaseId, procedures.name, procedures.siloName, gallerycasedoctors.accountDoctorId, gallerycaseangles.id AS galleryCaseAngleId, accountdoctors.firstName, accountdoctors.lastName, accountdoctors.middleName, accountdoctors.title",
					include	= "galleryCaseProcedures(procedure),galleryCaseDoctors(accountDoctor(accountDoctorLocations(AccountProductsPurchasedDoctorLocations(AccountProductsPurchased)))),galleryCaseAngles",
					where	= "	procedures.id IN (#local.procedureIds#) AND
								accountproductspurchased.dateEnd >= now() AND
								gallerycaseprocedures.galleryCaseId IS NOT NULL AND gallerycaseprocedures.isPrimary = 1 AND
								gallerycasedoctors.galleryCaseId IS NOT NULL AND
								accountdoctorlocations.id IS NOT NULL AND
								gallerycaseangles.id IS NOT NULL",
					order	= "accountproductspurchaseddoctorlocations.practiceRankScore DESC, gallerycases.id DESC, gallerycaseangles.orderNumber asc",
					group	= "accountdoctors.id",
					$limit	= "4")>
			</cfif>
		</cfif>


		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor">Ask A Doctor</a></span>')>
		<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor/questions">Questions</a></span>')>
		<cfset arrayAppend(breadcrumbs,"<span>#title#</span>")>

		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset renderPage(template="question_mobile", layout="/layout_mobile")>
		</cfif>

	</cffunction>

	<cffunction name="RelatedQuestions" hint="AJAX Call">
		<!--- carlos3.locateadoc.com/ask-a-doctor/related-questions?terms=abdominal%20liposuction%20&debug=0 --->
		<cfsetting showdebugoutput="false">

		<cfset var local = {}>
		<cfset local.returnLimit = 100>

		<cfparam default="" name="params.terms">

		<cfset qAskADoctorResults = model("SearchIndex").AskADoctor(	terms 		= params.terms,
																		limitCount	= local.returnLimit)>

		<cfset renderPage(layout=false)>
	</cffunction>

	<cffunction name="ProcedureQuestions" hint="AJAX call">
		<!--- 	carlos3.locateadoc.com/ask-a-doctor/procedure-questions?SPECIALTYORPROCEDUREID=procedure-16
				carlos3.locateadoc.com/ask-a-doctor/procedure-questions?SPECIALTYORPROCEDUREID=specialty-25
		 --->
		<cfsetting showdebugoutput="false">

		<cfset var local = {}>
		<cfset local.returnLimit = 100>
		<cfset local.specialtyId = 0>
		<cfset local.specialty = "">
		<cfset local.procedureId = 0>
		<cfset local.procedure = "">

		<cfparam default="" name="params.SPECIALTYORPROCEDUREID">


		<cfif ReFindNoCase("^(specialty-)[0-9]+", params.SPECIALTYORPROCEDUREID)>

			<cfif val(ListLast(params.SPECIALTYORPROCEDUREID, "-")) GT 0>
				<cfset local.specialtyId = val(ListLast(params.SPECIALTYORPROCEDUREID, "-"))>
				<cfset viewMore = model("Specialty").findOneById(
										value	= local.specialtyId,
										select	= "name, siloName")>
			</cfif>

		<cfelseif ReFindNoCase("^(procedure-)[0-9]+", params.SPECIALTYORPROCEDUREID)>

			<cfif val(ListLast(params.SPECIALTYORPROCEDUREID, "-")) GT 0>
				<cfset local.procedureId = val(ListLast(params.SPECIALTYORPROCEDUREID, "-"))>

				<cfset viewMore = model("Procedure").findOneById(
										value	= local.procedureId,
										select	= "name, siloName")>
			</cfif>
		<cfelse>
			Invalid parameter<cfabort>
		</cfif>

		<cfset qAskADoctorResults = model("AskADocQuestion").GetQuestions(
							procedure	= local.procedureId,
							specialty	= local.specialtyId,
							limit		= 5)>

		<cfset renderPage(layout=false)>
	</cffunction>

	<cffunction name="procedureSelect" hint="Javascript Include">
		<cfset Request.overrideDebug = "false">

		<!---
			http://carlos3.locateadoc.com/ask-a-doctor/procedureselect
		--->

		<cfset categories = model("AskADocQuestion").recentCategories(limit=10000)>


		<cfsavecontent variable="procedureSelections">
			BPprocedureArray = [];
			<cfoutput query="categories">
				<cfset nameString = formatForSelectBox(categories.procedureName)>
				<cfset nameString = deAccent(nameString)>
				BPprocedureArray.push({label:"#nameString#",value:"#nameString#",href:"/ask-a-doctor/questions/#categories.siloName#"});
			</cfoutput>
		</cfsavecontent>

		<cfcontent type="text/javascript; charset=utf-8">
		<cfset renderText(procedureSelections)>
	</cffunction>

	<cffunction name="Experts">
		<cfparam default="1" name="params.page">
		<cfparam default="1" name="params.key">

		<cfset var Local = {}>

		<cfif left(params.key, 5) EQ "page-">
			<cfset params.page = replaceNoCase(params.key, "page-", "")>

			<cfif NOT isnumeric(params.page) OR val(params.page) NEQ params.page OR params.key EQ "page-1">
				<cflocation addtoken="false" statuscode="301" url="/ask-a-doctor/experts">
			</cfif>
		</cfif>

		<cfset specialContent = model("SpecialContent").findOneById(
			select	= "title, header, content, metaDescription, metaKeywords",
			value	= "25"
		)>

		<cfset title = specialContent.title>
		<cfset metaDescriptionContent = specialContent.metaDescription>
		<cfset metaKeywordsContent = specialContent.metaKeywords>

		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor">Ask A Doctor</a></span>')>


		<!--- Init pagination variables --->
		<cfset search = {}>
		<cfset search.page = Max(val(params.page),1)>
		<cfset offset = (search.page-1)*10>
		<cfset limit = 10>


		<cfset Experts = model("AskADocQuestion").experts(offset=offset,limit=limit)>

		<!--- Get the number of records and pages from the full result set --->
		<cfquery datasource="#get('dataSourceName')#" name="count">
			Select Found_Rows() AS foundrows
		</cfquery>
		<cfset search.totalrecords = count.foundrows>
		<cfset search.pages = ceiling(search.totalrecords/limit)>

		<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10)>
		<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>

		<cfset recentCategories = model("AskADocQuestion").recentCategories(limit=10)>
		<cfset recentCategoriesTotal = model("AskADocQuestion").GetTotal().total>

		<cfset relNext = getNextPage(search.page,search.pages)>
		<cfset relPrev = getPrevPage(search.page)>

		<cfset styleSheetLinkTag(source	= "askadoctor/experts", head	= true)>


		<cfif search.page GT 1>
			<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor/experts">#title#</a> - Page #search.page#</span>')>
			<cfset title = title & " - Page " & search.page>
		<cfelse>
			<cfset arrayAppend(breadcrumbs,"<span>#title#</span>")>
		</cfif>

		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset renderPage(template="experts_mobile", layout="/layout_mobile")>
		</cfif>

	</cffunction>

	<cffunction name="Archive">
		<cfset var Local = {}>

		<cfparam default="" name="params.filter1">
		<cfparam default="" name="params.filter2">
		<cfparam default="" name="params.page">

		<cfset qQuestions = QueryNew("")>
		<cfset styleSheetLinkTag(source	= "askadoctor/archive", head	= true)>

		<cfif reFind("^[0-9]+$",params.filter1)>

			<cfif reFindNoCase("^page\-[0-9]+$", params.filter2)>
				<cfset params.page = listLast(params.filter2, "-")>
			</cfif>

			<!--- Init pagination variables --->
			<cfset limit = 12>
			<cfset search = {}>
			<cfset search.page = Max(val(params.page),1)>
			<cfset offset = (search.page-1)*limit>


			<cfset qQuestions = model("AskADocQuestion").GetArchiveQAs(
										procedureId	= params.filter1,
										offset		= offset,
										limit		= limit)>

			<cfif qQuestions.recordCount EQ 0>
				<cflocation addtoken="false" statuscode="301" url="/ask-a-doctor">
			</cfif>

			<cfquery datasource="myLocateadoc" name="qRecords">
				SELECT FOUND_ROWS() AS foundrows
			</cfquery>

			<cfset search.totalrecords = qRecords.foundrows>
			<cfset search.pages = ceiling(search.totalrecords/limit)>

			<cfquery datasource="myLocateadocLB3" name="qProcedure">
				SELECT name, siloName
				FROM procedures
				where id = #qQuestions.procedureId#
			</cfquery>

			<cfif qQuestions.procedureId EQ 43>
				<!--- Otoplasty --->
				<cfset qProcedure.name = "Ask A Doctor">
				<cfset doNotIndex = TRUE>
			</cfif>

			<cfset title = "#qProcedure.name# Questions and Answers Archive from Doctors and Patients">
			<cfset metaDescriptionContent = "Information on #qProcedure.name# Questions and Answers from patients asking doctors questions on abdomen problems and getting feedback from doctors. We have abdomen questions and answers for your health needs at LocateADoc.com.">
			<cfset metaKeywordsContent = "#qProcedure.name# Questions and Answers, #qProcedure.name# Information, LocateADoc">

			<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10)>
			<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>

			<cfset experts = model("AskADocQuestion").experts(offset=0,limit=12)>


			<!--- Breadcrumbs --->
			<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor">Ask A Doctor</a></span>')>
			<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor/archive">Archive</a></span>')>

			<cfif search.page GT 1>
					<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor/archive/#params.filter1#">#qProcedure.name#</a></span>')>
					<cfset title = title & " Archive - Page " & search.page>
			</cfif>
			<cfset arrayAppend(breadcrumbs,"<span>#title#</span>")>

		<cfelseif params.filter1 NEQ "">
			<cfif val(params.filter1) GT 0>
				<cflocation addtoken="false" statuscode="301" url="/ask-a-doctor/archive/#val(params.filter1)#">
			<cfelse>
				<cflocation addtoken="false" statuscode="301" url="/ask-a-doctor/categories">
			</cfif>

		</cfif>


		<cfif qQuestions.recordCount EQ 0>
			<cfset title = "Health Questions and Answers for Surgery, Medical, Health and Dental Procedures">
			<cfset metaDescriptionContent = "Health questions and answers for medical, dental and surgery procedures done by doctors and dentists.">
			<cfset metaKeywordsContent = "health questions health question answer answers doctor doctors">

			<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10)>
			<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>

			<cfset experts = model("AskADocQuestion").experts(offset=0,limit=12)>


			<!--- Breadcrumbs --->
			<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor">Ask A Doctor</a></span>')>
			<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor/archive">Archive</a></span>')>
			<cfset arrayAppend(breadcrumbs,"<span>#title#</span>")>
		</cfif>

		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset renderPage(template="archive_mobile", layout="/layout_mobile")>
		</cfif>

	</cffunction>

	<cffunction name="Categories">

		<cfset specialContent = model("SpecialContent").findOneById(
				select	= "title, metaKeywords, metaDescription, header, content",
				value	= "26"
			)>
		<cfset title = specialContent.title>
		<cfset header = specialContent.header>
		<cfset metaKeywordsContent = specialContent.metaKeywords>
		<cfset metaDescriptionContent = specialContent.metaDescription>
		<cfset content = specialContent.content>

		<cfset qCategories = model("AskADocQuestion").GetCategories()>

		<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10)>
		<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>

		<cfset experts = model("AskADocQuestion").experts(offset=0,limit=12)>

		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor">Ask A Doctor</a></span>')>

		<cfset sCategories = {}>
		<cfloop query="qCategories">
			<cfif NOT structKeyExists(sCategories, qCategories.procedureId)>
				<cfset sCategories[qCategories.procedureId] = {}>
				<cfset sCategories[qCategories.procedureId].questionList = questionIds>
				<cfset sCategories[qCategories.procedureId].questionCount = qCategories.questionCount>
			<cfelse>
				<cfset sCategories[qCategories.procedureId].questionCount += qCategories.questionCount>
				<cfset sCategories[qCategories.procedureId].questionList = ListAppend(sCategories[qCategories.procedureId].questionList, questionIds)>
			</cfif>
		</cfloop>

		<cfset styleSheetLinkTag(source	= "askadoctor/categories", head	= true)>
		<cfset javaScriptIncludeTag(source	= "askadoctor/categories", head	= true)>

		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset renderPage(template="categories_mobile", layout="/layout_mobile")>
		</cfif>

	</cffunction>

	<cffunction name="Category">
		<cfparam default="" name="params.key">

		<cfset qProcedures = model("AskADocQuestion").GetCategoryProcedures(specialtySiloName	= params.key)>

		<cfset header = "Ask A Doctor #qProcedures.specialtyName# Procedures">
		<cfset title = header>

		<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10)>
		<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>

		<cfset experts = model("AskADocQuestion").experts(offset=0,limit=12)>

		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor">Ask A Doctor</a></span>')>

		<cfset sCategories = {}>
		<cfloop query="qProcedures">
			<cfif NOT structKeyExists(sCategories, qProcedures.procedureId)>
				<cfset sCategories[qProcedures.procedureId] = {}>
				<cfset sCategories[qProcedures.procedureId].questionList = questionIds>
				<cfset sCategories[qProcedures.procedureId].questionCount = qProcedures.questionCount>
			<cfelse>
				<cfset sCategories[qProcedures.procedureId].questionCount += qProcedures.questionCount>
				<cfset sCategories[qProcedures.procedureId].questionList = ListAppend(sCategories[qProcedures.procedureId].questionList, questionIds)>
			</cfif>
		</cfloop>

		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,'<span><a href="/ask-a-doctor/categories">Categories</a></span>')>
		<cfset arrayAppend(breadcrumbs,'<span>Ask A Doctor #qProcedures.specialtyName# Procedures</span>')>


	</cffunction>

	<cffunction name="sponsoredlink" returntype="struct" access="private">
		<cfparam name="params.key" default="">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">

		<cfswitch expression="#params.action#">
			<cfcase value="specialty">
				<cfset sponsoredLink = getSponsoredLink(specialty="#val(params.key)#",
														paramsAction		= "#params.action#",
														paramsController	= "#params.controller#")>
			</cfcase>
			<cfcase value="procedure">
				<cfset sponsoredLink = getSponsoredLink(	procedure="#val(params.key)#",
															paramsAction		= "#params.action#",
															paramsController	= "#params.controller#")>
			</cfcase>
			<cfdefaultcase>
				<cfset sponsoredLink = getSponsoredLink(	paramsAction		= "#params.action#",
															paramsController	= "#params.controller#")>
			</cfdefaultcase>
		</cfswitch>
		<cfreturn sponsoredLink>
	</cffunction>

	<cffunction name="recordHit" access="private">
		<cfparam default="" name="params.action">
		<cfparam default="" name="params.specialty">
		<cfparam default="" name="params.procedure">
		<cfparam default="" name="params.key">
		<cfparam default="" name="params.page">
		<cfparam default="" name="AskADocQuestionId">

		<cfif not Client.IsSpider>
			<cfset model("HitsAskADoc").RecordHitDelayed(	action		= params.action,
															specialty	= params.specialty,
															procedure	= params.procedure,
															AskADocQuestionId	= AskADocQuestionId,
															page		= params.page)>


		</cfif>
	</cffunction>

</cfcomponent>