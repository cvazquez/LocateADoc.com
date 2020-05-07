<cfparam name="breadcrumbs" default="#arrayNew(1)#">
<cfoutput>
	<ul class="breadcrumbs">
		<cfloop from="1" to="#arrayLen(breadcrumbs)#" index="i">
			<li>#breadcrumbs[i]# > </li>
		</cfloop>
	</ul>
</cfoutput>