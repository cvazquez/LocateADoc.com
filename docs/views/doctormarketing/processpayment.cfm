<cfset styleSheetLinkTag(source="doctormarketing/addlisting", head=true)>


<!--- <cfoutput>
	<cfdump var="#xmlDoc#" label="xmlDoc"><br />
	<p>
	responseStep1ResultText = #xmlDoc.response["result-text"].xmlText#<br />
	responseStep1FormURL = #xmlDoc.response["form-url"].xmlText#<br />
	responseStep1SubscriptionId = #xmlDoc.response["subscription-id"].xmlText#<br />
	responseStep1ResultCode = #xmlDoc.response["result-code"].xmlText#<br />
	responseStep1Result = #xmlDoc.response["result"].xmlText#<br />
	</p>
</cfoutput> --->

<div style="margin-left: auto; margin-right: auto; padding-left: 100px; background-color:white;">
<cfoutput>
		#includePartial("billing-cc")#

		<div style="width: 100%; padding: 18px 230px 26px;">
			<input type="submit" name="submit" value="Next Step">
		</div>
	</form>
</cfoutput>

</div>