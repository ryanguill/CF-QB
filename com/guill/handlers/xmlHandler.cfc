<cfcomponent>
	<!---
		Microscopic XML Handler
		Jared Rypka-Hauer
		March, 2005
	--->

	<!-------------------------------------------->

	<cffunction name="init" access="public" returntype="xmlHandler" output="false">
		<cfargument name="xmlPath" type="string" required="true" />
		
		<cfset setXMLPath(arguments.xmlPath) />
		
		<cfset setFileHandler(loadFileHandler(getXMLPath()))>
		<cfset setXML(loadXML())>

		<cfreturn this />
	</cffunction>

	<!-------------------------------------------->
	
	<cffunction name="setxmlPath" access="private" returntype="boolean" output="False">
		<cfargument name="xmlPath" type="string" required="true" />
		
		<cfset variables["xmlPath"] = arguments["xmlPath"] />
	<cfreturn True />
	</cffunction>
	
	<cffunction name="getXmlPath" access="private" returntype="string" output="false">
	
	<cfreturn variables["xmlPath"] />
	</cffunction>
	
	<cffunction name="setXML" access="private" returntype="void" output="false">
		<cfargument name="xmlFile" type="any" required="true" />
		<cfset variables["xmlData"] = arguments["xmlFile"]>
	</cffunction>

	<!-------------------------------------------->

	<cffunction name="getXML" access="public" returntype="any" output="false">
		
		<cfset setFileHandler(loadFileHandler(getXMLPath()))>
		<cfset setXML(loadXML())>
		
		<cfreturn variables["xmlData"] />
	</cffunction>

	<!-------------------------------------------->

	<cffunction name="loadXML" access="private" returntype="any" output="false">
		<cfreturn xmlParse(getFileHandler().getFileData())>
	</cffunction>
	
	<!-------------------------------------------->
	
	<cffunction name="writeXML" access="public" returntype="boolean" output="False">
		<cfargument name="xmlOut" type="string" required="True" />
		
	<cfreturn getFileHandler().write(arguments.xmlOut,"overwrite") />
	</cffunction>

	<!-------------------------------------------->

	<cffunction name="setFileHandler" access="private" returntype="void" output="false">
		<cfargument name="fileHandler" type="any" required="true" />
		<cfset variables["fileHandler"] = arguments["fileHandler"]>
	</cffunction>

	<!-------------------------------------------->

	<cffunction name="getFileHandler" access="public" returntype="any" output="false">
		<cfreturn variables["fileHandler"] />
	</cffunction>

	<!-------------------------------------------->

	<cffunction name="loadFileHandler" access="private" returntype="any" output="false">
		<cfargument name="xmlPath" type="string" required="true" />
		<cfreturn createObject("component","fileHandler").init(arguments.xmlPath) />
	</cffunction>


	<!-------------------------------------------->

	<cffunction name="searchXML" access="public" returntype="array" output="false">
		<cfargument name="searchText" type="string" required="true" />
		<cfreturn xmlSearch(getXML(),arguments["searchText"]) />
	</cffunction>

	<!-------------------------------------------->

	<cffunction name="dump" access="public" returntype="any" output="false">
		<cfset var dumpData = "">
		<cfsavecontent variable="dumpData"><cfdump var="#variables#" /></cfsavecontent>
		<cfreturn dumpData />
	</cffunction>

</cfcomponent>