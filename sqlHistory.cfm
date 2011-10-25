<cfsilent>
	<cfparam name="url.user" default="all" />
	<cfset variables.sqlText = application.histHandler.getSQLForUser(lcase(session.username)) />	
</cfsilent>

<cfinclude template="inc/genFunctions.cfm" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>History</title>
	<link rel="stylesheet" media="screen" href="inc/css/main.css" />
	<script type="text/javascript">
		function choosesql(){
			var len = document.historyform.histselect.length;
			
			if (typeof(len) == "undefined") {
				if (document.historyform.histselect.checked) {
					eval("self.opener.document.qBrowserForm.sqlQuery.value=document.historyform.histselect.value");
					window.close();
				}
			}
			for(var i = 0;i < len; i++){
				
				if (document.historyform.histselect[i].checked) {
					eval("self.opener.document.qBrowserForm.sqlQuery.value=document.historyform.histselect[i].value");
					window.close();
				}
			}
		}
	</script>
	
</head>

<body>
	<a href="clearHistory.cfm">Clear History</a>
	<form name="historyform" onsubmit="choosesql()" action="#">
		<cfoutput>	
			<table width="495" border="0" cellpadding="0" cellspacing="0">
				<cfset variables.j = 0 />
				<cfloop from="#arrayLen(variables.sqlText)#" to="1" index="variables.i" step="-1">
					<cfset variables.tempSQL = replaceNoCase(variables.sqlText[variables.i],"<","&lt;","all") />
					<cfset variables.tempSQL = replaceNoCase(variables.tempSQL,">","&gt;","all") />
					<cfset variables.tempSQL = replaceNoCase(variables.tempSQL,"""","&quot;","all") />
					
					<tr>
						<td width="10">
							<input type="radio" name="histselect" value="#variables.tempSQL#" id="histSelect#variables.j#" onclick="choosesql()" />
						</td>
						<td width="200">
							<pre width="700"><label for="histSelect#variables.j#">#makeSQLPretty(Trim(variables.tempSQL))#<label></pre>
						</td>
					</tr>
					<cfset variables.j = variables.j + 1 />
				</cfloop>
			</table>
		</cfoutput>
	</form>
</body>
</html>
