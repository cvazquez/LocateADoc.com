<!--- No longer used, as modified queries make CF Wheels freak out --->
<cfparam name="commentcount" default="0">
<cfset commentcount++>
<cfoutput>
	<div class="video-holder comment page_#Ceiling(commentcount/5)#<cfif commentcount gt 5> hidden</cfif>">
		<p>
			<img src="/images/profile/miscellaneous/quote_left.gif" style="margin:0 5px 2px 0;">
			#content#
			<img src="/images/profile/miscellaneous/quote_right.gif" style="margin:2px 0 0 5px;">
		</p>
		<cfif procedureList neq "">
			<p>
				Procedures performed:<br />
				<ul>
					#procedureList#
				</ul>
			</p>
		</cfif>
		<p align="right">
			<cfif showName>#firstName#<cfelse>Anonymous</cfif><br />
			#city#, #state#<br />
			#DateFormat(createdAt,"medium")#
		</p>
	</div>
</cfoutput>