// Results filtering. Dependencies: filterresults.js, hashchange.js, utils.js .. and jQuery of course!
// Written by Jay Hartigan
/*	USAGE: (accepts a params object)
 	filterResults({
 		url:		required. this is the ajax url used to filter the search, ie: "/mysearch/filtersearch",
		action:		required. this is the action from which the filter request will originate, ie "search",
		permfilters:optional. pass an object of filter values that will ALWAYS be used, ie: {doctor:1234,procedure:16}
		returns:	optional. default="html". possible values are "html" or "json", if "json" the object returned should contain blocks of html content that directly relate to the div(s)
		div:		optional. jQuery selectors for elements that will receive ajax content, ie: "div.mysearchresults",
		opacity:	optional. default=1. fade the div(s) to this opacity while content loads. values are 0 to 1, ie: .25 (note: 0 wont work unless its in quotes)
		click:		optional. jQuery selectors for elements that will to filter on-click, ie: "a[filter]",
		change:		optional. jQuery selectors for elements that will to filter on-change, ie: "select, input[type=text]",
		callback:	optional. a function that will be called when the process completes. The ajax response will be handed to this function
	})
	EXAMPLE: This is how it's used for BAAG search results
	var FR = new filterResults({
		url:gallerybase+"/filterresults",
		action:"search",
		returns:"json",
		div:"#filters_content, #searchterm_content, #searchresults_content",
		opacity:"0",
		click:"a[filter]",
		change:"select, input[type=text]",
		callback:initOpenClose
	})
 */

function filterResults(options) {
	this.debug		= false;
	this.options	= options || {};
	this.filterURL	= this.options.url || "NoFilterURLWasProvided!!";
	this.action		= this.options.action || "NoActionWasProvided!!";
	this.permfilters= this.options.permfilters || {};
	this.returns	= this.options.returns || false;
	this.div		= this.options.div || null;
	this.opacity	= this.options.opacity || 1;
	this.click		= this.options.click || null;
	this.change		= this.options.change || null;
	this.callback	= this.options.callback || function(response){};
	if (this.returns)
		this.filterURL += "?format="+this.returns;
	var F_R = this;
	this.reformURL = function(){
		/* When the search results page loads for the first time, reformURL can check the URL
		 * to see if there are any hash values for filter options that should be applied
		 * to the current result set (this could be true if the user has copy-pasted the URL
		 * from a previous search into their browser) and refresh the page.
		 */
		if(location.href.split("#").length > 1)
		{
			alert("reformURL");
return;
			window.stop();
			$("body").css("display","none");
			var currentURL = location.href.replace(/https?:\/\/[^\.]+\.locateadoc\.com\/pictures/,"").split("?")[0].replace("#","");
			var newURL = location.href.split("/pictures/")[0] + "/pictures";
			var tempFilter = "";
			var filters;
			var newFilters = new Array();
			var siloGenderName;
			var siloGenderId;
			var siloBodyPartName;
			var siloBodyPartId;
			var siloProcedureName;
			var siloProcedureId;
			var stillHaveGender = 0;
			var stillHaveBodyPart = 0;
			var stillHaveProcedure = 0;
			var stillHaveLocation = 0;

			currentURL = location.href.split("?")[0].replace("#","");

			if(currentURL.indexOf("/pictures/search/") == -1)
				currentURL = currentURL.replace("/pictures/","/pictures/search/");
			if(typeof siloedFilters != "undefined" && currentURL.search(siloedFilters) == -1)
				currentURL = currentURL.replace(siloedNames,"") + siloedFilters;

			console.log(currentURL);

/*
			var isGenderBodyPart = currentURL.match(new RegExp("/(male|female)/[a-z0-9-]+((/[a-z_-]+-[0-9_]+)|(/location-[^/]+)|(/doctorlastname-[^/]+)|(/country-[a-zA-Z]+))*"));
			var isProcedure = currentURL.match(new RegExp("^/[a-z0-9-]+((/[a-z_-]+-[0-9_]+)|(/location-[^/]+)|(/doctorlastname-[^/]+)|(/country-[a-zA-Z]+))*$"));
			var isProcedureLocation = currentURL.match(new RegExp("/[a-z0-9-]+/[a-z-]+((/[a-z_-]+-[0-9_]+)|(/doctorlastname-[^/]+)|(/country-[a-zA-Z]+))*"));

			if(isGenderBodyPart)
			{
				siloGenderName = isGenderBodyPart[0].split("/")[1];
				siloBodyPartName = isGenderBodyPart[0].split("/")[2];
				siloGenderId = genderArray[siloGenderName] || 0;
				siloBodyPartId = bodyPartArray[siloBodyPartName] || 0;
				if(F_R.debug) console.log("Gender/body part silo detected: "+siloGenderName+" "+siloBodyPartName);
			}
			else if(isProcedure)
			{
				siloProcedureName = isProcedure[0].split("/")[1];
				siloProcedureId = procedureSiloArray[siloProcedureName];
				if(F_R.debug) console.log("Procedure silo detected: "+siloProcedureName+"["+siloProcedureId+"]");
			}
			else if(isProcedureLocation)
			{
				siloProcedureName = isProcedureLocation[0].split("/")[1];
				siloProcedureId = procedureSiloArray[siloProcedureName];
				locationSilo = isProcedureLocation[0].split("/")[2].replace(/-/g," ");
				if(F_R.debug) console.log("Procedure/location silo detected: procedure="+siloProcedureName+", location="+locationSilo);
			}
			filters = ((siloedFilters || '') + currentURL).split("/");
			if(F_R.debug) console.log("Adjusted filters: "+filters);
			
			// Building newFilters to remove duplicate filters, keep the last one of each
			if(F_R.debug) console.log("\nBuilding newFilters to remove duplicate filters, keep the last one of each");
			for(var i in filters)
			{
				tempFilter = filters[i].split("-");
				if(F_R.debug) console.log("Analyzing filter: "+tempFilter[0]+"="+tempFilter[1]);
				if(tempFilter.length > 1 && (tempFilter[0] == 'location' || tempFilter[1].match(/^[0-9_]+$/)))
				{
					newFilters[tempFilter[0]] = filters[i].replace(tempFilter[0]+"-","");
					if(F_R.debug) console.log("newFilters['"+tempFilter[0]+"']="+newFilters[tempFilter[0]]);
				}
			}
			filters = newFilters;
			newFilters = new Array();

			// Remove distance if location was removed			
			if(newFilters["location"] && newFilters["location"] == 0 && newFilters["distance"])
				newFilters["distance"] = 0;

			// Building newFilters to remove filters ending with -0
			if(F_R.debug) console.log("\nBuilding newFilters to remove filters ending with -0");
			for(var thisFilter in filters)
			{
				if(filters[thisFilter] != 0)
				{
					newFilters[thisFilter] = filters[thisFilter].replace(thisFilter+"-","");
					if(F_R.debug) console.log("newFilters['"+thisFilter+"'] = "+ filters[thisFilter].replace(thisFilter+"-",""));
					if(thisFilter == "gender")
					{
						stillHaveGender = filters[thisFilter].replace(thisFilter+"-","");
						if(F_R.debug) console.log("We still have gender: "+stillHaveGender);
					}
					else if(thisFilter == "bodypart")
					{
						stillHaveBodyPart = filters[thisFilter].replace(thisFilter+"-","");
						if(F_R.debug) console.log("We still have body part: "+stillHaveBodyPart);
					}
					else if(thisFilter == "procedure")
					{
						stillHaveProcedure = filters[thisFilter].replace(thisFilter+"-","");
						if(F_R.debug) console.log("We still have procedure: "+stillHaveProcedure);
					}
					else if(thisFilter == "location")
					{
						stillHaveLocation = filters[thisFilter].replace(thisFilter+"-","").toLowerCase().replace(/[^a-z]+/g,"-");
						if(F_R.debug) console.log("We still have location: "+stillHaveLocation);
					}
				}
				
			}
			if(isProcedureLocation && !stillHaveProcedure && stillHaveLocation)
			{
				stillHaveLocation = 0;
				if(F_R.debug) console.log("Technically we still have location but procedure was removed so we don't get to keep the siloed location either.");
			}
			
			// Update/remove siloed filters if needed
			if(stillHaveProcedure)
			{
				newURL += "/" + procedureSiloArray[stillHaveProcedure];
				if(stillHaveLocation)
					newURL += "/" + stillHaveLocation;
				stillHaveGender = 0;
				stillHaveBodyPart = 0;
				if(F_R.debug) console.log("\nAdded back the siloed filters to newURL: "+newURL);
			}
			else if(stillHaveGender && stillHaveBodyPart)
			{
				newURL += "/" + genderArray[stillHaveGender] + "/" + bodyPartArray[stillHaveBodyPart];
				stillHaveProcedure = 0;
				stillHaveLocation = 0;
				if(F_R.debug) console.log("\nAdded back the siloed filters to newURL: "+newURL);
			}
			
			// Generate remaining filters
			if(F_R.debug) console.log("\nGenerating remaining filters");
			filters = "";
			for(var i in newFilters)
			{
				if(
				 			((!stillHaveGender || !stillHaveBodyPart) || (i != "gender" && i != "bodypart"))
				 		&& (!stillHaveProcedure || i != "procedure")
				 		&& ((!stillHaveProcedure || !stillHaveLocation) || i != "location")
				 )
				{
					filters += "/" + i + "-" + newFilters[i]; 
					if(F_R.debug) console.log("Adding filter: /" + i + "-" + newFilters[i]);
				}
			}
			if(filters != "")
			{
				newURL += filters;
				if(F_R.debug) console.log("Added filters to newURL: " + newURL);
			}
			
			// Redirect to newURL
			if(F_R.debug)
				console.log("\nNew URL: " + newURL);
			else
				location.replace(newURL);
*/
		}
	}
	
	this.getHashFilters = function()
	{
		alert("getHashFilters");
		//First get the HASH string filters
		var hstring = location.hash.split("#")[1];
		//Check and procede
		if (hstring && hstring.length != 0)
		{
			//Split the string up into an array of filter option-value pairs
			var hoptions = hstring.split("/");
			//Create an assoc array where the filter option is the key
			var hfilters = {};
			for (var i in hoptions)
			{
				var opt = hoptions[i].split("-")[0];
				var val = hoptions[i].replace(opt+"-", "");
				if (typeof val == "undefined")
					val = opt;
				if (opt && val)
					hfilters[opt] = val;
			}
			return hfilters;
		}
		else
			return false;
	}
	
	this.getURLFilters = function()
	{
		alert("getURLFilters");
		//Get the URL string filters
		var ustring = location.pathname.split("#")[0];
		var siloGenderBodyPart = ustring.match(new RegExp("/(male|female)/[a-z0-9-]+($|[/#\?])"));
		var siloProcedure = ustring.match(new RegExp("\/pictures\/[a-z0-9-]+($|[\/#\?])"));
		var siloProcedureLocation = ustring.match(new RegExp("\/pictures\/[a-z0-9-]+\/[a-z-]+($|[\/#\?])"));
		if(siloProcedure && siloProcedure.length)
			siloProcedure = siloProcedure[0].replace("/pictures","").replace(/\//g,"");
		if(siloProcedureLocation && siloProcedureLocation.length)
			siloProcedureLocation = siloProcedureLocation[0].replace("/pictures","").replace(/\//g,"");

		//console.log("siloGenderBodyPart = "+siloGenderBodyPart);
		//console.log("siloProcedure = "+siloProcedure);
		if(typeof siloedFilters != "undefined" && (siloProcedure || siloGenderBodyPart || siloProcedureLocation))
		{
			if(ustring && ustring.length != 0 && ustring.indexOf(siloedFilters) == -1)
				ustring = siloedFilters + ustring;
			else
				ustring = siloedFilters;
			isSiloed = true;
		}
		else
			isSiloed = false;
		if (ustring && ustring.length != 0)
		{
			//Split the string up into an array of filter option-value pairs
			var uoptions = ustring.split("/");
			//Create an assoc array where the filter option is the key
			var ufilters = {};
			for (var i in uoptions)
			{
				var opt = uoptions[i].split("-")[0];
				var val = uoptions[i].replace(opt+"-", "");
				if (opt && val && (opt == "location" || val.match(/^[0-9_]+$/)))
				{
					if(F_R.debug) console.log("Adding filter: " + opt + "=" + val);
					ufilters[opt] = val;
				}
			}
			if(F_R.debug) for (var i in ufilters) { console.log("ufilters['" + i + "']=" + ufilters[i]); }
			return ufilters;
		}
		else
			return false;
	}
	
	this.initFilters = function() {
		// Filter links will do this:
		$(F_R.click)
			.unbind("click")
			.click(function(event){
				event.preventDefault();
				$("[id^=TB_]").remove();
				var fil = $(this).attr("filter");
				var val = $(this).attr("value");
				var filterURL = location.href.split("?")[0].replace("#","");
				var filterRegEx = new RegExp("\/" + fil + "-[^\/]+");
				if(fil != "page") filterURL = filterURL.replace(/\/page-[0-9]+/,"");
				if(typeof siloedFilters != "undefined" && filterURL.search(siloedFilters) == -1)
				{
					filterURL = filterURL.replace(siloedNames,"") + siloedFilters;
					if(filterURL.indexOf("/pictures/search/") == -1)
						filterURL = filterURL.replace("/pictures/","/pictures/search/");
				}
				if(val == 0)
					filterURL = filterURL.replace(filterRegEx,"");
				else if(filterURL.search(filterRegEx) >= 0)
						filterURL = filterURL.replace(filterRegEx,"/"+fil+"-"+val);
				else
					filterURL = filterURL + "/" + fil + "-" + val;
				location.href = filterURL;
			})
			
		$(F_R.change)
			.unbind("change")
			.change(function(){
				//alert("F_R.change");
				var fil = $(this).attr("name");
				var val = $(this).val().replace("-","_")
										.replace("  "," ")
										.replace("  "," ")
										.replace("  "," ")
										.replace(" ","_")
										.replace(" ","_")
										.replace(" ","_");
				var filterURL = location.href.split("?")[0].replace("#","");
				var filterRegEx = new RegExp("\/" + fil + "-[^\/]+");
				if(fil != "page") filterURL = filterURL.replace(/\/page-[0-9]+/,"");
		
				if(typeof siloedFilters != "undefined" && filterURL.search(siloedFilters) == -1)
				{
					filterURL = filterURL.replace(siloedNames,"") + siloedFilters;
					if(filterURL.indexOf("/pictures/search/") == -1)
						filterURL = filterURL.replace("/pictures/","/pictures/search/");
				}
				if(val == 0)
					filterURL = filterURL.replace(filterRegEx,"");
				else if(filterURL.search(filterRegEx) >= 0)
					filterURL = filterURL.replace(filterRegEx,"/"+fil+"-"+val);
				else
					filterURL = filterURL + "/" + fil+"-"+val;
				location.href = filterURL;
			})
	}
	
	this.refreshSearch = function() {
		alert("refreshSearch");
		var h_filters = F_R.getHashFilters() || {};
		if (h_filters.casedetails)
			return; //This means the user clicked on the 'view details' link of the profile-gallery tab
		var u_filters = F_R.getURLFilters() || {};
		jQuery.extend(u_filters,h_filters);
		jQuery.extend(u_filters,F_R.permfilters);

		if(u_filters['location'] == 0 && u_filters['distance'] != 0)
		{
			u_filters['distance'] = 0;
			if(F_R.debug) console.log("Removed distance because location was removed.");
		}
		else
		{
			if(F_R.debug) console.log("u_filters[\"location\"]="+u_filters['location']);
		}
		if(F_R.debug) for (var i in u_filters) { console.log("combined: " + i + "=" + u_filters[i]); }

		
		$("<div/>")
			.attr("id","pleasewait")
			.css("text-align","center")
			.html("<p>filtering your results...</p><img src='/images/layout/loading.gif' /></div>")
			.appendTo("body")
			.dialog({
				title			: "Please wait",
				modal			: true,
				resizable		: false,
				draggable		: false,
				closeOnEscape	: false
			})
		$("a.ui-dialog-titlebar-close").remove();
		if(F_R.debug) console.log("Posting to "+F_R.filterURL);
		$.post(F_R.filterURL,u_filters,function(response)
		{
			if (typeof response == "object")	// json response
			{
				if(F_R.debug) console.log("JSON object response");
				var areas = F_R.div.split(",");
				for (var i in response)
				{
					$(areas[i]).html(response[i]);
				}
				$("#pleasewait").remove();
				F_R.initFilters();
				F_R.callback();
			}
			else								// html response
			{
				if(response == 'PAGE_ERROR')
				{
					if(F_R.debug) console.log("Response: "+response);
					location.replace(location.href.replace(/page-[0-9]+/,"").replace('#','').replace(/\\\/+/g,"/").replace("http:/","http://"));
				}
				else
				{
					$(F_R.div).html(response);
					$("#pleasewait").remove();
					F_R.initFilters();
					F_R.callback();
				}
			}
			$("a.casedetails,img.casedetails")
				.click(function(event){
					var caseid = parseInt($(this).attr("caseid"));
					if (isNaN(caseid)) return;
					$.post("/profile/gallerycase/"+caseid+"?format=json",{},function(response){
						var backdata = $("#main").html();
						$("#main").html(response);
						$("#main .link-back")
							.unbind("click")
							.click(function(event){
								event.preventDefault()
								$("#main").html(backdata)
								history.back()
							});
					});
				});
			window.scroll(0,0);
			if (typeof tb_init == "function") //if we're using thickbox, initialize any thickbox links
				tb_init(".thickbox");
		});
	}
	
	//When the HASH value changes, filter the search results
	/*$(window).hashchange(function(){
		alert("hashchange");
		F_R.refreshSearch()
	})*/

	this.initFilters()
}