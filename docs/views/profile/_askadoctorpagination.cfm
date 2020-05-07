<cfif qaTotal.total GT 6>
<div class="comment-selector">
	<form action="##" class="pager-form" onsubmit="return validatePageForm(this);">
		<fieldset>
			<label>Page</label>
			<span class="text"><input name="page" class="txt comment-page noPreText" type="text" value="1" /></span>
			<span>of <cfoutput>#Ceiling(qaTotal.total/6)#</cfoutput></span>
			<div class="prev-page hidden"><a class="link-prev">prev</a></div>
			<div class="next-page hidden"><a class="link-next">next</a></div>
		</fieldset>
	</form>
	<!--- <div class="prev-page"><a>&lt;</a></div>
	<div class="next-page"><a>&gt;</a></div> --->
</div>
</cfif>