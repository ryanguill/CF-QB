
<!--- If form.maxrows is less than one, ignore it --->
<cfif form.maxrows LT 1>
	
	<cfif form.qUsername NEQ "">
		<cfset variables.startQueryTime = getTickCount() />
			<cfquery name="variables.q" datasource="#form.ds#" result="variables.qdata" timeout="#form.timeout#" username="#form.qUsername#" password="#form.qPassword#">
				<cfinclude template="../data/#variables.sqlTextFile#" />
			</cfquery>
		<cfset variables.totalQueryTime = getTickCount() - variables.startQueryTime />
	<cfelse>
		<cfset variables.startQueryTime = getTickCount() />
			<cfquery name="variables.q" datasource="#form.ds#" result="variables.qdata" timeout="#form.timeout#">
				<cfinclude template="../data/#variables.sqlTextFile#" />
			</cfquery>			
		<cfset variables.totalQueryTime = getTickCount() - variables.startQueryTime />
	</cfif>
<!--- otherwise use it --->
<cfelse>
	
	<cfif form.qUsername NEQ "">
		<cfset variables.startQueryTime = getTickCount() />
			<cfquery name="variables.q" datasource="#form.ds#" result="variables.qdata" maxrows="#form.maxrows#" timeout="#form.timeout#" username="#form.qUsername#" password="#form.qPassword#">
				<cfinclude template="../data/#variables.sqlTextFile#" />
			</cfquery>			
		<cfset variables.totalQueryTime = getTickCount() - variables.startQueryTime />
	<cfelse>	
		<cfset variables.startQueryTime = getTickCount() />
			<cfquery name="variables.q" datasource="#form.ds#" result="variables.qdata" maxrows="#form.maxrows#" timeout="#form.timeout#">
				<cfinclude template="../data/#variables.sqlTextFile#" />
			</cfquery>			
		<cfset variables.totalQueryTime = getTickCount() - variables.startQueryTime />
	</cfif>
</cfif>
