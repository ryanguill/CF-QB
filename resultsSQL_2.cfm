<cfparam name="variables.winnewline" default="#chr(13) & chr(10)#" />
<cfparam name="variables.tab" default="#chr(9)#" />
<cfparam name="variables.space" default="#chr(32)#" />
<cfparam name="variables.doublespace" default="#chr(32)&chr(32)#" />

<!--- Make sure an ID was passed to this page... --->
<cfif NOT structKeyExists(url,"id")>
	<!--- wouldnt hurt to at a later date add in a function isUUID() to validate the id passed... --->
	Sorry, your query did not have any records.  Return to the qbrowser page and run another query.
	<cfabort />	
</cfif>

<cffunction name="pickDefaultValue" access="public" returntype="string" output="false">
	<cfargument name="cf_sql_type" type="String" required="True" />
	
	<cfswitch expression="#arguments.cf_sql_type#">
		<cfcase value="cf_sql_float,cf_sql_bigint,cf_sql_integer,DECIMAL,NUMERIC" delimiters=",">
			<cfreturn 'DEFAULT 0' />
		</cfcase>
		<cfcase value="cf_sql_char,cf_sql_varchar,VARCHAR,CHAR" delimiters=",">
			<cfreturn "DEFAULT ''" />
		</cfcase>
		<cfcase value="cf_sql_date,DATE">
			<cfreturn "DEFAULT '1970-01-01'" />
		</cfcase>
		<cfcase value="cf_sql_timestamp,TIMESTAMP">
			<cfreturn "DEFAULT '1900-01-01-00.00.00.000000'" />
		</cfcase>
		<cfdefaultcase>
			<cfreturn 'ERROR:UNKNOWN TYPE #arguments.cf_sql_type#' />
		</cfdefaultcase>
	</cfswitch>
</cffunction>

<cffunction name="wrapInQuotes" access="public" returntype="string" output="false">
	<cfargument name="value" type="string" required="True" />
	<cfargument name="cf_sql_type" type="string" required="True" />
	
	<cfswitch expression="#arguments.cf_sql_type#">
		<cfcase value="cf_sql_float,cf_sql_bigint,cf_sql_integer,DECIMAL" delimiters=",">
			<cfreturn arguments.value />
		</cfcase>
		<cfcase value="DATE">
			<!--- <cfreturn '<cfqueryparam cfsqltype="cf_sql_date" value="' & arguments.value & '" />' /> --->
			<cfreturn "'#dateFormat(arguments.value,"yyyy-mm-dd")#'" />
		</cfcase>
		<cfdefaultcase>
			<cfreturn "'" & replaceNoCase(arguments.value,"'","''","all") & "'" />
		</cfdefaultcase>
	</cfswitch>
</cffunction>


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
	
	
	
	<cfset variables.queryMetadata = getMetaData(variables.q) />
	
	<cfloop query="variables.q">
		<cfloop from="1" to="#arrayLen(variables.queryMetaData)#" index="j">
			<cfswitch expression="#variables.queryMetadata[j].typename#">
				<cfcase value="VARCHAR">
					<cfset variables.curLen = len(variables.q[variables.queryMetadata[j].name][variables.q.currentRow]) />
					<cfif structKeyExists(variables.queryMetadata[j],"max")>
						<cfif variables.curLen GT variables.queryMetaData[j].max>
							<cfset variables.queryMetadata[j].max =  variables.curLen/>
						</cfif>
					<cfelse>
						<cfif variables.curLen LT 1><cfset variables.curLen = 1></cfif>
						<cfset variables.queryMetadata[j].max =  variables.curLen/>
					</cfif>
					
				</cfcase>
				<cfcase value="DECIMAL,NUMERIC">
					<cfset variables.digits = len(listFirst(variables.q[variables.queryMetadata[j].name][variables.q.currentRow],".")) />
					<cfif listLen(variables.q[variables.queryMetadata[j].name][variables.q.currentRow],".") GT 1>
						<cfset variables.dec = len(listLast(variables.q[variables.queryMetadata[j].name][variables.q.currentRow],".")) />
					<cfelse>
						<cfset variables.dec = 0 />
					</cfif>
					
					<cfset variables.digits = variables.digits + variables.dec />
					
					<cfif structKeyExists(variables.queryMetadata[j],"digits")>
						<cfif variables.digits GT variables.queryMetaData[j].digits>
							<cfset variables.queryMetadata[j].digits = variables.digits/>
						</cfif>
					<cfelse>
						<cfif variables.digits LT 1><cfset variables.digits = 1></cfif>
						<cfset variables.queryMetadata[j].digits = variables.digits/>
					</cfif>
					
					<cfif structKeyExists(variables.queryMetadata[j],"dec")>
						<cfif variables.dec GT variables.queryMetaData[j].dec>
							<cfset variables.queryMetadata[j].dec = variables.dec/>
						</cfif>
					<cfelse>
						<cfset variables.queryMetadata[j].dec = variables.dec/>
					</cfif>
					
				</cfcase>
				<cfcase value="CHAR">
					<cfset variables.curLen = len(variables.q[variables.queryMetadata[j].name][variables.q.currentRow]) />
					<cfif structKeyExists(variables.queryMetadata[j],"max")>
						<cfif variables.curLen GT variables.queryMetaData[j].max>
							<cfset variables.queryMetadata[j].max =  variables.curLen/>
						</cfif>
					<cfelse>
						<cfif variables.curLen LT 1><cfset variables.curLen = 1></cfif>
						<cfset variables.queryMetadata[j].max =  variables.curLen/>
					</cfif>
				</cfcase>
				
				<!--- <cfcase value="DATE">
					<cfdump var="#variables.q[variables.queryMetadata[j].name][variables.q.currentRow]#"><br />
					<cfset querySetCell(variables.q,variables.queryMetadata[j].name,dateFormat(variables.q[variables.queryMetadata[j].name][variables.q.currentRow],"mm/dd/yyyy"),variables.q.currentRow) />
					<cfdump var="#variables.queryMetadata[j].name#">
					<cfdump var="#dateFormat(variables.q[variables.queryMetadata[j].name][variables.q.currentRow],"yyyy-mm-dd")#">
					<cfdump var="#variables.q.currentRow#"><br />
					<cfdump var="#variables.q[variables.queryMetadata[j].name][variables.q.currentRow]#">
					<cfabort />
				</cfcase> --->
				
				<cfdefaultcase>
					
				</cfdefaultcase>
			</cfswitch>
		</cfloop>
	</cfloop>
	
	
	
	<cfset variables.i = 0 />
	<cfset variables.tableDoesNotExist = false />
	
	<cftry>
		<cfquery name="checkTable" datasource="#url.dsn#">
			select 1 from #lcase(url.library)#/#lcase(url.filename)#
		</cfquery>
	<cfcatch>
		<cfset variables.tableDoesNotExist = true />
	</cfcatch>
	</cftry>
	<cfoutput>
	<cfif variables.tableDoesNotExist>
		
		<!--- <cfquery name="createTable" datasource="#url.dsn#"> --->		
		<cfsavecontent variable="variables.createTable">
			/*CREATE TABLE #lcase(url.library)#/#lcase(url.filename)#*/
			CREATE 
				TABLE #lcase(url.library)#/#lcase(url.filename)#
			(
				
				<cfloop array="#variables.queryMetadata#" index="column">			
					<cfset variables.i++ />
					<cfif variables.i NEQ 1>#variables.tab##variables.tab#, <cfelse>#variables.doubleSpace#</cfif>
					#lcase(replaceNoCase(column.name,chr(35),chr(35)&chr(35)))#
						#variables.tab#
					<cfswitch expression="#column.typename#">
						<cfcase value="CHAR">
							CHAR (#column.max#)
						</cfcase>
						<cfcase value="VARCHAR">
							VARCHAR (#column.max#)
						</cfcase>
						<cfcase value="DECIMAL">
							DECIMAL (#column.digits#,#column.dec#)
						</cfcase>
						<cfcase value="NUMERIC">
							DECIMAL (#column.digits#,#column.dec#)
						</cfcase>
						<cfdefaultcase>
							#column.typename#
						</cfdefaultcase>
					</cfswitch>					
					#variables.tab#NOT NULL#variables.tab#
					
					#pickDefaultValue(column.typename)#
					#variables.winnewline#			
				</cfloop>
			)
			RCDFMT #left(lcase(url.filename),2)#rf#mid(lcase(url.filename),5,len(lcase(url.filename)))#		
		</cfsavecontent>
		
		
		<textarea cols="150" rows="15" wrap="off">#variables.createtable#</textarea>
		
		
		<cfquery name="createTable" datasource="#url.dsn#">
			#preserveSingleQuotes(variables.createTable)#
		</cfquery>
	<cfelse>
		This table already exists.  Please chose another tablename.
		<cfabort />
	</cfif>
	
	<cfset variables.i = 0 />
	
	<cfsavecontent variable="variables.insertStatement">
		INSERT INTO
			#variables.tab##lcase(replaceNoCase(url.library,chr(35),chr(35)&chr(35)))#/#lcase(replaceNoCase(url.filename,chr(35),chr(35)&chr(35)))#
		(
		<cfloop array="#variables.queryMetaData#" index="column">
			<cfset variables.i++ />
			#variables.tab#<cfif variables.i NEQ 1>,#variables.space#<cfelse>#variables.doublespace#</cfif>#lcase(replaceNoCase(column.name,chr(35),chr(35)&chr(35)))#<cfif variables.i NEQ arrayLen(variables.queryMetaData)>#variables.winnewline#</cfif>
		</cfloop>
		)
		
		values
		
		<cfloop query="variables.q">
			<cfset variables.i = 0 />
			<cfif variables.q.currentRow NEQ 1>,</cfif>
			(<cfloop array="#variables.queryMetaData#" index="column"><cfset variables.i++ /><cfif variables.i NEQ 1>,#variables.space#<cfelse>#variables.doublespace#</cfif>#wrapInQuotes(variables.q[column.name][variables.q.currentRow],column.typename)#</cfloop>)
		</cfloop>

	</cfsavecontent>
	
	<textarea cols="150" rows="15" wrap="off">#variables.insertStatement#</textarea>
	
	<cfquery name="insertData" datasource="#url.dsn#">
		#preserveSingleQuotes(variables.insertStatement)#
	</cfquery>
	
	
	Done. You can now query the #url.library#/#url.filename# file on the DSN #url.dsn#.

	</cfoutput>
	