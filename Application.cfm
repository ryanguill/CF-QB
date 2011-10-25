<!---
=================================================
If you want to run multiple versions of qBrowser,
change the application name below.  Do NOT change
any other settings.
=================================================
 --->
<cfsilent>

<cfapplication
		name="qBrowser_admin_dev"
		applicationtimeout="#createTimeSpan(1,0,0,0)#"
		sessionmanagement="True"
		sessiontimeout="#createTimeSpan(0,2,0,0)#"
		clientmanagement="false" />

	<!---
	=====================================================
	Read the cgi Auth Username, Abort if not allowed.
	This only applies if you are using NT Authentication.
	=====================================================
	 --->
	<!--- <cfset variables.authUser = uCase(ListLast(cgi.REMOTE_USER, '\')) /> --->
	<cfset variables.authUser = "" />

	<!--- If more users need access to this, add their names in a cfcase below --->

	<cfswitch expression="#variables.authUser#">
		<cfcase value=""/>
		<cfdefaultcase>
			<cfabort />
		</cfdefaultcase>
	</cfswitch>

	<!---
	===================================
	START: DO NOT CHANGE THESE SETTINGS
	===================================
	 --->
	<cfif structKeyExists(url,"reinit")>
		<cfif structKeyExists(application,"settings")>
			<cfset structClear(application.settings) />
		</cfif>
	</cfif>

	<cfparam name="application.settings" default="#structNew()#" />

	<cfparam name="application.settings.version" default="#structNew()#" />
	<cfparam name="application.settings.version.major" default="0" />
	<cfparam name="application.settings.version.minor" default="1" />
	<cfparam name="application.settings.version.revision" default="0" />
	<cfparam name="application.settings.version.string" default="#application.settings.version.major#.#application.settings.version.minor#.#application.settings.version.revision#" />
	
	<cfparam name="application.settings.cfVersionFull" default="#server.ColdFusion.ProductVersion#" />

		<cfif NOT structKeyExists(application.settings, "cfVersion")>
			<cfif ( ListGetAt(application.settings.cfVersionFull,1) LT 6 ) OR ( ListGetAt(application.settings.cfVersionFull,1) EQ 6 AND ListGetAt(application.settings.cfVersionFull,2) LT 1 )>
				<cfset application.settings.cfVersion = "5" />
			<cfelseif ListGetAt(application.settings.cfVersionFull,1) LT 7>
				<cfset application.settings.cfVersion = "6.1" />
			<cfelseif ListGetAt(application.settings.cfVersionFull,1) LT 8>
				<cfset application.settings.cfVersion = "7" />
			<cfelseif ListGetAt(application.settings.cfVersionFull,1) LT 9>
				<cfset application.settings.cfVersion = "8" />
			<cfelse>
				<cfset application.settings.cfVersion = "9" />
			</cfif>
		</cfif>

	<cfparam name="session.showVersionWarning" default="true" />
	
	<cfparam name="application.settings.allowedSQL" default="#structNew()#" />
	<cfparam name="application.settings.maxStoredResults" default="10" />
	
	<cfparam name="session.username" default="" />

	<cfif NOT structKeyExists(session,"resultsHandler") OR structKeyExists(url,"reinit") OR structKeyExists(url,"refreshresults")>
		<cfset session.resultsHandler = createObject("component","com.guill.handlers.resultsHandler").init(application.settings.maxStoredResults) />
	</cfif>

	<cfif NOT structKeyExists(application,"updateHandler") OR structKeyExists(url,"reinit")>
		<cfset application.updateHandler = createObject("component","com.guill.handlers.updateHandler").init() />
	</cfif>

	<cfif NOT structKeyExists(application,"dbhandler") OR structKeyExists(url,"reinit")>
		<cfset application.dbHandler = createObject("component","com.guill.handlers.dbHandler").init() />
	</cfif>
	
	<cfif NOT structKeyExists(application,"histHandler") OR structKeyExists(url,"reinit")>
		<cfset application.histHandler = createObject("component","com.guill.handlers.histHandler").init(expandpath("data/history.xml")) />
	</cfif>
	
	<!---
	=================================
	END: DO NOT CHANGE THESE SETTINGS
	=================================
	 --->

	
	<!---
	=================================================================
	The values of application.settings.pathToSQLText is the path to
	where the sql statement will be stored temporarily.  You should
	NOT change this setting unless you are moving things around.
	DO THIS AT YOUR OWN RISK.
	=================================================================
	 --->
	<cfparam name="application.settings.pathToSQLText" default="#expandPath('data/')#" />
	<!---
	=================================================================
	The values of application.settings.usernameReq is a boolean setting
	whether or not the application will required that a username and
	password be provided to run a query against ALL databases.
	=================================================================
	 --->
	<cfparam name="application.settings.usernameReq" default="false" />

	<!---
	=================================================================
	 The application.settings.maxsortable value is the maximum number
	 of *cells* that the javascript sort will be available for.  The
	 performance of the javascript sort will start to degrade rapidly
	 when using numbers higher than 1500.
	=================================================================
	 --->
	<cfparam name="application.settings.maxsortable" default="1500" />

	<!---
	=================================================================
	 You can set the default datasource that you want automatically
	 selected when you start the qBrowser here.  Leaving it blank
	 will automatically select the first datasource in the list.
	=================================================================
	 --->
	<cfparam name="application.settings.defaultDatasource" default="" />

	<!---
	=================================================================
	 You can set the default Max Rows setting to automatically select
	 this number of max rows when you start the qBrowser.  This value
	 must be an integer.
	=================================================================
	 --->
	<cfparam name="application.settings.defaultMaxRows" default="500" />

	<!---
	=================================================================
	 You can set the default timeout setting to automatically select
	 this timeout when you start the qBrowser.  This value
	 must be a positive integer or -1
	=================================================================
	 --->
	<cfparam name="application.settings.defaultTimeout" default="30" />

	<!---
	=================================================================
	 You can set the default save to history setting to automatically
	 set this value when you start the qBrowser and are logged in.  
	 This value must be a boolean, either true or false.
	=================================================================
	 --->
	<cfparam name="application.settings.defaultSaveToHistory" default="True" />

	<!---
	=================================================================
	 You can set the default textarea rows setting to automatically
	 set this value when you start the qBrowser.  This value
	 must be an integer, greater than 5
	=================================================================
	 --->
	<cfparam name="application.settings.defaultTextareaRows" default="10" />

	<!---
	=================================================================
	 DEPRECATED - THIS IS NO LONGER AN OPTION
	 You can set the default results popup to true or false, based on
	 if you want the results of your query to come up in a popup window
	 or not.  True means a popup will be used, false means the results
	 will be displayed in the same window as the query form.

	 Popups can be useful when comparing the results of two queries.
	 The default for this setting is false, possible values are true
	 and false.
	=================================================================
	 --->
	<cfparam name="application.settings.defaultResultsPopup" default="False" />

	<!---
	=================================================================
	 You can set the export include column names value to true or
	 false depending on whether or not you would like to see column
	 names in your csv, tab or xml files when you export.  This is
	 and application wide setting.  Possible values are true and
	 false. The default is true.
	=================================================================
	 --->
	<cfparam name="application.settings.exportIncludeColumnNames" default="true" />

	<!---
	=================================================================
	The value of application.settings.validateQuery sets whether or
	not the application will scan the sql for the allowed sql
	statements or not.  If you set this value to False, any user will
	be allowed to run any sql statement.  DO THIS AT YOUR OWN RISK.
	=================================================================
	 --->
	<cfparam name="application.settings.validateQuery" default="false" />
	
	<!---
	=================================================================
	The following only applies if you set the
	application.settings.validateQuery setting to true:
	
	The values of below are the settings on whether the specific
	sql statements are allowed or not.  Change the value to true if
	you want to allow that statment to be run using the application.
	Leave the value at false for statements you want to restrict.
	=================================================================
	 --->
	<cfparam name="application.settings.allowedSQL.update" default="false" />
	<cfparam name="application.settings.allowedSQL.insert" default="false" />
	<cfparam name="application.settings.allowedSQL.delete" default="false" />
	<cfparam name="application.settings.allowedSQL.drop" default="false" />
	<cfparam name="application.settings.allowedSQL.create" default="false" />
	<cfparam name="application.settings.allowedSQL.alter" default="false" />
	<cfparam name="application.settings.allowedSQL.describe" default="false" />
	<cfparam name="application.settings.allowedSQL.show" default="false" />
	<cfparam name="application.settings.allowedSQL.grant" default="false" />
	<cfparam name="application.settings.allowedSQL.revoke" default="false" />
	<cfparam name="application.settings.allowedSQL.truncate" default="false" />

	<!---
	=================================================================
	 If you change application.settings.useAllDatasources to false,
	 you can specify only the datasources you want the application
	 to bring in. You can add the specific datasources below.
	=================================================================
	 --->
	<cfparam name="application.settings.useAllDatasources" default="true" />
	
	<!---
	=================================================================
	 If you set the application.settings.useAllDatasources setting
	 to true, you will need to provide the CFAdmin password below
	 to allow the code to have access to the Admin API to load all
	 of the datasources configured in the administrator.
	 
	 You can leave this value blank if you want to provide the DSN
	 names you want to have access to.
	=================================================================
	 --->
	<cfparam name="application.settings.CFAdminPassword" default="" />


	<cfif NOT structKeyExists(application,"datasources") OR structKeyExists(url,"reinit")>
		<cfif application.settings.useAllDatasources>
			<!--- <cfset application.datasources = application.dbHandler.getDatasources() /> --->
			<cfset application.adminAPI = structNew() />
			<cfset application.adminAPI.admin = createObject("component","cfide.adminapi.administrator").login(application.settings.CFAdminPassword) />
			<cfset application.adminAPI.datasource = createObject("component","cfide.adminapi.datasource") />
			
			<cfset application.datasources = application.adminapi.datasource.getDatasources() />
		<cfelse>
			<cfset application.datasources = queryNew("name") />

			<!---
			===========================================================
			If you set application.settings.useAllDatasources to False,
			add your specific datasources below.  For each one, you need
			to add a new query row, and then querySetCell with the name
			of the datasource.  So basically, just copy the two lines
			below and fill in your datasource name for each datasource.
			===========================================================
			 --->
			<cfset queryAddRow(application.datasources) />
				<cfset querySetCell(application.datasources,"name","cfartgallery") />
			<cfset queryAddRow(application.datasources) />
				<cfset querySetCell(application.datasources,"name","cfbookclub") />
			<cfset queryAddRow(application.datasources) />
				<cfset querySetCell(application.datasources,"name","cfcodeexplorer") />
			<cfset queryAddRow(application.datasources) />
				<cfset querySetCell(application.datasources,"name","cfdocexamples") />
			

		</cfif>
	</cfif>

	
	<!---
	===========================================================
	If you add other sql statements to check for, make sure that
	you add in the appropriate handling code below.  Most of the
	time you would not change the following lines or add to them.
	===========================================================
	 --->
	<cfset application.dissallowedSQL = "" />

	<cfif NOT application.settings.allowedSQL.update>
		<cfset application.dissallowedSQL = listAppend(application.dissallowedSQL,"UPDATE") />
	</cfif>

	<cfif NOT application.settings.allowedSQL.delete>
		<cfset application.dissallowedSQL = listAppend(application.dissallowedSQL,"DELETE") />
	</cfif>

	<cfif NOT application.settings.allowedSQL.insert>
		<cfset application.dissallowedSQL = listAppend(application.dissallowedSQL,"INSERT") />
	</cfif>

	<cfif NOT application.settings.allowedSQL.create>
		<cfset application.dissallowedSQL = listAppend(application.dissallowedSQL,"CREATE") />
	</cfif>

	<cfif NOT application.settings.allowedSQL.drop>
		<cfset application.dissallowedSQL = listAppend(application.dissallowedSQL,"DROP") />
	</cfif>

	<cfif NOT application.settings.allowedSQL.alter>
		<cfset application.dissallowedSQL = listAppend(application.dissallowedSQL,"ALTER") />
	</cfif>

	<cfif NOT application.settings.allowedSQL.describe>
		<cfset application.dissallowedSQL = listAppend(application.dissallowedSQL,"DESCRIBE") />
	</cfif>

	<cfif NOT application.settings.allowedSQL.show>
		<cfset application.dissallowedSQL = listAppend(application.dissallowedSQL,"SHOW") />
	</cfif>

	<cfif NOT application.settings.allowedSQL.grant>
		<cfset application.dissallowedSQL = listAppend(application.dissallowedSQL,"GRANT") />
	</cfif>

	<cfif NOT application.settings.allowedSQL.revoke>
		<cfset application.dissallowedSQL = listAppend(application.dissallowedSQL,"REVOKE") />
	</cfif>

	<cfif NOT application.settings.allowedSQL.truncate>
		<cfset application.dissallowedSQL = listAppend(application.dissallowedSQL,"TRUNCATE") />
	</cfif>

	<!---
	=================================
	START: DO NOT CHANGE THESE SETTINGS
	=================================
	 --->
	<cfif structKeyExists(url,"reinit")>
		<cflocation url="index.cfm" />
	</cfif>
	<!---
	=================================
	END: DO NOT CHANGE THESE SETTINGS
	=================================
	 --->
</cfsilent>
<cfsetting showdebugoutput="false" />