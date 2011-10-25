<!--- 
===========================================================
Title: 			
FileName: 		
Version:		
Author:			
CreatedOn:		
LastModified:	

Purpose:

Dependancies:

Assumptions:

Outline:


ChangeLog:

===========================================================
 --->

<cfcomponent output="false">
	<cfsilent>
		
		<!--- Constructor Methods --->
		<cffunction name="init" access="public" returntype="any" output="false">
			<cfset createProperties() />
		<cfreturn This />
		</cffunction>
		
		<!--- Public Methods --->
		
		<cffunction name="isUpdateAvailable" access="public" returntype="struct" output="false">
			<cfargument name="curVersionMajor" type="numeric" required="True" />
			<cfargument name="curVersionMinor" type="numeric" required="True" />
			<cfargument name="curVersionRevision" type="numeric" required="True" />
			
			<cfset VAR curVersionXML = "" />
			<cfset VAR curVersionInfo = structNew() />
			<cfset VAR output = structNew() />
			<cfset VAR check = structNew() />
			
			<cftry>
				<cfhttp url="http://www.ryanguill.com/download/qbrowser/qBrowser_curVersion.xml" method="get" throwonerror="true" />
			<cfcatch type="any">
				<cfset output.result = "Error" />
				<cfreturn output />
			</cfcatch>
			</cftry>
			
			<cfset curVersionXML = xmlParse(cfhttp.filecontent) />
			<cfset curVersionInfo.major = curVersionXMl.root.currentVersion.major.XMLText />
			<cfset curVersionInfo.minor = curVersionXMl.root.currentVersion.minor.XMLText />
			<cfset curVersionInfo.revision = curVersionXMl.root.currentVersion.revision.XMLText />
			<cfset curVersionInfo.string = curVersionInfo.major & "." & curVersionInfo.minor & "." & curVersionInfo.revision />
			
			<cfif curVersionMajor LT curVersionInfo.major>
				<cfset output.result = True />
				<cfset output.newestVersion = curVersionInfo.string />
				<cfset check.major = false />
			<cfelse>
				<cfset output.result = False />
				<cfset output.newestVersion = curVersionInfo.string />
				<cfset check.major = true />
			</cfif>
			
			<cfif check.major>
				<cfif curVersionMinor LT curVersionInfo.minor>
					<cfset output.result = True />
					<cfset output.newestVersion = curVersionInfo.string />
					<cfset check.minor = false />
				<cfelse>
					<cfset output.result = False />
					<cfset output.newestVersion = curVersionInfo.string />
					<cfset check.minor = true />
				</cfif>
			</cfif>
			
			<cfif check.major>
				<cfif check.minor>
					<cfif curVersionRevision LT curVersionInfo.revision>
						<cfset output.result = True />
						<cfset output.newestVersion = curVersionInfo.string />
						<cfset check.revision = false />
					<cfelse>
						<cfset output.result = False />
						<cfset output.newestVersion = curVersionInfo.string />
						<cfset check.revision = true />
					</cfif>
				</cfif>
			</cfif>
			
			<cfset output.check = check />
			
		<cfreturn output />
		</cffunction>
		
		
		<!--- Package Methods --->
		
		<!--- Private Methods --->
		
		
		<cffunction name="createProperties" access="private" returntype="boolean" output="False">
			<cfset variables.properties = structNew() />
		<cfreturn True />
		</cffunction>
		
	</cfsilent>
</cfcomponent>