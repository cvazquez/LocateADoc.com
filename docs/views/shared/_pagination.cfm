<cfoutput>
	<cfif search.pages gt 1>
		<form action="##" class="pager-form" onsubmit="if(SearchValidatePage(#search.page#,this.page.value,#search.pages#))ChangePage(this.page.value,this.pages.value);return false;">
			<fieldset>
				<label for="page01">Page</label>
				<span class="text"><input name="page" class="txt" type="text" value="#search.page#" /></span>
				<input type="hidden" name="pages" value="#search.pages#">
				<span>of #search.pages#</span>
				<cfset NextURL = getNextPage(search.page,search.pages)>
				<cfset PrevURL = getPrevPage(search.page)>
				<cfif search.page gt 1>
					<a filter="page" value="#(search.page-1)#" href="#PrevURL#" class="link-prev">prev</a>
				</cfif>
				<cfif search.page neq search.pages>
					<a filter="page" value="#(search.page+1)#" href="#NextURL#" class="link-next">next</a>
				</cfif>
			</fieldset>
		</form>
	</cfif>
</cfoutput>