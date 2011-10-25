
<!--- Make sure an ID was passed to this page... --->
<cfif NOT structKeyExists(url,"id")>
	<!--- wouldnt hurt to at a later date add in a function isUUID() to validate the id passed... --->
	Sorry, your query did not have any records.  Return to the qbrowser page and run another query.
	<cfabort />	
</cfif>

<!--- create an exclusive lock to make sure that only one file is created and served up at a time... --->


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
	
	<cfset variables.display = "" />
	
	<cfset variables.out = "ac1:ArrayCollection = new ArrayCollection(" />
	
	<cfset variables.display = variables.display & variables.out & variables.newline />
	
	<cfloop from="1" to="#variables.q.recordCount#" index="k">
	
		<!--- The record number --->
		<cfset variables.out = '{row:' & NumberFormat(k,"0000") & ',' />
		
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
		<cfset variables.display = variables.display & variables.out & variables.newline />						
	</cfloop>
	
	
	
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta http-equiv="Pragma" content="no-cache">
		<meta http-equiv="CACHE-CONTROL" content="NO-CACHE">
		<meta http-equiv="EXPIRES" content="0">
		<meta name="ROBOTS" content="NONE">
		<meta name="GOOGLEBOT" content="NOARCHIVE">
		
		<title>Title</title>
	</head>
	<body>
		<cfoutput>
			<a href="resultsArrayCollection.cfm?id=#url.id#">Download this text file</a><br />
			<textarea name="results" cols="150" rows="25" wrap="off">#variables.display#</textarea>
		</cfoutput>
	</body>
</html>