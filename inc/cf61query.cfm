<!--- If form.maxrows is less than one, ignore it --->
<cfif form.maxrows LT 1>
	<cfif form.username NEQ "">
		<cfset variables.startQueryTime = getTickCount() />
			<cfquery name="variables.q" datasource="#form.ds#" timeout="#form.timeout#" username="#form.username#" password="#form.password#">
				<cfinclude template="../data/sqlText.txt" />
			</cfquery>
		<cfset variables.totalQueryTime = getTickCount() - variables.startQueryTime />
	<cfelse>
		<cfset variables.startQueryTime = getTickCount() />
			<cfquery name="variables.q" datasource="#form.ds#" timeout="#form.timeout#">
				<cfinclude template="../data/sqlText.txt" />
			</cfquery>
		<cfset variables.totalQueryTime = getTickCount() - variables.startQueryTime />
	</cfif>
<!--- otherwise use it --->
<cfelse>
	<cfif form.username NEQ "">
		<cfset variables.startQueryTime = getTickCount() />
			<cfquery name="variables.q" datasource="#form.ds#" maxrows="#form.maxrows#" timeout="#form.timeout#" username="#form.username#" password="#form.password#">
				<cfinclude template="../data/sqlText.txt" />
			</cfquery>
		<cfset variables.totalQueryTime = getTickCount() - variables.startQueryTime />
	<cfelse>
		<cfset variables.startQueryTime = getTickCount() />
			<cfquery name="variables.q" datasource="#form.ds#" maxrows="#form.maxrows#" timeout="#form.timeout#">
				<cfinclude template="../data/sqlText.txt" />
			</cfquery>
		<cfset variables.totalQueryTime = getTickCount() - variables.startQueryTime />
	</cfif>
</cfif>
