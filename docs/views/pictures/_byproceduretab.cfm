<cfoutput>
	<div id="tab1" class="procedure-tab sort-box location-form" style="visibility:hidden">
		<form onsubmit="ProcedureMatch();return false;">
		<div class="text" style="margin:5px 0 0 -5px">
			<cfif NOT isMobile>
				<label for="typeProcedure">Type a procedure</label>
			<cfelse>
				<div class="bodyPartOrProcedure">OR</div>
			</cfif>
			<input type="text" id="typeProcedure" placeholder="Type a Procedure">
		</div>
		<cfif NOT isMobile>
			<div class="clear"></div>
			<strong class="title">Start typing a procedure name above or click on the name below.</strong>
			<ul id="alphabet" class="list-item sort-heading">
				<cfloop from="97" to="122" index="i">
					<li><a href="##" class="tab<cfif i eq 97> active</cfif>">#ucase(chr(i))#</a></li>
				</cfloop>
			</ul>
		</cfif>
		<div class="procedures">
			<div class="scrollable">
				<ul class="list sort-list">
					<cfloop query="procedures">
						<li><a href="#URLFor(controller="pictures",action=procedureSiloName)#" class="procedureOption_#procedureId#" label="#UCase(procedureName)#">#procedureName#</a></li>
					</cfloop>
				</ul>
			</div>
		</div>

		</form>
	</div>
	<!--- <script>
		var allProcedures = []
		<cfloop query="procedures">
			allProcedures.push({
				value		: "#JSStringFormat(procedureName)#",
				label		: "#JSStringFormat(procedureName)#",
				procedureId	: #procedureid#
			})
		</cfloop>
	</script> --->
	<noscript>
		<h2>Pictures by Procedure</h2>
		<ul>
			<cfloop query="procedures">
				<li><a href="#URLFor(controller="pictures",action=procedureSiloName)#">#procedureName#</a></li>
			</cfloop>
		</ul>
	</noscript>
</cfoutput>