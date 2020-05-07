<div class="SiteMapSurgeryStateHeader">Find a <cfoutput>#doctor_singular#</cfoutput></div>
<div class="FindADoctor">
<cfif qStates.RecordCount GT 0>
<p class="FindADoctorCountry">
<div class="FindADoctorCountryHeader">United States</div>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR VALIGN="top">
	<CFSET Rows=Ceiling(Evaluate(qStates.RecordCount/state_columns))>
	<cfoutput>
	<CFLOOP FROM="1" TO="#rows#" INDEX="i">
		<CFLOOP FROM="#i#" TO="#Evaluate(state_columns*Rows)#" STEP="#Rows#" INDEX="i2">
			<TD class="SiteMapSurgeryStateList">
				<cfif qStates.stateSiloName[i2] neq "">
				<A HREF="/doctors/#qStates.specialtySiloName[i2]#/#qStates.stateSiloName[i2]#" TITLE="#qStates.name[i2]#">#qStates.name[i2]#</A>
				</cfif>
			</TD>
		</CFLOOP>
		</TR>
	</CFLOOP>
	</cfoutput>
</TABLE>
</p>
</cfif>


<cfif qStatesCanada.RecordCount GT 0>
<p class="FindADoctorCountry">
<div class="FindADoctorCountryHeader">Canadian Provinces</div>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR VALIGN="top">
	<CFSET Rows=Ceiling(Evaluate(qStatesCanada.RecordCount/state_columns))>
	<cfoutput>
	<CFLOOP FROM="1" TO="#rows#" INDEX="i">
		<CFLOOP FROM="#i#" TO="#Evaluate(state_columns*Rows)#" STEP="#Rows#" INDEX="i2">
			<TD class="SiteMapSurgeryStateList">
				<cfif qStatesCanada.stateSiloName[i2] neq "">
					<A HREF="/doctors/#qStatesCanada.specialtySiloName[i2]#/#qStatesCanada.stateSiloName[i2]#" TITLE="#qStatesCanada.name[i2]#">#qStatesCanada.name[i2]#</A>
				</cfif>
			</TD>
		</CFLOOP>
		</TR>
	</CFLOOP>
	</cfoutput>
</TABLE>
</p>
</cfif>

<cfif qStatesMexico.RecordCount GT 0>
<p class="FindADoctorCountry">
<div class="FindADoctorCountryHeader">Mexican States</div>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR VALIGN="top">
	<CFSET Rows=Ceiling(Evaluate(qStatesMexico.RecordCount/state_columns))>
	<cfoutput>
	<CFLOOP FROM="1" TO="#rows#" INDEX="i">
		<CFLOOP FROM="#i#" TO="#Evaluate(state_columns*Rows)#" STEP="#Rows#" INDEX="i2">
			<TD class="SiteMapSurgeryStateList">
				<cfif qStatesMexico.stateSiloName[i2] neq "">
					<A HREF="/doctors/#qStatesMexico.specialtySiloName[i2]#/#qStatesMexico.stateSiloName[i2]#" TITLE="#qStatesMexico.name[i2]#">#qStatesMexico.name[i2]#</A>
				</cfif>
			</TD>
		</CFLOOP>
		</TR>
	</CFLOOP>
	</cfoutput>
</TABLE>
</p>
</cfif>
</div>