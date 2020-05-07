<cfoutput>
	<div class="holder2 print-area">
		<div id="searchresults_content" class="aside">
			#includePartial("searchresults")#<!--- /views/pictures/_searchresults --->
		</div>
	</div>

	<div id="sidebar">
		<div id="filters_content" class="search-box">
			#includePartial("filters")#<!--- /views/pictures/_filters --->
		</div>
	</div>
</cfoutput>