<cfprocessingdirective suppresswhitespace="true">
<cfsetting showdebugoutput="false" />
<cfsilent>
<!---
===================================
START: DO NOT EDIT THESE VALUES
===================================
 --->
	<!--- Include the general functions --->
	<cfinclude template="inc/genFunctions.cfm" />

	<!--- if the user is logging out,
		just set thier username to [empty string]
		and relocate back to the index --->
	<cfif structKeyExists(url,"logout")>
		<cfset session.username = "" />
		<cflocation url="index.cfm" />
	</cfif>


	<cfif structKeyExists(url,"hideVersionWarning")>
		<cfset session.showVersionWarning = False />
		<cflocation url="index.cfm" />
	</cfif>

	<cfparam name="form.sqlQuery" default="" />
	<cfparam name="form.qusername" default="" />
	<cfparam name="form.qpassword" default="" />
	<cfparam name="form.ds" default="#application.settings.defaultDatasource#" />
	<cfparam name="form.otherDatabase" default="" />
	<cfparam name="form.maxrows" default="#application.settings.defaultMaxRows#" />
	<cfparam name="form.timeout" default="#application.settings.defaultTimeout#" />
	<cfparam name="form.saveToHist" default="#application.settings.defaultSaveToHistory#" />
	<cfparam name="form.textareaRows" default="#application.settings.defaultTextareaRows#" />
	<cfparam name="form.resultsPopup" default="#application.settings.defaultResultsPopup#" />

	<cfparam name="session.lastsql" default="" />
	<cfparam name="variables.index" default="0" />
	<cfparam name="variables.err" default="false" />
	<cfparam name="variables.arResultsHeaders" default="#arrayNew(1)#" />
	<cfparam name="variables.arResults" default="#arrayNew(1)#" />
	<cfparam name="variables.numscells" default="0" />
	<cfset variables.sqlTextFile = variables.authUser & "_sqlText.txt" />

	<cfif NOT fileExists(expandPath("data/#variables.sqlTextFile#")) >
		<cffile action="write" file="#expandPath('data/#variables.sqlTextFile#')#" output="" />
	</cfif>

	<cfset variables.regex = "\s\w+/\w+[\s)]?" />
	<cfset variables.matchlocations = arrayNew(2) />
	<cfset variables.matches = structNew() />
	<cfset variables.startPos = 1 />
	<cfloop from="1" to="20" index="i">
		<cfset variables.match = REFindNoCase(variables.regex,form.sqlquery,variables.startPos,true) />
		<cfif variables.match.pos[1] NEQ 0>
			<cfset variables.matchlocations[i][1] = variables.match.len[1] />
			<cfset variables.matchlocations[i][2] = variables.match.pos[1] />
			<cfset variables.startPos = variables.match.pos[1] + variables.match.len[1] />
		<cfelse>
			<cfbreak />
		</cfif>
	</cfloop>

	<cfloop from="1" to="#arrayLen(variables.matchlocations)#" index="i">
		<cfset variables.key = trim(replaceNoCase(mid(form.sqlQuery,variables.matchlocations[i][2],variables.matchlocations[i][1]),")","","all")) />
		<cfset variables.matches[variables.key] = arrayNew(1) />
		<cfset variables.matches[variables.key][1] = trim(listFirst(variables.key,"/")) />
		<cfset variables.matches[variables.key][2] = trim(listLast(variables.key,"/")) />
	</cfloop>

	<cfset variables.tablesArray = findTablesInSQL(form.sqlQuery) />
<!---
===================================
END: DO NOT EDIT THESE VALUES
===================================
 --->
</cfsilent>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>qBrowser</title>

	<link rel="stylesheet" media="screen" href="inc/css/main.css" />

	<script type="text/javascript">
		<!-- //
		function oHistory() {
			window.open("sqlHistory.cfm","history","width=750,height=550,status,scrollbars,resizable");
		}

		function oLibrary() {
			window.open("sqlLibrary.cfm","library","width=750,height=550,status,scrollbars,resizable");
		}

		function oHelp(){
			window.open("help.cfm", "help", "width=750,height=550,status,scrollbars,resizable");
		}

		function oRef() {
			window.open("reference.cfm","reference","width=750,height=550,status,scrollbars,resizable");
		}

		function oResults(uuid,tick) {
			lnk = "externalResults.cfm?id=" + uuid;
			winName = "w" + tick;
			window.open(lnk,winName,"width=750,height=550,status,scrollbars,resizable");
		}

		function increaseAreaSize() {
			ta = document.getElementById('sqlQuery');
			
			curRows = ta.attributes.rows.value;
			incrementBy = 5;


			ta.attributes.rows.value = parseInt(curRows) + parseInt(incrementBy);
			document.qBrowserForm.textarearows.value = ta.attributes.rows.value;

		}

		function decreaseAreaSize() {
			ta = document.getElementById('sqlQuery');


			curRows = ta.attributes.rows.value;
			decrementBy = 5;

			if ( curRows > 5) {
				ta.attributes.rows.value = parseInt(curRows) - parseInt(decrementBy);
				document.qBrowserForm.textarearows.value = ta.attributes.rows.value;
			}

		}

		// -->
	</script>

	<script type="text/javascript" src="inc/js/sorttable.js"></script>
</head>

<body onload="document.qBrowserForm.otherDatabase.focus()">
	<!--- If javascript is not enabled, show them a message begging them to turn it on... --->
	<noscript>
		<fieldset class="error">
			<h3>Javascript is Not Enabled!</h3>
			<p>You really need to enable javascript for this site, it will work much better if you do.</p>
		</fieldset>
	</noscript>

	<!--- Check the coldfusion version here, and show the appropriate message if applicable. --->
	<cfswitch expression="#application.settings.cfVersion#">
		<cfcase value="5">
			<fieldset class="error">
				<h3>You must be running at least CF 6.1</h3>
				<p>Your version of CF is too old.  Please upgrade to use this application.  I'll be surprised if you even made it to this message.</p>
			</fieldset>
			<cfabort />
		</cfcase>
		<cfcase value="6.1">
			<cfif session.showVersionWarning>
				<fieldset class="error">
					<h3>You are running CF 6.1</h3>
					<p>This application was designed to work with CF 7 or newer.  You can use this application, but some of the features have been disabled.  Please upgrade to CF 7 or newer to use all features.</p>
					<p><a href="index.cfm?hideVersionWarning=true">Hide this warning</a>
				</fieldset>
			</cfif>
		</cfcase>
		<cfdefaultcase />
	</cfswitch>




<!--- If form.action exists, see what the action is --->
<cfif structKeyExists(form,"action")>

	<!--- If the action is runquery, this is our money maker.   --->
	<cfif form.action EQ "runQuery">

		<!--- Trim the query and see if it is blank --->
		<cfif trim(form.sqlQuery) NEQ "">

			<!--- Trim the form variables --->
			<cfset form.sqlQuery = trim(form.sqlQuery) />
			<cfset form.qUsername = trim(form.qUsername) />
			<cfset form.ds = trim(form.ds) />
			<cfset form.timeout = trim(form.timeout) />
			<cfset form.qPassword = trim(form.qPassword) />

			<cfif len(trim(form.otherDatabase))>
				<cfset form.ds = trim(form.otherDatabase) />
			</cfif>

			<!--- check If we need to validate this query first to check for invalid sql --->
			<cfif NOT application.settings.validateQuery OR ( application.settings.validateQuery and isValidQuery(form.sqlQuery) )>
				
				<!--- Write the sql to a txt file... --->
				<cffile action="append" file="#expandPath('data/#variables.sqlTextFile#')#" output="#form.sqlQuery#" />

				<!--- use a lock to make sure we dont get multiple sql statements trying to run at one time --->
				<cflock name="qbrowser2Query" type="exclusive" timeout="30">
					<cftry>

						<!--- If cfversion is 6.1, we have to leave out the result attribute --->
						<cfif application.settings.cfVersion EQ "6.1">
							<cfinclude template="inc/cf61query.cfm" />

						<!--- else, we must be using cf 7 --->
						<cfelse>
							<cfinclude template="inc/cf7query.cfm" />
						</cfif>

					<!--- Catch any errors --->
					<cfcatch type="Any">

						<!--- Let the page know that an error occured so that we dont try to show the results of the query, that didnt run! --->
						<cfset variables.err = true />

						<fieldset class="error">
							<cfoutput>
								<center><h3>ERROR</h3></center>
								 <!--- The diagnostic message from ColdFusion MX. --->
								 #cfcatch.message#<br />
								 Caught an exception, type = #CFCATCH.TYPE#<br />
								 #cfcatch.detail#<br />

							</cfoutput>
						</fieldset>


						<!--- Get rid of the sql in the text file --->
						<cffile action="delete" file="#expandPath('data/#variables.sqlTextFile#')#" />
						<cffile action="write" file="#expandPath('data/#variables.sqlTextFile#')#" output=""/>
					</cfcatch>
					</cftry>

				<!--- release the lock... --->
				</cflock>

				<!--- If the query ran correctly, get rid of the sql in the text file --->
				<cffile action="delete" file="#expandPath('data/#variables.sqlTextFile#')#" />
				<cffile action="write" file="#expandPath('data/#variables.sqlTextFile#')#" output=""/>

			<!--- Else the query contains some bad words... --->
			<cfelse>

				<!--- the query is not valid for some reason: --->

				<!--- Let the page know that an error occured so that we dont try to show the results of the query, that didnt run! --->
				<cfset variables.err = true />

				<!--- tisk, tisk! --->
				<fieldset class="error">
					<h3>Sorry, the following statements are not allowed: <cfoutput>#application.dissallowedSQL#</cfoutput>.</h3>
				</fieldset>
			</cfif>


			<!--- 
				If form.saveToHist is true... 
				And there were no errors with the sql...
				and the person is logged in...
				and the trimmed sql query is not the last sql ran...--->
			<cfif form.saveToHist AND NOT variables.err AND len(trim(session.username)) AND trim(form.sqlQuery) NEQ session.lastsql>

				<!--- store the query with the username --->
				<cfset application.histHandler.addSQLForUser(lcase(session.username),trim(form.sqlQuery)) />

				<!--- set the last sql to the current sql --->
				<cfset session.lastsql = trim(form.sqlQuery) />
				
			</cfif>

			<!--- Check if we need to save to the library --->

			<!--- 
				if form.saveToLib is true... 
				and there were no errors with the sql--->
			<cfif form.saveToLib AND NOT variables.err>
		
				<!--- store the query with the username "all" --->
				<cfset application.histHandler.addSQLForUser("all",trim(form.sqlQuery)) />
		
			</cfif>

		<!--- else the query was blank, so error out --->
		<cfelse>

			<!--- Why are you running a blank query? --->
			<cfset variables.err = True />
		</cfif>

	<!--- oh, the form.action isnt runQuery, so lets see if the user is trying to login --->
	<cfelseif form.action EQ "login">

		<!--- Okay, store the username as lowercase (for the xml searching...) --->
		<cfset session.username = lcase(form.user) />
	</cfif>

<!--- close out the check for form.action --->
</cfif>

<!---
===================================================
This is the start of the output to the screen, this
is the form that the user fills out
===================================================
 --->

<table border="0" cellpadding="0" cellspacing="0" align="left" style="background-color:#ccc;" width="1000">

	<!--- If the user is not logged in, give them the opportunity... --->
	<cfif session.username eq "">
		<form action="index.cfm" method="post" name="loginForm">
			<tr>
				<td>
					<table border="1" >
						<tr>
							<td>
								To Save your History: Login as:
							</td>
							<td>
								<cfoutput>
								<input type="text" name="user" value="#variables.authuser#" size="40" />
								</cfoutput>
							</td>
								<input type="hidden" name="action" value="login" />
							<td>
								<input type="submit" value="login" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</form>
	</cfif>

	<!--- start the main form... --->
	<cfform action="index.cfm##results" method="post" name="qBrowserForm">
		<tr>
			<td>
				<table border="0" width="900" cellpadding="0" cellspacing="0">
					<tr class="welcomeBar">
						<td align="left">
							<a name="top" style="font-weight:bold;">Welcome To qBrowser<cfif session.username NEQ "">, <cfoutput>#session.username#</cfoutput></cfif>.</a>
							<a href="index.cfm?reinit=true" style="font-size:10pt;">Refresh</a>&nbsp;&nbsp;
							<a href="javascript:oHelp();" style="font-size:10pt;">Help</a>&nbsp;&nbsp;
						
							<a href="javascript:oRef();" style="font-size:10pt;">SQL Reference</a>&nbsp;&nbsp;
							<!---<a href="/tableDefs/" style="font-size:10pt;" target="_blank">Table Definitions</a>--->

							<!--- if the user is logged in, give them the chance to log out... --->
							<cfif session.username NEQ "">&nbsp;&nbsp;<a href="index.cfm?logout=true" style="font-size:10pt;">Logout</a></cfif>

						</td>
						<td align="right" valign="bottom">
							&nbsp;
						</td>
					</tr>
					<!--- <tr>
						<td>
							<!--- Tell the user what version they are running, and let them know if there is a new version available... --->
							<cfoutput>
								Current Version: #application.settings.version.string#
								<cfif application.updateCheck.result EQ "True">
									<a href="http://www.ryanguill.com/docs/" target="_blank" style="background-color:##fff;">Update Available! (#application.updateCheck.newestVersion#)</a>
								</cfif>
							</cfoutput>
						</td>
					</tr> --->
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table border="0" width="900">
					<tr>
						<td>
							<label for="ds">Datasource:</label>
							<!--- <cfselect name="ds" id="ds" query="application.datasources" value="name" selected="#form.ds#" /> --->
							<select name="ds" id="ds">
							<cfoutput>
							<cfloop collection="#application.datasources#" item="variables.key">
								<option value="#variables.key#" <cfif variables.key EQ form.ds>selected="true"</cfif>>#variables.key#</option>
							</cfloop>
							</cfoutput>
							</select>
							<!--- <cfif variables.authUser EQ "RGUILL">
								<select name="ds" id="ds">
									<option value="JTNMRKT_RGUILL">JTNMRKT_RGUILL</option>
									<option value="JTN9999">JTN9999</option>
									<option value="JTN9990">JTN9990</option>
								</select>
							<cfelse>
								<cfselect name="ds" id="ds" query="application.datasources" value="name" selected="#form.ds#" />
							</cfif> --->
						</td>
						<td>
							<label for="maxrows">MaxRows:</label>
							<cfinput type="text" name="maxrows" id="maxrows" size="4" value="#form.maxrows#" required="True" validate="integer" message="Please enter an integer between 0 and 1000 for maxrows. If you dont want to use maxrows, set it to 0" range="-1,1000" />
						</td>
						<td>
							<label for="timeout">Timeout (sec):</label>
							<cfinput type="text" name="timeout" id="timeout" size="4" value="#form.timeout#" required="True" validate="integer" message="Please enter an integer between 1 and 1120 for timeout." range="1,111120" />
						</td>
						<td>
							Save to library:
							<cfinput type="radio" name="saveToLib" id="saveToLibYes" value="true" />
							<label for="saveToLibYes">Yes</label>
							<cfinput type="radio" name="saveToLib" id="saveToLibNo" value="false" checked="True" />
							<label for="saveToLibNo">No</label>
						</td>
						<td>
							<input type="button" name="openLibrary" onclick="oLibrary()" value="Library" />
						</td>
					</tr>
					<tr>
						<td>
							<label for="otherDatabase">Other Database:</label>
							<cfinput type="text" name="otherDatabase" id="otherDatabase" value="#form.otherDatabase#" size="10" />
						</td>
						<td>
							<label for="username">Username:</label>
							<cfinput type="text" name="qusername" id="qusername" value="#form.qUsername#" required="#application.settings.usernameReq#" size="10" />
						</td>
						<td>
							<label for="password">Password:</label>
							<cfinput type="password" name="qpassword" id="qpassword" value="#form.qPassword#" required="#application.settings.usernameReq#" size="10" />
						</td>


						<!--- If the user is logged in, give them the opportunity to save queries to thier history... --->
						<cfif session.username NEQ "">
							<td>
								Save to History:
								<cfinput type="radio" name="saveToHist" id="saveToHistYes" value="true" checked="#form.saveToHist#" />
								<label for="saveToHistYes">Yes</label>
								<cfinput type="radio" name="saveToHist" id="saveToHistNo" value="false" checked="#not(form.saveToHist)#" />
								<label for="saveToHistNo">No</label>
							</td>
							<td>
								<input type="button" name="openHistory" onclick="oHistory()" value="history" />
							</td>

						<!--- otherwise, dont give them the chance... --->
						<cfelse>
							<td colspan="2">&nbsp;

							</td>
						</cfif>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<cfoutput>
					Your SQL Statement: <a href="javascript:increaseAreaSize();">[+]</a> / <a href="javascript:decreaseAreaSize();">[-]</a><br />
					<textarea id="sqlQuery" name="sqlQuery" cols="150" rows="#form.textarearows#" style="font-size:10pt;" wrap="off">#form.sqlQuery#</textarea>
				</cfoutput>
			</td>
		</tr>
			<cfoutput>
				<input type="hidden" name="Action" value="runQuery" /><!--- // tell the catching code what we are trying to do... --->
				<input type="hidden" name="textarearows" id="textarearows" value="#form.textarearows#" /><!--- // track how many rows the user wants in thier textara... --->
			</cfoutput>
		<tr>
			<td>
				<table width="100%">
					<tr>
						<td align="left" width="15%">
							<input type="submit" name="Execute" value="Execute (alt-e)" accesskey="e" /><!--- accesskey allows the user to hit alt + the key defined to hit this submit button. --->
						</td>
						<td align="left">
							<!---
							Open Results in Popup:
							<cfinput type="radio" name="resultsPopup" id="resultsPopupYes" value="true" checked="#form.resultsPopup#" />
							<label for="resultsPopupYes">Yes</label>
							<cfinput type="radio" name="resultsPopup" id="resultsPopupNo" value="false" checked="#NOT(form.resultsPopup)#" />
							<label for="resultsPopupNo">No</label>
							--->
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</cfform>


<!---
==========================================
This is the results section.  We do not
want to show anything else below this line
(except for the closing table tag) if there
was not a successful query ran.
==========================================
 --->

 	<!--- Check to make sure there was no errors --->
	<cfif NOT variables.err>

		<!--- we want to make sure a form was actually posted, and someone tried to run a query. --->
		<cfif structKeyExists(form, "action") AND form.action EQ "runQuery">
			<tr>
				<td>
					<!--- put this named anchor here so that we can position directly to this area when they submit the form... --->
					<a name="results">&nbsp;</a>
				</td>
			</tr>
			<tr>
				<td>
					<cfoutput>
						<table border="0" cellpadding="0" cellspacing="0" align="left" width="100%">
							<tr>
								<td colspan="2">
									<strong>Your Query</strong> <a href="##top">Top</a><!--- // let the user go back to the top with a click if they want... --->
								</td>
							</tr>
							<tr>
								<td>
									Datasource:
								</td>
								<td>
									<strong>#form.ds#</strong>
								</td>
							</tr>

							<!--- If the cf version is 6.1, we have to do without the results attribute... --->
							<cfif application.settings.cfVersion EQ "6.1">
								<tr style="background-color:##fff;">
									<td valign="top" width="100">
										SQL:
									</td>
									<td>
										<!--- <pre width="900">#makeSQLPretty(trim(form.sqlQuery))#</pre> --->
										<textarea name="code2" class="sql" rows="5" cols="125">#trim(form.sqlQuery)#</textarea>
									</td>
								</tr>
								<cfif structKeyExists(variables,"totalQueryTime")>
									<tr>
										<td>
											TC Exec.:
										</td>
										<td>
											<em>#variables.totalQueryTime# ms. (includes processing time for cfinclude)</em>
										</td>
									</tr>
								</cfif>
								<tr>
									<td>
										Record Count:
									</td>
									<td>
										<em>#variables.q.recordcount# record<cfif variables.q.recordcount NEQ 1>s</cfif></em>
									</td>
								</tr>

							<!--- oh, we must be using cfmx 7!  lets show them some more information... --->
							<cfelse>
								<tr style="background-color:##fff;">
									<td valign="top" width="100">
										SQL:
									</td>
									<td>
										<!--- <pre width="900">#makeSQLPretty(variables.qdata.sql)#</pre> --->
										<textarea name="code" class="sql" rows="5" cols="125">#variables.qdata.sql#</textarea>
									</td>
								</tr>
								<tr>
									<td>
										Exec. Time:
									</td>
									<td>
										<em>#variables.qData.executiontime# ms. (time reported by results struct)</em>
									</td>
								</tr>
								<cfif structKeyExists(variables,"totalQueryTime")>
									<tr>
										<td>
											TC Exec.:
										</td>
										<td>
											<em>#variables.totalQueryTime# ms. (includes processing time for cfinclude)</em>
										</td>
									</tr>
								</cfif>
								<tr>
									<td>
										Record Count:
									</td>
									<td>
										<em>#variables.qData.recordcount# record<cfif variables.qData.recordcount NEQ 1>s</cfif></em>
									</td>
								</tr>
								<cfif structKeyExists(variables.qData,"sqlparameters")>
									<tr>
										<td valign="top">
											Params:
										</td>
										<td>
											<cfloop from="1" to="#arrayLen(variables.qData.sqlparameters)#" index="variables.i">
												<em>(#i#)</em> #variables.qData.sqlParameters[i]#<br />
											</cfloop>
										</td>
									</tr>
								</cfif>
								<!---
								<tr>
									<td valign="top">
										Table Defs:
									</td>
									<td>
										<table>
											<cfloop from="1" to="#arrayLen(variables.tablesArray)#" index="variables.item">
												<tr>
													<td>
														<cfif findNoCase(".",variables.tablesArray[variables.item][1])>
															<a href="/dbview/table.cfm?dsn=#form.ds#&table=#listLast(variables.tablesArray[variables.item][1],".")#&schema=#listFirst(variables.tablesArray[variables.item][1],".")#" target="_blank">#ucase(variables.tablesArray[variables.item][1])# ( #variables.tablesArray[variables.item][2]# )</a>															
														<cfelse>
															<a href="/dbview/table.cfm?dsn=#form.ds#&table=#variables.tablesArray[variables.item][1]#" target="_blank">#ucase(variables.tablesArray[variables.item][1])# ( #variables.tablesArray[variables.item][2]# )</a>
														</cfif>
													</td>
												</tr>
											</cfloop>
										</table>
									</td>
								</tr>
								--->
								<!---
								<tr>
									<td valign="top">
										Table Defs:
									</td>
									<td>
										<table>
											<cfloop collection="#variables.matches#" item="variables.item">
												<tr>
													<td>
														<a href="/dbView400/libraryView.cfm?dsn=#form.ds#&lib=#variables.matches[variables.item][1]#" target="_blank">#ucase(variables.matches[variables.item][1])#</a> /
													</td>
													<td>
														<a href="/dbView400/tableView.cfm?dsn=#form.ds#&lib=#variables.matches[variables.item][1]#&tbl=#variables.matches[variables.item][2]#" target="_blank">#ucase(variables.matches[variables.item][2])#</a>
													</td>
													<td>
														<a href="/dbView400/dataView.cfm?dsn=#form.ds#&lib=#variables.matches[variables.item][1]#&tbl=#variables.matches[variables.item][2]#" target="_blank">[DATA VIEW]</a>
													</td>
													<td>
														<a href="/dbView400/sqlView.cfm?type=select&dsn=#form.ds#&lib=#variables.matches[variables.item][1]#&tbl=#variables.matches[variables.item][2]#" target="_blank">[SELECT]</a>
													</td>
													<td>
														<a href="/dbView400/sqlView.cfm?type=insert&dsn=#form.ds#&lib=#variables.matches[variables.item][1]#&tbl=#variables.matches[variables.item][2]#" target="_blank">[INSERT]</a>
													</td>
													<td>
														<a href="/dbView400/sqlView.cfm?type=update&dsn=#form.ds#&lib=#variables.matches[variables.item][1]#&tbl=#variables.matches[variables.item][2]#" target="_blank">[UPDATE]</a>
													</td>
												</tr>
											</cfloop>
										</table>
									</td>
								</tr>
								--->
							</cfif>
						</table>
					</cfoutput>
				</td>
			</tr>


<!---
================================================
this is the importaint part.  This is where we
display the data returned by the query.  We dont
want to just show a dump, so lets firgure out
how we can display the recordset dynamically...
================================================
 --->

			<!--- Check to make sure the recordset exists... --->
			<cfif structKeyExists(variables,"q")>

				<!--- store the recordset in the session scope, for the export options... --->
				<cfset session.lastRecordset = variables.q />

				<!--- store it in the resultsHandler, for the popup option --->
				<cfset variables.currentResultID = createUUID() />
				<cfset session.resultsHandler.addRecordset(variables.currentResultID,variables.q) />

				<cfif form.resultsPopup>
					<cfoutput>
						<tr>
							<td>
								<em>Your results opened in a popup window.  If you have popups disabled, either change the value in the form at the top, or enable them for this site and then re-run your query. <a href="javascript:oResults('#variables.currentResultID#','#getTickCount()#');">Open Results Again</a></em>
							</td>
						</tr>
						<script type="text/javascript">
							onload = oResults('#variables.currentResultID#','#getTickCount()#');
						</script>
					</cfoutput>
				<cfelse>

					<!--- give them export options... --->
					<tr>
						<td style="padding:2px;">
							<cfoutput>
								Export:
								<a href="resultscsv.cfm?id=#variables.currentResultID#"><img src="inc/img/csv.gif" border="0" alt="Save Results as CSV File" /></a><!--- // csv file --->
								<a href="resultstab.cfm?id=#variables.currentResultID#"><img src="inc/img/tab.gif" border="0" alt="Save Results as TAB File" /></a><!--- // tab delimited file --->
								<a href="resultsxml.cfm?id=#variables.currentResultID#"><img src="inc/img/xml.gif" border="0" alt="Save Results as XML File" /></a><!--- // xml file --->
								<a href="resultsWDDX.cfm?id=#variables.currentResultID#">WDDX</a><!--- // wddx file --->
								<a href="viewArrayCollection.cfm?id=#variables.currentResultID#" target="_blank">ArrayCollection</a><!--- // array collection file --->
								<a href="resultsJSON.cfm?id=#variables.currentResultID#">JSON</a><!--- // json file --->
								<a href="resultsJS.cfm?id=#variables.currentResultID#">JS</a><!--- // JS Variables file --->
								<a href="resultsHTMLtable.cfm?id=#variables.currentResultID#" target="_blank">HTML Table</a><!--- // HTML Table--->
								|
								<!---<a href="resultsSQL_1.cfm?id=#variables.currentResultID#&dsn=#form.ds#" target="_blank">SQL</a> // SQL file --->
							</cfoutput>
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

								<!--- if the total number of cells is less than or equal to the maxsorttable value, then put in the class on the table to make the js work... --->
								<table align="left" style="background-color:##fff;" <cfif variables.numCells LTE application.settings.maxsortable AND variables.q.recordCount GT 1>class="sortable"</cfif> id="queryResults">
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
												#NumberFormat(variables.k,repeatString("0",len(variables.q.recordcount)))#
											</th>

											<!--- for each record, loop over the columns and dynamically get the value out... --->
											<cfloop from="1" to="#arrayLen(variables.arResultsHeaders)#" index="variables.j">
												<td class="noPadd">
													<!--- The actual value --->

													<!--- if the value is blank, put in a nonbreaking space for IE to play nice... --->
													<cfif trim(variables.q[variables.arResultsHeaders[variables.j]][variables.k]) EQ "">
														&nbsp;

													<!--- put an htmleditformat around the value to make sure that html entities in the db is displayed correctly...  --->
													<cfelse>
														<code class="noPadd">#trim(htmlEditFormat(variables.q[variables.arResultsHeaders[variables.j]][variables.k]))#</code>
													</cfif>
												</td>
											</cfloop>
										</tr>

										<!--- this flush allows browsers such as firefox (http://www.getfirefox.com) to get results as quickly as possible,
												but IE just ignores it.  You can safely take out the cfflush if you start having viewing problems... --->
										<cfflush interval="500" />
									</cfloop>

								</table>
							</cfoutput>
						</td>
					</tr>
				<!--- close the resultsPopup Check --->
				</cfif>

			<!--- close the recordset exists check --->
			</cfif>

		<!--- close the form post check... --->
		</cfif>

	<!--- close the error check --->
	</cfif>
</table>

</body>
</html>
</cfprocessingdirective>
