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
	
	<cfif fileExists(expandPath('resultsXML.xml'))>
		<cffile action="delete" file="#expandPath('data/temp/resultsXML.xml')#" />
	</cfif>
	
	<cffile action="write" file="#expandPath('data/temp/resultsXML.xml')#" output="" addnewline="no"/>
	
	<cfset variables.out = xmlNew(false) />
	<cfset variables.out.xmlroot = xmlElemNew(variables.out,"root") />
	
	<cfloop from="1" to="#variables.q.RecordCount#" index="variables.i">
		<cfset variables.out.root.xmlChildren[variables.i] = xmlElemNew(variables.out,"row") />
		<cfloop from="1" to="#arrayLen(variables.arResultsHeaders)#" index="variables.j">
			<cfset variables.out.root.xmlChildren[variables.i].xmlChildren[variables.j] = xmlElemNew(variables.out,"field") />
			<cfset variables.out.root.xmlChildren[variables.i].xmlChildren[variables.j].xmlAttributes["name"] = variables.arResultsHeaders[variables.j] />
			<cfset variables.out.root.xmlChildren[variables.i].xmlChildren[variables.j].XmlCData = variables.q[variables.arResultsHeaders[variables.j]][i] />
		</cfloop>		
	</cfloop>
	
	
	<cffile action="write" file="#expandPath('data/temp/resultsXML.xml')#" output="#variables.out#" addnewline="no"/>
</cflock>
	
<cfheader name="Content-Disposition" value="attachment; filename=resultsXML.xml"> 
<cfcontent type="text/xml" file="#expandPath('data/temp/resultsXML.xml')#">
	
	
