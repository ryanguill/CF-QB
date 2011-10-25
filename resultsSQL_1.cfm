<!--- Make sure an ID was passed to this page... --->
<cfif NOT structKeyExists(url,"id")>
	<!--- wouldnt hurt to at a later date add in a function isUUID() to validate the id passed... --->
	Sorry, your query did not have any records.  Return to the qbrowser page and run another query.
	<cfabort />	
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta http-equiv="Pragma" content="no-cache">
		<meta http-equiv="CACHE-CONTROL" content="NO-CACHE">
		<meta http-equiv="EXPIRES" content="0">
		<meta name="ROBOTS" content="NONE">
		<meta name="GOOGLEBOT" content="NOARCHIVE">
		
		<title>Save Query Results as File</title>
	</head>
	<body>
		<cfoutput>
			<form action="resultsSQL_2.cfm" method="get">
				<table width="100%">
					<tr>
						<th>
							Datasource
						</th>
						<td>
							<input type="text" name="dsn" value="#url.dsn#" />
						</td>
					</tr>
					<tr>
						<th>
							Library
						</th>
						<td>
							<input type="text" name="library" maxlength="10" value="" />
						</td>
					</tr>
					<tr>
						<th>
							filename
						</th>
						<td>
							<input type="text" name="filename" maxlength="10" value="" />
						</td>
					</tr>
					<tr>
						<th>
							<input type="hidden" name="action" value="resultsSQL" />
							<input type="hidden" name="id" value="#url.id#" />
						</th>
						<td>
							<input type="submit" value="Save" accesskey="e" />
						</td>
					</tr>
				</table>
			</form>
		</cfoutput>
	</body>
</html>