<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
<cfparam name="url.style" default="1">

<cfif not isnumeric(URL.style)>
	<cfset URL.style = val(URL.style)>
</cfif>

<cfif URL.style LTE 0>
	<cfset URL.style = 1>
</cfif>

<cfoutput>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
	<head>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>
		<script type="text/javascript">
			var clicked = false;
			var myTimer;
			$(function(){
			    // Listen to the "click" event of the "recommendation_button" link and make an AJAX request
			    $("##recommendation_button").click(function() {
			        if(!clicked)
			        {
				        $.ajax({
				            type: "POST",
				            url: "#basePath##URLFor(action="recommendbutton-click",key=params.key)#?style=#URL.style#&clicked=button&referer=#CGI.HTTP_REFERER#"
				        });
				        clicked = true;
				        $("##recommendation_wrapper").addClass("disabled");
				        myTimer = setTimeout('clicked=false;$("##recommendation_wrapper").removeClass("disabled");',1000);
			        }
			        else
			        {
						return false;
			        }
			    });
			    // Listen to the "click" event of the "recommendation_counter" links and make an AJAX request
			    $("##recommendation_counter_left,##recommendation_counter,##recommendation_counter_right").click(function() {
			        if(!clicked)
			        {
				        $.ajax({
				            type: "POST",
				            url: "#basePath##URLFor(action="recommendbutton-click",key=params.key)#?style=#URL.style#&clicked=counter&referer=#CGI.HTTP_REFERER#"
				        });
				        clicked = true;
				        $("##recommendation_wrapper").addClass("disabled");
				        myTimer = setTimeout('clicked=false;$("##recommendation_wrapper").removeClass("disabled");',1000);
			        }
			        else
			        {
						return false;
			        }
			    });
			});
		</script>
		<style>
			.disabled
			{
				opacity:0.50; /* firefox, opera, safari, chrome */
    			-ms-filter:"progid:DXImageTransform.Microsoft.Alpha(opacity=50)"; /* IE 8 */
    			filter:alpha(opacity=50); /* IE 4, 5, 6 and 7 */
    			zoom:1;
				background-color:white;
    		}
			##recommendation_wrapper
				{
				height:20px;
				margin:3px;
				}
			##recommendation_button
				{
				background:url('#imagePath#/button#URL.style#.png') no-repeat left top;
				width: #buttonWidth[URL.style]#px;
				height: 20px;
				display: block;
				text-decoration:none;
				float:left;
				}
			##recommendation_button:hover
				{
				background-position:0 -20px;
				}
			##recommendation_counter_wrapper
				{
				float:left;
				}
			##recommendation_counter_wrapper ##recommendation_counter_left
				{
				background:url('#imagePath#/counter_left.png') no-repeat left top;
				width: 9px;
				height: 20px;
				display: block;
				text-decoration:none;
				float:left;
				}
			##recommendation_counter_wrapper:hover ##recommendation_counter_left
				{
				background-position:0 -20px;
				}
			##recommendation_counter_wrapper ##recommendation_counter
				{
				height:18px;
				font: bold 11px/18px Verdana;
				color:##883F5B;
				display: block;
				text-decoration:none;
				float:left;
				border-top:1px solid ##B6D5E9;
				border-bottom:1px solid ##B6D5E9;
				padding:0 2px;
				background-color: white;
				}
			##recommendation_counter_wrapper:hover ##recommendation_counter
				{
				border-top:1px solid ##8DBDDD;
				border-bottom:1px solid ##8DBDDD;
				background:##F2F1F2;
				}
			##recommendation_counter_wrapper ##recommendation_counter_right
				{
				background:url('#imagePath#/counter_right.png') no-repeat left top;
				width: 2px;
				height: 20px;
				display: block;
				float:left;
				text-decoration:none;
				}
			##recommendation_counter_wrapper:hover ##recommendation_counter_right
				{
				background-position:0 -20px;
				}
		</style>
	</head>
	<body style="margin:0; padding:0;">
		<div id="recommendation_wrapper">
			<a class="buttonlink" id="recommendation_button"<cfif linkToComments neq ""> href="#linkToComments#"</cfif> alt="Recommend Us on LocateADoc.com" title="Recommend Us on LocateADoc.com" target="_blank"></a>
			<div id="recommendation_counter_wrapper">
				<a class="buttonlink" id="recommendation_counter_left"<cfif linkToComments neq ""> href="#linkToComments#"</cfif> target="_blank"></a>
				<a class="buttonlink" id="recommendation_counter"<cfif linkToComments neq ""> href="#linkToComments#"</cfif> alt="View our recommendations on LocateADoc.com" title="View our recommendations on LocateADoc.com" target="_blank">#recommendationCount#</a>
				<a class="buttonlink" id="recommendation_counter_right"<cfif linkToComments neq ""> href="#linkToComments#"</cfif> target="_blank"></a>
			</div>
		</div><cfif validationError eq ""><!-- <cfoutput>Error: #validationError#</cfoutput> --></cfif>
	</body>
	</html>
</cfoutput>
