<div class="SiteMapSurgeryStateHeader">Find a Doctor</div>

<div class="FindADoctor">
<p class="FindADoctorCountry">
<div class="FindADoctorCountryHeader">United States</div>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR VALIGN="top">
	<CFSET Rows=Ceiling(Evaluate(qStates.RecordCount/state_columns))>
	<cfoutput>
	<CFLOOP FROM="1" TO="#rows#" INDEX="i">
		<CFLOOP FROM="#i#" TO="#Evaluate(state_columns*Rows)#" STEP="#Rows#" INDEX="i2">
			<TD class="SiteMapSurgeryStateList">
				<A HREF="/doctors/#qStates.siloName[i2]#" TITLE="#qStates.name[i2]#">#qStates.name[i2]#</A>
			</TD>
		</CFLOOP>
		</TR>
	</CFLOOP>
	</cfoutput>
</TABLE>
</p>

<p class="FindADoctorCountry">
<div class="FindADoctorCountryHeader">Canadian Provinces</div>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR VALIGN="top">
	<CFSET Rows=Ceiling(Evaluate(qStatesCanada.RecordCount/state_columns))>
	<cfoutput>
	<CFLOOP FROM="1" TO="#rows#" INDEX="i">
		<CFLOOP FROM="#i#" TO="#Evaluate(state_columns*Rows)#" STEP="#Rows#" INDEX="i2">
			<TD class="SiteMapSurgeryStateList">
				<A HREF="/doctors/#qStatesCanada.siloName[i2]#" TITLE="#qStatesCanada.name[i2]#">#qStatesCanada.name[i2]#</A>
			</TD>
		</CFLOOP>
		</TR>
	</CFLOOP>
	</cfoutput>
</TABLE>
</p>

<p class="FindADoctorCountry">
<div class="FindADoctorCountryHeader">Mexican States</div>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR VALIGN="top">
	<CFSET Rows=Ceiling(Evaluate(qStatesMexico.RecordCount/state_columns))>
	<cfoutput>
	<CFLOOP FROM="1" TO="#rows#" INDEX="i">
		<CFLOOP FROM="#i#" TO="#Evaluate(state_columns*Rows)#" STEP="#Rows#" INDEX="i2">
			<TD class="SiteMapSurgeryStateList">
				<A HREF="/doctors/#qStatesMexico.siloName[i2]#" TITLE="#qStatesMexico.name[i2]#">#qStatesMexico.name[i2]#</A>
			</TD>
		</CFLOOP>
		</TR>
	</CFLOOP>
	</cfoutput>
</TABLE>
</p>
</div>