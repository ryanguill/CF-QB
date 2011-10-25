<cfcomponent>
	<!---
		Microscopic File Handler
		Jared Rypka-Hauer
		March, 2005
	--->

	<cffunction name="init" returntype="fileHandler" access="public" output="false">
		<cfargument name="filePath" type="string" required="true" hint="full path and file name" />
		<cfset var initFileData = "">

		<cfset setFilePath(arguments.filePath)>
		<cfset read(getFilePath())>

		<cfreturn this />
	</cffunction>

	<!-------------------------------------------->

	<cffunction name="setFilePath" returntype="string" access="private" output="false">
		<cfargument name="filePath" type="string" required="true" hint="full path and file name" />
		<cfset variables.filePath = arguments.filePath>
	</cffunction>

	<!-------------------------------------------->

	<cffunction name="getFilePath" returntype="string" access="private" output="false">
		<cfreturn variables.filePath />
	</cffunction>

	<!-------------------------------------------->

	<cffunction name="setFileData"  returntype="string" access="private" output="false">
		<cfargument name="fileContents" type="string" required="true" />
		<cfset variables.fileData = arguments.fileContents>
	</cffunction>

	<!-------------------------------------------->

	<cffunction name="getFileData" returntype="string" access="public" output="false">
		
		<cfset read(getFilePath())>
		
		<cfreturn variables.fileData />
	</cffunction>

	<!-------------------------------------------->

	<cffunction name="read" returntype="string" access="private" output="false">
		<cfargument name="filePath" type="string" required="true" />
		<cfset var fileContent = "">
		
		<cflock name="qBrowserWrite" type="exclusive" timeout="30">
			<cffile action="READ" file="#arguments.filePath#" variable="fileContent">
		</cflock>
		
		<cfset setFileData(fileContent) />
	</cffunction>
	
	<cffunction name="write" returntype="boolean" access="public" output="false">
		<cfargument name="output" type="string" required="True" />
		<cfargument name="nameConflict" type="string" required="false" default="error" />
		
		<cfswitch expression="#arguments.nameConflict#">
			<cfcase value="makeUnique" />
			<cfcase value="overwrite" />
			<cfcase value="skip" />
			<cfcase value="error" />
			<cfdefaultcase>
				<cfthrow message="invalid nameconfict argument: #arguments.nameConfict#" />
			</cfdefaultcase>
		</cfswitch>
		
		<cftry>
			<cflock name="qBrowserWrite" type="exclusive" timeout="30">
				<cffile action="write" file="#getFilePath()#" output="#arguments.output#" nameconflict="#arguments.nameConflict#" />
			</cflock>
		<cfcatch>
			<cfrethrow />
		</cfcatch>
		</cftry>
	
	<cfreturn True />
	</cffunction>
	<!-------------------------------------------->

	<cffunction name="dump" access="public" returntype="any" output="false">
		<cfset var dumpData = "">
		<cfsavecontent variable="dumpData"><cfdump var="#variables#" /></cfsavecontent>
		<cfreturn dumpData />
	</cffunction>
</cfcomponent>