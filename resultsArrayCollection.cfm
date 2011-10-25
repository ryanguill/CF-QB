
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
		
	</cfsilent>
	
	<!--- if the file already exists, get rid of it... --->
	<cfif fileExists(expandPath('resultsArrayCollection.txt'))>
		<cffile action="delete" file="#expandPath('data/temp/resultsArrayCollection.txt')#" />
	</cfif>
	
	<!--- if it did exist, it doesnt now, so one way or another its not there, so we need to write a new file to output to...
		( if you are really scrutinizing my code, you will probably think that I dont need this line.  You are probably
			right, but its not huring anything either :P ) --->
	<cffile action="write" file="#expandPath('data/temp/resultsArrayCollection.txt')#" output="" addnewline="no"/>
		
	<cfset variables.out = "ac1:ArrayCollection = new ArrayCollection(" />
	
	<cffile action="append" addnewline="true" file="#expandPath("data/temp/resultsArrayCollection.txt")#" output="#variables.out#" />
	
	<cfloop from="1" to="#variables.q.recordCount#" index="k">
	
		<!--- The record number --->
		<cfset variables.out = '{row:' & NumberFormat(k,repeatString("0",len(variables.q.recordcount))) & ',' />
		
		<!--- now loop over the column names... --->
		<cfloop from="1" to="#arrayLen(variables.arResultsHeaders)#" index="j">
			<cfset variables.out = variables.out & variables.arResultsHeaders[j] & ":" & "'" & variables.q[variables.arResultsHeaders[j]][k] & "'"  />
			
			<cfif j EQ arrayLen(variables.arResultsHeaders)>
				<cfset variables.out = variables.out & "}" />
			<cfelse>
				<cfset variables.out = variables.out & "," />
			</cfif>
			
		</cfloop>
		
		<cfif k NEQ variables.q.recordCount>
			<cfset variables.out = variables.out & "," />
		<cfelse>
			<cfset variables.out = variables.out & ");" />			
		</cfif>
			
		<!--- write it out to the file --->
		<cffile action="append" addnewline="true" file="#expandPath("data/temp/resultsArrayCollection.txt")#" output="#out#" />						
	</cfloop>
	
	
	<!--- so now we have the file, so serve it up to the user! --->
	<cfheader name="Content-Disposition" value="attachment; filename=resultsArrayCollection.txt"> 
	<cfcontent type="text/text" file="#expandPath('data/temp/resultsArrayCollection.txt')#">
	
<!--- gotta release the lock so the next person can play... --->
</cflock>