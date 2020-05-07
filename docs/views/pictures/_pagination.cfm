<cfoutput>
	<cfif search.pages gt 1>
		<form action="##" class="pager-form" onsubmit="return false">
			<fieldset>
				<label for="page01">Page</label>
				<span class="text"><input name="page" class="txt" type="text" value="#search.page#" /></span>
				<span>of #search.pages#</span>
				<cfif search.page gt 1>
					<a filter="page" value="#(search.page-1)#" href="page-#(search.page-1)#" class="link-prev">prev</a>
				</cfif>
				<cfif search.page neq search.pages>
					<a filter="page" value="#(search.page+1)#" href="page-#(search.page+1)#" class="link-next">next</a>
				</cfif>
			</fieldset>
		</form>
	</cfif>
</cfoutput>