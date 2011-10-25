
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>qBrowser Help</title>
	<link rel="stylesheet" media="screen" href="inc/css/main.css" />
	
	<script type="text/javascript">
		function clswin() {
			window.close();
		}
	</script>
	
</head>

<body>

<h2 class="fixed">qbrowser Help</h2>
<input type="button" onClick="javascript:clswin();" value="Close This Window" />
<br />
<strong>Sections:</strong>
<ul style="list-style-type:none;">
	<li><a href="#general">General</a></li>
	<li><a href="#maxrows">Maxrows</a></li>
	<li><a href="#timeout">Timeout</a></li>
	<li><a href="#troubleshooting">Troubleshooting</a></li>
</ul>
<fieldset class="error">	
	
		<center><h3>NOTICE</h3></center>
		<p>This help file is not complete at all.  Its mostly just acting as a placeholder for now until I can find the time to finish it.  Get what you can out of it, and if you still have questions, email me: <a href="mailto:ryanguill@gmail.com" style="color:#ccc;">ryanguill@gmail.com</a></p>
</fieldset>
						
<a name="general"><h3 class="fixed">General</h3></a>
<dl>
	<dt>What is this?</dt>
	<dd>"This" is qBrowser, a small application to help you test out and use your coldfusion sql datasources.</dd>
	
	<dt>Yeah, but how do you use it?</dt>
	<dd>Choose your datasource, type in your sql and click the execute button or hit alt+e.  Its that easy.</dd>
	
	<dt>But what about all that other stuff?</dt>
	<dd>The other stuff is just a few more options.  See the sections below for more information.</dd>
	
	<dt>Should I worry about who has access to this?</dt>
	<dd>Uhh, yeah. This basically gives access to all of your cf databases.  Even if you have all the different sql statements restricted, you still have select, which means people can still at least get in and look at your data.  Guard it with your life, and please, only use it on developement!</dd>
</dl>

<a name="maxrows"><h3 class="fixed">Maxrows</h3></a>
<dl>
	<dt>What is maxrows for?</dt>
	<dd>Maxrows is a value to bring back only a certain amount of records.  Setting this value to 0 is basically like turning it off.  Any non-zero number will be applied.  If you set it to 500 for instance, and your query brings back 514 records, only the first 500 will be brought back.  It is similar to selecting TOP num records.  If you know a query is going to be bringing back thousands (or more) records, use the maxrows to keep yourself from having to wait forever.  It also works with your ORDER BY, so if you want to see the other side of your results with the maxrows, just ORDER BY the other way. By the way, you can only set this as a value between 0 (ignored) and 1000 records.</dd>
</dl>

<a name="timeout"><h3 class="fixed">Timeout</h3></a>
<dl>
	<dt>What about timeout?</dt>
	<dd>Just ignore this for now... leave it at 30 seconds, takes between 1 and 120 seconds.</dd>
</dl>

<a name="troubleshooting"><h3 class="fixed">Troubleshooting</h3></a>
<dl>
	<dt>Why does it take so gosh darn long to load up the first time I open it?</dt>
	<dd>When you first open the utility, it will go out and discover all of your valid datasources to provide them to you, so you dont have to type them in or look them up.  Because I want this app to be backwards compatable with cf 6.1, I am using an older way of doing this, that takes a little bit of time.  I may later go in and figure out which version of cf you are using, and if you are using cf 7, use the new way so to save some time.  But don't worry, its only the first time you load up after it has not been used in a while that takes so long.  Also, thats what that little link that says refresh does.  It will reload all of those datasources.  So don't click it unless you have made a change!</dd>
	
	<dt>Why does it take so long to run some of my queries?</dt>
	<dd>Your sql proficiency aside, some queries just take a long time to run, and some queries take a long time to come back because the amount of data you are returning.  It takes considerably more time to write the results to the page in your browser than it does for cf to actually run the query.  If you are getting some slow times, and you are just wanting to see how long some queries are taking, set your maxrows smaller, or even to 1.  But the execution time that is reported is how long the query actually took to make the round trip to the database.</dd>
</dl>

</body>
</html>
