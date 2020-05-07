<cfset addRoute(name="home", pattern="", controller="home", action="index")>
<cfset addRoute(name="advanced", pattern="advanced", controller="home", action="advanced")>
<cfset addRoute(name="doctor-reviews", pattern="doctor-reviews", controller="home", action="doctorReviews")>
<cfset addRoute(name="profilecase", pattern="profile/case/[caseid]/[key]", controller="profile", action="case")>

<!---GALLERY SEARCH FILTERS--->
<cfloop from="20" to="1" step="-1" index="i">
	<cfset filters = "">
	<cfloop from="1" to="#i#" index="j">
		<cfset filters = ListAppend(filters,"[filter#j#]","/")>
	</cfloop>
	<cfset addRoute(name="gallerySearch#i#",pattern="pictures/search/#filters#",controller="pictures",action="search")>
	<cfset addRoute(name="doctorSearch#i#",pattern="doctors/search/#filters#",controller="doctors",action="search")>
	<cfset addRoute(name="profileGalleryTab#i#",pattern="profile/gallery/[key]/#filters#",controller="profile",action="gallery")>
	<cfset addRoute(name="resourceArticles#i#",pattern="resources/articles/#filters#",controller="resources",action="articles")>
	<cfset addRoute(name="askadoctorQuestions#i#",pattern="ask-a-doctor/questions/#filters#",controller="askADoctor",action="questions")>
	<cfset addRoute(name="askadoctorArchive#i#",pattern="ask-a-doctor/archive/#filters#",controller="askADoctor",action="archive")>
	<cfset addRoute(name="doctorArticles#i#",pattern="doctor-marketing/articles/#filters#",controller="doctorMarketing",action="articles")>
	<cfset addRoute(name="resourceBlog#i#",pattern="resources/blog-list/#filters#",controller="resources",action="blogList")>
	<cfset addRoute(name="resourceBlogAuthorsList#i#",pattern="resources/authors-list/#filters#",controller="resources",action="authorsList")>
	<cfset addRoute(name="resourceVideos#i#",pattern="resources/video/#filters#",controller="resources",action="video")>
</cfloop>
<!--- DYNAMIC IMAGE NAMES --->
<cfset addRoute(name="dynamicImage",pattern="image/[filename]",controller="image",action="index")>