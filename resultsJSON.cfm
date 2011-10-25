<cfif NOT structKeyExists(url,"id")>
	Sorry, your query did not have any records.  Return to the qbrowser page and run another query.
	<cfabort />	
</cfif>

<cflock name="resultsxml" timeout="30" type="exclusive">
	<cfsilent>
		<cfset variables.arResults = session.resultsHandler.getRecordsetForID(url.id) />
		<cfset variables.q = variables.arResults[2] />
		<cfset variables.recordsetID = variables.arResults[1] />
		<cfset variables.ts = variables.arResults[3] />
		<!--- <cfset variables.arResultsHeaders = ListToArray(variables.q.columnlist) /> --->
		<cfset variables.arResultsHeaders = variables.q.getColumnNames() />
	</cfsilent>	
	
	<cfif fileExists(expandPath('results.xml'))>
		<cffile action="delete" file="#expandPath('data/temp/resultsJSON.txt')#" />
	</cfif>
	
	<cffile action="write" file="#expandPath('data/temp/resultsJSON.txt')#" output="" addnewline="no"/>
	
	<cfset variables.out = serializeJSON(variables.q,true) />
	
	
	<cffile action="write" file="#expandPath('data/temp/resultsJSON.txt')#" output="#variables.out#" addnewline="no"/>
</cflock>
	
<cfheader name="Content-Disposition" value="attachment; filename=resultsJSON.txt"> 
<cfcontent type="text/text" file="#expandPath('data/temp/resultsJSON.txt')#">
	
	
