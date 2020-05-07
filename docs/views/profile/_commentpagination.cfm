<div class="comment-selector hidden">
	<form action="##" class="pager-form" onsubmit="return validatePageForm(this);">
		<fieldset>
			<label>Page</label>
			<span class="text"><input name="page" class="txt comment-page noPreText" type="text" value="1" /></span>
			<span>of <cfoutput>#Ceiling(recommendations.recordcount/5)#</cfoutput></span>
			<div class="prev-page hidden"><a class="link-prev">prev</a></div>
			<div class="next-page hidden"><a class="link-next">next</a></div>
		</fieldset>
	</form>
	<!--- <div class="prev-page hidden"><a>&lt; Previous Comments</a></div>
	<div class="next-page hidden"><a>More Comments &gt;</a></div> --->
</div>