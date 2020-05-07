<cfoutput>
	<cfif search.pages gt 1>
		<form action="##" class="pager-form" onsubmit="if(SearchValidatePage(#search.page#,this.page.value,#search.pages#))ChangePage(this.page.value,this.pages.value);return false;">
			<table class="ui-icon-nodisc pagination">
				<td class="left-page-button">
					<cfset NextURL = getNextPage(search.page,search.pages)>
					<cfset PrevURL = getPrevPage(search.page)>
					<cfif search.page gt 1>
						<a filter="page" value="#(search.page-1)#" href="#PrevURL#" data-role="button" data-icon="arrow-l" data-iconpos="notext" data-theme="b" data-iconshadow="false" data-inline="true">Previous Page</a>
					<cfelse>
						<a data-role="button" data-icon="arrow-l" data-iconpos="notext" data-theme="d" data-iconshadow="false" data-inline="true"></a>
					</cfif>
				</td>
				<td class="left-page-indicator">
					Page
				</td>
				<td class="page-box">
					<div style="width:50px; margin:5px 5px 0; display:inline-block;">
					<input name="page" class="txt" type="text" value="#search.page#" <!--- style="width:100px; margin:5px 5px 0;" ---> data-mini="true" />
					</div>
					<input type="hidden" name="pages" value="#search.pages#">
				</td>
				<td class="right-page-indicator">
					<!--- <p style="display:inline-block;"> --->of #search.pages#<!--- </p> --->
				</td>
				<td class="right-page-indicator">
					<cfif search.page neq search.pages>
						<a filter="page" value="#(search.page+1)#" href="#NextURL#" data-role="button" data-icon="arrow-r" data-iconpos="notext" data-theme="b" data-iconshadow="false" data-inline="true">Next Page</a>
					<cfelse>
						<a data-role="button" data-icon="arrow-r" data-iconpos="notext" data-theme="d" data-iconshadow="false" data-inline="true"></a>
					</cfif>
				</td>
			</table>
		</form>
	</cfif>
</cfoutput>