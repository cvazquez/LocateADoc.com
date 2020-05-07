<cfcomponent extends="Controller" output="false">

	<cfset breadcrumbs = []>
	<cfset arrayAppend(breadcrumbs,linkTo(href="/",text="Home"))>

	<cfset baseURL = "http://#Globals.domain#">
	<cfset galleryImageBase	= "#baseURL#/images/gallery/thumb">

	<cfset isMobile = FALSE>
	<cfset mobileSuffix = "">

 	<cffunction name="init">
		<cfset filters("initializeController")>
		<cfset usesLayout("checkPrint")>
	</cffunction>

	<cffunction name="checkPrint">
		<cfif structKeyExists(params, "print-view")>
			<cfreturn "/print">
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>

<!--- URL Structure functions --->

	<cffunction name="procedureRewrite">
		<cfargument name="params" default={}>
		<cfset variables.params = arguments.params>

		<cfset initializeController()>
		<cfset procedure()>
		<cfset Request.mobileLayout = true>
		<cfset recordResourceGuideProcedureHit(	procedureId	 = arguments.params.key)>
		<cfreturn variables>
	</cffunction>

	<cffunction name="specialtyRewrite">
		<cfargument name="params" default={}>
		<cfset variables.params = arguments.params>
		<cfset initializeController()>
		<cfset specialty()>
		<cfset Request.mobileLayout = true>
		<cfset recordResourceGuideSpecialtyHit(	specialtyId	 = arguments.params.key)>
		<cfreturn variables>
	</cffunction>

	<cffunction name="reviewsRewrite">
		<cfargument name="params" default={}>
		<cfset variables.params = arguments.params>
		<cfset params.procedureSilo = params.siloname>
		<cfset Request.overrideLayout = "procedure">
		<cfset initializeController()>
		<cfset reviews()>
		<cfset Request.mobileLayout = true>
		<cfreturn variables>
	</cffunction>

<!--- Actions --->

	<cffunction name="index">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">

		<cfset styleSheetLinkTag(	sources = "resources/index",
									head	= true)>

		<cfset specialContent = model("SpecialContent").findAll(
				select="title, header, content, metaDescription, metaKeywords, description",
				where="name = 'Resources Home Page'"
			)>

		<cfset title = specialContent.title>
		<cfset metaDescriptionContent = specialContent.metaDescription>
		<cfset metaKeywordsContent = specialContent.metaKeywords>
		<cfset breadcrumbs = []>

		<cfset latestArticlesAndBlogs = model("ResourceArticle").getLatestArticlesAndBlogs(
									limit	= 6)>

		<cfset latestGuides = model("ResourceGuide").searchGuides(
								limit		= 2,
								noSubGuides	= true,
								order		= "rg.updatedAt desc")>

		<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=10, paramsAction = params.action, paramsController = params.controller)>

		<cfset Blog = model("Blog").GetLatestPosts()>


		<!--- 	List ~8 resource guides based upon the most visits in the past 6 months with a
				View All link similar to what you did on the Ask A Doctor main page.
				This would link to a page that lists resource guides by specialty, same as we did for the Ask A Doctor.
		--->
		<cfset popularResourceGuides = model("resourceGuidePopularSummary").findAll(
							select	= "name, siloName",
							order	= "totals desc",
							maxRows	= 8)>

		<cfset bodyParts = model("BodyRegion").findAll(
			select  = "DISTINCT bodyregions.name AS bodyRegionName,bodyparts.name AS bodyPartName,
						procedures.name AS procedureName,procedures.id AS procedureId,procedures.siloName",
			include	= "bodyParts(procedureBodyParts(procedure(resourceGuideProcedures(resourceGuide))))",
			where = "procedures.isPrimary = 1 AND resourceguides.content is not null",
			order	= "bodyregions.name asc, bodyparts.name asc, procedures.name asc"
		)>

		<!--- <cfset videoCarousel = model("Video").getVideoSearch(limit=12)> --->

		<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10)>
		<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>

		<cfset trendingTopics = model("ResourceGuideTrendingTopicSummary").findAll(
			select="title,specialtyID,procedureID,specialties.name as specialtyname,procedures.name as procedurename,specialties.siloName as specialtySiloName,procedures.siloName as procedureSiloName",
			include="resourceGuide,specialty,procedure",
			where="resourceguides.content is not null",
			order="totals desc",
			maxRows="6"
		)>

		<!--- Add a Popular Infographics widget which features the most recent infographic first
			 followed by the most popular 4 or 6 Infographics. --->
		<cfset infoGraphics = model("InfoGraphicHitsSummary").findAll(
						select	= "title, header, siloname, carouselImage",
						order	= "hitCount desc",
						maxRows	= "5"
					)>

		<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,censored=true)>

		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<!--- Latest articles --->
			<cfset latestArticles = model("ResourceArticle").searchArticles(limit=2)>

			<cfset renderPage(template="/resources_mobile/index", layout="/layout_mobile")>
		</cfif>

	</cffunction>

	<cffunction name="article">
		<cfparam name="params.key" default="0">
		<cfparam name="params.preview" default="0">
		<cfparam name="params.rewrite" default="0">
		<cfparam name="params.articlesilo" default="">
		<cfparam name="params.articleid" default="">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">

		<cfset isInfoGraphic = FALSE>

		<cfset var Local = {}>

		<cfif params.rewrite>
			<!--- This lock is exclusive with the one in pDock to make sure we're not reading partially updated data --->
			<cflock name="articleSiloNameUpdate" type="exclusive" timeout="10">
				<!--- Get article id for current silo name --->
				<cfset Local.articleSilo = model("resourceArticleSiloName")
										.findAll(
											select="resourceArticleId, isActive",
											where="siloName = '#params.articlesilo#'"
											)>
				<cfif Local.articleSilo.recordCount>
					<cfif Local.articleSilo.isActive neq 1>
						<!--- Get active silo name for article id --->
						<cfset Local.articleSilo = model("resourceArticleSiloName")
											.findAll(
												select="siloName",
												where="resourceArticleId = '#Local.articleSilo.resourceArticleId#' AND isActive = 1"
												)>
						<cfif Local.articleSilo.recordCount>
							<!--- Redirect to current silo name --->
							<cflocation url="/article/#Local.articleSilo.siloName#" addtoken="no" statuscode="301">
						<cfelse>
							<!--- If there's no active silo name for guide id (this should never happen) --->
							<cflocation url="/articles" addtoken="no" statuscode="301">
						</cfif>
					</cfif>
				<cfelse>
					<!--- No article for silo name --->
					<cflocation url="/articles" addtoken="no" statuscode="301">
				</cfif>
			</cflock>
			<cfif not Server.isInteger(Local.articleSilo.resourceArticleId)>
				<cflocation url="/articles" addtoken="no" statuscode="301">
			</cfif>
			<cfset params.key = Local.articleSilo.resourceArticleId>
		</cfif>

		<cfset articleID = val(params.key)>
		<cfif articleID eq 0>
			<cfset dumpStruct = {local=local,params=params}>
			<cfset fnCthulhuException(	scriptName="Resources.cfc",
										message="Invalid article id (id: 0).",
										detail="Cause of Injury: Lack of Adhesive Ducks.",
										dumpStruct=dumpStruct,
										redirectURL="/resources/articles"
										)>
			<cfset redirectTo(action="articles")>
		</cfif>
		<cfset articleInfo = model("ResourceArticle").searchArticles(article=articleID,preview=(params.preview ? 1 : 0),limit=1)>
		<cfif articleInfo.recordcount eq 0>
			<cfset dumpStruct = {local=local,params=params,articleInfo=articleInfo}>
			<cfset fnCthulhuException(	scriptName="Resources.cfc",
										message="Can't find article (id: #articleID#).",
										detail="Cause of Injury: Lack of Adhesive Ducks.",
										dumpStruct=dumpStruct,
										redirectURL="/resources/articles"
										)>
			<cfset redirectTo(action="articles")>
		</cfif>

		<cfset articleSiloName = model("resourceArticleSiloName").findAll(
			select="siloName",
			where="resourceArticleId = #articleID# AND isActive = 1"
		).siloName>

		<cfif articleInfo.resourceArticleCategoryId EQ 3>
			<cflocation addtoken="false" url="/ask-a-doctor/question/#articleSiloName#" statuscode="301">
		</cfif>

		<cfset specialtyID = ListLen(articleInfo.specialtyIDs) ? ListFirst(articleInfo.specialtyIDs) : 0>
		<cfset procedureID = ListLen(articleInfo.procedureIDs) ? ListFirst(articleInfo.procedureIDs) : 0>

		<cfset metaDescriptionContent = articleInfo.metaDescription>
		<cfset metaKeywordsContent = articleInfo.metaKeywords>

		<cfif articleInfo.id eq 2936>
			<cfset articleInfo.header = "Infographic: Breast Self Exam and Breast Cancer Facts">
		<cfelseif articleInfo.id eq 2952>
			<cfset articleInfo.header = "Infographic: Plastic Fantastic - What We Pay To Go Under The Knife">
		<cfelseif articleInfo.id eq 3013>
			<cfset embedFaceTouchup = true>
		</cfif>
		<cfif trim(articleInfo.header) eq "">
			<cfset articleInfo.header = articleInfo.title>
		</cfif>

		<cfset title = "#articleInfo.header#">
		<cfset metaDescriptionContent = "#articleInfo.metaDescription#">
		<!--- Breadcrumbs --->
		<cfif Find("resources/articles",CGI.HTTP_REFERER)>
			<cfset arrayAppend(breadcrumbs,LinkTo(href=CGI.HTTP_REFERER,text="Articles"))>
		<cfelse>
			<cfset arrayAppend(breadcrumbs,LinkTo(action="articles",text="Articles"))>
		</cfif>
		<cfset arrayAppend(breadcrumbs,"<span>#articleInfo.title#</span>")>

		<!--- Blog roll --->
		<cfquery name="blogRoll" datasource="wordpressLB">
			SELECT p.ID, p.post_title, p.post_date as createdAt, p.siloName
			FROM lad_posts p
			WHERE p.post_date < now()
			AND p.post_type = 'post' AND p.post_status = 'publish'
			ORDER BY p.post_date desc
			LIMIT 5;
		</cfquery>

		<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=10,specialtyId=specialtyID,procedureId=procedureID, paramsAction = params.action, paramsController = params.controller)>
		<cfif procedureID gt 0>
			<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,censored=true,procedure=procedureID)>
		</cfif>
		<cfif procedureID eq 0 OR latestPictures.recordcount eq 0>
			<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,censored=true,specialty=specialtyID)>
		</cfif>
		<!--- <cfset latestPictures =	model("GalleryCase").findAll(
								include="galleryCaseProcedures(procedure),galleryCaseDoctors,galleryCaseAngles",
								maxRows="4",
								order="id DESC")> --->
		<cfif articleInfo.ogImage neq "">
			<cfset og_image = articleInfo.ogImage>
		<cfelse>
			<cfset Local.og_image_temp = fnGetFirstImage(articleInfo.content)>
			<cfif Local.og_image_temp neq "">
				<cfset og_image = Local.og_image_temp>
			</cfif>
			<!--- Exception for infograph article --->
			<cfif params.key eq 2936>
				<cfset og_image = "http://#CGI.HTTP_HOST#/images/resources/content/lad-pinterest.jpg">
			<cfelseif articleInfo.id eq 2952>
				<cfset og_image = "http://#CGI.HTTP_HOST#/images/resources/content/plastic-fantastic-facebook.jpg">
			</cfif>
		</cfif>

		<cfif not Client.IsSpider AND isnumeric(articleID)>
			<cfset model("HitsResourceArticle").RecordHitDelayed(articleID = articleID)>
		</cfif>

		<cfif ReFindNoCase("^Infographic:", articleInfo.header)>
			<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10)>
			<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>
			<cfset isInfoGraphic = TRUE>
		<cfelse>
			<!--- Latest articles --->
			<cfset latestArticles = model("ResourceArticle").searchArticles(limit=5)>
			<cfset trendingTopics = model("ResourceGuideTrendingTopicSummary").findAll(
					select="title,specialtyID,procedureID,specialties.name as specialtyname,procedures.name as procedurename,specialties.siloName as specialtySiloName,procedures.siloName as procedureSiloName",
					include="resourceGuide,specialty,procedure",
					where="resourceguides.content is not null",
					order="totals desc",
					$limit="6"
				)>
		</cfif>

		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset renderPage(template="/resources_mobile/article", layout="/layout_mobile")>
		</cfif>


	</cffunction>

	<cffunction name="articles">
		<cfparam name="params.specialty" default="0">
		<cfparam name="params.procedure" default="0">
		<cfparam name="params.tag" default="">
		<cfparam name="params.show" default="">
		<cfparam name="params.page" default="1">
		<cfparam name="params.rewrite" default="0">
		<cfparam name="params.siloname" default="">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">

		<cfset var Local = {}>

		<cfset title = "Articles">
		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,"<span>Articles</span>")>

		<cfset listTitle = "">


		<cfif isdefined("params.category_id")>
			<!---
				Handles a bad url I can't seem to catch in htaccess
				http://www.locateadoc.com/articles/'http://www.healthshop.com/healthfact/default.asp?category_id=117'
			 --->
			<cflocation addtoken="false" statuscode="301" url="/articles">
		</cfif>


		<!---Search the URL for filter params and reformat them for the search--->
		<cfloop collection="#params#" item="i">
			<cfif left(i,6) is "filter">
				<cfset Local.filtername = listFirst(params[i],"-")>
				<cfset Local.filtervalue = Replace(params[i],"#Local.filtername#-","")>
				<cfset params[Local.filtername] = Local.filtervalue>
			</cfif>
		</cfloop>

		<cfset title = "">
		<cfset metaDescriptionContent = "">



		<cfif trim(params.tag) neq "">
			<cfif Refind("\s+", urlDecode(params.tag))>
				<!--- http://carlos3.locateadoc.com/articles/tag-anti-wrinkle%20%20treatment
					http://carlos3.locateadoc.com/articles/tag-brazilian-butt  lift
				--->
				<cfset params.tag = reReplace(urlDecode(params.tag), "\s+", "-", "all")>
			</cfif>

			<cfset tagSpecialty = model("Specialty").findAll(select="siloName",where="name = '#params.tag#' OR siloName= '#params.tag#'")>
			<cfif tagSpecialty.recordcount>
				<cflocation url="/articles/#tagSpecialty.siloName#" addtoken="no" statuscode="301">
			</cfif>

			<cfset tagProcedure = model("Procedure").findAll(select="siloName",where="name = '#params.tag#' OR siloName= '#params.tag#'")>
			<cfif tagProcedure.recordcount>
				<cflocation url="/articles/#tagProcedure.siloName#" addtoken="no" statuscode="301">
			</cfif>

			<cfset listTitle = "#Humanize(trim(params.tag))# Articles">
			<cfset title = "#Humanize(trim(params.tag))# Articles and Information on LocateADoc.com">
			<cfset metaDescriptionContent = " ">
			<cfset doNotIndex = true>
		</cfif>

		<cfif Find("procedure-",params.siloname) gt 0>
			<cfset procedureID = val(Replace(params.siloname,"procedure-",""))>
			<cfset siloProcedure = model("Procedure").findAll(select="siloName",where="id = '#procedureID#'")>
			<cflocation url="/articles/#siloProcedure.siloName#" addtoken="no" statuscode="301">
		</cfif>

		<cfif Find("specialty-",params.siloname) gt 0>
			<cfset specialtyID = val(Replace(params.siloname,"specialty-",""))>
			<cfset siloSpecialty = model("Specialty").findAll(select="siloName",where="id = '#specialtyID#'")>
			<cflocation url="/articles/#siloSpecialty.siloName#" addtoken="no" statuscode="301">
		</cfif>

		<cfif params.rewrite>
			<cfset Local.specialtySilo = model("Specialty").findAllBySiloName(value=params.siloname,select="id,name")>
			<cfif Local.specialtySilo.recordCount>
				<cfset params.specialty = Local.specialtySilo.id>
				<cfset listTitle = "#Local.specialtySilo.name# Articles">
				<cfset title = "#Local.specialtySilo.name# Articles and Information on LocateADoc.com">
				<cfset metaDescriptionContent = "Read articles about #Local.specialtySilo.name# and research information, costs, trends and more on LocateADoc.com">
			</cfif>
			<cfset Local.procedureSilo = model("Procedure").findAllBySiloName(value=params.siloname,select="id,name")>
			<cfif Local.procedureSilo.recordCount>
				<cfset params.procedure = Local.procedureSilo.id>
				<cfset listTitle = "#Local.procedureSilo.name# Articles">
				<cfset title = "#Local.procedureSilo.name# Articles and Information on LocateADoc.com">
				<cfset metaDescriptionContent = "Read articles about #Local.procedureSilo.name# and research information, costs, trends and more on LocateADoc.com">
			</cfif>
		</cfif>

		<!--- filter the params --->
		<cfset params.specialty = val(params.specialty)>
		<cfset params.procedure = val(params.procedure)>
		<cfset params.tag = LCase(REReplace(params.tag,"[^a-zA-Z0-9& ]","","all"))>

		<cfif (params.specialty eq 0) and (params.procedure eq 0) and (params.tag eq "") and (params.show neq "all")>
			<!--- Redirect to article index if an unrecognized siloname is in the URL --->
			<cfif params.siloname neq "">
				<cflocation url="/articles" addtoken="no" statuscode="301">
			</cfif>
			<cfset title = "Articles & Advice on Cosmetic Surgery, Plastic Surgery, Cosmetic Dentistry, Dermatology, LASIK, Infertility and Hair Restoration">
			<cfset metaDescriptionContent = "Current health articles for cosmetic surgery, plastic surgery, cosmetic dentistry, dermatology, LASIK eye surgery, infertility and hair restoration.">

			<!--- If not params defined, show the articles home --->
			<cfset headerContent = model("SpecialContent").findAll(
				select="title, header, content",
				where="name = 'Articles'"
			)>
			<cfset latestArticles = model("ResourceArticle").searchArticles(limit=5)>
			<cfset specialtyArticles = model("Specialty").findAll(
				select="specialties.id, specialties.name, specialties.siloName",
				include="ResourceArticleSpecialties(ResourceArticle)",
				where="resourcearticles.content is not null AND resourceArticleCategoryId IN (1,3) AND categoryId = 1",
				order="name asc",
				group="specialties.id"
			)>
			<cfset popularProcedures = model("Procedure").findAll(
				select="DISTINCT procedures.id, procedures.name",
				include="procedureRankingSummary,resourceArticleProcedures(resourceArticle)",
				where="procedures.isPrimary = 1 AND resourcearticles.content is not null AND resourceArticleCategoryId IN (1,3)",
				order="profileLeadCount desc"
			)>
			<cfset trendingTopics = model("HitsResourceArticle").getPopularArticles()>
			<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=10, paramsAction = params.action, paramsController = params.controller)>
			<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,censored=true)>

			<!--- Render mobile page --->
			<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
				<cfset renderPage(template="/resources_mobile/articles", layout="/layout_mobile")>
			</cfif>

		<cfelse>

			<cfif title eq "">
				<cfset title = "Articles & Advice on Cosmetic Surgery, Plastic Surgery, Cosmetic Dentistry, Dermatology, LASIK, Infertility and Hair Restoration">
			</cfif>
			<cfif metaDescriptionContent eq "">
				<cfset metaDescriptionContent = "Current health articles for cosmetic surgery, plastic surgery, cosmetic dentistry, dermatology, LASIK eye surgery, infertility and hair restoration.">
			</cfif>
			<cfif params.show eq "all">
				<cfset listTitle = "LocateADoc.com Articles">
			</cfif>

			<!--- Init pagination variables --->
			<cfset search = {}>
			<cfset search.page = Max(val(params.page),1)>
			<cfset offset = (search.page-1)*10>
			<cfset limit = 10>

			<!--- Get the list of articles --->
			<cfset articleInfo = model("ResourceArticle").searchArticles(
				specialty = params.specialty,
				procedure = params.procedure,
				tag = params.tag,
				offset = offset,
				limit = limit
			)>

			<cfif articleInfo.recordcount eq 0>

				<cfif params.tag NEQ "">
					<!--- It's a bad tag, so just redirect to articles main page --->
					<cflocation addtoken="false" statuscode="301" url="/articles">
				</cfif>

				<cfset dumpStruct = {local=local,params=params,articleInfo=articleInfo}>
				<cfset fnCthulhuException(	scriptName="Resources.cfc",
											message="No article found (specialty: #params.specialty#, procedure: #params.procedure#, tag: #params.tag#, offset: #offset#, limit: #limit#).",
											detail="NIGERIAN PRINCE, Y U NO SEND ME MY MONEY?",
											dumpStruct=dumpStruct,
											redirectURL="/resources/articles"
											)>
				<cfset redirectTo(action="articles",statuscode="301")>
			</cfif>

			<!--- Get the number of records and pages from the full result set --->
			<cfquery datasource="#get('dataSourceName')#" name="count">
				Select Found_Rows() AS foundrows
			</cfquery>
			<cfset search.totalrecords = count.foundrows>
			<cfset search.pages = ceiling(search.totalrecords/limit)>

			<cfset blogRoll = model("blog").GetLatestPosts(	limit	= 5)>

			<!--- Latest articles --->
			<cfset latestArticles = model("ResourceArticle").searchArticles(limit=5)>

			<cfset trendingTopics = model("ResourceGuideTrendingTopicSummary").findAll(
				select="title,specialtyID,procedureID,specialties.name as specialtyname,procedures.name as procedurename,specialties.siloName as specialtySiloName,procedures.siloName as procedureSiloName",
				include="resourceGuide,specialty,procedure",
				where="resourceguides.content is not null",
				order="totals desc",
				$limit="6"
			)>
			<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=10,specialtyId=params.specialty,procedureId=params.procedure, paramsAction = params.action, paramsController = params.controller)>
			<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,censored=true,specialty=params.specialty,procedure=params.procedure)>
			<!--- <cfset latestPictures =	model("GalleryCase").findAll(
									include="galleryCaseProcedures(procedure),galleryCaseDoctors,galleryCaseAngles",
									maxRows="4",
									order="id DESC")> --->

			<cfset relNext = getNextPage(search.page,search.pages)>
			<cfset relPrev = getPrevPage(search.page)>

			<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
				<!--- Render mobile page --->
				<cfset renderPage(template="/resources_mobile/article", layout="/layout_mobile")>
			<cfelse>
				<cfset renderPage(action="article")>
			</cfif>

			<cfif val(params.specialty) GT 0 AND val(params.specialty) EQ params.specialty>
				<cfif not Client.IsSpider AND isnumeric(params.specialty)>
					<cfset model("HitsResourceArticleSpecialty").RecordHitDelayed(specialtyId = params.specialty, pageNum	= search.page)>
				</cfif>
			</cfif>

			<cfif val(params.procedure) GT 0 AND val(params.procedure) EQ params.procedure>
				<cfif not Client.IsSpider AND isnumeric(params.procedure)>
					<cfset model("HitsResourceArticleProcedure").RecordHitDelayed(procedureId = params.procedure, pageNum	= search.page)>
				</cfif>
			</cfif>
		</cfif>

	</cffunction>

	<cffunction name="blog">
		<cfparam name="params.rewrite" default="0">
		<cfparam name="params.blogyear" default="">
		<cfparam name="params.blogmonth" default="">
		<cfparam name="params.blogday" default="">
		<cfparam name="params.blogtitle" default="">
		<cfparam name="params.key" default="0">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">
		<cfparam name="params.preview" default="false">
		<cfset var Local = {}>

		<cfset Local.post_status = params.preview ? "future" : "publish">
		<cfif params.rewrite>
			<cfquery datasource="wordpressLB" name="blogSilo">
				SELECT p.ID, p.post_date, p.post_title
				FROM lad_posts p
				WHERE p.siloName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#params.blogtitle#">
				AND year(p.post_date) = <cfqueryparam cfsqltype="cf_sql_integer" value="#params.blogyear#">
				AND month(p.post_date) = <cfqueryparam cfsqltype="cf_sql_integer" value="#params.blogmonth#">
				AND day(p.post_date) = <cfqueryparam cfsqltype="cf_sql_integer" value="#params.blogday#">
				AND p.post_type = 'post' AND p.post_status = '#Local.post_status#'
				GROUP BY p.ID
			</cfquery>
			<cfif blogSilo.recordCount>
				<cfset params.key = blogSilo.id>
			<cfelse>
				<cfset dumpStruct = {blogSilo=blogSilo,params=params}>
				<cfset fnCthulhuException(	scriptName="Resources.cfc",
											message="Can't find blog post for /#params.blogyear#/#params.blogmonth#/#params.blogday#/#params.blogtitle#",
											detail="A little misunderstanding? Galileo and the Pope had a little misunderstanding...",
											dumpStruct=dumpStruct,
											redirectURL="/resources/blog-list"
											)>
				<cflocation url="/blog" addtoken="no" statuscode="301">
			</cfif>
		</cfif>

		<cfset blogID = val(params.key)>
		<cfif blogID eq 0>
			<cfset dumpStruct = {params=params}>
			<cfset fnCthulhuException(	scriptName="Resources.cfc",
										message="Invalid blog id (id: 0)",
										detail="Blog no worky",
										dumpStruct=dumpStruct,
										redirectURL="/resources/blog-list"
										)>
			<cfset redirectTo(action="blogList")>
		</cfif>

		<cfquery name="articleInfo" datasource="wordpressLB">
			SELECT p.ID, p.post_date as createdAt, p.post_content as content,
			p.post_title as title, u.display_name as author,
			(SELECT group_concat(DISTINCT t.name ORDER BY t.name)
				FROM lad_term_relationships tr
				JOIN lad_term_taxonomy tt on tr.term_taxonomy_id = tt.term_taxonomy_id
				JOIN lad_terms t on tt.term_id = t.term_id
				WHERE p.ID = tr.object_id <!--- AND taxonomy = 'post_tag' --->) as tags,
			lu.meta_value AS googlePlusId,
			a.meta_value AS authorShipHandle
			FROM lad_posts p
			JOIN lad_users u ON p.post_author = u.id
			LEFT OUTER JOIN lad_usermeta lu ON lu.user_id = u.id AND lu.meta_key = "googleplus"
			LEFT OUTER JOIN lad_postmeta dq ON p.ID = dq.post_id AND dq.meta_key = 'dsq_thread_id'
			LEFT OUTER JOIN lad_usermeta a ON a.user_id = u.id AND a.meta_key = 'authorship'
			WHERE p.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#blogID#">
			<cfif not params.preview>AND p.post_date < now()</cfif>
			AND p.post_type = 'post' AND p.post_status = '#Local.post_status#'
			GROUP BY p.ID
		</cfquery>

		<cfif articleInfo.recordcount eq 0>
				<cfset dumpStruct = {articleInfo=articleInfo,params=params}>
				<cfset fnCthulhuException(	scriptName="Resources.cfc",
											message="Can't find blog post (id: #blogId#)",
											detail="What type of computer do you have? And please don't say a white one.",
											dumpStruct=dumpStruct,
											redirectURL="/resources/blog-list"
											)>
			<cfset redirectTo(action="blogList")>
		</cfif>

		<cfset title = articleInfo.title>
		<!--- And here we whittle a meta description out of the top of the blog post --->
		<cfset filteredContent = articleInfo.content>
		<cfset filteredContent = REReplace(filteredContent,"\[caption.+?/caption\](\r|\n)*","","all")>
		<cfset filteredContent = REReplace(filteredContent,"<img.+?>","","all")>
		<cfset filteredContent = REReplace(filteredContent,"</?strong.+?>","","all")>
		<cfset filteredContent = REReplace(filteredContent,"<a[^>]+>\s*?</a>","","all")>
		<cfset filteredContent = REReplace(filteredContent,"<p[^>]+>\s*?</p>","","all")>
		<cfset filteredContent = trim(filteredContent)>
		<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
		<cfset filteredContent = REReplace(filteredContent,"^.{0,100}(\r|\n)","","all")>
		<cfset filteredContent = REReplace(filteredContent,"<h[0-9]>.+</h[0-9]>((\r|\n)+)?","","all")>
		<cfset filteredContent = REReplace(filteredContent,"<[^<]+?>","","all")>
		<cfif REFind("\r|\n",filteredContent)>
			<cfset filteredContent = Left(filteredContent,REFind("\r|\n",filteredContent))>
		</cfif>
		<cfset truncatePoint = 200>
		<cfif Len(filteredContent) gt truncatePoint>
			<cfset filteredContent = Left(filteredContent,(truncatePoint))&"...">
		</cfif>
		<!--- <cfset filteredContent = REReplace(filteredContent,'"',"'","all")> --->
		<cfset metaDescriptionContent = HTMLEditFormat(filteredContent)>

		<!--- Breadcrumbs --->
		<cfif Find("resources/blog-list",CGI.HTTP_REFERER)>
			<cfset arrayAppend(breadcrumbs,LinkTo(href=CGI.HTTP_REFERER,text="Blog"))>
		<cfelse>
			<cfset arrayAppend(breadcrumbs,LinkTo(action="blogList",text="Blog"))>
		</cfif>
		<cfset arrayAppend(breadcrumbs,"<span>#articleInfo.title#</span>")>

		<cfset Local.og_image_temp = fnGetFirstImage(articleInfo.content)>
		<cfif Local.og_image_temp neq "">
			<cfset og_image = Local.og_image_temp>
		</cfif>

		<!--- <cfquery name="comments" datasource="wordpressLB">
			SELECT c.*
			FROM lad_comments c
			WHERE c.comment_post_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#blogID#">
			AND c.comment_approved = 1
			AND comment_type != 'pingback'
			ORDER BY c.comment_date desc;
		</cfquery> --->

		<!--- Blog roll --->
		<cfquery name="blogRoll" datasource="wordpressLB">
			SELECT p.ID, p.post_title, p.post_date as createdAt, p.siloName
			FROM lad_posts p
			WHERE p.post_date < now()
			AND p.post_type = 'post' AND p.post_status = 'publish'
			ORDER BY p.post_date desc
			LIMIT 5;
		</cfquery>

		<!--- <cfset allTerms = ListAppend(articleInfo.tags,articleInfo.categories)> --->
		<cfset allTerms = articleInfo.tags>
		<cfif allTerms eq ""><cfset allTerms = "Uncategorized"></cfif>
		<cfquery name="furtherReading" datasource="wordpressLB">
			SELECT p.ID, p.post_title, p.post_date as createdAt, p.post_content as content,
			p.siloName
			FROM lad_posts p
			JOIN lad_term_relationships tr on p.ID = tr.object_id
			JOIN lad_term_taxonomy tt on tr.term_taxonomy_id = tt.term_taxonomy_id
			JOIN lad_terms t on tt.term_id = t.term_id
			WHERE p.post_date < now()
			AND p.post_type = 'post' AND p.post_status = 'publish'
			AND taxonomy = 'post_tag'
			AND p.ID != <cfqueryparam cfsqltype="cf_sql_integer" value="#blogID#">
			AND t.name IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#allTerms#" list="yes">)
			GROUP BY p.ID
			ORDER BY p.post_date DESC<!--- rand() --->
			LIMIT 3;
		</cfquery>
		<cfset dominantSpecialty = model("Specialty").findDominantSpecialty(allTerms,articleInfo.title,articleInfo.content)>
		<cfset specialtyID = dominantSpecialty.rank gt 1000 ? val(dominantSpecialty.ID) : 0>
		<cfquery name="uniqueSpecialties" dbtype="query">
			SELECT DISTINCT ID, name FROM dominantSpecialty WHERE rank > 0;
		</cfquery>
		<cfset dominantProcedure = model("Procedure").findDominantProcedure(allTerms,articleInfo.title,articleInfo.content,ValueList(uniqueSpecialties.ID),ValueList(uniqueSpecialties.name))>
		<cfset procedureID = dominantProcedure.rank gt 1000 AND (dominantProcedure.rank * 2) gt dominantSpecialty.rank ? val(dominantProcedure.ID) : 0>
		<cfif procedureID gt 0 AND specialtyID eq 0>
			<cfset specialtyID = model("SpecialtyProcedure").findAll(where="procedureID=#procedureID#").specialtyID>
		</cfif>

		<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=10,specialtyId=val(specialtyID),procedure=val(procedureID), paramsAction = params.action, paramsController = params.controller)>
		<cfif procedureID gt 0>
			<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,procedure=procedureID,censored=true)>
		</cfif>
		<cfif procedureID eq 0 or latestPictures.recordcount eq 0>
			<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,specialty=specialtyID,censored=true)>
		</cfif>
		<cfset latestArticles = model("ResourceArticle").searchArticles(limit=5)>
		<cfset specialtyInfo = model("Specialty").findByKey(	key		= specialtyID,
																select	= "name, siloName")>
		<cfset procedureInfo = model("Procedure").findByKey(	key		= procedureID,
																select	= "name, siloName")>

		<cfif articleInfo.googlePlusId NEQ "">
			<cfsavecontent variable="authorShip">
				<cfoutput>
				<link rel="author" href="https://plus.google.com/#articleInfo.googlePlusId#"/>
				</cfoutput>
			</cfsavecontent>

			<cfhtmlhead text="#authorShip#">
		</cfif>

		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset renderPage(template="/resources_mobile/blog", layout="/layout_mobile")>
		</cfif>

	</cffunction>

	<cffunction name="authorsList">
		<cfparam name="params.tag" default="0">
		<cfparam name="params.procedure" default="0">
		<cfparam name="params.page" default="1">
		<cfparam name="params.title" default="">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">
		<cfparam name="params.filter1" default="">


		<cfquery name="authorInfo" datasource="wordpressLB">
			SELECT lu.display_name, lu.id, bio.meta_value AS bio, googleplus.meta_value AS googlePlusId, a.meta_value AS authorShipHandle
			FROM lad_usermeta lum
			INNER JOIN lad_users lu ON lu.id = lum.user_id
			INNER JOIN lad_usermeta bio ON bio.user_id = lu.id AND bio.meta_key = "description"
			INNER JOIN lad_usermeta googleplus ON googleplus.user_id = lum.user_id AND googleplus.meta_key = "googleplus"
			INNER JOIN lad_usermeta a ON a.user_id = lum.user_id AND a.meta_key = 'authorship'
			WHERE lum.meta_key = "authorship"
					AND lum.meta_value =
				<cfif reFind("^page-", params.filter1)>
					""
				<cfelse>
					<cfqueryparam value="#params.filter1#" cfsqltype="cf_sql_varchar">
				</cfif>
		</cfquery>

		<cfif authorInfo.recordCount EQ 0>
			<cfheader statuscode="404" statustext="Not Found">
			<cfset doNotIndex = true>
			<cfset errormsg	= "Invalid Blog Author">
			<cfset errordesc= "We are unable to locate an author with the name #params.filter1#.">
			<cfset backLink = "/resources/blog-list">
			<cfset renderPage(template="/shared/error")>
			<cfexit>
		</cfif>


		<cfset title = "Blog Posts by #authorInfo.display_name#">
		<cfset metaDescriptionContent = "Read interesting stories by #authorInfo.display_name# on your favorite celebrity and review other observations in cosmetic surgery, plastic surgery, cosmetic dentistry, LASIK eye surgery, infertility and hair restoration.">

		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,"<span>// <a href='/resources/blog-list'>Blog</a> // #authorInfo.display_name# Blogs</span>")>
		<cfset tagName = "">

		<!---Search the URL for filter params and reformat them for the search--->
		<cfloop collection="#params#" item="i">
			<cfif left(i,6) is "filter">
				<cfquery name="termCheck" datasource="wordpressLB">
					SELECT term_id
					FROM lad_terms
					WHERE name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ReReplace(LCase(params[i]), "[^a-z0-9]+", " ", "all")#">;
				</cfquery>
				<cfif termCheck.recordcount>
					<cfset params.tag = termCheck.term_id>
					<cfset tagName = params[i]>
				<cfelse>
					<cfif Find("-",params[i])>
						<cfset Local.filtername = listFirst(params[i],"-")>
						<cfset Local.filtervalue = Replace(params[i],"#Local.filtername#-","")>
						<cfset params[Local.filtername] = Local.filtervalue>
					<cfelse>
						<cfset params.title =  Replace(Replace(params[i],"%","","all"),"_","-","all")>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>

		<!--- filter the params --->
		<cfset params.tag = val(params.tag)>
		<cfset params.procedure = val(params.procedure)>

		<!--- Init pagination variables --->
		<cfset search = {}>
		<cfset search.page = Max(val(params.page),1)>
		<cfset offset = (search.page-1)*10>
		<cfset limit = 10>

		<cfset procedureInfo = Model("Procedure").findAll(
			select="procedures.name as procedureName, specialties.name as specialtyName, procedures.siloName",
			include="SpecialtyProcedures(specialty)",
			where="procedures.id = #params.procedure#"
		)>

		<!--- Get the list of posts --->
		<cfquery name="articleInfo" datasource="wordpressLB">
			SELECT SQL_CALC_FOUND_ROWS p.ID, p.post_date as createdAt,
			p.post_content,	p.post_title as title,
			p.siloName
			FROM lad_posts p
			JOIN lad_term_relationships tr on p.ID = tr.object_id
			JOIN lad_term_taxonomy tt on tr.term_taxonomy_id = tt.term_taxonomy_id
			JOIN lad_terms t on tt.term_id = t.term_id
			WHERE p.post_author = <cfqueryparam value="#authorInfo.id#" cfsqltype="cf_sql_integer"> AND  p.post_type = 'post' AND p.post_status = 'publish'
			<cfif params.tag neq 0>
			AND t.term_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#params.tag#">
			</cfif>
			<cfif procedureInfo.procedureName neq "">
				AND (t.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#procedureInfo.procedureName#%">
				OR <cfqueryparam cfsqltype="cf_sql_varchar" value="#procedureInfo.procedureName#"> LIKE concat('%',t.name,'%'))
			</cfif>
			<cfif params.title neq "">
				AND p.post_title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#params.title#%">
			</cfif>
			AND p.post_date < now()
			GROUP BY p.ID
			ORDER BY p.post_date desc
			LIMIT #limit# OFFSET #offset#
		</cfquery>

		<!--- Get the number of records and pages from the full result set --->
		<cfquery name="count" datasource="wordpressLB">
			Select Found_Rows() AS foundrows
		</cfquery>
		<cfset search.totalrecords = count.foundrows>
		<cfset search.pages = ceiling(search.totalrecords/limit)>

		<!--- <cfdump var="#search#" abort="true" expand="true" metainfo="true"> --->

		<!--- Blog roll --->
		<cfquery name="blogRoll" datasource="wordpressLB">
			SELECT p.ID, p.post_title, p.post_date as createdAt, p.siloName
			FROM lad_posts p
			WHERE p.post_author = <cfqueryparam value="#authorInfo.id#" cfsqltype="cf_sql_integer"> AND p.post_date < now()
			AND p.post_type = 'post' AND p.post_status = 'publish'
			ORDER BY p.post_date desc
			LIMIT 5;
		</cfquery>

		<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=10, paramsAction = params.action, paramsController = params.controller)>
		<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,censored=true)>

		<cfif search.totalrecords gt 0>
			<cfset relNext = getNextPage(search.page,search.pages)>
			<cfset relPrev = getPrevPage(search.page)>
		<cfelseif params.page GT 1>
			<cfset doNotIndex = true>
		</cfif>

		<cfif authorInfo.googlePlusId NEQ "">
			<cfsavecontent variable="authorShip">
				<cfoutput>
				<link rel="author" href="https://plus.google.com/#authorInfo.googlePlusId#"/>
				</cfoutput>
			</cfsavecontent>

			<cfhtmlhead text="#authorShip#">

			<!--- <cfset og_image = "https://www.googleapis.com/plus/v1/people/#authorInfo.googlePlusId#?fields=image.url&key=AIzaSyAW0P6vhJbR2PWfJy9GhUcFBUmTbjN9toc&sz=100"> --->
			<cfset og_image = "https://www.google.com/s2/photos/profile/#authorInfo.googlePlusId#?sz=250">
		</cfif>

		<cfif authorInfo.authorShipHandle NEQ "">
			<cfset url.silourl = "/resources/authors-list/#authorInfo.authorShipHandle#">
		</cfif>

		<cfset ShareSummary = authorInfo.bio>

		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<!--- This only seems to work for nearest, oldest and/or page gt 1 --->
			<cfset Request.mobileLayout = true>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="blogList">
		<cfparam name="params.tag" default="0">
		<cfparam name="params.procedure" default="0">
		<cfparam name="params.specialty" default="0">
		<cfparam name="params.page" default="1">
		<cfparam name="params.title" default="">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">
		<cfparam name="params.filter1" default="">

		<cfset title = "Celebrity Cosmetic Surgery News and Latest Trends">
		<cfset metaDescriptionContent = "Read interesting stories on your favorite celebrity and review other observations in cosmetic surgery, plastic surgery, cosmetic dentistry, LASIK eye surgery, infertility and hair restoration.">
		<cfset description = "Welcome to the LocateADoc Blog, an exciting journal, designed to share more information with you about elective procedures and treatments. As an enhancement to LocateADoc.com - a premier physician directory for patients - we have gathered interesting celebrity news, stories and observations that fascinate us. We hope they fascinate you too.">

		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,"<span>Blog</span>")>
		<cfset tagName = "">

		<!---Search the URL for filter params and reformat them for the search--->
		<cfloop collection="#params#" item="i">
			<cfif left(i,6) is "filter">
				<cfquery name="termCheck" datasource="wordpressLB">
					SELECT term_id
					FROM lad_terms
					WHERE name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ReReplace(LCase(params[i]), "[^a-z0-9]+", " ", "all")#">;
				</cfquery>
				<cfif termCheck.recordcount>
					<cfset params.tag = termCheck.term_id>
					<cfset tagName = params[i]>
					<cfset doNotIndex = TRUE>

					<cfset title = title & " for " & ReReplace(LCase(params[i]), "[^a-z0-9]+", " ", "all")>
				<cfelse>
					<cfif Find("-",params[i])>
						<cfset Local.filtername = listFirst(params[i],"-")>
						<cfset Local.filtervalue = Replace(params[i],"#Local.filtername#-","")>
						<cfset params[Local.filtername] = Local.filtervalue>
					<cfelse>
						<cfset params.title =  Replace(Replace(params[i],"%","","all"),"_","-","all")>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>

		<!--- filter the params --->
		<cfset params.tag = val(params.tag)>
		<cfset params.procedure = val(params.procedure)>
		<cfset params.specialty = val(params.specialty)>

		<!--- <cfdump var="#params#"><cfabort> --->

		<!--- Init pagination variables --->
		<cfset search = {}>
		<cfset search.page = Max(val(params.page),1)>
		<cfset offset = (search.page-1)*10>
		<cfset limit = 10>

		<cfset procedureInfo = Model("Procedure").findAll(
			select="procedures.name as procedureName, specialties.name as specialtyName, procedures.siloName",
			include="SpecialtyProcedures(specialty)",
			where="procedures.id = #params.procedure#"
		)>

		<cfif procedureInfo.recordCount GT 0>
			<cfset title = title & " for " & procedureInfo.procedureName>
		</cfif>

		<!--- Get the list of posts --->
		<cfquery name="articleInfo" datasource="wordpressLB">
			SELECT SQL_CALC_FOUND_ROWS p.ID, p.post_date as createdAt,
			p.post_content,	p.post_title as title,
			p.siloName,
			<cfif params.specialty GT 0> s.name<cfelse> ""</cfif> AS specialtyName
			FROM lad_posts p
			JOIN lad_term_relationships tr on p.ID = tr.object_id
			JOIN lad_term_taxonomy tt on tr.term_taxonomy_id = tt.term_taxonomy_id

			<cfif params.specialty GT 0>
				INNER JOIN myLocateadoc3.specialties s ON s.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#params.specialty#"> AND s.deletedAt IS NULL
				JOIN lad_terms t on tt.term_id = t.term_id AND s.name LIKE concat('%',t.name,'%')
				<cfif params.tag neq 0>
					AND t.term_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#params.tag#">
				</cfif>
			<cfelseif procedureInfo.procedureName neq "">
				JOIN lad_terms t on tt.term_id = t.term_id
								AND (t.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#procedureInfo.procedureName#%">
								OR <cfqueryparam cfsqltype="cf_sql_varchar" value="#procedureInfo.procedureName#"> LIKE concat('%',t.name,'%'))
								<cfif params.tag neq 0>
									AND t.term_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#params.tag#">
								</cfif>
			<cfelseif params.tag neq 0>
				JOIN lad_terms t on tt.term_id = t.term_id
									AND t.term_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#params.tag#">
			</cfif>
			WHERE p.post_type = 'post' AND p.post_status = 'publish'
			<cfif params.title neq "">
				AND MATCH (post_title, post_content) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#params.title#">)
				<!--- AND p.post_title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#params.title#%"> --->
			</cfif>
			AND p.post_date < now()
			GROUP BY p.ID
			ORDER BY p.post_date desc
			LIMIT #limit# OFFSET #offset#
		</cfquery>

		<cfif params.specialty GT 0 AND procedureInfo.recordCount EQ 0>
			<cfset title = title & " for " & articleInfo.specialtyName>
		</cfif>

<!--- <cfdump var="#params#" abort="true"> --->
		<cfif articleInfo.recordCount EQ 0 AND params.specialty EQ 0 AND procedureInfo.recordCount EQ 0 AND params.tag EQ 0 AND params.filter1 NEQ "" AND NOT reFindNoCase("^page-[0-9]+", params.filter1)>
			<!--- Make sure the url doesn't have extra junk in it --->
			<!--- http://carlos3.locateadoc.com/resources/blog-list/omotola%20jalade-ekeinde/page-50 --->
			<!--- <cfdump var="#params#"><cfabort> --->

			<cfset redirectTo = "/resources/blog-list">

			<cfif params.page GT 1>
				<cfset redirectTo = redirectTo & "/page-" & params.page>
			</cfif>

			<cflocation addtoken="false" statuscode="301" url="#redirectTo#">
		</cfif>

		<!--- Get the number of records and pages from the full result set --->
		<cfquery name="count" datasource="wordpressLB">
			Select Found_Rows() AS foundrows
		</cfquery>
		<cfset search.totalrecords = count.foundrows>
		<cfset search.pages = ceiling(search.totalrecords/limit)>

		<!--- Blog roll --->
		<cfquery name="blogRoll" datasource="wordpressLB">
			SELECT p.ID, p.post_title, p.post_date as createdAt, p.siloName
			FROM lad_posts p
			WHERE p.post_date < now()
			AND p.post_type = 'post' AND p.post_status = 'publish'
			ORDER BY p.post_date desc
			LIMIT 5;
		</cfquery>

		<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=10, paramsAction = params.action, paramsController = params.controller)>
		<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,censored=true)>

		<cfif search.totalrecords gt 0>
			<cfset relNext = getNextPage(search.page,search.pages)>
			<cfset relPrev = getPrevPage(search.page)>
		<cfelse>
			<cfset doNotIndex = true>
		</cfif>


		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset renderPage(template="/resources_mobile/bloglist", layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="guide">
		<cfparam name="params.key" default="0">
		<cfparam name="params.preview" default="0">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">

		<cfset var Local = {}>

		<cfset articleID = val(params.key)>
		<cfif articleID eq 0>
			<cfset dumpStruct = {params=params}>
			<cfset fnCthulhuException(	scriptName="Resources.cfc",
										message="Invalid guide id (id: 0).",
										detail="A neutron walks into a bar and asks how much for a drink. The bartender replies 'for you, no charge.'",
										dumpStruct=dumpStruct,
										redirectURL="/resources/surgery"
										)>
			<cfset redirectTo(action="surgery")>
		</cfif>

		<cfset articleInfo = model("ResourceGuide").searchGuides(guide=articleID,preview=(params.preview ? 1 : 0),limit=1)>
		<cfif articleInfo.recordcount eq 0>
			<cfset dumpStruct = {articleInfo=articleInfo,params=params}>
			<cfset fnCthulhuException(	scriptName="Resources.cfc",
										message="No guide found (id: #articleID#).",
										detail="ACTORS, Y U NO SAY GOODBYE ON TELEPHONE?",
										dumpStruct=dumpStruct,
										redirectURL="/resources/surgery"
										)>
			<cfset redirectTo(action="surgery")>
		</cfif>
		<cfset procedureID = val(articleInfo.subprocedureID)>
		<cfset procedureInfo = model("Procedure").findByKey(procedureID)>

		<cfswitch expression="#articleInfo.name#">
			<cfcase value="Candidate,Ideal Candidate">
				<cfset title = "#procedureInfo.name# - Ideal Candidate">
				<cfset metaDescriptionContent = "Find out if you are an ideal candidate for the#procedureInfo.name# procedure.">
			</cfcase>
			<cfcase value="Techniques,Surgical Techniques">
				<cfset title = "#procedureInfo.name# - Surgical Techniques">
				<cfset metaDescriptionContent = "Find out about #procedureInfo.name# surgery and techniques.">
			</cfcase>
			<cfcase value="Recovery,Recovery Process and Time">
				<cfset title = "#procedureInfo.name# - Recovery Process and Time">
				<cfset metaDescriptionContent = "How long does it take to recover from the #procedureInfo.name# procedure?  Find out at LocateADoc.com.">
			</cfcase>
			<cfcase value="Cost,Cost and Pricing">
				<cfset title = "#procedureInfo.name# - Cost and Pricing">
				<cfset metaDescriptionContent = "Everything you need to know about the costs of the #procedureInfo.name# procedure.">
			</cfcase>
			<cfcase value="Financing,Financing Information">
				<cfset title = "#procedureInfo.name# - Financing Information">
				<cfset metaDescriptionContent = "How to get a loan for a #procedureInfo.name# procedure.">
			</cfcase>
			<cfcase value="FAQs,Frequently Asked Questions">
				<cfset title = "#procedureInfo.name# - Frequently Asked Questions">
				<cfset metaDescriptionContent = "Frequently asked questions about the #procedureInfo.name# procedure.">
			</cfcase>
			<cfdefaultcase>
				<cfset title = "#procedureInfo.name# - #articleInfo.name#">
			</cfdefaultcase>
		</cfswitch>
		<cfset metaDescriptionContent = "#articleInfo.metaDescription#">


		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,LinkTo(action="surgery",text="Surgery Guides"))>
		<cfset arrayAppend(breadcrumbs,LinkTo(controller=procedureInfo.siloName,text=procedureInfo.name))>
		<cfset arrayAppend(breadcrumbs,"<span>#articleInfo.title#</span>")>

		<cfif client.relatedSpecialty gt 0>
			<cfset specialtyInfo = model("Specialty").findByKey(client.relatedSpecialty)>
			<cfset relatedProcedures = model("Procedure").findAll(
				select="procedures.id, procedures.name, procedures.siloName",
				include="specialtyProcedureRankingSummary,resourceGuideProcedures(resourceGuide)",
				where="specialtyId = #client.relatedSpecialty# AND procedures.isPrimary = 1 AND procedures.id != #procedureID# AND resourceguides.content is not null",
				order="profileLeadCount desc"
			)>
		</cfif>

		<cfset subSections = model("ResourceGuideSubProcedure").findAll(
			select="resourceguides.id,resourceguides.name,resourceguidesilonames.siloName",
			include="resourceGuide(resourceGuideSiloNames)",
			where="procedureId = #procedureID# AND resourceguides.content is not null AND resourceguidesilonames.isActive = 1",
			order="orderNumber asc"
		)>

		<cfset topArticles = model("ResourceArticle").searchArticles(procedure=procedureID,limit=3)>
		<!--- <cfset topArticles = model("ResourceArticle").findAll(
			select="resourcearticles.id, resourcearticles.title, resourcearticles.content",
			include="resourceArticleProcedures,hitsResourceArticles",
			where="procedureId = #procedureID# AND resourceArticleCategoryId = 1",
			maxRows="3",
			group="resourcearticles.id",
			order="resourcearticles.createdAt DESC")> --->

		<cfset Blog = model("Blog").GetProcedureOrSpecialtyPosts(	procedureName	= procedureInfo.name,
																	limit			= 2)>

		<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=10,procedureId=procedureID, paramsAction = params.action, paramsController = params.controller)>

		<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,procedure=procedureID)>
		<!--- <cfset latestPictures =	model("GalleryCase").findAll(
								select="gallerycases.id as galleryCaseId,gallerycaseangles.id as galleryCaseAngleId,name,siloName,accountDoctorId",
								include="galleryCaseProcedures(procedure),galleryCaseDoctors,galleryCaseAngles",
								maxRows="4",
								where="procedureid = #procedureID#",
								order="id DESC")> --->

		<cfset bodyParts = model("BodyRegion").findAll(
			select  = "bodyregions.id AS bodyRegionId,bodyregions.name AS bodyRegionName,
					   bodyparts.id AS bodyPartId,bodyparts.name AS bodyPartName",
			include	= "bodyParts",
			order	= "bodyregions.name asc, bodyparts.name asc"
		)>

		<cfset commentCount = model("AccountDoctorLocationRecommendation").getCommentCount(procedureID)>

		<cfset quickSelect = getCities(addendum="procedure-#procedureID#",addendumSilo=procedureInfo.siloName)>
		<cfif procedureInfo.isExplicit><cfset explicitAd = TRUE></cfif>

		<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10, procedure=procedureID)>
		<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>

		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset renderPage(template="/resources_mobile/procedure", layout="/layout_mobile")>
		<cfelse>
			<cfset renderPage(action="procedure")>
		</cfif>

		<cfset recordResourceSubGuideHit(	resourceGuideId	= articleID,
											procedureId		= procedureID)>
	</cffunction>

	<cffunction name="surgery">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">

		<cfset title = "Procedure and Treatment Guides and Information">
		<cfset metaDescriptionContent = "LocateADoc.com's procedure and treatment guides help you learn about the latest procedures. Find the most qualified and experienced doctor in your area.">
		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,"Procedure and Treatment Resources")>

		<cfset headerContent = model("SpecialContent").findAll(
			select="title, header, content",
			where="name = 'Surgery Guides'"
		)>

		<cfset specialtyGuides = model("Specialty").findAll(
			select="DISTINCT specialties.id, specialties.name, specialties.siloName",
			include="ResourceGuideSpecialties(ResourceGuide)",
			where="resourceguides.content is not null",
			order="name asc"
		)>
		<!--- <cfset popularGuides = model("ResourceGuide").findAll(
			select="DISTINCT resourceguidespecialties.specialtyID, resourceguides.title, resourceguides.content, resourceguides.metaDescription, specialties.name as specialty, specialties.siloName as specialtySiloName",
			include="hitsResourceGuides,resourceGuideSpecialty(specialty)",
			where="resourceguides.content is not null AND resourceguidespecialties.specialtyID is not null",
			group="resourceguides.id",
			order="hitcount desc",
			maxRows="4"
		)> --->
		<cfset popularGuides = model("ResourceGuide").findAll(
			select="DISTINCT resourceguidespecialties.specialtyID, resourceguides.title, resourceguides.content, resourceguides.metaDescription, specialties.name as specialty, specialties.siloName as specialtySiloName",
			include="resourceGuideSpecialty(specialty)",
			where="specialties.id IN (25,32,46,31) AND resourceguides.content is not null AND resourceguidespecialties.specialtyID is not null",
			group="resourceguides.id",
			order="specialties.id=31,specialties.id=46,specialties.id=32,specialties.id=25",
			$limit="4"
		)>
		<cfset trendingTopics = model("ResourceGuideTrendingTopicSummary").findAll(
			select="title,specialtyID,procedureID,specialties.name as specialtyname,procedures.name as procedurename,specialties.siloName as specialtySiloName,procedures.siloName as procedureSiloName",
			include="resourceGuide,specialty,procedure",
			where="resourceguides.content is not null",
			order="totals desc",
			$limit="6"
		)>
		<cfset popularProcedures = model("Procedure").findAll(
			select="DISTINCT procedures.id, procedures.name, procedures.siloName",
			include="procedureRankingSummary,resourceGuideProcedures(resourceGuide)",
			where="procedures.isPrimary = 1 AND resourceguides.content is not null",
			order="profileLeadCount desc"
		)>

		<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=10, paramsAction = params.action, paramsController = params.controller)>
		<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,censored=true)>

		<cfset Blog = model("Blog").GetProcedureOrSpecialtyPosts(limit = 2)>


		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset params.silourl = "/resources/surgery">
			<cfset renderPage(template="/resources_mobile/surgery", layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="specialty">
		<cfparam name="params.key" default="0">
		<cfparam name="params.preview" default="0">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">

		<!--- http://carlos3.locateadoc.com/resources/specialty/25 to http://carlos3.locateadoc.com/cosmetic-surgery --->

		<cfset specialtyID = val(params.key)>
		<cfif specialtyID eq 0 or specialtyID gt 255>
			<cfset dumpStruct = {local=local,params=params}>
			<cfset fnCthulhuException(	scriptName="Resources.cfc",
										message="Invalid specialty id (id: #specialtyID#).",
										detail="So, just to clarify, when you say 3, do we stand up or do we pee?",
										dumpStruct=dumpStruct,
										redirectURL="/resources/surgery"
										)>
			<cfset redirectTo(action="surgery")>
		</cfif>

		<cfset specialtyInfo = model("Specialty").findByKey(specialtyID)>
		<cfif not IsObject(specialtyInfo)>
			<cfset dumpStruct = {local=local,params=params}>
			<cfset fnCthulhuException(	scriptName="Resources.cfc",
										message="Can't fin specialty (id: #specialtyID#).",
										detail="MISSION, Y U NO POSSIBLE?",
										dumpStruct=dumpStruct,
										redirectURL="/resources/surgery"
										)>
			<cfset redirectTo(action="surgery")>
		</cfif>

		<cfset title = "#specialtyInfo.name# Procedures - Costs, Doctors, Recovery">
		<cfset metaDescriptionContent = "Find information about #specialtyInfo.name#. Research cost, doctors, recovery and more on LocateADoc.com">
		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,LinkTo(action="surgery",text="Surgery Guides"))>
		<cfset arrayAppend(breadcrumbs,"<span>#specialtyInfo.name#</span>")>

		<cfif params.preview eq 0>
			<cfset basicInfo = model("ResourceGuide").findAll(
				select="content",
				include="resourceGuideSpecialty",
				where="specialtyID=#specialtyID#"
			)>
		<cfelse>
			<cfset basicInfo = model("ResourceGuide").findAll(
				select="resourceguidepreviews.content",
				include="resourceGuideSpecialty,resourceGuidePreview",
				where="specialtyID=#specialtyID# AND resourceguidepreviews.publishedAt IS NULL"
			)>
		</cfif>

		<!---
			select="resourcearticles.id, resourcearticles.title, resourcearticles.content, resourcearticlesilonames.siloName",
			select="resourcearticles.id, resourcearticles.title, left(resourcearticles.content, 512) AS content, resourcearticlesilonames.siloName",
			include="resourceArticleSpecialties,hitsResourceArticlesInner,resourceArticleSiloNames",
			order="hitcount DESC")>
		--->

		<!--- <cfset topArticles = model("ResourceArticle").findAll(
			select="resourcearticles.id, resourcearticles.title, left(resourcearticles.content, 2048) AS content, resourcearticlesilonames.siloName",
			include="resourceArticleSpecialties,hitsResourceArticlesInner,resourceArticleSiloNames",
			where="specialtyId = #specialtyID# AND resourceArticleCategoryId = 1",
			$limit="5",
			group="resourcearticles.id",
			order="hitcount DESC")> --->

		<cfset topArticles = model("ResourceArticleHitCounts").findAll(
			select="resourceArticleId AS id, title, content2048 AS content, siloName",
			where="specialtyId = #specialtyID#",
			$limit="5",
			order="resourceArticleHitCount DESC")>

		<cfset popularProcedures = model("Procedure").findAll(
			select="DISTINCT procedures.id, procedures.name, procedures.siloName",
			include="specialtyProcedureRankingSummary,resourceGuideProcedures(resourceGuide)",
			where="specialtyId = #specialtyID# AND procedures.isPrimary = 1 AND resourceguides.content is not null",
			order="profileLeadCount desc",
			$limit="10"
		)>
		<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=10,specialtyId=specialtyID, paramsAction = params.action, paramsController = params.controller)>
		<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,specialty=specialtyID,censored=true)>

		<cfset bodyParts = model("BodyRegion").findAll(
			select  = "DISTINCT bodyregions.name AS bodyRegionName,bodyparts.name AS bodyPartName,
						procedures.name AS procedureName,procedures.id AS procedureId,procedures.siloName",
			include	= "bodyParts(procedureBodyParts(procedure(specialtyprocedures,resourceGuideProcedures(resourceGuide))))",
			where = "specialtyprocedures.specialtyId = #specialtyID# AND procedures.isPrimary = 1 AND resourceguides.content is not null",
			order	= "bodyregions.name asc, bodyparts.name asc, procedures.name asc"
		)>

		<cfset Blog = model("Blog").GetProcedureOrSpecialtyPosts(	procedureName	= specialtyInfo.name,
																	limit			= 2)>

		<cfset Local.og_image_temp = fnGetFirstImage(basicInfo.content)>
		<cfif Local.og_image_temp neq "">
			<cfset og_image = Local.og_image_temp>
		</cfif>

		<cfset quickSelect = getCities(addendum="specialty-#specialtyID#",addendumSilo=specialtyInfo.siloName)>

		<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10, specialty=specialtyID)>
		<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>
	</cffunction>

	<cffunction name="procedure">
		<cfparam name="params.key" default="0">
		<cfparam name="params.preview" default="0">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">

		<cfset procedureID = val(params.key)>
		<cfif procedureID eq 0>
			<cfset dumpStruct = {local=local,params=params}>
			<cfset fnCthulhuException(	scriptName="Resources.cfc",
										message="Invalid procedure id (id: 0).",
										detail="Don't you think that if I were wrong, I'd know it?",
										dumpStruct=dumpStruct,
										redirectURL="/resources/surgery"
										)>
			<cfset redirectTo(action="index")>
		</cfif>
		<cfset procedureInfo = model("Procedure").findByKey(	select	= "name, siloName, isExplicit, avgFee, candidate, timeSpan, treatments, results, timeBackToWork",
																key=procedureID,
																returnAs="query")>
		<cfif procedureInfo.recordcount eq 0>
			<cfset dumpStruct = {local=local,params=params}>
			<cfset fnCthulhuException(	scriptName="Resources.cfc",
										message="Can't find procedure (id: #procedureID#).",
										detail="404, Y U NO FOUND?",
										dumpStruct=dumpStruct,
										redirectURL="/resources/surgery"
										)>
			<cfset redirectTo(action="surgery")>
		</cfif>

		<cfset procedureSiloName = procedureInfo.siloName>

		<cfset title = "#procedureInfo.name# Costs, Side Effects & Recovery">
		<cfset metaDescriptionContent = "Find information about the #procedureInfo.name# procedure. Research cost, doctors, recovery and more on LocateADoc.com">
		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,LinkTo(action="surgery",text="Surgery Guides"))>
		<cfset arrayAppend(breadcrumbs,"<span>#procedureInfo.name#</span>")>

		<cfif params.preview eq 0>
			<cfset basicInfo = model("ResourceGuide").findAll(
				select="content",
				include="resourceGuideProcedure",
				where="procedureID=#procedureID#"
			)>
		<cfelse>
			<cfset basicInfo = model("ResourceGuide").findAll(
				select="resourceguidepreviews.content",
				include="resourceGuideProcedure,resourceGuidePreview",
				where="procedureID=#procedureID# AND resourceguidepreviews.publishedAt IS NULL"
			)>
		</cfif>

		<cfif client.relatedSpecialty gt 0>
			<cfset specialtyInfo = model("Specialty").findByKey(client.relatedSpecialty)>
			<cfset relatedProcedures = model("Procedure").findAll(
				select="procedures.id, procedures.name, procedures.siloName",
				include="specialtyProcedureRankingSummary,resourceGuideProcedures(resourceGuide)",
				where="specialtyId = #client.relatedSpecialty# AND procedures.isPrimary = 1 AND procedures.id != #procedureID# AND resourceguides.content is not null",
				order="profileLeadCount desc"
			)>
		<cfelse>
			<cfset specialtyInfo = QueryNew("name,siloName")>
			<cfset relatedProcedures = QueryNew("")>
		</cfif>

		<cfset subSections = model("ResourceGuideSubProcedure").findAll(
			select="resourceguides.id,resourceguides.name,resourceguidesilonames.siloName",
			include="resourceGuide(resourceGuideSiloNames)",
			where="procedureId = #procedureID# AND resourceguides.content is not null AND resourceguidesilonames.isActive = 1",
			order="orderNumber asc"
		)>

		<cfset topArticles = model("ResourceArticle").searchArticles(procedure=procedureID,limit=3)>
		<!--- <cfset topArticles = model("ResourceArticle").findAll(
			select="resourcearticles.id, resourcearticles.title, resourcearticles.content",
			include="resourceArticleProcedures,hitsResourceArticles",
			where="procedureId = #procedureID# AND resourceArticleCategoryId = 1",
			maxRows="3",
			group="resourcearticles.id",
			order="resourcearticles.createdAt DESC")> --->

		<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=10,procedureId=procedureID, paramsAction = params.action, paramsController = params.controller)>
		<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,procedure=procedureID)>

		<cfset bodyParts = model("BodyRegion").findAll(
			select  = "bodyregions.id AS bodyRegionId,bodyregions.name AS bodyRegionName,
					   bodyparts.id AS bodyPartId,bodyparts.name AS bodyPartName",
			include	= "bodyParts",
			order	= "bodyregions.name asc, bodyparts.name asc"
		)>

		<cfset Blog = model("Blog").GetProcedureOrSpecialtyPosts(	specialtyName	= specialtyInfo.name,
																	procedureName	= procedureInfo.name,
																	limit			= 2)>

		<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10, procedure=procedureID)>
		<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>

		<cfset Local.og_image_temp = fnGetFirstImage(basicInfo.content)>
		<cfif Local.og_image_temp neq "">
			<cfset og_image = Local.og_image_temp>
		</cfif>

		<cfset commentCount = model("AccountDoctorLocationRecommendation").getCommentCount(procedureID)>

		<cfset quickSelect = getCities(addendum="procedure-#procedureID#",addendumSilo=procedureInfo.siloName)>
		<cfif procedureInfo.isExplicit><cfset explicitAd = TRUE></cfif>
	</cffunction>

	<cffunction name="reviews">
		<cfparam name="params.key" default="0">
		<cfparam name="params.preview" default="0">
		<cfparam name="params.page" default="1">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">
		<cfparam name="params.order" default="">
		<cfparam name="Request.overrideLayout" default="">


		<cfset params.page = val(params.page)>
		<cfset procedureID = val(params.key)>

		<cfif procedureID eq 0>
			<cfset dumpStruct = {local=local,params=params}>
			<cfset fnCthulhuException(	scriptName="Resources.cfc",
										message="mmmmmmmmmMMMMMMMMMMMMmmmm!!",
										detail="Invalid procedure id (id: 0).",
										dumpStruct=dumpStruct,
										redirectURL="/resources/surgery"
										)>
			<cfset redirectTo(action="index")>
		</cfif>
		<cfset procedureInfo = model("Procedure").findByKey(key=procedureID,returnAs="query")>
		<cfif procedureInfo.recordcount eq 0>
			<cfset dumpStruct = {local=local,params=params}>
			<cfset fnCthulhuException(	scriptName="Resources.cfc",
										message="I destroyed a universe! Wait, U is a vowel. I destroyed an universe? English is confusing.",
										detail="Can't find procedure (id: #procedureID#).",
										dumpStruct=dumpStruct,
										redirectURL="/resources/surgery"
										)>
			<cfset redirectTo(action="surgery")>
		</cfif>

		<cfset Blog = model("Blog").GetProcedureOrSpecialtyPosts(	procedureName	= procedureInfo.name,
																	limit			= 2)>

		<cfswitch expression="#params.order#">
			<cfcase value="">
				<cfset search = model("AccountDoctorLocationRecommendation").getComments(
					procedureID = procedureID,
					page		= params.page,
					perpage		= 10,
					descending  = true
				)>
			</cfcase>
			<cfcase value="oldest">
				<cfset doNotIndex = true>
				<cfset search = model("AccountDoctorLocationRecommendation").getComments(
					procedureID = procedureID,
					page		= params.page,
					perpage		= 10,
					descending  = false
				)>
			</cfcase>
			<cfcase value="nearest">
				<cfset doNotIndex = true>
				<cfset search = model("AccountDoctorLocationRecommendation").getComments(
					procedureID = procedureID,
					page		= params.page,
					perpage		= 10,
					descending  = true,
					byLocation	= true
				)>
			</cfcase>
			<cfdefaultcase>
				<cfset params.order = "">
				<cfset doNotIndex = true>
				<cfset search = model("AccountDoctorLocationRecommendation").getComments(
					procedureID = procedureID,
					page		= params.page,
					perpage		= 10,
					descending  = true
				)>
			</cfdefaultcase>
		</cfswitch>


		<cfset commentCount = search.totalrecords>

		<cfif commentCount eq 0>
			<cfset dumpStruct = {local=local,params=params}>
			<cfset fnCthulhuException(	scriptName="Resources.cfc",
										message="The tissue boxes on my feet failed to protect me from germs!",
										detail="Procedure has no reviews (id: #procedureID#).",
										dumpStruct=dumpStruct,
										redirectURL="/resources/surgery"
										)>
			<cfset redirectTo(action="surgery")>
		</cfif>

		<cfset title = "#procedureInfo.name# Doctor Reviews - LocateADoc.com">
		<cfset metaDescriptionContent = "Read and submit patient reviews for #procedureInfo.name# and find out all you need to know about the #procedureInfo.name# procedure.">
		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,LinkTo(action="surgery",text="Surgery Guides"))>
		<cfset arrayAppend(breadcrumbs,"<span>#procedureInfo.name#</span>")>

		<cfif client.relatedSpecialty gt 0>
			<cfset specialtyInfo = model("Specialty").findByKey(client.relatedSpecialty)>
			<cfset relatedProcedures = model("Procedure").findAll(
				select="procedures.id, procedures.name, procedures.siloName",
				include="specialtyProcedureRankingSummary,resourceGuideProcedures(resourceGuide)",
				where="specialtyId = #client.relatedSpecialty# AND procedures.isPrimary = 1 AND procedures.id != #procedureID# AND resourceguides.content is not null",
				order="profileLeadCount desc"
			)>
		<cfelse>
			<cfset specialtyInfo = QueryNew("")>
			<cfset relatedProcedures = QueryNew("")>
		</cfif>

		<cfset subSections = model("ResourceGuideSubProcedure").findAll(
			select="resourceguides.id,resourceguides.name,resourceguidesilonames.siloName",
			include="resourceGuide(resourceGuideSiloNames)",
			where="procedureId = #procedureID# AND resourceguides.content is not null AND resourceguidesilonames.isActive = 1",
			order="orderNumber asc"
		)>

		<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=10,procedureId=procedureID, paramsAction = params.action, paramsController = params.controller)>
		<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,procedure=procedureID)>

		<cfset bodyParts = model("BodyRegion").findAll(
			select  = "bodyregions.id AS bodyRegionId,bodyregions.name AS bodyRegionName,
					   bodyparts.id AS bodyPartId,bodyparts.name AS bodyPartName",
			include	= "bodyParts",
			order	= "bodyregions.name asc, bodyparts.name asc"
		)>

		<cfif procedureInfo.isExplicit><cfset explicitAd = TRUE></cfif>

		<cfset relNext = getNextPage(search.page,search.pages)>
		<cfset relPrev = getPrevPage(search.page)>

		<cfset latestQuestions = model("AskADocQuestion").GetQuestions(limit=10, procedure=procedureID)>
		<cfset latestQuestionsTotal = model("AskADocQuestion").GetTotal().total>

		<!--- <cfoutput><cfdump var="#params#" abort="true"></cfoutput> --->


		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile) AND (params.order NEQ "" OR (params.order EQ "" AND params.page GT 1))>
			<!--- This only seems to work for nearest, oldest and/or page gt 1 --->
			<cfset Request.mobileLayout = true>
			<cfset isMobile = true>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(layout="/layout_mobile", action="procedure")>
		<cfelseif Request.overrideLayout eq "">
			<cfset renderPage(action="procedure")>
		</cfif>
	</cffunction>

	<cffunction name="video">
		<cfparam name="params.key" default="">
		<cfparam name="params.page" default="1">
		<cfparam name="params.specialty" default="0">
		<cfparam name="params.rewrite" default="0">
		<cfparam name="params.specialtysilo" default="">
		<cfparam name="params.action" default="">
		<cfparam name="params.controller" default="">

		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,"<span>Videos</span>")>

		<!---Search the URL for filter params and reformat them for the search--->
		<cfloop collection="#params#" item="i">
			<cfif left(i,6) is "filter">
				<cfif Find("-",params[i])>
					<cfset Local.filtername = listFirst(params[i],"-")>
					<cfset Local.filtervalue = Replace(params[i],"#Local.filtername#-","")>
					<cfset params[Local.filtername] = Local.filtervalue>
				</cfif>
			</cfif>
		</cfloop>

		<cfif params.rewrite>
			<cfset Local.specialtySilo = model("Specialty").findAllBySiloName(value=params.specialtysilo,select="id")>
			<cfif Local.specialtySilo.recordCount>
				<cfset params.specialty = Local.specialtySilo.id>
			</cfif>
		</cfif>

		<cfset params.page = val(params.page)>
		<cfset params.specialty = val(params.specialty)>

		<cfset latestArticles = model("ResourceArticle").searchArticles(limit=5)>
		<cfset featuredListings = createObject("component","Doctors").featuredCarousel(limit=10, paramsAction = params.action, paramsController = params.controller)>
		<cfset latestPictures = model("GalleryCase").getPracticeRankedGallery(limit=4,censored=true)>
		<cfset videoSpecialties = model("Video").getVideoSpecialties()>
		<cfif params.specialty gt 0>
			<cfset SpecialtyInfo = model("Specialty").findByKey(params.specialty)>
			<cfset title = "Watch #SpecialtyInfo.name# Videos from Doctors on LocateADoc.com">
			<cfset metaDescriptionContent = "The latest #SpecialtyInfo.name# videos, doctors, procedure information and more on LocateADoc.com.">
		<cfelse>
			<cfset title = "See Doctor Videos and Procedure Information">
			<cfset metaDescriptionContent = "Videos from doctors on their practice information, specialization, procedure information and latest techniques on LocateADoc.com">
		</cfif>

		<cfif REFind("^page-[0-9]+$",params.key)><cfset params.page = Replace(params.key,"page-","")></cfif>
		<cfset search = {}>
		<cfset search.page = Max(val(params.page),1)>
		<cfset offset = (search.page-1)*10>
		<cfset limit = 10>

		<!--- Get the list of videos --->
		<cfset videoInfo = model("Video").getVideoSearch(
			specialty = params.specialty,
			offset = offset,
			limit = limit
		)>
		<!--- Get the number of records and pages from the full result set --->
		<cfquery datasource="#get('dataSourceName')#" name="count">
			Select Found_Rows() AS foundrows
		</cfquery>
		<cfset search.totalrecords = count.foundrows>
		<cfset search.pages = ceiling(search.totalrecords/limit)>

		<cfset relNext = getNextPage(search.page,search.pages)>
		<cfset relPrev = getPrevPage(search.page)>

		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = TRUE>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(layout="/layout_mobile")>
		</cfif>
	</cffunction>

	<cffunction name="compare">
		<cfparam name="params.key" default="0">
		<cfset specialtyID = val(params.key)>
		<cfset doNotIndex = true>

		<cfset title = "Compare Procedures">
		<cfset title = "Compare procedures by body part, specialty or cost">
		<cfset metaDescriptionContent = "Compare procedures by body part and compare pricing and other information.">
		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,"<span>Compare Procedures</span>")>

		<cfif specialtyID gt 0>
			<cfset comparison = getComparison(specialty=specialtyID)>
			<cfset includeList = "bodyParts(procedureBodyParts(procedure(specialtyProcedures,resourceGuideProcedures(resourceGuide))))">
			<cfset whereCondition = "specialtyprocedures.specialtyId = #specialtyID# AND procedures.isPrimary = 1 AND resourceguides.content is not null">
		<cfelse>
			<cfset comparison = getComparison()>
			<cfset includeList = "bodyParts(procedureBodyParts(procedure))">
			<cfset whereCondition = "procedures.isPrimary = 1">
		</cfif>

		<!--- Gather info for populating body region and part selection boxes --->
		<cfset bodyRegions = model("BodyRegion").findAll(
			select  = "DISTINCT bodyregions.id, bodyregions.name",
			include = includeList,
			where = whereCondition,
			order	= "name asc"
		)>
		<cfset bodyParts = model("BodyRegion").findAll(
			select  = "DISTINCT bodyparts.id, bodyparts.name, bodyregions.id AS bodyRegionID",
			include = includeList,
			where = whereCondition,
			order	= "bodyparts.name asc"
		)>

		<cfset popularProcedures = model("Procedure").findAll(
			select="DISTINCT procedures.id, procedures.name, procedures.siloName",
			include="specialtyProcedureRankingSummary,resourceGuideProcedures(resourceGuide)",
			where= Replace(whereCondition,"specialtyprocedures.","","all"),
			order="profileLeadCount desc",
			$limit="10"
		)>

		<cfset doNotIndex = true>
	</cffunction>

	<cffunction name="procedureList">
		<cfparam name="params.key" default="0">
		<cfset specialtyID = val(params.key)>

		<cfset title = "Procedures">
		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,"<span>Procedures</span>")>

		<cfset specialtyInfo = model("Specialty").findByKey(specialtyID)>

		<cfif specialtyID gt 0>
			<cfset comparison = getComparison(specialty=specialtyID,showCompareBits=false)>
			<cfset includeList = "bodyParts(procedureBodyParts(procedure(specialtyProcedures)))">
			<cfset whereCondition = "specialtyprocedures.specialtyId = #specialtyID# AND procedures.isPrimary = 1">
		<cfelse>
			<cfset comparison = getComparison(showCompareBits=false)>
			<cfset includeList = "bodyParts(procedureBodyParts(procedure))">
			<cfset whereCondition = "procedures.isPrimary = 1">
		</cfif>
		<!--- Gather info for populating body region and part selection boxes --->
		<cfset bodyRegions = model("BodyRegion").findAll(
			select  = "DISTINCT bodyregions.id, bodyregions.name",
			include = includeList,
			where = whereCondition,
			order	= "name asc"
		)>
		<cfset bodyParts = model("BodyRegion").findAll(
			select  = "DISTINCT bodyparts.id, bodyparts.name, bodyregions.id AS bodyRegionID",
			include	= includeList,
			where = whereCondition,
			order	= "bodyparts.name asc"
		)>

		<cfset popularProcedures = model("Procedure").findAll(
			select="DISTINCT procedures.id, procedures.name, procedures.siloName",
			include="specialtyProcedureRankingSummary,resourceGuideProcedures(resourceGuide)",
			where=Replace(whereCondition,"specialtyprocedures.","","all") & " AND resourceguides.content is not null",
			order="profileLeadCount desc",
			$limit="10"
		)>

		<cfset doNotIndex = true>

		<!--- Render mobile page --->
		<cfif not Client.desktop and (Request.isMobileBrowser or Client.forcemobile)>
			<cfset isMobile = TRUE>
			<cfset mobileSuffix = "_mobile">
			<cfset renderPage(layout="/layout_mobile", action="compare")>
		<cfelse>
			<cfset renderPage(action="compare")>
		</cfif>


	</cffunction>

	<cffunction name="procedureSelect" hint="Javascript Include">
		<cfset Request.overrideDebug = "false">

		<cfset bodyParts = model("BodyRegion").findAll(
				select  = "DISTINCT bodyregions.name AS bodyRegionName,bodyparts.name AS bodyPartName,
							procedures.name AS procedureName,procedures.id AS procedureId,procedures.siloName",
				include	= "bodyParts(procedureBodyParts(procedure(resourceGuideProcedures(resourceGuide))))",
				where = "procedures.isPrimary = 1 AND resourceguides.content is not null",
				order	= "bodyregions.name asc, bodyparts.name asc, procedures.name asc",
				group	= "procedures.id"
		)>

		<cfsavecontent variable="procedureSelections">
			BPprocedureArray = [];
			<cfoutput query="bodyParts">
				<cfset nameString = formatForSelectBox(bodyParts.procedureName)>
				<cfset nameString = deAccent(nameString)>
				BPprocedureArray.push({label:"#nameString#",value:"#nameString#",href:"/#bodyParts.siloName#"});
			</cfoutput>
		</cfsavecontent>

		<cfcontent type="text/javascript; charset=utf-8">
		<cfset renderText(procedureSelections)>
	</cffunction>

	<cffunction name="changeCompare">
		<cfsetting showdebugoutput="false">
		<cfset provides("html,json")>
		<cfparam name="params.bodyRegion" default="0">
		<cfparam name="params.bodyPart" default="0">
		<cfparam name="params.specialty" default="0">
		<cfparam name="params.listOnly" default="0">

		<cfset results = {}>
		<cfif params.listOnly eq 0>
			<cfset results["content"] = getComparison(bodyRegion=params.bodyRegion,bodyPart=params.bodyPart,specialty=params.specialty)>
		<cfelse>
			<cfset results["content"] = getComparison(bodyRegion=params.bodyRegion,bodyPart=params.bodyPart,specialty=params.specialty,showCompareBits=false)>
		</cfif>
		<cfset renderWith(results)>
	</cffunction>

	<cffunction name="guides">
		<cfset specialContent = model("SpecialContent").findOneById(
				select	= "title, metaKeywords, metaDescription, header, content",
				value	= "27"
			)>
		<cfset title = specialContent.title>
		<cfset header = specialContent.header>
		<cfset metaKeywordsContent = specialContent.metaKeywords>
		<cfset metaDescriptionContent = specialContent.metaDescription>
		<cfset content = specialContent.content>

		<cfset qGuides = model("ResourceGuide").GetGuides()>

		<!--- Breadcrumbs --->
		<cfset arrayAppend(breadcrumbs,'<span>#title#</span>')>

		<cfset sGuides = {}>
		<cfloop query="qGuides">
			<cfif NOT structKeyExists(sGuides, qGuides.procedureId)>
				<cfset sGuides[qGuides.procedureId] = {}>
				<cfset sGuides[qGuides.procedureId].resourceGuideList = qGuides.resourceGuideIds>
				<cfset sGuides[qGuides.procedureId].resourceGuideCount = qGuides.resourceGuideCount>
			<cfelse>
				<cfset sGuides[qGuides.procedureId].resourceGuideCount += qGuides.resourceGuideCount>
				<cfset sGuides[qGuides.procedureId].resourceGuideList = ListAppend(sGuides[qGuides.procedureId].resourceGuideList, qGuides.resourceGuideIds)>
			</cfif>
		</cfloop>

		<cfset styleSheetLinkTag(source	= "askadoctor/categories", head	= true)>
		<cfset javaScriptIncludeTag(source	= "askadoctor/categories", head	= true)>

		<cfset popularResourceGuides = model("resourceGuidePopularSummary").findAll(
							select	= "name, siloName",
							order	= "totals desc",
							maxRows	= 8)>

		<cfset infoGraphics = model("InfoGraphicHitsSummary").findAll(
						select	= "title, header, siloname, carouselImage",
						order	= "hitCount desc",
						maxRows	= "5"
					)>
	</cffunction>

<!--- Private Methods --->

	<cffunction name="initializeController" access="private">
		<cfparam name="params.key" default="0">
		<cfparam name="client.relatedSpecialty" default="0">
		<cfparam name="params.rewrite" default="0">
		<cfparam name="params.rewrite" default="0">
		<cfparam name="params.procedureSilo" default="">
		<cfparam name="params.subPageSilo" default="">

		<cfset explicitAd = FALSE>

		<cfif params.rewrite and (params.action eq "guide" or params.action eq "reviews")>

			<cfset Local.procedure = model("procedure").findAllBySiloName(value=params.procedureSilo, select="id")>
			<cfif Local.procedure.recordCount>
				<cfset params.key=Local.procedure.id>
			<cfelse>
				<!--- Check for malformed URLs like /specialty/location --->
				<cfset Local.specialty = model("specialty").findAllBySiloName(value=params.procedureSilo, select="id")>
				<cfif Local.specialty.recordCount>
					<cflocation url="/doctors#params.silourl#" addtoken="no" statuscode="301">
				</cfif>
				<cfset dumpStruct = {procedure=Local.procedure,local=local,params=params}>
				<cfset fnCthulhuException(	scriptName="Resources.cfc",
											message="Can't find procedure for silo name (#params.procedureSilo#).",
											detail="WEBPAGE, Y U NO WORK?",
											dumpStruct=dumpStruct,
											redirectURL="/resources/surgery"
											)>
				<cfset redirectTo(controller="resources", statusCode="301")>
			</cfif>
			<cfif params.action eq "guide">
				<!--- This lock is exclusive with the one in pDock to make sure we're not reading partially updated data --->
				<cflock name="guideSiloNameUpdate" type="exclusive" timeout="10">
					<cfset Local.guide = model("resourceGuideSiloName")
											.findAll(
												select="resourceguidesubprocedures.resourceGuideId, resourceguidesilonames.isActive",
												where="siloName = '#params.subPageSilo#' AND procedureId = #Local.procedure.id#",
												include="resourceGuide(resourceGuideSubProcedure)"
												)>



					<cfif Local.guide.recordCount>
						<cfif Local.guide.isActive neq 1>
							<!--- Get active silo name for guide id --->
							<cfset Local.guide = model("resourceGuideSiloName")
												.findAll(
													select="siloName",
													where="resourceGuideId = '#Local.guide.resourceGuideId#' AND procedureId = #Local.procedure.id# AND isActive = 1",
													include="resourceGuide(resourceGuideSubProcedure)"
													)>
							<cfif Local.guide.recordCount>
								<cflocation url="/#params.procedureSilo#/#Local.guide.siloName#" addtoken="no" statuscode="301">
							<cfelse>
								<!--- If there's no active silo name for guide id (this should never happen) --->
								<cflocation url="/#params.procedureSilo#" addtoken="no" statuscode="301">
							</cfif>
						</cfif>
					<cfelse>

						<!--- Detect urls like
							http://carlos3.locateadoc.com/invisalign/west-virginia
							http://carlos3.locateadoc.com/invisalign/florida
							http://carlos3.locateadoc.com/skin-injection-treatments/stuart-fl
							http://carlos3.locateadoc.com/skin-injection-treatments/stuart
						--->

						<!--- First check if the entire params.subPageSilo is a state --->
						<cfset newSubPageSilo = replace(params.subPageSilo, "-", "", "all")>
						<cfset stateCheck = model("state").findOne(	select	= "CreateSiloNameWithDash(name) AS stateName",
																	where	= "siloName = '#newSubPageSilo#'",
																	returnAs	= "query" )>

						<cfif stateCheck.recordCount GT 0>
							<!--- Found State, so redirect to doctor state search for this procedure. http://carlos3.locateadoc.com/invisalign/west-virginia --->
							<cflocation url="/doctors/#params.procedureSilo#/#stateCheck.stateName#" addtoken="no" statuscode="301">
						</cfif>


						<!--- Searching for a city state combination --->
						<cfset subPageSiloLength = listLen(params.subPageSilo, "-")>
						<cfset city = "">
						<cfloop index="cityX" from="1" to="#subPageSiloLength-1#">
							<cfset city = listAppend(city, listGetAt(params.subPageSilo, cityX, "-"), "-")>
						</cfloop>

						<cfset cityCheck = model("city").findOne(	where	= "siloNameNew = '#city#'" )>

						<cfset state = listLast(params.subPageSilo, "-")>
						<cfset stateCheck = model("state").findOne(	where	= "abbreviation = '#state#'" )>

						<cfif isObject(cityCheck) AND isObject(stateCheck)>
							<cflocation url="/doctors/#params.procedureSilo#/#cityCheck.siloNameNew#-#lcase(stateCheck.abbreviation)#" addtoken="no" statuscode="301">
						<cfelseif isObject(cityCheck)>
							<cflocation url="/doctors/#params.procedureSilo#/#cityCheck.siloNameNew#" addtoken="no" statuscode="301">
						</cfif>


						<!--- Check if the entire params.subPageSilo is a city. http://carlos3.locateadoc.com/skin-injection-treatments/stuart --->
						<cfset cityCheck = model("city").findOne(	where	= "siloNameNew = '#params.subPageSilo#'" )>
						<cfif isObject(cityCheck)>
							<cflocation url="/doctors/#params.procedureSilo#/location-#cityCheck.siloNameNew#" addtoken="no" statuscode="301">
						</cfif>


						<!--- If no city or state found then redirect to procedures main page --->
						<cflocation url="/#params.procedureSilo#" addtoken="no" statuscode="301">

					</cfif>
				</cflock>
				<cfif not Server.isInteger(Local.guide.resourceGuideId)>
					<cflocation url="/#params.procedureSilo#" addtoken="no" statuscode="301">
				</cfif>
				<cfset params.key = Local.guide.resourceGuideId>
			</cfif>
		</cfif>


		<cfif params.action eq "index">
			<cfset arrayAppend(breadcrumbs,"<span>Resources</span>")>
		<cfelse>
			<cfset arrayAppend(breadcrumbs,linkTo(controller="resources",action="index",text="Resources"))>
		</cfif>
		<!--- Manage a client variable used to determine the specialty for a procedure --->
		<cfif params.action eq "specialty" or params.action eq "procedureList">
			<cfset client.relatedSpecialty = val(params.key)>
		<cfelseif params.action eq "procedure" or params.action eq "reviews">
			<!--- Check if the client variable is a valid specialty id for this procedure --->
			<cfif client.relatedSpecialty neq 0>
				<cfset specialtyCheck = model("SpecialtyProcedure").findAll(
					where="specialtyId = #val(client.relatedSpecialty)# AND procedureId = #val(params.key)#"
				)>
				<cfif specialtyCheck.recordcount eq 0>
					<cfset client.relatedSpecialty = 0>
				</cfif>
			</cfif>
			<!--- If the client variable is invalid, find a valid specialty for this procedure --->
			<cfif client.relatedSpecialty eq 0>
				<cfset specialtyCheck = model("SpecialtyProcedure").findAll(
					select="specialtyId",
					where="procedureId = #val(params.key)#",
					$limit="1"
				)>
				<cfif specialtyCheck.recordcount eq 1>
					<cfset client.relatedSpecialty = specialtyCheck.specialtyId>
				</cfif>
			</cfif>
		<cfelseif params.action eq "guide">
			<!--- Check if the client variable is a valid specialty id for this guide --->
			<cfif client.relatedSpecialty neq 0>
				<cfset specialtyCheckA = model("ResourceGuideSpecialty").findAll(
					where="resourceGuideId = #val(params.key)# AND specialtyId = #client.relatedSpecialty#"
				)>
				<cfset specialtyCheckB = model("ResourceGuideProcedure").findAll(
					include="procedure(specialtyProcedures)",
					where="resourceGuideId = #val(params.key)# AND specialtyId = #client.relatedSpecialty#"
				)>
				<cfset specialtyCheckC = model("ResourceGuideSubProcedure").findAll(
					include="procedure(specialtyProcedures)",
					where="resourceGuideId = #val(params.key)# AND specialtyId = #client.relatedSpecialty#"
				)>
				<cfif (specialtyCheckA.recordcount eq 0) AND (specialtyCheckB.recordcount eq 0) AND (specialtyCheckC.recordcount eq 0)>
					<cfset client.relatedSpecialty = 0>
				</cfif>
			</cfif>
			<!--- If the client variable is invalid, find a valid specialty for this guide --->
			<cfif client.relatedSpecialty eq 0>
				<cfset specialtyCheck = model("ResourceGuideSpecialty").findAll(
					select="specialtyId",
					where="resourceGuideId = #val(params.key)#",
					$limit="1"
				)>
				<cfif specialtyCheck.recordcount eq 1>
					<cfset client.relatedSpecialty = specialtyCheck.specialtyId>
				<cfelse>
					<cfset specialtyCheck = model("ResourceGuideProcedure").findAll(
						select="specialtyId",
						include="procedure(specialtyProcedures)",
						where="resourceGuideId = #val(params.key)#",
						$limit="1"
					)>
					<cfif specialtyCheck.recordcount eq 1>
						<cfset client.relatedSpecialty = specialtyCheck.specialtyId>
					<cfelse>
						<cfset specialtyCheck = model("ResourceGuideSubProcedure").findAll(
							select="specialtyId",
							include="procedure(specialtyProcedures)",
							where="resourceGuideId = #val(params.key)#",
							$limit="1"
						)>
						<cfif specialtyCheck.recordcount eq 1>
							<cfset client.relatedSpecialty = specialtyCheck.specialtyId>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		<cfelse>
			<cfset client.relatedSpecialty = 0>
		</cfif>
	</cffunction>

	<cffunction name="getComparison" returntype="string" access="private">
		<cfargument name="bodyRegion" required="false" default="0">
		<cfargument name="bodyPart" required="false" default="0">
		<cfargument name="specialty" required="false" default="0">
		<cfargument name="showCompareBits" required="false" default="true">

		<!--- Assemble search criteria for comparison list --->
		<cfset whereCondition = "isPrimary = 1 AND resourceguides.content is not null">
		<cfif val(arguments.bodyRegion) gt 0>
			<cfset whereCondition = ListAppend(whereCondition,"bodyregions.id = #val(arguments.bodyRegion)#","|")>
		</cfif>
		<cfif val(arguments.bodyPart) gt 0>
			<cfset whereCondition = ListAppend(whereCondition,"bodyparts.id = #val(arguments.bodyPart)#","|")>
		</cfif>
		<cfif val(arguments.specialty) gt 0>
			<cfset whereCondition = ListAppend(whereCondition,"specialtyprocedures.specialtyId = #val(arguments.specialty)#","|")>
		</cfif>
		<cfif whereCondition eq "isPrimary = 1" and showCompareBits><cfset whereCondition = "procedures.id = 0"></cfif>
		<cfset whereCondition = Replace(whereCondition,"|"," AND ","all")>

		<cfif val(arguments.bodyRegion) gt 0 or val(arguments.bodyPart) gt 0>
			<cfset includeList = "procedureBodyParts(bodyPart(bodyRegion)),specialtyProcedures,resourceGuideProcedures(resourceGuide)">
		<cfelse>
			<cfset includeList = "specialtyProcedures,resourceGuideProcedures(resourceGuide)">
		</cfif>
		<!--- Perform comparison query --->
		<cfset compareProcedures = model("Procedure").findAll(
			select  = "DISTINCT procedures.id, procedures.name, procedures.siloName, avgfee, candidate, timeSpan, treatments, results, timeBackToWork",
			include = includeList,
			where   = whereCondition,
			order   = "procedures.name asc"
		)>

		<!--- Write the comparison list onto a string --->
		<cfset comparison = "">
		<cfif compareProcedures.recordcount>
			<cfif arguments.showCompareBits>
				<cfset comparison &= '<a class="view-link" href="##" onclick="compareProcedures(); return false;">COMPARE</a>'>
			</cfif>
			<cfloop query="compareProcedures">
				<cfset comparison &= '<div class="procedure-listing">'>
				<cfif arguments.showCompareBits><cfset comparison &= '<div class="procedure-check"><input type="checkbox" id="c#currentrow#" value="#currentrow#" /></div>'></cfif>
				<cfif not arguments.showCompareBits>
					<cfset comparison &= '<div class="procedure-name">#LinkTo(controller=compareProcedures.siloName,text=compareProcedures.name)#</div>'>
				<cfelse>
					<cfset comparison &= '<div class="procedure-name">#compareProcedures.name#</div>
					<div class="procedure-cost">$#val(compareProcedures.avgfee)#</div>
					<div class="hidden" id="compare_#currentrow#">
						<ul>
							<li contentfor="name">#linkTo(text=compareProcedures.name,controller=compareProcedures.siloName)#</li>
							<li contentfor="cost"><span>Avg. Cost:</span> $#val(compareProcedures.avgfee)#</li>
							<li contentfor="candidate"><span>Candidate:</span> #compareProcedures.candidate#</li>
							<li contentfor="length"><span>Length:</span> #compareProcedures.timeSpan#</li>
							<li contentfor="treatment"><span>Treatment:</span> #compareProcedures.treatments#</li>
							<li contentfor="results"><span>Results:</span> #compareProcedures.results#</li>
							<li contentfor="backtowork"><span>Back to Work:</span> #compareProcedures.timeBackToWork#</li>
							<li contentfor="button">
								#linkTo(text="FIND A DOCTOR",class="view-link",style="float:left;",controller="doctors",action=compareProcedures.siloName)#
								<div class="btn">
								<form action="#URLFor(controller=compareProcedures.siloName)#">
									<input type="submit" class="btn-compare" value="LEARN MORE">
								</form>
								</div>
							</li>
						</ul>
					</div>'>
				</cfif>
				<cfset comparison &= '</div>'>
			</cfloop>
			<cfif arguments.showCompareBits>
				<cfset comparison &= '<a class="view-link" href="##" onclick="compareProcedures(); return false;">COMPARE</a>'>
			</cfif>
		</cfif>

		<cfreturn comparison>
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

	<cffunction name="getCities" access="private" returntype="struct">
		<cfargument name="statename" type="string" required="false" default="">
		<cfargument name="twocolumns" type="boolean" required="false" default="false">
		<cfargument name="addendum" type="string" required="false" default="">
		<cfargument name="addendumSilo" type="string" required="false" default="">
		<cfif addendum contains "specialty">
			<!--- <cfset includeAddendum = "accountLocationSpecialties,">
			<cfset whereAddendum = " AND specialtyId = #REReplace(addendum,'[^0-9]','','all')#"> --->
			<cfset whereAddendum = " AND FIND_IN_SET(#REReplace(addendum,'[^0-9]','','all')#,specialtyIDs)">
		<cfelseif addendum contains "procedure">
			<!--- <cfset includeAddendum = "accountDoctor(accountDoctorProcedures),">
			<cfset whereAddendum = " AND procedureid = #REReplace(addendum,'[^0-9]','','all')#"> --->
			<cfset whereAddendum = " AND FIND_IN_SET(#REReplace(addendum,'[^0-9]','','all')#,procedureIDs)">
		<cfelse>
			<cfset includeAddendum = "">
			<cfset whereAddendum = "">
		</cfif>

		<cfquery name="cities" datasource="#get('dataSourceName')#">
			SELECT DISTINCT cityId as id, city as name, state, stateAbbreviation, stateId, LEFT(state,1) AS letter
			FROM accountdoctorsearchsummary
			WHERE isFeatured = 1 AND cityId > 0 AND city is not null#whereAddendum#
			ORDER BY state asc, city asc
		</cfquery>
		<cfquery name="citycount" dbtype="query">
			SELECT count(1) most FROM cities GROUP BY stateid ORDER BY most desc;
		</cfquery>
		<cfif twocolumns>
			<cfset columnbreak = ceiling(val(citycount.most)/2)>
		<cfelse>
			<cfset columnbreak = ceiling(val(citycount.most)/5)>
		</cfif>
		<cfset result = "">
		<cfset currentState = "">
		<cfset RowInSet = 1>
		<cfloop query="cities">
			<cfif state neq currentState>
				<cfset currentState = state>
				<cfset RowInSet = 1>
				<cfif cities.currentrow gt 1>
					<cfset result &= "</div>">
				</cfif>
				<cfset result &= '<div id="#Replace(state," ","-","all")#">'>
			</cfif>
			<cfif ((columnbreak gt 1) and (RowInSet mod columnbreak) eq 1) or (cities.currentrow eq 1) or (RowInSet eq 1)>
				<cfset result &= "<ul>">
			</cfif>
			<cfif addendumSilo eq "">
				<!--- <cfset result &= '<li>#linkTo(text=name, route="doctorSearch1", filter1="location-#Replace(Replace("#cities.name#, #cities.stateAbbreviation#"," ","_","all"),",","%2C","all")#")#</li>'> --->
				<cfset result &= '<li>#linkTo(text=name, href="/doctors/location-#Replace(cities.name & ", " & cities.stateAbbreviation," ","_","all")#")#</li>'>
			<cfelse>
				<!--- <cfset result &= '<li>#linkTo(text=name, route="doctorSearch2", filter1="location-#Replace(Replace("#cities.name#, #cities.stateAbbreviation#"," ","_","all"),",","%2C","all")#", filter2=addendum)#</li>'> --->
				<cfset result &= '<li>#linkTo(text=name, href="/doctors/#addendumSilo#/#LCase(Replace(cities.name & "-" & cities.stateAbbreviation," ","_","all"))#")#</li>'>
			</cfif>
			<cfif ((columnbreak gt 1) and (RowInSet mod columnbreak) eq 0) or (cities.currentrow eq cities.recordcount)>
				<cfset result &= "</ul>">
			</cfif>
			<cfif cities.currentrow eq cities.recordcount>
				<cfset result &= "</div>">
			</cfif>
			<cfset RowInSet++>
		</cfloop>

		<cfquery name="States" dbtype="query">
			SELECT state as name, letter FROM cities GROUP BY state, letter ORDER BY state asc;
		</cfquery>
		<cfquery name="StateAlphas" dbtype="query">
			SELECT letter FROM States GROUP BY letter ORDER BY name asc;
		</cfquery>

		<cfreturn {cities=result, states=States, stateAlphas=StateAlphas}>
	</cffunction>

	<cffunction name="recordResourceSubGuideHit" access="private">
		<cfargument name="resourceGuideId" required="true" default="" type="numeric">
		<cfargument name="procedureID" required="false" default="">


		<cfif not Client.IsSpider>
			<cfset model("HitsResourceSubGuide").RecordHitDelayed(
								resourceGuideId	= arguments.resourceGuideId,
								procedureID		= arguments.procedureID)>
		</cfif>
	</cffunction>

	<cffunction name="recordResourceGuideSpecialtyHit" access="private">
		<cfargument name="specialtyId" required="false" default="">

		<cfif not Client.IsSpider>
			<cfset model("HitsResourceGuideSpecialty").RecordHitDelayed(specialtyId	= arguments.specialtyId)>
		</cfif>
	</cffunction>

	<cffunction name="recordResourceGuideProcedureHit" access="private">
		<cfargument name="procedureId" required="false" default="">

		<cfif not Client.IsSpider>
			<cfset model("HitsResourceGuideProcedure").RecordHitDelayed(procedureId	= arguments.procedureId)>
		</cfif>
	</cffunction>

</cfcomponent>