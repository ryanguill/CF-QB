
<!--- Make sure an ID was passed to this page... --->
<cfif NOT structKeyExists(url,"id")>
	<!--- wouldnt hurt to at a later date add in a function isUUID() to validate the id passed... --->
	Sorry, your query did not have any records.  Return to the qbrowser page and run another query.
	<cfabort />	
</cfif>

<!--- create an exclusive lock to make sure that only one file is created and served up at a time... --->
<cflock name="resultscsv" timeout="30" type="exclusive">

	<!--- create our helper variables... --->
	<cfsilent>
		<cfset variables.arResults = session.resultsHandler.getRecordsetForID(url.id) />
		<cfset variables.q = variables.arResults[2] />
		<cfset variables.recordsetID = variables.arResults[1] />
		<cfset variables.ts = variables.arResults[3] />
		<!--- <cfset variables.arResultsHeaders = ListToArray(variables.q.columnlist) /> --->
		<cfset variables.arResultsHeaders = variables.q.getColumnNames() />
		
		<!--- dont need this following line at all, only leaving it in because
			someone may be wondering how to create a windows new line... --->
		<cfset variables.newline = chr(10) & chr(13) />
	</cfsilent>
	
	<!--- set quote and comma to a variable and then set them together to make a delimiter,
		this makes our job easier in a minute... --->
	<cfset variables.quot = chr(34) />
	<cfset variables.comma = chr(44) />
	<cfset variables.delim = variables.quot & variables.comma & variables.quot />
	
	<!--- if the file already exists, get rid of it... --->
	<cfif fileExists(expandPath('results.csv'))>
		<cffile action="delete" file="#expandPath('data/temp/results.csv')#" />
	</cfif>
	
	<!--- if it did exist, it doesnt now, so one way or another its not there, so we need to write a new file to output to...
		( if you are really scrutinizing my code, you will probably think that I dont need this line.  You are probably
			right, but its not huring anything either :P ) --->
	<cffile action="write" file="#expandPath('data/temp/results.csv')#" output="" addnewline="no"/>
	
	<!--- check the application setting to know whether or not the user wants to see column names in his ouput... --->
	<cfif application.settings.exportIncludeColumnNames>
		
		<!--- guess they do, so lets give it to them... --->
		<cfset variables.out = variables.quot & "Record" & variables.delim/>
		
		<cfloop from="1" to="#arrayLen(variables.arResultsHeaders)#" index="i">
			<!--- the column name --->
			<cfset variables.out = variables.out & variables.arResultsHeaders[i] />
			
			<cfif i NEQ arrayLen(variables.arResultsHeaders)>
				<!--- if this isnt the end, we need another delimiter, otherwise.... --->
				<cfset variables.out = variables.out & variables.delim />
			<cfelse>
				<!--- this is the end and we just need a quote. --->
				<cfset variables.out = variables.out & variables.quot />
			</cfif>
		</cfloop>
		
		<!--- lets write what we have to the file, and add a new line.  
			cf takes care of the new line for us, isn't that nice of it? --->
		<cffile action="append" addnewline="true" file="#expandPath("data/temp/results.csv")#" output="#out#" />
	</cfif>
	
	<!--- now lets loop over the rows, one by one, creating the output and writing it to the file... --->
	<cfloop from="1" to="#variables.q.recordCount#" index="k">
	
		<!--- The record number --->
		<cfset variables.out = variables.quot & NumberFormat(k,repeatString("0",len(variables.q.recordcount))) & variables.delim />
		
		<!--- now loop over the column names... --->
		<cfloop from="1" to="#arrayLen(variables.arResultsHeaders)#" index="j">
			<cfset variables.out = variables.out & variables.q[variables.arResultsHeaders[j]][k] />
			
			<cfif j NEQ arrayLen(variables.arResultsHeaders)>
				<!--- this must not be the end, so write out the delimiter --->
				<cfset variables.out = variables.out & variables.delim />
			<cfelse>
				<!--- this must be the end, so just end with a quote --->
				<cfset variables.out = variables.out & variables.quot />
			</cfif>
			
		</cfloop>
		
		<!--- write it out to the file --->
		<cffile action="append" addnewline="true" file="#expandPath("data/temp/results.csv")#" output="#out#" />						
	</cfloop>
	
	<!--- so now we have the file, so serve it up to the user! --->
	<cfheader name="Content-Disposition" value="attachment; filename=results.csv"> 
	<cfcontent type="application/vnd.ms-excel" file="#expandPath('data/temp/results.csv')#">
	
<!--- gotta release the lock so the next person can play... --->
</cflock>