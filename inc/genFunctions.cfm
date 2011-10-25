<!--- 
===========================================================
Title: 			General Functions
FileName: 		include/genFunctions.cfm
Version:		0.0.1
Author:			Ryan Guill, Brian Bockhold
CreatedOn:		09/22/05
LastModified:	09/22/05

Purpose:

Dependancies:

Assumptions:

Outline:


ChangeLog:

===========================================================
 --->

<cffunction name="qparam" access="public" returntype="void" output="true">
	<cfargument name="cfsqltype" type="String" required="false" default="cf_sql_varchar" />
	<cfargument name="value" type="string" required="True" default="" />
	
	<cfset VAR type = arguments.cfsqltype />
	
	<cfif left(type,7) NEQ "cf_sql_">
		<cfset type = "cf_sql_" & type />
	</cfif>
	
	<cfqueryparam cfsqltype="#type#" value="#arguments.value#" />

</cffunction>

<cffunction name="isValidQuery" access="public" returntype="boolean" output="false">
	<cfargument name="sqlQuerytext" type="String" required="true" />
	
	<cfset VAR qry = arguments.sqlQueryText />
	
	<cfif NOT application.settings.allowedSQL.update>
		<cfif findNoCase("update",qry)>
			<cfreturn False />
		</cfif>
	</cfif>
	
	<cfif NOT application.settings.allowedSQL.delete>
		<cfif findNoCase("delete",qry)>
			<cfreturn False />
		</cfif>
	</cfif>
	
	<cfif NOT application.settings.allowedSQL.insert>
		<cfif findNoCase("insert",qry)>
			<cfreturn False />
		</cfif>
	</cfif>
	
	<cfif NOT application.settings.allowedSQL.create>
		<cfif findNoCase("create",qry)>
			<cfreturn False />
		</cfif>
	</cfif>
	
	<cfif NOT application.settings.allowedSQL.drop>
		<cfif findNoCase("drop",qry)>
			<cfreturn False />
		</cfif>
	</cfif>
	
	<cfif NOT application.settings.allowedSQL.alter>
		<cfif findNoCase("alter",qry)>
			<cfreturn False />
		</cfif>
	</cfif>
	
	<cfif NOT application.settings.allowedSQL.describe>
		<cfif findNoCase("describe",qry)>
			<cfreturn False />
		</cfif>
	</cfif>
	
	<cfif NOT application.settings.allowedSQL.show>
		<cfif findNoCase("show",qry)>
			<cfreturn False />
		</cfif>
	</cfif>
	
	<cfif NOT application.settings.allowedSQL.grant>
		<cfif findNoCase("grant",qry)>
			<cfreturn False />
		</cfif>
	</cfif>
	
	<cfif NOT application.settings.allowedSQL.revoke>
		<cfif findNoCase("revoke",qry)>
			<cfreturn False />
		</cfif>
	</cfif>
	
	<cfif NOT application.settings.allowedSQL.truncate>
		<cfif findNoCase("truncate",qry)>
			<cfreturn False />
		</cfif>
	</cfif>
	
<cfreturn True />
</cffunction>


<cffunction name="makeSQLPretty" access="public" returntype="string" output="False">
	<cfargument name="sqlQueryText" type="String" required="true" />
	
	<cfset VAR out = arguments.sqlQueryText />
	
	
	<!--- STATEMENTS --->
	
	<cfset out = replaceNoCase(out,"select","<strong class=""keyword"">SELECT</strong>","all") />
	<cfset out = replaceNoCase(out,"describe ","<strong class=""keyword"">DESCRIBE </strong>","all") />
	<cfset out = replaceNoCase(out,"show ","<strong class=""keyword"">SHOW </strong>","all") />
	<cfset out = replaceNoCase(out,"from","<strong class=""keyword"">FROM</strong>","all") />
	<cfset out = replaceNoCase(out,"create","<strong class=""keyword"">CREATE</strong>","all") />
	<cfset out = replaceNoCase(out,"drop","<strong class=""keyword"">DROP</strong>","all") />
	<cfset out = replaceNoCase(out,"alter","<strong class=""keyword"">ALTER</strong>","all") />
	<cfset out = replaceNoCase(out,"grant","<strong class=""keyword"">GRANT</strong>","all") />
	<cfset out = replaceNoCase(out,"revoke","<strong class=""keyword"">REVOKE</strong>","all") />
	<cfset out = replaceNoCase(out,"truncate","<strong class=""keyword"">TRUNCATE</strong>","all") />
	<cfset out = replaceNoCase(out,"where","<strong class=""keyword"">WHERE</strong>","all") />
	<cfset out = replaceNoCase(out,"update","<strong class=""keyword"">UPDATE</strong>","all") />
	<cfset out = replaceNoCase(out,"insert","<strong class=""keyword"">INSERT</strong>","all") />
	<cfset out = replaceNoCase(out,"delete","<strong class=""keyword"">DELETE</strong>","all") />
	<cfset out = replaceNoCase(out,"between","<strong class=""keyword"">BETWEEN</strong>","all") />
	<cfset out = replaceNoCase(out,"like","<strong class=""keyword"">LIKE</strong>","all") />
	<cfset out = replaceNoCase(out,"as ","<strong class=""keyword"">AS</strong> ","all") />
	<cfset out = replaceNoCase(out,"case","<strong class=""keyword"">CASE</strong>","all") />
	<cfset out = replaceNoCase(out,"then","<strong class=""keyword"">THEN</strong>","all") />
	<cfset out = replaceNoCase(out,"else","<strong class=""keyword"">ELSE</strong>","all") />
	<cfset out = replaceNoCase(out,"end","<strong class=""keyword"">END</strong>","all") />
	<cfset out = replaceNoCase(out,"exists","<strong class=""keyword"">EXISTS</strong>","all") />	
	<cfset out = replaceNoCase(out," or ","<strong class=""keyword"">OR</strong> ","all") />
	<cfset out = replaceNoCase(out,"group by","<strong class=""keyword"">GROUP BY</strong>","all") />
	<cfset out = replaceNoCase(out,"order by","<strong class=""keyword"">ORDER BY</strong>","all") />
	<cfset out = replaceNoCase(out,"union all","<strong class=""keyword"">UNION ALL</strong>","all") />
	<cfset out = replaceNoCase(out,"union","<strong class=""keyword"">UNION</strong>","all") />
	<cfset out = replaceNoCase(out,"inner join","<strong class=""keyword"">INNER JOIN</strong>","all") />
	<cfset out = replaceNoCase(out,"left outer join","<strong class=""keyword"">LEFT OUTER JOIN</strong>","all") />
	<cfset out = replaceNoCase(out,"when","<strong class=""keyword"">WHEN</strong>","all") />
	<cfset out = replaceNoCase(out,"right outer join","<strong class=""keyword"">RIGHT OUTER JOIN</strong>","all") />
	<cfset out = replaceNoCase(out,"exception join","<strong class=""keyword"">EXCEPTION JOIN</strong>","all") />
	<cfset out = replaceNoCase(out,"join","<strong class=""keyword"">JOIN</strong>","all") />
	<cfset out = replaceNoCase(out,"having","<strong class=""keyword"">HAVING</strong>","all") />
	<cfset out = replaceNoCase(out,"outer join","<strong class=""keyword"">OUTER JOIN</strong>","all") />	
	<cfset out = replaceNoCase(out,"not ","<strong class=""keyword"">NOT</strong> ","all") />
	<cfset out = replaceNoCase(out,"distinct","<strong class=""keyword"">DISTINCT</strong>","all") />
	<cfset out = replaceNoCase(out,"in ","<strong class=""keyword"">IN</strong> ","all") />
	<cfset out = replaceNoCase(out,"and ","<strong class=""keyword"">AND</strong> ","all") />
	<cfset out = replaceNoCase(out,"||","<strong class=""keyword"">||</strong>","all") />
	<cfset out = replaceNoCase(out,"asc","<strong class=""keyword"">ASC</strong>","all") />
	<cfset out = replaceNoCase(out," desc","<strong class=""keyword""> DESC</strong>","all") />
	<cfset out = replaceNoCase(out," <> ","<strong class=""keyword""> <> </strong>","all") />
	<cfset out = replaceNoCase(out," = ","<strong class=""keyword""> = </strong>","all") />
	<cfset out = replaceNoCase(out,"+","<strong class=""keyword"">+</strong>","all") />
	<cfset out = replaceNoCase(out,"-","<strong class=""keyword"">-</strong>","all") />	
	<cfset out = replaceNoCase(out,"on ","<strong class=""keyword"">ON</strong> ","all") />
	
	
	
	<!--- CUSTOM FUNCTIONS --->
	
	<cfset out = replaceNoCase(out,"replace(","<strong class=""custFunct"">REPLACE</strong>(","all") />
	
	<!--- AGGREGATE FUNCTIONS --->
	
	<cfset out = replaceNoCase(out,"min(","<strong class=""aggFunct"">MIN</strong>(","all") />
	<cfset out = replaceNoCase(out,"sum(","<strong class=""aggFunct"">SUM</strong>(","all") />	
	<cfset out = replaceNoCase(out,"count(","<strong class=""aggFunct"">COUNT</strong>(","all") />
	<cfset out = replaceNoCase(out,"stddev(","<strong class=""aggFunct"">STDDEV</strong>(","all") />		
	<cfset out = replaceNoCase(out,"max(","<strong class=""aggFunct"">MAX</strong>(","all") />
	<cfset out = replaceNoCase(out,"avg(","<strong class=""aggFunct"">AVG</strong>(","all") />
	
	<!--- DATA MANIPULATION FUNCTIONS --->
	
	<cfset out = replaceNoCase(out,"abs(","<strong class=""dataManip"">ABS</strong>(","all") />
	<cfset out = replaceNoCase(out,"ceil(","<strong class=""dataManip"">CEIL</strong>(","all") />
	<cfset out = replaceNoCase(out,"ceiling(","<strong class=""dataManip"">CEILNG</strong>(","all") />
	<cfset out = replaceNoCase(out,"floor(","<strong class=""dataManip"">FLOOR</strong>(","all") />
	<cfset out = replaceNoCase(out,"coalesce(","<strong class=""dataManip"">COALESCE</strong>(","all") />
	<cfset out = replaceNoCase(out,"translate(","<strong class=""dataManip"">TRANSLATE</strong>(","all") />
	<cfset out = replaceNoCase(out,"int(","<strong class=""dataManip"">INT</strong>(","all") />
	<cfset out = replaceNoCase(out,"dec(","<strong class=""dataManip"">DEC</strong>(","all") />
	<cfset out = replaceNoCase(out,"integer(","<strong class=""dataManip"">INTEGER</strong>(","all") />
	<cfset out = replaceNoCase(out,"decimal(","<strong class=""dataManip"">DECIMAL</strong>(","all") />
	<cfset out = replaceNoCase(out,"round(","<strong class=""dataManip"">ROUND</strong>(","all") />
	<cfset out = replaceNoCase(out,"upper(","<strong class=""dataManip"">UPPER</strong>(","all") />
	<cfset out = replaceNoCase(out,"lower(","<strong class=""dataManip"">LOWER</strong>(","all") />
	<cfset out = replaceNoCase(out,"trim(","<strong class=""dataManip"">TRIM</strong>(","all") />
	<cfset out = replaceNoCase(out,"ltrim(","<strong class=""dataManip"">LTRIM</strong>(","all") />
	<cfset out = replaceNoCase(out,"rtrim(","<strong class=""dataManip"">RTRIM</strong>(","all") />
	<cfset out = replaceNoCase(out,"char(","<strong class=""dataManip"">CHAR</strong>(","all") />
	<cfset out = replaceNoCase(out,"substr(","<strong class=""dataManip"">SUBSTR</strong>(","all") />
	<cfset out = replaceNoCase(out,"substring(","<strong class=""dataManip"">SUBSTRING</strong>(","all") />
	<cfset out = replaceNoCase(out,"date(","<strong class=""dataManip"">DATE</strong>(","all") />
	<cfset out = replaceNoCase(out,"days(","<strong class=""dataManip"">DAYS</strong>(","all") />
	<cfset out = replaceNoCase(out,"day(","<strong class=""dataManip"">DAY</strong>(","all") />
	<cfset out = replaceNoCase(out,"week(","<strong class=""dataManip"">WEEK</strong>(","all") />
	<cfset out = replaceNoCase(out,"month(","<strong class=""dataManip"">MONTH</strong>(","all") />
	<cfset out = replaceNoCase(out,"year(","<strong class=""dataManip"">YEAR</strong>(","all") />
	<cfset out = replaceNoCase(out,"dayofweek(","<strong class=""dataManip"">DAYOFWEEK</strong>(","all") />
	<cfset out = replaceNoCase(out,"convert(","<strong class=""dataManip"">CONVERT</strong>(","all") />
	
	<!--- MISC --->
	
	
	<cfset out = REreplace(out, "('[^']*')", "<strong class=""paren"">\1</strong>", "all") />
	<cfset out = REreplace(out, "(\([^\(|^\)]*\))", "<strong class=""paren"">\1</strong>", "all") />
	<cfset out = REreplace(out, "(\/\*[^\*|^\/]*\*\/)", "<strong class=""comnt"">\1</strong>", "all") />
	
<cfreturn out />
</cffunction>



<cffunction name="findTablesInSQL" access="public" returntype="array" output="true">
	<cfargument name="sqlQueryText" type="String" required="true" />
	
	<cfset VAR out = arrayNew(2) />
	<cfset VAR tmp = structNew() />
	<cfset VAR i = 0 />
	<cfset VAR foundMatch = true />
	<cfset VAR strPos = 0 />
	<cfset VAR tmpIndex = 0 />
	
	
	<cfset foundMatch = true />
	<cfset strPos = 0 />	
	<cfloop condition="foundMatch EQ true">
		<cfset tmp = refindNoCase('FROM\s+[\w##@.]+\s*',arguments.sqlQueryText,strPos,true) />
		
		<cfloop from="1" to="#arrayLen(tmp.pos)#" index="i">
			<cfif tmp.pos[i] GT 0>
				<cfset tmpIndex = arrayLen(out) + 1 />
				<cfset out[tmpIndex][1] = trim(replaceNoCase(mid(arguments.sqlqueryText,tmp.pos[i],tmp.len[i]),"from","","all")) />
				<cfset out[tmpIndex][2] = "READ" />
				<cfset foundMatch = true />
				<cfset strPos = tmp.pos[i] + tmp.len[i] />
			<cfelse>
				<cfset foundMatch = false />
				<cfset strPos = 0 />
			</cfif>
		</cfloop>
	</cfloop>
	
	<cfset foundMatch = true />
	<cfset strPos = 0 />	
	<cfloop condition="foundMatch EQ true">
		<cfset tmp = refindNoCase('UPDATE\s+[\w##@.]+\s*',arguments.sqlQueryText,strPos,true) />
		
		<cfloop from="1" to="#arrayLen(tmp.pos)#" index="i">
			<cfif tmp.pos[i] GT 0>
				<cfset tmpIndex = arrayLen(out) + 1 />
				<cfset out[tmpIndex][1] = trim(replaceNoCase(mid(arguments.sqlqueryText,tmp.pos[i],tmp.len[i]),"UPDATE","","all")) />
				<cfset out[tmpIndex][2] = "WRITE" />
				<cfset foundMatch = true />
				<cfset strPos = tmp.pos[i] + tmp.len[i] />
			<cfelse>
				<cfset foundMatch = false />
				<cfset strPos = 0 />
			</cfif>
		</cfloop>
	</cfloop>
	
	<cfset foundMatch = true />
	<cfset strPos = 0 />	
	<cfloop condition="foundMatch EQ true">
		<cfset tmp = refindNoCase('INTO\s+[\w##@.]+\s*',arguments.sqlQueryText,strPos,true) />
		
		<cfloop from="1" to="#arrayLen(tmp.pos)#" index="i">
			<cfif tmp.pos[i] GT 0>
				<cfset tmpIndex = arrayLen(out) + 1 />
				<cfset out[tmpIndex][1] = trim(replaceNoCase(mid(arguments.sqlqueryText,tmp.pos[i],tmp.len[i]),"INTO","","all")) />
				<cfset out[tmpIndex][2] = "WRITE" />
				<cfset foundMatch = true />
				<cfset strPos = tmp.pos[i] + tmp.len[i] />
			<cfelse>
				<cfset foundMatch = false />
				<cfset strPos = 0 />
			</cfif>
		</cfloop>
	</cfloop>
	
	<cfset foundMatch = true />
	<cfset strPos = 0 />	
	<cfloop condition="foundMatch EQ true">
		<cfset tmp = refindNoCase('JOIN\s+[\w##@.]+\s*',arguments.sqlQueryText,strPos,true) />
		
		<cfloop from="1" to="#arrayLen(tmp.pos)#" index="i">
			<cfif tmp.pos[i] GT 0>
				<cfset tmpIndex = arrayLen(out) + 1 />
				<cfset out[tmpIndex][1] = trim(replaceNoCase(mid(arguments.sqlqueryText,tmp.pos[i],tmp.len[i]),"JOIN","","all")) />
				<cfset out[tmpIndex][2] = "READ" />
				<cfset foundMatch = true />
				<cfset strPos = tmp.pos[i] + tmp.len[i] />
			<cfelse>
				<cfset foundMatch = false />
				<cfset strPos = 0 />
			</cfif>
		</cfloop>
	</cfloop>
	
	<cfset foundMatch = true />
	<cfset strPos = 0 />	
	<cfloop condition="foundMatch EQ true">
		<cfset tmp = refindNoCase('TABLE\s+[\w##@.]+\s*',arguments.sqlQueryText,strPos,true) />
				
		<cfloop from="1" to="#arrayLen(tmp.pos)#" index="i">
			<cfif tmp.pos[i] GT 0>
				<cfset tmpIndex = arrayLen(out) + 1 />
				<cfset out[tmpIndex][1] = trim(replaceNoCase(mid(arguments.sqlqueryText,tmp.pos[i],tmp.len[i]),"TABLE","","all")) />
				<cfset out[tmpIndex][2] = "WRITE" />
				<cfset foundMatch = true />
				<cfset strPos = tmp.pos[i] + tmp.len[i] />
			<cfelse>
				<cfset foundMatch = false />
				<cfset strPos = 0 />
			</cfif>
		</cfloop>
	</cfloop>
	
	
	<cfdump var="#out#">
	
<cfreturn out />
</cffunction>