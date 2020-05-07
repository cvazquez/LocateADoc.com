<cfoutput>
	<!-- main -->
	<div id="main">
		<ul class="breadcrumbs">
			<li>&nbsp;</li>
		</ul>
		<!-- container inner-container -->
		<div class="container inner-container">
			<div class="inner-holder">
				<!-- content-frame -->
				<div class="content-frame">
					<div class="financing">
<div style="padding: 20px;">
<h1>Site Map - #specialty_name#</h1>

<table border="0">
    <tr valign="top">
        <td>
            <div class="SiteMapModuleLeft">
				<cfif qProcedures.recordCount>
				#includePartial(partial="specialty/_procedures.cfm")#
				</cfif>
            </div>
        </td>
        <td>
            <div class="SiteMapModuleRight">
				#includePartial(partial="specialty/_states.cfm")#
            </div>
        </td>
    </tr>
</table>
</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>