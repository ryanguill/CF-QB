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
			<cfargument name="xmlPath" type="String" required="True" />
			
			<cfset createProperties() />
			<cfset setXMLPath(arguments.xmlPath) />
			<cfset setXMLHandler(loadXMLHandler()) />
		<cfreturn This />
		</cffunction>
		
		<!--- Public Methods --->
		<cffunction name="getXML" access="public" returntype="any" output="False">
			
			<cfset setXMLHandler(loadXMLHandler()) />
			
		<cfreturn getXMLHandler().getXML() />
		</cffunction>
		
		<cffunction name="getSQLForUser" access="public" returntype="array" output="False">
			<cfargument name="user" required="true" type="string" />
			
			<cfset VAR out = arrayNew(1) />
			<cfset VAR usersql = arrayNew(1) />
			<cfset VAR i = 0 />
			
			<cfset setXMLHandler(loadXMLHandler()) />
			
			<cfset usersql = getXMLHandler().searchXML("//sql[@user='#lCase(arguments.user)#']") />
			
			<cfloop from="1" to="#arrayLen(usersql)#" index="i">
				<cfset out[(arrayLen(out)+1)] = usersql[i].XMLText />
			</cfloop>
			
		<cfreturn out />
		</cffunction>
		
		<cffunction name="addSQLForUser" access="public" returntype="boolean" output="false">
			<cfargument name="user" type="String" required="True" />
			<cfargument name="sqlText" type="string" required="True" />
			
			<cfset VAR currentXML = "" />
			<cfset VAR nextI = 0 />
			
			
			<cflock name="qBrowserAddSQLForUser" type="exclusive" timeout="30">
				<cfset currentXML = getXML() />
				<cfset nextI = (arrayLen(currentXML.history.XMLChildren) + 1) />
				
				<cfset currentXML.history.XMLChildren[nextI] = XMLElemNew(currentXML, "sql") />
				<cfset currentXML.history.XMLChildren[nextI].XMLCdata = arguments.sqlText />
				<cfset currentXML.history.XMLChildren[nextI].XMLAttributes["user"] = arguments.user />
				
				<cfset getXMLHandler().writeXML(toString(currentXML)) />
			</cflock>
		
		<cfreturn True />
		</cffunction>
		
		<cffunction name="clearSQLForUser" access="public" returntype="boolean" output="true">
			<cfargument name="user" type="String" required="True" />
			
			<cfset VAR currentXML = "" />
			<cfset VAR i = 0 />
			<cfset VAR newLen = 0 />
			<cfset VAR elemRemoved = 0 />
			
			<cflock name="qBrowserAddSQLForUser" type="exclusive" timeout="30">
				<cfset currentXML = getXML() />
								
				<cfloop to="1" from="#arraylen(currentXML.history.XMLChildren)#" index="i" step="-1">
					<cfif currentXML.history.XMLChildren[i].XMLAttributes["user"] EQ arguments.user>												
						<cfset arrayDeleteAt(currentXML.history.XMLChildren, (i)) />						
					</cfif>
				</cfloop>
				
				<cfset getXMLHandler().writeXML(toString(currentXML)) />
			</cflock>
		<cfreturn True />
		</cffunction>
		
		<!--- Package Methods --->
		
		<!--- Private Methods --->
		<cffunction name="createProperties" access="private" returntype="boolean" output="False">
			<cfset variables.properties = structNew() />
		<cfreturn True />
		</cffunction>
		
		<cffunction name="setXMLPath" access="private" returntype="boolean" output="false">
			<cfargument name="xmlpath" type="String" required="True" />
			
			<cfset variables.properties["xmlPath"] = arguments.xmlPath />
		<cfreturn True />
		</cffunction>
		
		<cffunction name="getXMLPath" access="private" returntype="string" required="true">
		
		<cfreturn variables.properties["xmlPath"] />
		</cffunction>
		
		
		<cffunction name="loadXMLHandler" access="private" returntype="any" output="false">
			
		<cfreturn createObject("component","xmlHandler").init(getXMLPath()) />
		</cffunction>
		
		<cffunction name="setXMLHandler" access="private" returntype="boolean" output="false">
			<cfargument name="xmlHandler" type="any" required="True" />
			
			<cfset variables.properties["xmlHandler"] = arguments.xmlHandler />
		<cfreturn True />
		</cffunction>
		
		<cffunction name="getXMLHandler" access="private" returntype="any" output="False">
		
		<cfreturn variables.properties["xmlHandler"] />
		</cffunction>
	</cfsilent>
</cfcomponent>