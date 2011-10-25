<!--- <cfdump var="#session.resultsHandler.getResultsArray()#" /> --->
<cfif NOT structKeyExists(url,"id")>
	<p>You tried to load this file manually.  Please return to your qBrowser and run another query.</p>
	<cfabort />
<cfelse>
	<cfset variables.arResults = session.resultsHandler.getRecordsetForID(url.id) />
	<cfset variables.q = variables.arResults[2] />
	<cfset variables.recordsetID = variables.arResults[1] />
	<cfset variables.ts = variables.arResults[3] />
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Results</title>
	
	<link rel="stylesheet" media="screen" href="inc/css/main.css" />
	
	<style type="text/css">
		body {
			background-color:#ccc;
			}
	</style>
	
	<script type="text/javascript">
		function clswin() {
			window.close();
		}
	</script>
</head>

<body>
	<table>
		<tr>
			<td style="padding:2px;">
				<cfoutput>
					Export: 
					<a href="resultscsv.cfm?id=#variables.recordsetID#"><img src="inc/img/csv.gif" border="0" alt="Save Results as CSV File" /></a><!--- // csv file --->
					<a href="resultstab.cfm?id=#variables.recordsetID#"><img src="inc/img/tab.gif" border="0" alt="Save Results as TAB File" /></a><!--- // tab delimited file --->
					<a href="resultsxml.cfm?id=#variables.recordsetID#"><img src="inc/img/xml.gif" border="0" alt="Save Results as XML File" /></a><!--- // xml file --->
				</cfoutput>
				<input type="button" onclick="javascript:clswin();" value="Close This Window" />
			</td>
		</tr>
		<tr>
			<td>
				<!--- leaving the line below in the code for easy debugging... --->
				<!--- <cfdump var="#variables.q#" label="Your Query Results" /> --->
				
				<!--- get an array of the column names in the query... --->
				<!--- <cfset variables.arResultsHeaders = ListToArray(variables.q.columnlist) /> --->
				<cfset variables.arResultsHeaders = variables.q.getColumnNames() />
				
				<!--- figure out how many cells (rows * columsn) there are in the recordset... 
						this is used to know whether we should include the abilty to do the javascript sort or not--->
				<cfset variables.numCells = ( variables.q.recordCount * arrayLen(variables.arResultsHeaders) ) />
				
				
				<cfoutput>
					
					<!--- if teh total number of cells is less than or equal to the maxsorttable value, then put in the class on the table to make the js work... --->
					<table align="left" style="background-color:##fff;" <cfif variables.numCells lte application.settings.maxsortable>class="sortable"</cfif> id="queryResults">
						<tr>
							<th>
								Row
							</th>
							
							<!--- Loop over the columns creating a column for each in the table... --->
							<cfloop from="1" to="#arrayLen(variables.arResultsHeaders)#" index="variables.i">
								<th>
									<!--- the column name --->
									#variables.arResultsHeaders[variables.i]#
								</th>
							</cfloop>
						</tr>
						
						<!--- loop over the records... creating a row for each one... --->
						<cfloop from="1" to="#variables.q.recordCount#" index="variables.k">
							<tr>
								<th>
									<!--- The record number --->
									#NumberFormat(variables.k,"0000")#
								</th>
								
								<!--- for each record, loop over the columns and dynamically get the value out... --->
								<cfloop from="1" to="#arrayLen(variables.arResultsHeaders)#" index="variables.j">
									<td>
										
										<!--- The actual value --->
										
										<!--- if the value is blank, put in a nonbreaking space for IE to play nice... --->
										<cfif trim(variables.q[variables.arResultsHeaders[variables.j]][variables.k]) EQ "">
											&nbsp;
										
										<!--- put an htmleditformat around the value to make sure that html entities in the db is displayed correctly...  --->
										<cfelse>
											#htmlEditFormat(variables.q[variables.arResultsHeaders[variables.j]][variables.k])#
										</cfif>
									</td>
								</cfloop>
							</tr>
							
							<!--- this flush allows browsers such as firefox (http://www.getfirefox.com) to get results as quickly as possible,
									but IE just ignores it.  You can savely take out the cfflush if you start having viewing problems... --->
							<cfflush interval="500" />
						</cfloop>
						
					</table>
				</cfoutput>
			</td>
		</tr>
	</table>
</body>
</html>
