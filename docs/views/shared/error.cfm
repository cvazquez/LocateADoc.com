<cfparam name="errormsg" default="An error occured while processing your request.">
<cfparam name="errordesc" default="Please navigate back to the previous page and check the request">
<cfparam name="backLink" default="">
<cfparam name="mainid" default="main">
<cfparam name="containerclass" default="container inner-container">

<cfoutput>
	<div id="#mainid#">
		<div class="#containerclass#">
			<div class="content-frame">
				<div id="content" style="text-align:center">
					<h1>ERROR: <cfdump var="#errormsg#"></h1>
					<p><b>#errordesc#</b></p>
					<cfif backLink EQ "">
						<p><a href="back" class="btn-contact" id="btn-back" style="margin:auto">GO BACK</a></p>
					<cfelse>
						<p><a href="#backLink#" class="btn-contact" style="margin:auto">GO BACK</a></p>
					</cfif>
				</div>
			</div>
		</div>
	</div>
</cfoutput>
<script>
	$("a#btn-back")
		.click(function(event){
			event.preventDefault()
			history.back(1)
		})
</script>