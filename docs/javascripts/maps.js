//Variable for holding a function, for updating the active info bubble with a directions form
var showDirections = function(){};

function getMap(lon, lat, zoom, legendtype) {
   	if(lon&&lat){
   		//Center over specified coordinates
	   	var mapcenter = new google.maps.LatLng(lat, lon);
	   	var mapzoom = zoom;
   	}else{
   		//Center over USA
	   	var mapcenter = new google.maps.LatLng(-97,38.5);
	   	var mapzoom = 4;
   	}
   	//Create map objects
   	var map = new google.maps.Map(document.getElementById("map"),{
	    zoom: mapzoom,
	    center: mapcenter,
	    mapTypeId: google.maps.MapTypeId.ROADMAP,
	    scaleControl: true
    });
   	var infowindow = new google.maps.InfoWindow();
   	var shadow = new google.maps.MarkerImage(
   		"http://www.google.com/mapfiles/shadow50.png",
   		new google.maps.Size(40,37),
   		new google.maps.Point(0,0),
   		new google.maps.Point(10,34)   		
	);
	
	var legend = document.createElement('DIV');
	legend.className = "map-legend";
	if(legendtype == "featured"){
		legend.innerHTML = "<table><tr><td><img src='http://chart.apis.google.com/chart?cht=d&chdp=mapsapi&chl=pin_star%27i%5C%27[%27-2%27f%5Chv%27a%5C]h%5C]o%5CDAA520%27fC%5C000000%27tC%5C000000%27eC%5CFFFF00%271C%5C000000%270C%5CLauto%27f%5C' /></td>"
		+ "<td><p>Featured Doctor</p></td>"
		+ "<td><img src='http://chart.apis.google.com/chart?cht=d&chdp=mapsapi&chl=pin%27i\\%27[%27-2%27f\\hv%27a\\]h\\]o\\FF0000%27fC\\000000%27tC\\000000%27eC\\Lauto%27f\\" 
		+ "' /></td><td><p>Doctor</p></td></tr></table>";
	}else if(legendtype == "location"){
		legend.innerHTML = "<table><tr><td><img src='http://chart.apis.google.com/chart?cht=d&chdp=mapsapi&chl=pin%27i\\%27[%27-2%27f\\hv%27a\\]h\\]o\\FF8800%27fC\\000000%27tC\\000000%27eC\\Lauto%27f\\"		 
		+ "' /></td><td><p>Current Location</p></td>"
		+ "<td><img src='http://chart.apis.google.com/chart?cht=d&chdp=mapsapi&chl=pin%27i\\%27[%27-2%27f\\hv%27a\\]h\\]o\\FF0000%27fC\\000000%27tC\\000000%27eC\\Lauto%27f\\" 
		+ "' /></td><td><p>Location</p></td></tr></table>";		
	}
	map.controls[google.maps.ControlPosition.RIGHT].push(legend);
	
	//Unique location group definition
	function uniqueLocation(latitude,longitude,newIndex){
		this.latitude=latitude;
		this.longitude=longitude;
		this.indexlist = new Array();
		this.indexlist.push(newIndex);
		
		this.addIndex = function(index){
			this.indexlist.push(index);
		};
		this.findMetaIndex = function(index){
			var i = 0;
			while(i<this.indexlist.length){
				if(this.indexlist[i] == index) return i;								
				i++;
			}
			return -1;
		};
		this.nextIndex = function(index){
			var metaIndex = this.findMetaIndex(index);
			if (metaIndex == -1) return -1;
			if(metaIndex == (this.indexlist.length - 1)){
				return this.indexlist[0];
			}else{
				return this.indexlist[metaIndex+1];
			}					
		};
		this.prevIndex = function(index){
			var metaIndex = this.findMetaIndex(index);
			if (metaIndex == -1) return -1;
			if(metaIndex == 0){
				return this.indexlist[this.indexlist.length - 1];
			}else{
				return this.indexlist[metaIndex-1];
			}
		};
	}
	
	//Array of location groups
	var locations = new Array();
	function GroupLocation(latitude,longitude,newIndex){
		var i = 0;
		while(i<locations.length){
			if((locations[i].latitude == latitude) && (locations[i].longitude == longitude)){
				locations[i].addIndex(newIndex);
				return i;	
			}								
			i++;
		}
		locations.push(new uniqueLocation(latitude,longitude,newIndex));
		return locations.length - 1;
	}
   
    function createMarker(point, index) {
    	//Place listing into a group
    	var group = GroupLocation(point.lat(),point.lng(),index);
    	var markerLabel = locations[group].indexlist[0];
		//Determine marker color
		if(listings[index].type == "featured"){	
			listings[index].pinicon = createLabeledMarkerIcon({primaryColor:"#DAA520", label:markerLabel.toString(), addStar:true, starStrokeColor:"#000000"});
		}else if(listings[index].type == "current"){	
			listings[index].pinicon = createLabeledMarkerIcon({primaryColor:"#FF8800", label:markerLabel.toString()});
		}else{
		 	listings[index].pinicon = createLabeledMarkerIcon({primaryColor:"#FF0000", label:markerLabel.toString()});
		}
		//Create marker object
		var marker = new google.maps.Marker({
		 	map: map,
		 	icon: listings[index].pinicon,
		 	position: point,
		 	title: listings[index].title,
		 	shadow: shadow
		});		
		//Set up contents of info bubble
		var html = '<table><tr valign="top"><td>';
		if(listings[index].photo != "") html = html + '<IMG SRC="/images/profile/doctors/thumb/' + listings[index].photo + '" STYLE="border:none;padding:5px;">';
		html = html + '</td><td>' + '<b><a href="' + listings[index].link + '">' + listings[index].name + '</a></b><br>' + listings[index].address + '<br>' + listings[index].city + ', ' + listings[index].state + ' ' + listings[index].zip;
		var htmlForm = html + "<div style='margin:0px;'>Directions: <strong>To here</strong><p><form id=\"gForm\" onsubmit=\"return openGWindow(this);\" target=\"_blank\"><input type=\"hidden\" name=\"daddr\" value=\"" + listings[index].address.replace(/ /g,"+") + ",+" + listings[index].city.replace(/ /g,"+") + "+" + listings[index].state.replace(/ /g,"+") + "\">Start address<br><input type=\"text\" size=\"32\" value=\"\" name=\"saddr\" maxlength=\"255\"><br><input type=\"submit\" value=\"Get Directions\"></form></div></td></tr></table>";
		html = html + '<br>Directions: <a onclick="showDirections();" style="cursor:pointer;">To here</a></td></tr></table>';
		//Rig marker to open info bubble when clicked 
		google.maps.event.addListener(marker, 'click', function(){
			var leftArrow =  (locations[group].indexlist.length > 1) ? '<table><tr><td><a class="prev-bubble" onclick="$(\'#'+listings[locations[group].prevIndex(index)].pincontainer+'\').click();"></a></td><td>' : '';
			var rightArrow = (locations[group].indexlist.length > 1) ? '</td><td><a class="next-bubble" onclick="$(\'#'+listings[locations[group].nextIndex(index)].pincontainer+'\').click();"></a></td></table>' : '';
			infowindow.setContent(leftArrow + html + rightArrow);
	 		infowindow.open(map,marker);
	 		showDirections = function(){
	 			infowindow.setContent(leftArrow + htmlForm + rightArrow);
	 			infowindow.open(map,marker);
	 			return false;
	 		};
		});
		//Set up marker icon in the listings, if available
		var markerDiv = document.getElementById(listings[index].pincontainer); 	 
		if(markerDiv != null){
		 	markerDiv.innerHTML = '<a href="#map"><img src="'+listings[index].pinicon.replace("&ext=.png","")+'" /></a>';
			markerDiv.onclick = function() {
			 	google.maps.event.trigger(marker,'click');
			}
		}
		return marker;
    }
    
    function SubmitGeocode(currentindex){
    	var geocoder = new google.maps.Geocoder();
    	geocoder.geocode(
			{address:listings[currentindex].address+", "
					+listings[currentindex].city+", "
					+listings[currentindex].state+", "
					+listings[currentindex].zip},
			function(resultArray,status){					
				//alert(status);
				if(status == google.maps.GeocoderStatus.OK){
					var newpoint = resultArray[0].geometry.location;					
					marker = createMarker(newpoint, currentindex);
					$.ajax({url:"/doctors/updategeodata",
						type:"POST",
						data:"id="+listings[currentindex].pincontainer
							+"&lat="+newpoint.lat()
							+"&lon="+newpoint.lng()					  
					});
					/*
					alert(currentindex+": "+google.maps.GeocoderStatus.OK+"\r\n"+listings[currentindex].address+", "
					+listings[currentindex].city+", "
					+listings[currentindex].state+", "
					+listings[currentindex].zip+"\r\nLatitude: "+newpoint.lat()+" Longitude: "+newpoint.lng());
					*/
				}
			}
		);
    }

	//Set up map markers for all listings
	var point = null;
	
   	for (var i = 1; i < listings.length; i++) {
		if (listings[i].lat != "" && listings[i].lon !=""){
		    point = new google.maps.LatLng(listings[i].lat, listings[i].lon);
		    marker = createMarker(point, i);
		}else if((listings[i].address != "") && (listings[i].city != "") && (listings[i].state != "") && (listings[i].zip != "")){
			SubmitGeocode(i);
		}
   	}
   	if(cityPlotPolygon){
   		cityPlot = new google.maps.Polygon({
		    paths: cityPlotPolygon,
		    strokeColor: "#008888",
		    strokeOpacity: 0.8,
		    strokeWeight: 2,
		    fillOpacity: 0,
		    clickable: false
	  	});
   		cityPlot.setMap(map);
   	}
   	if(cityPlotLines){
   		cityExpandPlot = new google.maps.Polygon({
		    paths: cityPlotLines,
		    strokeColor: "#008800",
		    strokeOpacity: 0.8,
		    strokeWeight: 2,
		    fillOpacity: 0,
		    clickable: false
	  	});
   		cityExpandPlot.setMap(map);
   	}
   	if(mapBounds){
   		map.fitBounds(mapBounds);
   	}
}
//Insert HTML code for the map box
function writeMap(){
	document.write('<div id="map" style="width: 700px; height: 400px; border:solid; border-color:9391D9;"></div>');
	document.write('<div id="message">How to Use the Map<UL><LI>Moving Around: to move the map, use the arrow buttons, or click on the map and drag it.</LI><LI>Zooming: to zoom in our out, click the plus or minus signs, or turn the mouse wheel.</LI><LI>Pins: to read a doctor\'s information, click on a pin.</LI></UL></div>');
}
//Show or hide the map and the buttons that call this function
function toggleMap(){
	if(document.getElementById('map-view').style.display != 'none'){
		$('.map-view').slideUp("fast");
		document.getElementById('message').style.display = 'none';		
		$('.pincontainer').addClass('hidden');
		$('#list-on').addClass('hidden');
		$('#map-on').removeClass('hidden');
	}
	else{
		$('.map-view').slideDown("fast", function() {
    		loadMap();
  		});
		document.getElementById('message').style.display = 'block';
		$('.pincontainer').removeClass('hidden');
		$('#list-on').removeClass('hidden');
		$('#map-on').addClass('hidden');
	}
}
//Open a new window for directions on Google Maps
function openGWindow(gform){
	var thislink="http://maps.google.com/maps?f=d&hl=en&saddr=" + gform.saddr.value.replace(/ /g,"+") + "&daddr=" + gform.daddr.value.replace(/ /g,"+");
	window.open(thislink,"gwindow", "", false);
	return false;
}
//Generate a URL for a google map marker image based on variables passed through the argument structure
function createLabeledMarkerIcon(opts) {
	var primaryColor = opts.primaryColor || "#DA7187";
	var strokeColor = opts.strokeColor || "#000000";
	var starPrimaryColor = opts.starPrimaryColor || "#FFFF00";
	var starStrokeColor = opts.starStrokeColor || "#0000FF";
	var label = encodeURIComponent(opts.label) || "";
	var labelColor = opts.labelColor || "#000000";
	var addStar = opts.addStar || false;
	  
	var pinProgram = (addStar) ? "pin_star" : "pin";
	var baseUrl = "http://chart.apis.google.com/chart?cht=d&chdp=mapsapi&chl=";
	var iconUrl = baseUrl + pinProgram + "'i\\" + "'[" + label + 
	    "'-2'f\\"  + "hv'a\\]" + "h\\]o\\" + 
	    primaryColor.replace("#", "")  + "'fC\\" + 
	    labelColor.replace("#", "")  + "'tC\\" + 
	    strokeColor.replace("#", "")  + "'eC\\";
	if (addStar) {
	  	iconUrl += starPrimaryColor.replace("#", "") + "'1C\\" + 
	    starStrokeColor.replace("#", "") + "'0C\\";
	}
	iconUrl += "Lauto'f\\";
	iconUrl += "&ext=.png";
	return iconUrl;
}