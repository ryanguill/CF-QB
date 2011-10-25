<cfif NOT structKeyExists(url,"id")>
	Sorry, your query did not have any records.  Return to the qbrowser page and run another query.
	<cfabort />	
</cfif>

<cflock name="resultshtml" timeout="30" type="exclusive">
	
	<cfparam name="url.lowercaseColumnnames" default="False" />
	<cfset variables.arResults = session.resultsHandler.getRecordsetForID(url.id) />
	<cfset variables.q = variables.arResults[2] />
	<cfset variables.recordsetID = variables.arResults[1] />
	<cfset variables.ts = variables.arResults[3] />
	<!--- <cfset variables.arResultsHeaders = ListToArray(variables.q.columnlist) /> --->
	<cfset variables.arResultsHeaders = variables.q.getColumnNames() />
	<cfset variables.newline = chr(10) & chr(13) />

	
	<cfset variables.tab = chr(9) />
	
	<cfset variables.out = "" />

	<cfset variables.out = variables.out & "<table>" & variables.newline />
	<cfset variables.out = variables.out & variables.tab & "<tr>" & variables.newline />
	<cfloop from="1" to="#arrayLen(variables.arResultsHeaders)#" index="i">
		<cfset variables.out = variables.out & variables.tab & variables.tab & "<th>" & variables.newline />
		<cfif url.lowercaseColumnnames>
			<cfset variables.out = variables.out & variables.tab & variables.tab & variables.tab & lcase(variables.arResultsHeaders[i]) & variables.newline />
		<cfelse>
			<cfset variables.out = variables.out & variables.tab & variables.tab & variables.tab & variables.arResultsHeaders[i] & variables.newline />
		</cfif>
		<cfset variables.out = variables.out & variables.tab & variables.tab & "</th>" & variables.newline />
	</cfloop>
	<cfset variables.out = variables.out & variables.tab & "</tr>" & variables.newline />
	<cfset variables.out = variables.out & variables.tab & '<cfloop query="queryvariable">' & variables.newline />
	<cfset variables.out = variables.out & variables.tab & variables.tab & "<tr>" & variables.newline />
	<cfloop from="1" to="#arrayLen(variables.arResultsHeaders)#" index="i">
		<cfset variables.out = variables.out & variables.tab & variables.tab & variables.tab & "<th>" & variables.newline />
		<cfif url.lowercaseColumnnames>
			<cfset variables.out = variables.out & variables.tab & variables.tab & variables.tab & variables.tab & "##queryvariable." & lcase(variables.arResultsHeaders[i]) & "##" & variables.newline />
		<cfelse>
			<cfset variables.out = variables.out & variables.tab & variables.tab & variables.tab & variables.tab & "##queryvariable." & variables.arResultsHeaders[i] & "##" & variables.newline />
		</cfif>
		<cfset variables.out = variables.out & variables.tab & variables.tab & variables.tab & "</th>" & variables.newline />
	</cfloop>
	<cfset variables.out = variables.out & variables.tab & variables.tab & "</tr>" & variables.newline />
	<cfset variables.out = variables.out & variables.tab & "</cfloop>" & variables.newline />
	<cfset variables.out = variables.out & "</table>" & variables.newline />
	
	<cfoutput>
		<cfif url.lowercasecolumnnames>
			<a href="http://#cgi.HTTP_HOST##cgi.SCRIPT_NAME#?id=#url.id#&lowercasecolumnnames=false">Do not lowercase columnnames</a>		
		<cfelse>
			<a href="http://#cgi.HTTP_HOST##cgi.SCRIPT_NAME#?id=#url.id#&lowercasecolumnnames=true">lowercase columnnames</a>		
		</cfif>

		<textarea cols="150" rows="45">#htmleditformat(variables.out)#</textarea>
	</cfoutput>
	
	
</cflock>