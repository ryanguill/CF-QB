<cfif NOT structKeyExists(url,"id")>
	Sorry, your query did not have any records.  Return to the qbrowser page and run another query.
	<cfabort />	
</cfif>

<cflock name="resultscsv" timeout="30" type="exclusive">
	<cfsilent>
		<cfset variables.arResults = session.resultsHandler.getRecordsetForID(url.id) />
		<cfset variables.q = variables.arResults[2] />
		<cfset variables.recordsetID = variables.arResults[1] />
		<cfset variables.ts = variables.arResults[3] />
		<!--- <cfset variables.arResultsHeaders = ListToArray(variables.q.columnlist) /> --->
		<cfset variables.arResultsHeaders = variables.q.getColumnNames() />
		<cfset variables.newline = chr(10) & chr(13) />
	</cfsilent>
	
	<cfset variables.tabChar = chr(9) />
	<cfset variables.delim = variables.tabChar />
	
	
	<cfif fileExists(expandPath('results.txt'))>
		<cffile action="delete" file="#expandPath('data/temp/results.txt')#" />
	</cfif>
	<cffile action="write" file="#expandPath('data/temp/results.txt')#" output="" addnewline="no"/>
	
	<cfif application.settings.exportIncludeColumnNames>
		<cfset variables.out = "Record" & variables.delim/>
		
		<cfloop from="1" to="#arrayLen(variables.arResultsHeaders)#" index="i">
			<!--- the column name --->
			<cfset variables.out = variables.out & variables.arResultsHeaders[i] />
			<cfif i NEQ arrayLen(variables.arResultsHeaders)>
				<cfset variables.out = variables.out & variables.delim />
			</cfif>
		</cfloop>
		
		<cffile action="append" addnewline="true" file="#expandPath("data/temp/results.txt")#" output="#out#" />
	</cfif>	
		
	<cfloop from="1" to="#variables.q.recordCount#" index="k">
		<!--- The record number --->
		<cfset variables.out = NumberFormat(k,"0000") & variables.delim />
		
		<cfloop from="1" to="#arrayLen(variables.arResultsHeaders)#" index="j">
			<cfset variables.out = variables.out & variables.q[variables.arResultsHeaders[j]][k] />
			<cfif j NEQ arrayLen(variables.arResultsHeaders)>
				<cfset variables.out = variables.out & variables.delim />
			</cfif>
			
		</cfloop>
		
		<cffile action="append" addnewline="true" file="#expandPath("data/temp/results.txt")#" output="#out#" />						
	</cfloop>
	
	<cfheader name="Content-Disposition" value="attachment; filename=results.txt"> 
	<cfcontent type="text/plain" file="#expandPath('data/temp/results.txt')#">
</cflock>